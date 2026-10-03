extends SceneTree
## Empacota a tira gerada sem alterar cores/alfa; rejeita margem ou escala inválidas.

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() < 4 or args.size() > 6:
		quit(2)
		return
	var source := Image.load_from_file(args[0])
	var target_height := int(args[2])
	var baseline := int(args[3])
	var frame_count := int(args[4]) if args.size() > 4 else 6
	var groups: Array[Rect2i] = []
	var active := Rect2i()
	var mass := 0
	for x in source.get_width():
		var column := Rect2i()
		var count := 0
		for y in source.get_height():
			if source.get_pixel(x, y).a >= 0.10:
				var pixel := Rect2i(x, y, 1, 1)
				column = pixel if count == 0 else column.merge(pixel)
				count += 1
		if count > 0:
			active = column if mass == 0 else active.merge(column)
			mass += count
		elif mass > 0:
			if mass > 100:
				groups.append(active)
			mass = 0
	if mass > 100:
		groups.append(active)
	if args.size() > 5 and args[5] == "--grid":
		if source.get_size() != Vector2i(frame_count * 256, 384):
			push_error("Grid source must already use 256x384 cells")
			quit(1)
			return
		groups.clear()
		for index in frame_count:
			var bounds := Rect2i()
			var occupied := false
			for y in 384:
				for x in 256:
					if source.get_pixel(index * 256 + x, y).a >= 0.10:
						var pixel := Rect2i(index * 256 + x, y, 1, 1)
						bounds = bounds.merge(pixel) if occupied else pixel
						occupied = true
			if occupied:
				groups.append(bounds)
	print("source silhouettes=", groups.size(), " bounds=", groups)
	if groups.size() != frame_count:
		push_error("Expected %d separated silhouettes; alpha or layout needs correction" % frame_count)
		quit(1)
		return
	var output := Image.create(frame_count * 256, 384, false, Image.FORMAT_RGBA8)
	for index in frame_count:
		var bounds: Rect2i = groups[index]
		if bounds.position.x <= 0 or bounds.end.x >= source.get_width():
			push_error("Source silhouette touches canvas border")
			quit(1)
			return
		var fit := float(target_height) / bounds.size.y
		var width := int(round(bounds.size.x * fit))
		if width > 236:
			push_error("Frame %d width %d would violate 10px margin at target height" % [index, width])
			quit(1)
			return
		var frame := source.get_region(bounds)
		frame.resize(width, target_height, Image.INTERPOLATE_NEAREST)
		output.blit_rect(frame, Rect2i(Vector2i.ZERO, frame.get_size()), Vector2i(index * 256 + (256 - width) / 2, baseline - target_height))
		print("frame=", index, " width=", width, " height=", target_height, " base=", baseline)
	print("save=", output.save_png(args[1]))
	quit()
