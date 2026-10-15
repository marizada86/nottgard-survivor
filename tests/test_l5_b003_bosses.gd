extends RefCounted
## PLAN-105 B-003: mecânicas do Discípulo Pestilento (Feng-tu) e de Malcanthet (Shendilavri).

func _cfg(path: Array, value: Variant) -> void:
	var d: Dictionary = Data.table("difficulty")
	for i in path.size() - 1:
		d = d[path[i]]
	d[path[path.size() - 1]] = value

func _boss_battle(stage_id: String) -> Battle:
	var b := Battle.new(51, "durvall", stage_id, {"meta_mods": {"hp": 50000.0}})
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

func _enemy_shots(b: Battle) -> int:
	return b.projectiles.filter(func(p): return p.owner == "enemy").size()

func run() -> Array:
	var out: Array = []
	var cfg: Dictionary = Data.table("difficulty").get("boss_mech", {})
	if cfg.is_empty():
		return ["data/difficulty.json deveria ter o bloco boss_mech"]
	var was: bool = bool(cfg.get("enabled", false))
	var l4_was: bool = bool(Data.table("difficulty").get("l4", {}).get("enabled", false))
	_cfg(["boss_mech", "enabled"], true)
	_cfg(["l4", "enabled"], false)
	_discipulo(out)
	_malcanthet(out)
	_cfg(["boss_mech", "enabled"], was)
	_cfg(["l4", "enabled"], l4_was)
	return out

func _discipulo(out: Array) -> void:
	var b := _boss_battle("feng_tu")
	var m: BossMechanics = b.boss_mech
	if m == null:
		out.append("o Discípulo Pestilento deveria ter mecânicas")
		return
	if m.budget() != 3:
		out.append("Feng-tu tem orçamento 3 (%d)" % m.budget())
	_to_phase(b, 0.69)
	if _puddles(b) != 0:
		out.append("a 70%% as poças soltas antigas são substituídas pelos quadrantes (%d)" % _puddles(b))
	var saw_quad := false
	var saw_mark := false
	var both := false
	for _i in 200:
		b.hero.hp = b.hero.max_hp
		b.step(Vector2.ZERO, 0.05)
		saw_quad = saw_quad or not m.quad.is_empty()
		saw_mark = saw_mark or not m.mark.is_empty()
		both = both or (not m.quad.is_empty() and not m.mark.is_empty())
	if not saw_quad or not saw_mark:
		out.append("a 70%% o Discípulo deveria usar quadrantes e marca (quad %s, marca %s)" % [str(saw_quad), str(saw_mark)])
	if m.active_count() > m.budget():
		out.append("o orçamento não pode estourar")
	# 35%: grito interrompível + 4 cultistas, sem o anel antigo
	_to_phase(b, 0.34)
	if _enemy_shots(b) != 0:
		out.append("o anel antigo de 35%% é substituído pelo grito (%d projéteis)" % _enemy_shots(b))
	if _count(b, "cultista_de_feng_tu") != 4:
		out.append("a 35%% deveria haver 4 cultistas (%d)" % _count(b, "cultista_de_feng_tu"))
	if not m.is_immune(b.boss):
		out.append("a 35%% o chefe fica imune até os cultistas caírem")
	var named := b.enemies.filter(func(e): return e.id == "cultista_de_feng_tu" and String(e.name) == "Cultista da Peste")
	if named.size() != 4:
		out.append("os servos deveriam ter o nome do verbo")
	var cast_seen := false
	for _i in 120:
		b.hero.hp = b.hero.max_hp
		b.step(Vector2.ZERO, 0.05)
		cast_seen = cast_seen or not m.cast.is_empty()
	if not cast_seen:
		out.append("a 35%% o Discípulo deveria conjurar o Grito na mente")

func _malcanthet(out: Array) -> void:
	var b := _boss_battle("shendilavri")
	var m: BossMechanics = b.boss_mech
	if m == null:
		out.append("Malcanthet deveria ter mecânicas")
		return
	if m.budget() != 4:
		out.append("Shendilavri tem orçamento 4 (%d)" % m.budget())
	_to_phase(b, 0.69)
	if _count(b, "ilusao_de_sucubo") != 4:
		out.append("a 70%% deveria haver 4 ilusões, sem o invocar antigo de 6 (%d)" % _count(b, "ilusao_de_sucubo"))
	for e in b.enemies:
		if e.id == "ilusao_de_sucubo" and (e.max_hp < 25.0 or String(e.name) != "Ilusão da Rainha"):
			out.append("as ilusões da rainha têm 30 PV e nome próprio (%.0f, %s)" % [e.max_hp, e.name])
			break
	if not m.is_immune(b.boss):
		out.append("a 70%% Malcanthet fica imune enquanto as ilusões vivem")
	var saw_mark := false
	for _i in 160:
		b.hero.hp = b.hero.max_hp
		b.step(Vector2.ZERO, 0.05)
		saw_mark = saw_mark or not m.mark.is_empty()
	if not saw_mark:
		out.append("a 70%% Malcanthet deveria marcar o herói junto com as ilusões")
	# 35%: Beijo da Rainha + varredura de um lado só; sem os 3 súcubos do invocar antigo
	_to_phase(b, 0.34)
	if _count(b, "sucubo") != 0:
		out.append("o invocar de súcubos de 35%% é substituído (%d)" % _count(b, "sucubo"))
	var cast_seen := false
	var sweep_seen := false
	var offsets := 0
	for _i in 200:
		b.hero.hp = b.hero.max_hp
		b.step(Vector2.ZERO, 0.05)
		cast_seen = cast_seen or not m.cast.is_empty()
		if not m.sweep.is_empty():
			sweep_seen = true
			offsets = (m.sweep.offsets as Array).size()
	if not cast_seen or not sweep_seen:
		out.append("a 35%% Malcanthet deveria conjurar e varrer (conjuração %s, varredura %s)" % [str(cast_seen), str(sweep_seen)])
	if sweep_seen and offsets != 1:
		out.append("o chifre perdido: varredura de um lado só (%d feixes)" % offsets)
	if m.active_count() > m.budget():
		out.append("o orçamento não pode estourar")
