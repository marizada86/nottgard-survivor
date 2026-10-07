extends RefCounted

func run() -> Array:
	var failures: Array = []
	var original_profile: Profile = Game.profile
	var original_save: String = Game._save_path
	Game.profile = Profile.new({})
	Game._save_path = "res://.atena/generated/controller-experience/v01/unit-profile.json"
	var controls = Game.controls
	var device: int = controls.active_device
	var disconnected: bool = controls.disconnected
	var method: String = controls.method
	Game.profile.data.settings.controller = {}
	controls.active_device = -1
	controls.disconnected = false
	Game.ensure_input_actions()
	var up := InputEventJoypadButton.new()
	up.button_index = JOY_BUTTON_DPAD_UP
	up.pressed = true
	if not up.is_action_pressed(Game.ACTION_MOVE_UP) or up.is_action_pressed(Game.ACTION_RUN_SPEED):
		failures.append("direcional para cima deve mover sem mudar velocidade")
	up.button_index = JOY_BUTTON_Y
	if not up.is_action_pressed(Game.ACTION_RUN_AIM) or up.is_action_pressed(Game.ACTION_RUN_EXTRACT):
		failures.append("Y deve alternar mira sem extrair")
	Game.profile.data.settings.controller = {"preset": "legacy"}
	Game.ensure_input_actions()
	up.button_index = JOY_BUTTON_B
	if not up.is_action_pressed("ui_accept"):
		failures.append("preset Legado deve manter leste confirma")
	Game.profile.data.settings.controller = {}
	Game.ensure_input_actions()
	controls.method = "controller"
	for pair in [["Xbox Wireless Controller", "xbox"], ["DualShock 4", "ps4"], ["DualSense", "ps5"], ["Unknown Pad", "generic"]]:
		if controls.device_family(pair[0]) != pair[1]:
			failures.append("familia detectada incorretamente: " + pair[0])
	Game.profile.data.settings.controller = {"family": "ps5"}
	if controls.prompt("tab_previous", "Q") != "L1" or controls.prompt("tab_next", "E") != "R1":
		failures.append("abas PlayStation devem indicar L1/R1")
	if controls.glyph("tab_next") == null:
		failures.append("icone vetorial PlayStation ausente")
	if controls.remap_button("hero_active", JOY_BUTTON_X):
		failures.append("remapeamento deve rejeitar conflito com interagir")
	if controls.remap_button("hero_active", JOY_BUTTON_START):
		failures.append("pausa deve permanecer caminho de recuperacao")
	if not controls.remap_button("hero_active", JOY_BUTTON_LEFT_STICK):
		failures.append("remapeamento valido deve aceitar clique esquerdo")
	up.button_index = JOY_BUTTON_LEFT_STICK
	if not up.is_action_pressed("hero_active"):
		failures.append("remapeamento deve atingir a acao efetiva")
	controls.active_device = 2
	up.device = 3
	if controls.accepts(up):
		failures.append("segundo controle nao pode assumir comandos da sessao")
	controls._held[JOY_BUTTON_A] = true
	controls.transition()
	up.device = 2
	up.button_index = JOY_BUTTON_A
	if controls.accepts(up):
		failures.append("confirmar mantido nao pode atravessar modal")
	controls._held.clear()
	controls._blocked.clear()
	Game.profile = original_profile
	Game._save_path = original_save
	controls.active_device = device
	controls.disconnected = disconnected
	controls.method = method
	controls.axes_armed = true
	controls.capture_notice = ""
	Game.ensure_input_actions()
	return failures
