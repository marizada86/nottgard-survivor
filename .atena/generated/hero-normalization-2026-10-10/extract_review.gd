extends SceneTree

func _init() -> void:
	var package_root := OS.get_cmdline_user_args()[0]
	var review: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(package_root.path_join("extraction-review-v01.json")))
	var saved := 0
	for record in review.records:
		if record.frames.is_empty():
			continue
		var source := Image.load_from_file(package_root.path_join(record.source))
		assert(source != null and not source.is_empty())
		for frame in record.frames:
			var coords: Array = frame.rect
			var region := Rect2i(int(coords[0]), int(coords[1]), int(coords[2]), int(coords[3]))
			var extracted := source.get_region(region)
			var destination := package_root.path_join(frame.path)
			DirAccess.make_dir_recursive_absolute(destination.get_base_dir())
			assert(not FileAccess.file_exists(destination), "Existing output must not be overwritten")
			assert(extracted.save_png(destination) == OK)
			saved += 1
	print(JSON.stringify({"saved_native_frames": saved, "resized": false, "repainted": false}))
	quit()
