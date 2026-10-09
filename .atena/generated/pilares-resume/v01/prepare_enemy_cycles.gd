extends SceneTree
## Empacotamento técnico com alfa nativo, sem limpeza ou modificação de RGB.

func _init() -> void:
	var id := "servo_de_zuggtmoy"
	var biome := "shedaklah"
	var identity_version := "03"
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--id="): id = arg.substr(5)
		if arg.begins_with("--biome="): biome = arg.substr(8)
		if arg.begins_with("--identity-version="): identity_version = arg.substr(19)
	var base := "res://.atena/generated/art-candidates/enemies-%s/%s/" % [biome, id]
	var selection: Dictionary = {}
	if FileAccess.file_exists(base + "frame-selection.json"):
		selection = JSON.parse_string(FileAccess.get_file_as_string(base + "frame-selection.json"))
	var states := {"idle": 4, "move": 6, "attack": 4, "death": 6}
	if id in ["zuggtmoy", "molydeus_chefe", "lu_yueh", "malcanthet", "socothbenoth", "sintese_abissal"]: states["special"] = 6
	var identity_path := base + id + "_idle_00_v%s.png" % identity_version
	var identity := Image.load_from_file(identity_path)
	if identity == null:
		push_error("Missing approved identity: " + id)
		quit(1)
		return
	var idle_rect := _body_rect(identity)
	var idle_height := float(idle_rect.size.y)
	var images := {}
	var transforms := {}
	var union := Rect2()
	for state in states:
		images[state] = []
		transforms[state] = []
		for index in states[state]:
			var path := base + "%s_%s_%02d_v01.png" % [id, state, index]
			for version in [2, 3]:
				var retry := base + "%s_%s_%02d_v%02d.png" % [id, state, index, version]
				if FileAccess.file_exists(retry): path = retry
			var frame_choice: Dictionary = selection.get("%s_%02d" % [state, index], {})
			var source_index := int(frame_choice.get("source_index", index))
			if source_index != index:
				path = base + "%s_%s_%02d_v01.png" % [id, state, source_index]
			if frame_choice.has("version"):
				path = base + "%s_%s_%02d_v%02d.png" % [id, state, source_index, int(frame_choice.version)]
			if state == "idle" and index == 0: path = identity_path
			var source := Image.load_from_file(path)
			if source == null:
				push_error("Missing frame: " + path)
				quit(1)
				return
			source.convert(Image.FORMAT_RGBA8)
			var rect := _body_rect(source)
			if rect.position.x == 0 or rect.position.y == 0 or rect.end.x >= source.get_width() or rect.end.y >= source.get_height():
				push_error("Clipped body: " + path)
				quit(1)
				return
			var pose_scale := float(identity.get_height()) / source.get_height()
			if state == "idle" or (state == "move" and id not in ["esporo_voador", "alma_penada", "ezro", "larva_de_lu_yueh"]):
				pose_scale = idle_height / rect.size.y
			pose_scale *= float(frame_choice.get("scale_multiplier", 1.0))
			var anchor := _ground_anchor(source, rect, state, id)
			# Permite ancorar o corpo quando uma arma da pose final passa abaixo dele.
			anchor.y += float(frame_choice.get("anchor_y_offset", 0.0))
			anchor.x += float(frame_choice.get("anchor_x_offset", 0.0))
			# Mesmo limiar de visibilidade da auditoria: ignora alfa residual no cálculo
			# da escala, mas preserva todos os canais ao amostrar o quadro final.
			var used := _visible_rect(source)
			var relative := Rect2((Vector2(used.position) - anchor) * pose_scale, Vector2(used.size) * pose_scale)
			union = relative if union.size == Vector2.ZERO else union.merge(relative)
			images[state].append(source)
			transforms[state].append({"anchor": anchor, "scale": pose_scale, "path": path})
	var fit := minf(106.0 / maxf(absf(union.position.x), union.end.x), 340.0 / maxf(1.0, -union.position.y))
	fit = minf(fit, 18.0 / maxf(1.0, union.end.y))
	print("Shedaklah ", id, " native_alpha=true fit=", fit, " body_height=", idle_height * fit, " union=", union)
	var output := base + "strips/"
	DirAccess.make_dir_recursive_absolute(output)
	var packing_record := {"id": id, "cell": [256, 384], "feet_y": 356, "body_height": idle_height * fit, "fit": fit, "native_alpha": true, "sources": transforms}
	var record_file := FileAccess.open(output + "packing.json", FileAccess.WRITE)
	record_file.store_string(JSON.stringify(packing_record, "\t"))
	record_file.close()
	var review := Image.create(1536, 384 * states.size(), false, Image.FORMAT_RGBA8)
	review.fill(Color("24242e"))
	var row := 0
	for state in states:
		var strip := Image.create(states[state] * 256, 384, false, Image.FORMAT_RGBA8)
		for index in states[state]:
			var source: Image = images[state][index]
			var transform: Dictionary = transforms[state][index]
			var scale: float = fit * transform.scale
			var frame := Image.create(256, 384, false, Image.FORMAT_RGBA8)
			for y in 384:
				for x in 256:
					var sample := (Vector2(x, y) - Vector2(128, 356)) / scale + Vector2(transform.anchor)
					var at := Vector2i(sample.floor())
					if at.x >= 0 and at.y >= 0 and at.x < source.get_width() and at.y < source.get_height():
						frame.set_pixel(x, y, source.get_pixelv(at))
			print(state, "_", index, " source=", transform.path, " body=", _body_rect(frame))
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

func _body_rect(image: Image) -> Rect2i:
	var minimum := image.get_size()
	var maximum := Vector2i(-1, -1)
	for y in image.get_height():
		for x in image.get_width():
			if image.get_pixel(x, y).a >= 0.9:
				minimum = minimum.min(Vector2i(x, y))
				maximum = maximum.max(Vector2i(x, y))
	return Rect2i(minimum, maximum - minimum + Vector2i.ONE)

func _visible_rect(image: Image) -> Rect2i:
	var minimum := image.get_size()
	var maximum := Vector2i(-1, -1)
	for y in image.get_height():
		for x in image.get_width():
			if image.get_pixel(x, y).a > 0.04:
				minimum = minimum.min(Vector2i(x, y))
				maximum = maximum.max(Vector2i(x, y))
	return Rect2i(minimum, maximum - minimum + Vector2i.ONE)

func _ground_anchor(image: Image, rect: Rect2i, state: String, id: String) -> Vector2:
	# A lança estendida não deve deslocar a origem do ator para o centro da arma.
	if state == "death" or id in ["esporo_voador", "alma_penada"]:
		return Vector2(rect.get_center().x, rect.end.y)
	var left := image.get_width()
	var right := -1
	var band := maxi(2, int(rect.size.y * 0.02))
	for y in range(rect.end.y - band, rect.end.y):
		for x in range(rect.position.x, rect.end.x):
			if image.get_pixel(x, y).a >= 0.9:
				left = mini(left, x)
				right = maxi(right, x)
	return Vector2((left + right) * 0.5, rect.end.y)
