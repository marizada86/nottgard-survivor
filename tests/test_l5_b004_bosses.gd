extends RefCounted
## PLAN-105 B-004: mecânicas de Socothbenoth (Goranthis) e da Síntese Abissal (Pilares, modo infinito).

func _cfg(path: Array, value: Variant) -> void:
	var d: Dictionary = Data.table("difficulty")
	for i in path.size() - 1:
		d = d[path[i]]
	d[path[path.size() - 1]] = value

func _boss_battle(stage_id: String) -> Battle:
	var b := Battle.new(61, "durvall", stage_id, {"meta_mods": {"hp": 50000.0}})
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
	_socothbenoth(out)
	_sintese(out)
	_cfg(["boss_mech", "enabled"], was)
	_cfg(["l4", "enabled"], l4_was)
	return out

func _socothbenoth(out: Array) -> void:
	var b := _boss_battle("goranthis")
	var m: BossMechanics = b.boss_mech
	if m == null:
		out.append("Socothbenoth deveria ter mecânicas")
		return
	if m.budget() != 4:
		out.append("Goranthis tem orçamento 4 (%d)" % m.budget())
	_to_phase(b, 0.69)
	if _puddles(b) != 0:
		out.append("a 70%% as poças soltas antigas são substituídas (%d)" % _puddles(b))
	var anchors := b.enemies.filter(func(e): return e.id == "totem_de_chefe" and not e.dead)
	if anchors.size() != 2 or String(anchors[0].name) != "Âncora de Juiblex":
		out.append("a 70%% deveria haver 2 Âncoras de Juiblex (%d)" % anchors.size())
	if absf(b._shield_factor(b.boss) - 1.0) > 0.001:
		out.append("âncora que cura não blinda")
	var saw_quad := false
	var lit := 0
	for _i in 120:
		b.hero.hp = b.hero.max_hp
		b.step(Vector2.ZERO, 0.05)
		if not m.quad.is_empty():
			saw_quad = true
			lit = (m.quad.sectors as Array).size()
	if not saw_quad or lit != 3:
		out.append("a 70%% Socothbenoth acende 3 quadrantes (%s, %d)" % [str(saw_quad), lit])
	# 35%: 6 ilusões de 40 PV, grito interrompível, sem invocar nem anel antigos
	b.projectiles.clear()
	_to_phase(b, 0.34)
	if _enemy_shots(b) != 0:
		out.append("o anel antigo de 35%% é substituído (%d projéteis)" % _enemy_shots(b))
	if _count(b, "ilusao_de_socothbenoth") != 6:
		out.append("a 35%% deveria haver 6 ilusões, sem o invocar antigo duplicado (%d)" % _count(b, "ilusao_de_socothbenoth"))
	for e in b.enemies:
		if e.id == "ilusao_de_socothbenoth" and (e.max_hp < 35.0 or String(e.name) != "Ilusão do Paraíso"):
			out.append("as ilusões do paraíso têm 40 PV e nome próprio (%.0f, %s)" % [e.max_hp, e.name])
			break
	if not m.is_immune(b.boss):
		out.append("a 35%% o chefe fica imune até as ilusões caírem")
	var cast_seen := false
	for _i in 120:
		b.hero.hp = b.hero.max_hp
		b.step(Vector2.ZERO, 0.05)
		cast_seen = cast_seen or not m.cast.is_empty()
	if not cast_seen:
		out.append("a 35%% Socothbenoth deveria conjurar a Verdade desfeita")

func _sintese(out: Array) -> void:
	var b := _boss_battle("pilares")
	b.stage.waves = [{"id": "zumbi", "t0": 99999.0, "t1": 99999.0, "every": 1000.0, "n": 1, "max": 1}]   # o modo infinito usa a primeira onda no pinga-pinga
	var m: BossMechanics = b.boss_mech
	if m == null:
		out.append("a Síntese Abissal deveria ter mecânicas")
		return
	if m.budget() != 4:
		out.append("Os Pilares têm orçamento 4 (%d)" % m.budget())
	_to_phase(b, 0.69)
	if _puddles(b) != 0 or b.zones.filter(func(z): return z.kind == "telegraph").size() != 0:
		out.append("a 70%% as poças e os golpes soltos antigos são substituídos")
	var lodo := b.enemies.filter(func(e): return e.id == "totem_de_chefe" and not e.dead)
	if lodo.size() != 3 or String(lodo[0].name) != "Lodo de Astherion":
		out.append("a 70%% deveria haver 3 poças-fonte de Lodo (%d)" % lodo.size())
	var sweep_seen := false
	for _i in 120:
		b.hero.hp = b.hero.max_hp
		b.step(Vector2.ZERO, 0.05)
		sweep_seen = sweep_seen or not m.sweep.is_empty()
	if not sweep_seen:
		out.append("a 70%% a Síntese deveria varrer")
	# 35%: armadura (sem interromper reduz 40%), quadrantes e marca; sem o anel de 20 projéteis
	b.projectiles.clear()
	for e in b.enemies:
		if e.id == "totem_de_chefe":
			b._kill(e)
	_to_phase(b, 0.34)
	if _enemy_shots(b) != 0:
		out.append("o anel antigo de 35%% é substituído (%d projéteis)" % _enemy_shots(b))
	var armor_seen := false
	var quad_seen := false
	var mark_seen := false
	var armor_ok := false
	for _i in 400:
		b.hero.hp = b.hero.max_hp
		b.step(Vector2.ZERO, 0.05)
		if not m.cast.is_empty():
			armor_seen = armor_seen or String(m.cast.effect) == "armor"
		quad_seen = quad_seen or not m.quad.is_empty()
		mark_seen = mark_seen or not m.mark.is_empty()
		if m.armor_t > 0.0 and absf(m.damage_taken_mult(b.boss) - 0.6) < 0.001:
			armor_ok = true
		if m.active_count() > m.budget():
			out.append("o orçamento não pode estourar (%d de %d)" % [m.active_count(), m.budget()])
			break
	if not armor_seen or not armor_ok:
		out.append("a 35%% a Síntese conjura a Armadura do Psíquico (conjuração %s, armadura %s)" % [str(armor_seen), str(armor_ok)])
	if not quad_seen:
		out.append("a 35%% a Síntese usa quadrantes")
	if mark_seen:
		out.append("a Síntese não usa a marca (o pico foi suavizado: armadura e quadrantes)")
	# o chefe repetido do modo infinito ganha mecânicas novas
	b._kill(b.boss)
	if b.boss_mech != null:
		out.append("a morte do chefe encerra as mecânicas")
