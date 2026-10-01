extends SceneTree
## Bot de balanceamento (headless). Joga runs completas com kite + escolhas heurísticas.
##   godot --headless --path . -s tools/bot.gd -- <heroi> <seeds> [fase_inicial] [dt] [maxfases]
##   6º argumento opcional: lado do mapa (40 padrão; 60 = mapa estendido da MEC-012).
## Saída: por seed, fases alcançadas, nível, tempo, causa da morte.

var _map_side := 40.0

func _init() -> void:
	var a := OS.get_cmdline_user_args()
	var hero: String = a[0] if a.size() > 0 else "durvall"
	var seeds := int(a[1]) if a.size() > 1 else 3
	var start: String = a[2] if a.size() > 2 else "dagruve"
	var dt := float(a[3]) if a.size() > 3 else 0.06
	var max_stages := int(a[4]) if a.size() > 4 else 8
	_map_side = float(a[5]) if a.size() > 5 else 40.0
	TerrainLayout.scale = _map_side / 40.0
	var summary := {}
	for s in seeds:
		var r := _run(hero, s + 1, start, dt, max_stages)
		print("seed %d: %s" % [s + 1, r.line])
		for k in r.stages:
			summary[k] = int(summary.get(k, 0)) + 1
	print("chegaram: %s" % str(summary))
	quit()

func _run(hero_id: String, seed_v: int, start: String, dt: float, max_stages: int) -> Dictionary:
	var b := Battle.new(seed_v, hero_id, start, {})
	b.map_size = Vector2(_map_side, _map_side)
	b.hero.map_size = b.map_size
	b.hero.pos = b.map_size * 0.5
	var stages_reached: Array = [start]
	var t_total := 0.0
	var steps := 0
	var cleared := 0
	var last_stage := start
	var cause := "tempo"
	var bossinfo := {}
	while steps < 400000:
		steps += 1
		if b.state == "levelup" or b.state == "altar":
			b.choose(_pick(b))
			continue
		if b.state == "item_offer":
			b.choose(_pick_item(b))
			continue
		if b.run_time > 6000.0:
			cause = "CAP de tempo em %s (boss hp %s)" % [b.stage_id, str(int(b.boss.hp)) if b.boss != null else "-"]
			break
		if b.state == "dead" or b.state == "revive_offer":
			cause = "morreu em %s (%.0fs) nv%d por volta de %d inimigos; boss=%s" % [b.stage_id, b.time, b.hero.level, b.enemies.size(), ("hp %d/%d" % [int(b.boss.hp), int(b.boss.max_hp)]) if b.boss != null and not b.boss_dead else ("caiu" if b.boss_dead else "nao-surgiu")]
			break
		if b.state == "won":
			cause = "VENCEU"
			break
		if b.stage_id != last_stage:
			last_stage = b.stage_id
			stages_reached.append(last_stage)
			if stages_reached.size() > max_stages:
				cause = "limite de fases"
				break
		if b.active_cd <= 0.0 and not b.enemies.is_empty():
			var active_target := b.nearest(b.hero.pos, 10.0)
			var active_dir := (active_target.pos - b.hero.pos).normalized() if active_target != null else Vector2(1, 0)
			b.use_active(active_dir)
		b.step(_move(b), dt)
		if b.boss != null and not b.boss.dead:
			var bi: Dictionary = bossinfo.get(b.stage_id, {"t0": b.time, "min": 1.0, "dur": -1.0})
			bi.min = minf(float(bi.min), b.hero.hp / maxf(1.0, b.hero.max_hp))
			bossinfo[b.stage_id] = bi
		elif b.boss_dead and bossinfo.has(b.stage_id) and float(bossinfo[b.stage_id].dur) < 0.0:
			bossinfo[b.stage_id].dur = b.time - float(bossinfo[b.stage_id].t0)
		b.events.clear()
		_interact(b)
		if b.stage_cleared and b.stage.get("next", "") == "" and not b.stage.get("endless", false):
			break
		if b.stage_cleared and b.stage.get("next", "") != "":
			# vai ao portal
			for it in b.interactions:
				if it.kind == "portal" and not it.used:
					b.hero.pos = it.pos
					b.interact()
	if cause == "tempo":
		cause = "tempo (estado=%s t=%.0fs run=%.0fs boss=%s)" % [b.state, b.time, b.run_time, ("hp %d/%d" % [int(b.boss.hp), int(b.boss.max_hp)]) if b.boss != null and not b.boss_dead else ("caiu" if b.boss_dead else "nao-surgiu")]
	var line := "%s | fases=%s | profundidade=%d x%.2f | nv=%d armas=%s passivas=%s | itens=%d | %s" % [hero_id, ",".join(stages_reached),
		b.descent_depth, b.reward_multiplier(), b.hero.level, ",".join(b.hero.weapons.map(func(w): return "%s%d" % [w.id, w.level])), str(b.hero.passives), b.hero.items.size(), cause]
	var bf: Array = []
	for k in bossinfo:
		bf.append("%s:%s/pvmin%d%%" % [k, ("%.0fs" % float(bossinfo[k].dur)) if float(bossinfo[k].dur) >= 0.0 else "x", int(float(bossinfo[k].min) * 100.0)])
	line += " | chefe=" + ",".join(bf)
	return {"line": line, "stages": stages_reached}

func _interact(b: Battle) -> void:
	# usa altares e rituais próximos como um jogador usaria
	for it in b.interactions:
		if not it.used and it.kind in ["altar"] and it.pos.distance_to(b.hero.pos) < 1.6:
			b.interact()
			return

func _pick(b: Battle) -> int:
	var best := 0
	var best_s := -1.0
	for i in b.offer.size():
		var o: Dictionary = b.offer[i]
		var s := 1.0
		match String(o.t):
			"evolve": s = 10.0
			"weapon_up": s = 6.0
			"weapon_new": s = 4.0 if b.hero.weapons.size() < 3 else 2.0
			"passive": s = 5.0 if o.id in ["constituicao", "regeneracao", "cota_de_malha", "forca", "foco_arcano", "pele_de_pedra"] else 3.0
			"boon": s = 5.0
			"heal": s = 2.0
		s += randf() * 0.5
		if s > best_s:
			best_s = s
			best = i
	return best

func _move(b: Battle) -> Vector2:
	var h := b.hero
	var v := Vector2.ZERO
	var near := 0
	for e in b.enemies:
		var off: Vector2 = h.pos - e.pos
		var d := off.length()
		if d < 4.5 and d > 0.01:
			near += 1
			var w := 1.0 / maxf(0.4, d * d)
			if e.move == "keep":
				w *= 0.4
			v += off / d * w
	for z in b.zones:
		if z.owner != "hero" and (z.kind == "telegraph" or z.kind == "puddle"):
			var off: Vector2 = h.pos - z.pos
			var d := off.length()
			if d < z.radius + 1.6 and d > 0.01:
				v += off / d * 2.5
	for p in b.projectiles:
		if p.owner == "enemy":
			var off: Vector2 = h.pos - p.pos
			var d := off.length()
			if d < 3.0 and d > 0.01:
				var perp := Vector2(-p.dir.y, p.dir.x)
				v += perp * (1.0 if perp.dot(off) >= 0.0 else -1.0) * 1.5 / maxf(0.5, d)
	# pickups atraem quando calmo
	if near == 0 or v.length() < 0.4:
		var best: Variant = null
		var bd := 9.0
		for pk in b.pickups:
			var d: float = pk.pos.distance_to(h.pos)
			if d < bd:
				bd = d
				best = pk
		if best != null:
			v += (best.pos - h.pos).normalized() * 0.6
		for it in b.interactions:
			if not it.used and it.kind in ["chest", "fountain", "altar"]:
				var d2: float = it.pos.distance_to(h.pos)
				if d2 < 16.0:
					v += (it.pos - h.pos).normalized() * 0.5
	# fica longe das bordas
	var m := 3.0
	if h.pos.x < m: v.x += (m - h.pos.x)
	if h.pos.y < m: v.y += (m - h.pos.y)
	if h.pos.x > b.map_size.x - m: v.x -= (h.pos.x - (b.map_size.x - m))
	if h.pos.y > b.map_size.y - m: v.y -= (h.pos.y - (b.map_size.y - m))
	# quando o boss existe e está calmo, aproxima para causar dano
	if b.boss != null and not b.boss.dead and near < 3:
		v += (b.boss.pos - h.pos).normalized() * 0.5
	if v.length() < 0.05:
		return Vector2.ZERO
	return Iso.to_screen(v.normalized()).normalized()

## Troca de item (MEC-021/027): fica com a opção de melhor saldo de modificadores; empate, a primeira (equipar o novo).
func _pick_item(b: Battle) -> int:
	var best := 0
	var best_s := -999
	for i in b.offer.size():
		var badge: Dictionary = b.offer[i].get("badge", {})
		var s := int(badge.get("up", 0)) - int(badge.get("down", 0))
		if s > best_s:
			best_s = s
			best = i
	return best
