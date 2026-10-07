extends RefCounted
## SPEC-129 B-005: eventos divinos (Altar disputado em Feng-tu e Shedaklah; recompensa `god_boon`).

func _bat(stage: String) -> Battle:
	var b := Battle.new(7, "durvall", stage)
	b.stage.waves = []
	b.stage.elites = []
	b.stage.duration = 99999
	b._inter_t = 99999.0
	b._breakable_t = 99999.0
	b.hero.max_hp = 9999.0
	b.hero.hp = 9999.0
	return b

func _open(b: Battle, stage: String, id: String) -> bool:
	for d in Data.table("stage_events").get(stage, []):
		if String(d.id) == id:
			b.happenings.fire(b, d.duplicate(true))
	var pts: Array = b.interactions.filter(func(it): return String(it.kind) == "event_pact" and not it.used)
	if pts.is_empty():
		return false
	b.hero.pos = pts[0].pos
	pts[0].born_at = -10.0
	return b.interact() and b.state == "shop" and b.offer_kind == "pact"

func _ids(b: Battle) -> Array:
	return b.hero.boons.map(func(x): return String(x.id))

func _count(b: Battle, enemy_id: String) -> int:
	return b.enemies.filter(func(e): return String(e.id) == enemy_id).size()

func run() -> Array:
	var out: Array = []
	var pairs := [["feng_tu", "altar_disputado_feng_tu", "Tou Um", "Lu Yueh"], ["shedaklah", "altar_disputado_shedaklah", "Zuggtmoy", "Juiblex"]]
	var boon_ids := {}
	for bn in Data.table("boons").boons:
		boon_ids[String(bn.id)] = String(bn.god)
	for p in pairs:
		var stage: String = p[0]
		var id: String = p[1]
		var def := {}
		for d in Data.table("stage_events").get(stage, []):
			if String(d.id) == id:
				def = d
		if def.is_empty():
			out.append("evento %s ausente em %s" % [id, stage])
			continue
		if String(def.get("pool", "")) != "optional":
			out.append("%s deveria somar como opcional (D4)" % id)
		# dados: cada escolha concede bênção do deus certo e todo id existe
		var gods := []
		for c in def.choices:
			for gid in c.effect.get("god_boon", []):
				if not boon_ids.has(String(gid)):
					out.append("%s: bênção %s inexistente" % [id, gid])
				else:
					gods.append(boon_ids[String(gid)])
		if not (String(p[2]) in gods and String(p[3]) in gods):
			out.append("%s deveria oferecer bênçãos de %s e de %s" % [id, p[2], p[3]])
		# primeira escolha: bênção do primeiro deus, inimigos do rival, a oferta fecha
		var b := _bat(stage)
		if not _open(b, stage, id):
			out.append("%s: E no altar deveria abrir o pacto" % id)
			continue
		if String(b.offer[-1].t) != "shop_leave":
			out.append("%s: o altar disputado deveria poder ser recusado" % id)
		var before := _ids(b).size()
		b.choose(0)
		if b.state != "running":
			out.append("%s: escolher deveria voltar a running" % id)
		if _ids(b).size() != before + 1 or Favor.count(b.hero.boons, String(p[2])) != 1:
			out.append("%s: a primeira escolha deveria dar 1 bênção de %s (bênçãos %s)" % [id, p[2], _ids(b)])
		if b.enemies.size() < 6:
			out.append("%s: o rival deveria se revoltar com 6 inimigos (há %d)" % [id, b.enemies.size()])
		# segunda escolha: bênção do segundo deus
		var c2 := _bat(stage)
		_open(c2, stage, id)
		c2.choose(1)
		if Favor.count(c2.hero.boons, String(p[3])) != 1:
			out.append("%s: a segunda escolha deveria dar 1 bênção de %s" % [id, p[3]])
		# recusar não dá nada
		var d2 := _bat(stage)
		_open(d2, stage, id)
		d2.choose(d2.offer.size() - 1)
		if not d2.hero.boons.is_empty() or d2.state != "running":
			out.append("%s: recusar não deve dar bênção" % id)
		# sem repetir: se o herói já tem todas as bênçãos do deus, vira moedas
		var e := _bat(stage)
		for gid in def.choices[0].effect.god_boon:
			for bn in Data.table("boons").boons:
				if String(bn.id) == String(gid):
					e.hero.boons.append(bn)
		_open(e, stage, id)
		var n_before := _ids(e).size()
		e.choose(0)
		if _ids(e).size() != n_before:
			out.append("%s: sem bênção nova para dar não deve duplicar" % id)
		if not e.pickups.any(func(pk): return String(pk.kind) == "gold"):
			out.append("%s: sem bênção nova deveria cair ouro" % id)
	return out
