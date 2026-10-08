class_name EcoBanner
extends PanelContainer
## SPEC-152 (MEC-039): faixa do Eco de Nottgard. Aparece embaixo, no centro, por `faixa_segundos` (6 s), sem pausar nem
## bloquear o jogo, com o texto completo e a fonte do Vault. O texto vai inteiro para o Diário no Quartel.

var _title: Label
var _text: Label
var _source: Label
var _tween: Tween

func _init() -> void:
	name = "EcoBanner"
	visible = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.06, 0.04, 0.1, 0.88)
	style.border_color = Color(0.78, 0.6, 1.0)
	style.set_border_width_all(2)
	style.set_corner_radius_all(6)
	style.content_margin_left = 16.0
	style.content_margin_right = 16.0
	style.content_margin_top = 8.0
	style.content_margin_bottom = 8.0
	add_theme_stylebox_override("panel", style)
	custom_minimum_size.x = 620.0
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 2)
	col.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(col)
	_title = _label(15, Color(0.85, 0.72, 1.0))
	col.add_child(_title)
	_text = _label(17, Color(0.95, 0.93, 0.88))
	_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	col.add_child(_text)
	_source = _label(12, Color(0.62, 0.58, 0.7))
	col.add_child(_source)

func _label(size: int, color: Color) -> Label:
	var l := Label.new()
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	l.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85))
	l.add_theme_constant_override("outline_size", 3)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return l

## `known`: o Eco já estava no Diário (título diferente, mesma faixa).
func show_eco(text: String, source: String, known: bool, seconds: float) -> void:
	_title.text = "✦ Eco de Nottgard%s" % (" (já no Diário)" if known else " — novo no Diário")
	_text.text = text
	_source.text = "Fonte: %s" % source if source != "" else ""
	visible = true
	modulate.a = 1.0
	if _tween != null and _tween.is_valid():
		_tween.kill()
	_tween = create_tween()
	_tween.tween_interval(maxf(0.5, seconds - 0.6))
	_tween.tween_property(self, "modulate:a", 0.0, 0.6)
	_tween.tween_callback(func(): visible = false)
