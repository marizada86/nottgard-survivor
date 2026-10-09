extends RefCounted
## SPEC-164 (MEC-005): os seis eventos aleatórios novos.

func _bat(seed_value := 81, hero := "durvall", stage := "dagruve") -> Battle:
	var b := Battle.new(seed_value, hero, stage)
	b.hero.pos = Vector2(20, 20)
	b.stage.elites = b.stage.elites   # mantém elites e ondas (a emboscada usa as da fase)
	b._inter_t = 99999.0
	b._breakable_t = 99999.0
	b.stage.duration = 99999
	return b

func _row(b: Battle, opt: String) -> int:
	for i in b.offer.size():
		if String(b.offer[i].get("opt", "")) == opt:
			return i
	return -1

func _leave(b: Battle) -> int:
	for i in b.offer.size():
		if String(b.offer[i].t) == "shop_leave":
			return i
	return -1

func _count(b: Battle) -> int:
	var n := 0
	for e in b.enemies:
		if not e.dead:
			n += 1
	return n

func run() -> Array:
	var out: Array = []
	var cfg_all: Dictionary = Data.table("random_events").events

	# dados: os seis existem, têm nome, cor e intro; os pesos existem nas nove fases
	for kind in RandomEvents.KINDS:
		if not cfg_all.has(kind):
			out.append("evento sem dados: %s" % kind)
			continue
		var c: Dictionary = cfg_all[kind]
		if String(c.get("name", "")) == "" or String(c.get("intro", "")) == "" or not c.has("color"):
			out.append("%s: faltam nome, intro ou cor" % kind)
	var stages: Dictionary = Data.table("stages")
	for sid in stages:
		if String(sid).begins_with("_"):
			continue
		for kind in RandomEvents.KINDS:
			if float(stages[sid].get("interactions", {}).get(kind, 0.0)) <= 0.0:
				out.append("%s: sem peso para %s" % [sid, kind])

	# todo evento abre com "Sair" sem custo, e Sair não muda nada
	for kind in RandomEvents.KINDS:
		var lb := _bat()
		lb.hero.gold = 500
		var snapshot := [lb.hero.max_hp, lb.hero.hp, lb.hero.gold, lb.hero.run_mods.duplicate(), lb.world_mod.duplicate(), _count(lb)]
		lb._open_random_event(kind)
		if lb.state != "shop" or lb.offer_kind != "shop_%s" % kind:
			out.append("%s: deveria abrir a oferta (estado %s, tipo %s)" % [kind, lb.state, lb.offer_kind])
			continue
		var li := _leave(lb)
		if li < 0:
			out.append("%s: faltou 'Sair'" % kind)
			continue
		lb.choose(li)
		if lb.state != "running" or snapshot != [lb.hero.max_hp, lb.hero.hp, lb.hero.gold, lb.hero.run_mods.duplicate(), lb.world_mod.duplicate(), _count(lb)]:
			out.append("%s: 'Sair' não deveria custar nada nem mudar o estado" % kind)

	# interact(): um interativo de cada tipo abre o evento
	for kind in RandomEvents.KINDS:
		var ib := _bat()
		ib.interactions.append({"kind": kind, "pos": ib.hero.pos, "used": false, "born_at": -5.0})
		if not ib.interact() or ib.state != "shop" or ib.offer_kind != "shop_%s" % kind:
			out.append("%s: interact() não abriu o evento" % kind)

	# ---- Pacto de Sangue: contas puras
	var pc: Dictionary = cfg_all.pacto_sangue
	if RandomEvents.pact_cost(60.0, 0.15) != 9 or RandomEvents.pact_cost(48.0, 0.30) != 14:
		out.append("custo do selo: 15%% de 60 = 9 e 30%% de 48 = 14")
	if not RandomEvents.pact_allowed(60.0, 0.0, 0.30, pc):
		out.append("60 PV, nenhum pacto: o selo maior deveria valer")
	if RandomEvents.pact_allowed(60.0, 0.0, 0.50, pc):
		out.append("o selo de 50% passa do teto de 45%")
	if RandomEvents.pact_allowed(24.0, 0.0, 0.30, pc):
		out.append("vida máxima 24 - 7 = 17 fica abaixo do piso de 20")
	if RandomEvents.pact_allowed(54.0, 18.0, 0.15, pc) and RandomEvents.blood_room(54.0, 18.0, pc) < 8.0:
		out.append("o teto de 45%% não pode ser ultrapassado (sala %.1f)" % RandomEvents.blood_room(54.0, 18.0, pc))

	# ---- Pacto de Sangue no Battle
	var pb := _bat()
	pb.hero.hp = pb.hero.max_hp
	var max0 := pb.hero.max_hp
	var dmg0 := pb.hero.m("dmg_pct")
	pb._open_random_event("pacto_sangue")
	pb.choose(_row(pb, "menor"))
	var cost := float(RandomEvents.pact_cost(max0, 0.15))
	if absf(pb.hero.max_hp - (max0 - cost)) > 0.01:
		out.append("selo menor: vida máxima %.1f, esperava %.1f" % [pb.hero.max_hp, max0 - cost])
	if absf(pb.hero.m("dmg_pct") - (dmg0 + 0.12)) > 0.001:
		out.append("selo menor: dano +12%% (veio %.3f)" % (pb.hero.m("dmg_pct") - dmg0))
	if pb.hero.hp > pb.hero.max_hp + 0.001 or pb.hero.hp < 1.0:
		out.append("selo menor: a vida atual segue a máxima sem matar (%.1f de %.1f)" % [pb.hero.hp, pb.hero.max_hp])
	if absf(pb.event_blood_lost - cost) > 0.001:
		out.append("selo menor: perda acumulada deveria ser %.1f" % cost)
	pb._open_random_event("pacto_sangue")
	pb.choose(_row(pb, "maior"))
	if pb.hero.max_hp < max0 * 0.55 - 1.0:
		out.append("dois selos tiraram mais de 45%% da vida máxima (%.1f de %.1f)" % [pb.hero.max_hp, max0])
	pb._open_random_event("pacto_sangue")
	var after := pb.hero.max_hp
	for opt in ["menor", "maior"]:
		var i := _row(pb, opt)
		if i >= 0 and not bool(pb.offer[i].locked) and RandomEvents.blood_room(pb.hero.max_hp, pb.event_blood_lost, pc) < RandomEvents.pact_cost(pb.hero.max_hp, float(pc.options[0 if opt == "menor" else 1].hp_pct)):
			out.append("selo %s deveria estar travado depois do teto" % opt)
	# piso: herói frágil não paga o selo
	var low := _bat(82)
	low.hero.run_mods = {"hp": -(low.hero.max_hp - 22.0)}
	low.hero.recalc()
	low._open_random_event("pacto_sangue")
	if not bool(low.offer[_row(low, "maior")].locked):
		out.append("com 22 PV máximos o selo maior deveria estar travado")

	# ---- Relicário
	var rb := _bat(83)
	rb.hero.hp = rb.hero.max_hp
	rb.hero.gold = 1000
	rb._open_random_event("relicario")
	var gi := _row(rb, "ouro")
	var price: int = rb.offer[gi].price
	rb.choose(gi)
	if rb.hero.gold != 1000 - price:
		out.append("relicário a ouro: deveria cobrar %d (ouro %d)" % [price, rb.hero.gold])
	if rb.state != "item_offer" or rb.offer.is_empty() or int(Items.RANK[String(rb.offer[0].keep.rarity)]) < int(Items.RANK["magico"]):
		out.append("relicário a ouro: esperava oferta de item mágico ou melhor (estado %s)" % rb.state)
	var rs := _bat(84)
	rs.hero.hp = rs.hero.max_hp
	var hp_full := rs.hero.hp
	rs._open_random_event("relicario")
	rs.choose(_row(rs, "sangue"))
	if absf(rs.hero.hp - hp_full * 0.75) > 0.01:
		out.append("relicário a sangue: custa 25%% da vida atual (%.1f de %.1f)" % [rs.hero.hp, hp_full])
	if rs.state != "item_offer" or int(Items.RANK[String(rs.offer[0].keep.rarity)]) < int(Items.RANK["raro"]):
		out.append("relicário a sangue: esperava item raro ou melhor")
	var rl := _bat(85)
	rl.hero.hp = rl.hero.max_hp * 0.3
	rl._open_random_event("relicario")
	if not bool(rl.offer[_row(rl, "sangue")].locked):
		out.append("relicário a sangue com 30%% de vida deveria estar travado")
	var rp := _bat(86)
	rp.hero.gold = 10
	rp._open_random_event("relicario")
	if not bool(rp.offer[_row(rp, "ouro")].locked):
		out.append("relicário a ouro sem moedas deveria estar travado")

	# ---- Peregrino
	var pg := _bat(87)
	pg.hero.gold = 100
	var xp0: float = pg.hero.xp
	pg._open_random_event("peregrino")
	pg.choose(_row(pg, "ajudar"))
	if pg.hero.gold != 70:
		out.append("ajudar custa 30%% das moedas (100 -> 70, veio %d)" % pg.hero.gold)
	if not pg.hero.kind_buffs.has("gratidao_peregrino") or absf(pg.hero.m("xp_pct") - 0.08) > 0.001 and pg.hero.m("xp_pct") < 0.08:
		out.append("ajudar deveria dar a Gratidão do Peregrino (+8%% de XP)")
	if pg.hero.xp <= xp0 and pg.hero.level == 1:
		out.append("ajudar deveria dar XP")
	var pt := _bat(88)
	var xp1: float = pt.hero.xp
	var gold1: int = pt.hero.gold
	pt._open_random_event("peregrino")
	pt.choose(_row(pt, "conversar"))
	if pt.hero.xp <= xp1 and pt.hero.level == 1:
		out.append("conversar deveria dar XP")
	if pt.hero.gold != gold1:
		out.append("conversar não custa nem dá moedas")
	var pr := _bat(89)
	var n0 := _count(pr)
	var g0: int = pr.hero.gold
	var meta0 := float(pr.stats.gold)
	pr._open_random_event("peregrino")
	pr.choose(_row(pr, "roubar"))
	if pr.hero.gold <= g0:
		out.append("roubar deveria dar moedas")
	if _count(pr) != n0 + int(cfg_all.peregrino.steal_ambush):
		out.append("roubar deveria trazer %d inimigos (vieram %d)" % [int(cfg_all.peregrino.steal_ambush), _count(pr) - n0])
	if float(pr.stats.gold) != meta0:
		out.append("o ouro roubado não entra no ouro do Quartel")

	# ---- Contador de Histórias
	var ct := _bat(90)
	ct._open_random_event("contador")
	var stories := 0
	for o in ct.offer:
		if String(o.t) == "ev_choice":
			stories += 1
	if stories != 3:
		out.append("contador deveria mostrar 3 histórias (mostrou %d)" % stories)
	var first := -1
	for i in ct.offer.size():
		if String(ct.offer[i].t) == "ev_choice":
			first = i
			break
	var story_mods: Dictionary = ct.offer[first].mods.duplicate()
	var key: String = String(story_mods.keys()[0])
	var before := ct.hero.m(key)
	ct.choose(first)
	if absf(ct.hero.m(key) - before - float(story_mods[key])) > 0.001:
		out.append("a história deveria somar %s (%.3f -> %.3f)" % [key, before, ct.hero.m(key)])
	if ct.state != "running":
		out.append("escolher uma história encerra o evento")

	# ---- Carroça: os dois ramos aparecem e fazem o que dizem
	if RandomEvents.carroca_is_ambush(0.59, cfg_all.carroca) or not RandomEvents.carroca_is_ambush(0.60, cfg_all.carroca):
		out.append("a carroça é emboscada a partir de 0,60 (40%%)")
	var ambushes := 0
	var loots := 0
	for sd in range(1, 41):
		var cb := _bat(100 + sd)
		var cn := _count(cb)
		var cg: int = cb.hero.gold
		cb._open_random_event("carroca")
		cb.choose(_row(cb, "vasculhar"))
		if _count(cb) == cn + int(cfg_all.carroca.ambush_enemies) + 1:
			ambushes += 1
			var elite_chest := false
			for e in cb.enemies:
				if e.drops_chest:
					elite_chest = true
			if not elite_chest:
				out.append("a emboscada deveria ter um elite que solta baú")
		elif cb.state == "item_offer" or cb.hero.gold > cg:
			loots += 1
		else:
			out.append("carroça (semente %d): nem emboscada nem recompensa" % (100 + sd))
	if ambushes < 8 or loots < 12:
		out.append("40 carroças deveriam dar cerca de 40%% de emboscada (emboscadas %d, recompensas %d)" % [ambushes, loots])

	# ---- Eclipse
	var eb := _bat(91)
	eb._open_random_event("eclipse_pedra")
	eb.choose(_row(eb, "rubro"))
	if eb.world_mod.is_empty() or absf(float(eb.world_mod.enemy_speed) - 1.25) > 0.001:
		out.append("eclipse rubro deveria ligar o mundo (+25%% de velocidade)")
	if absf(RandomEvents.world_mult(eb.world_mod, "enemy_dmg", false) - 1.25) > 0.001 or RandomEvents.world_mult(eb.world_mod, "enemy_dmg", true) != 1.0:
		out.append("o eclipse afeta inimigos comuns e poupa chefes")
	if absf(RandomEvents.world_mult(eb.world_mod, "xp", false) - 1.5) > 0.001 or absf(RandomEvents.world_mult(eb.world_mod, "gold", false) - 1.5) > 0.001:
		out.append("o eclipse rubro dá XP e ouro ×1,5")
	eb._open_random_event("eclipse_pedra")
	if not bool(eb.offer[_row(eb, "rubro")].locked) or not bool(eb.offer[_row(eb, "prateado")].locked):
		out.append("com um eclipse ativo a pedra não oferece outro")
	eb.choose(_leave(eb))
	# o relógio: 90 s e acaba
	eb.step(Vector2.ZERO, 0.1)
	var t_left := float(eb.world_mod.t)
	if t_left > 90.0 or t_left < 89.0:
		out.append("o eclipse deveria durar ~90 s (restam %.1f)" % t_left)
	eb.world_mod.t = 0.05
	eb.step(Vector2.ZERO, 0.1)
	if not eb.world_mod.is_empty():
		out.append("o eclipse deveria acabar quando o relógio zera")
	var sb := _bat(92)
	sb._open_random_event("eclipse_pedra")
	sb.choose(_row(sb, "prateado"))
	if absf(RandomEvents.world_mult(sb.world_mod, "enemy_speed", false) - 0.8) > 0.001 or absf(RandomEvents.world_mult(sb.world_mod, "xp", false) - 0.8) > 0.001:
		out.append("eclipse prateado: inimigos −20%% e XP ×0,8")
	# efeito real na luta: XP do abate com e sem eclipse
	var xa := _bat(93)
	xa.hero.xp = 0.0
	var ea := xa._spawn("esqueleto_dagruve" if Data.table("enemies").has("esqueleto_dagruve") else String(xa.stage.waves[0].id), xa.hero.pos + Vector2(3, 0))
	var xp_base := float(ea.xp)
	xa.world_mod = {"id": "rubro", "name": "Eclipse Rubro", "enemy_speed": 1.25, "enemy_dmg": 1.25, "xp": 1.5, "gold": 1.5, "t": 60.0}
	if absf(RandomEvents.world_mult(xa.world_mod, "xp", ea.is_boss()) * xp_base - xp_base * 1.5) > 0.001:
		out.append("o XP do abate com eclipse rubro deveria ser ×1,5")


	# ---- estresse: 400 aberturas em todas as fases, qualquer opção (travada ou não), depois passos de simulação
	var fuzz := RandomNumberGenerator.new()
	fuzz.seed = 4242
	var stage_ids: Array = []
	for sid in stages:
		if not String(sid).begins_with("_"):
			stage_ids.append(String(sid))
	for n in 400:
		var fb := _bat(500 + n, ["durvall", "sylas", "arlindo", "erik", "bromnor"][n % 5], stage_ids[n % stage_ids.size()])
		fb.hero.gold = fuzz.randi_range(0, 900)
		fb.hero.hp = maxf(1.0, fb.hero.max_hp * fuzz.randf())
		var fkind: String = RandomEvents.KINDS[fuzz.randi() % RandomEvents.KINDS.size()]
		fb._open_random_event(fkind)
		if fb.offer.is_empty() or _leave(fb) < 0:
			out.append("estresse %d (%s): oferta vazia ou sem 'Sair'" % [n, fkind])
			continue
		fb.choose(fuzz.randi() % fb.offer.size())
		if fb.state == "shop":   # linha travada: a oferta continua aberta; 'Sair' fecha sem custo
			fb.choose(_leave(fb))
		var guard := 0
		while fb.state == "item_offer" and guard < 3:
			fb.choose(0)
			guard += 1
		for _i in 40:
			fb.step(Vector2.ZERO, 0.1)
			if fb.state == "levelup":
				fb.choose(0)
		if fb.state != "running" and fb.state != "dead" and fb.state != "revive_offer":
			out.append("estresse %d (%s, %s): estado inesperado '%s'" % [n, fkind, fb.stage_id, fb.state])
		if is_nan(fb.hero.hp) or is_nan(fb.hero.max_hp) or fb.hero.max_hp < 10.0 or fb.hero.hp > fb.hero.max_hp + 0.01:
			out.append("estresse %d (%s): vida inválida (%.1f de %.1f)" % [n, fkind, fb.hero.hp, fb.hero.max_hp])
		if fb.hero.gold < 0:
			out.append("estresse %d (%s): ouro negativo (%d)" % [n, fkind, fb.hero.gold])
	return out
