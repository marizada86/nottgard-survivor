extends SceneTree
## Prancha de revisão: preserva integralmente o alfa fornecido pelo gerador.

func _init() -> void:
	var ids := ["servo_de_zuggtmoy", "cogumelo_fungico", "esporo_voador", "slime_de_juiblex", "pudim_negro", "gargula", "receptaculo_de_juiblex", "zuggtmoy"]
	var version := "02"
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--version="):
			version = arg.substr(10)
	var review := Image.create(1280, 768, false, Image.FORMAT_RGBA8)
	for y in 768:
		for x in 1280:
			review.set_pixel(x, y, Color("34343c") if ((x / 16 + y / 16) % 2 == 0) else Color("24242e"))
	for index in ids.size():
		var id: String = ids[index]
		var path := "res://.atena/generated/art-candidates/enemies-shedaklah/%s/%s_idle_00_v%s.png" % [id, id, version]
		var source := Image.load_from_file(path)
		if source == null:
			push_error("Missing identity: " + path)
			quit(1)
			return
		var zero := 0
		var partial := 0
		for y in source.get_height():
			for x in source.get_width():
				var a := source.get_pixel(x, y).a
				if a == 0.0: zero += 1
				elif a < 250.5 / 255.0: partial += 1
		print(id, " size=", source.get_size(), " transparent=", zero, " partial=", partial)
		var fit := minf(300.0 / source.get_width(), 340.0 / source.get_height())
		source.resize(int(source.get_width() * fit), int(source.get_height() * fit), Image.INTERPOLATE_NEAREST)
		var column := index % 4
		var row := index / 4
		review.blend_rect(source, Rect2i(Vector2i.ZERO, source.get_size()), Vector2i(column * 320 + (320 - source.get_width()) / 2, row * 384 + 384 - source.get_height()))
	print("Shedaklah review result=", review.save_png("res://.atena/generated/priority-review/shedaklah_identities_v%s.png" % version))
	quit()
