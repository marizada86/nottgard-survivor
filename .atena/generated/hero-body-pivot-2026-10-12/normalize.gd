extends SceneTree

func clean_traces(image: Image) -> void:
	for y in image.get_height():
		for x in image.get_width():
			var pixel := image.get_pixel(x, y)
			if pixel.a < 8.5 / 255.0:
				image.set_pixel(x, y, Color(0, 0, 0, 0))

func _init() -> void:
	var out := OS.get_cmdline_user_args()[0]
	var root_path := out.get_base_dir().get_base_dir().get_base_dir()
	var manifest: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(out.path_join("manifest.json")))
	var variant := String(manifest.get("output_variant", ""))
	var result_root := out.path_join(variant) if variant != "" else out
	DirAccess.make_dir_recursive_absolute(result_root)
	var records: Array = []
	var board := Image.create(7 * 256, 2 * 420, false, Image.FORMAT_RGBA8)
	board.fill(Color("19171e"))
	var slots := {"arlindo": 0, "erik": 0}
	for record in manifest.records:
		var atlas := Image.create(record.frames.size() * 256, 384, false, Image.FORMAT_RGBA8)
		atlas.fill(Color(0, 0, 0, 0))
		var frame_records: Array = []
		var scale := float(record.scale) * (0.995 if bool(record.size_conflict) else 1.0)
		for frame in record.frames:
			var source := Image.load_from_file(root_path.path_join(frame.path))
			if source == null or source.is_empty():
				push_error("Missing source " + String(frame.path))
				quit(1)
				return
			source.convert(Image.FORMAT_RGBA8)
			clean_traces(source)
			var used := source.get_used_rect()
			var cropped := source.get_region(used)
			var width := maxi(1, roundi(used.size.x * scale))
			var height := maxi(1, roundi(used.size.y * scale))
			cropped.resize(width, height, Image.INTERPOLATE_LANCZOS)
			clean_traces(cropped)
			var x := 128 - roundi((float(frame.waist_x) - used.position.x) * scale)
			var y := 368 - height
			if x < 10 or x + width > 246 or y < 10 or y + height > 374:
				push_error("Placement would violate guard margin " + String(record.code))
				quit(1)
				return
			var cell := Image.create(256, 384, false, Image.FORMAT_RGBA8)
			cell.fill(Color(0, 0, 0, 0))
			cell.blit_rect(cropped, Rect2i(0, 0, width, height), Vector2i(x, y))
			var name := "frames/%s/f%02d.png" % [record.code, frame.frame]
			var destination := result_root.path_join(name)
			DirAccess.make_dir_recursive_absolute(destination.get_base_dir())
			if FileAccess.file_exists(destination) or cell.save_png(destination) != OK:
				push_error("Output exists or could not save " + destination)
				quit(1)
				return
			atlas.blit_rect(cell, Rect2i(0, 0, 256, 384), Vector2i((int(frame.frame) - 1) * 256, 0))
			frame_records.append({"frame": frame.frame, "path": name, "scale": scale, "body_height": float(frame.body_height) * scale, "head_y": 368.0 - float(frame.body_height) * scale, "feet_y": 368, "waist_x": 128, "paste_rect": [x, y, width, height], "used_rect": [used.position.x, used.position.y, used.size.x, used.size.y]})
			if int(frame.frame) == 1:
				var row := 0 if String(record.hero) == "arlindo" else 1
				var origin := Vector2i(int(slots[record.hero]) * 256, row * 420)
				var bg := Color("252127") if int(slots[record.hero]) % 2 == 0 else Color("1d1b23")
				for cy in 384:
					for cx in 256:
						board.set_pixel(origin.x + cx, origin.y + cy, bg)
				board.blend_rect(cell, Rect2i(0, 0, 256, 384), origin)
				for cx in 256:
					board.set_pixel(origin.x + cx, origin.y + 368, Color("d0bd88"))
				for cy in range(10, 384):
					if cy % 8 < 3:
						board.set_pixel(origin.x + 128, origin.y + cy, Color("72b6bd"))
				slots[record.hero] += 1
		DirAccess.make_dir_recursive_absolute(result_root.path_join("strips"))
		if atlas.save_png(result_root.path_join(record.output)) != OK:
			quit(1)
			return
		records.append({"code": record.code, "output": record.output, "scale": scale, "frames": frame_records, "size_conflict": record.size_conflict, "state": "DRAFT"})
	board.save_png(result_root.path_join("body-pivot-board.png"))
	var report := FileAccess.open(result_root.path_join("preparation.json"), FileAccess.WRITE)
	report.store_string(JSON.stringify({"engine": Engine.get_version_info().string, "strips": records, "frames": 60, "runtime_admission": false, "status": "CANDIDATES_PREPARED"}, "\t"))
	report.close()
	print("Eleven candidate strips and sixty cells prepared; AO08 remains a size-conflict diagnostic.")
	quit()
