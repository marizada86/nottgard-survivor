extends RefCounted

const PlaytestScript := preload("res://core/playtest.gd")

func run() -> Array:
	var failures: Array = []
	_assert_panel_size(failures, Vector2(1280, 720), Vector2(820, 560))
	_assert_panel_size(failures, Vector2(375, 667), Vector2(327, 560))
	_assert_panel_size(failures, Vector2(320, 480), Vector2(272, 432))
	_assert_shortcut(failures, KEY_F5, &"note")
	_assert_shortcut(failures, KEY_F6, &"screenshot")
	_assert_shortcut(failures, KEY_F7, &"export")
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
	return failures

func _assert_panel_size(failures: Array, viewport_size: Vector2, expected: Vector2) -> void:
	if PlaytestScript.guide_panel_size(viewport_size) != expected:
		failures.append("modal em %s deveria medir %s, recebeu %s" % [viewport_size, expected, PlaytestScript.guide_panel_size(viewport_size)])

func _assert_shortcut(failures: Array, keycode: Key, expected: StringName) -> void:
	var event := InputEventKey.new()
	event.pressed = true
	event.physical_keycode = keycode
	if PlaytestScript.shortcut_action(event) != expected:
		failures.append("atalho %s deveria ser %s" % [keycode, expected])
