extends SceneTree
## Varre TODOS os quadros de todos os heróis e sinaliza os que perdem dimensão ao se mover.
## Referência de cada herói: altura, base e massa (pixels opacos) medianas do idle.
## Não modifica PNGs.
##
## godot --headless --path . -s tools/audit_hero_frame_stability.gd -- [--hero=id] [--all]
## Sem --all imprime só as sequências com alguma sinalização.

const CELL := Vector2i(256, 384)
const ALPHA_THRESHOLD := 0.10
const SEQUENCES := ["move_n", "move_ne", "move_e", "move_se", "move_s", "attack", "active", "death"]
const HEIGHT_TOLERANCE := 0.12
const BASE_TOLERANCE := 6
const MASS_TOLERANCE := 0.30
const MAX_INTRA_MASS_SPREAD := 1.45

func _initialize() -> void:
	var only_hero := ""
	var show_all := false
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--hero="):
			only_hero = arg.substr(7)
		elif arg == "--all":
			show_all = true
	var directory := DirAccess.open("res://assets/animations/heroes")
	print("hero,seq,h_ratio_min,h_ratio_max,base_dev_max,mass_ratio_min,mass_ratio_max,mass_spread,edge_frames,flags")
	for hero in directory.get_directories():
		if only_hero != "" and hero != only_hero:
			continue
		var root := ProjectSettings.globalize_path("res://assets/animations/heroes/%s" % hero)
		var idle := _load("%s/idle.png" % root)
		if idle == null:
			continue
		var ref := _measure(idle)
		for sequence in SEQUENCES:
			var image := _load("%s/%s.png" % [root, sequence])
			if image == null:
				continue
			var stats := _measure(image)
			var flags: Array[String] = []
			var h_min := 99.0
			var h_max := 0.0
			var base_dev := 0
			var m_min := 99.0
			var m_max := 0.0
			var edges := 0
			for frame in stats.frames:
				var h_ratio := float(frame.height) / float(ref.height)
				var m_ratio := float(frame.mass) / float(ref.mass)
				h_min = minf(h_min, h_ratio)
				h_max = maxf(h_max, h_ratio)
				m_min = minf(m_min, m_ratio)
				m_max = maxf(m_max, m_ratio)
				base_dev = maxi(base_dev, absi(frame.bottom - ref.bottom))
				if frame.edge:
					edges += 1
			var spread := m_max / maxf(m_min, 0.0001)
			if h_min < 1.0 - HEIGHT_TOLERANCE or h_max > 1.0 + HEIGHT_TOLERANCE:
				flags.append("ALTURA")
			if base_dev > BASE_TOLERANCE and not sequence in ["death"]:
				flags.append("BASE")
			if m_min < 1.0 - MASS_TOLERANCE or m_max > 1.0 + MASS_TOLERANCE:
				flags.append("MASSA")
			if spread > MAX_INTRA_MASS_SPREAD:
				flags.append("VARIACAO")
			if edges > 0:
				flags.append("BORDA")
			if show_all or not flags.is_empty():
				print("%s,%s,%.2f,%.2f,%d,%.2f,%.2f,%.2f,%d,%s" % [hero, sequence, h_min, h_max, base_dev, m_min, m_max, spread, edges, "+".join(flags)])
	quit()

func _load(path: String) -> Image:
	var image := Image.new()
	if image.load(path) != OK:
		return null
	image.convert(Image.FORMAT_RGBA8)
	return image

func _measure(image: Image) -> Dictionary:
	var frames: Array = []
	var heights: Array[int] = []
	var bottoms: Array[int] = []
	var masses: Array[int] = []
	for index in image.get_width() / CELL.x:
		var left := CELL.x
		var top := CELL.y
		var right := -1
		var bottom := -1
		var mass := 0
		for y in CELL.y:
			for x in CELL.x:
				if image.get_pixel(index * CELL.x + x, y).a < ALPHA_THRESHOLD:
					continue
				mass += 1
				left = mini(left, x)
				top = mini(top, y)
				right = maxi(right, x)
				bottom = maxi(bottom, y)
		if right < left:
			continue
		var edge := left <= 1 or top <= 1 or right >= CELL.x - 2 or bottom >= CELL.y - 2
		frames.append({"height": bottom - top + 1, "bottom": bottom + 1, "mass": mass, "edge": edge})
		heights.append(bottom - top + 1)
		bottoms.append(bottom + 1)
		masses.append(mass)
	return {"frames": frames, "height": _median(heights), "bottom": _median(bottoms), "mass": _median(masses)}

func _median(values: Array[int]) -> int:
	if values.is_empty():
		return 1
	var sorted := values.duplicate()
	sorted.sort()
	return sorted[sorted.size() / 2]
