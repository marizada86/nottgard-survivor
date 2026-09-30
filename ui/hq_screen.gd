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

func start_hq(hq: Dictionary) -> void:
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
	visible = false
	closed.emit()

func _input(event: InputEvent) -> void:
	if is_closed:
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
