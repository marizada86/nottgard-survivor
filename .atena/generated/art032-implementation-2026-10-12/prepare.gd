extends SceneTree

func _init() -> void:
	var package: String = get_script().resource_path.get_base_dir()
	var root: String = package.get_base_dir().get_base_dir().get_base_dir()
	var manifest_path := package.path_join("manifest.json")
	var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(manifest_path))
	var records: Array = []
	for entry in data.entries:
		var source_path := root.path_join(str(entry.path))
		var source := Image.load_from_file(source_path)
		if source == null:
			push_error("Source load failed: " + source_path)
			quit(1)
			return
		source.convert(Image.FORMAT_RGBA8)
		_clear_trace_alpha(source)
		var box := source.get_used_rect()
		if box.size.x <= 0 or box.size.y <= 0:
			push_error("Empty source: " + str(entry.code))
			quit(1)
			return
		var cropped := source.get_region(box)
		var height := int(entry.target_visible_height)
		var width := maxi(1, roundi(float(box.size.x) / box.size.y * height))
		cropped.resize(width, height, Image.INTERPOLATE_LANCZOS)
		_clear_trace_alpha(cropped)
		var pad := int(entry.padding)
		var result := Image.create(width + 2 * pad, height + 2 * pad, false, Image.FORMAT_RGBA8)
		result.fill(Color(0, 0, 0, 0))
		result.blit_rect(cropped, Rect2i(Vector2i.ZERO, cropped.get_size()), Vector2i(pad, pad))
		var destination := root.path_join(str(entry.derived_path))
		var error := result.save_png(destination)
		if error != OK:
			push_error("Derivative write failed: " + destination)
			quit(1)
			return
		records.append({"code": entry.code, "source": entry.path, "source_crop": [box.position.x, box.position.y, box.size.x, box.size.y], "derived_path": entry.derived_path, "size": [result.get_width(), result.get_height()], "body_target": [width, height], "padding": pad, "source_file_modified": false})
	var output := FileAccess.open(package.path_join("preparation.json"), FileAccess.WRITE)
	output.store_string(JSON.stringify({"status": "PASS", "count": records.size(), "engine": Engine.get_version_info().string, "method": "DERIVATIVE_ONLY_ALPHA_CROP_ASPECT_LANCZOS_PADDING", "records": records}, "  ") + "\n")
	output.close()
	print("Prepared %d derivatives; native sources unchanged." % records.size())
	quit(0)

func _clear_trace_alpha(image: Image) -> void:
	for y in image.get_height():
		for x in image.get_width():
			# Half a quantization step avoids float32 rounding retaining byte value 8.
			if image.get_pixel(x, y).a < 8.5 / 255.0:
				image.set_pixel(x, y, Color(0, 0, 0, 0))
