class_name AbilitySlot
extends Control
## SPEC-127 (MEC-043): slot da habilidade ativa (Q/RMB) com ícone, varredura de recarga, segundos e brilho ao ficar pronta.

const SIZE := Vector2(60, 60)
const FLASH_TIME := 0.4
const OPACITY := 0.8  ## o slot fica translúcido para não competir com o combate

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
	modulate.a = OPACITY

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
	# disco suave e translúcido, sem bordas; a tecla fica logo abaixo (pedido do dono: menos "grotesco")
	var center := Vector2(SIZE.x * 0.5, SIZE.y * 0.5 - 4.0)
	var radius := SIZE.x * 0.5 - 4.0
	draw_circle(center, radius, Color(0.12, 0.1, 0.16, 0.55))
	var cooling := _cd > 0.0
	var isize := radius * 1.6
	if _icon != null:
		draw_texture_rect(_icon, Rect2(center - Vector2(isize, isize) * 0.5, Vector2(isize, isize)), false, Color(0.55, 0.55, 0.6, 1.0) if cooling else Color.WHITE)
	else:
		var font := ThemeDB.fallback_font
		draw_string(font, Vector2(0, center.y + 9.0), _letter, HORIZONTAL_ALIGNMENT_CENTER, SIZE.x, 26, Color(0.9, 0.9, 0.85))
	if cooling:
		var frac := clampf(_cd / _cd_max, 0.0, 1.0)
		var pts := PackedVector2Array([center])
		var steps := maxi(2, int(ceil(frac * 48.0)))
		# varredura horária: a parte ainda em recarga começa no topo e vai até a fração restante
		for i in steps + 1:
			var ang := -PI * 0.5 + TAU * (1.0 - frac) + TAU * frac * float(i) / float(steps)
			pts.append(center + Vector2(cos(ang), sin(ang)) * radius)
		draw_colored_polygon(pts, Color(0, 0, 0, 0.5))
		var font2 := ThemeDB.fallback_font
		var txt := cooldown_text(_cd)
		draw_string_outline(font2, Vector2(0, center.y + 8.0), txt, HORIZONTAL_ALIGNMENT_CENTER, SIZE.x, 22, 5, Color(0, 0, 0, 0.9))
		draw_string(font2, Vector2(0, center.y + 8.0), txt, HORIZONTAL_ALIGNMENT_CENTER, SIZE.x, 22, Color(1, 1, 1))
	if _guard:
		draw_circle(center, radius, Color(0.45, 0.75, 1.0, 0.28))
	if _flash > 0.0:
		draw_circle(center, radius, Color(1, 1, 1, 0.5 * _flash / FLASH_TIME))
	var kfont := ThemeDB.fallback_font
	var key_y := SIZE.y - 2.0
	draw_string_outline(kfont, Vector2(0, key_y), "Q/RMB", HORIZONTAL_ALIGNMENT_CENTER, SIZE.x, 10, 3, Color(0, 0, 0, 0.9))
	draw_string(kfont, Vector2(0, key_y), "Q/RMB", HORIZONTAL_ALIGNMENT_CENTER, SIZE.x, 10, Color(1, 0.95, 0.75, 0.9))
