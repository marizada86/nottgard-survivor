extends RefCounted
## SPEC-162 (PLAN-088 B-001): verificações antes manuais do roteiro do PLAN-033 que a suíte ainda não cobria.
##   BUG-005: quebráveis reaparecem por tempo, perto do herói, e a contagem não explode.
##   BUG-006: comprar na loja, no ferreiro e no curandeiro não mexe no ouro do Quartel (`stats.gold`).

func _bat(seed_value: int, hero := "durvall", stage := "dagruve") -> Battle:
	var b := Battle.new(seed_value, hero, stage)
	b.hero.pos = Vector2(20, 20)
	b.stage.waves = []
	b.stage.elites = []
	b.stage.duration = 99999
	b._inter_t = 99999.0
	b._breakable_t = 99999.0
	return b

func _breakables(b: Battle) -> int:
	var n := 0
	for e in b.enemies:
		if not e.dead and e.has_flag("quebravel"):
			n += 1
	return n

func run() -> Array:
	var out: Array = []

	# BUG-005: o relógio dos quebráveis, ao zerar, cria um quebrável entre 6 e 11 tiles do herói e reinicia a contagem.
	var b := _bat(61)
	var before := _breakables(b)
	b._breakable_t = 0.01
	b.step(Vector2.ZERO, 0.1)
	var after := _breakables(b)
	if after != before + 1:
		out.append("quebrável deveria reaparecer quando o relógio zera (antes %d, depois %d)" % [before, after])
	if b._breakable_t <= 1.0:
		out.append("o relógio dos quebráveis deveria ser rearmado com o intervalo configurado (%.2f s)" % b._breakable_t)
	for e in b.enemies:
		if not e.dead and e.has_flag("quebravel"):
			var dist: float = e.pos.distance_to(b.hero.pos)
			if dist < 5.0 or dist > 12.0:
				out.append("quebrável novo deveria nascer a 6 a 11 tiles do herói (nasceu a %.1f)" % dist)

	# BUG-005: sem o relógio zerado, nada novo nasce (não há vazamento de quebráveis a cada passo).
	var quiet := _bat(62)
	quiet.step(Vector2.ZERO, 0.1)
	if _breakables(quiet) != 0:
		out.append("nenhum quebrável deveria nascer antes do relógio zerar")

	# BUG-005: o tipo vem da tabela do bioma (cada fase tem os seus quebráveis).
	for stage_id in Battle.BREAKABLE_TYPES_BY_STAGE:
		var sb := _bat(63, "durvall", String(stage_id))
		sb._breakable_t = 0.01
		sb.step(Vector2.ZERO, 0.1)
		var allowed: Array = Battle.BREAKABLE_TYPES_BY_STAGE[stage_id]
		var found := false
		for e in sb.enemies:
			if e.has_flag("quebravel"):
				found = true
				if not allowed.has(e.id):
					out.append("%s: quebrável '%s' fora da tabela do bioma" % [stage_id, e.id])
		if not found:
			out.append("%s: relógio zerado não criou quebrável" % stage_id)

	# BUG-006: comprar não mexe no ouro histórico (stats.gold), que é o que vai para o Quartel.
	for kind in ["loja", "ferreiro", "curandeiro"]:
		var s := _bat(64 if kind == "loja" else 65 if kind == "ferreiro" else 66)
		s.hero.gold = 5000
		if kind == "curandeiro":
			s.hero.hp = maxf(1.0, s.hero.max_hp * 0.4)
		s._open_shop_event(kind)
		var idx := -1
		for j in s.offer.size():
			if String(s.offer[j].t).begins_with("shop_") and String(s.offer[j].t) != "shop_leave" and String(s.offer[j].t) != "shop_info":
				idx = j
				break
		if idx < 0:
			out.append("%s: nenhuma oferta para comprar (teste sem cobertura)" % kind)
			continue
		var meta_before := float(s.stats.gold)
		var run_before: int = s.hero.gold
		s.choose(idx)
		if s.hero.gold >= run_before:
			out.append("%s: comprar deveria gastar ouro da run" % kind)
		if float(s.stats.gold) != meta_before:
			out.append("%s: comprar não deveria alterar o ouro do Quartel (stats.gold %.1f -> %.1f)" % [kind, meta_before, float(s.stats.gold)])

	return out
