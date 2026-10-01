extends SceneTree
## Normaliza a escala aparente das tiras de animação dos heróis (BUG-021).
## Cada herói usa a altura e a linha de base medianas do `idle` como referência;
## as demais tiras são reescalonadas por um fator único (todos os quadros juntos),
## sem sair da célula 256×384.
##
## godot --headless --path . -s tools/normalize_hero_scale.gd -- [--apply] [--hero=id] [--only=move,attack,...]
## Sem --apply só imprime o plano (relatório).

const CELL := Vector2i(256, 384)
const ALPHA_THRESHOLD := 0.10
const MAX_WIDTH := 246
const MAX_HEIGHT := 376
const MIN_BOTTOM_MARGIN := 3
const EDGE_MARGIN := 3
const MIN_CHANGE := 0.03
var max_residual := 1.18
const FRAMES := {"idle": 4, "move": 6, "attack": 4, "active": 6, "death": 6}
const MOVE_DIRECTIONS := ["n", "ne", "e", "se", "s"]

func _initialize() -> void:
	var apply := false
	var only_hero := ""
	var groups: Array = ["move"]
	var fixed_factor := 0.0
	for arg in OS.get_cmdline_user_args():
		if arg == "--apply":
			apply = true
		elif arg.begins_with("--hero="):
			only_hero = arg.substr(7)
		elif arg.begins_with("--factor="):
			fixed_factor = float(arg.substr(9))
		elif arg.begins_with("--residual="):
			max_residual = float(arg.substr(11))
		elif arg.begins_with("--only="):
			groups = arg.substr(7).split(",")
	var directory := DirAccess.open("res://assets/animations/heroes")
	if directory == null:
		printerr("pasta de animações de heróis não encontrada")
		quit(1)
		return
	print("hero,seq,ref_h,h_atual,fator,aplicado,largura_nova,altura_nova,motivo")
	for hero_id in directory.get_directories():
		if only_hero != "" and hero_id != only_hero:
			continue
		if fixed_factor > 0.0:
			_apply_fixed(hero_id, groups, fixed_factor, apply)
		else:
			_process_hero(hero_id, groups, apply)
	quit()

func _sequences(groups: Array) -> Array:
	var result: Array = []
	for group in groups:
		if group == "move":
			for direction in MOVE_DIRECTIONS:
				result.append("move_%s" % direction)
		elif FRAMES.has(group):
			result.append(group)
	return result

func _process_hero(hero_id: String, groups: Array, apply: bool) -> void:
	var root := ProjectSettings.globalize_path("res://assets/animations/heroes/%s" % hero_id)
	var idle := _load("%s/idle.png" % root, FRAMES.idle)
	if idle.is_empty():
		print("%s,idle,,,,ausente" % hero_id)
		return
	var idle_height := _median(idle.heights)
	var ref_bottom := _median(idle.bottoms)
	# Referência: o idle, mas não acima do que o andar mais largo consegue ter dentro da célula
	# (tolerando até MAX_RESIDUAL de diferença nas tiras largas). Se a referência cair, o idle acompanha.
	var ref_height := idle_height
	if "move" in groups:
		var fit_height := idle_height
		for direction in MOVE_DIRECTIONS:
			var walk := _load("%s/move_%s.png" % [root, direction], FRAMES.move)
			if walk.is_empty():
				continue
			var walk_fit := float(_median(walk.heights)) * float(MAX_WIDTH) / float(maxi(1, _max(walk.widths)))
			fit_height = mini(fit_height, int(walk_fit))
		ref_height = mini(idle_height, int(float(fit_height) * max_residual))
		var idle_factor := float(ref_height) / float(idle_height)
		if absf(idle_factor - 1.0) >= MIN_CHANGE:
			var idle_applied := "nao"
			if apply:
				_write("%s/idle.png" % root, idle, idle_factor, ref_bottom, ref_bottom)
				idle_applied = "sim"
			print("%s,idle,%d,%d,%.3f,%s,,,referencia reduzida" % [hero_id, ref_height, idle_height, idle_factor, idle_applied])
	for sequence in _sequences(groups):
		var path := "%s/%s.png" % [root, sequence]
		if not FileAccess.file_exists(path):
			continue
		var frames_count: int = FRAMES.move if sequence.begins_with("move_") else FRAMES[sequence]
		var data := _load(path, frames_count)
		if data.is_empty():
			print("%s,%s,%d,,,nao,,,invalido" % [hero_id, sequence, ref_height])
			continue
		var height := _median(data.heights)
		var wanted := float(ref_height) / float(height)
		var limit_w := float(MAX_WIDTH) / float(maxi(1, _max(data.widths)))
		var limit_h := float(MAX_HEIGHT) / float(maxi(1, _max(data.heights)))
		var factor := minf(wanted, minf(limit_w, limit_h))
		var reason := "ok" if factor >= wanted - 0.001 else "limitado pela celula (queria %.3f)" % wanted
		var changed: bool = absf(factor - 1.0) >= MIN_CHANGE or absi(_median(data.bottoms) - ref_bottom) > 2 or int(data.edges) > 0
		var new_w := int(round(_median(data.widths) * factor))
		var new_h := int(round(height * factor))
		var applied := "nao"
		if changed and apply:
			_write(path, data, factor, ref_bottom, _median(data.bottoms))
			applied = "sim"
		elif not changed:
			reason = "ja proporcional"
		print("%s,%s,%d,%d,%.3f,%s,%d,%d,%s" % [hero_id, sequence, ref_height, height, factor, applied, new_w, new_h, reason])

func _load(path: String, frames_count: int) -> Dictionary:
	var image := Image.new()
	if image.load(path) != OK:
		return {}
	image.convert(Image.FORMAT_RGBA8)
	if image.get_size() != Vector2i(frames_count * CELL.x, CELL.y):
		return {}
	var result := {"image": image, "frames": frames_count, "rects": [], "heights": [], "widths": [], "bottoms": [], "edges": 0}
	for index in frames_count:
		var rect := _bounds(image, index)
		result.rects.append(rect)
		if rect.size != Vector2i.ZERO and (rect.position.x <= 1 or rect.position.y <= 1 or rect.end.x >= CELL.x - 1 or rect.end.y >= CELL.y - 1):
			result.edges += 1
		if rect.size == Vector2i.ZERO:
			continue
		result.heights.append(rect.size.y)
		result.widths.append(rect.size.x)
		result.bottoms.append(rect.end.y)
	if result.heights.is_empty():
		return {}
	return result

func _write(path: String, data: Dictionary, factor: float, target_bottom: int, strip_bottom: int) -> void:
	var source: Image = data.image
	# Mantém a ancoragem da mediana: a base do herói vai para a base mediana do idle.
	var output := Image.create(source.get_width(), source.get_height(), false, Image.FORMAT_RGBA8)
	for index in data.frames:
		var rect: Rect2i = data.rects[index]
		if rect.size == Vector2i.ZERO:
			continue
		var crop := source.get_region(Rect2i(rect.position + Vector2i(index * CELL.x, 0), rect.size))
		var new_size := Vector2i(maxi(1, int(round(rect.size.x * factor))), maxi(1, int(round(rect.size.y * factor))))
		crop.resize(new_size.x, new_size.y, Image.INTERPOLATE_LANCZOS)
		crop.fix_alpha_edges()
		# Centro horizontal do quadro preservado; base deslocada pela diferença das medianas.
		var center_x := rect.position.x + rect.size.x * 0.5
		var bottom_offset := float(rect.end.y - strip_bottom) * factor
		var dest_x := int(round(center_x - new_size.x * 0.5))
		var dest_bottom := int(round(target_bottom + bottom_offset))
		dest_bottom = mini(dest_bottom, CELL.y - MIN_BOTTOM_MARGIN)
		var dest_y := dest_bottom - new_size.y
		if dest_y < 0:
			dest_y = 0
		dest_x = clampi(dest_x, EDGE_MARGIN, CELL.x - new_size.x - EDGE_MARGIN)
		output.blend_rect(crop, Rect2i(Vector2i.ZERO, new_size), Vector2i(index * CELL.x + dest_x, dest_y))
	output.save_png(path)

func _bounds(image: Image, frame_index: int) -> Rect2i:
	var left := CELL.x
	var top := CELL.y
	var right := -1
	var bottom := -1
	for y in CELL.y:
		for x in CELL.x:
			if image.get_pixel(frame_index * CELL.x + x, y).a < ALPHA_THRESHOLD:
				continue
			left = mini(left, x)
			top = mini(top, y)
			right = maxi(right, x)
			bottom = maxi(bottom, y)
	if right < left or bottom < top:
		return Rect2i()
	return Rect2i(left, top, right - left + 1, bottom - top + 1)

func _median(values: Array) -> int:
	var sorted := values.duplicate()
	sorted.sort()
	return sorted[sorted.size() / 2]

func _max(values: Array) -> int:
	var best := 0
	for value in values:
		best = maxi(best, value)
	return best

## Modo --factor=F: aplica um fator fixo às tiras de ataque, habilidade e morte, mantendo a base de cada tira.
## Usado para acompanhar a redução do idle de um herói (mesma relação ataque/idle de antes). Ex.: --hero=sylas --factor=0.833 --apply
func _apply_fixed(hero_id: String, groups: Array, factor: float, apply: bool) -> void:
	var root := ProjectSettings.globalize_path("res://assets/animations/heroes/%s" % hero_id)
	for sequence in groups:
		if not (sequence in ["attack", "active", "death"]):
			continue
		var data := _load("%s/%s.png" % [root, sequence], FRAMES[sequence])
		if data.is_empty():
			print("%s,%s,invalido" % [hero_id, sequence])
			continue
		var bottom := _median(data.bottoms)
		var applied := "nao"
		if apply:
			_write("%s/%s.png" % [root, sequence], data, factor, bottom, bottom)
			applied = "sim"
		print("%s,%s,fator=%.4f,altura %d -> %d,aplicado=%s" % [hero_id, sequence, factor, _median(data.heights), int(round(_median(data.heights) * factor)), applied])
