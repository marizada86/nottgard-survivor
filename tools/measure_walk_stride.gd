extends SceneTree
## SPEC-144 (BUG-028): mede a passada desenhada nas tiras de andar e compara com o deslocamento do herói em jogo.
## godot --headless --path . -s tools/measure_walk_stride.gd [-- <heroi>]
## Saída: CSV no stdout e em .atena/generated/walk-debug/stride.csv (relativo ao projeto).
##
## Passada visível = abertura dos pés no quadro mais aberto (bbox do pé nos 10% inferiores do corpo; vertical = diferença entre
## o ponto mais baixo do pé esquerdo e do direito). `ratio` = (SPEED_PX × duração do ciclo) / (2 × passada): ~1 não desliza;
## bem acima de 1 o corpo anda mais que o pé desenhado (patinar).

const CELL := Vector2i(256, 384)
const DIRECTIONS := ["e", "se", "s", "ne", "n"]
const ALPHA := 0.10
const SPEED_PX := 190.0
const FPS_OPTIONS := [10.0, 15.0]

func _initialize() -> void:
	var only := ""
	var args := OS.get_cmdline_user_args()
	if args.size() > 0:
		only = args[0]
	var hero_script: Script = load("res://ui/hero_view.gd")
	var lines: Array[String] = ["hero,strip,scale,foot_w_min,foot_w_max,foot_dy_max,step_px,cycle_px_10fps,ratio_10fps,cycle_px_15fps,ratio_15fps,frames_w,plant_dx_per_frame,implied_speed_10fps,implied_speed_15fps"]
	var directory := DirAccess.open("res://assets/animations/heroes")
	for hero_id in directory.get_directories():
		if only != "" and hero_id != only:
			continue
		var scale: float = hero_script.display_scale(hero_id)
		var speed := SPEED_PX * (0.9 if hero_id == "korrak" else 1.0)
		for direction in DIRECTIONS:
			var image := Image.new()
			var path := ProjectSettings.globalize_path("res://assets/animations/heroes/%s/move_%s.png" % [hero_id, direction])
			if not FileAccess.file_exists(path) or image.load(path) != OK:
				continue
			image.convert(Image.FORMAT_RGBA8)
			var widths: Array[int] = []
			var plants: Array[float] = []
			var dys: Array[int] = []
			for index in image.get_width() / CELL.x:
				var foot := _foot(image, index)
				if foot.is_empty():
					continue
				widths.append(foot.w)
				plants.append(foot.plant)
				dys.append(foot.dy)
			if widths.is_empty():
				continue
			var w_min: int = widths.min()
			var w_max: int = widths.max()
			var dy_max: int = dys.max()
			# Passada em tela: o maior entre abertura horizontal e vertical, na escala de exibição do herói.
			var step_px := maxf(float(w_max), float(dy_max)) * scale
			var row := [hero_id, "move_" + direction, "%.3f" % scale, str(w_min), str(w_max), str(dy_max), "%.1f" % step_px]
			for fps: float in FPS_OPTIONS:
				var cycle: float = speed * 6.0 / fps
				row.append("%.0f" % cycle)
				row.append("%.2f" % (cycle / maxf(2.0 * step_px, 0.001)))
			var deltas: Array[float] = []
			for i in range(1, plants.size()):
				var d := absf(plants[i] - plants[i - 1])
				if d > 0.0 and d < 40.0:
					deltas.append(d)
			deltas.sort()
			var plant_dx: float = deltas[deltas.size() / 2] if not deltas.is_empty() else 0.0
			var tail := ["%.1f" % plant_dx, "%.0f" % (plant_dx * scale * 10.0), "%.0f" % (plant_dx * scale * 15.0)]
			row.append("|".join(widths.map(func(v: int) -> String: return str(v))))
			row.append_array(tail)
			lines.append(",".join(PackedStringArray(row)))
	var text := "\n".join(lines)
	print(text)
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://.atena/generated/walk-debug"))
	var file := FileAccess.open("res://.atena/generated/walk-debug/stride.csv", FileAccess.WRITE)
	if file != null:
		file.store_string(text + "\n")
		file.close()
	quit(0)

func _foot(image: Image, index: int) -> Dictionary:
	var top := CELL.y
	var bottom := -1
	for y in CELL.y:
		for x in CELL.x:
			if image.get_pixel(index * CELL.x + x, y).a >= ALPHA:
				top = mini(top, y)
				bottom = maxi(bottom, y)
	if bottom < 0:
		return {}
	var band := maxi(8, int(float(bottom - top + 1) * 0.10))
	var y0 := bottom - band + 1
	var xs: Array[int] = []
	for y in range(y0, bottom + 1):
		for x in CELL.x:
			if image.get_pixel(index * CELL.x + x, y).a >= ALPHA:
				xs.append(x)
	if xs.is_empty():
		return {}
	xs.sort()
	var split := xs[xs.size() / 2]
	var low_left := -1
	var low_right := -1
	for y in range(y0, bottom + 1):
		for x in CELL.x:
			if image.get_pixel(index * CELL.x + x, y).a < ALPHA:
				continue
			if x <= split:
				low_left = maxi(low_left, y)
			else:
				low_right = maxi(low_right, y)
	var dy := absi(low_left - low_right) if low_left >= 0 and low_right >= 0 else 0
	var plant_sum := 0.0
	var plant_n := 0
	for y in range(bottom - 2, bottom + 1):
		for x in CELL.x:
			if image.get_pixel(index * CELL.x + x, y).a >= ALPHA:
				plant_sum += x
				plant_n += 1
	return {"w": xs[xs.size() - 1] - xs[0] + 1, "dy": dy, "plant": plant_sum / maxf(plant_n, 1)}
