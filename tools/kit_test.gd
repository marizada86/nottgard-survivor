extends Node
## Teste do kit de playtest (precisa de janela): print, nota, F7 e leitura do .zip.
##   godot --path . res://tools/kit_test.tscn

func _ready() -> void:
	Game.profile.data.name = "Testador"
	Game.profile.data.welcome_seen = true
	Game.profile.data.coins = 0
	Playtest.items.clear()
	add_child(load("res://ui/menu.tscn").instantiate())
	await get_tree().create_timer(0.5).timeout
	var fails: Array = []
	print('a'); await Playtest.take_print(); print('b')
	await Playtest.open_note(); print('c')
	Playtest._edit.text = "Nota de teste em %s do usuário %s" % [OS.get_user_data_dir(), OS.get_environment("USERNAME")]
	Playtest.close_note(); print('d')
	if Playtest.items.size() != 2:
		fails.append("esperava 2 itens, veio %d" % Playtest.items.size())
	Playtest.export_zip()
	var dir := Playtest.out_dir()
	var found := ""
	for f in DirAccess.get_files_at(dir):
		if f.begins_with("EV-Testador-") and f.ends_with(".zip"):
			found = f
	if found == "":
		fails.append("zip não foi criado em %s" % dir)
	else:
		var zr := ZIPReader.new()
		zr.open("%s/%s" % [dir, found])
		var files := zr.get_files()
		for need in ["info.json", "log.txt", "notas.md"]:
			if not files.has(need):
				fails.append("zip sem %s" % need)
		if not Array(files).any(func(x): return x.begins_with("prints/")):
			fails.append("zip sem prints")
		var notes := zr.read_file("notas.md").get_string_from_utf8()
		if notes.contains(OS.get_environment("USERNAME")) and OS.get_environment("USERNAME").length() > 2:
			fails.append("notas.md vazou o usuário do Windows")
		print("zip: %s -> %s" % [found, str(files)])
		zr.close()
		DirAccess.remove_absolute("%s/%s" % [dir, found])
	if Playtest.items.size() != 0:
		fails.append("pacote não esvaziou")
	Playtest.export_zip()
	print("kit: %s" % ("OK" if fails.is_empty() else str(fails)))
	get_tree().quit(1 if not fails.is_empty() else 0)
