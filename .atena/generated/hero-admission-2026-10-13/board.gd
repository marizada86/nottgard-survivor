extends SceneTree

func _init() -> void:
	var out := "res://.atena/generated/hero-admission-2026-10-13/"
	var names: Array[String] = []
	for hero in ["arlindo", "erik"]:
		names.append(hero + "-idle-hud")
		for index in 8:
			names.append(hero + "-direction-" + str(index))
		for suffix in ["attack", "active", "death", "death-final", "static-fallback"]:
			names.append(hero + "-" + suffix)
	var board := Image.create(960, 1120, false, Image.FORMAT_RGBA8)
	for index in names.size():
		var shot := Image.load_from_file(out + "captures/" + names[index] + ".png")
		shot.convert(Image.FORMAT_RGBA8)
		board.blit_rect(shot, Rect2i(520, 280, 240, 160), Vector2i((index % 4) * 240, (index / 4) * 160))
	assert(board.save_png(out + "runtime-board.png") == OK)
	var report := {"order_left_to_right_top_to_bottom": names, "crop": [520,280,240,160], "fallback_comparisons": {}}
	for hero in ["arlindo", "erik"]:
		var idle := Image.load_from_file(out + "captures/" + hero + "-idle-hud.png")
		var still := Image.load_from_file(out + "captures/" + hero + "-static-fallback.png")
		idle.convert(Image.FORMAT_RGBA8)
		still.convert(Image.FORMAT_RGBA8)
		var region := Rect2i(600, 315, 80, 85)
		report.fallback_comparisons[hero] = {"crop": [600,315,80,85], "rendered_rgba_equal": idle.get_region(region).get_data() == still.get_region(region).get_data()}
	var file := FileAccess.open(out + "runtime-board.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(report, "\t") + "\n")
	print("board saved; fallback rendered comparison: ", report.fallback_comparisons)
	quit()
