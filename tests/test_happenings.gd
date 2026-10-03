extends RefCounted
## SPEC-118: acontecimentos exclusivos por fase (tipos novos, dados, chefes de Feng-tu e Shedaklah).

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

func _def(stage: String, id: String) -> Dictionary:
	for d in Data.table("stage_events").get(stage, []):
		if String(d.id) == id:
			return d.duplicate(true)
	return {}

func _fire(b: Battle, stage: String, id: String) -> Dictionary:
	var def := _def(stage, id)
	b.happenings.fire(b, def)
	return def

func _points(b: Battle, kind: String) -> Array:
	return b.interactions.filter(func(it): return String(it.kind) == kind and not it.used)

func _touch(b: Battle, it: Dictionary) -> void:
	b.hero.pos = it.pos
	b.happenings.step(b, 0.01)
	b.interactions = b.interactions.filter(func(i): return not i.used)

func _toasts(b: Battle) -> Array:
	return b.events.filter(func(e): return e.type == "toast").map(func(e): return String(e.text))

func _tagged(b: Battle) -> Array:
	return b.enemies.filter(func(e): return e.event_tag != "" and not e.dead)

func run() -> Array:
	var out: Array = []
	_check_data(out)
	_check_select(out)
	_check_collect(out)
	_check_zuggtmoy(out)
	_check_escort(out)
	_check_intercept(out)
	_check_invasion_rescue_arena(out)
	_check_pact(out)
	_check_shift_pilgrimage_quake(out)
	return out

func _check_data(out: Array) -> void:
	var enemies: Dictionary = Data.table("enemies")
	var all_events: Dictionary = Data.table("stage_events")
	for stage in ["shedaklah", "molor", "durao", "feng_tu", "shendilavri", "goranthis", "pilares"]:
		var defs: Array = all_events.get(stage, [])
		if defs.filter(func(d): return String(d.get("pool", "fixed")) != "optional").size() < 1 or defs.size() < 2:
			out.append("%s: precisa de ao menos 2 acontecimentos, 1 fixo" % stage)
		for d in defs:
			if String(d.kind) not in Happenings.KINDS and String(d.kind) not in ["ritual", "hazard", "wave", "elite"]:
				out.append("%s/%s: tipo desconhecido %s" % [stage, d.id, d.kind])
			for key in ["enemy_id"]:
				if d.has(key) and not enemies.has(String(d[key])):
					out.append("%s/%s: inimigo %s inexistente" % [stage, d.id, d[key]])
			for item in d.get("items", []):
				var src := String(item.get("source", ""))
				if src.begins_with("elite:") and not enemies.has(src.substr(6)):
					out.append("%s/%s: elite %s inexistente" % [stage, d.id, src])
			if String(d.get("fonte_vault", "")) == "":
				out.append("%s/%s: sem fonte_vault" % [stage, d.id])
	var stages: Dictionary = Data.table("stages")
	if String(stages.feng_tu.boss) != "discipulo_pestilento":
		out.append("Feng-tu: o chefe deveria ser O Discípulo Pestilento")
	if not enemies.has("manifestacao_de_juiblex") or not enemies.manifestacao_de_juiblex.get("flags", []).has("boss"):
		out.append("Manifestação de Juiblex deveria existir como chefe")

func _check_select(out: Array) -> void:
	var defs: Array = Data.table("stage_events").get("durao", [])
	var a := Happenings.select("durao", defs, 11)
	var b := Happenings.select("durao", defs, 11)
	if a.map(func(d): return d.id) != b.map(func(d): return d.id):
		out.append("o sorteio deveria ser determinístico pela semente")
	var fixed := defs.filter(func(d): return String(d.get("pool", "fixed")) != "optional").size()
	if a.size() < fixed + 1 or a.size() > fixed + 2:
		out.append("Durao deveria ter os fixos + 1 ou 2 opcionais (veio %d)" % a.size())
	var dag := Happenings.select("dagruve", Data.table("stage_events").dagruve, 3)
	if dag.size() != Data.table("stage_events").dagruve.size():
		out.append("Dagruve não tem opcionais: deveria manter todos os eventos")

func _check_collect(out: Array) -> void:
	var b := _bat("shedaklah")
	_fire(b, "shedaklah", "portal_sem_vao")
	var items := _points(b, "event_item")
	if items.size() != 2:
		out.append("o portal sem vão deveria espalhar 2 itens (há %d)" % items.size())
		return
	var target: Dictionary = _points(b, "event_target")[0]
	_touch(b, target)
	if not _points(b, "event_boss_chest").is_empty() or b.happenings.objectives.is_empty():
		out.append("tocar o arco sem os itens não deveria concluir")
	for it in items:
		_touch(b, it)
	if b.happenings.carrying.size() != 2:
		out.append("o herói deveria carregar os 2 itens")
	_touch(b, target)
	if b.interactions.filter(func(i): return i.kind == "boss_chest").is_empty():
		out.append("entregar os opostos deveria dar o baú do chefe")
	# prazo: sem entrega, o arco explode em poças e limos
	var c := _bat("shedaklah")
	_fire(c, "shedaklah", "portal_sem_vao")
	c.time += 80.0
	c.happenings.step(c, 0.01)
	if c.zones.filter(func(z): return z.kind == "puddle").is_empty() or c.enemies.filter(func(e): return e.id == "slime_de_juiblex").size() != 4:
		out.append("perder o prazo deveria deixar poça e 4 limos")

func _check_zuggtmoy(out: Array) -> void:
	var b := _bat("shedaklah")
	_fire(b, "shedaklah", "pedido_de_zuggtmoy")
	var carrier := _tagged(b)
	if carrier.size() != 1 or carrier[0].event_item == "":
		out.append("o pedido deveria trazer um receptáculo com o Coração de Limo")
		return
	var throne: Dictionary = _points(b, "event_target")[0]
	b.events.clear()
	_touch(b, throne)
	if not _toasts(b).any(func(t): return t.begins_with("Zuggtmoy:")):
		out.append("tocar o trono sem o item deveria dar a dica de Zuggtmoy")
	b._kill(carrier[0])
	var heart := _points(b, "event_item")
	if heart.size() != 1:
		out.append("o receptáculo deveria soltar o Coração de Limo")
		return
	_touch(b, heart[0])
	_touch(b, throne)
	if b.happenings.boss_id(b) != "manifestacao_de_juiblex":
		out.append("com o pacto, o chefe deveria ser a Manifestação de Juiblex")
	var boss := b._spawn(b.happenings.boss_id(b), b.hero.pos + Vector2(5, 0))
	b.happenings.on_boss_spawn(b, boss)
	if b.happenings.allies.size() != 4:
		out.append("a guarnição de Zuggtmoy deveria lutar ao lado (há %d aliados)" % b.happenings.allies.size())
	# sem o pacto, o pedido some quando o chefe chega e Zuggtmoy segue chefe
	var c := _bat("shedaklah")
	_fire(c, "shedaklah", "pedido_de_zuggtmoy")
	c.happenings.on_boss_spawn(c, c._spawn("zuggtmoy", c.hero.pos + Vector2(5, 0)))
	c.happenings.step(c, 0.01)
	if not c.happenings.objectives.is_empty() or c.happenings.boss_id(c) != "zuggtmoy":
		out.append("sem o pacto, o pedido deveria sumir e o chefe continuar Zuggtmoy")
	# aliado ataca inimigo próximo
	var d := _bat("shedaklah")
	d.happenings._add_ally(d, {"label": "teste", "pos": d.hero.pos, "dice": "10d10", "life": 10.0})
	var foe := d._spawn("servo_de_zuggtmoy", d.hero.pos + Vector2(0.5, 0))
	d.happenings.step(d, 0.1)
	if not foe.dead:
		out.append("o aliado deveria atacar o inimigo encostado")

func _check_escort(out: Array) -> void:
	var b := _bat("feng_tu")
	_fire(b, "feng_tu", "escolta_do_peregrino")
	var joao: Array = b.happenings.allies.filter(func(a): return a.role == "escort")
	if joao.size() != 1:
		out.append("a escolta deveria criar João Barbosa")
		return
	var start: Vector2 = joao[0].pos
	b.happenings.step(b, 1.0)
	if joao[0].pos == start:
		out.append("João deveria andar com o herói por perto")
	b.hero.pos = joao[0].pos + Vector2(20, 0)
	var waiting: Vector2 = joao[0].pos
	b.happenings.step(b, 1.0)
	if joao[0].pos != waiting:
		out.append("João deveria esperar o herói que ficou para trás")
	joao[0].pos = joao[0].goal
	b.happenings.step(b, 0.01)
	if b.interactions.filter(func(i): return i.kind == "chest").is_empty() or b.hero.temp_t <= 0.0:
		out.append("chegar ao templo deveria dar baú e a Bênção da Estrela")
	var c := _bat("feng_tu")
	_fire(c, "feng_tu", "escolta_do_peregrino")
	c.happenings.allies[0].hp = 0.0
	c.happenings.step(c, 0.01)
	if not _toasts(c).has("João Barbosa caiu antes de ver o templo."):
		out.append("João morto deveria falhar a escolta")
	# inimigos miram o peregrino como miram a isca
	var d := _bat("feng_tu")
	_fire(d, "feng_tu", "escolta_do_peregrino")
	var foe := d._spawn("cultista_de_feng_tu", d.happenings.allies[0].pos + Vector2(1.0, 0))
	if d._decoy_for(foe).is_empty():
		out.append("inimigos perto de João deveriam atacá-lo")

func _check_intercept(out: Array) -> void:
	var b := _bat("molor")
	_fire(b, "molor", "ritual_de_estagnacao")
	var carriers := _tagged(b)
	if carriers.size() != 5:
		out.append("o ritual deveria trazer 5 carregadores (há %d)" % carriers.size())
		return
	for e in carriers:
		b._kill(e)
	if b.interactions.filter(func(i): return i.kind == "chest").size() < 2:
		out.append("matar todos os carregadores deveria dar 2 baús")
	var c := _bat("molor")
	_fire(c, "molor", "ritual_de_estagnacao")
	var one: Enemy = _tagged(c)[0]
	one.pos = one.goal + Vector2(0.3, 0)
	c._enemy_step(one, 0.1)
	if not one.dead or not is_equal_approx(c.happenings.boss_hp_bonus, 0.1):
		out.append("carregador que chega deveria sumir e dar +10%% de PV ao chefe")

func _check_invasion_rescue_arena(out: Array) -> void:
	var b := _bat("durao")
	_fire(b, "durao", "patrulha_do_carcereiro")
	if _tagged(b).size() != 1:
		out.append("a patrulha deveria trazer um Molydeus")
	b.time += 80.0
	b.happenings.step(b, 0.01)
	if not _tagged(b).is_empty():
		out.append("o Molydeus deveria partir ao fim do prazo")
	var r := _bat("durao")
	_fire(r, "durao", "desertores")
	for it in _points(r, "event_npc"):
		_touch(r, it)
	if not r.hero.temp_mods.has("dmg_pct"):
		out.append("salvar os 3 desertores deveria dar a Gratidão dos desertores")
	var a := _bat("durao")
	_fire(a, "durao", "arena_do_testador")
	var center: Vector2 = a.happenings.arena.pos
	a.hero.pos = center + Vector2(10, 0)
	a.happenings.post_hero_step(a)
	if a.hero.pos.distance_to(center) > float(a.happenings.arena.radius) + 0.01:
		out.append("a arena deveria prender o herói no círculo")
	a._kill(_tagged(a)[0])
	if not a.happenings.arena.is_empty() or not a.hero.temp_mods.has("speed_pct"):
		out.append("vencer o duelo deveria abrir a arena e dar a Primeira aprovação")

func _check_pact(out: Array) -> void:
	var b := _bat("shendilavri")
	_fire(b, "shendilavri", "o_convite")
	var p: Dictionary = _points(b, "event_pact")[0]
	b.hero.pos = p.pos
	p.born_at = -10.0
	if not b.interact() or b.state != "shop" or b.offer_kind != "pact":
		out.append("E no convite deveria abrir o pacto")
		return
	if String(b.offer[-1].t) != "shop_leave":
		out.append("todo pacto deveria ter a opção de recusar")
	var hp_before := b.hero.hp
	b.choose(0)
	if b.state != "running" or b.interactions.filter(func(i): return i.kind == "boss_chest").is_empty() or b.hero.hp >= hp_before:
		out.append("aceitar o convite deveria custar PV e dar o baú do chefe")
	var g := _bat("shedaklah")
	_fire(g, "shedaklah", "barqueiro_do_estige")
	var q: Dictionary = _points(g, "event_pact")[0]
	g.hero.pos = q.pos
	q.born_at = -10.0
	g.hero.gold = 0
	g.interact()
	g.choose(0)
	if g.state != "shop":
		out.append("pacto sem moedas suficientes não deveria fechar a oferta")

func _check_shift_pilgrimage_quake(out: Array) -> void:
	var b := _bat("goranthis")
	_fire(b, "goranthis", "do_trono_ao_lodo")
	if String(b.stage_rule.get("kind", "")) != "sanctuary" or float(b.stage_rule.get("fake_chance", 0.0)) < 1.0:
		out.append("a queda do paraíso deveria tornar todo santuário falso")
	var fast := b._spawn("ezro", b.hero.pos + Vector2(6, 0))
	var base_speed := float(Data.table("enemies").ezro.speed)
	if fast.speed <= base_speed:
		out.append("depois da queda, inimigos novos deveriam ser mais rápidos")
	var f := _bat("feng_tu")
	_fire(f, "feng_tu", "peregrinacao_da_estrela")
	if float(f.hero.temp_mods.get("dmg_pct", 0.0)) >= 0.0:
		out.append("a peregrinação deveria começar com a doença (−dano)")
	_touch(f, _points(f, "event_star")[0])
	if not f.hero.temp_mods.is_empty():
		out.append("alcançar a estrela deveria curar a doença")
	var p := _bat("pilares")
	_fire(p, "pilares", "elevador_do_castelo")
	if p.zones.filter(func(z): return z.kind == "telegraph").size() != 6:
		out.append("o elevador deveria marcar 6 quedas no chão")
