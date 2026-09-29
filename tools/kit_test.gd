extends Node
## Teste interativo do kit: F4, relato, log e print direto em evidencias/.
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
	var found_zip := false
	for file in DirAccess.get_files_at(root):
		if file.ends_with(".zip"):
			found_zip = true
	if found_zip:
		fails.append("o kit nao pode criar ZIP")
	var relato := FileAccess.get_file_as_string(root.path_join("relato.txt"))
	if relato.contains(OS.get_environment("USERNAME")) and OS.get_environment("USERNAME").length() > 2:
		fails.append("relato.txt vazou o usuario do Windows")
	if Playtest.shortcut_action(_key(KEY_F5)) != &"note" or Playtest.shortcut_action(_key(KEY_F6)) != &"screenshot":
		fails.append("F5/F6 nao resolveram para as acoes esperadas")
	if Playtest.shortcut_action(_key(KEY_F7)) != &"":
		fails.append("F7 ainda possui acao")
	print("kit: %s" % ("OK" if fails.is_empty() else str(fails)))
	_cleanup_test_root()
	get_tree().quit(1 if not fails.is_empty() else 0)

func _key(keycode: Key) -> InputEventKey:
	var event := InputEventKey.new()
	event.pressed = true
	event.physical_keycode = keycode
	return event

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
