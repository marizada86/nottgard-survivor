extends RefCounted

const PlaytestScript := preload("res://core/playtest.gd")

func run() -> Array:
	var failures: Array = []
	_assert_panel_size(failures, Vector2(1280, 720), Vector2(820, 560))
	_assert_panel_size(failures, Vector2(375, 667), Vector2(327, 560))
	_assert_panel_size(failures, Vector2(320, 480), Vector2(272, 432))
	_assert_note_panel_size(failures, Vector2(1280, 720), Vector2(760, 470))
	_assert_note_panel_size(failures, Vector2(320, 480), Vector2(272, 432))
	_assert_shortcut(failures, KEY_F5, &"note")
	_assert_shortcut(failures, KEY_F6, &"screenshot")
	_assert_shortcut(failures, KEY_F7, &"zip")
	_assert_shortcut(failures, KEY_F8, &"")
	_assert_shortcut(failures, KEY_F11, &"fullscreen")
	_assert_shortcut(failures, KEY_F12, &"console")
	_assert_shortcut(failures, KEY_ESCAPE, &"")
	for destination in PlaytestScript.qa_run_destinations():
		if String(destination[1]).begins_with("menu_"):
			failures.append("Abrir destino nao pode enviar a fase selecionada ao Quartel")
	var qa_key := InputEventKey.new()
	qa_key.pressed = true
	qa_key.physical_keycode = KEY_P
	qa_key.ctrl_pressed = true
	if not PlaytestScript.is_qa_shortcut(qa_key, true):
		failures.append("Ctrl+O+P nao abriu o atalho QA")
	if PlaytestScript.is_qa_shortcut(qa_key, false):
		failures.append("Ctrl+P sem O nao pode abrir o atalho QA")
	qa_key.ctrl_pressed = false
	if PlaytestScript.is_qa_shortcut(qa_key, true):
		failures.append("O+P sem Ctrl nao pode abrir o atalho QA")
	var qa_f4 := InputEventKey.new()
	qa_f4.pressed = true
	qa_f4.physical_keycode = KEY_F4
	if not PlaytestScript.is_qa_shortcut(qa_f4):
		failures.append("F4 nao abriu o atalho QA")
	if not PlaytestScript.should_handle_qa_shortcut(qa_f4, true, true):
		failures.append("F4 deveria fechar o navegador mesmo com foco em um controle QA")
	if PlaytestScript.should_handle_qa_shortcut(qa_f4, false, true):
		failures.append("F4 nao deveria abrir o navegador com outro controle em foco")
	if not PlaytestScript.should_handle_qa_shortcut(qa_f4, false, false):
		failures.append("F4 deveria abrir o navegador quando nenhum controle tem foco")
	var open_pause := PlaytestScript.qa_browser_pause_transition(true, false, false)
	var close_pause := PlaytestScript.qa_browser_pause_transition(false, bool(open_pause.paused_before), true)
	var open_existing_pause := PlaytestScript.qa_browser_pause_transition(true, false, true)
	var keep_existing_pause := PlaytestScript.qa_browser_pause_transition(false, bool(open_existing_pause.paused_before), true)
	if not bool(open_pause.tree_paused) or bool(close_pause.tree_paused):
		failures.append("F4 deveria pausar durante o navegador e retomar após fechar")
	if not bool(open_existing_pause.tree_paused) or not bool(keep_existing_pause.tree_paused):
		failures.append("fechar F4 nao deveria retomar um jogo que ja estava pausado")
	if not PlaytestScript.qa_run_destinations().any(func(destination): return String(destination[1]) == "comic_preview"):
		failures.append("destino QA deveria incluir prévia direta de quadrinho")
	var hqs: Dictionary = Data.table("hqs")
	var docas_comics := PlaytestScript.qa_comic_ids_for_stage(hqs, "docas")
	var shedaklah_comics := PlaytestScript.qa_comic_ids_for_stage(hqs, "shedaklah")
	if docas_comics[0] != "hqn_02":
		failures.append("HQ da fase selecionada deveria vir primeiro para Docas")
	if shedaklah_comics[0] != "hqn_03" or shedaklah_comics[1] != "hqn_04":
		failures.append("Shedaklah deveria priorizar HQN-03 e HQN-04 na ordem de campanha")
	if shedaklah_comics.size() != 14 or not shedaklah_comics.has("hqn_01") or not shedaklah_comics.has("hqn_14"):
		failures.append("todas as HQN-01 a HQN-14 deveriam continuar acessíveis na lista QA")
	var evidence_dir := PlaytestScript.evidence_directory_for_executable("C:/playtest/NottgardSurvivors.exe")
	if evidence_dir != "C:/playtest/evidencias":
		failures.append("evidencias deveria ficar ao lado do executavel, recebeu %s" % evidence_dir)
	for path in ["relato.txt", "logs/jogo.log", "imagens/print-2026-09-29-010203.png"]:
		if not PlaytestScript.is_allowed_evidence_path(path):
			failures.append("extensao permitida rejeitada: %s" % path)
	for path in ["manifest.json", "pacote.zip", "video.mp4", "save.dat", "NottgardSurvivors.exe"]:
		if PlaytestScript.is_allowed_evidence_path(path):
			failures.append("extensao proibida aceita: %s" % path)
	var rules := PlaytestScript.game_rules_text()
	if rules.find("Seu nome") >= 0 or rules.find("[b]Objetivo[/b]") < 0 or rules.find("[b]Progresso[/b]") < 0:
		failures.append("ajuda de regras deveria explicar o jogo sem pedir nome")
	var guide := PlaytestScript._guide_text()
	if guide.find("F7") < 0 or guide.find("ZIP") < 0:
		failures.append("guia de playtest deveria explicar o F7 e o ZIP")
	_check_evidence_zip(failures)
	if PlaytestScript.qa_shortcuts_text(true).find("F4 Navegador QA") < 0:
		failures.append("guia QA deveria explicar F4")
	if PlaytestScript.qa_shortcuts_text(false).find("F4 Navegador QA") >= 0:
		failures.append("guia publico nao deveria anunciar o atalho do Navegador QA")
	return failures

func _check_evidence_zip(failures: Array) -> void:
	var base := "user://test_evidence_zip"
	var root := base.path_join("evidencias")
	_remove_tree(base)
	DirAccess.make_dir_recursive_absolute(root.path_join("logs"))
	DirAccess.make_dir_recursive_absolute(root.path_join("imagens"))
	if PlaytestScript.build_evidence_zip(root, base.path_join("vazio.zip")) != 0 or FileAccess.file_exists(base.path_join("vazio.zip")):
		failures.append("pasta sem arquivos nao deveria gerar ZIP")
	var contents := {"relato.txt": "nota", "logs/jogo.log": "linha", "imagens/print-1.png": "png", "logs/save.dat": "x", "manifest.json": "{}"}
	for rel in contents:
		var f := FileAccess.open(root.path_join(rel), FileAccess.WRITE)
		f.store_string(contents[rel])
		f.close()
	var dt := {"year": 2026, "month": 10, "day": 7, "hour": 1, "minute": 2, "second": 3}
	var first := PlaytestScript.unique_zip_path(base, dt)
	if first.get_file() != "evidencias-2026-10-07-010203.zip":
		failures.append("nome do ZIP inesperado: %s" % first.get_file())
	if PlaytestScript.build_evidence_zip(root, first) != 3:
		failures.append("ZIP deveria conter so os 3 arquivos permitidos")
	var second := PlaytestScript.unique_zip_path(base, dt)
	if second == first or second.get_file() != "evidencias-2026-10-07-010203-02.zip":
		failures.append("segundo ZIP no mesmo segundo nao pode sobrescrever o primeiro: %s" % second.get_file())
	if PlaytestScript.build_evidence_zip(root, second) != 3:
		failures.append("segundo ZIP nao deveria incluir o primeiro")
	var reader := ZIPReader.new()
	if reader.open(first) != OK:
		failures.append("ZIP nao abriu para leitura")
	else:
		var names := Array(reader.get_files()).filter(func(n): return not String(n).ends_with("/"))
		names.sort()
		if names != ["evidencias/imagens/print-1.png", "evidencias/logs/jogo.log", "evidencias/relato.txt"]:
			failures.append("conteudo do ZIP inesperado: %s" % [names])
		elif reader.read_file("evidencias/relato.txt").get_string_from_utf8() != "nota":
			failures.append("conteudo de relato.txt corrompido no ZIP")
		reader.close()
	for rel in ["relato.txt", "logs/jogo.log", "imagens/print-1.png"]:
		if not FileAccess.file_exists(root.path_join(rel)):
			failures.append("original %s nao pode ser movido nem apagado" % rel)
	_remove_tree(base)

func _remove_tree(path: String) -> void:
	var dir := DirAccess.open(path)
	if dir == null:
		return
	for sub in dir.get_directories():
		_remove_tree(path.path_join(sub))
	for file_name in dir.get_files():
		DirAccess.remove_absolute(path.path_join(file_name))
	DirAccess.remove_absolute(path)

func _assert_panel_size(failures: Array, viewport_size: Vector2, expected: Vector2) -> void:
	if PlaytestScript.guide_panel_size(viewport_size) != expected:
		failures.append("modal em %s deveria medir %s, recebeu %s" % [viewport_size, expected, PlaytestScript.guide_panel_size(viewport_size)])

func _assert_note_panel_size(failures: Array, viewport_size: Vector2, expected: Vector2) -> void:
	if PlaytestScript.note_panel_size(viewport_size) != expected:
		failures.append("bloco F5 em %s deveria medir %s, recebeu %s" % [viewport_size, expected, PlaytestScript.note_panel_size(viewport_size)])

func _assert_shortcut(failures: Array, keycode: Key, expected: StringName) -> void:
	var event := InputEventKey.new()
	event.pressed = true
	event.physical_keycode = keycode
	if PlaytestScript.shortcut_action(event) != expected:
		failures.append("atalho %s deveria ser %s" % [keycode, expected])
