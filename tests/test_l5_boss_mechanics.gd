extends RefCounted
## L5 (PROPOSTA-l5-mecanicas-de-chefe): mecânicas de chefe, orçamento de caos e interruptores.

func _cfg(path: Array, value: Variant) -> void:
	var d: Dictionary = Data.table("difficulty")
	for i in path.size() - 1:
		d = d[path[i]]
	d[path[path.size() - 1]] = value

func _boss_battle(stage_id: String) -> Battle:
	var b := Battle.new(21, "durvall", stage_id, {"meta_mods": {"hp": 50000.0}})   # herói que aguenta a luta inteira
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
	return b

func _to_phase(b: Battle, frac: float) -> void:
	b.boss.hp = b.boss.max_hp * frac
	b._check_boss_phase(b.boss)

func _enemies_with(b: Battle, id: String) -> int:
	var n := 0
	for e in b.enemies:
		if e.id == id and not e.dead:
			n += 1
	return n

func run() -> Array:
	var out: Array = []
	var cfg: Dictionary = Data.table("difficulty").get("boss_mech", {})
	if cfg.is_empty():
		return ["data/difficulty.json deveria ter o bloco boss_mech"]
	var was: bool = bool(cfg.get("enabled", false))
	var l4_was: bool = bool(Data.table("difficulty").get("l4", {}).get("enabled", false))
	_cfg(["l4", "enabled"], false)   # mede só o L5
	_cfg(["boss_mech", "enabled"], true)
	_budget(out)
	_totems(out)
	_immunity(out)
	_cast(out)
	_sweep(out)
	_quadrants(out)
	_enrage(out)
	_switches(out)
	_cfg(["boss_mech", "enabled"], was)
	_cfg(["l4", "enabled"], l4_was)
	return out

func _budget(out: Array) -> void:
	if BossMechanics.budget_for_order(0) != 2 or BossMechanics.budget_for_order(2) != 2:
		out.append("as três primeiras fases têm orçamento 2")
	if BossMechanics.budget_for_order(3) != 3 or BossMechanics.budget_for_order(6) != 4:
		out.append("o orçamento deveria crescer a cada três fases (3 e 4)")
	# com o orçamento cheio, um verbo novo espera
	var b := _boss_battle("dagruve")
	var m: BossMechanics = b.boss_mech
	if m == null:
		out.append("o Sacerdote deveria ter mecânicas")
		return
	m.cast = {"name": "x", "t": 5.0, "total": 5.0, "dice": "1d4", "stun": 2.0}
	m.sweep = {"origin": b.boss.pos, "a": 0.0, "a0": 0.0, "sign": 1.0, "arc": 1.0, "warn": 5.0, "dur": 1.0, "t": 0.0, "len": 5.0, "dice": "1d4"}
	m._verbs = [{"def": {"t": "quadrants", "cd": 5.0}, "timer": 0.0}]
	m.step(0.05)
	if not m.quad.is_empty():
		out.append("com o orçamento cheio o verbo novo não deveria começar")
	m.cast.clear()
	for v in m._verbs:
		v.timer = 0.0
	m.step(0.05)
	if m.quad.is_empty():
		out.append("com folga no orçamento o verbo deveria começar")

func _totems(out: Array) -> void:
	var b := _boss_battle("dagruve")
	if b.boss_mech == null:
		out.append("o chefe da Dagruve deveria ter mecânicas")
		return
	if _enemies_with(b, "totem_de_chefe") != 0:
		out.append("os turíbulos só aparecem na fase de 70%")
	_to_phase(b, 0.69)
	if _enemies_with(b, "totem_de_chefe") != 2:
		out.append("a 70%% deveria haver 2 turíbulos (%d)" % _enemies_with(b, "totem_de_chefe"))
	if absf(b._shield_factor(b.boss) - 0.7) > 0.001:
		out.append("com os turíbulos de pé o chefe recebe 30%% menos dano (%.2f)" % b._shield_factor(b.boss))
	for e in b.enemies:
		if e.id == "totem_de_chefe":
			b._kill(e)
	if absf(b._shield_factor(b.boss) - 1.0) > 0.001:
		out.append("sem turíbulos o chefe volta a receber o dano inteiro")
	# morte do chefe limpa tudo
	var c := _boss_battle("dagruve")
	_to_phase(c, 0.69)
	c._kill(c.boss)
	if c.boss_mech != null:
		out.append("a morte do chefe deveria encerrar as mecânicas")
	if _enemies_with(c, "totem_de_chefe") != 0:
		out.append("os turíbulos somem com o chefe")

func _immunity(out: Array) -> void:
	var b := _boss_battle("molor")
	if b.boss_mech == null:
		out.append("Blogbog deveria ter mecânicas")
		return
	_to_phase(b, 0.69)
	if _enemies_with(b, "slime_de_juiblex") != 3:
		out.append("a 70%% Blogbog invoca 3 servos, sem o invocar antigo de 5 (%d)" % _enemies_with(b, "slime_de_juiblex"))
	if not b.boss_mech.is_immune(b.boss):
		out.append("Blogbog deveria estar imune enquanto os servos vivem")
	var before: float = b.boss.hp
	var hit := b._hero_hit(b.boss, {"dice": "2d8", "attr": "forca", "dtype": "fisico"}, false)
	if hit or b.boss.hp != before:
		out.append("o chefe imune não deveria perder PV")
	for e in b.enemies:
		if e.id == "slime_de_juiblex":
			b._kill(e)
	b.step(Vector2.ZERO, 0.05)
	if b.boss_mech.is_immune(b.boss):
		out.append("sem servos o chefe volta a ser ferível")

func _cast(out: Array) -> void:
	var b := _boss_battle("docas")
	if b.boss_mech == null:
		out.append("o Guardião Alado deveria ter mecânicas")
		return
	_to_phase(b, 0.34)
	var m: BossMechanics = b.boss_mech
	for _i in 100:   # primeira conjuração aos 3 s
		b.step(Vector2.ZERO, 0.05)
		if not m.cast.is_empty():
			break
	if m.cast.is_empty():
		out.append("na fase de 35%% o Guardião deveria conjurar (verbos: %d)" % m._verbs.size())
		return
	# sem interromper: o golpe pesado sai
	var hp0: float = b.hero.hp
	for _i in 80:
		b.step(Vector2.ZERO, 0.05)
		if m.cast.is_empty():
			break
	if b.hero.hp >= hp0:
		out.append("a conjuração sem interromper deveria ferir o herói")
	# interrompendo com a habilidade ativa
	for _i in 400:
		b.step(Vector2.ZERO, 0.05)
		if not m.cast.is_empty():
			break
	if m.cast.is_empty():
		out.append("a segunda conjuração deveria começar")
		return
	b.active_cd = 0.0
	b.boss.pos = b.hero.pos + Vector2(1.2, 0.0)
	b.aim_dir = Vector2(1, 0)
	if not b.use_active(Vector2(1, 0)):
		m.on_hero_active()   # a habilidade pode não ter alvo no cone; o gancho é o que importa
	if not m.cast.is_empty():
		out.append("usar a habilidade ativa deveria interromper a conjuração")
	if b.boss.stun_t < 1.5:
		out.append("o chefe interrompido deveria ficar atordoado (%.2f)" % b.boss.stun_t)

func _sweep(out: Array) -> void:
	var b := _boss_battle("docas")
	_to_phase(b, 0.69)
	var m: BossMechanics = b.boss_mech
	for _i in 120:
		b.step(Vector2.ZERO, 0.05)
		if not m.sweep.is_empty():
			break
	if m.sweep.is_empty():
		out.append("a 70%% o Guardião deveria varrer")
		return
	var hurt := false
	for _i in 80:
		if not m.sweep.is_empty() and float(m.sweep.t) >= float(m.sweep.warn):
			b.hero.pos = (m.sweep.origin as Vector2) + Vector2.from_angle(float(m.sweep.a)) * 4.0
		var hp: float = b.hero.hp
		b.step(Vector2.ZERO, 0.05)
		if b.hero.hp < hp:
			hurt = true
			break
	if not hurt:
		out.append("a varredura deveria ferir quem está na linha")

func _quadrants(out: Array) -> void:
	var b := _boss_battle("molor")
	_to_phase(b, 0.34)
	# isola os quadrantes: sem poças da fase, sem golpes do chefe
	for e in b.enemies:   # a fase de 70% (atravessada junto) invoca servos; aqui só os quadrantes contam
		if e != b.boss:
			b._kill(e)
	b.zones.clear()
	b.boss.abilities = []
	b.boss.atk_dice = "1d1"
	b.boss.atk_bonus = -20
	var m: BossMechanics = b.boss_mech
	for _i in 160:
		b.step(Vector2.ZERO, 0.05)
		if not m.quad.is_empty():
			break
	if m.quad.is_empty():
		out.append("a 35%% Blogbog deveria acender quadrantes")
		return
	var sectors: Array = m.quad.sectors
	if sectors.size() != 2 or sectors[0] == sectors[1]:
		out.append("dois quadrantes distintos deveriam acender")
		return
	var center: Vector2 = m.quad.center
	var good_sector := 0
	for s in 4:
		if not sectors.has(s):
			good_sector = s
			break
	var good := center + Vector2.from_angle((float(good_sector) + 0.5) * TAU / 4.0) * 4.0
	var burst := false
	var hp_good: float = b.hero.hp
	for _i in 60:
		b.hero.pos = good
		b.step(Vector2.ZERO, 0.05)
		for e in b.events:
			if String(e.get("type", "")) == "telegraph_burst":
				burst = true
		b.events.clear()
		if m.quad.is_empty():
			break
	if not burst:
		out.append("o quadrante deveria explodir ao fim do aviso")
	if b.hero.hp < hp_good:
		out.append("o herói no quadrante seguro não deveria ser ferido pela explosão (%.1f → %.1f)" % [hp_good, b.hero.hp])
	# nova rodada: no quadrante aceso a explosão fere
	for _i in 300:
		b.step(Vector2.ZERO, 0.05)
		if not m.quad.is_empty():
			break
	if m.quad.is_empty():
		out.append("uma segunda rodada de quadrantes deveria acender")
		return
	var lit: Array = m.quad.sectors
	var bad: Vector2 = (m.quad.center as Vector2) + Vector2.from_angle((float(lit[0]) + 0.5) * TAU / 4.0) * 4.0
	var hp2: float = b.hero.hp
	for _i in 60:
		b.hero.pos = bad
		b.step(Vector2.ZERO, 0.05)
		if m.quad.is_empty():
			break
	if b.hero.hp >= hp2:
		out.append("quem fica no quadrante aceso deveria ser ferido (%.1f → %.1f)" % [hp2, b.hero.hp])

func _enrage(out: Array) -> void:
	var b := _boss_battle("dagruve")
	var m: BossMechanics = b.boss_mech
	var base := b._stage_dmg_mult("hit")
	m.fight_t = 80.0
	m.step(0.05)
	if m.enrage_steps != 0:
		out.append("antes de 90 s o chefe não se enfurece")
	m.fight_t = 91.0
	m.step(0.05)
	if m.enrage_steps != 1 or absf(b._stage_dmg_mult("hit") / base - 1.08) > 0.001:
		out.append("aos 90 s o chefe ganha +8%% de dano (passos %d, fator %.3f)" % [m.enrage_steps, b._stage_dmg_mult("hit") / base])
	m.fight_t = 999.0
	m.step(0.05)
	if m.enrage_steps != 5 or absf(b._stage_dmg_mult("hit") / base - 1.40) > 0.001:
		out.append("o enrage tem teto de +40%% (passos %d)" % m.enrage_steps)

func _switches(out: Array) -> void:
	_cfg(["boss_mech", "verbs", "totems"], false)
	var b := _boss_battle("dagruve")
	_to_phase(b, 0.69)
	if _enemies_with(b, "totem_de_chefe") != 0:
		out.append("com o verbo desligado não há turíbulo")
	_cfg(["boss_mech", "verbs", "totems"], true)
	_cfg(["boss_mech", "enabled"], false)
	var c := _boss_battle("dagruve")
	if c.boss_mech != null:
		out.append("com boss_mech desligado o chefe não tem mecânicas")
	_cfg(["boss_mech", "enabled"], true)
