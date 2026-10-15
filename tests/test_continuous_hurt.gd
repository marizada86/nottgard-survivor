extends RefCounted
## SPEC-177 F-1/F-2: dano contínuo da névoa vira um aviso por intervalo; textos flutuantes têm limite próprio.

func _bat() -> Battle:
	var b := Battle.new(7, "durvall", "dagruve")
	b.stage.waves = []
	b.stage.elites = []
	b.stage.duration = 99999
	b._inter_t = 99999.0
	b._breakable_t = 99999.0
	return b

func _hurts(b: Battle) -> Array:
	return b.events.filter(func(e): return e.type == "hurt")

func run() -> Array:
	var out: Array = []
	var b := _bat()
	var dt := 1.0 / 60.0
	var hp_start: float = b.hero.hp
	var emitted := 0
	var summed := 0
	b.events.clear()
	for i in 180:   # 3 s de névoa de borda a 6 % da vida por segundo
		b.time += dt
		b._hurt_hero(b.hero.max_hp * 0.06 * dt, "borda_nevoa", true)
		for e in _hurts(b):
			emitted += 1
			summed += int(e.amount)
			if not bool(e.get("continuous", false)):
				out.append("o aviso de névoa deveria vir marcado como contínuo")
		b.events.clear()
	if emitted == 0:
		out.append("3 s de névoa deveriam emitir ao menos um aviso")
	if emitted > 6:
		out.append("3 s de névoa emitiram %d avisos (máximo 6)" % emitted)
	var lost: float = hp_start - b.hero.hp
	if summed > int(lost) or int(lost) - summed > 1:
		out.append("a soma dos avisos (%d) deveria acompanhar a vida perdida (%.2f)" % [summed, lost])
	# fração nunca vira rótulo "-0"
	var c := _bat()
	c.events.clear()
	c._hurt_hero(0.2, "borda_nevoa", true)
	if not _hurts(c).is_empty():
		out.append("dano contínuo menor que 1 não deveria emitir aviso")
	# dano pontual continua imediato
	var d := _bat()
	d.events.clear()
	d._hurt_hero(5.0, "pact", true)
	var immediate := _hurts(d)
	if immediate.size() != 1 or bool(immediate[0].get("continuous", false)):
		out.append("dano pontual deveria continuar imediato e sem marca contínua")
	# morte pela névoa descarrega o acumulado
	var f := _bat()
	f.events.clear()
	f.hero.hp = 1.5
	f._hurt_hero(0.9, "mare_nevoa", true)
	f._hurt_hero(1.0, "mare_nevoa", true)
	if _hurts(f).is_empty():
		out.append("a morte pela névoa deveria emitir o aviso acumulado")
	# F-2: limite próprio dos textos que não são acerto
	var run_script = load("res://ui/run.gd")
	if not run_script.can_show_aux_text(0) or run_script.can_show_aux_text(run_script.AUX_TEXT_MAX):
		out.append("o limite de textos flutuantes auxiliares deveria bloquear no máximo")
	return out
