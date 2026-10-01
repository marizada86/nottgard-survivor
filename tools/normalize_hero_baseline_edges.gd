extends SceneTree
## Alinha a linha de base de cada tira de herói à do idle e afasta o conteúdo das bordas da célula.
## Uma única escala por tira (só reduz, nunca amplia) e um único deslocamento vertical por tira,
## para preservar o movimento interno. Não normaliza a altura entre tiras.
## Uso: godot --headless --path . -s res://tools/normalize_hero_baseline_edges.gd -- [--write] [heroi ...]

const CELL := Vector2i(256, 384)
const DIRECTIONS := ["n", "ne", "e", "se", "s"]
const ALPHA_THRESHOLD := 0.10
const EDGE_MARGIN := 3
const MAX_BASELINE := 376

func _initialize() -> void:
	var write := false
	var only: Array[String] = []
	for arg in OS.get_cmdline_user_args():
		if arg == "--write":
			write = true
		else:
			only.append(arg)
	var directory := DirAccess.open("res://assets/animations/heroes")
	if directory == null:
		push_error("Não foi possível abrir a pasta de animações de heróis")
		quit(1)
		return
	print("hero,sequence,baseline_before,baseline_after,scale,edge_before,edge_after,changed")
	for hero_id in directory.get_directories():
		if not only.is_empty() and hero_id not in only:
			continue
		var root := "res://assets/animations/heroes/%s" % hero_id
		var idle := _load("%s/idle.png" % root)
		if idle == null:
			continue
		var target := mini(_median(_bottoms(idle)), MAX_BASELINE)
		for sequence in ["idle"] + DIRECTIONS.map(func(direction: String) -> String: return "move_%s" % direction):
			var path := "%s/%s.png" % [root, sequence]
			var image := _load(path)
			if image == null:
				continue
			var result := _normalize(image, target)
			print("%s,%s,%d,%d,%.3f,%d,%d,%s" % [hero_id, sequence, result.before, result.after, result.scale, result.edge_before, result.edge_after, result.changed])
			if write and result.changed:
				if result.image.save_png(ProjectSettings.globalize_path(path)) != OK:
					push_error("falha ao gravar %s" % path)
					quit(1)
					return
	quit()

func _load(path: String) -> Image:
	if not FileAccess.file_exists(path):
		return null
	var image := Image.new()
	if image.load(ProjectSettings.globalize_path(path)) != OK:
		return null
	image.convert(Image.FORMAT_RGBA8)
	return image

func _normalize(image: Image, target: int) -> Dictionary:
	var frames := image.get_width() / CELL.x
	var bounds: Array[Rect2i] = []
	for frame in frames:
		bounds.append(_bounds(image, frame))
	var bottoms: Array[int] = []
	var min_left := CELL.x
	var min_top := CELL.y
	var max_right := 0
	var max_bottom := 0
	for rect in bounds:
		if rect.size == Vector2i.ZERO:
			continue
		bottoms.append(rect.end.y)
		min_left = mini(min_left, rect.position.x)
		min_top = mini(min_top, rect.position.y)
		max_right = maxi(max_right, rect.end.x)
		max_bottom = maxi(max_bottom, rect.end.y)
	var before := _median(bottoms)
	var edge_before := _edge_count(bounds)
	var scale := minf(1.0, minf(float(CELL.x - 2 * EDGE_MARGIN) / maxf(max_right - min_left, 1), float(CELL.y - 2 * EDGE_MARGIN) / maxf(max_bottom - min_top, 1)))
	# Deslocamento: pivô central/base-alvo, limitado para todos os quadros ficarem na margem.
	var offset_x := clampi(roundi(CELL.x * (1.0 - scale) * 0.5), ceili(EDGE_MARGIN - min_left * scale), floori(CELL.x - EDGE_MARGIN - max_right * scale))
	var offset_y := clampi(roundi(target - before * scale), ceili(EDGE_MARGIN - min_top * scale), floori(CELL.y - EDGE_MARGIN - max_bottom * scale))
	var predicted_bottom := roundi(before * scale) + offset_y
	# Só altera o que foge do alvo (> 2 px de base) ou toca a borda.
	if absi(before - predicted_bottom) <= 2 and edge_before == 0:
		return {"image": image, "before": before, "after": before, "scale": 1.0, "edge_before": 0, "edge_after": 0, "changed": false}
	var out := Image.create(image.get_width(), image.get_height(), false, Image.FORMAT_RGBA8)
	out.fill(Color(0, 0, 0, 0))
	var after_bounds: Array[Rect2i] = []
	for frame in frames:
		var cell := image.get_region(Rect2i(frame * CELL.x, 0, CELL.x, CELL.y))
		var size := Vector2i(roundi(CELL.x * scale), roundi(CELL.y * scale))
		if scale < 1.0:
			cell.resize(size.x, size.y, Image.INTERPOLATE_LANCZOS)
		var dest := Vector2i(offset_x, offset_y)
		out.blit_rect(cell, Rect2i(Vector2i.ZERO, size), Vector2i(frame * CELL.x, 0) + dest)
		after_bounds.append(Rect2i())
	for frame in frames:
		after_bounds[frame] = _bounds(out, frame)
	return {"image": out, "before": before, "after": _median(_bottoms_of(after_bounds)), "scale": scale, "edge_before": edge_before, "edge_after": _edge_count(after_bounds), "changed": true}

func _bottoms(image: Image) -> Array[int]:
	var values: Array[int] = []
	for frame in image.get_width() / CELL.x:
		var rect := _bounds(image, frame)
		if rect.size != Vector2i.ZERO:
			values.append(rect.end.y)
	return values

func _bottoms_of(rects: Array[Rect2i]) -> Array[int]:
	var values: Array[int] = []
	for rect in rects:
		if rect.size != Vector2i.ZERO:
			values.append(rect.end.y)
	return values

func _edge_count(rects: Array[Rect2i]) -> int:
	var count := 0
	for rect in rects:
		if rect.size == Vector2i.ZERO:
			continue
		if rect.position.x <= 1 or rect.position.y <= 1 or rect.end.x >= CELL.x - 1 or rect.end.y >= CELL.y - 1:
			count += 1
	return count

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

func _median(values: Array[int]) -> int:
	if values.is_empty():
		return 0
	var sorted := values.duplicate()
	sorted.sort()
	return sorted[sorted.size() / 2]
