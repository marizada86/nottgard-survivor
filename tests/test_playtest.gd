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
	_assert_shortcut(failures, KEY_F7, &"")
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
	if guide.find("F7") >= 0 or guide.to_lower().find(".zip") >= 0:
		failures.append("guia de playtest ainda referencia F7 ou ZIP")
	if guide.find("F4 Navegador QA") < 0:
		failures.append("guia de playtest deveria explicar F4")
	return failures

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
