extends SceneTree
## Escala única por ator; alfa técnico autorizado, originais preservados.

func _init() -> void:
	var id := "bolha_de_slime"
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--id="):
			id = arg.substr(5)
	var base := "res://.atena/generated/art-candidates/enemies-molor/%s/" % id
	var states := {"idle": 4, "move": 6, "attack": 4, "death": 6}
	if id == "blogbog":
		states["special"] = 6
	var images := {}
	var transforms := {}
	var union := Rect2i()
	for state in states:
		images[state] = []
		transforms[state] = []
		for index in states[state]:
			var path := base + "%s_%s_%02d_v01.png" % [id, state, index]
			if id == "cultista_thullgrime" and state == "attack" and index == 2:
				path = base + id + "_attack_02_v02.png"
			if id == "blogbog" and state == "death" and index >= 3:
				path = base + "%s_death_%02d_v02.png" % [id, index]
			if id == "blogbog" and state == "special" and index in [3, 4]:
				path = base + "%s_special_%02d_v02.png" % [id, index]
			if state == "idle" and index == 0:
				path = base + id + "_idle_00_alpha_clean.png"
			var image := Image.load_from_file(path)
			if image == null:
				push_error("Missing frame: " + path)
				quit(1)
				return
			image.convert(Image.FORMAT_RGBA8)
			for y in image.get_height():
				for x in image.get_width():
					var pixel := image.get_pixel(x, y)
					image.set_pixel(x, y, Color(pixel, 1.0) if pixel.a >= 250.5 / 255.0 else Color.TRANSPARENT)
			if id == "blogbog":
				_remove_islands(image)
			var rect := image.get_used_rect()
			var pose_scale := 1.0
			var pose_anchor := Vector2(520, 1343)
			if id == "blogbog":
				# Standing loops share the approved body height. Death retains collapse.
				if state in ["idle", "move"]:
					pose_scale = 1216.0 / rect.size.y
				pose_anchor = Vector2(rect.get_center().x, rect.end.y)
				var relative_start := (Vector2(rect.position) - pose_anchor) * pose_scale
				var relative_end := (Vector2(rect.end) - pose_anchor) * pose_scale
				rect = Rect2i(Vector2i(relative_start.floor()), Vector2i((relative_end - relative_start).ceil()))
			transforms[state].append({"scale": pose_scale, "anchor": pose_anchor})
			union = rect if union.size == Vector2i.ZERO else union.merge(rect)
			images[state].append(image)
	# Origem do idle aprovado; transformação idêntica em todos os estados.
	var anchor := Vector2(522.5, 1173)
	var idle_height := 825.0
	if id == "cultista_thullgrime":
		anchor = Vector2(509, 1476)
		idle_height = 1428.0
	elif id == "blogbog":
		anchor = Vector2.ZERO
		idle_height = 1216.0
	var fit := minf(107.0 / maxf(anchor.x - union.position.x, union.end.x - anchor.x), 360.0 / (anchor.y - union.position.y))
	fit = minf(fit, 16.0 / maxf(1.0, union.end.y - anchor.y))
	print("Molor ", id, " union=", union, " scale=", fit, " idle_body_height=", idle_height * fit)
	var output := base + "strips/"
	DirAccess.make_dir_recursive_absolute(output)
	var review := Image.create(1536, 384 * states.size(), false, Image.FORMAT_RGBA8)
	review.fill(Color("24242e"))
	var row := 0
	for state in states:
		var strip := Image.create(256 * states[state], 384, false, Image.FORMAT_RGBA8)
		for index in states[state]:
			var source: Image = images[state][index]
			var frame_anchor := anchor
			var frame_fit := fit
			if id == "blogbog":
				frame_anchor = transforms[state][index].anchor
				frame_fit *= transforms[state][index].scale
			var frame := Image.create(256, 384, false, Image.FORMAT_RGBA8)
			for y in 384:
				for x in 256:
					var at := Vector2i((Vector2(x, y) - Vector2(128, 356)) / frame_fit + frame_anchor)
					if at.x >= 0 and at.y >= 0 and at.x < source.get_width() and at.y < source.get_height():
						frame.set_pixel(x, y, source.get_pixelv(at))
			_remove_islands(frame)
			strip.blit_rect(frame, Rect2i(Vector2i.ZERO, frame.get_size()), Vector2i(index * 256, 0))
		strip.save_png(output + state + ".png")
		var state_review := Image.create(strip.get_width(), 384, false, Image.FORMAT_RGBA8)
		state_review.fill(Color("24242e"))
		state_review.blend_rect(strip, Rect2i(Vector2i.ZERO, strip.get_size()), Vector2i.ZERO)
		state_review.save_png("res://.atena/generated/priority-review/%s_%s.png" % [id, state])
		review.blend_rect(strip, Rect2i(Vector2i.ZERO, strip.get_size()), Vector2i(0, row * 384))
		row += 1
	review.save_png("res://.atena/generated/priority-review/%s_all_states.png" % id)
	quit()

func _remove_islands(image: Image) -> void:
	var width := image.get_width()
	var height := image.get_height()
	var visited := PackedByteArray()
	visited.resize(width * height)
	for y in height:
		for x in width:
			var start := y * width + x
			if visited[start] != 0 or image.get_pixel(x, y).a == 0:
				continue
			var component := PackedInt32Array([start])
			visited[start] = 1
			var index := 0
			while index < component.size():
				var pixel := component[index]
				index += 1
				var at := Vector2i(pixel % width, pixel / width)
				for offset in [Vector2i(-1, 0), Vector2i(1, 0), Vector2i(0, -1), Vector2i(0, 1)]:
					var next: Vector2i = at + offset
					if next.x < 0 or next.x >= width or next.y < 0 or next.y >= height:
						continue
					var next_id: int = next.y * width + next.x
					if visited[next_id] == 0 and image.get_pixelv(next).a > 0:
						visited[next_id] = 1
						component.append(next_id)
			if component.size() <= 3:
				for pixel in component:
					image.set_pixel(pixel % width, pixel / width, Color.TRANSPARENT)
