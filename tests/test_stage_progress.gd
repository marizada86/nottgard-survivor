extends RefCounted
## SPEC-163 (MEC-002): o estado da barra de progresso da fase (modo e fração).

func _bat(seed_value := 71, stage := "dagruve") -> Battle:
	var b := Battle.new(seed_value, "durvall", stage)
	b.hero.pos = Vector2(20, 20)
	return b

func _near(a: float, b: float) -> bool:
	return absf(a - b) < 0.001

func run() -> Array:
	var out: Array = []

	# até o chefe: a fração acompanha time / duration
	var b := _bat()
	var dur := float(b.stage.duration)
	for pair in [[0.0, 0.0], [0.5, 0.5], [0.99, 0.99]]:
		b.time = dur * float(pair[0])
		var s := StageProgress.state(b)
		if String(s.mode) != StageProgress.MODE_STAGE or not _near(float(s.fraction), float(pair[1])):
			out.append("fase em %.0f%%: esperava modo stage e fração %.2f, veio %s" % [float(pair[0]) * 100.0, float(pair[1]), str(s)])
	b.time = dur * 3.0
	if float(StageProgress.state(b).fraction) > 1.0:
		out.append("a fração nunca passa de 1")

	# chefe vivo: cheia
	var boss := _bat()
	boss.boss_spawned = true
	var sb := StageProgress.state(boss)
	if String(sb.mode) != StageProgress.MODE_BOSS or not _near(float(sb.fraction), 1.0):
		out.append("chefe vivo: esperava modo boss e fração 1, veio %s" % str(sb))

	# depois do chefe, sem Maré (Pilares, regras desligadas): nada
	var nf := _bat()
	nf.boss_spawned = true
	nf.boss_dead = true
	nf.fog_state = "inactive"
	if String(StageProgress.state(nf).mode) != StageProgress.MODE_NONE:
		out.append("chefe morto sem Maré: a barra deveria sumir")

	# depois do chefe, com Maré: esvazia de 1 a 0 em carência + aviso + avanço
	var fg := _bat()
	fg.boss_spawned = true
	fg.boss_dead = true
	fg.fog_state = "grace"
	fg.fog_config = {"grace_seconds": 8.0, "warning_seconds": 2.0, "advance_seconds": 30.0}   # total 40
	for pair in [[0.0, 1.0], [10.0, 0.75], [20.0, 0.5], [40.0, 0.0], [90.0, 0.0]]:
		fg.fog_elapsed = float(pair[0])
		var sf := StageProgress.state(fg)
		if String(sf.mode) != StageProgress.MODE_FOG or not _near(float(sf.fraction), float(pair[1])):
			out.append("Maré a %.0f s: esperava fração %.2f, veio %s" % [float(pair[0]), float(pair[1]), str(sf)])
	if not _near(StageProgress.fog_total_seconds({}), 38.0):
		out.append("sem configuração a Maré dura 8 + 2 + 28 = 38 s")

	# o relógio de verdade: uma fase real chega ao chefe e a barra vira 'boss'
	var run := _bat(72)
	run.stage.waves = []
	run.stage.elites = []
	run._inter_t = 99999.0
	run._breakable_t = 99999.0
	run.hero.max_hp = 1.0e9
	run.hero.hp = 1.0e9
	run.time = float(run.stage.duration) - 0.5
	for i in 20:
		run.step(Vector2.ZERO, 0.1)
	if not run.boss_spawned or String(StageProgress.state(run).mode) != StageProgress.MODE_BOSS:
		out.append("ao chegar em stage.duration o chefe nasce e a barra deveria virar 'boss' (veio %s)" % str(StageProgress.state(run)))

	# sem batalha: nada
	if String(StageProgress.state(null).mode) != StageProgress.MODE_NONE:
		out.append("sem batalha a barra some")

	# cores: dourado no começo, quente no fim, azul na Maré
	if StageProgress.fill_color({"mode": "stage", "fraction": 0.1}, 0) != StageProgress.GOLD:
		out.append("início da fase deveria ser dourado")
	if StageProgress.fill_color({"mode": "stage", "fraction": 1.0}, 0) != StageProgress.HOT:
		out.append("fim da fase deveria esquentar para laranja")
	if StageProgress.fill_color({"mode": "fog", "fraction": 0.5}, 0) != StageProgress.FOG_BLUE:
		out.append("Maré deveria ser azul-névoa")
	return out
