class_name EventPointer
extends Control
## SPEC-159 (MEC-061): setas na borda da tela para os eventos de quest fora da área visível.
## As contas (ponto na borda, desvio da HUD, fusão) são estáticas e testadas; o desenho só as aplica.

const MARGIN := 28.0         # a seta fica inteira dentro da tela, a esta distância da borda
const MERGE_DIST := 40.0     # setas mais próximas que isto (px) viram uma só, com contagem
const MAX_ARROWS := 6
const PULSE_TIME := 0.6
const ARROW_LEN := 22.0
const ARROW_HALF := 11.0
const AVOID_PAD := 8.0
const FONT_SIZE := 14
const BOX_H := 26.0

var battle: Battle
var avoid_nodes: Array = []   # Controls da HUD que a seta não pode cobrir
var mobile: MobileControls
var _seen: Dictionary = {}    # key do marcador -> ms da primeira vez que apareceu fora da tela

## Onde a seta fica: `visible` quando o alvo já está dentro de `view`; senão, o ponto em que o raio
## origem → alvo cruza a borda de `view` e o ângulo (rad) da direção.
static func edge_point(view: Rect2, from: Vector2, target: Vector2) -> Dictionary:
	if view.has_point(target):
		return {"visible": true, "pos": target, "angle": 0.0}
	var o := from.clamp(view.position, view.end)
	var d := target - o
	if d.length_squared() < 0.0001:
		return {"visible": false, "pos": o, "angle": 0.0}
	var t := INF
	if d.x > 0.0:
		t = minf(t, (view.end.x - o.x) / d.x)
	elif d.x < 0.0:
		t = minf(t, (view.position.x - o.x) / d.x)
	if d.y > 0.0:
		t = minf(t, (view.end.y - o.y) / d.y)
	elif d.y < 0.0:
		t = minf(t, (view.position.y - o.y) / d.y)
	return {"visible": false, "pos": (o + d * t).clamp(view.position, view.end), "angle": d.angle()}

## Caixa que a seta ocupa: o quadrado da ponta em `p` mais a legenda (`caption_w` px), que vai para dentro da tela
## (à direita, ou à esquerda quando não cabe; `flip` inverte o lado).
static func box_rect(p: Vector2, view: Rect2, caption_w: float, flip: bool = false) -> Rect2:
	var total := BOX_H + 6.0 + caption_w
	var goes_left := p.x + total - BOX_H * 0.5 > view.end.x + MARGIN - 4.0
	if flip:
		goes_left = not goes_left
	var x := p.x + BOX_H * 0.5 - total if goes_left else p.x - BOX_H * 0.5
	return Rect2(x, p.y - BOX_H * 0.5, total, BOX_H)

static func _overlap(box: Rect2, rects: Array, pad: float) -> float:
	var area := 0.0
	for r in rects:
		var hit := box.intersection((r as Rect2).grow(pad))
		area += hit.size.x * hit.size.y
	return area

## Desliza `pos` ao longo da borda de `view` até a caixa (seta + legenda) sair de todos os retângulos `rects`,
## podendo virar a legenda para o outro lado. Sem lugar livre, fica onde a sobreposição é menor.
## Devolve {pos, flip}.
static func avoid(pos: Vector2, view: Rect2, rects: Array, caption_w: float = 0.0, pad: float = AVOID_PAD) -> Dictionary:
	var best := {"pos": pos, "flip": false}
	var best_area := INF
	var horizontal := absf(pos.y - view.position.y) < 1.0 or absf(pos.y - view.end.y) < 1.0
	var step := 6.0
	for k in range(0, 400):
		for sign in ([1.0, -1.0] if k > 0 else [1.0]):
			var p := pos + (Vector2(sign * k * step, 0.0) if horizontal else Vector2(0.0, sign * k * step))
			if not view.grow(0.01).has_point(p):
				continue
			for flip in [false, true]:
				var area := _overlap(box_rect(p, view, caption_w, flip), rects, pad)
				if area <= 0.0:
					return {"pos": p, "flip": flip}
				if area < best_area - 0.5:
					best_area = area
					best = {"pos": p, "flip": flip}
	return best

## Junta setas próximas (a mais perto do herói manda) e limita a `max_n`. Cada item: {pos, dist, label, color, key, count}.
static func group(items: Array, merge_dist: float = MERGE_DIST, max_n: int = MAX_ARROWS) -> Array:
	var sorted := items.duplicate()
	sorted.sort_custom(func(a, b): return float(a.dist) < float(b.dist))
	var out: Array = []
	for it in sorted:
		var merged := false
		for g in out:
			if (g.pos as Vector2).distance_to(it.pos) < merge_dist:
				g.count = int(g.count) + 1
				merged = true
				break
		if not merged:
			var g: Dictionary = it.duplicate()
			g.count = 1
			out.append(g)
	if out.size() > max_n:
		out.resize(max_n)
	return out

static func caption(item: Dictionary) -> String:
	var text := String(item.label)
	if int(item.count) > 1:
		text += " +%d" % (int(item.count) - 1)
	return "%s · %d m" % [text, int(round(float(item.dist)))]

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _process(_delta: float) -> void:
	queue_redraw()

## Setas prontas para desenhar (já na borda, fora da HUD, fundidas). `ms` é o relógio para o pulso de entrada.
func arrows(b: Battle, ms: int) -> Array:
	var ct := get_viewport().get_canvas_transform()
	var view := get_viewport_rect().grow(-MARGIN)
	var hero_s: Vector2 = ct * (Iso.to_screen(b.hero.pos) + Vector2(0, -30))
	var items: Array = []
	var alive: Dictionary = {}
	for m in b.happenings.markers(b):
		var e := edge_point(view, hero_s, ct * Iso.to_screen(m.pos))
		if e.visible:
			continue
		var key := String(m.key)
		alive[key] = true
		if not _seen.has(key):
			_seen[key] = ms
		items.append({"pos": e.pos, "angle": e.angle, "dist": b.hero.pos.distance_to(m.pos), "label": String(m.label), "color": m.color, "key": key,
			"age": (ms - int(_seen[key])) / 1000.0})
	for k in _seen.keys():
		if not alive.has(k):
			_seen.erase(k)
	var rects: Array = []
	for n in avoid_nodes:
		if is_instance_valid(n) and (n as Control).is_visible_in_tree() and (n as Control).size.y > 0.0:
			rects.append((n as Control).get_global_rect())
	if mobile != null and is_instance_valid(mobile):
		for r in mobile.regions.values():
			rects.append(r)
	var font := ThemeDB.fallback_font
	var out := group(items)
	for g in out:
		g.caption = caption(g)
		g.caption_w = font.get_string_size(String(g.caption), HORIZONTAL_ALIGNMENT_LEFT, -1, FONT_SIZE).x
		var spot := avoid(g.pos, view, rects, float(g.caption_w))
		g.pos = spot.pos
		g.flip = spot.flip
	return out

func _draw() -> void:
	if battle == null or not visible:
		return
	var font := ThemeDB.fallback_font
	var view := get_viewport_rect().grow(-MARGIN)
	for a in arrows(battle, Time.get_ticks_msec()):
		var dir := Vector2.from_angle(float(a.angle))
		var side := Vector2(-dir.y, dir.x)
		var p: Vector2 = a.pos
		var pop := clampf(1.0 - float(a.age) / PULSE_TIME, 0.0, 1.0)   # 1 -> 0 nos primeiros 0,6 s
		var col: Color = (a.color as Color).lightened(0.35)
		col.a = 1.0
		var k := 1.0 + 0.5 * pop
		var tip := p + dir * ARROW_LEN * 0.5 * k
		var back := p - dir * ARROW_LEN * 0.5 * k
		var half := ARROW_HALF * k
		if pop > 0.0:
			draw_circle(p, 26.0 + 14.0 * pop, Color(col, 0.35 * pop))
		draw_colored_polygon(PackedVector2Array([tip + dir * 3.0, back + side * (half + 3.0), back - side * (half + 3.0)]), Color(0, 0, 0, 0.7))
		draw_colored_polygon(PackedVector2Array([tip, back + side * half, back - side * half]), col)
		var box := box_rect(p, view, float(a.caption_w), bool(a.flip))
		var tx := box.position.x + BOX_H + 6.0 if box.position.x >= p.x - BOX_H * 0.5 - 0.5 else box.position.x
		var text := String(a.caption)
		draw_string_outline(font, Vector2(tx, p.y + 5.0), text, HORIZONTAL_ALIGNMENT_LEFT, -1, FONT_SIZE, 5, Color(0, 0, 0, 0.85))
		draw_string(font, Vector2(tx, p.y + 5.0), text, HORIZONTAL_ALIGNMENT_LEFT, -1, FONT_SIZE, col)
