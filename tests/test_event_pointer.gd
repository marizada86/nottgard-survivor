extends RefCounted
## SPEC-159 (MEC-061): seta de evento na borda da tela (contas puras e marcadores de Happenings).

const VIEW := Rect2(28, 28, 1224, 664)   # 1280x720 com a margem de 28 px
const CENTER := Vector2(640, 360)

func run() -> Array:
	var out: Array = []
	_check_edge_point(out)
	_check_avoid(out)
	_check_group(out)
	_check_caption(out)
	_check_markers(out)
	return out

func _on_border(p: Vector2) -> bool:
	return is_equal_approx(p.x, VIEW.position.x) or is_equal_approx(p.x, VIEW.end.x) or is_equal_approx(p.y, VIEW.position.y) or is_equal_approx(p.y, VIEW.end.y)

func _check_edge_point(out: Array) -> void:
	var inside := EventPointer.edge_point(VIEW, CENTER, Vector2(900, 400))
	if not inside.visible:
		out.append("alvo dentro da área visível deveria devolver visible=true")
	for dir in [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN, Vector2(1, 1), Vector2(-1, 1), Vector2(1, -1), Vector2(-1, -1)]:
		var e := EventPointer.edge_point(VIEW, CENTER, CENTER + dir.normalized() * 5000.0)
		if e.visible:
			out.append("alvo longe em %s não deveria estar visível" % dir)
			continue
		if not _on_border(e.pos) or not VIEW.grow(0.01).has_point(e.pos):
			out.append("a seta de %s deveria ficar sobre a borda encolhida (veio %s)" % [dir, e.pos])
		if absf(angle_difference(float(e.angle), dir.angle())) > 0.001:
			out.append("ângulo errado para %s: %f" % [dir, float(e.angle)])
	# alvo logo à direita, fora: encosta na borda direita na altura do herói
	var r := EventPointer.edge_point(VIEW, CENTER, Vector2(2000, 360))
	if not is_equal_approx(r.pos.x, VIEW.end.x) or not is_equal_approx(r.pos.y, 360.0):
		out.append("alvo à direita deveria parar em (%f, 360), veio %s" % [VIEW.end.x, r.pos])
	# alvo sobre o herói: sem divisão por zero e sem seta
	var same := EventPointer.edge_point(VIEW, CENTER, CENTER)
	if not same.visible:
		out.append("alvo sobre o herói está dentro da área visível")
	var degenerate := EventPointer.edge_point(Rect2(0, 0, 10, 10), Vector2(50, 50), Vector2(50, 50))
	if degenerate.visible or not Rect2(0, 0, 10, 10).grow(0.01).has_point(degenerate.pos):
		out.append("origem e alvo iguais fora da área não podem estourar nem sair dela")

func _check_avoid(out: Array) -> void:
	var block := Rect2(500, 0, 300, 120)   # painel no topo central
	var pad := EventPointer.AVOID_PAD
	var free := EventPointer.avoid(Vector2(1000, VIEW.position.y), VIEW, [block], 100.0)
	if free.pos != Vector2(1000, VIEW.position.y) or free.flip:
		out.append("caixa fora do painel não deveria mexer")
	# a seta está fora do painel, mas a legenda (150 px para a direita) entra nele: tem que sair
	var moved := EventPointer.avoid(Vector2(420, VIEW.position.y), VIEW, [block], 150.0)
	if EventPointer.box_rect(moved.pos, VIEW, 150.0, moved.flip).intersects(block.grow(pad)) or not is_equal_approx(moved.pos.y, VIEW.position.y):
		out.append("a seta no topo deveria sair do painel, ao longo da borda (veio %s)" % [moved])
	var blocker := Rect2(0, 0, 300, 200)
	var side := EventPointer.avoid(Vector2(VIEW.position.x, 60), VIEW, [blocker], 80.0)
	if not is_equal_approx(side.pos.x, VIEW.position.x) or EventPointer.box_rect(side.pos, VIEW, 80.0, side.flip).intersects(blocker.grow(pad)):
		out.append("a seta na borda esquerda deveria descer ao longo da borda (veio %s)" % [side])
	# legenda perto da borda direita vai para a esquerda, dentro da tela
	var box := EventPointer.box_rect(Vector2(VIEW.end.x, 300), VIEW, 160.0)
	if box.end.x > VIEW.end.x + EventPointer.MARGIN or box.position.x > VIEW.end.x - 100.0:
		out.append("a legenda na borda direita deveria ir para a esquerda da seta (caixa %s)" % box)
	# sem lugar livre (faixa estreita entre dois blocos): escolhe o ponto de menor sobreposição, sem sair da borda
	var wall := [Rect2(0, 0, 400, 200), Rect2(450, 0, 800, 200)]
	var tight := EventPointer.avoid(Vector2(420, VIEW.position.y), VIEW, wall, 300.0)
	if not VIEW.grow(0.01).has_point(tight.pos) or not is_equal_approx(tight.pos.y, VIEW.position.y):
		out.append("sem lugar livre a seta deve ficar sobre a borda (veio %s)" % [tight])

func _item(pos: Vector2, dist: float, label: String) -> Dictionary:
	return {"pos": pos, "dist": dist, "label": label, "color": Color.WHITE, "key": label}

func _check_group(out: Array) -> void:
	var items := [_item(Vector2(1252, 300), 30.0, "B"), _item(Vector2(1252, 320), 12.0, "A"), _item(Vector2(100, 28), 40.0, "C")]
	var g := EventPointer.group(items)
	if g.size() != 2:
		out.append("duas setas a 20 px deveriam virar uma (há %d)" % g.size())
		return
	var near: Dictionary = g.filter(func(x): return int(x.count) == 2)[0]
	if String(near.label) != "A":
		out.append("na fusão manda o evento mais perto do herói (veio %s)" % near.label)
	var many: Array = []
	for i in 10:
		many.append(_item(Vector2(40 + i * 100, 28), float(i), "E%d" % i))
	if EventPointer.group(many).size() != EventPointer.MAX_ARROWS:
		out.append("no máximo %d setas ao mesmo tempo" % EventPointer.MAX_ARROWS)
	if String(EventPointer.group(many)[0].label) != "E0":
		out.append("as mais próximas ficam")

func _check_caption(out: Array) -> void:
	var text := EventPointer.caption({"label": "Cura", "dist": 23.6, "count": 1})
	if text != "Cura · 24 m":
		out.append("legenda esperada 'Cura · 24 m', veio '%s'" % text)
	if EventPointer.caption({"label": "Cura", "dist": 5.0, "count": 3}) != "Cura +2 · 5 m":
		out.append("legenda fundida deveria trazer +2")

func _check_markers(out: Array) -> void:
	var b := Battle.new(7, "durvall", "shedaklah")
	b.stage.waves = []
	b.stage.elites = []
	b.stage.duration = 99999
	b._inter_t = 99999.0
	b._breakable_t = 99999.0
	var def: Dictionary = {}
	for d in Data.table("stage_events").get("shedaklah", []):
		if String(d.id) == "portal_sem_vao":
			def = d.duplicate(true)
	b.happenings.fire(b, def)
	var ms := b.happenings.markers(b)
	var kinds := ms.map(func(m): return String(m.kind))
	if kinds.count("event_item") != 2 or kinds.count("event_target") != 1:
		out.append("portal sem vão: 2 itens e 1 destino com marcador (veio %s)" % [kinds])
	for m in ms:
		if String(m.label) == "" or String(m.label).length() > 18 or String(m.key) == "":
			out.append("todo marcador traz label curto e key (veio %s)" % [m])
	# item pego some
	var item: Dictionary = b.interactions.filter(func(i): return String(i.kind) == "event_item")[0]
	item.used = true
	if b.happenings.markers(b).size() != ms.size() - 1:
		out.append("evento já usado deveria sair dos marcadores")
	# arena e Estrela do Norte entram
	b.happenings.arena = {"obj": "x", "pos": Vector2(10, 10), "radius": 3.0}
	b.kinds.star.pos = Vector2(20, 20)
	b.kinds.star.has = true
	var k2 := b.happenings.markers(b).map(func(m): return String(m.kind))
	if not k2.has("arena") or not k2.has("north_star"):
		out.append("a arena e a Estrela do Norte deveriam ter marcador (veio %s)" % [k2])
	# Ecos nunca entram
	b.ecos.append({"id": "e1", "pos": Vector2(30, 30), "found": false})
	if b.happenings.markers(b).any(func(m): return Vector2(m.pos) == Vector2(30, 30)):
		out.append("Ecos não podem ter seta")
	# concluído: sem marcadores do objetivo
	for it in b.interactions:
		it.used = true
	b.happenings.arena = {}
	b.kinds.star.has = false
	if not b.happenings.markers(b).is_empty():
		out.append("sem eventos abertos, sem marcadores")
