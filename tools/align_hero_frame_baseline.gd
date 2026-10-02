extends SceneTree
## Alinha a base (pés) de CADA quadro de uma tira à linha de base do idle do herói (BUG-021).
## Corrige tiras em que parte dos quadros fica deslocada na vertical e o herói "pula" ao andar.
## Só desloca na vertical, sem reescalar.
## Uso: godot --headless --path . -s res://tools/align_hero_frame_baseline.gd -- [--write] heroi [seq,seq...]

const CELL := Vector2i(256, 384)
const ALPHA_THRESHOLD := 0.10

func _initialize() -> void:
	var write := false
	var positional: Array[String] = []
	for arg in OS.get_cmdline_user_args():
		if arg == "--write":
			write = true
		else:
			positional.append(arg)
	if positional.is_empty():
		push_error("informe o herói")
		quit(1)
		return
	var hero_id := positional[0]
	var sequences: Array = ["move_n", "move_ne", "move_e", "move_se", "move_s"]
	if positional.size() > 1:
		sequences = positional[1].split(",")
	var root := ProjectSettings.globalize_path("res://assets/animations/heroes/%s" % hero_id)
	var idle := Image.new()
	if idle.load("%s/idle.png" % root) != OK:
		push_error("idle ausente")
		quit(1)
		return
	var target := _median(_bottoms(idle))
	print("%s: base alvo (idle) = %d" % [hero_id, target])
	for sequence in sequences:
		var path := "%s/%s.png" % [root, sequence]
		var image := Image.new()
		if image.load(path) != OK:
			print("%s: ausente" % sequence)
			continue
		image.convert(Image.FORMAT_RGBA8)
		var bottoms := _bottoms(image)
		var output := Image.create(image.get_width(), image.get_height(), false, Image.FORMAT_RGBA8)
		var shifts: Array[int] = []
		for index in bottoms.size():
			var shift: int = target - bottoms[index]
			shifts.append(shift)
			var source := Rect2i(index * CELL.x, maxi(0, -shift), CELL.x, CELL.y - absi(shift))
			output.blend_rect(image, source, Vector2i(index * CELL.x, maxi(0, shift)))
		print("%s: bases %s -> deslocamentos %s" % [sequence, bottoms, shifts])
		if write:
			output.save_png(path)
	quit()

func _bottoms(image: Image) -> Array[int]:
	var result: Array[int] = []
	for index in image.get_width() / CELL.x:
		var bottom := -1
		for y in range(CELL.y - 1, -1, -1):
			for x in CELL.x:
				if image.get_pixel(index * CELL.x + x, y).a >= ALPHA_THRESHOLD:
					bottom = y
					break
			if bottom >= 0:
				break
		result.append(bottom)
	return result

func _median(values: Array[int]) -> int:
	var sorted := values.duplicate()
	sorted.sort()
	return sorted[sorted.size() / 2]
