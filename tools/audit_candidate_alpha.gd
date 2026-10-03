extends SceneTree

func _init() -> void:
	for path in OS.get_cmdline_user_args():
		var source := Image.load_from_file(path)
		var histogram := {}
		var solid_min := source.get_size()
		var solid_max := Vector2i.ZERO
		for y in source.get_height():
			for x in source.get_width():
				var alpha := int(round(source.get_pixel(x, y).a * 255))
				histogram[alpha] = int(histogram.get(alpha, 0)) + 1
				if alpha >= 251:
					solid_min = solid_min.min(Vector2i(x, y))
					solid_max = solid_max.max(Vector2i(x, y))
		var transparent := int(histogram.get(0, 0))
		var opaque := 0
		for a in [251, 252, 253, 254, 255]:
			opaque += int(histogram.get(a, 0))
		print(path, " size=", source.get_size(), " transparent=", transparent, " solid251+=", opaque, " partial=", source.get_width() * source.get_height() - opaque - transparent)
		print("  solid bounds=", solid_min, "..", solid_max, " clipped=", solid_min.x == 0 or solid_min.y == 0 or solid_max.x == source.get_width() - 1 or solid_max.y == source.get_height() - 1)
	quit()
