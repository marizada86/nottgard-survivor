extends RefCounted

const TerrainLayout := preload("res://core/terrain_layout.gd")
const SceneryLayoutRef := preload("res://ui/scenery_layout.gd")
const PropRef := preload("res://ui/prop.gd")

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
	b._breakable_t = 99999.0

func run() -> Array:
	var out: Array = []

	# MEC-007: quebráveis mais frequentes que o intervalo antigo de 35-55 s; Carisma encurta
	var bk_t := _bat(51)
	var bk_avg := 0.0
	for i in 40:
		bk_avg += bk_t._breakable_interval()
	bk_avg /= 40.0
	if bk_avg >= 35.0:
		out.append("intervalo médio dos quebráveis deveria ser menor que o antigo (%.1f s)" % bk_avg)
	var bk_hi := _bat(51)
	bk_hi.hero.base_attrs["carisma"] = 20
	var hi_sum := 0.0
	for i in 40:
		hi_sum += bk_hi._breakable_interval()
	if hi_sum / 40.0 >= bk_avg:
		out.append("Carisma alto deveria encurtar o intervalo dos quebráveis")

	# MEC-022: a perda de INT do Estige some sozinha depois de styx_lucidity_seconds
	var sl := _bat(52)
	_quiet(sl)
	sl.hero.styx_lucidity_loss = 2
	sl._styx_loss_expiry = [sl.run_time + 300.0, sl.run_time + 320.0]
	sl.run_time += 301.0
	sl._styx_step(0.016)
	if sl.hero.styx_lucidity_loss != 1:
		out.append("a primeira perda de INT deveria expirar aos 300 s (perda agora %d)" % sl.hero.styx_lucidity_loss)
	sl.run_time += 30.0
	sl._styx_step(0.016)
	if sl.hero.styx_lucidity_loss != 0:
		out.append("a segunda perda de INT deveria expirar depois")

	# MEC-013: baú do chefe sempre raro ou melhor
	var bc := _bat(53)
	_quiet(bc)
	var bad_rarity := 0
	for i in 20:
		bc.hero.items.clear()
		bc._open_boss_chest()
		var got: Dictionary = bc.hero.items.values()[0] if not bc.hero.items.is_empty() else {}
		if not got.is_empty() and int(Items.RANK[got.rarity]) < int(Items.RANK["raro"]):
			bad_rarity += 1
	if bad_rarity > 0:
		out.append("baú do chefe entregou item abaixo de raro %d vez(es)" % bad_rarity)

	# MEC-018: faixa de dano com atributos; MEC-008: dica de evolução
	var dm := _bat(61)
	_quiet(dm)
	var sw := Weapon.make("espada_sombria")
	var rng_dm := dm.weapon_damage_range(sw.params())
	var expect_min: int = 1 + dm.hero.attr_mod("forca")
	if rng_dm.x < 1 or rng_dm.y <= rng_dm.x or absf(float(rng_dm.x) - maxf(1.0, float(expect_min) * (1.0 + dm.hero.m("dmg_pct")))) > 1.0:
		out.append("faixa de dano da espada deveria refletir 1d8 + FOR: %s" % str(rng_dm))
	if dm.weapon_damage_text(sw.params()).find("FOR") < 0:
		out.append("texto de dano deveria citar o atributo que escala")
	if Dice.bounds("2d6") != Vector2i(2, 12):
		out.append("Dice.bounds de 2d6 deveria ser 2 a 12")
	if dm.evolve_hint(sw).find("Falta") < 0:
		out.append("dica de evolução deveria dizer o que falta")
	sw.level = Weapon.MAX_LEVEL
	dm.hero.passives["cota_de_malha"] = 1
	if dm.evolve_hint(sw).find("Pronta") < 0:
		out.append("dica de evolução deveria avisar que a arma está pronta")

	# MEC-021: recusar a troca 3 vezes seguidas sobe o nível do item equipado
	var fk := _bat(71)
	_quiet(fk)
	var cota_b: Dictionary = Data.table("items").bases.armadura.filter(func(b): return b.id == "cota")[0]
	fk.hero.items["armadura"] = {"id": "cota_fk", "base": "cota", "name": "Cota", "slot": "armadura", "rarity": "comum", "mods": cota_b.mods.duplicate(), "level": 1}
	for i in 3:
		fk.give_item({"id": "novo_%d" % i, "name": "Novo", "slot": "armadura", "rarity": "comum", "mods": {"ca": 1.0}, "level": 1})
		if i == 0 and String(fk.offer[1].desc).find("Fidelidade 1/3") < 0:
			out.append("oferta de manter deveria mostrar o progresso da fidelidade")
		fk.choose(1)
	if int(fk.hero.items.armadura.level) != 2:
		out.append("3 recusas seguidas deveriam subir o item para Nv 2 (nível %d)" % int(fk.hero.items.armadura.level))
	fk.give_item({"id": "novo_x", "name": "Novo", "slot": "armadura", "rarity": "comum", "mods": {"ca": 1.0}, "level": 1})
	fk.choose(0)
	fk.give_item({"id": "novo_y", "name": "Novo", "slot": "armadura", "rarity": "comum", "mods": {"ca": 1.0}, "level": 1})
	fk.choose(1)
	if int(fk.keep_streak.get("armadura", 0)) != 0:
		out.append("equipar um item novo deveria zerar a sequência (e itens sem nível não contam)")

	# MEC-005: Altar da Doação troca um item por uma bênção à escolha; Mesa de Aposta mexe só em hero.gold
	var dn := _bat(81)
	_quiet(dn)
	dn.hero.items["anel"] = {"id": "anel_dn", "name": "Anel de Teste", "slot": "anel", "rarity": "raro", "mods": {"cam": 2.0}, "level": 1}
	dn.hero.recalc()
	dn._open_risk_event("doacao")
	if dn.state != "shop" or String(dn.offer[0].t) != "donate":
		out.append("altar da doação deveria oferecer doar o item equipado")
	else:
		dn.choose(0)
		if dn.hero.items.has("anel") or dn.state != "altar" or dn.offer.size() < 1:
			out.append("doar deveria remover o item e abrir a escolha de bênção (estado %s)" % dn.state)
	var gb := _bat(82)
	_quiet(gb)
	gb.hero.gold = 100
	var gold_hist := float(gb.stats.gold)
	gb._open_risk_event("aposta")
	gb.choose(0)
	if gb.hero.gold != 120 and gb.hero.gold != 80:
		out.append("aposta de 20 deveria terminar em 120 ou 80 moedas (agora %d)" % gb.hero.gold)
	if float(gb.stats.gold) != gold_hist:
		out.append("aposta não deve alterar o ouro histórico da run")
	if gb.state != "running":
		out.append("aposta deveria fechar a mesa depois de resolver")
	var gb2 := _bat(83)
	_quiet(gb2)
	gb2.hero.gold = 5
	gb2._open_risk_event("aposta")
	gb2.choose(0)
	if gb2.state != "shop" or gb2.hero.gold != 5:
		out.append("aposta sem moedas suficientes deveria ficar travada")

	# MEC-014: PV por nível a partir de start_level; MEC-015: novos aprimoramentos existem e têm custo crescente
	var lg := _bat(91)
	_quiet(lg)
	lg.hero.level = 14
	lg.hero.recalc()
	var hp14 := lg.hero.max_hp
	lg.hero.level = 24
	lg.hero.recalc()
	if lg.hero.max_hp - hp14 < 9.9:
		out.append("nível 24 deveria ter cerca de 10 PV a mais que o nível 14 (%.1f)" % (lg.hero.max_hp - hp14))
	var up_ids: Array = []
	for u in Data.table("upgrades").upgrades:
		up_ids.append(u.id)
		for i in range(1, u.costs.size()):
			if int(u.costs[i]) <= int(u.costs[i - 1]):
				out.append("custo do aprimoramento %s deveria crescer a cada nível" % u.id)
	for needed in ["corpo_de_ferro", "mente_aguda", "braco_forte", "presenca", "regeneracao_meta"]:
		if not up_ids.has(needed):
			out.append("aprimoramento novo ausente: %s" % needed)

	# MEC-011: perseguidores flanqueiam (curvam de lado) e ainda chegam ao herói; parte segue reta
	var fl := _bat(101)
	_quiet(fl)
	var sides := {}
	for i in 40:
		var fe := fl._spawn("zumbi", Vector2(30.0, 5.0 + float(i) * 0.5))
		sides[fe.flank_side] = int(sides.get(fe.flank_side, 0)) + 1
	if not sides.has(1) or not sides.has(-1) or not sides.has(0):
		out.append("deveria haver flanqueadores dos dois lados e perseguidores diretos: %s" % str(sides))
	var straight := Enemy.make("zumbi", Vector2(30.0, 20.0))
	var curved := Enemy.make("zumbi", Vector2(30.0, 20.0))
	curved.flank_side = 1
	for i in 25:
		fl.enemies = [straight, curved]
		fl._enemy_step(straight, 0.1)
		fl._enemy_step(curved, 0.1)
	if absf(straight.pos.y - 20.0) > 0.05:
		out.append("perseguidor direto não deveria sair da linha reta")
	if absf(curved.pos.y - 20.0) < 0.3:
		out.append("flanqueador deveria curvar para o lado (y=%.2f)" % curved.pos.y)
	var reached := 99.0
	for i in 600:
		fl._enemy_step(curved, 0.05)
		reached = minf(reached, curved.pos.distance_to(fl.hero.pos))
	if reached > 2.0:
		out.append("flanqueador deveria acabar chegando ao herói (%.1f)" % reached)

	# MEC-009: evoluir a arma abre a mini-cinemática, que para o jogo e some sozinha ou ao pular
	var evb := _bat(111)
	_quiet(evb)
	var evb_w := Weapon.make("espada_sombria")
	evb_w.level = Weapon.MAX_LEVEL
	evb.hero.weapons = [evb_w]
	evb.hero.passives["cota_de_malha"] = 1
	evb.state = "levelup"
	evb.offer = [{"t": "evolve", "id": "espada_sombria", "into": "espada_do_receptaculo", "name": "x", "desc": ""}]
	evb.choose(0)
	evb.step(Vector2.ZERO, 0.016)
	if evb.state != "evolve_cine" or String(evb.evolve_cine.get("into", "")) != "espada_do_receptaculo":
		out.append("evoluir deveria abrir a mini-cinemática (estado %s)" % evb.state)
	var t_evb := evb.time
	evb.step(Vector2.ZERO, 0.5)
	if evb.time != t_evb:
		out.append("o jogo deveria ficar parado durante a cinemática")
	evb.step(Vector2.ZERO, 5.0)
	if evb.state != "running":
		out.append("a cinemática deveria acabar sozinha")
	var evb2 := _bat(112)
	_quiet(evb2)
	evb2.state = "evolve_cine"
	evb2.evolve_cine = {"from": "a", "into": "b", "passive": "", "level": 5}
	evb2.skip_cine()
	if evb2.state != "running":
		out.append("pular a cinemática deveria voltar ao jogo")

	# MEC-010: 2x só em fase já vencida
	var sp := _bat(41)
	_quiet(sp)
	if sp.toggle_speed() or sp.speed_scale() != 1.0:
		out.append("2x não deveria ligar em fase ainda não vencida")
	sp.cleared_stages = ["dagruve"]
	if not sp.toggle_speed() or sp.speed_scale() != 1.5:
		out.append("primeiro toggle deveria ligar 1,5x em fase já vencida")
	if not sp.toggle_speed() or sp.speed_scale() != 2.0:
		out.append("segundo toggle deveria ir para 2x")
	if sp.toggle_speed() or sp.speed_scale() != 1.0:
		out.append("terceiro toggle deveria voltar à velocidade normal")

	# MEC-010: a Ampulheta adianta o relógio e despeja os spawns acumulados
	var hg := _bat(42)
	hg.hero.max_hp = 99999.0
	hg.hero.hp = 99999.0
	hg.time = 30.0
	var n_before := hg.enemies.size()
	hg._add_interaction("ampulheta", hg.hero.pos + Vector2(0.5, 0.0))
	hg.interactions[hg.interactions.size() - 1].born_at = -5.0
	if not hg.interact():
		out.append("ampulheta deveria ser interagível com E")
	if hg.time < 89.0 or hg.time > 91.0:
		out.append("ampulheta deveria adiantar 60 s (tempo agora %.1f)" % hg.time)
	if hg.enemies.size() <= n_before:
		out.append("ampulheta deveria despejar inimigos acumulados")
	var hb := _bat(43)
	_quiet(hb)
	hb.boss_spawned = true
	hb._add_interaction("ampulheta", hb.hero.pos + Vector2(0.5, 0.0))
	hb.interactions[hb.interactions.size() - 1].born_at = -5.0
	var t_boss := hb.time
	if hb.interact() or hb.time != t_boss:
		out.append("ampulheta não deveria agir depois de o chefe surgir")

	# MEC-024: a abertura da fase é mais cheia e decai; sem o bônus a contagem cai
	var op := _bat(31)
	_quiet(op)
	op.time = 0.0
	if not is_equal_approx(op.opening_factor(), 1.0):
		out.append("abertura deveria valer 1.0 no início")
	op.time = 165.0
	if absf(op.opening_factor() - 0.5) > 0.01:
		out.append("abertura deveria decair para 0.5 na metade do fade (%.2f)" % op.opening_factor())
	op.time = 240.0
	if op.opening_factor() != 0.0:
		out.append("abertura deveria acabar em fade_seconds")
	var open_counts: Array = []
	for with_bonus in [true, false]:
		var oc := _bat(32)
		oc.hero.max_hp = 99999.0
		oc.hero.hp = 99999.0
		var od: Dictionary = Data.table("difficulty").opening
		var saved: Dictionary = od.duplicate()
		if not with_bonus:
			od.cap_bonus = 0
			od.n_mult = 1.0
			od.max_mult = 1.0
			od.every_mult = 1.0
		for i in 900:
			oc._director(0.1)
		open_counts.append(oc.enemies.size())
		od.merge(saved, true)
	if int(open_counts[0]) <= int(open_counts[1]):
		out.append("abertura deveria gerar mais inimigos: com bônus %d, sem bônus %d" % [open_counts[0], open_counts[1]])

	# MEC-026: interromper o ritual dá bênção temporária que expira
	var rb := _bat(33)
	_quiet(rb)
	var dmg0 := rb.hero.m("dmg_pct")
	rb.zones.append({"owner": "stage", "kind": "rule_ritual", "pos": rb.hero.pos, "radius": 1.7, "delay": 7.0, "total": 7.0, "interrupt": 1.5, "progress": 0.0, "life": 99.0})
	for i in 30:
		rb.step(Vector2.ZERO, 0.1)
	if rb.hero.temp_t <= 0.0 or rb.hero.m("dmg_pct") <= dmg0 + 0.1:
		out.append("interromper o ritual deveria dar bênção temporária (temp_t=%.1f)" % rb.hero.temp_t)
	for i in 260:
		rb.hero.step(Vector2.ZERO, 0.1)
	if rb.hero.temp_t != 0.0 or absf(rb.hero.m("dmg_pct") - dmg0) > 0.001:
		out.append("a bênção do selo deveria expirar e voltar ao dano base")

	# 0) BUG-012: inimigo com obstáculo redondo exatamente entre ele e o herói contorna e chega; o Esquecimento do Estige (restrição do herói) não o trava
	var ob := _bat(7)
	_quiet(ob)
	ob.hero.blockers = [Vector3(24.0, 20.0, 1.5)]
	var chaser := ob.spawn_for_test("zumbi", Vector2(28.0, 20.0))
	ob.hero.styx_forget_t = 30.0
	var closest := 99.0
	for i in 1200:
		ob._enemy_step(chaser, 0.016)
		closest = minf(closest, chaser.pos.distance_to(ob.hero.pos))
	if closest > 2.0:
		out.append("inimigo preso atrás de obstáculo redondo: chegou só a %.1f do herói" % closest)

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

	# 8) primeira morte pede revive; aceitar restaura a run; Segunda Chance dá oferta extra.
	var d := _bat(2)
	_quiet(d)
	d.stats.gold = 100.0
	d._hurt_hero(9999.0, "test")
	if d.state != "revive_offer" or not d.hero.dead:
		out.append("primeira morte deveria abrir a oferta de revive")
	if not d.decline_revive() or d.result().reward_rate != 0.3:
		out.append("recusar revive deveria encerrar com 30% da tentativa")
	var rv := Battle.new(2, "durvall", "dagruve", {"meta_mods": {"revive": 1}})
	_quiet(rv)
	rv._hurt_hero(9999.0, "test")
	if not rv.accept_revive() or rv.state != "running" or rv.hero.dead or rv.hero.hp != rv.hero.max_hp * 0.5 or rv.revive_left != 1:
		out.append("revive gratuito deveria restaurar a run sem consumir Segunda Chance")
	rv.invuln = 0.0
	rv._hurt_hero(9999.0, "test")
	if rv.state != "revive_offer" or not rv.accept_revive() or rv.revive_left != 0:
		out.append("Segunda Chance deveria conceder uma oferta manual adicional")
	rv.invuln = 0.0
	rv._hurt_hero(9999.0, "test")
	if rv.state != "dead" or rv.result().reward_rate != 0.5:
		out.append("sem ofertas restantes, derrota deveria manter 50%")
	var qa_revive := _bat(3)
	qa_revive.qa_prepare("revive_offer")
	if qa_revive.state != "revive_offer" or qa_revive.result().gold != 10:
		out.append("cenário QA de revive deveria abrir a oferta com moedas previsíveis")

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

	# 9b) slot ocupado: give_item pausa e oferece equipar/manter (SPEC-060)
	var martelo: Dictionary = Data.table("items").uniques.filter(func(u): return u.id == "martelo_da_gloria")[0]
	var gold_before := it.hero.gold
	it.give_item(Items.unique(martelo))
	if it.state != "item_offer" or it.offer.size() != 2:
		out.append("item para slot ocupado deveria abrir uma oferta de 2 opções")
	if it.hero.items.arma.id != "machado_de_xargath":
		out.append("item ocupado não deveria trocar antes da escolha")
	it.choose(0)  # equipar o novo (martelo), vender o machado
	if it.state != "running":
		out.append("escolher um item deveria retomar a run")
	if it.hero.items.arma.id != "martelo_da_gloria":
		out.append("escolher 'equipar novo' deveria trocar o item equipado")
	if it.hero.weapons.any(func(w): return w.id == "machado_de_xargath"):
		out.append("vender o item deveria remover a arma que ele concedia")
	if not it.hero.weapons.any(func(w): return w.id == "martelo_da_gloria" and w.granted):
		out.append("equipar o novo item deveria conceder sua arma")
	if it.hero.gold <= gold_before:
		out.append("vender o item deslocado deveria render moedas")

	var lamina: Dictionary = Data.table("items").uniques.filter(func(u): return u.id == "lamina_da_digestao")[0]
	var gold_before2 := it.hero.gold
	it.give_item(Items.unique(lamina))
	if it.state != "item_offer":
		out.append("segundo item para o mesmo slot também deveria ofertar escolha")
	it.choose(1)  # manter o atual (martelo), vender a lâmina
	if it.hero.items.arma.id != "martelo_da_gloria":
		out.append("escolher 'manter atual' não deveria trocar o item equipado")
	if it.hero.gold <= gold_before2:
		out.append("recusar o item novo também deveria render moedas pela venda")

	# 9c) quebráveis: não se movem, não atacam e sempre largam um item (SPEC-063)
	var bk := _bat(9)
	_quiet(bk)
	bk.hero.weapons = []
	var crate := bk._spawn("caixote_quebravel", bk.hero.pos + Vector2(0.6, 0.0))
	var hp_before := bk.hero.hp
	var pos_before := crate.pos
	for i in 30:
		bk.step(Vector2.ZERO, 0.5)
	if bk.hero.hp < hp_before:
		out.append("quebrável não deveria atacar o herói parado ao lado")
	if crate.pos != pos_before:
		out.append("quebrável não deveria se mover")
	var pickups_before := bk.pickups.size()
	bk._kill(crate)
	if bk.pickups.size() > pickups_before + 1:
		out.append("quebrável deveria largar no máximo um item ao morrer (MEC-033: às vezes nada)")
	elif bk.pickups.size() > pickups_before and not (String(bk.pickups[-1].kind) in ["potion", "gold", "magnet"]):
		out.append("drop de quebrável deveria ser poção, moeda ou ímã")

	# 9d) rebalanceamento de poção: inimigo comum nunca dropa; elite pode
	var pot := _bat(10)
	_quiet(pot)
	var common_potions := 0
	for i in 400:
		var foe := pot._spawn("zumbi", pot.hero.pos + Vector2(3, 0))
		foe.hp = 0.0
		var before := pot.pickups.size()
		pot._kill(foe)
		for p in pot.pickups.slice(before):
			if String(p.kind) == "potion":
				common_potions += 1
	if common_potions > 0:
		out.append("inimigo comum não deveria mais dropar poção")

	# 9d-2) drop de quebrável enviesado: ouro comum, item raro (amend. SPEC-063)
	var wt := _bat(16)
	_quiet(wt)
	var counts := {"gold": 0, "potion": 0, "magnet": 0, "item": 0}
	for i in 500:
		var b2 := wt._spawn("arbusto_quebravel", wt.hero.pos + Vector2(3, 0))
		var pickups_before2 := wt.pickups.size()
		var items_before2 := wt.hero.items.size()
		wt._kill(b2)
		if wt.state == "item_offer":
			counts.item += 1
			wt.state = "running"
			wt.offer.clear()
		elif wt.hero.items.size() > items_before2:
			counts.item += 1
		elif wt.pickups.size() > pickups_before2:
			var kind2 := String(wt.pickups[-1].kind)
			counts[kind2] = int(counts.get(kind2, 0)) + 1
		wt.pickups.clear()  # evita esbarrar em MAX_PICKUPS e mascarar a contagem
	if counts.gold <= counts.potion or counts.gold <= counts.magnet or counts.gold <= counts.item:
		out.append("ouro deveria ser o drop mais comum do quebrável (contagem: %s)" % str(counts))
	if counts.item >= counts.gold:
		out.append("item raro do quebrável não deveria ser mais comum que ouro")

	# 9e) eventos econômicos: loja, ferreiro, curandeiro (SPEC-064)
	var sh := _bat(11)
	_quiet(sh)
	sh.hero.gold = 500
	sh._open_shop_event("loja")
	var shop_idx := -1
	for j in sh.offer.size():
		if String(sh.offer[j].t) == "shop_item":
			shop_idx = j
			break
	if sh.state != "shop" or shop_idx < 0:
		out.append("loja com moeda suficiente deveria oferecer pelo menos um item")
	else:
		var gold_before_shop: int = sh.hero.gold
		var price: int = sh.offer[shop_idx].price
		sh.choose(shop_idx)
		if sh.hero.gold != gold_before_shop - price:
			out.append("comprar da loja deveria descontar exatamente o preço mostrado")
		if sh.state != "running" and sh.state != "item_offer":
			out.append("comprar da loja deveria fechar a oferta (ou abrir a escolha de equipar/vender)")

	var fe := _bat(12)
	_quiet(fe)
	fe.hero.gold = 500
	fe._open_shop_event("ferreiro")
	var forge_idx := -1
	for j in fe.offer.size():
		if String(fe.offer[j].t) == "shop_weapon_up":
			forge_idx = j
			break
	if forge_idx < 0:
		out.append("ferreiro com arma elegível e moeda deveria oferecer upgrade")
	else:
		var weapon_id: String = fe.offer[forge_idx].weapon_id
		var level_before := 0
		for w in fe.hero.weapons:
			if w.id == weapon_id:
				level_before = w.level
		fe.choose(forge_idx)
		var level_after := 0
		for w in fe.hero.weapons:
			if w.id == weapon_id:
				level_after = w.level
		if level_after != level_before + 1:
			out.append("comprar do ferreiro deveria subir o nível da arma em 1")
		if fe.state != "running":
			out.append("comprar do ferreiro deveria fechar a oferta")

	var cu := _bat(13)
	_quiet(cu)
	cu.hero.gold = 500
	cu.hero.hp = maxf(1.0, cu.hero.max_hp - 10.0)
	cu._open_shop_event("curandeiro")
	var heal_idx := -1
	for j in cu.offer.size():
		if String(cu.offer[j].t) == "shop_heal":
			heal_idx = j
			break
	if heal_idx < 0:
		out.append("curandeiro com PV faltando e moeda deveria oferecer cura")
	else:
		cu.choose(heal_idx)
		if cu.hero.hp < cu.hero.max_hp - 0.01:
			out.append("comprar do curandeiro deveria curar completamente")

	var le := _bat(14)
	_quiet(le)
	le.hero.gold = 500
	le._open_shop_event("curandeiro")  # herói com PV cheio: linha informativa travada + "Sair" (MEC-023)
	if le.offer.size() != 2 or String(le.offer[0].t) != "shop_info" or String(le.offer[1].t) != "shop_leave":
		out.append("sem PV faltando, curandeiro deveria mostrar 'Vida cheia' e 'Sair'")
	le.choose(0)
	if le.state != "shop":
		out.append("linha informativa travada não deveria fechar a loja")
	var gold_before_leave: int = le.hero.gold
	le.choose(le.offer.size() - 1)
	if le.hero.gold != gold_before_leave or le.state != "running":
		out.append("'Sair' não deveria custar nada nem deixar de fechar a oferta")

	var poor := _bat(15)
	_quiet(poor)
	poor.hero.gold = 0
	poor._open_shop_event("loja")
	# MEC-023: sem moeda a loja continua mostrando os itens, mas travados e com o que falta; escolher não compra nem fecha
	if not poor.offer.any(func(o): return o.t == "shop_item" and bool(o.locked)):
		out.append("sem moeda suficiente, a loja deveria mostrar o item travado")
	var poor_item: int = poor.offer.find_custom(func(o): return o.t == "shop_item")
	if poor_item >= 0:
		if String(poor.offer[poor_item].desc).find("faltam") < 0:
			out.append("item travado deveria dizer quantas moedas faltam")
		poor.choose(poor_item)
		if poor.state != "shop" or poor.hero.gold != 0:
			out.append("escolher item sem moeda não deveria comprar nem fechar a loja")

	# MEC-023: ferreiro sem nada forjável explica o motivo em vez de mostrar só "Sair"
	var nf := _bat(16)
	_quiet(nf)
	nf.hero.weapons = []
	nf.hero.items.clear()
	nf._open_shop_event("ferreiro")
	if nf.offer.size() != 2 or String(nf.offer[0].t) != "shop_info":
		out.append("ferreiro sem nada forjável deveria mostrar 'Nada para melhorar' e 'Sair'")

	# MEC-019: item novo contra o equipado mostra a diferença e o slot ocupado
	var cmp := _bat(19)
	_quiet(cmp)
	var old_item := {"id": "a", "name": "Velho", "slot": "amuleto", "rarity": "comum", "mods": {"cam": 1.0, "hp": 2.0}, "level": 1}
	cmp.hero.items["amuleto"] = old_item
	cmp.give_item({"id": "b", "name": "Novo", "slot": "amuleto", "rarity": "raro", "mods": {"cam": 3.0, "hp": 1.0}})
	var equip_desc := String(cmp.offer[0].desc)
	if equip_desc.find("Contra o atual: +2 CAM, -1 PV") < 0:
		out.append("oferta de item deveria trazer a diferença contra o equipado: %s" % equip_desc)
	if String(cmp.offer[0].get("tooltip", "")).find("Velho") < 0:
		out.append("oferta de item deveria ter tooltip com o item equipado")
	if Items.compare_text({"cam": 1.0}, {"cam": 1.0}) != "sem diferença nos atributos":
		out.append("compare_text de mods iguais deveria avisar que não há diferença")

	# MEC-027 fase 1: cartão resumido (brief/badge) e tabela de hover; desc antigo preservado
	var brief_mods := {"inteligencia": 1.0, "cam": 1.0, "cd_pct": 0.09, "dmg_pct": 0.16, "pickup": 0.4}
	var brief := Items.brief_text(brief_mods)
	if brief != "+16% dano, +9% recarga, +1 CAM" and brief != "+16% dano, +9% recarga, +1 INT":
		out.append("brief deveria trazer os 3 atributos mais relevantes: %s" % brief)
	if brief.split(",").size() != 3:
		out.append("brief deveria ter no máximo 3 atributos: %s" % brief)
	var vd := Items.verdict({"cam": 3.0, "hp": 1.0, "ca": 0.0}, {"cam": 1.0, "hp": 2.0, "carisma": 1.0})
	if int(vd.up) != 1 or int(vd.down) != 2:
		out.append("verdict deveria contar 1 sobe e 2 descem: %s" % str(vd))
	var tbl := Items.compare_table({"cam": 3.0, "hp": 1.0}, {"cam": 1.0, "hp": 2.0}, "Novo", "Atual")
	if tbl.rows.size() != 2 or String(tbl.rows[0].label) != "PV" or int(tbl.rows[0].sign) != -1 or int(tbl.rows[1].sign) != 1:
		out.append("compare_table deveria ordenar por relevância e marcar o sinal: %s" % str(tbl))
	var pct_cmp := Items.compare_table({"cd_pct": 0.04}, {}, "Novo", "Atual")
	if int(pct_cmp.rows[0].sign) != 1 or Items.compare_text({"cd_pct": 0.04}, {}) != "+4% recarga":
		out.append("diferença de +4%% deveria contar como ganho: %s / %s" % [str(pct_cmp.rows[0]), Items.compare_text({"cd_pct": 0.04}, {})])
	# cartão sem detalhe não pode abrir tooltip vazio (o Godot chama _make_custom_tooltip mesmo sem texto)
	var bare_card := OfferCard.new()
	bare_card.offer = {"name": "Simples", "desc": "+1 CA por nível.", "brief": "+1 CA por nível."}
	if bare_card._make_custom_tooltip("") != null:
		out.append("cartão sem detalhe deveria devolver tooltip nulo")
	var full_tip = OfferCard.new()
	full_tip.offer = cmp.offer[0]
	var tip_node = full_tip._make_custom_tooltip(" ")
	if tip_node == null:
		out.append("cartão com detalhe deveria devolver tooltip")
	else:
		tip_node.free()
	bare_card.free()
	full_tip.free()
	if String(cmp.offer[0].brief) == "" or int(cmp.offer[0].badge.up) != 1 or int(cmp.offer[0].badge.down) != 1:
		out.append("oferta de item deveria trazer brief e badge ▲1 ▼1: %s" % str(cmp.offer[0].badge))
	if int(cmp.offer[1].badge.up) != 1 or int(cmp.offer[1].badge.down) != 1 or cmp.offer[1].detail.footer.size() < 1:
		out.append("opção de manter deveria trazer badge invertido e rodapé com a venda")
	if cmp.offer[0].detail.rows.is_empty() or String(cmp.offer[0].price_text).find("vende") < 0:
		out.append("oferta de item deveria trazer tabela de detalhe e texto de venda")

	# 9f) nível de equipamento e super-upgrade (SPEC-073)
	var eq := _bat(17)
	_quiet(eq)
	eq.hero.gold = 1000
	var cota_base: Dictionary = Data.table("items").bases.armadura.filter(func(b): return b.id == "cota")[0]
	var cota := {"id": "cota_teste", "base": "cota", "name": "Cota de Malha", "slot": "armadura", "rarity": "comum", "mods": cota_base.mods.duplicate(), "level": 1}
	eq.hero.items["armadura"] = cota
	eq.hero.recalc()
	if int(eq.hero.m("ca")) != 3:
		out.append("item no nível 1 deveria contribuir com o mod cheio, sem regressão")

	eq._open_shop_event("ferreiro")
	var up_idx := -1
	for j in eq.offer.size():
		if String(eq.offer[j].t) == "shop_item_up" and String(eq.offer[j].slot) == "armadura":
			up_idx = j
			break
	if up_idx < 0:
		out.append("ferreiro deveria oferecer upgrade de armadura equipada")
	else:
		# BUG-015: a prévia do ferreiro tem de mostrar o nível seguinte já escalado (+15%), não o texto do nível atual.
		var preview := String(eq.offer[up_idx].desc)
		var lines := preview.split("\n")
		if lines.size() < 2 or lines[0].strip_edges().substr(lines[0].find(":")) == lines[1].strip_edges().substr(lines[1].find(":")):
			out.append("prévia do ferreiro deveria mostrar valores diferentes entre o nível atual e o próximo: %s" % preview)
		var sc := Items.scaled_mods({"mods": {"cam": 1.0, "hp": 4.0}}, 2)
		if absf(float(sc.cam) - 1.15) > 0.001 or absf(float(sc.hp) - 4.6) > 0.001:
			out.append("scaled_mods deveria aplicar +15% por nível acima de 1")
		if Items.mods_text({"hp": 4.6}).find("4.6") < 0:
			out.append("mods_text não deveria truncar 4.6 PV para 4")
		eq.choose(up_idx)
		if int(eq.hero.items.armadura.level) != 2:
			out.append("comprar upgrade de equipamento deveria subir o nível em 1")
		if eq.hero.m("ca") <= 3.0:
			out.append("nível 2 deveria escalar o mod de CA pra cima de 3")

	eq.hero.items.armadura.level = Items.MAX_LEVEL - 1
	eq.hero.recalc()
	eq._open_shop_event("ferreiro")
	var up_idx2 := -1
	for j in eq.offer.size():
		if String(eq.offer[j].t) == "shop_item_up" and String(eq.offer[j].slot) == "armadura":
			up_idx2 = j
			break
	if up_idx2 < 0:
		out.append("ferreiro deveria oferecer o upgrade final de armadura")
	else:
		var forca_before := eq.hero.m("forca")
		eq.choose(up_idx2)
		if int(eq.hero.items.armadura.level) != Items.MAX_LEVEL:
			out.append("upgrade final deveria levar ao nível máximo")
		if eq.hero.m("forca") <= forca_before:
			out.append("nível máximo deveria aplicar o super-upgrade da base (Cota de Malha: +2 Força)")

	eq._open_shop_event("ferreiro")
	if eq.offer.any(func(o): return o.t == "shop_item_up" and String(o.slot) == "armadura"):
		out.append("item no nível máximo não deveria mais aparecer na oferta do ferreiro")

	var uq := _bat(18)
	_quiet(uq)
	uq.hero.gold = 1000
	uq.hero.items["arma"] = Items.unique(Data.table("items").uniques[0])
	uq._open_shop_event("ferreiro")
	if uq.offer.any(func(o): return o.t == "shop_item_up" and String(o.slot) == "arma"):
		out.append("item único não deveria aparecer na oferta de upgrade do ferreiro")

	# 10) evolução: arma nv5 + passiva libera a evolução na oferta
	var ev := _bat(8)
	_quiet(evb)
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

	# 10b) sinergia combinada: arma evoluída + acessório nv máx + magia (SPEC-075)
	var sy := _bat(19)
	_quiet(sy)
	sy.hero.weapons = [Weapon.make("espada_do_receptaculo")]
	sy.hero.passives = {"cota_de_malha": 1}
	sy.hero.meta_mods = {"choices": 60}
	sy.hero.recalc()
	if sy._build_offer().any(func(o): return o.t == "synergy_activate"):
		out.append("sinergia não deveria aparecer sem o acessório equipado")
	var cota_super: Dictionary = Data.table("items").bases.armadura.filter(func(b): return b.id == "cota")[0]
	sy.hero.items["armadura"] = {"id": "cota_syn", "base": "cota", "name": "Cota de Malha", "slot": "armadura", "rarity": "comum", "mods": cota_super.mods.duplicate(), "level": 1}
	sy.hero.recalc()
	if sy._build_offer().any(func(o): return o.t == "synergy_activate"):
		out.append("sinergia não deveria aparecer com o acessório abaixo do nível máximo")
	if sy._has_maxed_accessory("cota"):
		out.append("acessório no nível 1 não deveria contar como maximizado")
	sy.hero.items.armadura = Items.unique(Data.table("items").uniques.filter(func(u): return String(u.slot) == "armadura")[0])
	if sy._has_maxed_accessory("cota"):
		out.append("item único (sem base) nunca deveria satisfazer a condição de sinergia")
	sy.hero.items["armadura"] = {"id": "cota_syn", "base": "cota", "name": "Cota de Malha", "slot": "armadura", "rarity": "comum", "mods": cota_super.mods.duplicate(), "level": Items.MAX_LEVEL}
	sy.hero.recalc()
	var syn_offer := sy._build_offer()
	var syn_idx := syn_offer.find(syn_offer.filter(func(o): return o.t == "synergy_activate")[0]) if syn_offer.any(func(o): return o.t == "synergy_activate") else -1
	if syn_idx < 0:
		out.append("sinergia deveria aparecer com arma evoluída + acessório no nível máximo + passiva")
	else:
		var ca_before := sy.hero.m("ca")
		sy.state = "levelup"
		sy.offer = syn_offer
		sy.pending_levels = 1
		sy.offer_kind = "levelup"
		sy.choose(syn_idx)
		if not sy.hero.synergies.get("espada_do_receptaculo", false):
			out.append("escolher a sinergia deveria marcá-la como ativa")
		if absf(sy.hero.m("ca") - ca_before - 1.0) > 0.001:
			out.append("sinergia ativa deveria somar +1 CA (bônus por camada, descent_depth mínimo 1)")
		if sy._build_offer().any(func(o): return o.t == "synergy_activate"):
			out.append("sinergia já ativa não deveria ser oferecida de novo")
		sy.hero.items.erase("armadura")
		sy.hero.recalc()
		if not sy.hero.synergies.get("espada_do_receptaculo", false):
			out.append("perder o acessório não deveria desativar uma sinergia já ativada")
		var ca_depth0 := sy.hero.m("ca")
		sy.enter_next_stage()
		sy.enter_next_stage()
		if int(sy.hero.descent_depth) != int(sy.descent_depth) or sy.descent_depth != 2:
			out.append("descer de fase deveria sincronizar Hero.descent_depth com Battle.descent_depth")
		var ca_after_descent := sy.hero.m("ca")
		if absf(ca_after_descent - ca_depth0 - 1.0) > 0.001:
			out.append("bônus de sinergia deveria crescer ao descer de fase (escala com descent_depth, aqui de ×1 para ×2)")

	# 11) chefe morto abre portal e leva à próxima fase
	var bs := _bat(12)
	_quiet(bs)
	var bb := bs.spawn_for_test("sacerdote_mente_derretida", Vector2(21, 20))
	bb.hp = 1.0
	bs._hero_hit(bb, {"dice": "1d4", "dmg": 50, "attr": "forca", "dtype": "fisico"}, false)
	if not bs.stage_cleared or not bs.interactions.any(func(i): return i.kind == "portal"):
		out.append("chefe não abriu o portal")
	else:
		bs.step(Vector2.ZERO, 0.66)
		bs.hero.pos = bs.interactions.filter(func(i): return i.kind == "portal")[0].pos
		bs.interact()
		if bs.stage_id != "docas":
			out.append("portal não levou a docas (%s)" % bs.stage_id)
		else:
			bs.enter_next_stage()
			if bs.stage_id != "shedaklah":
				out.append("portal de docas não levou a shedaklah (%s)" % bs.stage_id)

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

	# 13) cenarios QA usam os estados reais da simulacao
	var qa := _bat(101)
	_quiet(qa)
	qa.qa_prepare("levelup")
	if qa.state != "levelup" or qa.offer.is_empty():
		out.append("QA levelup nao preparou oferta")
	var qb := _bat(102)
	_quiet(qb)
	qb.qa_prepare("boss_70")
	if qb.boss == null or qb.boss.phase_index != 1:
		out.append("QA boss_70 nao disparou primeira virada")
	var qp := _bat(103)
	_quiet(qp)
	qp.qa_prepare("portal")
	if not qp.interactions.any(func(i): return i.kind == "portal"):
		out.append("QA portal nao preparou transicao")

	# 14) Afinidade visual nasce do patrono e só fica ativa após escolha divina.
	var kayron := _bat(104, "kayron")
	if kayron.visual_god != "Shar" or kayron.visual_boon_selected:
		out.append("Kayron deveria iniciar em Shar sem aura")
	var selune: Dictionary = Data.table("boons").boons.filter(func(b): return b.id == "selune_luar")[0]
	kayron.state = "altar"
	kayron.offer_kind = "altar"
	kayron.offer = [{"t": "boon", "boon": selune}]
	kayron.choose(0)
	if kayron.visual_god != "Selûne" or not kayron.visual_boon_selected:
		out.append("bênção de Selûne deveria substituir a afinidade visual")
	var kayron_base: Dictionary = DivineVisuals.resolve("kayron", "Shar", false)
	if kayron_base.primary != Color("d13e54"):
		out.append("Kayron deveria preservar vermelho abissal antes da bênção")
	var shar_theme: Dictionary = DivineVisuals.resolve("kayron", "Shar", true)
	if shar_theme.primary != Color("b56bff") or shar_theme.outline != Color("160d24"):
		out.append("sobreposição de Shar deveria usar a paleta violeta aprovada")
	var ghaunadaur_theme: Dictionary = DivineVisuals.resolve("brook", "Ghaunadaur", true)
	if ghaunadaur_theme.primary != Color("8ad14b") or ghaunadaur_theme.aura_accent != Color("a56bda"):
		out.append("Ghaunadaur deveria ser verde com acentos roxos")
	var divine_primaries := {"Shar": "b56bff", "Sendrinah": "f4c542", "Mask": "aeb8c8", "Lliira": "ffa12d", "Ghaunadaur": "8ad14b", "Tou Um": "6fd4ff", "Selûne": "8ccbff"}
	for god in divine_primaries:
		var theme: Dictionary = DivineVisuals.resolve("brook", String(god), true)
		if theme.primary != Color(String(divine_primaries[god])):
			out.append("%s deveria resolver para sua cor divina aprovada" % god)
	if DivineVisuals.is_divine_affinity("Helion"):
		out.append("Helion é mago e não pode habilitar afinidade divina")
	var helion: Dictionary = Data.table("boons").boons.filter(func(b): return b.id == "helion_saber")[0]
	var helion_battle := _bat(105, "kayron")
	helion_battle.state = "altar"
	helion_battle.offer_kind = "altar"
	helion_battle.offer = [{"t": "boon", "boon": helion}]
	helion_battle.choose(0)
	if helion_battle.visual_boon_selected:
		out.append("bênção de Helion não deveria habilitar aura divina")

	# 15) CA/CAM acima de 10 viram esquiva tipada, sem imunidade.
	var guard := Hero.make("durvall")
	if not is_equal_approx(guard.typed_evasion("fisico"), 0.09):
		out.append("CA 13 deveria conceder 9% de esquiva física")
	guard.hero_mods = {"ca": 7, "dodge": 0.10}
	guard.recalc()
	if not is_equal_approx(guard.typed_evasion("fisico"), 0.30):
		out.append("CA 20 deveria limitar esquiva tipada a 30%")
	if not is_equal_approx(guard.evasion("fisico"), 0.37):
		out.append("esquiva tipada e genérica deveriam combinar multiplicativamente")
	if guard.evasion("fisico") >= 0.45:
		out.append("esquiva composta não pode virar imunidade")

	# 16) Crítico: excedente de 2 dá 6%, e a chance nunca passa de 40%.
	var striker := Hero.make("durvall")
	if not is_equal_approx(striker.crit_chance(22), 0.06):
		out.append("19 + 3 = 22 deveria conceder 6% de crítico por excedente")
	striker.hero_mods = {"crit_overflow_bonus": 0.50}
	striker.recalc()
	if not is_equal_approx(striker.crit_chance(99), 0.40):
		out.append("chance de crítico deveria respeitar teto de 40%")

	# 17) Apresentacao do chefe pausa a simulacao uma vez e libera um telegrafo.
	var intro := _bat(105)
	_quiet(intro)
	intro.stage.duration = 0.0
	intro._director(0.01)
	var intro_count := intro.events.filter(func(ev): return ev.type == "boss_intro").size()
	var before_intro_time := intro.time
	intro.step(Vector2.ZERO, 0.5)
	if intro_count != 1 or intro.boss_intro_remaining <= 0.0 or intro.time != before_intro_time:
		out.append("introducao do chefe deveria pausar a simulacao uma unica vez")
	intro.step(Vector2.ZERO, 0.6)
	if not intro.events.any(func(ev): return ev.type == "boss_intro_end") or not intro.events.any(func(ev): return ev.type == "telegraph" and ev.enemy_id == intro.boss.id):
		out.append("introducao do chefe deveria terminar com telegrafo")

	# 18) Mare: graca, aviso, rampa 1% a 3% e dano que ignora esquiva generica.
	var fog := _bat(106)
	_quiet(fog)
	var fog_boss := fog.spawn_for_test("sacerdote_mente_derretida", Vector2(21, 20))
	fog._on_boss_dead(fog_boss)
	fog_boss.dead = true
	fog.step(Vector2.ZERO, 7.9)
	if fog.fog_state != "grace" or not is_zero_approx(fog.fog_damage_per_second()):
		out.append("Mare deveria manter 8s de graca sem dano")
	fog.step(Vector2.ZERO, 0.2)
	if fog.fog_state != "warning":
		out.append("Mare deveria avisar antes de avancar")
	fog.step(Vector2.ZERO, 2.0)
	if fog.fog_state != "advancing" or fog.fog_damage_per_second() < 0.02 or fog.fog_damage_per_second() > 0.021:
		out.append("Mare deveria iniciar em 2% da vida maxima por segundo")
	fog._update_postboss_fog(20.0)
	if not is_equal_approx(fog.fog_damage_per_second(), 0.06):
		out.append("Mare deveria atingir 6% da vida maxima por segundo apos a rampa")
	fog.hero.hero_mods = {"ca": 99, "cam": 99, "dodge": 0.99}
	fog.hero.recalc()
	fog.hero.pos = Vector2(0.1, 0.1)
	fog.invuln = 5.0
	var hp_before_fog := fog.hero.hp
	fog._update_postboss_fog(1.0)
	if fog.hero.hp >= hp_before_fog:
		out.append("CA, CAM e esquiva nao deveriam evitar o dano da Mare")

	# 19) Estige: risco de memória sem deslocamento físico.
	var styx := _bat(107, "korrak", "durao")
	_quiet(styx)
	styx.hero.pos = Vector2(20, 20)
	styx.hero.push = Vector2.ZERO
	styx._stage_rule_step(0.1)
	if styx.hero.push != Vector2.ZERO:
		out.append("corrente de Durao não pode empurrar fora do rio")
	styx.hero.pos = TerrainLayout.styx_sample("durao")
	styx._stage_rule_step(0.1)
	if styx.styx_exposure <= 0.0 or styx.hero.push != Vector2.ZERO:
		out.append("Estige deveria iniciar exposição sem empurrão")
	styx.hero.styx_lucidity_loss = 99
	if styx.hero.styx_intelligence() != 1:
		out.append("lucidez do Estige deveria ter piso de Inteligência efetiva em 1")
	styx.styx_exposure = 2.1
	styx.styx_in_water = true
	styx.hero.pos = Vector2(20, 20)
	styx._stage_rule_step(0.01)
	if styx.hero.styx_forget_t < 2.0:
		out.append("sair do Estige após dois segundos deveria aplicar Esquecimento")

	# 20) Paridade limitada: apenas os quatro andares documentados usam o contrato.
	for stage_id in TerrainLayout.STYX_STAGES:
		var documented_styx := _bat(208, "korrak", stage_id)
		_quiet(documented_styx)
		documented_styx.hero.pos = TerrainLayout.styx_sample(stage_id)
		documented_styx._stage_rule_step(0.1)
		if documented_styx.styx_exposure <= 0.0:
			out.append("%s não iniciou o contrato de memória do Estige" % stage_id)
		documented_styx.styx_exposure = 2.1
		documented_styx.styx_in_water = true
		documented_styx.hero.pos = TerrainLayout.styx_sample(stage_id, TerrainLayout.MATERIAL_BANK)
		documented_styx._stage_rule_step(0.01)
		if documented_styx.hero.styx_forget_t < 2.0:
			out.append("%s não aplicou Esquecimento ao deixar o Estige" % stage_id)
	for stage_id in [&"dagruve", &"docas", &"molor", &"feng_tu", &"pilares"]:
		var dry_stage := _bat(209, "korrak", stage_id)
		dry_stage.hero.pos = TerrainLayout.styx_sample(stage_id)
		dry_stage._stage_rule_step(0.1)
		if dry_stage.has_styx_contract() or dry_stage.styx_exposure > 0.0:
			out.append("%s não deveria ter contrato ou exposição do Estige" % stage_id)

	# MEC-029: Passo pelas Sombras deixa uma cópia-isca que atrai e explode
	var dc := _bat(61, "sylas")
	_quiet(dc)
	dc.hero.pos = Vector2(20, 20)
	var lured: Enemy = dc._spawn("zumbi", Vector2(26, 20))
	var boss_like: Enemy = dc._spawn("zumbi", Vector2(20, 26))
	boss_like.flags.append("chefe")
	if not dc.use_active(Vector2(-1, 0)):
		out.append("Passo pelas Sombras deveria poder ser usado")
	if dc.decoys.size() != 1:
		out.append("Passo pelas Sombras deveria deixar uma cópia-isca (há %d)" % dc.decoys.size())
	else:
		var decoy_pos: Vector2 = dc.decoys[0].pos
		if decoy_pos.distance_to(Vector2(20, 20)) > 0.01:
			out.append("a cópia deveria ficar onde o herói estava")
		if dc._decoy_for(lured).is_empty():
			out.append("inimigo comum dentro do alcance deveria ser atraído pela cópia")
		var far: Enemy = dc._spawn("zumbi", Vector2(20 + 40, 20))
		if not dc._decoy_for(far).is_empty():
			out.append("inimigo fora do alcance de aggro não deveria ser atraído")
		var lured_hp := lured.hp
		dc.enemies = [lured]
		lured.pos = Vector2(21, 20)
		dc.decoys[0].life = 0.01
		dc._update_decoys(0.1)
		if not dc.decoys.is_empty():
			out.append("a cópia deveria sumir ao fim da duração")
		if lured.hp >= lured_hp:
			out.append("a cópia deveria explodir e ferir os inimigos próximos")
	var dc2 := _bat(62, "sylas")
	_quiet(dc2)
	dc2.use_active(Vector2(1, 0))
	var swarm: Enemy = dc2._spawn("zumbi", dc2.decoys[0].pos + Vector2(0.5, 0))
	dc2._hit_decoy(dc2.decoys[0], 999.0)
	dc2._update_decoys(0.016)
	if not dc2.decoys.is_empty():
		out.append("cópia destruída deveria explodir")
	if swarm.hp >= swarm.max_hp and not swarm.dead:
		out.append("explosão da cópia destruída deveria ferir o inimigo ao lado")

	# MEC-033: Sorte melhora chance e qualidade do loot dos destrutíveis
	var lk := _bat(71)
	lk.hero.base_attrs["carisma"] = 10
	var chance_base := lk.breakable_drop_chance()
	var weights_base := lk.breakable_loot_weights()
	lk.hero.mods["sorte"] = 4.0
	var chance_lucky := lk.breakable_drop_chance()
	var weights_lucky := lk.breakable_loot_weights()
	if not (chance_lucky > chance_base):
		out.append("Sorte deveria aumentar a chance de drop (%.2f -> %.2f)" % [chance_base, chance_lucky])
	if not (float(weights_lucky.gold) < float(weights_base.gold) and float(weights_lucky.item) > float(weights_base.item)):
		out.append("Sorte deveria trocar ouro por itens na tabela de loot")
	lk.hero.mods["sorte"] = 99.0
	if lk.breakable_drop_chance() > float(Data.table("difficulty").breakables.loot.max_chance) + 0.0001:
		out.append("a chance de drop deve respeitar o teto")
	lk.hero.mods["sorte"] = -99.0
	if lk.breakable_drop_chance() < float(Data.table("difficulty").breakables.loot.min_chance) - 0.0001:
		out.append("a chance de drop deve respeitar o piso")
	var drops_none := _bat(72)
	_quiet(drops_none)
	drops_none.hero.mods["sorte"] = -99.0
	var loot_before := drops_none.pickups.size()
	var rolled := 0
	for i in 200:
		drops_none._breakable_loot(Vector2(10, 10))
		rolled += 1
	if drops_none.pickups.size() - loot_before >= rolled:
		out.append("com Sorte mínima o destrutível não deveria soltar algo sempre")
	if drops_none.pickups.size() - loot_before <= 0:
		out.append("destrutível deveria soltar algo às vezes")

	# MEC-035: destrutíveis fixos por dados; sem consumir a RNG da batalha
	for scenery_stage in ["dagruve", "docas"]:
		var sc := _bat(73, "durvall", scenery_stage)
		sc.map_size = Vector2(60, 60)
		sc.hero.map_size = Vector2(60, 60)
		_quiet(sc)
		var before_state := sc.rng.state
		var placed := sc.place_scenery()
		var wanted: int = Data.table("scenery")[scenery_stage].destrutiveis.size()
		if placed != wanted:
			out.append("%s: %d de %d destrutíveis fixos colocados" % [scenery_stage, placed, wanted])
		if sc.rng.state != before_state:
			out.append("%s: place_scenery não pode consumir a RNG da batalha" % scenery_stage)
		var near := 0
		for e in sc.enemies:
			if not e.has_flag("quebravel"):
				out.append("%s: destrutível fixo inesperado %s" % [scenery_stage, e.id])
			if e.pos.distance_to(sc.hero.pos) < 4.0:
				near += 1
		if near > 0:
			out.append("%s: destrutível fixo nasceu colado no herói" % scenery_stage)
		if sc._combat_count() != 0:
			out.append("destrutíveis não devem contar no limite de inimigos")
	var no_scenery := _bat(74, "durvall", "shedaklah")
	if no_scenery.place_scenery() != 0:
		out.append("fase sem dados de cenário não deve colocar nada")

	# MEC-034: armadilhas de cenário ferem herói e inimigos
	for trap_stage in ["dagruve", "docas"]:
		var tb := _bat(81, "durvall", trap_stage)
		_quiet(tb)
		tb.map_size = Vector2(60, 60)
		tb.hero.map_size = Vector2(60, 60)
		tb.place_scenery()
		var traps: Array = tb.zones.filter(func(z): return z.kind == "trap")
		var expected: int = Data.table("scenery")[trap_stage].armadilhas.size()
		if traps.size() != expected:
			out.append("%s: %d de %d armadilhas colocadas" % [trap_stage, traps.size(), expected])
			continue
		var trap: Dictionary = traps[0]
		if trap.pos.distance_to(tb.hero.pos) < 4.0:
			out.append("%s: armadilha nasceu perto do herói" % trap_stage)
		tb.enemies.clear()
		var victim: Enemy = tb._spawn("zumbi", trap.pos + Vector2(0.3, 0.0))
		victim.hp = 9999.0
		var far_enemy: Enemy = tb._spawn("zumbi", trap.pos + Vector2(float(trap.radius) + 3.0, 0.0))
		far_enemy.hp = 9999.0
		tb.hero.pos = trap.pos + Vector2(0.2, 0.0)
		tb.invuln = 0.0
		var hp_start := tb.hero.hp
		var victim_hp := victim.hp
		var far_hp := far_enemy.hp
		tb.events.clear()
		trap.t = float(trap.warn) + 0.05
		tb._update_zones(0.1)
		var warned := tb.events.any(func(ev): return ev.type == "trap_warn")
		if not warned or not bool(trap.armed):
			out.append("%s: a armadilha deveria avisar antes de disparar" % trap_stage)
		if tb.hero.hp < hp_start or victim.hp < victim_hp:
			out.append("%s: a armadilha não pode ferir antes do aviso acabar" % trap_stage)
		tb._update_zones(float(trap.warn) + 0.5)
		if not (tb.hero.hp < hp_start):
			out.append("%s: a armadilha deveria ferir o herói" % trap_stage)
		if not (victim.hp < victim_hp):
			out.append("%s: a armadilha deveria ferir o inimigo dentro do raio" % trap_stage)
		if far_enemy.hp != far_hp:
			out.append("%s: a armadilha não pode ferir quem está fora do raio" % trap_stage)
		if bool(trap.armed) or float(trap.t) <= 0.0:
			out.append("%s: a armadilha deveria reiniciar o ciclo" % trap_stage)
	var puddle_check := _bat(82, "durvall", "docas")
	_quiet(puddle_check)
	puddle_check.map_size = Vector2(60, 60)
	puddle_check.hero.map_size = Vector2(60, 60)
	puddle_check.place_scenery()
	var docas_trap: Dictionary = puddle_check.zones.filter(func(z): return z.kind == "trap")[0]
	docas_trap.t = 0.01
	puddle_check._update_zones(0.1)
	if puddle_check.zones.filter(func(z): return z.kind == "puddle").is_empty():
		out.append("Carga Solta deveria deixar uma poça")

	# MEC-030: interativos fixos e layout de props por zonas
	for lay_stage in ["dagruve", "docas"]:
		var lb := _bat(91, "durvall", lay_stage)
		_quiet(lb)
		lb.map_size = Vector2(60, 60)
		lb.hero.map_size = Vector2(60, 60)
		lb.place_scenery()
		var fixed_kinds: Array = []
		for inter in lb.interactions:
			if bool(inter.get("fixed", false)):
				fixed_kinds.append(String(inter.kind))
		var want_kinds: Array = Data.table("scenery")[lay_stage].interativos.map(func(i): return String(i.kind))
		if fixed_kinds != want_kinds:
			out.append("%s: interativos fixos %s, esperado %s" % [lay_stage, str(fixed_kinds), str(want_kinds)])
		var props := SceneryLayoutRef.expanded_props(lay_stage, lb.hero.pos, Vector2(60, 60))
		if props.size() < 20:
			out.append("%s: layout com poucos props (%d)" % [lay_stage, props.size()])
		var kinds: Dictionary = Data.table("scenery")._kinds
		var prop_kinds: Array = PropRef.new().get_property_list().filter(func(p): return p.name == "kind")[0].hint_string.split(",")
		for entry in props:
			if not kinds.has(String(entry.kind)):
				out.append("%s: prop %s sem dimensões em _kinds" % [lay_stage, entry.kind])
			if not (String(entry.kind) in prop_kinds):
				out.append("%s: prop %s não existe em ui/prop.gd" % [lay_stage, entry.kind])
			if entry.pos.distance_to(lb.hero.pos) < SceneryLayoutRef.START_CLEARANCE:
				out.append("%s: prop colado no ponto de início" % lay_stage)
		for dest in Data.table("scenery")[lay_stage].destrutiveis:
			var dpos := Vector2(float(dest.pos[0]), float(dest.pos[1]))
			for entry in props:
				if entry.pos.distance_to(dpos) < 1.0:
					out.append("%s: prop em cima do destrutível %s" % [lay_stage, str(dest.pos)])
					break
		for trap in Data.table("scenery")[lay_stage].armadilhas:
			var tpos := Vector2(float(trap.pos[0]), float(trap.pos[1]))
			for entry in props:
				if entry.pos.distance_to(tpos) < float(trap.radius) + 0.8:
					out.append("%s: prop dentro da armadilha %s" % [lay_stage, trap.id])
					break

	# Estátua Viva: segundos seguidos sem andar, reinicia ao andar, só conta com a run ativa
	var st := _bat(95, "durvall")
	_quiet(st)
	st.hero.max_hp = 99999.0
	st.hero.hp = 99999.0
	for i in 250:
		st.step(Vector2.ZERO, 0.5)
	if st.stats.still_best < 120.0 or st.result().still < 120.0:
		out.append("125 s parado deveriam registrar ao menos 120 s (veio %.1f)" % float(st.stats.still_best))
	var best_before := float(st.stats.still_best)
	st.step(Vector2(1, 0), 0.5)
	if st.still_t != 0.0:
		out.append("andar deveria reiniciar a contagem de imobilidade")
	if float(st.stats.still_best) != best_before:
		out.append("o melhor tempo parado não pode diminuir ao andar")
	st.step(Vector2.ZERO, 0.5)
	if st.still_t <= 0.0 or st.still_t > 1.0:
		out.append("a contagem deveria recomeçar do zero depois de andar")

	# cada cópia-isca tem um id estável e único (o visual é indexado por ele, nunca pelo dicionário mutável)
	var did := _bat(96, "sylas")
	_quiet(did)
	did.use_active(Vector2(1, 0))
	did.active_cd = 0.0
	did.use_active(Vector2(1, 0))
	var ids: Array = did.decoys.map(func(d): return int(d.id))
	if ids.size() != 2 or ids[0] == ids[1]:
		out.append("cada cópia-isca deveria ter um id único (ids %s)" % str(ids))
	var id_before := int(did.decoys[0].id)
	did.step(Vector2.ZERO, 0.5)
	if int(did.decoys[0].id) != id_before:
		out.append("o id da cópia não pode mudar durante a vida dela")
	did.load_stage("docas")
	if not did.decoys.is_empty():
		out.append("trocar de fase deve limpar as cópias-isca")

	return out
