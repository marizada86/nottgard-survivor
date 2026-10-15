extends RefCounted
## L4 do relato do T05 (proposta em vault/drafts/PROPOSTA-l4-...): telégrafo, atiradores legíveis e movimentos novos.

func _set_l4(on: bool) -> void:
	Data.table("difficulty")["l4"]["enabled"] = on

func _bat(stage := "dagruve") -> Battle:
	var b := Battle.new(4, "durvall", stage)
	b.stage.waves = []
	b.stage.elites = []
	b.stage.duration = 99999
	b._inter_t = 99999.0
	b._breakable_t = 99999.0
	b.hero.pos = b.map_size * 0.5
	b.hero.max_hp = 99999.0
	b.hero.hp = 99999.0
	b.hero.weapons.clear()
	return b

func run() -> Array:
	var out: Array = []
	if not Data.table("difficulty").has("l4"):
		return ["data/difficulty.json deveria ter o bloco l4"]
	var was: bool = bool(Data.table("difficulty").l4.get("enabled", false))
	_emerge(out)
	_telegraph(out)
	_aim(out)
	_strafe(out)
	_lunge(out)
	_pack(out)
	_set_l4(was)
	return out

func _emerge(out: Array) -> void:
	for on in [false, true]:
		_set_l4(on)
		var far := 0
		var near := 0
		for s in 8:
			var b := Battle.new(10 + s, "durvall", "docas")
			b.hero.pos = b.map_size * 0.5
			var t := b._spawn_elite("tentaculo_kraken", b._ring_pos())
			var d := t.pos.distance_to(b.hero.pos)
			if d > 6.0:
				far += 1
			else:
				near += 1
		if on and far > 0:
			out.append("com o L4 o Tentáculo deveria nascer ao alcance de 6 tiles (%d de 8 longe)" % far)
		if not on and near > 0:
			out.append("sem o L4 o Tentáculo nasce no anel, fora do alcance (%d de 8 perto)" % near)

func _telegraph(out: Array) -> void:
	_set_l4(true)
	var b := _bat()
	var t: Enemy = b.spawn_for_test("tentaculo_kraken", b.hero.pos + Vector2(3.0, 0.0))
	t.ab_cd = [0.0]
	b.step(Vector2.ZERO, 0.05)
	var zone: Variant = null
	for z in b.zones:
		if z.kind == "telegraph":
			zone = z
	if zone == null:
		out.append("o Tentáculo ao alcance deveria armar um golpe em área")
		return
	if not zone.has("src"):
		out.append("o golpe deveria guardar a origem para a linha")
	if absf(float(zone.delay) - 1.3) > 0.06:
		out.append("o aviso do Tentáculo deveria durar 1,3 s (%.2f)" % float(zone.delay))
	if t.cast_t <= 0.0:
		out.append("o inimigo deveria ficar 'quente' enquanto o golpe está armado")
	_set_l4(false)
	var c := _bat()
	var t2: Enemy = c.spawn_for_test("tentaculo_kraken", c.hero.pos + Vector2(3.0, 0.0))
	t2.ab_cd = [0.0]
	c.step(Vector2.ZERO, 0.05)
	for z in c.zones:
		if z.kind == "telegraph" and (z.has("src") or absf(float(z.delay) - 0.9) > 0.06):
			out.append("sem o L4 o golpe do Tentáculo segue com 0,9 s e sem origem")

func _aim(out: Array) -> void:
	_set_l4(true)
	var b := _bat()
	var a: Enemy = b.spawn_for_test("cultista_arqueiro", b.hero.pos + Vector2(5.0, 0.0))
	a.ab_cd = [0.0]
	b.step(Vector2.ZERO, 0.05)
	var projectiles_now := b.projectiles.filter(func(p): return p.owner == "enemy").size()
	if a.shoot_wind <= 0.0 or projectiles_now != 0:
		out.append("com o L4 o atirador deveria mirar antes de atirar (mira %.2f, tiros %d)" % [a.shoot_wind, projectiles_now])
	var dir_locked := a.shoot_dir
	b.hero.pos += Vector2(0.0, 3.0)   # o herói sai do lugar durante a mira
	for _i in 12:
		b.step(Vector2.ZERO, 0.05)
	var shots: Array = b.projectiles.filter(func(p): return p.owner == "enemy")
	if shots.is_empty():
		out.append("o tiro deveria sair ao fim da mira")
	elif (shots[0].dir as Vector2).distance_to(dir_locked) > 0.01:
		out.append("o tiro deveria sair na direção travada no início da mira")
	_set_l4(false)
	var c := _bat()
	var a2: Enemy = c.spawn_for_test("cultista_arqueiro", c.hero.pos + Vector2(5.0, 0.0))
	a2.ab_cd = [0.0]
	c.step(Vector2.ZERO, 0.05)
	if c.projectiles.filter(func(p): return p.owner == "enemy").is_empty():
		out.append("sem o L4 o atirador atira na hora")

func _strafe(out: Array) -> void:
	for on in [false, true]:
		_set_l4(on)
		var b := _bat()
		var a: Enemy = b.spawn_for_test("cultista_arqueiro", b.hero.pos + Vector2(5.4, 0.0))   # dentro da faixa de manter distância
		a.ab_cd = [999.0]
		var start := a.pos
		for _i in 60:
			b.step(Vector2.ZERO, 0.05)
		var moved := a.pos.distance_to(start)
		if on and moved < 0.5:
			out.append("com o L4 o atirador deveria andar de lado (andou %.2f)" % moved)
		if not on and moved > 0.05:
			out.append("sem o L4 o atirador fica parado na faixa (andou %.2f)" % moved)

func _lunge(out: Array) -> void:
	_set_l4(true)
	var b := _bat()
	var c: Enemy = b.spawn_for_test("cultista_adaga", b.hero.pos + Vector2(3.0, 0.0))
	b.step(Vector2.ZERO, 0.05)
	if c.windup <= 0.0:
		out.append("o cultista deveria armar o bote a 3 tiles")
	var armed := false
	for e in b.events:
		if String(e.get("type", "")) == "windup":
			armed = true
	if not armed:
		out.append("o bote deveria avisar com o evento windup")
	var d0 := c.pos.distance_to(b.hero.pos)
	for _i in 16:
		b.step(Vector2.ZERO, 0.05)
	if c.pos.distance_to(b.hero.pos) >= d0 - 0.5:
		out.append("o cultista deveria ter saltado em direção ao herói")
	_set_l4(false)
	var b2 := _bat()
	var c2: Enemy = b2.spawn_for_test("cultista_adaga", b2.hero.pos + Vector2(3.0, 0.0))
	b2.step(Vector2.ZERO, 0.05)
	if c2.windup > 0.0:
		out.append("sem o L4 não há bote")

func _pack(out: Array) -> void:
	_set_l4(true)
	var solo := _bat()
	var z: Enemy = solo.spawn_for_test("zumbi", solo.hero.pos + Vector2(8.0, 0.0))
	var s0 := z.pos
	for _i in 20:
		solo.step(Vector2.ZERO, 0.05)
	var solo_move := z.pos.distance_to(s0)
	var group := _bat()
	var g: Enemy = group.spawn_for_test("zumbi", group.hero.pos + Vector2(8.0, 0.0))
	for k in 3:
		group.spawn_for_test("zumbi", group.hero.pos + Vector2(8.0 + 0.4 * float(k + 1), 0.0))
	var g0 := g.pos
	for _i in 20:
		group.step(Vector2.ZERO, 0.05)
	var group_move := g.pos.distance_to(g0)
	if group_move <= solo_move * 1.2:
		out.append("zumbi em grupo deveria andar mais que sozinho (grupo %.2f, só %.2f)" % [group_move, solo_move])
