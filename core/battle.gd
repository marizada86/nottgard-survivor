class_name Battle
extends RefCounted
## Simulação da run (sem nós, RNG por seed). A UI lê o estado e consome `events`.

enum Aim { AUTO, MOUSE }

const ENEMY_ATK_RANGE := 0.95
const ENEMY_ATK_CD := 1.1
const HERO_HIT_R := 0.3
const MAX_PICKUPS := 140
const AFFIXES := ["veloz", "resistente", "mortal", "avaro"]
const AFFIX_NAMES := {"veloz": "Veloz", "resistente": "Resistente", "mortal": "Mortal", "avaro": "Avaro"}

var rng := RandomNumberGenerator.new()
var hero: Hero
var stage_id := ""
var stage: Dictionary = {}
var enemies: Array = []
var projectiles: Array = []
var zones: Array = []
var pickups: Array = []
var interactions: Array = []
var events: Array = []
var aim := Aim.AUTO
var aim_dir := Vector2(1, 1).normalized()
var aim_pos := Vector2.ZERO
var time := 0.0
var run_time := 0.0
var state := "running"   # running | levelup | altar | dead | won
var offer: Array = []
var offer_kind := ""
var pending_levels := 0
var rerolls := 0
var boss: Enemy = null
var boss_spawned := false
var boss_dead := false
var boss_repeat := 0
var stage_cleared := false
var final_victory := false
var extracted := false
var stage_changed := false
var map_size := Vector2(40, 40)
var difficulty := 1.0
var revive_left := 0
var invuln := 0.0
var stats := {"kills": 0, "crits": 0, "ones": 0, "elites": 0, "bosses": 0, "chests": 0, "gold": 0.0, "damage_taken": 0.0, "stages_cleared": 0, "boss_ids": [], "stage_ids": [], "cleared_ids": []}
var codex := {"enemies": {}, "items": {}, "weapons": {}}
var _acc := {}
var _elites_done := {}
var _inter_t := 4.0
var _amb_puddle := 9.0
var _amb_strike := 6.0
var _cur_angle := 0.0
var _trickle := 0.0
var _grid := {}
var _first_inter := true

func _init(seed_value: int = 1, hero_id: String = "durvall", stage_key: String = "dagruve", ctx: Dictionary = {}) -> void:
	rng.seed = seed_value
	difficulty = float(ctx.get("difficulty", 1.0))
	hero = Hero.make(hero_id, ctx.get("meta_mods", {}), ctx.get("bonus_mods", {}))
	hero.map_size = map_size
	hero.pos = map_size * 0.5
	rerolls = int(hero.m("rerolls"))
	revive_left = int(hero.m("revive"))
	hero.xp_need = xp_need_for(1)
	var start_w: String = Data.table("heroes")[hero_id].weapon
	hero.weapons.append(Weapon.make(start_w))
	codex.weapons[start_w] = true
	load_stage(stage_key)

func load_stage(stage_key: String) -> void:
	stage_id = stage_key
	stage = Data.table("stages")[stage_key].duplicate(true)
	enemies.clear()
	projectiles.clear()
	zones.clear()
	pickups.clear()
	interactions.clear()
	time = 0.0
	boss = null
	boss_spawned = false
	boss_dead = false
	boss_repeat = 0
	stage_cleared = false
	_acc.clear()
	_elites_done.clear()
	_inter_t = 4.0
	_first_inter = true
	_amb_puddle = 9.0
	_amb_strike = 6.0
	hero.pos = map_size * 0.5
	if not stats.stage_ids.has(stage_key):
		stats.stage_ids.append(stage_key)
	stage_changed = true

static func xp_need_for(lv: int) -> int:
	return int(18.0 + lv * 10.0 + lv * lv * 1.2)

func spawn_for_test(id: String, at: Vector2) -> Enemy:
	return _spawn(id, at, 0.0)

func toggle_aim() -> void:
	aim = Aim.MOUSE if aim == Aim.AUTO else Aim.AUTO

func minute() -> float:
	return time / 60.0

func alive(id: String) -> int:
	var n := 0
	for e in enemies:
		if e.id == id and not e.dead:
			n += 1
	return n

# ------------------------------------------------------------------ passo

func step(screen_dir: Vector2, dt: float) -> void:
	if state != "running" or hero.dead:
		return
	time += dt
	run_time += dt
	invuln = maxf(0.0, invuln - dt)
	hero.push = Vector2.ZERO
	_ambient(dt)
	hero.step(screen_dir, dt)
	if hero.m("regen") > 0.0:
		hero.hp = minf(hero.max_hp, hero.hp + hero.m("regen") * dt)
	_build_grid()
	_update_weapons(dt)
	_update_projectiles(dt)
	_update_zones(dt)
	for e in enemies:
		if not e.dead:
			_enemy_step(e, dt)
	enemies = enemies.filter(func(x): return not x.dead)
	_update_pickups(dt)
	_update_interactions(dt)
	_director(dt)

func _build_grid() -> void:
	_grid.clear()
	for e in enemies:
		var k := Vector2i(int(floor(e.pos.x)), int(floor(e.pos.y)))
		if not _grid.has(k):
			_grid[k] = []
		_grid[k].append(e)

func nearest(from: Vector2, max_range: float) -> Enemy:
	var best: Enemy = null
	var bd := max_range
	for e in enemies:
		if e.dead:
			continue
		var d: float = e.pos.distance_to(from) - e.radius
		if d <= bd:
			bd = d
			best = e
	return best

# ------------------------------------------------------------------ armas

func _cd_of(p: Dictionary) -> float:
	var f := clampf(1.0 - hero.m("cd_pct"), 0.35, 1.5)
	return maxf(0.25, float(p.cd) * f)

func _update_weapons(dt: float) -> void:
	for w in hero.weapons:
		w.timer -= dt
		if w.timer <= 0.0:
			var p: Dictionary = w.params()
			if _fire(w, p):
				w.timer = _cd_of(p)
			else:
				w.timer = 0.12

func _fire(w: Weapon, p: Dictionary) -> bool:
	var area := 1.0 + hero.m("area_pct")
	match String(p.kind):
		"melee": return _fire_melee(p, area)
		"bolt": return _fire_bolt(p)
		"nova": return _fire_nova(p, area)
		"zone": return _fire_zone(p, area)
	return false

func _fire_melee(p: Dictionary, area: float) -> bool:
	var reach: float = float(p.range) * area
	var dir := aim_dir
	if aim == Aim.AUTO:
		var t := nearest(hero.pos, reach)
		if t == null:
			return false
		dir = (t.pos - hero.pos).normalized()
	var cos_c := cos(deg_to_rad(minf(float(p.cone) * (1.0 + (area - 1.0) * 0.5), 175.0)))
	var targets: Array = []
	for e in enemies:
		var off: Vector2 = e.pos - hero.pos
		if not e.dead and off.length() - e.radius <= reach and (off.length() < 0.05 or off.normalized().dot(dir) >= cos_c):
			targets.append(e)
	if targets.is_empty():
		return false
	events.append({"type": "swing", "pos": hero.pos, "dir": dir, "range": reach, "cone": float(p.cone)})
	for t in targets:
		_hero_hit(t, p, true)
	return true

func _fire_bolt(p: Dictionary) -> bool:
	var dir := aim_dir
	if aim == Aim.AUTO:
		var t := nearest(hero.pos, 10.0 * (1.0 + hero.m("area_pct")))
		if t == null:
			return false
		dir = (t.pos - hero.pos).normalized()
	var n := int(p.get("count", 1))
	var spread := float(p.get("spread", 14.0))
	for k in n:
		var ang := deg_to_rad((k - (n - 1) * 0.5) * spread)
		projectiles.append({"owner": "hero", "pos": hero.pos, "dir": dir.rotated(ang), "speed": float(p.speed), "life": float(p.range) * (1.0 + hero.m("area_pct")) / float(p.speed),
			"pierce": int(p.get("pierce", 0)), "radius": 0.4, "p": p, "hit": {}})
	events.append({"type": "cast", "pos": hero.pos, "dir": dir})
	return true

func _fire_nova(p: Dictionary, area: float) -> bool:
	var r: float = float(p.radius) * area
	var targets: Array = []
	for e in enemies:
		if not e.dead and e.pos.distance_to(hero.pos) - e.radius <= r:
			targets.append(e)
	if targets.is_empty() and float(p.get("heal", 0.0)) <= 0.0:
		return false
	if targets.is_empty() and hero.hp >= hero.max_hp:
		return false
	events.append({"type": "nova", "pos": hero.pos, "radius": r, "dtype": p.dtype})
	var heal := float(p.get("heal", 0.0))
	if heal > 0.0:
		hero.hp = minf(hero.max_hp, hero.hp + heal)
		events.append({"type": "heal", "pos": hero.pos, "amount": int(heal)})
	for t in targets:
		_hero_hit(t, p, true)
	return true

func _fire_zone(p: Dictionary, area: float) -> bool:
	var r: float = float(p.radius) * area
	var at := hero.pos
	var reach: float = float(p.get("range", 0.0)) * area
	if reach > 0.0:
		if aim == Aim.AUTO:
			var t := nearest(hero.pos, reach)
			if t == null:
				return false
			at = t.pos
		else:
			var off := aim_pos - hero.pos
			at = hero.pos + off.limit_length(reach)
	else:
		if nearest(hero.pos, r * 2.0) == null:
			return false
	zones.append({"owner": "hero", "kind": "zone", "pos": at, "radius": r, "life": float(p.get("duration", 3.0)), "tick": float(p.get("tick", 0.5)), "acc": 0.0, "p": p})
	events.append({"type": "zone", "pos": at, "radius": r, "dtype": p.dtype})
	return true

## Golpe do herói. `roll`: usa d20 vs CA/CAM (senão acerta sempre, p.ex. zonas).
func _hero_hit(e: Enemy, p: Dictionary, roll: bool) -> bool:
	if e.dead:
		return false
	var attr := String(p.get("attr", "forca"))
	var dtype := String(p.get("dtype", "fisico"))
	var r := 0
	var crit := false
	if roll:
		r = Dice.d20(rng)
		var acc := hero.prof + hero.attr_mod(attr) + int(hero.m("hit")) + int(p.get("acc", 0))
		var defn: int = e.ca if dtype == "fisico" else e.cam
		var cmin := 20 - hero.crit_range()
		if r == 1:
			stats.ones += 1
		crit = r >= cmin
		if not crit and (r == 1 or r + acc < defn):
			events.append({"type": "miss", "pos": e.pos})
			return false
	var dmg := 0.0
	var dice := String(p.get("dice", ""))
	if dice != "":
		dmg = float(Dice.roll(rng, dice) + hero.attr_mod(attr) + int(p.get("dmg", 0)) + int(hero.m("dmg_flat")))
		var pct := 1.0 + hero.m("dmg_pct")
		if hero.hp < hero.max_hp * 0.5:
			pct += hero.m("low_hp_dmg")
		dmg *= maxf(0.2, pct) * (1.0 + e.mark) * float(e.resist.get(dtype, 1.0))
		if crit:
			dmg *= 2.0
			stats.crits += 1
		dmg = maxf(1.0, round(dmg))
		e.hp -= dmg
		e.hit_flash = 0.12
		events.append({"type": "hit", "pos": e.pos, "amount": int(dmg), "crit": crit})
		var ls := float(p.get("lifesteal", 0.0)) + hero.m("lifesteal")
		if ls > 0.0:
			hero.hp = minf(hero.max_hp, hero.hp + dmg * ls)
	_apply_effects(e, p)
	if float(p.get("gold_hit", 0.0)) > 0.0:
		_add_gold(float(p.gold_hit))
	if e.hp <= 0.0 and not e.dead:
		_kill(e)
	return true

func _apply_effects(e: Enemy, p: Dictionary) -> void:
	if float(p.get("weaken", 0.0)) > 0.0 and e.ca > 4:
		var n := int(p.weaken)
		e.ca -= n
		e.cam -= n
	if float(p.get("stun", 0.0)) > 0.0 and not e.is_boss():
		e.stun_t = maxf(e.stun_t, float(p.stun))
	elif float(p.get("stun", 0.0)) > 0.0:
		e.stun_t = maxf(e.stun_t, minf(float(p.stun) * 0.3, 0.6))
	if float(p.get("slow", 0.0)) > 0.0:
		e.slow_t = maxf(e.slow_t, float(p.slow))
	if float(p.get("mark", 0.0)) > 0.0:
		e.mark = maxf(e.mark, float(p.mark))
		e.mark_t = 5.0
	if float(p.get("burn", 0.0)) > 0.0:
		e.burn_t = 3.0
		e.burn_dps = maxf(e.burn_dps, float(p.burn) * 1.5)
	if float(p.get("knock", 0.0)) > 0.0 and not e.is_boss():
		var away: Vector2 = (e.pos - hero.pos).normalized() * float(p.knock)
		if hero.is_free(e.pos + away, e.radius):
			e.pos += away

# ------------------------------------------------------------------ projéteis e zonas

func _update_projectiles(dt: float) -> void:
	var keep: Array = []
	for pr in projectiles:
		pr.pos += pr.dir * pr.speed * dt
		pr.life -= dt
		var gone: bool = pr.life <= 0.0 or pr.pos.x < 0.0 or pr.pos.y < 0.0 or pr.pos.x > map_size.x or pr.pos.y > map_size.y
		if not gone:
			if pr.owner == "hero":
				for e in enemies:
					if e.dead or pr.hit.has(e):
						continue
					if e.pos.distance_to(pr.pos) <= e.radius + pr.radius:
						pr.hit[e] = true
						_hero_hit(e, pr.p, true)
						pr.pierce -= 1
						if pr.pierce < 0:
							gone = true
							break
			elif pr.pos.distance_to(hero.pos) <= HERO_HIT_R + pr.radius:
				_enemy_hit_hero(int(pr.bonus), String(pr.dice), String(pr.dtype), true)
				gone = true
		if not gone:
			keep.append(pr)
	projectiles = keep

func _update_zones(dt: float) -> void:
	var keep: Array = []
	for z in zones:
		z.life -= dt
		if z.owner == "hero":
			z.acc += dt
			if z.acc >= z.tick:
				z.acc -= z.tick
				for e in enemies:
					if not e.dead and e.pos.distance_to(z.pos) <= z.radius + e.radius * 0.5:
						_hero_hit(e, z.p, false)
			if z.life > 0.0:
				keep.append(z)
		elif z.kind == "puddle":
			if hero.pos.distance_to(z.pos) <= z.radius and hero.m("puddle_immune") <= 0.0:
				hero.slow_t = 0.3
				z.acc += dt
				if z.acc >= 0.9:
					z.acc = 0.0
					_hurt_hero(2.0 + tier(), "puddle")
			if z.life > 0.0:
				keep.append(z)
		else:   # telegraph
			z.delay -= dt
			if z.delay <= 0.0:
				events.append({"type": "boom", "pos": z.pos, "radius": z.radius})
				if hero.pos.distance_to(z.pos) <= z.radius + HERO_HIT_R:
					_hurt_hero(float(Dice.roll(rng, z.dice) + int(z.bonus / 2)), "aoe")
			else:
				keep.append(z)
	zones = keep

func tier() -> int:
	return int(stage.get("tier", 0))

# ------------------------------------------------------------------ inimigos

func _enemy_step(e: Enemy, dt: float) -> void:
	e.hit_flash = maxf(0.0, e.hit_flash - dt)
	e.atk_cd = maxf(0.0, e.atk_cd - dt)
	e.slow_t = maxf(0.0, e.slow_t - dt)
	if e.burn_t > 0.0:
		e.burn_t -= dt
		e.hp -= e.burn_dps * dt
		if e.hp <= 0.0:
			_kill(e)
			return
	if e.mark_t > 0.0:
		e.mark_t -= dt
		if e.mark_t <= 0.0:
			e.mark = 0.0
	if e.stun_t > 0.0:
		e.stun_t -= dt
		return
	var to := hero.pos - e.pos
	var dist := to.length()
	if e.charge_t > 0.0:
		e.charge_t -= dt
		var np: Vector2 = e.pos + e.charge_dir * float(e.charge_ab.speed) * dt
		if hero.is_free(np, e.radius):
			e.pos = np
		if dist <= e.radius + HERO_HIT_R + 0.2 and e.atk_cd <= 0.0:
			e.atk_cd = 1.0
			_enemy_hit_hero(int(e.charge_ab.get("bonus", e.atk_bonus)), String(e.charge_ab.dice), "fisico", false)
		return
	if e.windup > 0.0:
		e.windup -= dt
		if e.windup <= 0.0:
			e.charge_t = float(e.charge_ab.dist) / float(e.charge_ab.speed)
		return
	for i in e.abilities.size():
		e.ab_cd[i] -= dt
		if e.ab_cd[i] <= 0.0 and _use_ability(e, i, e.abilities[i], dist, to):
			e.ab_cd[i] = float(e.abilities[i].cd) * (0.85 + rng.randf() * 0.3)
	var spd := e.speed * (0.5 if e.slow_t > 0.0 else 1.0)
	if e.speed > 0.0 and dist > 0.001:
		var dir := to / dist
		var mv := Vector2.ZERO
		if e.move == "keep":
			if dist > e.keep + 0.6:
				mv = dir
			elif dist < e.keep - 1.2:
				mv = -dir * 0.7
		elif dist > ENEMY_ATK_RANGE * 0.6:
			mv = dir
		if mv != Vector2.ZERO:
			var step_v := mv * spd * dt
			var nx := Vector2(e.pos.x + step_v.x, e.pos.y)
			if hero.is_free(nx, e.radius):
				e.pos = nx
			var ny := Vector2(e.pos.x, e.pos.y + step_v.y)
			if hero.is_free(ny, e.radius):
				e.pos = ny
	var k := Vector2i(int(floor(e.pos.x)), int(floor(e.pos.y)))
	for dx in range(-1, 2):
		for dy in range(-1, 2):
			var cell: Array = _grid.get(Vector2i(k.x + dx, k.y + dy), [])
			for o in cell:
				if o != e:
					var off: Vector2 = e.pos - o.pos
					var l := off.length()
					var min_d: float = e.radius + o.radius
					if l < min_d and l > 0.001:
						e.pos += off / l * (min_d - l) * 0.35
	var reach := 1.4 if e.speed == 0.0 else ENEMY_ATK_RANGE + e.radius * 0.3
	if dist <= reach and e.atk_cd <= 0.0:
		e.atk_cd = ENEMY_ATK_CD
		_enemy_hit_hero(e.atk_bonus, e.atk_dice, "fisico", false)

func _use_ability(e: Enemy, idx: int, a: Dictionary, dist: float, to: Vector2) -> bool:
	match String(a.t):
		"shoot":
			if dist > float(a.range):
				return false
			var dir := to.normalized()
			projectiles.append({"owner": "enemy", "pos": e.pos, "dir": dir, "speed": float(a.speed), "life": float(a.range) / float(a.speed) + 1.0, "radius": 0.25,
				"dice": a.dice, "bonus": int(a.bonus) + int(minute() / 4.0) + tier(), "dtype": a.dtype, "pierce": 0, "hit": {}, "p": {}})
			return true
		"aoe":
			if dist > float(a.range):
				return false
			var lead := hero.pos
			zones.append({"owner": "enemy", "kind": "telegraph", "pos": lead, "radius": float(a.radius), "delay": float(a.delay), "life": 99.0,
				"dice": a.dice, "bonus": e.atk_bonus, "dtype": a.dtype})
			events.append({"type": "telegraph", "pos": lead, "radius": float(a.radius), "delay": float(a.delay)})
			return true
		"charge":
			if dist < 2.5 or dist > float(a.dist) + 3.0:
				return false
			e.windup = float(a.windup)
			e.charge_dir = to.normalized()
			e.charge_ab = a
			events.append({"type": "windup", "pos": e.pos, "dir": e.charge_dir, "len": float(a.dist)})
			return true
		"summon":
			if alive(String(a.id)) >= int(a.cap):
				return false
			for i in int(a.n):
				var at := e.pos + Vector2(rng.randf_range(-1.5, 1.5), rng.randf_range(-1.5, 1.5))
				_spawn(String(a.id), at)
			events.append({"type": "text", "pos": e.pos, "text": "invoca"})
			return true
		"puddle":
			zones.append({"owner": "enemy", "kind": "puddle", "pos": e.pos, "radius": float(a.radius), "delay": 0.0, "life": float(a.life), "acc": 0.0})
			return true
		"ring":
			if dist > 13.0:
				return false
			var n := int(a.n)
			var off := rng.randf() * TAU
			for k in n:
				var ang := off + TAU * k / n
				projectiles.append({"owner": "enemy", "pos": e.pos, "dir": Vector2(cos(ang), sin(ang)), "speed": float(a.speed), "life": 4.0, "radius": 0.25,
					"dice": a.dice, "bonus": e.atk_bonus, "dtype": "magico", "pierce": 0, "hit": {}, "p": {}})
			return true
	return false

func _enemy_hit_hero(bonus: int, dice: String, dtype: String, is_proj: bool) -> void:
	if hero.dead or invuln > 0.0:
		return
	var r := Dice.d20(rng)
	var defn: int = hero.ca() if dtype == "fisico" else hero.cam()
	if r == 1 or (r != 20 and r + bonus < defn):
		events.append({"type": "text", "pos": hero.pos, "text": "erra"})
		return
	if rng.randf() < hero.m("dodge"):
		events.append({"type": "text", "pos": hero.pos, "text": "esquiva"})
		return
	var dmg := float(Dice.roll(rng, dice)) * (2.0 if r == 20 else 1.0)
	_hurt_hero(dmg, "hit")

func _hurt_hero(dmg: float, src: String) -> void:
	if hero.dead or invuln > 0.0:
		return
	dmg = maxf(1.0, dmg * difficulty - hero.m("dr"))
	hero.hp -= dmg
	hero.hit_flash = 0.15
	stats.damage_taken += dmg
	events.append({"type": "hurt", "pos": hero.pos, "amount": int(dmg)})
	if hero.hp <= 0.0:
		if revive_left > 0:
			revive_left -= 1
			hero.hp = hero.max_hp * 0.5
			invuln = 3.0
			for e in enemies:
				if e.pos.distance_to(hero.pos) < 4.0 and not e.is_boss():
					e.stun_t = 2.0
			events.append({"type": "toast", "text": "Segunda Chance!"})
		else:
			hero.hp = 0.0
			hero.dead = true
			state = "dead"
			events.append({"type": "dead", "pos": hero.pos})

# ------------------------------------------------------------------ mortes e drops

func _kill(e: Enemy) -> void:
	if e.dead:
		return
	e.dead = true
	codex.enemies[e.id] = true
	stats.kills += 1
	var xp_v := float(e.xp)
	events.append({"type": "kill", "pos": e.pos, "enemy": e})
	if xp_v > 0.0:
		_drop("xp", e.pos, xp_v)
	if e.xp > 0 and rng.randf() < 0.22 + hero.m("gold_pct") * 0.05:
		_drop("gold", e.pos, maxf(1.0, round(float(stage.coin_mult) * (1.0 + hero.m("gold_pct")))) * (5.0 if e.affix == "avaro" else 1.0))
	if e.xp > 0 and rng.randf() < 0.025:
		_drop("potion", e.pos, 0.25)
	if e.split_id != "":
		for i in 2:
			_spawn(e.split_id, e.pos + Vector2(rng.randf_range(-0.6, 0.6), rng.randf_range(-0.6, 0.6)))
	if e.affix != "" or e.drops_chest:
		stats.elites += 1
		if e.drops_chest or rng.randf() < 0.5:
			_add_interaction("chest", e.pos)
		_drop("gold", e.pos, 12.0 * float(stage.coin_mult))
	if e.is_boss():
		_on_boss_dead(e)

func _on_boss_dead(e: Enemy) -> void:
	boss_dead = true
	stats.bosses += 1
	stats.boss_ids.append(e.id)
	_drop("gold", e.pos, 60.0 * float(stage.coin_mult))
	_add_interaction("chest", e.pos + Vector2(1.2, 0))
	_add_interaction("chest", e.pos + Vector2(-1.2, 0))
	events.append({"type": "toast", "text": "%s caiu!" % e.name})
	if bool(stage.get("endless", false)):
		if not final_victory:
			final_victory = true
			stats.cleared_ids.append(stage_id)
			events.append({"type": "toast", "text": "Vitória final! Continue nos Pilares ou extraia (X)."})
		boss_repeat += 1
		boss_spawned = false
		time = 0.0
		return
	stage_cleared = true
	stats.stages_cleared += 1
	stats.cleared_ids.append(stage_id)
	var nxt: String = stage.get("next", "")
	if nxt != "":
		_add_interaction("portal", e.pos + Vector2(0, 2.0))
		events.append({"type": "toast", "text": "Portal aberto: %s (E). Ou extraia (X)." % String(stage.essence)})
	else:
		state = "won"

func _drop(kind: String, at: Vector2, value: float) -> void:
	if pickups.size() >= MAX_PICKUPS and kind != "potion":
		_collect(kind, value)
		return
	pickups.append({"kind": kind, "pos": at + Vector2(rng.randf_range(-0.3, 0.3), rng.randf_range(-0.3, 0.3)), "value": value, "magnet": false})

func _collect(kind: String, value: float) -> void:
	match kind:
		"xp": _add_xp(value * (1.0 + hero.m("xp_pct")))
		"gold": _add_gold(value)
		"potion":
			hero.hp = minf(hero.max_hp, hero.hp + hero.max_hp * value)
			events.append({"type": "heal", "pos": hero.pos, "amount": int(hero.max_hp * value)})

func _add_gold(v: float) -> void:
	hero.gold += int(v)
	stats.gold += v

func _add_xp(v: float) -> void:
	hero.xp += v
	while hero.xp >= hero.xp_need:
		hero.xp -= hero.xp_need
		hero.level += 1
		hero.xp_need = xp_need_for(hero.level)
		pending_levels += 1
	if pending_levels > 0 and state == "running":
		_open_levelup()

func _update_pickups(dt: float) -> void:
	var rng_pick := hero.pickup_range()
	var keep: Array = []
	for p in pickups:
		var d: float = p.pos.distance_to(hero.pos)
		if d <= 0.5:
			_collect(p.kind, p.value)
			continue
		if d <= rng_pick or p.magnet:
			p.magnet = true
			p.pos += (hero.pos - p.pos).normalized() * (5.0 + rng_pick) * dt
		keep.append(p)
	pickups = keep

# ------------------------------------------------------------------ interações

func _add_interaction(kind: String, at: Vector2) -> void:
	at = at.clamp(Vector2(1, 1), map_size - Vector2(1, 1))
	interactions.append({"kind": kind, "pos": at, "used": false})

func _update_interactions(dt: float) -> void:
	for it in interactions:
		if it.used:
			continue
		var d: float = it.pos.distance_to(hero.pos)
		if d <= 0.8 and (it.kind == "chest" or it.kind == "fountain"):
			it.used = true
			if it.kind == "chest":
				_open_chest(it)
			else:
				hero.hp = minf(hero.max_hp, hero.hp + hero.max_hp * 0.4)
				events.append({"type": "heal", "pos": hero.pos, "amount": int(hero.max_hp * 0.4)})
				events.append({"type": "toast", "text": "Fonte: +40% PV"})
	interactions = interactions.filter(func(i): return not i.used)

## Interação manual (E): altar, ritual, portal.
func interact() -> bool:
	if state != "running":
		return false
	var best: Dictionary = {}
	var bd := 1.6
	for it in interactions:
		if not it.used and it.kind in ["altar", "ritual", "portal"]:
			var d: float = it.pos.distance_to(hero.pos)
			if d <= bd:
				bd = d
				best = it
	if best.is_empty():
		return false
	best.used = true
	match String(best.kind):
		"altar":
			_open_altar()
		"ritual":
			var elites: Array = stage.elites
			var el: Dictionary = elites[rng.randi() % elites.size()]
			var boss_e := _spawn_elite(String(el.id), best.pos)
			boss_e.drops_chest = true
			var waves: Array = stage.waves
			for i in 6:
				var w: Dictionary = waves[rng.randi() % waves.size()]
				_spawn(String(w.id), best.pos + Vector2(rng.randf_range(-2, 2), rng.randf_range(-2, 2)))
			events.append({"type": "toast", "text": "O ritual atrai algo..."})
		"portal":
			enter_next_stage()
	return true

func _open_chest(it: Dictionary) -> void:
	stats.chests += 1
	if rng.randf() < 0.10 + tier() * 0.01 and not it.get("safe", false):
		var m := _spawn("mimico", it.pos, 0.0)
		m.drops_chest = true
		m.max_hp = round(m.max_hp * (1.0 + tier() * 0.5))
		m.hp = m.max_hp
		events.append({"type": "toast", "text": "Era um Mímico!"})
		return
	give_item(Items.roll(rng, tier(), hero.m("carisma") + hero.attr_mod("carisma")))

func give_item(item: Dictionary) -> void:
	codex.items[item.id] = true
	var slot: String = item.slot
	var cur: Variant = hero.items.get(slot)
	if cur != null and Items.RANK[cur.rarity] > Items.RANK[item.rarity]:
		var g: float = 8.0 * float(Items.RANK[item.rarity] + 1)
		_add_gold(g)
		events.append({"type": "toast", "text": "%s vendido (+%d moedas)" % [item.name, int(g)], "color": Items.rarity_color(item.rarity)})
		return
	if cur != null and String(cur.get("weapon", "")) != "":
		hero.weapons = hero.weapons.filter(func(w): return not (w.granted and w.id == cur.weapon))
	hero.items[slot] = item
	var wid: String = item.get("weapon", "")
	if wid != "" and not hero.weapons.any(func(w): return w.id == wid):
		var w := Weapon.make(wid)
		w.granted = true
		hero.weapons.append(w)
		codex.weapons[wid] = true
	hero.recalc()
	events.append({"type": "item", "item": item})
	events.append({"type": "toast", "text": "%s [%s]" % [item.name, item.rarity], "color": Items.rarity_color(item.rarity)})

func _open_altar() -> void:
	var boons: Array = Data.table("boons").boons.duplicate()
	var have: Array = hero.boons.map(func(b): return b.id)
	boons = boons.filter(func(b): return not (b.id in have))
	_shuffle(boons)
	offer = []
	for b in boons.slice(0, 3):
		offer.append({"t": "boon", "id": b.id, "name": "%s: %s" % [b.god, b.name], "desc": b.desc, "boon": b})
	if offer.is_empty():
		return
	offer_kind = "altar"
	state = "altar"

func _shuffle(a: Array) -> void:
	for i in range(a.size() - 1, 0, -1):
		var j := rng.randi_range(0, i)
		var t: Variant = a[i]
		a[i] = a[j]
		a[j] = t

func enter_next_stage() -> void:
	var nxt: String = stage.get("next", "")
	if nxt == "":
		return
	hero.hp = minf(hero.max_hp, hero.hp + hero.max_hp * 0.4)
	load_stage(nxt)
	events.append({"type": "toast", "text": "Você desce: %s" % Data.table("stages")[nxt].name})

func extract() -> void:
	if stage_cleared or final_victory:
		extracted = true
		state = "won"

# ------------------------------------------------------------------ level-up

func _open_levelup() -> void:
	offer = _build_offer()
	offer_kind = "levelup"
	state = "levelup"
	events.append({"type": "levelup", "level": hero.level})

func _build_offer() -> Array:
	var n := 3 + int(hero.m("choices"))
	var pool: Array = []
	var wdata: Dictionary = Data.table("weapons")
	var pdata: Dictionary = Data.table("passives")
	var owned_w := 0
	for w in hero.weapons:
		if not w.granted:
			owned_w += 1
		var pv: Dictionary = w.params()
		if w.can_evolve() and int(hero.passives.get(w.def.evolve.passive, 0)) > 0:
			var evo: Dictionary = wdata[w.def.evolve.into]
			pool.append({"t": "evolve", "id": w.id, "into": w.def.evolve.into, "name": "EVOLUÇÃO: %s" % evo.name, "desc": evo.desc, "weight": 9.0})
		elif w.level < w.max_level():
			pool.append({"t": "weapon_up", "id": w.id, "name": "%s → Nv %d" % [w.def.name, w.level + 1], "desc": _level_desc(w), "weight": 3.0})
	if owned_w < hero.weapon_slots():
		for wid in wdata:
			var d: Dictionary = wdata[wid]
			if String(d.src).begins_with("Evolu") or String(d.src).begins_with("Item"):
				continue
			if hero.weapons.any(func(w): return w.id == wid):
				continue
			pool.append({"t": "weapon_new", "id": wid, "name": "NOVA: %s" % d.name, "desc": d.desc, "weight": 2.0})
	var owned_p := hero.passives.size()
	for pid in pdata:
		var lv := int(hero.passives.get(pid, 0))
		if lv >= 5:
			continue
		if lv > 0:
			pool.append({"t": "passive", "id": pid, "name": "%s → Nv %d" % [pdata[pid].name, lv + 1], "desc": pdata[pid].desc, "weight": 3.0})
		elif owned_p < 5:
			pool.append({"t": "passive", "id": pid, "name": "NOVA: %s" % pdata[pid].name, "desc": pdata[pid].desc, "weight": 2.0})
	var out: Array = []
	for i in n:
		if pool.is_empty():
			break
		var total := 0.0
		for c in pool:
			total += float(c.weight)
		var roll := rng.randf() * total
		var pick := 0
		for j in pool.size():
			roll -= float(pool[j].weight)
			if roll <= 0.0:
				pick = j
				break
		out.append(pool[pick])
		pool.remove_at(pick)
	if out.size() < n:
		out.append({"t": "heal", "id": "heal", "name": "Provisões", "desc": "Recupera 40% dos PV.", "weight": 1.0})
	if out.size() < n:
		out.append({"t": "gold", "id": "gold", "name": "Bolsa de Moedas", "desc": "+40 moedas.", "weight": 1.0})
	return out

func _level_desc(w: Weapon) -> String:
	var lv: Array = w.def.get("levels", [])
	if w.level - 1 >= lv.size():
		return ""
	var parts: Array = []
	for k in lv[w.level - 1]:
		var v: Variant = lv[w.level - 1][k]
		parts.append("%s %s" % [k, v if k == "dice" else "%+.1f" % float(v)])
	return ", ".join(parts)

func choose(i: int) -> void:
	if state != "levelup" and state != "altar":
		return
	if i < 0 or i >= offer.size():
		return
	var c: Dictionary = offer[i]
	match String(c.t):
		"weapon_new":
			hero.weapons.append(Weapon.make(String(c.id)))
			codex.weapons[String(c.id)] = true
		"weapon_up":
			for w in hero.weapons:
				if w.id == c.id:
					w.level += 1
		"evolve":
			for w in hero.weapons:
				if w.id == c.id:
					var nw := Weapon.make(String(c.into))
					nw.granted = w.granted
					hero.weapons[hero.weapons.find(w)] = nw
					codex.weapons[String(c.into)] = true
					break
		"passive":
			hero.passives[c.id] = int(hero.passives.get(c.id, 0)) + 1
		"heal":
			hero.hp = minf(hero.max_hp, hero.hp + hero.max_hp * 0.4)
		"gold":
			_add_gold(40.0)
		"boon":
			hero.boons.append(c.boon)
	hero.recalc()
	if offer_kind == "altar":
		state = "running"
		offer.clear()
		return
	pending_levels -= 1
	if pending_levels > 0:
		offer = _build_offer()
	else:
		offer.clear()
		state = "running"

func reroll() -> bool:
	if state != "levelup" or rerolls <= 0:
		return false
	rerolls -= 1
	offer = _build_offer()
	return true

# ------------------------------------------------------------------ diretor e ambiente

func _ring_pos() -> Vector2:
	for i in 8:
		var ang := rng.randf() * TAU
		var p := hero.pos + Vector2(cos(ang), sin(ang)) * rng.randf_range(8.0, 11.0)
		if p.x > 1.0 and p.y > 1.0 and p.x < map_size.x - 1.0 and p.y < map_size.y - 1.0 and hero.is_free(p, 0.4):
			return p
	return hero.pos + Vector2(8, 0)

func _spawn(id: String, at: Vector2, minute_override: float = -1.0) -> Enemy:
	var mn := minute() if minute_override < 0.0 else minute_override
	var e := Enemy.make(id, at, mn, float(stage.hp_mult) * difficulty, tier())
	e.pos = e.pos.clamp(Vector2(0.6, 0.6), map_size - Vector2(0.6, 0.6))
	if "illusions" in stage.ambient and not e.is_boss() and not e.has_flag("elite_only") and rng.randf() < 0.12 and e.xp > 0:
		e.max_hp = 1.0
		e.hp = 1.0
		e.xp = 0
		e.flags = e.flags + ["ghost"]
	enemies.append(e)
	codex.enemies[id] = codex.enemies.get(id, false)
	return e

func _spawn_elite(id: String, at: Vector2) -> Enemy:
	var e := _spawn(id, at)
	e.affix = AFFIXES[rng.randi() % AFFIXES.size()]
	match e.affix:
		"veloz": e.speed *= 1.5
		"resistente":
			e.max_hp *= 2.0
			e.hp = e.max_hp
		"mortal": e.atk_bonus += 3
	e.xp *= 3
	e.name = "%s (%s)" % [e.name, AFFIX_NAMES[e.affix]]
	events.append({"type": "toast", "text": "Elite: %s" % e.name})
	return e

func _director(dt: float) -> void:
	var cap := int(stage.cap) + int(minute()) * 3
	if enemies.size() < cap:
		for wi in stage.waves.size():
			var w: Dictionary = stage.waves[wi]
			if time < float(w.t0) or time > float(w.t1):
				continue
			_acc[wi] = float(_acc.get(wi, 0.0)) + dt
			if _acc[wi] >= float(w.every):
				_acc[wi] = 0.0
				var room := int(w.max) - alive(String(w.id))
				for i in mini(int(w.n), room):
					if enemies.size() < cap:
						_spawn(String(w.id), _ring_pos())
	for i in stage.elites.size():
		var el: Dictionary = stage.elites[i]
		if not _elites_done.has(i) and time >= float(el.at):
			_elites_done[i] = true
			_spawn_elite(String(el.id), _ring_pos())
	if not boss_spawned and time >= float(stage.duration):
		boss_spawned = true
		var scale_extra := 1.0 + 0.5 * boss_repeat
		boss = _spawn(String(stage.boss), _ring_pos(), 0.0)
		boss.max_hp = round(boss.max_hp * scale_extra * (1.0 + 0.3 * tier() * 0.0))
		boss.hp = boss.max_hp
		codex.enemies[boss.id] = true
		events.append({"type": "boss", "enemy": boss})
		events.append({"type": "toast", "text": "%s surge!" % boss.name})
	if boss_spawned and not boss_dead:
		_trickle += dt
		if _trickle >= 3.5 and enemies.size() < cap:
			_trickle = 0.0
			var w0: Dictionary = stage.waves[0]
			_spawn(String(w0.id), _ring_pos())
	_inter_t -= dt
	if _inter_t <= 0.0:
		_inter_t = 50.0 + rng.randf() * 25.0
		_spawn_random_interaction()

func _spawn_random_interaction() -> void:
	var alive_n := interactions.filter(func(i): return not i.used and i.kind != "portal").size()
	if alive_n >= 4:
		return
	var weights: Dictionary = stage.interactions
	var total := 0.0
	for k in weights:
		total += float(weights[k])
	var roll := rng.randf() * total
	var kind := "chest"
	for k in weights:
		roll -= float(weights[k])
		if roll <= 0.0:
			kind = k
			break
	if _first_inter:
		_first_inter = false
		kind = "chest"
	var ang := rng.randf() * TAU
	_add_interaction(kind, hero.pos + Vector2(cos(ang), sin(ang)) * rng.randf_range(6.0, 12.0))
	events.append({"type": "toast", "text": "Algo apareceu no mapa..."})

func _ambient(dt: float) -> void:
	for a in stage.ambient:
		match String(a):
			"puddles":
				_amb_puddle -= dt
				if _amb_puddle <= 0.0:
					_amb_puddle = 7.0 + rng.randf() * 4.0
					var ang := rng.randf() * TAU
					zones.append({"owner": "enemy", "kind": "puddle", "pos": hero.pos + Vector2(cos(ang), sin(ang)) * rng.randf_range(2.5, 6.0),
						"radius": 1.3, "delay": 0.0, "life": 10.0, "acc": 0.0})
			"current":
				_cur_angle += 0.12 * dt
				hero.push += Vector2(cos(_cur_angle), sin(_cur_angle)) * 0.9
			"strikes":
				_amb_strike -= dt
				if _amb_strike <= 0.0:
					_amb_strike = 3.5 + rng.randf() * 2.5
					var at := hero.pos + Vector2(rng.randf_range(-3, 3), rng.randf_range(-3, 3)) * (0.3 if rng.randf() < 0.5 else 1.0)
					zones.append({"owner": "enemy", "kind": "telegraph", "pos": at, "radius": 1.5, "delay": 1.3, "life": 99.0, "dice": "2d6", "bonus": 4 + tier(), "dtype": "magico"})
					events.append({"type": "telegraph", "pos": at, "radius": 1.5, "delay": 1.3})

# ------------------------------------------------------------------ resultado

func result() -> Dictionary:
	return {"won": state == "won", "dead": state == "dead", "extracted": extracted, "time": run_time, "kills": stats.kills, "gold": int(stats.gold),
		"level": hero.level, "stage": stage_id, "hero": hero.id, "bosses": stats.bosses, "boss_ids": stats.boss_ids, "elites": stats.elites, "crits": stats.crits,
		"ones": stats.ones, "chests": stats.chests, "stages_cleared": stats.stages_cleared, "stage_ids": stats.stage_ids, "cleared_ids": stats.cleared_ids, "final_victory": final_victory, "weapons": hero.weapons.map(func(w): return w.id), "codex": codex}
