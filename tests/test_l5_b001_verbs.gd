extends RefCounted
## PLAN-105 B-001: verbos novos e parâmetros novos das mecânicas de chefe (marca, totem que cura, 2 feixes,
## quadrantes com 3 acesos e poça, conjuração de armadura). Nenhum chefe novo: as definições são injetadas.

func _cfg(path: Array, value: Variant) -> void:
	var d: Dictionary = Data.table("difficulty")
	for i in path.size() - 1:
		d = d[path[i]]
	d[path[path.size() - 1]] = value

func _battle() -> Battle:
	var b := Battle.new(31, "durvall", "molor", {"meta_mods": {"hp": 50000.0}})
	b.map_size = Vector2(60, 60)
	b.hero.map_size = b.map_size
	b.hero.pos = b.map_size * 0.5
	b.stage.waves = []
	b.stage.elites = []
	b._inter_t = 99999.0
	b._breakable_t = 99999.0
	b.hero.hp = b.hero.max_hp
	b.qa_prepare({"target_state": "boss", "prelude_seconds": 0.1})
	for _i in 12:
		b.step(Vector2.ZERO, 0.05)
		if b.boss != null:
			break
	# isola: sem golpes do chefe e sem as mecânicas do piloto
	for e in b.enemies:
		if e != b.boss:
			b._kill(e)
	b.boss.abilities = []
	b.boss.atk_dice = "1d1"
	b.boss.atk_bonus = -20
	b.zones.clear()
	if b.boss_mech != null:
		b.boss_mech._verbs.clear()
		b.boss_mech.totems.clear()
		b.boss_mech.adds.clear()
		b.boss_mech.immune_t = 0.0
	return b

func run() -> Array:
	var out: Array = []
	var cfg: Dictionary = Data.table("difficulty").get("boss_mech", {})
	if cfg.is_empty():
		return ["data/difficulty.json deveria ter o bloco boss_mech"]
	var was: bool = bool(cfg.get("enabled", false))
	var l4_was: bool = bool(Data.table("difficulty").get("l4", {}).get("enabled", false))
	_cfg(["boss_mech", "enabled"], true)
	_cfg(["l4", "enabled"], false)
	_mark(out)
	_heal(out)
	_beams(out)
	_quadrants(out)
	_armor(out)
	_cfg(["boss_mech", "enabled"], was)
	_cfg(["l4", "enabled"], l4_was)
	return out

func _mark(out: Array) -> void:
	var b := _battle()
	var m: BossMechanics = b.boss_mech
	if m == null:
		out.append("o chefe de Molor deveria ter mecânicas")
		return
	m._start({"t": "mark", "follow": 0.5, "lock": 0.5, "radius": 3.0, "dice": "2d6", "slow": 1.5, "puddle": true})
	if m.mark.is_empty() or m.active_count() != 1:
		out.append("a marca deveria contar no orçamento")
	# parado dentro do círculo: leva o golpe, a lentidão e a poça
	b.hero.hp = b.hero.max_hp
	var hp0: float = b.hero.hp
	for _i in 24:
		b.step(Vector2.ZERO, 0.05)
	if not m.mark.is_empty():
		out.append("a marca deveria ter explodido em 1 s")
	if b.hero.hp >= hp0:
		out.append("quem fica dentro do círculo travado deveria ser ferido")
	if b.hero.slow_t <= 0.0:
		out.append("a marca deveria retardar quem foi acertado")
	if b.zones.filter(func(z): return z.kind == "puddle").is_empty():
		out.append("a marca com poça deveria deixar a poça")
	# saindo do círculo depois de travar: não leva nada
	var c := _battle()
	var mc: BossMechanics = c.boss_mech
	mc._start({"t": "mark", "follow": 0.5, "lock": 0.5, "radius": 3.0, "dice": "2d6"})
	var start_pos: Vector2 = c.hero.pos
	var followed := false
	for _i in 30:
		c.step(Vector2.ZERO, 0.05)
		if float(mc.mark.get("t", 0.0)) > 0.1 and float(mc.mark.get("t", 0.0)) < 0.4:
			c.hero.pos += Vector2(0.05, 0.0)   # anda um pouco: a marca segue
			if (mc.mark.pos as Vector2).distance_to(c.hero.pos) < 0.2:
				followed = true
		if float(mc.mark.get("t", 0.0)) >= 0.5 and not mc.mark.is_empty():
			c.hero.pos = start_pos + Vector2(6.0, 0.0)   # sai na hora em que a marca trava
	if not followed:
		out.append("durante o seguimento a marca deveria acompanhar o herói")
	if c.hero.hp < c.hero.max_hp - 0.01:
		out.append("quem sai do círculo ao travar não deveria ser ferido (%.1f de %.1f)" % [c.hero.hp, c.hero.max_hp])

func _heal(out: Array) -> void:
	var b := _battle()
	var m: BossMechanics = b.boss_mech
	m._start_totems({"n": 2, "hp": 40, "heal_pct_s": 0.02})
	if absf(b._shield_factor(b.boss) - 1.0) > 0.001:
		out.append("totem que cura não blinda (fator %.2f)" % b._shield_factor(b.boss))
	b.boss.hp = b.boss.max_hp * 0.5
	var before := b.boss.hp
	for _i in 40:   # 2 s
		b.step(Vector2.ZERO, 0.05)
	var gained := b.boss.hp - before
	if gained < b.boss.max_hp * 0.02 * 1.5:
		out.append("os totens deveriam curar uns 2%% do PV por segundo (curou %.1f de %.1f)" % [gained, b.boss.max_hp])
	for t in m.totems:
		b._kill(t)
	var after := b.boss.hp
	for _i in 20:
		b.step(Vector2.ZERO, 0.05)
	if b.boss.hp > after + 0.01:
		out.append("sem os totens o chefe não se cura")

func _beams(out: Array) -> void:
	for beams in [1, 2]:
		var b := _battle()
		var m: BossMechanics = b.boss_mech
		m._start({"t": "sweep", "warn": 0.1, "dur": 2.0, "arc": 90.0, "len": 9.0, "dice": "2d6", "beams": beams, "gap_deg": 180.0})
		var hurt := false
		for _i in 60:
			if float(m.sweep.get("t", 0.0)) >= 0.1:
				# herói exatamente no lado oposto do feixe principal
				b.hero.pos = (m.sweep.origin as Vector2) + Vector2.from_angle(float(m.sweep.a) + PI) * 4.0
			var hp: float = b.hero.hp
			b.step(Vector2.ZERO, 0.05)
			if b.hero.hp < hp:
				hurt = true
				break
		if beams == 2 and not hurt:
			out.append("com 2 feixes o lado oposto também deveria ferir")
		if beams == 1 and hurt:
			out.append("com 1 feixe o lado oposto é seguro")

func _quadrants(out: Array) -> void:
	var b := _battle()
	var m: BossMechanics = b.boss_mech
	m._start({"t": "quadrants", "warn": 0.3, "radius": 9.0, "dice": "1d4", "lit": 3, "puddle": true})
	if (m.quad.sectors as Array).size() != 3:
		out.append("3 quadrantes deveriam acender (%d)" % (m.quad.sectors as Array).size())
	b.hero.pos = b.map_size * 0.5 + Vector2(20.0, 20.0)   # longe: só queremos o efeito no chão
	for _i in 12:
		b.step(Vector2.ZERO, 0.05)
	var puddles := b.zones.filter(func(z): return z.kind == "puddle" and float(z.life) > 5.0).size()
	if puddles != 3:
		out.append("cada quadrante aceso deveria deixar uma poça (%d)" % puddles)

func _armor(out: Array) -> void:
	# sem interromper: a armadura entra e reduz 40% do dano recebido pelo chefe; o herói não é ferido
	var b := _battle()
	var m: BossMechanics = b.boss_mech
	m._start({"t": "cast", "name": "Armadura do Psíquico", "windup": 0.5, "effect": "armor", "stun": 2.0})
	var hp0: float = b.hero.hp
	for _i in 14:
		b.step(Vector2.ZERO, 0.05)
	if m.armor_t <= 0.0:
		out.append("a conjuração de armadura não interrompida deveria blindar o chefe")
	if absf(m.damage_taken_mult(b.boss) - 0.6) > 0.001:
		out.append("a armadura reduz 40%% do dano (fator %.2f)" % m.damage_taken_mult(b.boss))
	if b.hero.hp < hp0:
		out.append("a armadura não fere o herói")
	# interrompendo: sem armadura
	var c := _battle()
	var mc: BossMechanics = c.boss_mech
	mc._start({"t": "cast", "name": "Armadura do Psíquico", "windup": 1.0, "effect": "armor", "stun": 2.0})
	c.step(Vector2.ZERO, 0.05)
	mc.on_hero_active()
	for _i in 30:
		c.step(Vector2.ZERO, 0.05)
	if mc.armor_t > 0.0:
		out.append("interrompida a tempo, a armadura não deveria entrar")
