extends SceneTree

func _initialize() -> void:
	var batch_root := OS.get_cmdline_user_args()[0]
	var repo := batch_root.get_base_dir().get_base_dir().get_base_dir()
	DirAccess.make_dir_recursive_absolute(batch_root.path_join("previews"))
	var source := Image.load_from_file(batch_root.path_join("native-sources/L02_v01.png"))
	source.convert(Image.FORMAT_RGBA8)
	var removed := 0
	for y in source.get_height():
		for x in source.get_width():
			var color := source.get_pixel(x, y)
			if color.r < 0.30 and color.g > 0.65 and color.b > 0.65 and color.g - color.r > 0.45 and color.b - color.r > 0.45:
				source.set_pixel(x, y, Color.TRANSPARENT)
				removed += 1
	var bounds := source.get_used_rect()
	var crop := source.get_region(bounds)
	source.save_png(batch_root.path_join("previews/L02-keyed.png"))
	var fit_scale := minf(476.0 / crop.get_width(), 60.0 / crop.get_height())
	var resized := crop.duplicate() as Image
	resized.resize(maxi(1, roundi(crop.get_width() * fit_scale)), maxi(1, roundi(crop.get_height() * fit_scale)), Image.INTERPOLATE_NEAREST)
	var fitted := Image.create(480, 64, false, Image.FORMAT_RGBA8)
	fitted.fill(Color.TRANSPARENT)
	fitted.blit_rect(resized, Rect2i(Vector2i.ZERO, resized.get_size()), (Vector2i(480, 64) - resized.get_size()) / 2)
	fitted.save_png(batch_root.path_join("previews/L02-480x64.png"))
	var small := crop.duplicate() as Image
	small.resize(roundi(crop.get_width() * 30.0 / crop.get_height()), 30, Image.INTERPOLATE_NEAREST)
	small.save_png(batch_root.path_join("previews/L02-30px.png"))
	var mock := Image.load_from_file(repo.path_join("assets/ui/title/title_background.png"))
	mock.convert(Image.FORMAT_RGBA8)
	mock.resize(960, 540, Image.INTERPOLATE_LANCZOS)
	var logo := Image.load_from_file(repo.path_join("assets/ui/title/logo.png"))
	logo.convert(Image.FORMAT_RGBA8)
	logo.resize(480, roundi(logo.get_height() * 480.0 / logo.get_width()), Image.INTERPOLATE_NEAREST)
	mock.blend_rect(logo, Rect2i(Vector2i.ZERO, logo.get_size()), Vector2i(240, 70))
	mock.blend_rect(small, Rect2i(Vector2i.ZERO, small.get_size()), Vector2i((960 - small.get_width()) / 2, 465))
	mock.save_png(batch_root.path_join("previews/title-mock.png"))
	var file := FileAccess.open(batch_root.path_join("previews/preparation.json"), FileAccess.WRITE)
	file.store_string(JSON.stringify({"key": "global cyan threshold per prompt including enclosed counters; no letter repaint", "removed_pixels": removed, "bounds_xywh": [bounds.position.x, bounds.position.y, bounds.size.x, bounds.size.y], "final_canvas": [480, 64], "content_size": [resized.get_width(), resized.get_height()], "small_size": [small.get_width(), 30], "runtime_capture": false}, "  "))
	print("L02 previews prepared, native source untouched")
	quit()
