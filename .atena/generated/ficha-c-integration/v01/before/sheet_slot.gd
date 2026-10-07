class_name SheetSlot
extends Control
## SPEC-130 (MEC-045): slot da grade da ficha C. Ícone, borda por raridade, selo de nível, seta de evolução e moldura vazia.
## O foco (teclado, controle ou mouse por cima) avisa a ficha para mostrar o detalhe do item.

signal chosen(slot: SheetSlot)

const SIZE := Vector2(76, 76)
const GOLD := Color(1.0, 0.85, 0.4)

var entry: Dictionary = {}
var _icon: Texture2D = null
var _t := 0.0

func setup(e: Dictionary) -> void:
	entry = e
	custom_minimum_size = SIZE
	size = SIZE
	focus_mode = Control.FOCUS_ALL
	mouse_filter = Control.MOUSE_FILTER_STOP
	var path := String(e.get("icon", ""))
	_icon = load(path) if path != "" and ResourceLoader.exists(path) else null
	focus_entered.connect(func():
		chosen.emit(self)
		queue_redraw())
	focus_exited.connect(queue_redraw)
	mouse_entered.connect(func():
		if not has_focus():
			grab_focus())
	set_process(bool(e.get("evolve", false)))

func is_empty_slot() -> bool:
	return bool(entry.get("empty", false))

func _process(delta: float) -> void:
	_t += delta
	if is_visible_in_tree():
		queue_redraw()

func _draw() -> void:
	var rect := Rect2(Vector2.ZERO, SIZE)
	var font := ThemeDB.fallback_font
	if is_empty_slot():
		draw_rect(rect, Color(0.07, 0.065, 0.085, 0.9))
		_dashed_frame(rect, Color(0.38, 0.36, 0.42))
		var cap := String(entry.get("caption", ""))
		if cap != "":
			draw_string(font, Vector2(0, SIZE.y * 0.56), cap, HORIZONTAL_ALIGNMENT_CENTER, SIZE.x, 13, Color(0.5, 0.48, 0.55))
	else:
		draw_rect(rect, Color(0.12, 0.105, 0.14, 1.0))
		var inner := rect.grow(-7.0)
		if _icon != null:
			draw_texture_rect(_icon, inner, false)
		else:
			var letter := String(entry.get("letter", "?"))
			draw_string(font, Vector2(0, SIZE.y * 0.68), letter, HORIZONTAL_ALIGNMENT_CENTER, SIZE.x, 32, Color(0.9, 0.88, 0.8))
		var border: Color = entry.get("border", Color(0.5, 0.5, 0.55))
		draw_rect(rect, border, false, 2.0)
		var badge := String(entry.get("badge", ""))
		if badge != "":
			var is_max := bool(entry.get("badge_max", false))
			var bw := 8.0 + 8.0 * float(badge.length())
			var brect := Rect2(SIZE.x - bw - 2.0, SIZE.y - 18.0, bw, 16.0)
			draw_rect(brect, Color(0.04, 0.035, 0.05, 0.92))
			draw_rect(brect, GOLD if is_max else Color(0.45, 0.43, 0.5), false, 1.0)
			draw_string(font, Vector2(brect.position.x, brect.position.y + 12.0), badge, HORIZONTAL_ALIGNMENT_CENTER, bw, 12, GOLD if is_max else Color(0.9, 0.9, 0.92))
		if bool(entry.get("evolve", false)):
			var pulse := 0.55 + 0.45 * sin(_t * 4.0)
			draw_rect(rect.grow(-1.0), Color(1.0, 0.85, 0.3, 0.16 * pulse))
			draw_rect(rect, Color(1.0, 0.85, 0.3, 0.55 + 0.45 * pulse), false, 3.0)
			var tri := PackedVector2Array([Vector2(SIZE.x - 17.0, 15.0), Vector2(SIZE.x - 5.0, 15.0), Vector2(SIZE.x - 11.0, 4.0)])
			draw_colored_polygon(tri, Color(1.0, 0.88, 0.35, 0.7 + 0.3 * pulse))
	if has_focus():
		draw_rect(rect.grow(2.0), GOLD, false, 3.0)

func _dashed_frame(rect: Rect2, color: Color) -> void:
	var dash := 6.0
	var gap := 5.0
	var x := rect.position.x
	while x < rect.end.x:
		var x2 := minf(x + dash, rect.end.x)
		draw_line(Vector2(x, rect.position.y + 1.0), Vector2(x2, rect.position.y + 1.0), color, 1.5)
		draw_line(Vector2(x, rect.end.y - 1.0), Vector2(x2, rect.end.y - 1.0), color, 1.5)
		x += dash + gap
	var y := rect.position.y
	while y < rect.end.y:
		var y2 := minf(y + dash, rect.end.y)
		draw_line(Vector2(rect.position.x + 1.0, y), Vector2(rect.position.x + 1.0, y2), color, 1.5)
		draw_line(Vector2(rect.end.x - 1.0, y), Vector2(rect.end.x - 1.0, y2), color, 1.5)
		y += dash + gap
