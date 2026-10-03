extends SceneTree
## Somente leitura: verifica recorte da matriz antes de empacotar.

func _init() -> void:
	for path in OS.get_cmdline_user_args():
		var image := Image.load_from_file(path)
		if image == null:
			quit(1)
			return
		print(path, " size=", image.get_size())
		for frame in 6:
			var start := int(floor(frame * image.get_width() / 6.0))
			var end := int(floor((frame + 1) * image.get_width() / 6.0))
			var bounds := Rect2i()
			var pixels := 0
			for y in image.get_height():
				for x in range(start, end):
					if image.get_pixel(x, y).a < 250.5 / 255.0:
						continue
					var point := Rect2i(x - start, y, 1, 1)
					bounds = point if pixels == 0 else bounds.merge(point)
					pixels += 1
			var cut := bounds.position.x <= 1 or bounds.end.x >= end - start - 1
			print("frame=", frame, " solid_bounds=", bounds, " cut=", cut, " ratio=", float(bounds.size.x) / maxf(1, bounds.size.y))
	quit()
