extends SceneTree
## Authorized Molor alpha cleanup for review; originals remain unchanged.
func _init() -> void:
	var directory := "res://.atena/generated/art-candidates/enemies-molor/blogbog/"
	var files := DirAccess.open(directory).get_files()
	for file in files:
		if not (file.ends_with("_v01.png") or file.ends_with("_v02.png")) or file.contains("idle_00"):
			continue
		var source := Image.load_from_file(directory + file)
		var solid := 0
		for y in source.get_height():
			for x in source.get_width():
				var pixel := source.get_pixel(x, y)
				if pixel.a >= 250.5 / 255.0:
					solid += 1
					source.set_pixel(x, y, Color(pixel, 1.0))
				else:
					source.set_pixel(x, y, Color.TRANSPARENT)
		var bounds := source.get_used_rect()
		print(file, " size=", source.get_size(), " solid=", solid, " body=", bounds, " clipped=", bounds.position.x <= 0 or bounds.end.x >= source.get_width() or bounds.end.y >= source.get_height())
		source.save_png(directory + file.replace(".png", "_alpha_clean.png"))
	quit()
