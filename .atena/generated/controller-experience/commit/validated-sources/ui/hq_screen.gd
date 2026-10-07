extends Control
## Leitor reutilizável de HQ; a cena permanece ativa enquanto a run está pausada.

signal closed

@onready var panel_image: TextureRect = %PanelImage
@onready var title_label: Label = %HqTitle
@onready var panel_counter: Label = %PanelCounter
@onready var caption_label: Label = %Caption

var panels: Array = []
var panel_index := 0
var is_closed := false
var completed := false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Game.controls.changed.connect(_update_hint)
	_update_hint()
	if Game.touch_controls_enabled():
		var bar := HBoxContainer.new()
		bar.position = Vector2(Game.touch_safe_rect().end.x - 280, Game.touch_safe_rect().position.y)
		var next := Button.new()
		next.text = "Próximo"
		next.custom_minimum_size = Vector2(140, 56)
		next.pressed.connect(advance)
		bar.add_child(next)
		var close := Button.new()
		close.text = "Fechar"
		close.custom_minimum_size = Vector2(120, 56)
		close.pressed.connect(finish)
		bar.add_child(close)
		add_child(bar)
		$ControlsHint.text = "Use Próximo para avançar ou Fechar para sair."
		TouchUI.prepare(self)

func start_hq(hq: Dictionary) -> void:
	Game.controls.transition()
	title_label.text = String(hq.get("title", ""))
	panels = hq.get("panels", [])
	panel_index = 0
	is_closed = false
	completed = false
	visible = true
	if panels.is_empty():
		finish()
		return
	_show_panel()

func advance() -> void:
	if is_closed:
		return
	if panel_index + 1 >= panels.size():
		completed = true
		finish()
		return
	panel_index += 1
	_show_panel()

func finish() -> void:
	if is_closed:
		return
	is_closed = true
	Game.controls.transition()
	visible = false
	closed.emit()

func _update_hint() -> void:
	$ControlsHint.text = "Use Próximo para avançar ou Fechar para sair." if Game.touch_controls_enabled() else "%s Avançar · %s Fechar" % [Game.controls.prompt("ui_accept", "Enter / Espaço / clique"), Game.controls.prompt("ui_cancel", "Esc")]

func _input(event: InputEvent) -> void:
	if is_closed or not Game.controls.accepts(event):
		return
	# O bloco de notas (F5) fica por cima da HQ e precisa receber espaço e clique.
	if Playtest.is_note_open():
		return
	if event is InputEventJoypadButton and event.pressed:
		if event.is_action_pressed("ui_cancel"):
			finish()
			Game.controls.transition()
			get_viewport().set_input_as_handled()
		elif event.is_action_pressed("ui_accept"):
			advance()
			Game.controls.transition()
			get_viewport().set_input_as_handled()
		return
	if Game.touch_controls_enabled() and event is InputEventMouse:
		return
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			finish()
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER or event.keycode == KEY_SPACE:
			advance()
			get_viewport().set_input_as_handled()
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		advance()
		get_viewport().set_input_as_handled()

func _show_panel() -> void:
	var panel: Dictionary = panels[panel_index]
	var image_path := String(panel.get("image", ""))
	panel_image.texture = load(image_path) as Texture2D if ResourceLoader.exists(image_path) else null
	caption_label.text = String(panel.get("text", ""))
	panel_counter.text = "Quadro %d de %d" % [panel_index + 1, panels.size()]
