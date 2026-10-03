extends SceneTree
## Technical packing by annotated head/sole landmarks; weapons do not change body scale.

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 3:
		quit(2)
		return
	var source := Image.load_from_file(args[0])
	var config: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(args[2]))
	var count: int = config.frames.size()
	var output := Image.create(count * 256, 384, false, Image.FORMAT_RGBA8)
	var body_height: int = config.idle_sole_y - config.idle_head_y
	for index in count:
		var spec: Dictionary = config.frames[index]
		var bounds := Rect2i(int(spec.x), int(spec.y), int(spec.width), int(spec.height))
		var factor := float(body_height) / float(spec.sole_y - spec.head_y)
		var size := Vector2i(roundi(bounds.size.x * factor), roundi(bounds.size.y * factor))
		var top := int(config.idle_sole_y) - roundi((int(spec.sole_y) - bounds.position.y) * factor)
		if size.x > 236 or top < 2 or top + size.y > 382:
			push_error("Action cannot fit without changing body scale: frame %d" % index)
			quit(1)
			return
		var frame := source.get_region(bounds)
		frame.resize(size.x, size.y, Image.INTERPOLATE_NEAREST)
		output.blit_rect(frame, Rect2i(Vector2i.ZERO, size), Vector2i(index * 256 + (256 - size.x) / 2, top))
		print("frame=", index, " body_height=", body_height, " body_top=", config.idle_head_y, " sole=", config.idle_sole_y, " whole=", size, " top=", top)
	print("save=", output.save_png(args[1]))
	quit()
