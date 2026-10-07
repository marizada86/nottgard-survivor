extends Node
## Visibilidade e inicio real da tentativa; perfil descartavel.
const OUTPUT := "res://.atena/generated/controller-experience/v02/"
var checks: Array[Dictionary] = []
var failures: Array[String] = []
@onready var root: Window = get_tree().root

func _ready() -> void:
	call_deferred("_check")
	get_tree().create_timer(90).timeout.connect(func(): get_tree().quit(2))

func _frames(count: int = 6) -> void:
	for i in count:
		await get_tree().process_frame

func _record(id: String, passed: bool) -> void:
	checks.append({"id": id, "passed": passed})
	if not passed:
		failures.append(id)
	print("menu start ", id, ": ", "PASS" if passed else "FAIL")

func _button(index: int) -> void:
	for pressed in [true, false]:
		var event := InputEventJoypadButton.new()
		event.device = 0
		event.button_index = index
		event.pressed = pressed
		root.push_input(event, true)
		await _frames(2)

func _shot(name: String) -> void:
	if "--menu-capture" not in OS.get_cmdline_user_args():
		return
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(OUTPUT + name + ".png")

func _check() -> void:
	get_tree().current_scene = null
	var signature := Game.real_save_signature()
	Game._save_path = OUTPUT + "menu-test-profile.json"
	Input.use_accumulated_input = false
	if Playtest._guide_open:
		Playtest._close_guide_modal()
	for mode in ["standard", "legacy", "mouse", "touch"]:
		Game.profile = Profile.new({"name": "Teste acesso Jogar", "welcome_seen": true})
		for id in Data.table("hqs"):
			Game.profile.data.hqs_seen[id] = true
		Game.touch_preview = mode == "touch"
		Game.profile.data.settings.controller = {"family": "xbox", "preset": "legacy" if mode == "legacy" else "standard"}
		Game.controls._held.clear()
		Game.controls._blocked.clear()
		Game.controls.method = "keyboard" if mode in ["mouse", "touch"] else "controller"
		Game.controls.active_device = 0
		Game.controls.focused = true
		Game.controls.disconnected = false
		Game.ensure_input_actions()
		Game.goto_menu()
		await _frames(12)
		var menu = get_tree().current_scene
		var button: Button = menu.play_btn
		_record(mode + "_habilitado", not button.disabled and button.is_visible_in_tree())
		if mode == "standard":
			for size in [Vector2i(1280, 720), Vector2i(1600, 900), Vector2i(1920, 1080), Vector2i(1024, 768), Vector2i(1280, 600), Vector2i(960, 540)]:
				root.size = size
				await _frames(12)
				_record("visivel_%dx%d" % [size.x, size.y], menu.get_viewport_rect().encloses(button.get_global_rect()))
				await _shot("quartel_%dx%d" % [size.x, size.y])
			root.size = Vector2i(1280, 720)
			await _frames()
			var old_min: Vector2 = menu.stage_list.custom_minimum_size
			menu.stage_list.custom_minimum_size.y = 900
			await _frames()
			_record("conteudo_excedente_nao_oculta_jogar", menu.get_viewport_rect().encloses(button.get_global_rect()))
			menu.stage_list.custom_minimum_size = old_min
			menu.get_node("Tabs").current_tab = 1
			await _frames()
			_record("jogar_oculto_outras_abas", not button.visible)
			menu.get_node("Tabs").current_tab = 0
			await _frames()
		if mode in ["standard", "legacy"]:
			await _button(JOY_BUTTON_DPAD_RIGHT)
			await _button(JOY_BUTTON_DPAD_RIGHT)
			_record(mode + "_alcancavel_direcional", root.gui_get_focus_owner() == button)
			_record("icone_b_legado" if mode == "legacy" else "icone_a", button.icon != null and button.tooltip_text.begins_with("B " if mode == "legacy" else "A "))
			await _button(JOY_BUTTON_B if mode == "legacy" else JOY_BUTTON_A)
		else:
			await _frames()
			var point := button.get_global_rect().get_center()
			for pressed in [true, false]:
				var event := InputEventMouseButton.new()
				event.position = point
				event.global_position = point
				event.button_index = MOUSE_BUTTON_LEFT
				event.pressed = pressed
				event.device = InputEvent.DEVICE_ID_EMULATION if mode == "touch" else 0
				root.push_input(event, true)
				await _frames(2)
		await _frames(14)
		var run = get_tree().current_scene
		_record(mode + "_inicia_tentativa", Game.screen_name == "run" and run.get("battle") != null)
	Game.touch_preview = false
	_record("perfil_real_preservado", signature == Game.real_save_signature())
	var file := FileAccess.open(OUTPUT + "menu-start-report.json", FileAccess.WRITE)
	file.store_string(JSON.stringify({"checks": checks, "failures": failures, "synthetic_input": true, "hardware_acceptance": false}, "\t"))
	print("menu start: %d verificacoes; %d falha(s)" % [checks.size(), failures.size()])
	get_tree().quit(0 if failures.is_empty() else 1)
