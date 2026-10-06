extends RefCounted
## SPEC-129 B-002: bênçãos de família. Juramento de Lliira (oath) e Caminho da Estrela de Tou Um (path).

func _bat(boon_id: String, seed_value := 3) -> Battle:
	var b := Battle.new(seed_value, "durvall", "dagruve")
	b.hero.pos = Vector2(30, 30)
	b.stage.waves = []
	b.stage.elites = []
	b.stage.duration = 99999
	b._inter_t = 99999.0
	b._breakable_t = 99999.0
	for bn in Data.table("boons").boons:
		if String(bn.id) == boon_id:
			b.hero.boons.append(bn)
	b.hero.recalc()
	return b

func _run_for(b: Battle, seconds: float, dir := Vector2.ZERO, dt := 0.1) -> void:
	var t := 0.0
	while t < seconds:
		b.step(dir, dt)
		b.events.clear()
		t += dt

func run() -> Array:
	var out: Array = []
	out.append_array(_data())
	out.append_array(_oath())
	out.append_array(_path())
	out.append_array(_no_boon())
	return out

func _data() -> Array:
	var out: Array = []
	for id in ["lliira_juramento", "tou_um_caminho"]:
		var found := false
		for bn in Data.table("boons").boons:
			if String(bn.id) == id:
				found = true
				if String(bn.get("kind", "")) == "":
					out.append("%s sem `kind`" % id)
				if BoonKinds.describe(bn) == "":
					out.append("%s sem descrição gerada" % id)
		if not found:
			out.append("bênção %s ausente em boons.json" % id)
	return out

func _oath() -> Array:
	var out: Array = []
	var o: Dictionary = BoonKinds.boon_of(_bat("lliira_juramento"), "oath").oath
	# cumprido: nenhum golpe durante a janela
	var b := _bat("lliira_juramento")
	_run_for(b, float(o.first_delay) + 1.0)
	if not bool(b.kinds.oath.open):
		out.append("o juramento deveria estar aberto após first_delay (%s s)" % o.first_delay)
	_run_for(b, float(o.window) + 1.0)
	if bool(b.kinds.oath.open):
		out.append("o juramento deveria fechar ao fim da janela")
	if not b.hero.kind_buffs.has("oath_glory"):
		out.append("cumprir o juramento deveria dar Glória")
	var dmg_glory := b.hero.m("dmg_pct")
	if absf(dmg_glory - float(o.reward.mods.dmg_pct)) > 0.001:
		out.append("Glória deveria somar %.2f de dano, veio %.2f" % [float(o.reward.mods.dmg_pct), dmg_glory])
	_run_for(b, float(o.reward.duration) + 1.0)
	if b.hero.kind_buffs.has("oath_glory") or absf(b.hero.m("dmg_pct")) > 0.001:
		out.append("a Glória deveria expirar e limpar o bônus (dmg_pct %.2f)" % b.hero.m("dmg_pct"))
	# o ciclo reabre sozinho
	_run_for(b, float(o.cycle))
	if not b.kinds.oath.armed:
		out.append("o juramento deveria seguir armado no ciclo seguinte")
	# quebrado: mais golpes que o limite
	var c := _bat("lliira_juramento", 4)
	_run_for(c, float(o.first_delay) + 1.0)
	var hp_before: float = c.hero.hp
	for i in int(o.max_hits) + 1:
		c.invuln = 0.0
		c._hurt_hero(1.0, "hit")
	var hp_lost: float = hp_before - c.hero.hp
	c.step(Vector2.ZERO, 0.1)
	if bool(c.kinds.oath.open):
		out.append("o juramento deveria fechar ao passar do limite de golpes")
	if not c.hero.kind_buffs.has("oath_judgment") or c.hero.kind_buffs.has("oath_glory"):
		out.append("quebrar o juramento deveria dar só o Julgamento")
	if absf(c.hero.m("dmg_pct") - float(o.penalty.mods.dmg_pct)) > 0.001:
		out.append("Julgamento deveria somar %.2f de dano, veio %.2f" % [float(o.penalty.mods.dmg_pct), c.hero.m("dmg_pct")])
	if c.hero.hp < hp_before - hp_lost - 0.001 or c.hero.dead:
		out.append("o Julgamento não pode tirar PV nem matar (vida %.1f -> %.1f)" % [hp_before, c.hero.hp])
	# fontes que não contam como golpe
	var d := _bat("lliira_juramento", 5)
	_run_for(d, float(o.first_delay) + 1.0)
	for i in 6:
		d.invuln = 0.0
		d._hurt_hero(1.0, "puddle")
	if int(d.kinds.oath.hits) != 0 or not bool(d.kinds.oath.open):
		out.append("poça não deve quebrar o juramento (golpes %d)" % int(d.kinds.oath.hits))
	return out

func _path() -> Array:
	var out: Array = []
	var p: Dictionary = BoonKinds.boon_of(_bat("tou_um_caminho"), "path").path
	var b := _bat("tou_um_caminho")
	b.step(Vector2.ZERO, 0.1)
	var sp: Variant = b.kinds.star_pos()
	if sp == null:
		out.append("a estrela deveria existir assim que a bênção está ativa")
		return out
	var dist: float = b.hero.pos.distance_to(sp)
	if dist < float(p.min_far) - 0.01:
		out.append("a estrela deveria nascer a pelo menos %s tiles (veio %.1f)" % [p.min_far, dist])
	if sp.x < 3.99 or sp.y < 3.99 or sp.x > b.map_size.x - 3.99 or sp.y > b.map_size.y - 3.99:
		out.append("a estrela deveria ficar dentro do mapa (%s)" % sp)
	# parado não cura
	b.hero.hp = b.hero.max_hp * 0.5
	var hp0: float = b.hero.hp
	_run_for(b, 3.0)
	if b.hero.hp > hp0 + 0.001 and b.hero.m("regen") == 0.0:
		out.append("parado, o herói não deve ser curado pela estrela")
	# seguir cura: andar na direção da estrela
	var f := _bat("tou_um_caminho", 8)
	f.step(Vector2.ZERO, 0.1)
	f.hero.hp = f.hero.max_hp * 0.3
	var hp1: float = f.hero.hp
	var healed := false
	for i in 40:
		var star: Variant = f.kinds.star_pos()
		var world_dir: Vector2 = (star - f.hero.pos).normalized()
		f.step(Iso.to_screen(world_dir).normalized(), 0.1)
		f.events.clear()
		if f.hero.hp > hp1 + 0.001:
			healed = true
			break
	if not healed:
		out.append("andar na direção da estrela deveria curar")
	# a estrela recua quando o herói chega perto
	var g := _bat("tou_um_caminho", 9)
	g.step(Vector2.ZERO, 0.1)
	g.hero.pos = g.kinds.star.pos + Vector2(1.0, 0.0)
	g.step(Vector2.ZERO, 0.1)
	if g.hero.pos.distance_to(g.kinds.star_pos()) < float(p.min_far) - 0.01:
		out.append("a estrela deveria recuar para longe quando o herói chega a %s tiles" % p.retreat_dist)
	# seguir demais: exaustão e contador zerado
	var h := _bat("tou_um_caminho", 10)
	h.step(Vector2.ZERO, 0.1)
	h.kinds.star.follow_t = float(p.exhaust_after) - 0.05
	h.kinds.star.follow_t = float(p.exhaust_after) - 0.05
	var star2: Variant = h.kinds.star_pos()
	h.hero.pos = (star2 as Vector2) + Vector2(-8.0, 0.0)
	h.kinds._prev_pos = h.hero.pos
	h.step(Iso.to_screen(Vector2(1, 0)).normalized(), 0.1)
	if not h.hero.kind_buffs.has("star_exhaust"):
		out.append("seguir por exhaust_after segundos deveria dar Exaustão")
	if float(h.kinds.star.follow_t) != 0.0:
		out.append("o contador de fé deveria zerar após a Exaustão")
	var sp_before: float = h.hero.speed_px()
	if absf(h.hero.m("speed_pct") - float(p.exhaust.mods.speed_pct)) > 0.001:
		out.append("Exaustão deveria somar %.2f de velocidade, veio %.2f (px %.1f)" % [float(p.exhaust.mods.speed_pct), h.hero.m("speed_pct"), sp_before])
	_run_for(h, float(p.exhaust.duration) + 1.0)
	if h.hero.kind_buffs.has("star_exhaust"):
		out.append("a Exaustão deveria expirar")
	return out

## Sem as bênçãos, nada muda: sem estrela, sem juramento, sem buffs.
func _no_boon() -> Array:
	var out: Array = []
	var b := Battle.new(1, "durvall", "dagruve")
	b.hero.pos = Vector2(30, 30)
	b.stage.waves = []
	b.stage.elites = []
	b._inter_t = 99999.0
	b._breakable_t = 99999.0
	_run_for(b, 90.0)
	if b.kinds.star_pos() != null or bool(b.kinds.oath.open) or not b.hero.kind_buffs.is_empty():
		out.append("sem as bênçãos de família não deve haver estrela, juramento aberto nem buffs")
	if not b.kinds.hud_lines(b).is_empty():
		out.append("sem as bênçãos de família o HUD não deve ganhar linhas")
	return out
