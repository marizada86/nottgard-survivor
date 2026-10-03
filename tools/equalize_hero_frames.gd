extends SceneTree
## Iguala quadro a quadro as tiras de caminhada dos heróis (BUG-021/BUG-023).
## Referência: altura e base medianas do idle. Quadro com altura fora da tolerância é reescalado
## (fator único, ancorado no centro-base) e o pé volta à base do idle. Não mexe em tira com borda colada.
##
## godot --headless --path . -s tools/equalize_hero_frames.gd -- [--apply] [--hero=id] [--seq=move_se,...]
## Sem --apply só imprime o plano.

const CELL := Vector2i(256, 384)
const ALPHA_THRESHOLD := 0.10
const HEIGHT_TOLERANCE := 0.04
const BASE_TOLERANCE := 5
const MIN_FACTOR := 0.82
const MAX_FACTOR := 1.20
const MAX_WIDTH := 238
const SEQUENCES := ["move_n", "move_ne", "move_e", "move_se", "move_s"]

func _initialize() -> void:
	var apply := false
	var only_hero := ""
	var sequences: Array = SEQUENCES
	for arg in OS.get_cmdline_user_args():
		if arg == "--apply":
			apply = true
		elif arg.begins_with("--hero="):
			only_hero = arg.substr(7)
		elif arg.begins_with("--seq="):
			sequences = arg.substr(6).split(",")
	var directory := DirAccess.open("res://assets/animations/heroes")
	for hero in directory.get_directories():
		if only_hero != "" and hero != only_hero:
			continue
		var root := ProjectSettings.globalize_path("res://assets/animations/heroes/%s" % hero)
		var idle := Image.new()
		if idle.load("%s/idle.png" % root) != OK:
			continue
		idle.convert(Image.FORMAT_RGBA8)
		var heights: Array[int] = []
		var bottoms: Array[int] = []
		for frame in idle.get_width() / CELL.x:
			var box := _bounds(idle, frame)
			heights.append(box.size.y)
			bottoms.append(box.end.y)
		var target_height := _median(heights)
		var target_bottom := _median(bottoms)
		for sequence in sequences:
			var path := "%s/%s.png" % [root, sequence]
			var image := Image.new()
			if image.load(path) != OK:
				continue
			image.convert(Image.FORMAT_RGBA8)
			var output := Image.create(image.get_width(), image.get_height(), false, Image.FORMAT_RGBA8)
			var notes: Array[String] = []
			for frame in image.get_width() / CELL.x:
				var box := _bounds(image, frame)
				var cell := image.get_region(Rect2i(frame * CELL.x, 0, CELL.x, CELL.y))
				if box.size == Vector2i.ZERO:
					output.blit_rect(cell, Rect2i(0, 0, CELL.x, CELL.y), Vector2i(frame * CELL.x, 0))
					continue
				var factor := 1.0
				if absf(float(box.size.y) / target_height - 1.0) > HEIGHT_TOLERANCE:
					factor = clampf(float(target_height) / box.size.y, MIN_FACTOR, MAX_FACTOR)
					factor = minf(factor, float(MAX_WIDTH) / box.size.x)
				var shifted := _transform(cell, box, factor, target_bottom)
				if factor != 1.0 or absi(box.end.y - target_bottom) > BASE_TOLERANCE:
					notes.append("q%d f=%.2f base %d->%d" % [frame, factor, box.end.y, target_bottom])
					output.blit_rect(shifted, Rect2i(0, 0, CELL.x, CELL.y), Vector2i(frame * CELL.x, 0))
				else:
					output.blit_rect(cell, Rect2i(0, 0, CELL.x, CELL.y), Vector2i(frame * CELL.x, 0))
			if not notes.is_empty():
				print("%s/%s: %s" % [hero, sequence, "; ".join(notes)])
				if apply:
					output.save_png(path)
	quit()

## Reescala o conteúdo por `factor` em torno do centro-base e põe o pé em `target_bottom`.
func _transform(cell: Image, box: Rect2i, factor: float, target_bottom: int) -> Image:
	var content := cell.get_region(box)
	var new_size := Vector2i(maxi(1, roundi(box.size.x * factor)), maxi(1, roundi(box.size.y * factor)))
	if new_size != box.size:
		content.resize(new_size.x, new_size.y, Image.INTERPOLATE_LANCZOS)
	var center_x := box.position.x + box.size.x * 0.5
	var left := clampi(roundi(center_x - new_size.x * 0.5), 0, CELL.x - new_size.x)
	var top := clampi(target_bottom - new_size.y, 0, CELL.y - new_size.y)
	var result := Image.create(CELL.x, CELL.y, false, Image.FORMAT_RGBA8)
	result.blend_rect(content, Rect2i(Vector2i.ZERO, new_size), Vector2i(left, top))
	return result

func _bounds(image: Image, frame: int) -> Rect2i:
	var left := CELL.x
	var top := CELL.y
	var right := -1
	var bottom := -1
	for y in CELL.y:
		for x in CELL.x:
			if image.get_pixel(frame * CELL.x + x, y).a < ALPHA_THRESHOLD:
				continue
			left = mini(left, x)
			top = mini(top, y)
			right = maxi(right, x)
			bottom = maxi(bottom, y)
	if right < left:
		return Rect2i()
	return Rect2i(left, top, right - left + 1, bottom - top + 1)

func _median(values: Array[int]) -> int:
	var sorted := values.duplicate()
	sorted.sort()
	return sorted[sorted.size() / 2]
