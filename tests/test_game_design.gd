extends RefCounted

func _quiet(b: Battle) -> void:
	b.stage.waves = []
	b.stage.elites = []
	b.stage.duration = 99999
	b._inter_t = 99999.0
	b._rule_timer = 99999.0
	b._amb_puddle = 99999.0
	b._amb_strike = 99999.0

func run() -> Array:
	var out: Array = []

	# 1) Todo herói possui uma habilidade utilizável e com recarga.
	for hero_id in Data.table("heroes"):
		var b := Battle.new(100, hero_id, "dagruve")
		_quiet(b)
		var target := b.spawn_for_test("zumbi", b.hero.pos + Vector2(1.0, 0.0))
		target.speed = 0.0
		if not b.use_active(Vector2(1, 0)):
			out.append("habilidade de %s não foi utilizada" % hero_id)
		elif b.active_cd <= 0.0 or b.use_active(Vector2(1, 0)):
			out.append("recarga da habilidade de %s não bloqueou segundo uso" % hero_id)

	# 2) Oferta estruturada: três opções únicas e papéis diferentes quando disponíveis.
	var offer_battle := Battle.new(22, "durvall", "dagruve")
	_quiet(offer_battle)
	var offer := offer_battle._build_offer()
	var keys := {}
	var roles := {}
	for option in offer:
		var key := "%s:%s" % [option.t, option.id]
		keys[key] = true
		roles[String(option.get("role", "fallback"))] = true
	if offer.size() < 3 or keys.size() != offer.size():
		out.append("oferta estruturada contém menos de 3 opções ou duplicatas")
	if not roles.has("synergy") or not roles.has("defense") or not roles.has("direction"):
		out.append("oferta não apresentou sinergia, defesa e nova direção: %s" % str(roles.keys()))

	# 3) Descida mantém a build e aumenta o multiplicador.
	var descent := Battle.new(7, "durvall", "dagruve")
	_quiet(descent)
	descent.hero.passives = {"forca": 2}
	descent.enter_next_stage()
	if descent.stage_id != "shedaklah" or descent.descent_depth != 1:
		out.append("descida não levou a Shedaklah com profundidade 1")
	if absf(descent.reward_multiplier() - 1.25) > 0.001 or int(descent.hero.passives.get("forca", 0)) != 2:
		out.append("descida não preservou build/multiplicador")

	# 4) Toda camada tem exatamente uma regra principal configurada.
	for stage_id in Data.table("stages"):
		var rule: Dictionary = Data.table("stage_rules").get(stage_id, {})
		if rule.is_empty() or String(rule.get("kind", "")) == "":
			out.append("fase %s sem regra principal" % stage_id)

	# 5) As duas fases de chefe disparam uma única vez nos limiares.
	var phase_battle := Battle.new(9, "durvall", "dagruve")
	_quiet(phase_battle)
	var boss := phase_battle.spawn_for_test("sacerdote_mente_derretida", phase_battle.hero.pos + Vector2(4, 0))
	boss.hp = boss.max_hp * 0.69
	phase_battle._check_boss_phase(boss)
	phase_battle._check_boss_phase(boss)
	if boss.phase_index != 1:
		out.append("primeira fase do chefe disparou incorretamente")
	boss.hp = boss.max_hp * 0.34
	phase_battle._check_boss_phase(boss)
	phase_battle._check_boss_phase(boss)
	if boss.phase_index != 2:
		out.append("segunda fase do chefe disparou incorretamente")

	# 6) Pactos e itens são resolvidos pelo vocabulário de efeitos.
	var effect_battle := Battle.new(3, "durvall", "dagruve")
	for boon in Data.table("boons").boons:
		if boon.id == "ghaunadaur_fome":
			effect_battle.hero.boons.append(boon)
	effect_battle.give_item(Items.unique(Data.table("items").uniques.filter(func(u): return u.id == "ampulheta")[0]))
	if not effect_battle._has_boon_effect("friendly_puddles"):
		out.append("efeito jogável da bênção não foi encontrado")
	if not effect_battle._has_item_effect("projectile_slow_on_active"):
		out.append("efeito transformador do item não foi encontrado")

	return out
