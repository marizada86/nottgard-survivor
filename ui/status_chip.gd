class_name StatusChip
extends PanelContainer
## SPEC-147 (IN-064): indicador de estado do herói na HUD (hoje o Estige: na água, e o Esquecimento depois).
## Ícone, título, texto curto e dica ao passar o mouse; moldura colorida pelo tipo e pulso enquanto durar.

const KINDS := {
	"water": {"border": Color(0.35, 0.72, 1.0), "title_color": Color(0.6, 0.85, 1.0)},
	"forget": {"border": Color(0.78, 0.52, 1.0), "title_color": Color(0.85, 0.7, 1.0)},
}
const ICON_PATH := "res://assets/icons/stages/durao_current.png"

var kind := ""
var _icon: TextureRect
var _title: Label
var _text: Label
var _style: StyleBoxFlat

func _init() -> void:
	name = "StatusChip"
	visible = false
	mouse_filter = Control.MOUSE_FILTER_PASS
	_style = StyleBoxFlat.new()
	_style.bg_color = Color(0.05, 0.06, 0.1, 0.78)
	_style.set_border_width_all(2)
	_style.set_corner_radius_all(5)
	_style.content_margin_left = 8.0
	_style.content_margin_right = 12.0
	_style.content_margin_top = 4.0
	_style.content_margin_bottom = 4.0
	add_theme_stylebox_override("panel", _style)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(row)
	_icon = TextureRect.new()
	_icon.custom_minimum_size = Vector2(34, 34)
	_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if ResourceLoader.exists(ICON_PATH):
		_icon.texture = load(ICON_PATH)
	row.add_child(_icon)
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 0)
	col.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(col)
	_title = _label(15)
	col.add_child(_title)
	_text = _label(14)
	_text.add_theme_color_override("font_color", Color(0.92, 0.9, 0.86))
	col.add_child(_text)
	set_process(false)

func _label(size: int) -> Label:
	var l := Label.new()
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85))
	l.add_theme_constant_override("outline_size", 4)
	return l

## `status`: {} para esconder, ou {kind, title, text, tip}.
func show_status(status: Dictionary) -> void:
	if status.is_empty():
		kind = ""
		visible = false
		set_process(false)
		return
	kind = String(status.kind)
	var look: Dictionary = KINDS.get(kind, KINDS.water)
	_title.text = String(status.title)
	_title.add_theme_color_override("font_color", look.title_color)
	_text.text = String(status.text)
	tooltip_text = String(status.get("tip", ""))
	_style.border_color = look.border
	_icon.modulate = Color.WHITE if kind == "water" else Color(0.8, 0.6, 1.0, 0.85)
	visible = true
	set_process(true)

func _process(_dt: float) -> void:
	var pulse := 0.5 + 0.5 * sin(Time.get_ticks_msec() / 220.0)
	var look: Dictionary = KINDS.get(kind, KINDS.water)
	_style.border_color = Color(look.border, 0.55 + 0.45 * pulse)
