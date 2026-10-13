extends SceneTree

func clean_traces(image: Image) -> void:
	for y in image.get_height():
		for x in image.get_width():
			if image.get_pixel(x, y).a < 8.5 / 255.0:
				image.set_pixel(x, y, Color(0, 0, 0, 0))

func _init() -> void:
	var out := OS.get_cmdline_user_args()[0]
	var root_path := out.get_base_dir().get_base_dir().get_base_dir()
	var manifest: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(out.path_join("manifest.json")))
	var results: Array = []
	var board := Image.create(1536, 2048, false, Image.FORMAT_RGBA8)
	board.fill(Color("211f27"))
	var row := 0
	for record in manifest.records:
		if bool(record.fit_conflict):
			push_error("Body/fit conflict: " + String(record.code))
			quit(1)
			return
		var scale := float(record.requested_scale)
		var atlas := Image.create(record.frames.size() * 512, 512, false, Image.FORMAT_RGBA8)
		atlas.fill(Color(0, 0, 0, 0))
		var frames: Array = []
		for frame in record.frames:
			var source := Image.load_from_file(root_path.path_join(frame.path))
			if source == null or source.is_empty():
				quit(1)
				return
			source.convert(Image.FORMAT_RGBA8)
			clean_traces(source)
			var used := source.get_used_rect()
			var image := source.get_region(used)
			var width := maxi(1, roundi(used.size.x * scale))
			var height := maxi(1, roundi(used.size.y * scale))
			image.resize(width, height, Image.INTERPOLATE_LANCZOS)
			clean_traces(image)
			var x := 256 - roundi((float(frame.hip_x) - used.position.x) * scale)
			var y := 448 - roundi((float(frame.ground_y) - used.position.y) * scale)
			if x < 10 or x + width > 502 or y < 10 or y + height > 502:
				push_error("Guard violation: " + String(record.code))
				quit(1)
				return
			var cell := Image.create(512, 512, false, Image.FORMAT_RGBA8)
			cell.fill(Color(0, 0, 0, 0))
			cell.blit_rect(image, Rect2i(0, 0, width, height), Vector2i(x, y))
			var path := "frames/%s/f%02d.png" % [record.code, frame.frame]
			var destination := out.path_join(path)
			DirAccess.make_dir_recursive_absolute(destination.get_base_dir())
			if FileAccess.file_exists(destination) or cell.save_png(destination) != OK:
				quit(1)
				return
			atlas.blit_rect(cell, Rect2i(0, 0, 512, 512), Vector2i((int(frame.frame) - 1) * 512, 0))
			frames.append({"frame": frame.frame, "path": path, "scale": scale, "paste_rect": [x, y, width, height], "used_rect": [used.position.x, used.position.y, used.size.x, used.size.y], "head_y_geometry": y + (float(frame.head_y) - used.position.y) * scale, "ground_y_geometry": y + (float(frame.ground_y) - used.position.y) * scale, "hip_x_geometry": x + (float(frame.hip_x) - used.position.x) * scale})
			var preview_index := 3 if String(record.code) in ["AO08", "ER08"] else 4 if String(record.code) == "ER09" else 6
			if int(frame.frame) == 1:
				board.blend_rect(cell, Rect2i(0, 0, 512, 512), Vector2i(512, row * 512))
			if int(frame.frame) == preview_index:
				board.blend_rect(cell, Rect2i(0, 0, 512, 512), Vector2i(1024, row * 512))
		var idle := Image.load_from_file(root_path.path_join(record.idle_reference.path))
		var idle_frame := idle.get_region(Rect2i(0, 0, 256, 384))
		board.blend_rect(idle_frame, Rect2i(0, 0, 256, 384), Vector2i(128, row * 512 + 80))
		for column in 3:
			for x in 512:
				board.set_pixel(column * 512 + x, row * 512 + 448, Color("d3ba7d"))
			for y in range(12, 500):
				if y % 10 < 4:
					board.set_pixel(column * 512 + 256, row * 512 + y, Color("6bbac0"))
		DirAccess.make_dir_recursive_absolute(out.path_join("strips"))
		var strip := "strips/" + String(record.code) + "_wide_v01.png"
		atlas.save_png(out.path_join(strip))
		results.append({"code": record.code, "strip": strip, "scale": scale, "frames": frames, "content_state": "DRAFT", "runtime_admission": false})
		row += 1
	board.save_png(out.path_join("review-board.png"))
	var file := FileAccess.open(out.path_join("preparation.json"), FileAccess.WRITE)
	file.store_string(JSON.stringify({"engine": Engine.get_version_info().string, "records": results, "frames": 20, "cell": [512, 512], "status": "DRAFT_PREPARED"}, "\t"))
	file.close()
	print("Twenty wide-canvas frames and four strips prepared; accepted idles compared without rescaling.")
	quit()
