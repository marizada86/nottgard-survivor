extends RefCounted

func _bat(seed_value := 1) -> Battle:
	var b := Battle.new(seed_value)
	b.hero.pos = Vector2(10, 10)
	b.hero.map_size = Vector2(40, 40)
	return b

func run() -> Array:
	var out: Array = []

	# herói parado mata zumbi adjacente (AUTO) e ganha XP
	var b := _bat()
	b.spawn("zumbi", Vector2(11, 10))
	for i in 1500:
		b.step(Vector2.ZERO, 0.016)
	if not b.enemies.is_empty() and not b.hero.dead:
		out.append("zumbi sobreviveu e herói vivo em 24s")
	if not b.hero.dead and b.hero.xp != 8:
		out.append("XP esperado 8, veio %d" % b.hero.xp)

	# determinismo por seed
	var a := _bat(7)
	var c := _bat(7)
	a.spawn("zumbi", Vector2(11, 10))
	c.spawn("zumbi", Vector2(11, 10))
	for i in 600:
		a.step(Vector2.ZERO, 0.016)
		c.step(Vector2.ZERO, 0.016)
	if a.hero.hp != c.hero.hp or a.enemies.size() != c.enemies.size():
		out.append("simulação não determinística")

	# habilidade reduz CA em 2, respeita cooldown
	var s := _bat()
	var z := s.spawn("zumbi", Vector2(11, 10))
	var ca0: int = z.ca
	var used := false
	for seed_try in 40:
		s.rng.seed = seed_try
		s.hero.skill_timer = 0.0
		z.ca = ca0
		z.hp = z.max_hp
		if s.use_skill() and z.ca == ca0 - 2:
			used = true
			break
	if not used:
		out.append("Romper Armadura nunca reduziu a CA")
	var again := s.use_skill()
	if again:
		out.append("habilidade ignorou o cooldown")

	# modo MOUSE: cone atinge à frente e ignora atrás
	var m := _bat()
	m.aim = Battle.Aim.MOUSE
	m.aim_dir = Vector2(1, 0)
	var front := m.spawn("zumbi", Vector2(11, 10))
	var back := m.spawn("zumbi", Vector2(9, 10))
	front.atk_bonus = -99
	back.atk_bonus = -99
	front.speed = 0.0
	back.speed = 0.0
	m.step(Vector2.ZERO, 0.016)
	var swings := 0
	var dmg_events := 0
	for e in m.events:
		if e.type == "swing": swings += 1
		if e.type == "dmg": dmg_events += 1
	if swings != 1 or dmg_events != 1:
		out.append("cone: swings=%d dmg=%d (esperado 1/1)" % [swings, dmg_events])

	# modo AUTO ataca mesmo sem mira
	var au := _bat()
	au.aim_dir = Vector2(-1, 0)
	au.spawn("zumbi", Vector2(11, 10)).speed = 0.0
	au.step(Vector2.ZERO, 0.016)
	if au.events.filter(func(e): return e.type == "dmg").size() != 1:
		out.append("AUTO não atacou o alvo próximo")

	# inimigos matam herói parado; herói morto não simula
	var d := _bat()
	for i in 6:
		d.spawn("cultista_adaga", Vector2(10.5 + i * 0.01, 10.5))
	d.hero.attack_cd = 9999.0
	d.hero.atk_timer = 9999.0
	for i in 3000:
		d.step(Vector2.ZERO, 0.016)
	if not d.hero.dead or d.hero.hp != 0:
		out.append("herói deveria ter morrido")

	# crítico dobra: força d20=20 procurando seed
	var found_crit := false
	for sd in 200:
		var k := _bat(sd)
		var t := k.spawn("zumbi", Vector2(11, 10))
		t.speed = 0.0
		t.atk_bonus = -99
		k.step(Vector2.ZERO, 0.016)
		for e in k.events:
			if e.type == "dmg" and e.crit:
				found_crit = true
				if e.amount < 2 * (1 + 3):
					out.append("crítico com dano baixo demais: %d" % e.amount)
	if not found_crit:
		out.append("nenhum crítico em 200 seeds")
	return out
