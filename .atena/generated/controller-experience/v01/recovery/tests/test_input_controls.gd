extends RefCounted

func run() -> Array:
	var failures: Array = []
	Game.ensure_input_actions()
	for action in [Game.ACTION_MOVE_LEFT, Game.ACTION_MOVE_RIGHT, Game.ACTION_MOVE_UP, Game.ACTION_MOVE_DOWN,
		Game.ACTION_AIM_LEFT, Game.ACTION_AIM_RIGHT, Game.ACTION_AIM_UP, Game.ACTION_AIM_DOWN,
		Game.ACTION_RUN_PAUSE, Game.ACTION_RUN_AIM, Game.ACTION_RUN_INTERACT, Game.ACTION_RUN_EXTRACT,
		Game.ACTION_RUN_ITEMS, Game.ACTION_RUN_SPEED, Game.ACTION_RUN_REROLL, Game.ACTION_OFFER_DETAILS]:
		if not InputMap.has_action(action):
			failures.append("ação ausente: %s" % action)
	if Game.stick_vector(Vector2(0.1, 0.0)) != Vector2.ZERO:
		failures.append("zona morta deveria anular deriva pequena")
	var full := Game.stick_vector(Vector2(1.0, 0.0))
	if not is_equal_approx(full.x, 1.0) or not is_zero_approx(full.y):
		failures.append("analógico máximo deveria preservar direção e intensidade")
	var diagonal := Game.stick_vector(Vector2(0.8, 0.8))
	if diagonal.length() > 1.001 or diagonal.length() <= 0.0:
		failures.append("analógico diagonal deveria ser normalizado dentro do limite")
	_assert_joy_action(failures, JOY_BUTTON_RIGHT_SHOULDER, &"hero_active")
	_assert_joy_action(failures, JOY_BUTTON_START, Game.ACTION_RUN_PAUSE)
	_assert_joy_action(failures, JOY_BUTTON_X, Game.ACTION_RUN_INTERACT)
	_assert_joy_action(failures, JOY_BUTTON_LEFT_SHOULDER, Game.ACTION_RUN_REROLL)
	_assert_joy_action(failures, JOY_BUTTON_B, &"ui_accept")
	_assert_joy_action(failures, JOY_BUTTON_A, &"ui_cancel")
	_assert_joy_action(failures, JOY_BUTTON_DPAD_LEFT, &"ui_left")
	_assert_joy_action(failures, JOY_BUTTON_DPAD_DOWN, &"ui_down")
	return failures


func _assert_joy_action(failures: Array, button: JoyButton, action: StringName) -> void:
	var event := InputEventJoypadButton.new()
	event.button_index = button
	event.pressed = true
	if not InputMap.event_is_action(event, action):
		failures.append("botão %s deveria disparar %s" % [button, action])
