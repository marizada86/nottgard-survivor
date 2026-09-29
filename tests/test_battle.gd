extends RefCounted

const TerrainLayout := preload("res://core/terrain_layout.gd")

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
	if bk.pickups.size() != pickups_before + 1:
		out.append("quebrável deveria largar exatamente um item ao morrer")
	elif not (String(bk.pickups[-1].kind) in ["potion", "gold", "magnet"]):
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
	le._open_shop_event("curandeiro")  # herói com PV cheio: só "Sair" deveria aparecer
	if le.offer.size() != 1 or String(le.offer[0].t) != "shop_leave":
		out.append("sem PV faltando, curandeiro deveria oferecer só 'Sair'")
	var gold_before_leave: int = le.hero.gold
	le.choose(0)
	if le.hero.gold != gold_before_leave or le.state != "running":
		out.append("'Sair' não deveria custar nada nem deixar de fechar a oferta")

	var poor := _bat(15)
	_quiet(poor)
	poor.hero.gold = 0
	poor._open_shop_event("loja")
	if poor.offer.any(func(o): return o.t == "shop_item"):
		out.append("sem moeda suficiente, a loja não deveria oferecer o item")

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
	if fog.fog_state != "advancing" or fog.fog_damage_per_second() < 0.01 or fog.fog_damage_per_second() > 0.011:
		out.append("Mare deveria iniciar em 1% da vida maxima por segundo")
	fog._update_postboss_fog(20.0)
	if not is_equal_approx(fog.fog_damage_per_second(), 0.03):
		out.append("Mare deveria atingir 3% da vida maxima por segundo apos a rampa")
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

	return out
