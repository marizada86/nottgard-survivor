extends Node2D
## Desenha zonas, telégrafos, projéteis, coletáveis e interações. Um nó por camada (mode).

@export_enum("under", "over") var mode := "over"
var battle: Battle
static var _texture_cache := {}

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

func _texture(path: String) -> Texture2D:
	if not _texture_cache.has(path):
		_texture_cache[path] = load(path) if ResourceLoader.exists(path) else null
	return _texture_cache[path]

func _draw_over() -> void:
	for it in battle.interactions:
		var p := Iso.to_screen(it.pos)
		var col := Color.WHITE
		var label := ""
		var asset := ""
		match String(it.kind):
			"chest": col = Color(0.9, 0.7, 0.2); label = "baú"; asset = "chest_closed"
			"fountain": col = Color(0.3, 0.7, 1.0); label = "fonte"; asset = "fountain_active"
			"altar": col = Color(0.8, 0.4, 1.0); label = "altar [E]"; asset = "altar_active"
			"ritual": col = Color(0.9, 0.2, 0.2); label = "ritual [E]"; asset = "ritual"
			"portal": col = Color(0.3, 1.0, 0.6); label = "portal [E]"; asset = "portal"
		var texture := _texture("res://assets/interactions/%s.png" % asset)
		var animation_id: String = {"fountain": "fountain_active", "altar": "altar_active", "ritual": "ritual", "portal": "portal"}.get(String(it.kind), "")
		var animation_count: int = {"fountain_active": 6, "altar_active": 6, "ritual": 8, "portal": 8}.get(animation_id, 0)
		var animation_texture := _texture("res://assets/animations/interactions/%s.png" % animation_id) if animation_id != "" else null
		if animation_texture != null and animation_count > 0:
			var h := 70.0 if it.kind == "portal" else 54.0
			var frame := int(Time.get_ticks_msec() / 100) % animation_count
			var w := h
			draw_texture_rect_region(animation_texture, Rect2(p.x - w * 0.5, p.y - h, w, h), Rect2(frame * 192, 0, 192, 192))
		elif texture != null:
			var h := 70.0 if it.kind == "portal" else 54.0
			var w := h * float(texture.get_width()) / float(texture.get_height())
			draw_texture_rect(texture, Rect2(p.x - w * 0.5, p.y - h, w, h), false)
		else:
			draw_colored_polygon(PackedVector2Array([p + Vector2(0, -18), p + Vector2(14, 0), p + Vector2(0, 9), p + Vector2(-14, 0)]), Color(col, 0.35))
			draw_rect(Rect2(p + Vector2(-9, -22), Vector2(18, 16)), col.darkened(0.2))
		draw_string(ThemeDB.fallback_font, p + Vector2(-32, -62), label, HORIZONTAL_ALIGNMENT_CENTER, 64, 12, Color(col, 0.95))
	for pk in battle.pickups:
		var p := Iso.to_screen(pk.pos)
		var pickup_asset: String = {"xp": "xp_shard", "gold": "gold_coin", "potion": "health_potion"}.get(String(pk.kind), "")
		var pickup_texture := _texture("res://assets/pickups/%s.png" % pickup_asset)
		if pickup_texture != null:
			var size := 22.0 if pk.kind != "potion" else 26.0
			draw_texture_rect(pickup_texture, Rect2(p.x - size * 0.5, p.y - size, size, size), false)
		else:
			draw_circle(p + Vector2(0, -4), 4.0, Color(0.6, 0.85, 1.0))
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
