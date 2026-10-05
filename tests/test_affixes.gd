extends RefCounted
## SPEC-120 parte A: dmg_mult por fase e afixos de elite/chefe.

const DMG_MULTS := {"dagruve": 1.0, "docas": 1.7, "shedaklah": 1.7, "molor": 2.1, "durao": 2.7, "feng_tu": 3.2, "shendilavri": 3.6, "goranthis": 3.9, "pilares": 4.2}

func _bat(stage: String) -> Battle:
	var b := Battle.new(11, "durvall", stage)
	b.stage.waves = []
	b.stage.elites = []
	b.stage.duration = 99999
	b._inter_t = 99999.0
	b._breakable_t = 99999.0
	b.hero.max_hp = 9999.0
	b.hero.hp = 9999.0
	return b

func run() -> Array:
	var f: Array = []
	for stage_id in DMG_MULTS:
		var b := _bat(stage_id)
		if not is_equal_approx(float(b.stage.get("dmg_mult", 0.0)), float(DMG_MULTS[stage_id])):
			f.append("%s: dmg_mult esperado %s, veio %s" % [stage_id, DMG_MULTS[stage_id], b.stage.get("dmg_mult", "ausente")])
	# o multiplicador vale para golpe e área, mas não para poça/armadilha/névoa
	var b := _bat("goranthis")
	var hp0: float = b.hero.hp
	b._hurt_hero(10.0, "hit")
	var hit_taken := hp0 - b.hero.hp
	if absf(hit_taken - 39.0) > 1.5:   # 10 × 3,9 (− defesas do herói)
		f.append("golpe em Goranthis devia dar ~39, deu %s" % hit_taken)
	b.invuln = 0.0
	hp0 = b.hero.hp
	b._hurt_hero(10.0, "puddle")
	if absf((hp0 - b.hero.hp) - 10.0) > 1.5:
		f.append("poça não deve escalar com dmg_mult, deu %s" % (hp0 - b.hero.hp))

	# Dagruve e Docas: elite com um afixo do conjunto antigo
	for sid in ["dagruve", "docas"]:
		var bd := _bat(sid)
		for i in 12:
			var e := bd._spawn_elite("zumbi", bd.hero.pos + Vector2(5, 0))
			if e.affixes.size() != 1 or not (e.affixes[0] in Battle.AFFIXES):
				f.append("%s: elite devia ter 1 afixo antigo, tem %s" % [sid, e.affixes])
				break

	# quantidade de afixos por fase
	var expected := {"shedaklah": [1, 1], "molor": [1, 1], "durao": [1, 2], "feng_tu": [1, 2], "shendilavri": [2, 2], "goranthis": [2, 2], "pilares": [2, 2]}
	for sid in expected:
		var bs := _bat(sid)
		var lo := 99
		var hi := 0
		for i in 40:
			var e := bs._spawn_elite("zumbi", bs.hero.pos + Vector2(5, 0))
			lo = mini(lo, e.affixes.size())
			hi = maxi(hi, e.affixes.size())
			if e.affix != e.affixes[0]:
				f.append("%s: affix principal diverge de affixes[0]" % sid)
				break
		if lo < int(expected[sid][0]) or hi > int(expected[sid][1]):
			f.append("%s: afixos por elite %d–%d, esperado %s" % [sid, lo, hi, expected[sid]])

	# afixos novos
	var bn := _bat("shedaklah")
	var plain := bn.spawn_for_test("zumbi", bn.hero.pos + Vector2(6, 0))
	var base_ca := plain.ca
	bn._apply_affix(plain, "blindado")
	if plain.ca != base_ca + 3:
		f.append("blindado devia dar +3 CA")
	bn._apply_affix(plain, "blindado")
	if plain.affixes.size() != 1:
		f.append("afixo repetido não deve duplicar")

	# explosivo: ao morrer, aviso no chão
	var bx := _bat("shedaklah")
	var boom := bx.spawn_for_test("zumbi", bx.hero.pos + Vector2(6, 0))
	bx._apply_affix(boom, "explosivo")
	var zones_before := bx.zones.size()
	bx._kill(boom)
	if bx.zones.size() != zones_before + 1 or String(bx.zones.back().kind) != "telegraph":
		f.append("explosivo devia deixar um telegraph ao morrer")

	# vampírico cura 20 % do dano causado
	var bv := _bat("shedaklah")
	var leech := bv.spawn_for_test("zumbi", bv.hero.pos + Vector2(6, 0))
	bv._apply_affix(leech, "vampirico")
	leech.hp = 1.0
	leech.max_hp = 1000.0
	bv.invuln = 0.0
	var seen := false
	for i in 40:
		bv.invuln = 0.0
		bv._enemy_hit_hero(60, "1d6", "fisico", false, 1.0, leech)
		if leech.hp > 1.0:
			seen = true
			break
	if not seen:
		f.append("vampírico devia curar ao acertar")

	# escudeiro reduz 25 % o dano em aliados próximos, mas não nele mesmo nem longe
	var bs2 := _bat("shedaklah")
	var shield := bs2.spawn_for_test("zumbi", bs2.hero.pos + Vector2(6, 0))
	bs2._apply_affix(shield, "escudeiro")
	var near := bs2.spawn_for_test("zumbi", shield.pos + Vector2(1, 0))
	var far := bs2.spawn_for_test("zumbi", shield.pos + Vector2(20, 0))
	if not is_equal_approx(bs2._shield_factor(near), 0.75) or bs2._shield_factor(far) != 1.0 or bs2._shield_factor(shield) != 1.0:
		f.append("aura do escudeiro: perto 0.75, longe e ele mesmo 1.0")
	bs2._kill(shield)
	if bs2._shield_factor(near) != 1.0:
		f.append("escudeiro morto não deve proteger")

	# invocador chama 3 servos do bioma
	var bi := _bat("shedaklah")
	bi.stage.waves = [{"t0": 0, "t1": 999, "id": "servo_de_zuggtmoy", "every": 3.0, "n": 1, "max": 5}]
	var summoner := bi.spawn_for_test("zumbi", bi.hero.pos + Vector2(6, 0))
	bi._apply_affix(summoner, "invocador")
	var n0 := bi.enemies.size()
	summoner.affix_t = 0.0
	bi._affix_step(summoner, 0.1)
	if bi.enemies.size() != n0 + Battle.AFFIX_SUMMON_N:
		f.append("invocador devia chamar %d servos, chamou %d" % [Battle.AFFIX_SUMMON_N, bi.enemies.size() - n0])

	# chefe: sem afixo até Molor... Durao (5ª fase) em diante tem 1, sem virar elite
	for sid in ["dagruve", "shedaklah", "molor"]:
		var bb := _bat(sid)
		var boss_e := bb.spawn_for_test(String(bb.stage.boss), bb.hero.pos + Vector2(6, 0))
		bb._apply_boss_affix(boss_e)
		if not boss_e.affixes.is_empty():
			f.append("%s: chefe não devia ter afixo" % sid)
	for sid in ["durao", "feng_tu", "pilares"]:
		var bb := _bat(sid)
		var boss_e := bb.spawn_for_test(String(bb.stage.boss), bb.hero.pos + Vector2(6, 0))
		bb._apply_boss_affix(boss_e)
		if boss_e.affixes.size() != 1 or boss_e.affix != "" or not (boss_e.affixes[0] in Battle.BOSS_AFFIXES):
			f.append("%s: chefe devia ter 1 afixo sem virar elite (%s)" % [sid, boss_e.affixes])

	# horda: Dagruve/Docas/Pilares não têm; Shedaklah avisa 5 s antes, dura 20 s e só acontece uma vez
	for sid in ["dagruve", "docas", "pilares"]:
		var bh := _bat(sid)
		bh.stage.waves = [{"t0": 0, "t1": 999, "id": "zumbi", "every": 1.0, "n": 1, "max": 5}]
		bh.time = float(bh.stage.duration) * Battle.HORDE_AT
		bh._horde_step(0.1)
		if bh._horde_state != 0:
			f.append("%s não devia ter horda" % sid)
	var bh2 := _bat("shedaklah")
	bh2.stage.waves = [{"t0": 0, "t1": 999, "id": "zumbi", "every": 1.0, "n": 2, "max": 5}]
	var start := float(bh2.stage.duration) * Battle.HORDE_AT
	bh2.time = start - Battle.HORDE_WARNING - 1.0
	bh2._horde_step(0.1)
	if bh2._horde_state != 0:
		f.append("horda não devia avisar cedo demais")
	bh2.time = start - Battle.HORDE_WARNING + 0.1
	bh2._horde_step(0.1)
	if bh2._horde_state != 1:
		f.append("horda devia avisar 5 s antes")
	bh2.time = start + 0.1
	bh2._horde_step(0.1)
	if not bh2.horde_active():
		f.append("horda devia estar ativa no início")
	bh2._horde_step(2.0)
	if bh2.alive("zumbi") != 6:
		f.append("horda devia soltar n×3 = 6 zumbis, soltou %d" % bh2.alive("zumbi"))
	bh2._horde_step(Battle.HORDE_DURATION)
	bh2._horde_step(0.1)
	if bh2._horde_state != 3 or bh2.horde_active():
		f.append("horda devia terminar após 20 s")
	return f
