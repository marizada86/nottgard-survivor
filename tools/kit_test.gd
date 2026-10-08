extends Node
## Teste interativo do kit: F4, relato, log, print direto em evidencias/ e ZIP do F7.
## godot --path . res://tools/kit_test.tscn

const TEST_ROOT := "res://.atena/generated/playtest-kit-test"

func _ready() -> void:
	_cleanup_test_root()
	Game.profile.data.name = "Testador"
	Game.profile.data.welcome_seen = true
	Game.profile.data.coins = 0
	Playtest._evidence_dir = ProjectSettings.globalize_path(TEST_ROOT)
	Playtest._evidence_error = ""
	Playtest._logged_line_count = 0
	var fails: Array = []
	if not Playtest._prepare_evidence_dir():
		fails.append("nao criou evidencias para o teste")
	add_child(load("res://ui/menu.tscn").instantiate())
	await get_tree().create_timer(0.5).timeout
	var f4 := InputEventKey.new()
	f4.pressed = true
	f4.physical_keycode = KEY_F4
	if not Playtest.is_qa_shortcut(f4):
		fails.append("F4 nao reconhecido pelo Navegador QA")
	await Playtest.take_print()
	Playtest.open_note()
	Playtest._edit.text = "Nota de teste em %s do usuario %s" % [OS.get_user_data_dir(), OS.get_environment("USERNAME")]
	Playtest.close_note()
	Game.logline("log do teste de evidencias")
	var root := Playtest._evidence_dir
	if not FileAccess.file_exists(root.path_join("relato.txt")):
		fails.append("relato.txt nao foi criado")
	if not FileAccess.file_exists(root.path_join("logs/jogo.log")):
		fails.append("logs/jogo.log nao foi criado")
	var found_print := false
	for file in DirAccess.get_files_at(root.path_join("imagens")):
		if file.ends_with(".png"):
			found_print = true
	if not found_print:
		fails.append("F6 nao criou PNG em evidencias/imagens")
	var zip_folder := root.get_base_dir()
	var zips_before := _zips_in(zip_folder)
	Playtest.zip_evidence()
	var new_zips := _zips_in(zip_folder).filter(func(f): return not zips_before.has(f))
	if new_zips.size() != 1:
		fails.append("F7 deveria criar exatamente um ZIP ao lado de evidencias, criou %d" % new_zips.size())
	for zip_file in new_zips:
		DirAccess.remove_absolute(zip_folder.path_join(zip_file))
	if not FileAccess.file_exists(root.path_join("relato.txt")):
		fails.append("F7 nao pode mover o relato.txt")
	var relato := FileAccess.get_file_as_string(root.path_join("relato.txt"))
	if relato.contains(OS.get_environment("USERNAME")) and OS.get_environment("USERNAME").length() > 2:
		fails.append("relato.txt vazou o usuario do Windows")
	if Playtest.shortcut_action(_key(KEY_F5)) != &"note" or Playtest.shortcut_action(_key(KEY_F6)) != &"screenshot":
		fails.append("F5/F6 nao resolveram para as acoes esperadas")
	if Playtest.shortcut_action(_key(KEY_F7)) != &"zip":
		fails.append("F7 nao resolveu para a acao zip")
	print("kit: %s" % ("OK" if fails.is_empty() else str(fails)))
	_cleanup_test_root()
	get_tree().quit(1 if not fails.is_empty() else 0)

func _key(keycode: Key) -> InputEventKey:
	var event := InputEventKey.new()
	event.pressed = true
	event.physical_keycode = keycode
	return event

func _zips_in(folder: String) -> Array:
	return Array(DirAccess.get_files_at(folder)).filter(func(f): return String(f).begins_with("evidencias-") and String(f).ends_with(".zip"))

func _cleanup_test_root() -> void:
	var root := ProjectSettings.globalize_path(TEST_ROOT)
	for directory in [root.path_join("imagens"), root.path_join("logs")]:
		if DirAccess.dir_exists_absolute(directory):
			for file in DirAccess.get_files_at(directory):
				DirAccess.remove_absolute(directory.path_join(file))
			DirAccess.remove_absolute(directory)
	if DirAccess.dir_exists_absolute(root):
		for file in DirAccess.get_files_at(root):
			DirAccess.remove_absolute(root.path_join(file))
		DirAccess.remove_absolute(root)
