class_name QuestPanel
extends PanelContainer
## SPEC-147 (IN-070) e SPEC-168 (MEC-064): questlog (objetivos dos acontecimentos de fase, SPEC-118). Fica no canto direito da HUD,
## sem moldura nem fundo e a `LOG_ALPHA` de opacidade, para o jogador ver o mapa por trás. Uma linha por objetivo (título,
## progresso, prazo); só o mais urgente mostra a descrição. Pulsa quando um objetivo nasce, avança ou termina.

const MAX_ROWS := 4
const LOG_ALPHA := 0.8
const LOG_WIDTH := 300.0
const GOLD := Color(0.93, 0.78, 0.4)
const URGENT := Color(1.0, 0.45, 0.4)
const URGENT_SECONDS := 10.0

var _rows: VBoxContainer
var _signature := ""
var _timers: Dictionary = {}  # id -> Label com o prazo restante
var _progress: Dictionary = {}  # id -> have, para pulsar quando avança
var _pulse: Tween

func _init() -> void:
	name = "QuestPanel"
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	visible = false
	modulate = Color(1, 1, 1, LOG_ALPHA)
	add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	_rows = VBoxContainer.new()
	_rows.add_theme_constant_override("separation", 3)
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
	var urgent := urgent_index(shown)
	var sig: Array = [carrying, extra, urgent]
	for e in shown:
		sig.append("%s|%s|%s|%d|%d|%s" % [e.id, e.title, e.text, int(e.need), int(e.have), "t" if float(e.left) >= 0.0 else ""])
	var signature := "\n".join(sig.map(func(s): return str(s)))
	if signature != _signature:
		var grew := _signature == "" or _has_progress(shown) or shown.size() != _progress.size()
		_signature = signature
		_rebuild(shown, extra, carrying, urgent)
		if grew:
			pulse()
	visible = true
	for e in shown:
		var t: Label = _timers.get(String(e.id))
		if t != null:
			var left := float(e.left)
			t.text = "%d s" % int(ceil(left))
			t.add_theme_color_override("font_color", URGENT if left <= URGENT_SECONDS else Color(0.85, 0.85, 0.9))

## O objetivo mais urgente: o de menor prazo restante; sem nenhum prazo, o primeiro.
static func urgent_index(entries: Array) -> int:
	var best := 0
	var best_left := INF
	for i in entries.size():
		var left := float(entries[i].left)
		if left >= 0.0 and left < best_left:
			best_left = left
			best = i
	return best

func _has_progress(shown: Array) -> bool:
	for e in shown:
		if int(e.have) > int(_progress.get(String(e.id), 0)):
			return true
	return false

func _rebuild(shown: Array, extra: int, carrying: String, urgent: int) -> void:
	for c in _rows.get_children():
		_rows.remove_child(c)
		c.queue_free()
	_timers.clear()
	var progress := {}
	for i in shown.size():
		var e: Dictionary = shown[i]
		progress[String(e.id)] = int(e.have)
		_rows.add_child(_row(e, i == urgent))
	_progress = progress
	if extra > 0:
		_rows.add_child(_label("+%d objetivo%s" % [extra, "" if extra == 1 else "s"], 14, Color(0.7, 0.7, 0.78)))
	if carrying != "":
		_rows.add_child(_label("Carregando: %s" % carrying, 14, Color(0.7, 0.95, 0.75)))

func _row(e: Dictionary, with_text: bool) -> Control:
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 0)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var head := HBoxContainer.new()
	head.add_theme_constant_override("separation", 8)
	head.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var title := _label(String(e.title), 17, GOLD)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.clip_text = true
	head.add_child(title)
	if int(e.need) > 1:
		head.add_child(_label("%d/%d" % [int(e.have), int(e.need)], 17, Color(0.7, 0.95, 0.75)))
	if float(e.left) >= 0.0:
		var t := _label("", 16, Color(0.85, 0.85, 0.9))
		_timers[String(e.id)] = t
		head.add_child(t)
	head.add_child(_label("◆", 17, GOLD))
	v.add_child(head)
	if with_text:
		var text := _label(String(e.text), 14, Color(0.92, 0.9, 0.86))
		text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		text.custom_minimum_size.x = LOG_WIDTH
		v.add_child(text)
	return v

func _label(text: String, size: int, color: Color) -> Label:
	var l := Label.new()
	l.text = text
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	l.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85))
	l.add_theme_constant_override("outline_size", 4)
	return l

## Brilho curto do questlog inteiro: um objetivo nasceu, avançou ou terminou.
func pulse() -> void:
	if _pulse != null and _pulse.is_valid():
		_pulse.kill()
	modulate = Color(1.7, 1.45, 0.9, 1.0)
	if not is_inside_tree():
		return
	_pulse = create_tween()
	_pulse.tween_property(self, "modulate", Color(1, 1, 1, LOG_ALPHA), 0.7)
