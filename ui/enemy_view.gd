extends Node2D
## Visual de um inimigo (criado em runtime, um por Enemy). Usa a arte do Nottcard quando existe.

const H_BASE := 62.0
static var _tex_cache := {}

var enemy: Enemy
var tex: Texture2D

func setup(e: Enemy) -> void:
	enemy = e
	position = Iso.to_screen(e.pos)
	var path := "res://assets/enemies/%s.png" % e.id
	if not _tex_cache.has(path):
		_tex_cache[path] = load(path) if ResourceLoader.exists(path) else null
	tex = _tex_cache[path]

func _draw() -> void:
	if enemy == null:
		return
	var s := enemy.scale
	var a := 0.45 if enemy.has_flag("ghost") or enemy.has_flag("illusory") else 1.0
	var mod := Color(1, 1, 1, a)
	if enemy.hit_flash > 0.0:
		mod = Color(2.2, 2.2, 2.2, a)
	elif enemy.stun_t > 0.0:
		mod = Color(0.6, 0.7, 1.4, a)
	elif enemy.slow_t > 0.0:
		mod = Color(0.75, 0.9, 1.2, a)
	draw_colored_polygon(PackedVector2Array([Vector2(0, -7 * s), Vector2(14 * s, 0), Vector2(0, 7 * s), Vector2(-14 * s, 0)]), Color(0, 0, 0, 0.5 * a))
	if enemy.affix != "":
		draw_arc(Vector2.ZERO, 16 * s, 0, TAU, 20, Color(1.0, 0.85, 0.3, 0.9), 2.0)
	if enemy.is_boss():
		draw_arc(Vector2.ZERO, 22 * s, 0, TAU, 24, Color(0.9, 0.2, 0.2, 0.9), 3.0)
	if tex != null:
		var h := H_BASE * s
		var w := h * float(tex.get_width()) / float(tex.get_height())
		draw_texture_rect(tex, Rect2(-w * 0.5, -h, w, h), false, mod)
	else:
		var c := enemy.color
		c = Color(c.r * mod.r, c.g * mod.g, c.b * mod.b, a)
		draw_rect(Rect2(-8 * s, -34 * s, 16 * s, 34 * s), c)
		draw_circle(Vector2(0, -39 * s), 7 * s, c.lightened(0.2))
	if enemy.hp < enemy.max_hp or enemy.affix != "" or enemy.is_boss():
		var top := -(H_BASE if tex != null else 46.0) * s - 6.0
		var frac := clampf(enemy.hp / enemy.max_hp, 0.0, 1.0)
		var bw := 26.0 * maxf(1.0, s * 0.8)
		draw_rect(Rect2(-bw * 0.5, top, bw, 3), Color(0.12, 0, 0, 0.9))
		draw_rect(Rect2(-bw * 0.5, top, bw * frac, 3), Color(0.8, 0.15, 0.15))
	if enemy.stun_t > 0.0:
		draw_string(ThemeDB.fallback_font, Vector2(-6, -H_BASE * s - 12), "✦", HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color(1, 1, 0.5))
