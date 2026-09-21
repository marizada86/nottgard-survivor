extends RefCounted

func _bat(seed_value := 1, hero := "durvall", stage := "dagruve") -> Battle:
	var b := Battle.new(seed_value, hero, stage)
	b.hero.pos = Vector2(20, 20)
	return b

func _quiet(b: Battle) -> void:
	# desliga o diretor para testes de unidade
	b.stage.waves = []
	b.stage.elites = []
	b.stage.duration = 99999
	b._inter_t = 99999.0

func run() -> Array:
	var out: Array = []

	# 1) XP e level-up: matar zumbi rende XP e gera oferta de 3
	var b := _bat()
	_quiet(b)
	var z := b.spawn_for_test("zumbi", Vector2(21, 20))
	for i in 1500:
		b.step(Vector2.ZERO, 0.016)
	if b.stats.kills < 1:
		out.append("zumbi não morreu")

	# 2) oferta de level-up: 3 escolhas, choose aplica e volta a running
	var c := _bat(3)
	_quiet(c)
	c._add_xp(500.0)
	if c.state != "levelup" or c.offer.size() < 3:
		out.append("level-up não abriu com 3 opções (state=%s n=%d)" % [c.state, c.offer.size()])
	else:
		var lv0 := c.hero.level
		var pend := c.pending_levels
		for k in pend:
			if c.state == "levelup":
				c.choose(0)
		if c.state != "running":
			out.append("estado não voltou a running após escolhas: %s" % c.state)
		if c.hero.level != lv0:
			out.append("nível mudou sem xp")

	# 3) determinismo por seed
	var a1 := _bat(7)
	var a2 := _bat(7)
	for i in 1200:
		a1.step(Vector2.ZERO, 0.016)
		a2.step(Vector2.ZERO, 0.016)
		if a1.state == "levelup": a1.choose(0)
		if a2.state == "levelup": a2.choose(0)
	if a1.stats.kills != a2.stats.kills or int(a1.hero.hp) != int(a2.hero.hp) or a1.enemies.size() != a2.enemies.size():
		out.append("simulação não determinística")

	# 4) armas por tipo disparam e causam dano
	for wid in ["espada_sombria", "raio_de_luz", "sentenca_de_lliira", "cera_fervente", "colar_dos_tentaculos", "golpe_atordoante", "descarga_estelar"]:
		var w := _bat(11)
		_quiet(w)
		w.hero.weapons = [Weapon.make(wid)]
		var tgt := w.spawn_for_test("zumbi", Vector2(21.2, 20))
		tgt.speed = 0.0
		tgt.atk_bonus = -99
		tgt.max_hp = 9999.0
		tgt.hp = 9999.0
		for i in 900:
			w.step(Vector2.ZERO, 0.016)
			w.hero.hp = w.hero.max_hp
		if tgt.hp >= tgt.max_hp:
			out.append("arma %s não causou dano" % wid)

	# 5) efeitos: weaken reduz CA; stun para o inimigo
	var e1 := _bat(5)
	_quiet(e1)
	e1.hero.weapons = [Weapon.make("raio_enfraquecedor")]
	var t1 := e1.spawn_for_test("zumbi", Vector2(22, 20))
	t1.speed = 0.0
	t1.max_hp = 9999.0
	t1.hp = 9999.0
	var ca0: int = t1.ca
	for i in 400:
		e1.step(Vector2.ZERO, 0.016)
	if t1.ca >= ca0:
		out.append("weaken não reduziu CA")

	# 6) resistência: radiante fura a Síntese, físico não
	var s1 := _bat(9, "durvall", "pilares")
	_quiet(s1)
	var boss := s1.spawn_for_test("sintese_abissal", Vector2(21, 20))
	if float(boss.resist.get("fisico", 1.0)) >= float(boss.resist.get("radiante", 1.0)):
		out.append("Síntese deveria resistir mais a físico que a radiante")

	# 7) inimigo à distância dispara projétil e pode ferir
	var r1 := _bat(4)
	_quiet(r1)
	r1.hero.weapons = []
	r1.spawn_for_test("cultista_arqueiro", Vector2(24, 20))
	var shot := false
	for i in 1500:
		r1.step(Vector2.ZERO, 0.016)
		if r1.projectiles.any(func(p): return p.owner == "enemy"):
			shot = true
	if not shot:
		out.append("arqueiro nunca atirou")

	# 8) morte do herói e segunda chance
	var d := _bat(2)
	_quiet(d)
	d.hero.weapons = []
	for i in 6:
		d.spawn_for_test("cultista_adaga", Vector2(20.5 + i * 0.05, 20.5))
	for i in 4000:
		d.step(Vector2.ZERO, 0.016)
	if not d.hero.dead:
		out.append("herói deveria ter morrido")
	var rv := Battle.new(2, "durvall", "dagruve", {"meta_mods": {"revive": 1}})
	_quiet(rv)
	rv.hero.pos = Vector2(20, 20)
	rv.hero.weapons = []
	for i in 6:
		rv.spawn_for_test("cultista_adaga", Vector2(20.5 + i * 0.05, 20.5))
	var revived := false
	for i in 4000:
		rv.step(Vector2.ZERO, 0.016)
		if rv.revive_left == 0:
			revived = true
			break
	if not revived:
		out.append("segunda chance não disparou")

	# 9) itens: rolagem gera item válido; equipar concede arma do item
	var it := _bat(6)
	var got := 0
	for i in 200:
		var item := Items.roll(it.rng, 3, 0.0)
		if not item.has("slot") or not Items.RANK.has(item.rarity):
			out.append("item inválido")
			break
		got += 1
	it.give_item(Items.unique(Data.table("items").uniques[0]))
	if not it.hero.weapons.any(func(w): return w.id == "machado_de_xargath"):
		out.append("item único não concedeu a arma")

	# 10) evolução: arma nv5 + passiva libera a evolução na oferta
	var ev := _bat(8)
	_quiet(ev)
	ev.hero.weapons = [Weapon.make("espada_sombria", 5)]
	ev.hero.passives = {"cota_de_malha": 1}
	ev.hero.meta_mods = {"choices": 60}
	ev.hero.recalc()
	var offer := ev._build_offer()
	if not offer.any(func(o): return o.t == "evolve"):
		out.append("evolução não apareceu na oferta")
	else:
		ev.state = "levelup"
		ev.offer = offer
		ev.pending_levels = 1
		ev.offer_kind = "levelup"
		ev.choose(offer.find(offer.filter(func(o): return o.t == "evolve")[0]))
		if ev.hero.weapons[0].id != "espada_do_receptaculo":
			out.append("evolução não trocou a arma")

	# 11) chefe morto abre portal e leva à próxima fase
	var bs := _bat(12)
	_quiet(bs)
	var bb := bs.spawn_for_test("sacerdote_mente_derretida", Vector2(21, 20))
	bb.hp = 1.0
	bs._hero_hit(bb, {"dice": "1d4", "dmg": 50, "attr": "forca", "dtype": "fisico"}, false)
	if not bs.stage_cleared or not bs.interactions.any(func(i): return i.kind == "portal"):
		out.append("chefe não abriu o portal")
	else:
		bs.hero.pos = bs.interactions.filter(func(i): return i.kind == "portal")[0].pos
		bs.interact()
		if bs.stage_id != "shedaklah":
			out.append("portal não levou a shedaklah (%s)" % bs.stage_id)

	# 12) todas as fases carregam e o diretor spawna sem quebrar
	for sid in Data.table("stages"):
		var sb := Battle.new(1, "durvall", sid)
		for i in 3000:
			sb.step(Vector2.ZERO, 0.05)
			if sb.state == "levelup":
				sb.choose(0)
			elif sb.state == "altar":
				sb.choose(0)
			sb.hero.hp = sb.hero.max_hp
		if sb.enemies.is_empty():
			out.append("fase %s sem inimigos após 150s" % sid)

	return out
