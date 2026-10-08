class_name QuestPanel
extends PanelContainer
## SPEC-147 (IN-070): painel de quests (objetivos dos acontecimentos de fase, SPEC-118). Moldura dourada, título,
## texto, progresso e prazo de cada objetivo; pulsa quando um objetivo nasce, avança ou termina.
## Fica numa pilha vertical do HUD (ver Hud._build_top_stack), então nunca invade a barra do chefe nem os avisos.

const MAX_ROWS := 4
const GOLD := Color(0.93, 0.78, 0.4)
const URGENT := Color(1.0, 0.45, 0.4)

var _rows: VBoxContainer
var _signature := ""
var _timers: Dictionary = {}  # id -> Label com o prazo restante
var _progress: Dictionary = {}  # id -> have, para pulsar quando avança
var _pulse: Tween

func _init() -> void:
	name = "QuestPanel"
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	visible = false
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.08, 0.06, 0.11, 0.84)
	sb.border_color = Color(GOLD, 0.95)
	sb.set_border_width_all(2)
	sb.set_corner_radius_all(5)
	sb.content_margin_left = 12.0
	sb.content_margin_right = 12.0
	sb.content_margin_top = 6.0
	sb.content_margin_bottom = 8.0
	add_theme_stylebox_override("panel", sb)
	_rows = VBoxContainer.new()
	_rows.add_theme_constant_override("separation", 4)
	_rows.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_rows)

## `entries`: Happenings.hud_entries(); `carrying`: Happenings.carrying_text().
func update_entries(entries: Array, carrying := "") -> void:
	if entries.is_empty():
		_signature = ""
		_progress.clear()
		_timers.clear()
		visible = false
		return
	var shown: Array = entries.slice(0, MAX_ROWS)
	var extra := entries.size() - shown.size()
	var sig: Array = [carrying, extra]
	for e in shown:
		sig.append("%s|%s|%s|%d|%d|%s" % [e.id, e.title, e.text, int(e.need), int(e.have), "t" if float(e.left) >= 0.0 else ""])
	var signature := "\n".join(sig.map(func(s): return str(s)))
	if signature != _signature:
		var grew := _signature == "" or _has_progress(shown) or shown.size() != _progress.size()
		_signature = signature
		_rebuild(shown, extra, carrying)
		if grew:
			pulse()
	visible = true
	for e in shown:
		var t: Label = _timers.get(String(e.id))
		if t != null:
			var left := float(e.left)
			t.text = "%d s" % int(ceil(left))
			t.add_theme_color_override("font_color", URGENT if left <= 10.0 else Color(0.85, 0.85, 0.9))

func _has_progress(shown: Array) -> bool:
	for e in shown:
		if int(e.have) > int(_progress.get(String(e.id), 0)):
			return true
	return false

func _rebuild(shown: Array, extra: int, carrying: String) -> void:
	for c in _rows.get_children():
		_rows.remove_child(c)
		c.queue_free()
	_timers.clear()
	var progress := {}
	for e in shown:
		progress[String(e.id)] = int(e.have)
		_rows.add_child(_row(e))
	_progress = progress
	if extra > 0:
		_rows.add_child(_label("+%d objetivo%s" % [extra, "" if extra == 1 else "s"], 14, Color(0.7, 0.7, 0.78)))
	if carrying != "":
		_rows.add_child(_label("Carregando: %s" % carrying, 15, Color(0.7, 0.95, 0.75)))

func _row(e: Dictionary) -> Control:
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 1)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var head := HBoxContainer.new()
	head.add_theme_constant_override("separation", 8)
	head.mouse_filter = Control.MOUSE_FILTER_IGNORE
	head.add_child(_label("◆", 20, GOLD))
	var title := _label(String(e.title), 19, GOLD)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.clip_text = true
	head.add_child(title)
	if int(e.need) > 1:
		head.add_child(_label("%d/%d" % [int(e.have), int(e.need)], 19, Color(0.7, 0.95, 0.75)))
	if float(e.left) >= 0.0:
		var t := _label("", 17, Color(0.85, 0.85, 0.9))
		_timers[String(e.id)] = t
		head.add_child(t)
	v.add_child(head)
	var text := _label(String(e.text), 15, Color(0.92, 0.9, 0.86))
	text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text.custom_minimum_size.x = 400.0
	v.add_child(text)
	if int(e.need) > 1:
		var bar := ProgressBar.new()
		bar.show_percentage = false
		bar.max_value = int(e.need)
		bar.value = clampi(int(e.have), 0, int(e.need))
		bar.custom_minimum_size = Vector2(0, 6)
		bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var fill := StyleBoxFlat.new()
		fill.bg_color = GOLD
		fill.set_corner_radius_all(2)
		var back := StyleBoxFlat.new()
		back.bg_color = Color(0.2, 0.17, 0.12, 0.9)
		back.set_corner_radius_all(2)
		bar.add_theme_stylebox_override("fill", fill)
		bar.add_theme_stylebox_override("background", back)
		v.add_child(bar)
	return v

func _label(text: String, size: int, color: Color) -> Label:
	var l := Label.new()
	l.text = text
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	l.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85))
	l.add_theme_constant_override("outline_size", 4)
	return l

## Brilho curto do painel inteiro: um objetivo nasceu, avançou ou terminou.
func pulse() -> void:
	if _pulse != null and _pulse.is_valid():
		_pulse.kill()
	modulate = Color(1.7, 1.45, 0.9)
	if not is_inside_tree():
		return
	_pulse = create_tween()
	_pulse.tween_property(self, "modulate", Color.WHITE, 0.7)
