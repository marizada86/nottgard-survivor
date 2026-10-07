extends VBoxContainer
## Preferências locais de controle; reutilizadas no Quartel e na pausa.
var _preset: OptionButton
var _family: OptionButton
var _device: OptionButton
var _move: HSlider
var _aim: HSlider
var _notice: Label
var _reading: Label
var _bindings := {}
const LABELS := {"hero_active": "Habilidade", "run_interact": "Interagir", "run_toggle_aim": "Alternar mira", "run_items": "Ficha", "run_reroll": "Rerrolar", "offer_details": "Detalhes"}

func _ready() -> void:
	add_theme_constant_override("separation", 8)
	var heading := Label.new()
	heading.text = "CONTROLES"
	heading.add_theme_color_override("font_color", Color(0.9, 0.75, 0.42))
	add_child(heading)
	_preset = _choice("Convenção dos botões", ["Padrão — A/× confirma; B/○ volta", "Legado — B/○ confirma; A/× volta"])
	_preset.item_selected.connect(func(i):
		Game.controls.set_setting("preset", "standard" if i == 0 else "legacy")
		Game.controls.capture_notice = "Convenção atualizada. Os ícones acompanham sua escolha."
		_refresh())
	_family = _choice("Ícones", ["Automático", "Xbox", "PlayStation — DualShock 4", "PlayStation — DualSense", "Genérico"])
	_family.item_selected.connect(func(i): Game.controls.set_setting("family", ["auto", "xbox", "ps4", "ps5", "generic"][i]))
	_device = _choice("Controle ativo (Menu/Options reconecta na pausa)", [])
	_device.item_selected.connect(func(i): Game.controls.select_device(_device.get_item_id(i)))
	_move = _slider("Zona morta — movimento")
	_aim = _slider("Zona morta — mira")
	_move.value_changed.connect(func(v): Game.controls.set_setting("move_deadzone", v))
	_aim.value_changed.connect(func(v): Game.controls.set_setting("aim_deadzone", v))
	_reading = Label.new()
	_reading.add_theme_font_size_override("font_size", 14)
	add_child(_reading)
	for action in LABELS:
		var row := HBoxContainer.new()
		var label := Label.new()
		label.text = LABELS[action]
		label.custom_minimum_size.x = 150
		row.add_child(label)
		var binding := Button.new()
		binding.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		binding.pressed.connect(func(): Game.controls.begin_capture(action))
		row.add_child(binding)
		_bindings[action] = binding
		add_child(row)
	_notice = Label.new()
	_notice.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_notice.custom_minimum_size = Vector2(400, 40)
	add_child(_notice)
	var actions := HBoxContainer.new()
	for text in ["Cancelar remapeamento", "Restaurar controles"]:
		var button := Button.new()
		button.text = text
		button.pressed.connect(Game.controls.cancel_capture if text.begins_with("Cancelar") else Game.controls.restore_defaults)
		actions.add_child(button)
	add_child(actions)
	Game.controls.changed.connect(_refresh)
	_refresh()
	if Game.touch_controls_enabled():
		TouchUI.adapt_sizes(self)

func _choice(label_text: String, entries: Array) -> OptionButton:
	var label := Label.new()
	label.text = label_text
	add_child(label)
	var choice := OptionButton.new()
	for entry in entries:
		choice.add_item(entry)
	add_child(choice)
	return choice

func _slider(label_text: String) -> HSlider:
	var label := Label.new()
	label.text = label_text
	add_child(label)
	var slider := HSlider.new()
	slider.min_value = 0.1
	slider.max_value = 0.4
	slider.step = 0.01
	slider.custom_minimum_size = Vector2(340, 24)
	add_child(slider)
	return slider

func _refresh() -> void:
	_preset.select(1 if Game.controls.preset() == "legacy" else 0)
	_family.select(maxi(0, ["auto", "xbox", "ps4", "ps5", "generic"].find(Game.controls.settings().get("family", "auto"))))
	_move.set_value_no_signal(Game.controls.deadzone())
	_aim.set_value_no_signal(Game.controls.deadzone(true))
	_device.clear()
	for id in Input.get_connected_joypads():
		_device.add_item(Input.get_joy_name(id), id)
		if id == Game.controls.active_device:
			_device.select(_device.item_count - 1)
	_device.disabled = _device.item_count == 0
	if _device.item_count == 0:
		_device.add_item("Nenhum controle conectado")
	for action in _bindings:
		var binding: Button = _bindings[action]
		binding.text = "Pressione um botão…" if Game.controls.capture_action == action else Game.controls.button_name(Game.controls.button(action))
		binding.icon = Game.controls.glyph(action)
		binding.expand_icon = true
		binding.add_theme_constant_override("icon_max_width", 28)
	_notice.text = Game.controls.capture_notice if Game.controls.capture_notice != "" else "Remapear: pressione um botão novo. Abas dos detalhes: L1/LB anterior, R1/RB próxima."

func _process(_delta: float) -> void:
	if not is_visible_in_tree():
		return
	var device: int = Game.controls.active_device
	var left := Vector2.ZERO
	var right := Vector2.ZERO
	if device >= 0:
		left = Vector2(Input.get_joy_axis(device, JOY_AXIS_LEFT_X), Input.get_joy_axis(device, JOY_AXIS_LEFT_Y))
		right = Vector2(Input.get_joy_axis(device, JOY_AXIS_RIGHT_X), Input.get_joy_axis(device, JOY_AXIS_RIGHT_Y))
	_reading.text = "Repouso: esquerdo %.2f / direito %.2f   ·   zonas %.2f / %.2f" % [left.length(), right.length(), Game.controls.deadzone(), Game.controls.deadzone(true)]
