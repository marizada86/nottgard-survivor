extends SceneTree

func _init() -> void:
	var id := OS.get_cmdline_user_args()[0]
	var base := "res://.atena/generated/art-candidates/enemies-shedaklah/%s/" % id
	var states := {"idle": 4, "move": 6, "attack": 4, "death": 6}
	if id == "zuggtmoy": states["special"] = 6
	for state in states:
		for index in states[state]:
			var path := base + "%s_%s_%02d_v01.png" % [id, state, index]
			for version in [2, 3]:
				var retry := base + "%s_%s_%02d_v%02d.png" % [id, state, index, version]
				if FileAccess.file_exists(retry): path = retry
			if state == "idle" and index == 0: path = base + id + "_idle_00_v03.png"
			if not FileAccess.file_exists(path): continue
			var source := Image.load_from_file(path)
			if source == null: continue
			var lower := source.get_size()
			var upper := Vector2i.ZERO
			for y in source.get_height():
				for x in source.get_width():
					if source.get_pixel(x, y).a >= 0.9:
						lower = lower.min(Vector2i(x, y))
						upper = upper.max(Vector2i(x, y))
			print(state, "_", index, " height=", upper.y-lower.y+1, " bounds=", lower, "..", upper, " clipped=", lower.x == 0 or lower.y == 0 or upper.x == source.get_width()-1 or upper.y == source.get_height()-1)
	quit()
