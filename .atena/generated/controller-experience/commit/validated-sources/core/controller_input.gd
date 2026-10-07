extends Node
## Entrada local por dispositivo, bindings e prompts (SPEC-135).
signal changed
signal recovery_requested(reason: String)

const DEFAULT_BUTTONS := {"hero_active": JOY_BUTTON_RIGHT_SHOULDER, "run_interact": JOY_BUTTON_X,
	"run_toggle_aim": JOY_BUTTON_Y, "run_items": JOY_BUTTON_BACK,
	"run_reroll": JOY_BUTTON_LEFT_SHOULDER, "offer_details": JOY_BUTTON_RIGHT_STICK}
const CONTEXTS := [["hero_active", "run_interact", "run_toggle_aim", "run_items"], ["run_reroll", "offer_details", "run_items"]]
const BUTTON_NAMES := {0: "A", 1: "B", 2: "X", 3: "Y", 4: "View", 6: "Menu", 7: "LS", 8: "RS", 9: "LB", 10: "RB"}
var active_device := -1
var method := "keyboard"
var disconnected := false
var capture_action := ""
var capture_notice := ""
var axes_armed := true
var _held := {}
var _blocked := {}
var _repeat_action := ""
var _repeat_time := 0.0
var _mouse_position := Vector2.INF
var focused := true

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Input.joy_connection_changed.connect(connection_changed)
	Input.set("ignore_joypad_on_unfocused_application", true)
	set_process_input(true)

func settings() -> Dictionary:
	if Game.profile == null:
		return {}
	return Game.profile.data.settings.get("controller", {})

func button(action: String) -> int:
	return int(settings().get("bindings", {}).get(action, DEFAULT_BUTTONS.get(action, -1)))

func preset() -> String:
	return String(settings().get("preset", "standard"))

func deadzone(aim: bool = false) -> float:
	return clampf(float(settings().get("aim_deadzone" if aim else "move_deadzone", 0.24)), 0.1, 0.4)

static func device_family(device_name: String) -> String:
	var name_lower := device_name.to_lower()
	if "dualsense" in name_lower or "ps5" in name_lower:
		return "ps5"
	if "dualshock" in name_lower or "ps4" in name_lower or "sony" in name_lower or "playstation" in name_lower:
		return "ps4"
	if "xbox" in name_lower or "xinput" in name_lower or "x-box" in name_lower:
		return "xbox"
	return "generic"

func family() -> String:
	var override := String(settings().get("family", "auto"))
	if override != "auto":
		return override
	return device_family(Input.get_joy_name(active_device)) if active_device >= 0 else "generic"

func is_controller() -> bool:
	return method == "controller"

func button_name(index: int) -> String:
	if family() in ["ps4", "ps5"]:
		return String({0: "×", 1: "○", 2: "□", 3: "△", 4: "Create" if family() == "ps5" else "Share", 6: "Options", 7: "L3", 8: "R3", 9: "L1", 10: "R1"}.get(index, "Botão %d" % index))
	if family() == "generic":
		return String({0: "Sul", 1: "Leste", 2: "Oeste", 3: "Norte", 4: "Voltar central", 6: "Menu", 7: "Clique esquerdo", 8: "Clique direito", 9: "Ombro esquerdo", 10: "Ombro direito"}.get(index, "Botão %d" % index))
	return String(BUTTON_NAMES.get(index, "Botão %d" % index))

func action_button(action: String) -> int:
	if action == "ui_accept":
		return JOY_BUTTON_B if preset() == "legacy" else JOY_BUTTON_A
	if action == "ui_cancel":
		return JOY_BUTTON_A if preset() == "legacy" else JOY_BUTTON_B
	if action == "run_pause":
		return JOY_BUTTON_START
	if action == "tab_previous":
		return JOY_BUTTON_LEFT_SHOULDER
	if action == "tab_next":
		return JOY_BUTTON_RIGHT_SHOULDER
	return button(action)

func prompt(action: String, keyboard: String) -> String:
	return button_name(action_button(action)) if is_controller() else keyboard

func glyph(action: String) -> Texture2D:
	if not is_controller():
		return null
	var path := "res://assets/icons/controller/%s/%d.svg" % [family(), action_button(action)]
	return load(path) if ResourceLoader.exists(path) else null

func set_setting(key: String, value: Variant) -> void:
	var config := settings().duplicate(true)
	config[key] = value
	Game.profile.data.settings.controller = config
	Game.ensure_input_actions()
	Game.save()
	changed.emit()

func remap_button(action: String, index: int) -> bool:
	if not DEFAULT_BUTTONS.has(action) or index not in [2, 3, 4, 7, 8, 9, 10]:
		capture_notice = "Botão reservado; use um botão de ação, ombro ou clique do analógico."
		return false
	for context in CONTEXTS:
		if action in context:
			for other in context:
				if other != action and button(other) == index:
					capture_notice = "Conflito com %s. Escolha outro botão." % other
					return false
	var bindings: Dictionary = settings().get("bindings", {}).duplicate()
	bindings[action] = index
	set_setting("bindings", bindings)
	return true

func begin_capture(action: String) -> void:
	capture_action = action
	capture_notice = "Pressione um novo botão; Voltar cancela."
	transition()
	changed.emit()

func cancel_capture() -> void:
	capture_action = ""
	capture_notice = "Remapeamento cancelado."
	changed.emit()

func restore_defaults() -> void:
	Game.profile.data.settings.controller = {}
	Game.ensure_input_actions()
	Game.save()
	cancel_capture()
	changed.emit()

func select_device(device: int) -> void:
	active_device = device
	disconnected = false
	transition()
	Game.ensure_input_actions()
	changed.emit()

func accepts(event: InputEvent) -> bool:
	if not focused:
		return false
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		var intentional: bool = event.pressed if event is InputEventJoypadButton else absf(event.axis_value) > deadzone(event.axis in [JOY_AXIS_RIGHT_X, JOY_AXIS_RIGHT_Y])
		if active_device < 0 and intentional and not disconnected:
			active_device = event.device
			Game.ensure_input_actions()
		if disconnected or (active_device >= 0 and event.device != active_device):
			return false
		if event is InputEventJoypadButton and _blocked.has(event.button_index):
			return false
		if event is InputEventJoypadButton:
			if event.pressed:
				_held[event.button_index] = true
			else:
				_held.erase(event.button_index)
		if intentional and method != "controller":
			method = "controller"
			changed.emit()
	elif event is InputEventKey and event.pressed and not event.echo and method != "keyboard":
		method = "keyboard"
		changed.emit()
	return true

func transition() -> void:
	_blocked = _held.duplicate()
	if active_device >= 0:
		for index in 21:
			if Input.is_joy_button_pressed(active_device, index):
				_blocked[index] = true
	axes_armed = false
	_repeat_action = ""
	for action in ["joy_move_left", "joy_move_right", "joy_move_up", "joy_move_down", "joy_aim_left", "joy_aim_right", "joy_aim_up", "joy_aim_down", "hero_active"]:
		Input.action_release(action)

func connection_changed(device: int, connected: bool) -> void:
	if not connected and device == active_device:
		transition()
		_held.clear()
		active_device = -1
		disconnected = true
		Game.ensure_input_actions()
		recovery_requested.emit("Controle desconectado. Reconecte e selecione o controle antes de continuar.")
	changed.emit()

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		focused = false
		transition()
		recovery_requested.emit("Jogo pausado ao perder foco.")
	elif what == NOTIFICATION_APPLICATION_FOCUS_IN:
		focused = true

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if disconnected and event is InputEventJoypadButton and event.pressed and event.button_index == JOY_BUTTON_START and event.device in Input.get_connected_joypads():
			select_device(event.device)
			capture_notice = "Controle selecionado. Use Continuar para retomar."
			get_viewport().set_input_as_handled()
			return
		var intent: bool = event.pressed if event is InputEventJoypadButton else absf(event.axis_value) > deadzone(event.axis in [JOY_AXIS_RIGHT_X, JOY_AXIS_RIGHT_Y])
		if active_device < 0 and intent and not disconnected:
			active_device = event.device
			Game.ensure_input_actions()
		if not accepts(event):
			if event is InputEventJoypadButton and not event.pressed and event.device == active_device:
				_held.erase(event.button_index)
				_blocked.erase(event.button_index)
			get_viewport().set_input_as_handled()
			return
		if event is InputEventJoypadButton:
			if event.pressed:
				_held[event.button_index] = true
			else:
				_held.erase(event.button_index)
		if intent and method != "controller":
			method = "controller"
			changed.emit()
		if capture_action != "":
			if event is InputEventJoypadButton and event.pressed:
				if event.button_index == action_button("ui_cancel"):
					cancel_capture()
				elif remap_button(capture_action, event.button_index):
					capture_action = ""
					capture_notice = "Botão atualizado."
					changed.emit()
			get_viewport().set_input_as_handled()
			return
		for direction in ["ui_left", "ui_right", "ui_up", "ui_down"]:
			if event.is_action_pressed(direction):
				_repeat_action = direction
				_repeat_time = 0.35
			elif event.is_action_released(direction) and _repeat_action == direction:
				_repeat_action = ""
	elif event is InputEventKey and event.pressed and not event.echo:
		if capture_action != "" and event.is_action_pressed("ui_cancel"):
			cancel_capture()
			get_viewport().set_input_as_handled()
		if method != "keyboard":
			method = "keyboard"
			changed.emit()
	elif event is InputEventScreenTouch and event.pressed:
		method = "touch"
		changed.emit()
	elif event is InputEventMouse and event.device != InputEvent.DEVICE_ID_EMULATION:
		var intent: bool = event is InputEventMouseButton and event.pressed
		if event is InputEventMouseMotion:
			intent = event.relative.length() > 2.0
		if intent and method != "keyboard":
			method = "keyboard"
			changed.emit()

func _process(delta: float) -> void:
	if _repeat_action == "" or not focused or capture_action != "":
		return
	_repeat_time -= delta
	if _repeat_time > 0.0:
		return
	_repeat_time = 0.12
	var owner := get_viewport().gui_get_focus_owner()
	if owner == null or not owner.is_visible_in_tree():
		return
	var key := InputEventKey.new()
	key.keycode = {"ui_left": KEY_LEFT, "ui_right": KEY_RIGHT, "ui_up": KEY_UP, "ui_down": KEY_DOWN}[_repeat_action]
	key.pressed = true
	key.echo = true
	# Direto ao controle focado: repetir navegação nunca chega ao combate ou confirma.
	get_viewport().push_input(key, true)
	key = key.duplicate()
	key.pressed = false
	get_viewport().push_input(key, true)

func stick(aim: bool = false) -> Vector2:
	if not focused or disconnected or active_device < 0:
		return Vector2.ZERO
	var raw := Vector2(Input.get_joy_axis(active_device, JOY_AXIS_RIGHT_X if aim else JOY_AXIS_LEFT_X), Input.get_joy_axis(active_device, JOY_AXIS_RIGHT_Y if aim else JOY_AXIS_LEFT_Y))
	var digital := Vector2(float(Input.is_joy_button_pressed(active_device, JOY_BUTTON_DPAD_RIGHT)) - float(Input.is_joy_button_pressed(active_device, JOY_BUTTON_DPAD_LEFT)), float(Input.is_joy_button_pressed(active_device, JOY_BUTTON_DPAD_DOWN)) - float(Input.is_joy_button_pressed(active_device, JOY_BUTTON_DPAD_UP)))
	if not axes_armed:
		var left := Vector2(Input.get_joy_axis(active_device, JOY_AXIS_LEFT_X), Input.get_joy_axis(active_device, JOY_AXIS_LEFT_Y))
		var right := Vector2(Input.get_joy_axis(active_device, JOY_AXIS_RIGHT_X), Input.get_joy_axis(active_device, JOY_AXIS_RIGHT_Y))
		axes_armed = left.length() <= deadzone() and right.length() <= deadzone(true) and digital == Vector2.ZERO
		return Vector2.ZERO
	if not aim and digital != Vector2.ZERO:
		return digital.limit_length()
	return Game.stick_vector(raw, deadzone(aim))
