extends SceneTree

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() < 4 or args.size() > 5:
		push_error("Expected source destination width height")
		quit(1)
		return
	var image := Image.load_from_file(args[0])
	if image == null:
		quit(1)
		return
	if image.detect_alpha() != Image.ALPHA_NONE:
		if args.size() == 4:
			image = image.get_region(image.get_used_rect())
		image.convert(Image.FORMAT_RGBA8)
	else:
		image.convert(Image.FORMAT_RGB8)
	image.resize(int(args[2]), int(args[3]), Image.INTERPOLATE_NEAREST)
	DirAccess.make_dir_recursive_absolute(args[1].get_base_dir())
	var result := image.save_png(args[1])
	print("Saved ", args[1], " ", image.get_size(), " result=", result)
	quit(0 if result == OK else 1)
