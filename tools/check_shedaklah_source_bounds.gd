extends SceneTree

func _init() -> void:
	var id := OS.get_cmdline_user_args()[0]
	var biome := "shedaklah"
	var identity_version := "03"
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--biome="): biome = arg.substr(8)
		if arg.begins_with("--identity-version="): identity_version = arg.substr(19)
	var base := "res://.atena/generated/art-candidates/enemies-%s/%s/" % [biome, id]
	var selection: Dictionary = {}
	if FileAccess.file_exists(base + "frame-selection.json"):
		selection = JSON.parse_string(FileAccess.get_file_as_string(base + "frame-selection.json"))
	var states := {"idle": 4, "move": 6, "attack": 4, "death": 6}
	if id in ["zuggtmoy", "molydeus_chefe", "lu_yueh"]: states["special"] = 6
	for state in states:
		for index in states[state]:
			var path := base + "%s_%s_%02d_v01.png" % [id, state, index]
			for version in [2, 3]:
				var retry := base + "%s_%s_%02d_v%02d.png" % [id, state, index, version]
				if FileAccess.file_exists(retry): path = retry
			var frame_choice: Dictionary = selection.get("%s_%02d" % [state, index], {})
			if frame_choice.has("version"):
				path = base + "%s_%s_%02d_v%02d.png" % [id, state, index, int(frame_choice.version)]
			if state == "idle" and index == 0: path = base + id + "_idle_00_v%s.png" % identity_version
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
