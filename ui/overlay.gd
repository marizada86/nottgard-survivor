extends Node2D
## Desenha zonas, telégrafos, projéteis, coletáveis e interações. Um nó por camada (mode).

@export_enum("under", "over") var mode := "over"
var battle: Battle

func _process(_dt: float) -> void:
	queue_redraw()

func _ellipse(c: Vector2, r: float, n: int = 28) -> PackedVector2Array:
	# círculo no chão em projeção isométrica (raio r em tiles)
	var pts := PackedVector2Array()
	for i in n:
		var a := TAU * i / n
		pts.append(Iso.to_screen(c + Vector2(cos(a), sin(a)) * r))
	return pts

func _draw() -> void:
	if battle == null:
		return
	if mode == "under":
		_draw_zones()
	else:
		_draw_over()

func _draw_zones() -> void:
	for z in battle.zones:
		if z.owner == "hero":
			var col := _dcol(String(z.p.dtype), 0.28)
			draw_colored_polygon(_ellipse(z.pos, z.radius), col)
			draw_polyline(_ellipse_closed(z.pos, z.radius), Color(col, 0.7), 2.0)
		elif z.kind == "puddle":
			draw_colored_polygon(_ellipse(z.pos, z.radius), Color(0.35, 0.6, 0.25, 0.32))
			draw_polyline(_ellipse_closed(z.pos, z.radius), Color(0.5, 0.8, 0.3, 0.5), 1.5)
		elif z.kind == "rule_ritual":
			draw_colored_polygon(_ellipse(z.pos, z.radius), Color(0.65, 0.12, 0.55, 0.24))
			draw_polyline(_ellipse_closed(z.pos, z.radius), Color(1.0, 0.35, 0.75, 0.9), 3.0)
			var progress: float = clampf(float(z.progress) / maxf(0.01, float(z.interrupt)), 0.0, 1.0)
			draw_arc(Iso.to_screen(z.pos), 26.0, -PI * 0.5, -PI * 0.5 + TAU * progress, 24, Color(0.4, 1.0, 0.7), 4.0)
		elif z.kind == "sanctuary":
			var col := Color(1.0, 0.9, 0.5, 0.24) if not bool(z.fake) else Color(0.85, 0.72, 0.48, 0.18)
			draw_colored_polygon(_ellipse(z.pos, z.radius), col)
			draw_polyline(_ellipse_closed(z.pos, z.radius), Color(col, 0.8), 2.0)
		elif z.kind == "bubble":
			draw_colored_polygon(_ellipse(z.pos, z.radius), Color(0.3, 0.65, 0.9, 0.2))
			draw_polyline(_ellipse_closed(z.pos, z.radius), Color(0.5, 0.85, 1.0, 0.9), 3.0)
		else:
			var t: float = clampf(1.0 - z.delay / maxf(0.01, z.get("total", z.delay)), 0.0, 1.0)
			draw_colored_polygon(_ellipse(z.pos, z.radius), Color(0.9, 0.15, 0.1, 0.16 + 0.2 * (1.0 - clampf(z.delay, 0.0, 1.5) / 1.5)))
			draw_polyline(_ellipse_closed(z.pos, z.radius), Color(1.0, 0.3, 0.2, 0.9), 2.0)

func _ellipse_closed(c: Vector2, r: float) -> PackedVector2Array:
	var p := _ellipse(c, r)
	p.append(p[0])
	return p

func _dcol(dtype: String, a: float) -> Color:
	match dtype:
		"fogo": return Color(1.0, 0.45, 0.1, a)
		"radiante": return Color(1.0, 0.95, 0.6, a)
		"magico": return Color(0.6, 0.4, 1.0, a)
	return Color(0.8, 0.8, 0.8, a)

func _draw_over() -> void:
	for it in battle.interactions:
		var p := Iso.to_screen(it.pos)
		var col := Color.WHITE
		var label := ""
		match String(it.kind):
			"chest": col = Color(0.9, 0.7, 0.2); label = "baú"
			"fountain": col = Color(0.3, 0.7, 1.0); label = "fonte"
			"altar": col = Color(0.8, 0.4, 1.0); label = "altar [E]"
			"ritual": col = Color(0.9, 0.2, 0.2); label = "ritual [E]"
			"portal": col = Color(0.3, 1.0, 0.6); label = "portal [E]"
		draw_colored_polygon(PackedVector2Array([p + Vector2(0, -18), p + Vector2(14, 0), p + Vector2(0, 18) * 0.5, p + Vector2(-14, 0)]), Color(col, 0.35))
		draw_rect(Rect2(p + Vector2(-9, -22), Vector2(18, 16)), col.darkened(0.2))
		draw_rect(Rect2(p + Vector2(-9, -22), Vector2(18, 4)), col)
		if it.kind == "portal":
			draw_arc(p + Vector2(0, -20), 20, 0, TAU, 24, Color(0.4, 1.0, 0.7, 0.8), 3.0)
		draw_string(ThemeDB.fallback_font, p + Vector2(-26, -30), label, HORIZONTAL_ALIGNMENT_CENTER, 52, 12, Color(col, 0.95))
	for pk in battle.pickups:
		var p := Iso.to_screen(pk.pos)
		match String(pk.kind):
			"xp": draw_colored_polygon(PackedVector2Array([p + Vector2(0, -8), p + Vector2(5, -3), p + Vector2(0, 2), p + Vector2(-5, -3)]), Color(0.35, 0.85, 1.0))
			"gold": draw_circle(p + Vector2(0, -4), 4.0, Color(1.0, 0.8, 0.2))
			"potion":
				draw_circle(p + Vector2(0, -5), 5.0, Color(0.9, 0.2, 0.3))
				draw_rect(Rect2(p + Vector2(-2, -12), Vector2(4, 4)), Color(0.8, 0.8, 0.8))
	for pr in battle.projectiles:
		var p := Iso.to_screen(pr.pos) + Vector2(0, -16)
		if pr.owner == "hero":
			var col := _dcol(String(pr.p.get("dtype", "fisico")), 1.0)
			draw_circle(p, 5.0, col)
			draw_line(p, p - Iso.to_screen(pr.dir).normalized() * 14.0, Color(col, 0.5), 3.0)
		else:
			draw_circle(p, 5.0, Color(1.0, 0.25, 0.25))
			draw_circle(p, 2.5, Color(1.0, 0.8, 0.6))
	for e in battle.enemies:
		if e.windup > 0.0:
			var a := Iso.to_screen(e.pos)
			var b := Iso.to_screen(e.pos + e.charge_dir * float(e.charge_ab.dist))
			draw_line(a, b, Color(1.0, 0.25, 0.2, 0.6), 4.0)
