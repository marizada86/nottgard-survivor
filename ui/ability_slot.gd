class_name AbilitySlot
extends Control
## SPEC-127 (MEC-043): slot da habilidade ativa (Q/RMB) com ícone, varredura de recarga, segundos e brilho ao ficar pronta.

const SIZE := Vector2(72, 72)
const FLASH_TIME := 0.4

var _icon: Texture2D = null
var _letter := "?"
var _cd := 0.0
var _cd_max := 1.0
var _guard := false
var _flash := 0.0
var _was_cooling := false

func _init() -> void:
	custom_minimum_size = SIZE
	size = SIZE
	clip_contents = true
	mouse_filter = Control.MOUSE_FILTER_PASS

func set_ability(name: String, desc: String, icon: Texture2D, key_text: String) -> void:
	_icon = icon
	_letter = name.substr(0, 1).to_upper() if name != "" else "?"
	tooltip_text = "%s [%s]\n%s" % [name, key_text, desc]
	queue_redraw()

## cd = recarga restante em segundos; cd_max = recarga efetiva da última vez que foi usada.
func set_state(cd: float, cd_max: float, guard_active: bool, delta: float) -> void:
	var cooling := cd > 0.0
	if _was_cooling and not cooling:
		_flash = FLASH_TIME
	_was_cooling = cooling
	_flash = maxf(0.0, _flash - delta)
	_cd = cd
	_cd_max = maxf(cd_max, 0.001)
	_guard = guard_active
	queue_redraw()

static func cooldown_text(cd: float) -> String:
	if cd <= 0.0:
		return ""
	return "%.1f" % cd if cd < 10.0 else "%d" % int(ceil(cd))

func _draw() -> void:
	var rect := Rect2(Vector2.ZERO, SIZE)
	draw_rect(rect, Color(0.2, 0.18, 0.26, 0.92))
	var inner := rect.grow(-4.0)
	var cooling := _cd > 0.0
	if _icon != null:
		draw_texture_rect(_icon, inner, false, Color(0.5, 0.5, 0.55, 1.0) if cooling else Color.WHITE)
	else:
		var font := ThemeDB.fallback_font
		draw_string(font, Vector2(0, SIZE.y * 0.68), _letter, HORIZONTAL_ALIGNMENT_CENTER, SIZE.x, 30, Color(0.9, 0.9, 0.85))
	if cooling:
		var frac := clampf(_cd / _cd_max, 0.0, 1.0)
		var center := SIZE * 0.5
		var pts := PackedVector2Array([center])
		var steps := maxi(2, int(ceil(frac * 48.0)))
		# varredura horária: a parte ainda em recarga começa no topo e vai até a fração restante
		for i in steps + 1:
			var ang := -PI * 0.5 + TAU * (1.0 - frac) + TAU * frac * float(i) / float(steps)
			pts.append(center + Vector2(cos(ang), sin(ang)) * SIZE.x)
		draw_colored_polygon(pts, Color(0, 0, 0, 0.62))
		var font2 := ThemeDB.fallback_font
		var txt := cooldown_text(_cd)
		draw_string_outline(font2, Vector2(0, SIZE.y * 0.6), txt, HORIZONTAL_ALIGNMENT_CENTER, SIZE.x, 26, 6, Color(0, 0, 0, 0.9))
		draw_string(font2, Vector2(0, SIZE.y * 0.6), txt, HORIZONTAL_ALIGNMENT_CENTER, SIZE.x, 26, Color(1, 1, 1))
	var border := Color(0.55, 0.55, 0.6)
	if _guard:
		border = Color(0.45, 0.75, 1.0)
	elif not cooling:
		border = Color(1.0, 0.85, 0.35)
	draw_rect(rect, border, false, 3.0)
	if _flash > 0.0:
		draw_rect(rect, Color(1, 1, 1, 0.55 * _flash / FLASH_TIME))
	var kfont := ThemeDB.fallback_font
	draw_string_outline(kfont, Vector2(3, SIZE.y - 4), "Q/RMB", HORIZONTAL_ALIGNMENT_LEFT, -1, 12, 4, Color(0, 0, 0, 0.9))
	draw_string(kfont, Vector2(3, SIZE.y - 4), "Q/RMB", HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color(1, 0.95, 0.75))
