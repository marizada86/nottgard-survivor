extends SceneTree

func _init() -> void:
	var out := "res://.atena/generated/orbe-arcano-admission-2026-10-13/"
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(out + "normalized"))
	var receipt: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(out + "authorization.json"))
	var rows: Array = []
	for family in 2:
		var atlas := Image.create(1024, 256, false, Image.FORMAT_RGBA8)
		atlas.fill(Color(1, 1, 1, 0))
		for index in 4:
			var source: Dictionary = receipt.sources[family * 4 + index]
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
			rows.append({"code": source.code, "version": source.version, "source": source.path, "sha256": source.sha256, "cell": [256, 256], "offset": [index * 256, 0]})
		var name := "orbe_arcano_voo" if family == 0 else "orbe_arcano_impacto"
		assert(atlas.save_png(out + name + ".png") == OK)
		var preview := Image.create(1024, 256, false, Image.FORMAT_RGB8)
		for y in 256:
			for x in 1024:
				var a := atlas.get_pixel(x, y).a
				preview.set_pixel(x, y, Color(a, a, a))
		assert(preview.save_png(out + name + "-black-preview.png") == OK)
	var file := FileAccess.open(out + "packing.json", FileAccess.WRITE)
	file.store_string(JSON.stringify({"revision": "orbe-arcano-admission/v01", "content_state": "DRAFT", "records": rows, "atlas_size": [1024, 256], "filter": "Godot Lanczos1254->1024 audit and1254->256 runtime", "canvas_center": [128,128], "alpha": "Rec709 luminance; <=2/255zero", "rgb": "white", "flight_fps":12,"impact_duration":0.24}, "\t") + "\n")
	print("prepare PASS: eight normalized sources and two four-cell atlases")
	quit()
