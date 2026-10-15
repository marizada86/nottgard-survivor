extends RefCounted
## L1 do relatório do T05 (EVID-250/EVID-252): evolução alcançável e visível, troca de item com ordem fixa e foco no melhor,
## Guardião Alado com presença.

func _bat() -> Battle:
	var b := Battle.new(5, "durvall", "dagruve")
	b.stage.waves = []
	b.stage.elites = []
	b.stage.duration = 99999
	b._inter_t = 99999.0
	b._breakable_t = 99999.0
	return b

func _passive_offered(b: Battle, pid: String) -> bool:
	for _i in 60:   # a oferta é sorteada; com peso 9 ela aparece cedo
		for o in b._build_offer():
			if String(o.t) == "passive" and String(o.id) == pid:
				return true
	return false

func run() -> Array:
	var out: Array = []
	_evolution(out)
	_item_order(out)
	_guardian(out)
	return out

func _evolution(out: Array) -> void:
	var b := _bat()
	var base: Weapon = b.hero.weapons[0]
	var pid := String(base.def.evolve.passive)
	# 5 espaços de passiva cheios sem a passiva da evolução
	var filler: Array = []
	for p in Data.table("passives"):
		if String(p) != pid and filler.size() < 5:
			filler.append(String(p))
	for p in filler:
		b.hero.passives[p] = 1
	base.level = Weapon.MAX_LEVEL
	if b.evolution_passives_needed().has(pid) == false:
		out.append("a passiva %s deveria constar como necessária para evoluir" % pid)
	if b.evolve_status(base) != "falta %s" % String(Data.table("passives")[pid].name):
		out.append("o texto da HUD deveria dizer o que falta, deu '%s'" % b.evolve_status(base))
	if not _passive_offered(b, pid):
		out.append("com os 5 espaços cheios, a passiva da evolução deveria entrar na oferta mesmo assim")
	# sem a arma no nível máximo, o teto de 5 segue valendo para a passiva nova
	var c := _bat()
	for p in filler:
		c.hero.passives[p] = 1
	if _passive_offered(c, pid):
		out.append("arma fora do nível máximo não deveria furar o teto de 5 passivas")
	if c.evolve_status(c.hero.weapons[0]) != "":
		out.append("abaixo do nível máximo a HUD não deveria falar de evolução")
	# com a passiva em mãos, a evolução fica pronta e a HUD diz isso
	b.hero.passives[pid] = 1
	if b.evolution_passives_needed().has(pid):
		out.append("com a passiva em mãos ela não deveria mais ser listada como necessária")
	var status := b.evolve_status(base)
	if status != "pronta para evoluir" and not status.begins_with("falta"):
		out.append("estado inesperado da evolução: '%s'" % status)
	# subir a arma ao nível máximo sem a passiva avisa o jogador
	var d := _bat()
	var w: Weapon = d.hero.weapons[0]
	w.level = Weapon.MAX_LEVEL - 1
	d.offer = [{"t": "weapon_up", "id": w.id, "name": "x", "desc": ""}]
	d.offer_kind = "levelup"
	d.state = "levelup"
	d.events.clear()
	d.choose(0)
	var warned := false
	for e in d.events:
		if String(e.get("type", "")) == "toast" and String(e.text).find("nível máximo") >= 0:
			warned = true
	if not warned:
		out.append("ao chegar ao nível máximo sem a passiva deveria haver um aviso")

func _item_order(out: Array) -> void:
	var b := _bat()
	var rng := RandomGenerator_make(3)
	var cur := Items.roll(rng, 0, 0.0)
	cur["level"] = 1
	b.hero.items[cur.slot] = cur
	b.hero.recalc()
	var better := cur.duplicate(true)
	better["mods"] = {}
	for k in cur.mods:
		better.mods[k] = float(cur.mods[k]) + 5.0
	better["name"] = "Melhor"
	better["id"] = "melhor_teste"
	b.give_item(better)
	if b.state != "item_offer" or b.offer.size() != 2:
		out.append("trocar item deveria abrir 2 opções")
		return
	if bool(b.offer[0].get("equips", false)) or not bool(b.offer[1].get("equips", false)):
		out.append("ordem fixa: manter o atual primeiro, equipar o novo depois")
	if b.offer_focus != 1:
		out.append("item melhor deveria começar em foco no 'Equipar' (índice 1), deu %d" % b.offer_focus)
	var worse := cur.duplicate(true)
	worse["mods"] = {}
	for k in cur.mods:
		worse.mods[k] = float(cur.mods[k]) - 1.0
	worse["name"] = "Pior"
	worse["id"] = "pior_teste"
	var c := _bat()
	c.hero.items[cur.slot] = cur
	c.hero.recalc()
	c.give_item(worse)
	if c.offer_focus != 0:
		out.append("item pior deveria começar em foco no 'Manter' (índice 0), deu %d" % c.offer_focus)
	if bool(c.offer[0].get("equips", false)):
		out.append("a ordem não pode depender do veredito")

func RandomGenerator_make(seed_value: int) -> RandomNumberGenerator:
	var r := RandomNumberGenerator.new()
	r.seed = seed_value
	return r

func _guardian(out: Array) -> void:
	var enemies: Dictionary = Data.table("enemies")
	var g: Dictionary = enemies.guardiao_verdadeiro
	var smallest := 99.0
	for id in enemies:
		var d: Dictionary = enemies[id]
		if (d.get("flags", []) as Array).has("boss") and id != "guardiao_verdadeiro":
			smallest = minf(smallest, float(d.get("scale", 1.0)))
	if float(g.scale) < smallest:
		out.append("o Guardião Alado (escala %.1f) não deveria ser menor que o menor outro chefe (%.1f)" % [float(g.scale), smallest])
	if float(g.radius) < 0.5:
		out.append("o raio do Guardião Alado deveria acompanhar o tamanho")
	var pres: Dictionary = Data.table("boss_presentations").get("guardiao_verdadeiro", {})
	if String(pres.get("title", "")) == "":
		out.append("o Guardião Alado deveria ter apresentação (título)")
