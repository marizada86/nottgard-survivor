extends SceneTree

func _init() -> void:
	var out := "res://.atena/generated/ampulheta-admission-2026-10-13/"
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(out + "normalized"))
	var accepted: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(out + "authorization.json"))
	var atlas := Image.create(1536, 256, false, Image.FORMAT_RGBA8)
	atlas.fill(Color(1, 1, 1, 0))
	var rows: Array = []
	for index in 6:
		var source: Dictionary = accepted.sources[index]
		var path := "res://" + String(source.path)
		assert(FileAccess.get_sha256(path) == source.sha256)
		var original := Image.load_from_file(path)
		var normalized := original.duplicate() as Image
		normalized.resize(1024, 1024, Image.INTERPOLATE_LANCZOS)
		assert(normalized.save_png(out + "normalized/" + String(source.code) + ".png") == OK)
		var small := original.duplicate() as Image
		small.resize(256, 256, Image.INTERPOLATE_LANCZOS)
		for y in 256:
			for x in 256:
				var p := small.get_pixel(x, y)
				var light := p.r * 0.2126 + p.g * 0.7152 + p.b * 0.0722
				atlas.set_pixel(index * 256 + x, y, Color(1, 1, 1, 0 if light <= 2.0 / 255.0 else light))
		rows.append({"code": source.code, "version": source.version, "source": source.path, "source_sha256": source.sha256, "offset": [index * 256, 0], "cell": [256, 256], "normalized_size": [1024, 1024]})
	assert(atlas.save_png(out + "ampulheta_silencio.png") == OK)
	var preview := Image.create(1536, 256, false, Image.FORMAT_RGB8)
	for y in 256:
		for x in 1536:
			var light := atlas.get_pixel(x, y).a
			preview.set_pixel(x, y, Color(light, light, light))
	assert(preview.save_png(out + "black-preview.png") == OK)
	var file := FileAccess.open(out + "packing.json", FileAccess.WRITE)
	file.store_string(JSON.stringify({"revision": "ampulheta-admission/v01", "content_state": "DRAFT", "records": rows, "atlas_size": [1536, 256], "resampling": "Godot Lanczos native1254 to1024 audit and directly to256 runtime", "pivot": [128, 128], "alpha": "Rec.709 luminance; <=2/255 zero", "rgb": "white", "duration": 0.35}, "\t") + "\n")
	print("prepare PASS: six normalized images and six-cell luminous-alpha atlas")
	quit()
