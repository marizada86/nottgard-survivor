extends Node2D
## Desenha zonas, telégrafos, projéteis, coletáveis e interações. Um nó por camada (mode).

@export_enum("under", "over") var mode := "over"
var battle: Battle
static var _texture_cache := {}
var _large_fx_by_quadrant: Array[int] = [0, 0, 0, 0]

func _process(_dt: float) -> void:
	queue_redraw()

func _ellipse(c: Vector2, r: float, n: int = 28) -> PackedVector2Array:
	# círculo no chão em projeção isométrica (raio r em tiles)
	var pts := PackedVector2Array()
	for i in n:
		var a := TAU * i / n
		pts.append(Iso.to_screen(c + Vector2(cos(a), sin(a)) * r))
	return pts

func _organic_ellipse(c: Vector2, r: float, seed: float, n: int = 22) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in n:
		var a := TAU * float(i) / float(n)
		var wobble := 0.88 + 0.09 * sin(a * 3.0 + seed) + 0.035 * sin(a * 7.0 - seed * 0.7)
		pts.append(Iso.to_screen(c + Vector2(cos(a), sin(a)) * r * wobble))
	return pts

func _phase() -> float:
	return float(Time.get_ticks_msec()) * 0.001

func _allow_large_fx(c: Vector2) -> bool:
	var size := get_viewport_rect().size
	var p := Iso.to_screen(c)
	var quadrant := (1 if p.x >= size.x * 0.5 else 0) + (2 if p.y >= size.y * 0.5 else 0)
	if _large_fx_by_quadrant[quadrant] >= 3:
		return false
	_large_fx_by_quadrant[quadrant] += 1
	return true

func _draw() -> void:
	if battle == null:
		return
	if mode == "under":
		_draw_zones()
	else:
		_draw_over()

func _draw_zones() -> void:
	_large_fx_by_quadrant = [0, 0, 0, 0]
	if battle.stage_id == "pilares" and battle._stage_has_rule("current"):
		_draw_pillar_current()
	for z in battle.zones:
		if z.owner == "hero":
			_draw_hero_zone(z)
		elif z.kind == "puddle":
			_draw_puddle(z)
		elif z.kind == "rule_ritual":
			_draw_ritual(z)
		elif z.kind == "sanctuary":
			_draw_sanctuary(z)
		elif z.kind == "bubble":
			_draw_bubble(z)
		else:
			_draw_telegraph(z)

func _draw_puddle(z: Dictionary) -> void:
	var seed: float = float(z.pos.x) * 1.73 + float(z.pos.y) * 2.41
	var outline := _organic_ellipse(z.pos, z.radius, seed)
	outline.append(outline[0])
	draw_colored_polygon(outline, Color(0.12, 0.22, 0.11, 0.42))
	draw_polyline(outline, Color(0.46, 0.78, 0.28, 0.64), 1.7)
	if not _allow_large_fx(z.pos):
		return
	var pulse := 0.5 + 0.5 * sin(_phase() * 2.2 + seed)
	var inner := _organic_ellipse(z.pos, z.radius * (0.9 + pulse * 0.05), seed + 0.8)
	inner.append(inner[0])
	draw_polyline(inner, Color(0.66, 0.92, 0.38, 0.18 + pulse * 0.18), 1.1)
	for i in 3:
		var a: float = seed + float(i) * TAU / 3.0
		var p := Iso.to_screen(z.pos + Vector2(cos(a), sin(a)) * z.radius * (0.25 + float(i) * 0.14))
		draw_circle(p + Vector2(0.0, -2.0), 1.4 + pulse * 0.7, Color(0.66, 0.9, 0.37, 0.34))

func _draw_ritual(z: Dictionary) -> void:
	var pulse := 0.5 + 0.5 * sin(_phase() * 2.5)
	var edge := Color(1.0, 0.35, 0.75, 0.76 + pulse * 0.18)
	draw_colored_polygon(_ellipse(z.pos, z.radius), Color(0.42, 0.06, 0.35, 0.3))
	draw_polyline(_ellipse_closed(z.pos, z.radius), edge, 2.6)
	var center := Iso.to_screen(z.pos)
	for i in 4:
		var a := PI * 0.25 + float(i) * PI * 0.5
		var inner := Iso.to_screen(z.pos + Vector2(cos(a), sin(a)) * z.radius * 0.24)
		var outer := Iso.to_screen(z.pos + Vector2(cos(a), sin(a)) * z.radius * 0.58)
		draw_line(inner, outer, Color(0.86, 0.3, 0.72, 0.42), 1.4)
	draw_circle(center, 3.0 + pulse, Color(0.92, 0.34, 0.78, 0.34))
	var progress: float = clampf(float(z.progress) / maxf(0.01, float(z.interrupt)), 0.0, 1.0)
	_draw_ellipse_arc(z.pos, z.radius * 0.73, -PI * 0.5, -PI * 0.5 + TAU * progress, Color(0.4, 1.0, 0.7, 0.96), 3.2)

func _draw_sanctuary(z: Dictionary) -> void:
	var pulse := 0.5 + 0.5 * sin(_phase() * 2.0)
	var is_fake := bool(z.fake)
	var base := Color(1.0, 0.86, 0.42, 0.22)
	var edge := Color(1.0, 0.92, 0.58, 0.76)
	if is_fake:
		base = Color(0.9, 0.76, 0.48, 0.2)
		edge = Color(0.96, 0.82, 0.52, 0.7)
	draw_colored_polygon(_ellipse(z.pos, z.radius), base)
	draw_polyline(_ellipse_closed(z.pos, z.radius * (0.96 + pulse * 0.025)), edge, 2.1)
	if _allow_large_fx(z.pos):
		_draw_ellipse_arc(z.pos, z.radius * 0.62, -PI * 0.5, -PI * 0.5 + TAU * (0.25 + pulse * 0.25), Color(1.0, 0.96, 0.66, 0.42), 1.8)
	if is_fake:
		var c := Iso.to_screen(z.pos)
		draw_line(c + Vector2(-7.0, 2.0), c + Vector2(2.0, -4.0), Color(0.54, 0.2, 0.6, 0.35), 1.2)
		draw_line(c + Vector2(2.0, -4.0), c + Vector2(8.0, 4.0), Color(0.54, 0.2, 0.6, 0.35), 1.2)

func _draw_bubble(z: Dictionary) -> void:
	var total := maxf(0.01, float(z.get("total", z.delay)))
	var charge := clampf(1.0 - float(z.delay) / total, 0.0, 1.0)
	var pulse := 0.5 + 0.5 * sin(_phase() * 7.0)
	draw_colored_polygon(_ellipse(z.pos, z.radius), Color(0.12, 0.46, 0.38, 0.19 + charge * 0.1))
	draw_polyline(_ellipse_closed(z.pos, z.radius), Color(0.38, 0.94, 0.72, 0.58 + charge * 0.28), 2.4)
	if not _allow_large_fx(z.pos):
		return
	var center := Iso.to_screen(z.pos) + Vector2(0.0, -5.0 - charge * 8.0)
	draw_circle(center, 4.0 + charge * 7.0, Color(0.37, 0.84, 0.72, 0.16 + charge * 0.18))
	draw_arc(center, 4.0 + charge * 7.0, -PI * 0.75, PI * 0.15, 16, Color(0.82, 1.0, 0.88, 0.58), 1.5)
	_draw_ellipse_arc(z.pos, z.radius * (0.8 + pulse * 0.12), 0.0, TAU, Color(0.53, 0.95, 0.78, 0.12 + pulse * 0.15), 1.1)

func _draw_telegraph(z: Dictionary) -> void:
	var total := maxf(0.01, float(z.get("total", z.delay)))
	var t := clampf(1.0 - float(z.delay) / total, 0.0, 1.0)
	var beat := 0.5 + 0.5 * sin(_phase() * (5.0 + t * 9.0))
	draw_colored_polygon(_ellipse(z.pos, z.radius), Color(0.92, 0.12, 0.08, 0.1 + t * 0.18))
	draw_polyline(_ellipse_closed(z.pos, z.radius), Color(1.0, 0.3, 0.16, 0.56 + t * 0.34), 1.8 + t * 1.6)
	if not _allow_large_fx(z.pos):
		return
	_draw_ellipse_arc(z.pos, z.radius * (1.03 + beat * 0.045), -PI * 0.2, PI * 0.38, Color(1.0, 0.72, 0.36, 0.28 + beat * 0.45), 1.4 + t)
	for i in 3:
		var a := -PI * 0.5 + float(i) * TAU / 3.0
		var a0 := Iso.to_screen(z.pos + Vector2(cos(a), sin(a)) * z.radius * 0.76)
		var a1 := Iso.to_screen(z.pos + Vector2(cos(a), sin(a)) * z.radius * 0.98)
		draw_line(a0, a1, Color(1.0, 0.7, 0.34, 0.36 + t * 0.42), 1.5)

func _draw_hero_zone(z: Dictionary) -> void:
	var p: Dictionary = z.p
	var weapon_id := String(p.get("id", ""))
	var dtype := String(p.get("dtype", ""))
	if dtype == "fogo":
		_draw_wax_fire(z)
		return
	if weapon_id == "colar_dos_tentaculos":
		_draw_tentacle_zone(z)
		return
	var col := _dcol(dtype, 0.24)
	draw_colored_polygon(_ellipse(z.pos, z.radius), col)
	draw_polyline(_ellipse_closed(z.pos, z.radius), Color(col, 0.76), 2.0)

func _draw_wax_fire(z: Dictionary) -> void:
	var pulse := 0.5 + 0.5 * sin(_phase() * 5.0)
	draw_colored_polygon(_ellipse(z.pos, z.radius), Color(0.78, 0.16, 0.04, 0.32))
	draw_polyline(_ellipse_closed(z.pos, z.radius), Color(1.0, 0.52, 0.12, 0.82), 2.1)
	if not _allow_large_fx(z.pos):
		return
	for i in 3:
		var a := _phase() * 0.7 + float(i) * TAU / 3.0
		var base := Iso.to_screen(z.pos + Vector2(cos(a), sin(a)) * z.radius * 0.45)
		var tip := base + Vector2(sin(a) * 2.0, -5.0 - pulse * 5.0)
		draw_line(base, tip, Color(1.0, 0.77, 0.24, 0.8), 2.4)
		draw_circle(base, 2.2 + pulse, Color(1.0, 0.35, 0.08, 0.62))

func _draw_tentacle_zone(z: Dictionary) -> void:
	var pulse := 0.5 + 0.5 * sin(_phase() * 3.2)
	draw_colored_polygon(_ellipse(z.pos, z.radius), Color(0.28, 0.1, 0.48, 0.26))
	draw_polyline(_ellipse_closed(z.pos, z.radius), Color(0.64, 0.42, 1.0, 0.75), 2.1)
	if not _allow_large_fx(z.pos):
		return
	for i in 5:
		var a := float(i) * TAU / 5.0 + _phase() * 0.25
		var root := Iso.to_screen(z.pos + Vector2(cos(a), sin(a)) * z.radius * 0.2)
		var mid := Iso.to_screen(z.pos + Vector2(cos(a + 0.28), sin(a + 0.28)) * z.radius * 0.54) + Vector2(0.0, -5.0 * pulse)
		var tip := Iso.to_screen(z.pos + Vector2(cos(a + 0.1), sin(a + 0.1)) * z.radius * 0.82)
		draw_polyline(PackedVector2Array([root, mid, tip]), Color(0.7, 0.48, 1.0, 0.72), 2.0)

func _draw_pillar_current() -> void:
	var direction := Vector2(cos(float(battle._cur_angle)), sin(float(battle._cur_angle)))
	var side := Vector2(-direction.y, direction.x)
	var p := _phase()
	for i in 7:
		var lateral := -5.0 + float(i) * 1.65
		var distance := fmod(p * 2.2 + float(i) * 1.9, 9.0) - 4.5
		var start_ground := battle.hero.pos + side * lateral + direction * distance
		var end_ground := start_ground + direction * 1.35
		draw_line(Iso.to_screen(start_ground), Iso.to_screen(end_ground), Color(0.48, 0.66, 1.0, 0.24), 1.4)

func _draw_ellipse_arc(c: Vector2, r: float, from: float, to: float, col: Color, width: float) -> void:
	var points := PackedVector2Array()
	var segments := maxi(4, int(24.0 * absf(to - from) / TAU))
	for i in segments + 1:
		var a := lerpf(from, to, float(i) / float(segments))
		points.append(Iso.to_screen(c + Vector2(cos(a), sin(a)) * r))
	draw_polyline(points, col, width)

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
		var arrival_age := maxf(0.0, battle.time - float(it.get("born_at", 0.0)))
		var arrival := clampf(arrival_age / 0.65, 0.0, 1.0)
		var col := Color.WHITE
		var label := ""
		var asset := ""
		match String(it.kind):
			"chest": col = Color(0.9, 0.7, 0.2); label = "baú"; asset = "chest_closed"
			"fountain": col = Color(0.3, 0.7, 1.0); label = "fonte"; asset = "fountain_active"
			"altar": col = Color(0.8, 0.4, 1.0); label = "altar [E]"; asset = "altar_active"
			"ritual": col = Color(0.9, 0.2, 0.2); label = "ritual [E]"; asset = "ritual"
			"portal": col = Color(0.3, 1.0, 0.6); label = "portal [E]"; asset = "portal"
		# A simulação também bloqueia interação durante estes 0,65 s de entrada.
		if arrival < 0.35:
			var target_alpha := 0.25 + 0.45 * arrival / 0.35
			draw_polyline(_ellipse_closed(it.pos, 0.65), Color(col, target_alpha), 2.0)
			continue
		var landing := clampf((arrival - 0.35) / 0.65, 0.0, 1.0)
		var height_offset := lerpf(-70.0, 0.0, ease(landing, 2.2))
		var size_scale := lerpf(0.55, 1.0, ease(landing, 1.8))
		var draw_p := p + Vector2(0, height_offset)
		if arrival > 0.92:
			var impact := 1.0 - (arrival - 0.92) / 0.08
			draw_polyline(_ellipse_closed(it.pos, 0.65 + (1.0 - impact) * 0.45), Color(col, impact * 0.55), 2.0)
		var texture := _texture("res://assets/interactions/%s.png" % asset)
		var animation_id: String = {"fountain": "fountain_active", "altar": "altar_active", "ritual": "ritual", "portal": "portal"}.get(String(it.kind), "")
		var animation_count: int = {"fountain_active": 6, "altar_active": 6, "ritual": 8, "portal": 8}.get(animation_id, 0)
		var animation_texture := _texture("res://assets/animations/interactions/%s.png" % animation_id) if animation_id != "" else null
		if animation_texture != null and animation_count > 0:
			var h := (70.0 if it.kind == "portal" else 54.0) * size_scale
			var frame := int(Time.get_ticks_msec() / 100) % animation_count
			var w := h
			draw_texture_rect_region(animation_texture, Rect2(draw_p.x - w * 0.5, draw_p.y - h, w, h), Rect2(frame * 192, 0, 192, 192))
		elif texture != null:
			var h := (70.0 if it.kind == "portal" else 54.0) * size_scale
			var w := h * float(texture.get_width()) / float(texture.get_height())
			draw_texture_rect(texture, Rect2(draw_p.x - w * 0.5, draw_p.y - h, w, h), false)
		else:
			draw_colored_polygon(PackedVector2Array([draw_p + Vector2(0, -18), draw_p + Vector2(14, 0), draw_p + Vector2(0, 9), draw_p + Vector2(-14, 0)]), Color(col, 0.35))
			draw_rect(Rect2(draw_p + Vector2(-9, -22), Vector2(18, 16)), col.darkened(0.2))
		draw_string(ThemeDB.fallback_font, draw_p + Vector2(-32, -62), label, HORIZONTAL_ALIGNMENT_CENTER, 64, 12, Color(col, 0.95))
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
