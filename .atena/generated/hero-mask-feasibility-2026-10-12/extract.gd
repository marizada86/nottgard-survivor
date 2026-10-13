extends SceneTree

func _init() -> void:
	var out := OS.get_cmdline_user_args()[0]
	var root_path := out.get_base_dir().get_base_dir().get_base_dir()
	var analysis: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(out.path_join("analysis.json")))
	var records: Array = []
	for record in analysis.records:
		var source := Image.load_from_file(root_path.path_join(record.source))
		if source == null or source.is_empty():
			quit(1)
			return
		source.convert(Image.FORMAT_RGBA8)
		var overlay := source.duplicate() as Image
		for corridor in record.corridors:
			var color := Color("52ffc0") if bool(corridor.clear_three_pixel_corridor) else Color("ff5368")
			for y in source.get_height():
				overlay.set_pixel(int(corridor.trace_x_by_y[y]), y, color)
		DirAccess.make_dir_recursive_absolute(out.path_join("diagnostics"))
		overlay.save_png(out.path_join("diagnostics/" + String(record.code) + ".png"))
		if not String(record.status).begins_with("NONRECTANGULAR"):
			continue
		var frames: Array = []
		for index in int(record.observed_poses):
			var left: Array = []
			var right: Array = []
			for y in source.get_height():
				left.append(0 if index == 0 else int(record.corridors[index - 1].trace_x_by_y[y]))
				right.append(source.get_width() if index == int(record.observed_poses) - 1 else int(record.corridors[index].trace_x_by_y[y]))
			var x0 := int(left.min())
			var x1 := int(right.max())
			var image := source.get_region(Rect2i(x0, 0, x1 - x0, source.get_height()))
			for y in image.get_height():
				for x in image.get_width():
					if x + x0 < int(left[y]) or x + x0 >= int(right[y]):
						image.set_pixel(x, y, Color(0, 0, 0, 0))
			var name := "native/%s/f%02d.png" % [record.code, index + 1]
			var destination := out.path_join(name)
			DirAccess.make_dir_recursive_absolute(destination.get_base_dir())
			if FileAccess.file_exists(destination) or image.save_png(destination) != OK:
				quit(1)
				return
			frames.append({"frame": index + 1, "path": name, "rect": [x0, 0, x1 - x0, source.get_height()], "left_x_by_y": left, "right_x_by_y": right})
		records.append({"code": record.code, "source": record.source, "source_sha256": record.source_sha256, "frames": frames, "state": "DRAFT_NATIVE_MASKED_EXTRACTION", "resized": false, "repainted": false})
	var report := FileAccess.open(out.path_join("native-extractions.json"), FileAccess.WRITE)
	report.store_string(JSON.stringify({"engine": Engine.get_version_info().string, "records": records, "runtime_admission": false}, "\t"))
	report.close()
	print("Sixteen native masked frames and five diagnostic overlays saved; source images preserved.")
	quit()
