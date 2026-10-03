extends SceneTree

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() < 2 or args.size() > 4:
		push_error("Expected hero ID and candidate path")
		quit(1)
		return
	var audit: RefCounted = load("res://tests/test_animation_assets.gd").new()
	var idle: Dictionary = audit._walk_metrics("res://assets/animations/heroes/%s/idle.png" % args[0])
	var strip: Dictionary = audit._walk_metrics(args[1])
	if args.size() > 3:
		var head_y := int(args[3])
		idle = _body_metrics("res://assets/animations/heroes/%s/idle.png" % args[0], head_y, idle)
		strip = _body_metrics(args[1], head_y, strip)
		print("Body landmark audit; weapon above y=", head_y, " is excluded from body height")
	if idle.is_empty() or strip.is_empty():
		push_error("Could not read hero reference or candidate")
		quit(1)
		return
	var min_height := 10000
	var max_height := 0
	var failures := 0
	var frame_count := int(args[2]) if args.size() > 2 else 6
	for frame in strip.frames:
		var ratio := float(frame.mass) / float(idle.mass)
		print("height=", frame.height, " base=", frame.bottom, " mass_ratio=", ratio, " edge=", frame.edge)
		min_height = mini(min_height, frame.height)
		max_height = maxi(max_height, frame.height)
		if absf(float(frame.height) / idle.height - 1.0) > 0.03 or absi(frame.bottom - idle.bottom) > 1 or frame.edge or ratio < 0.7 or ratio > 1.3:
			failures += 1
	if strip.frames.size() != frame_count or max_height - min_height > 12:
		failures += 1
	print("acceptance failures=", failures, " idle=", idle.height, "/", idle.bottom)
	quit(0 if failures == 0 else 1)

func _body_metrics(path: String, head_y: int, whole: Dictionary) -> Dictionary:
	if whole.is_empty():
		return {}
	var image := Image.load_from_file(path)
	var frames: Array = []
	var heights: Array[int] = []
	var bottoms: Array[int] = []
	var masses: Array[int] = []
	for index in image.get_width() / 256:
		var top := 384
		var bottom := -1
		var mass := 0
		for y in range(head_y, 384):
			for x in 256:
				if image.get_pixel(index * 256 + x, y).a >= 0.10:
					top = mini(top, y)
					bottom = maxi(bottom, y)
					mass += 1
		if mass == 0:
			return {}
		frames.append({"height": bottom - top + 1, "bottom": bottom + 1, "mass": mass, "edge": whole.frames[index].edge})
		heights.append(bottom - top + 1)
		bottoms.append(bottom + 1)
		masses.append(mass)
	heights.sort()
	bottoms.sort()
	masses.sort()
	return {"frames": frames, "height": heights[heights.size() / 2], "bottom": bottoms[bottoms.size() / 2], "mass": masses[masses.size() / 2]}
