extends RefCounted
## PLAN-105 B-002: mecânicas de Zuggtmoy (Shedaklah) e Molydeus (Durao).

func _cfg(path: Array, value: Variant) -> void:
	var d: Dictionary = Data.table("difficulty")
	for i in path.size() - 1:
		d = d[path[i]]
	d[path[path.size() - 1]] = value

func _boss_battle(stage_id: String) -> Battle:
	var b := Battle.new(41, "durvall", stage_id, {"meta_mods": {"hp": 50000.0}})
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
	for e in b.enemies:
		if e != b.boss:
			b._kill(e)
	return b

func _to_phase(b: Battle, frac: float) -> void:
	b.boss.hp = b.boss.max_hp * frac
	b._check_boss_phase(b.boss)

func _count(b: Battle, id: String) -> int:
	var n := 0
	for e in b.enemies:
		if e.id == id and not e.dead:
			n += 1
	return n

func _puddles(b: Battle) -> int:
	return b.zones.filter(func(z): return z.kind == "puddle").size()

func run() -> Array:
	var out: Array = []
	var cfg: Dictionary = Data.table("difficulty").get("boss_mech", {})
	if cfg.is_empty():
		return ["data/difficulty.json deveria ter o bloco boss_mech"]
	var was: bool = bool(cfg.get("enabled", false))
	var l4_was: bool = bool(Data.table("difficulty").get("l4", {}).get("enabled", false))
	_cfg(["boss_mech", "enabled"], true)
	_cfg(["l4", "enabled"], false)
	_zuggtmoy(out)
	_molydeus(out)
	_priority(out)
	_switch(out)
	_cfg(["boss_mech", "enabled"], was)
	_cfg(["l4", "enabled"], l4_was)
	return out

func _zuggtmoy(out: Array) -> void:
	var b := _boss_battle("shedaklah")
	var m: BossMechanics = b.boss_mech
	if m == null:
		out.append("Zuggtmoy deveria ter mecânicas")
		return
	if m.budget() != 2:
		out.append("Shedaklah tem orçamento 2 (%d)" % m.budget())
	_to_phase(b, 0.69)
	if _puddles(b) != 0:
		out.append("a 70%% os esporos antigos (poças soltas) são substituídos pelos quadrantes (%d poças)" % _puddles(b))
	for _i in 60:
		b.step(Vector2.ZERO, 0.05)
		if not m.quad.is_empty():
			break
	if m.quad.is_empty():
		out.append("a 70%% Zuggtmoy deveria acender quadrantes")
		return
	if (m.quad.sectors as Array).size() != 3 or not bool(m.quad.puddle):
		out.append("os quadrantes de esporos acendem 3 e deixam poça")
	# fase de 35%: cogumelos-mãe que curam, sem os servos do invocar antigo
	_to_phase(b, 0.34)
	var mothers := b.enemies.filter(func(e): return e.id == "totem_de_chefe" and not e.dead)
	if mothers.size() != 3 or String(mothers[0].name) != "Cogumelo-mãe":
		out.append("a 35%% deveria haver 3 Cogumelos-mãe (%d)" % mothers.size())
	if _count(b, "servo_de_zuggtmoy") != 0:
		out.append("o invocar antigo de 35%% é substituído pelos cogumelos")
	if absf(b._shield_factor(b.boss) - 1.0) > 0.001:
		out.append("cogumelo que cura não blinda")
	var before: float = b.boss.hp
	for _i in 40:
		b.step(Vector2.ZERO, 0.05)
	if b.boss.hp <= before:
		out.append("os cogumelos-mãe deveriam curar o chefe")
	# a cura total dos cogumelos tem teto (20%% do PV máximo)
	b.boss.hp = b.boss.max_hp * 0.3
	m._healed = 0.0
	var start_hp: float = b.boss.hp
	for _i in 1200:   # 60 s com os cogumelos de pé
		for t in m.totems:
			if is_instance_valid(t) and not t.dead:
				t.hp = t.max_hp
		b.step(Vector2.ZERO, 0.05)
		b.boss.hp = minf(b.boss.hp, b.boss.max_hp)
	var healed: float = b.boss.hp - start_hp
	if healed > b.boss.max_hp * 0.2 + 1.0:
		out.append("a cura dos cogumelos passou do teto de 20%% (curou %.0f de %.0f)" % [healed, b.boss.max_hp])

func _molydeus(out: Array) -> void:
	var b := _boss_battle("durao")
	var m: BossMechanics = b.boss_mech
	if m == null:
		out.append("Molydeus deveria ter mecânicas")
		return
	if m.budget() != 3:
		out.append("Durao tem orçamento 3 (%d)" % m.budget())
	_to_phase(b, 0.69)
	if _count(b, "molydeus_menor") != 2:
		out.append("a 70%% as jaulas se abrem: 2 Molydeus menores (%d)" % _count(b, "molydeus_menor"))
	for _i in 120:
		b.step(Vector2.ZERO, 0.05)
		if not m.mark.is_empty():
			break
	if m.mark.is_empty():
		out.append("a 70%% Molydeus deveria marcar o herói")
		return
	if float(m.mark.slow) <= 0.0 or float(m.mark.follow) < 2.0:
		out.append("a marca de sentença segue 2 s e retarda")
	# 35%: correntes em 2 feixes; o anel antigo é substituído
	_to_phase(b, 0.34)
	m.mark.clear()
	var enemy_shots := b.projectiles.filter(func(p): return p.owner == "enemy").size()
	if enemy_shots != 0:
		out.append("o anel antigo de 35%% é substituído pelas correntes (%d projéteis)" % enemy_shots)
	for _i in 160:
		b.step(Vector2.ZERO, 0.05)
		if not m.sweep.is_empty():
			break
	if m.sweep.is_empty():
		out.append("a 35%% Molydeus deveria varrer com correntes")
		return
	if (m.sweep.offsets as Array).size() != 2:
		out.append("as correntes são 2 feixes")

func _priority(out: Array) -> void:
	# a mira automática prefere os totens, mesmo com um inimigo comum mais perto
	var b := _boss_battle("shedaklah")
	_to_phase(b, 0.34)
	var zombie: Enemy = b.spawn_for_test("zumbi", b.hero.pos + Vector2(0.8, 0.0))
	var target: Enemy = b.nearest(b.hero.pos, 12.0)
	if target == null or target.id != "totem_de_chefe":
		out.append("com totens de pé a mira automática deveria preferi-los (%s)" % [target.id if target != null else "nada"])
	for e in b.enemies:
		if e.id == "totem_de_chefe":
			b._kill(e)
	var after: Enemy = b.nearest(b.hero.pos, 12.0)
	if after != zombie:
		out.append("sem totens a mira volta ao inimigo mais próximo")

func _switch(out: Array) -> void:
	_cfg(["boss_mech", "off_bosses"], ["zuggtmoy"])
	var b := _boss_battle("shedaklah")
	if b.boss_mech != null:
		out.append("o chefe em off_bosses não tem mecânicas")
	_cfg(["boss_mech", "off_bosses"], [])
	var c := _boss_battle("shedaklah")
	if c.boss_mech == null:
		out.append("sem off_bosses o chefe volta a ter mecânicas")
