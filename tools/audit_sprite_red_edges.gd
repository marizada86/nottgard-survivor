extends SceneTree

func _init() -> void:
	for path in OS.get_cmdline_user_args():
		var source := Image.load_from_file(path)
		if source == null:
			quit(1)
			return
		var visible := 0
		var solid := 0
		var hidden := 0
		for y in source.get_height():
			for x in source.get_width():
				var c := source.get_pixel(x, y)
				if c.r > 0.8 and c.g < 0.15 and c.b < 0.3:
					if c.a > 0.04: visible += 1
					if c.a >= 0.9: solid += 1
					if c.a == 0.0: hidden += 1
		print(path.get_file(), " red_visible=", visible, " red_solid=", solid, " red_hidden=", hidden)
	quit()
