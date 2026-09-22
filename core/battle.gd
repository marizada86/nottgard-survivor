class_name Battle
extends RefCounted
## Simulação da run (sem nós, RNG por seed). A UI lê o estado e consome `events`.

enum Aim { AUTO, MOUSE }

const ENEMY_ATK_RANGE := 0.95
const ENEMY_ATK_CD := 1.3
const SPAWN_SLOW := 1.35   # multiplica o intervalo das ondas (ritmo lento)
const HIT_INVULN := 0.4
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
var active_def: Dictionary = {}
var active_cd := 0.0
var active_buff_t := 0.0
var time_slow_t := 0.0
var projectile_slow_t := 0.0
var active_guard := 0
var active_guard_t := 0.0
var barrier := 0.0
var shadow_charge := false
var descent_depth := 0
var stage_rule: Dictionary = {}
var _rule_timer := 0.0
var _rule_index := -1
var _effect_cd := {}
var _hero_moving := false

func _init(seed_value: int = 1, hero_id: String = "durvall", stage_key: String = "dagruve", ctx: Dictionary = {}) -> void:
	rng.seed = seed_value
	difficulty = float(ctx.get("difficulty", 1.0))
	hero = Hero.make(hero_id, ctx.get("meta_mods", {}), ctx.get("bonus_mods", {}))
	active_def = Data.table("abilities")[hero_id].duplicate(true)
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
	stage_rule = Data.table("stage_rules").get(stage_key, {}).duplicate(true)
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
	_rule_timer = minf(8.0, float(stage_rule.get("interval", 8.0)))
	_rule_index = -1
	hero.pos = map_size * 0.5
	if _has_boon_effect("stage_heal"):
		_heal_hero(hero.max_hp * 0.15)
	if not stats.stage_ids.has(stage_key):
		stats.stage_ids.append(stage_key)
	stage_changed = true

static func xp_need_for(lv: int) -> int:
	return int(12.0 + lv * 7.0 + lv * lv * 0.9)

func spawn_for_test(id: String, at: Vector2) -> Enemy:
	return _spawn(id, at, 0.0)

func toggle_aim() -> void:
	aim = Aim.MOUSE if aim == Aim.AUTO else Aim.AUTO

func active_status() -> String:
	if active_guard > 0:
		return "[Q/RMB] %s — GUARDA ATIVA" % active_def.name
	if active_cd <= 0.0:
		return "[Q/RMB] %s — PRONTA" % active_def.name
	return "[Q/RMB] %s — %.1fs" % [active_def.name, active_cd]

func reward_multiplier() -> float:
	return _reward_multiplier_for(descent_depth)

func _reward_multiplier_for(depth: int) -> float:
	var values := [1.0, 1.25, 1.55, 1.90]
	if depth < values.size():
		return values[depth]
	return 1.90 + float(depth - 3) * 0.35

func next_reward_multiplier() -> float:
	return _reward_multiplier_for(descent_depth + 1)

func _has_boon_effect(effect_id: String) -> bool:
	var defs: Dictionary = Data.table("boon_effects")
	for boon in hero.boons:
		if defs.get(String(boon.id), {}).get("effect", "") == effect_id:
			return true
	return false

func _has_item_effect(effect_id: String) -> bool:
	var defs: Dictionary = Data.table("item_effects")
	for item in hero.items.values():
		if defs.get(String(item.id), {}).get("effect", "") == effect_id:
			return true
	return false

func _heal_hero(amount: float) -> void:
	if amount <= 0.0:
		return
	var before := hero.hp
	hero.hp = minf(hero.max_hp, hero.hp + amount)
	var excess := maxf(0.0, amount - (hero.hp - before))
	if excess > 0.0 and _has_boon_effect("overheal_shield"):
		barrier = minf(hero.max_hp * 0.25, barrier + excess)

func _update_effect_timers(dt: float) -> void:
	active_cd = maxf(0.0, active_cd - dt)
	active_buff_t = maxf(0.0, active_buff_t - dt)
	time_slow_t = maxf(0.0, time_slow_t - dt)
	projectile_slow_t = maxf(0.0, projectile_slow_t - dt)
	active_guard_t = maxf(0.0, active_guard_t - dt)
	if active_guard_t <= 0.0:
		active_guard = 0
	for key in _effect_cd.keys():
		_effect_cd[key] = maxf(0.0, float(_effect_cd[key]) - dt)
	if _hero_moving and _has_boon_effect("moving_cooldown"):
		active_cd = maxf(0.0, active_cd - dt * 0.35)
		for w in hero.weapons:
			w.timer -= dt * 0.25

func use_active(dir: Vector2 = Vector2.ZERO) -> bool:
	if state != "running" or active_cd > 0.0 or hero.dead:
		return false
	var p := active_def
	var used := true
	var radius := float(p.get("radius", p.get("range", 2.0)))
	match String(p.kind):
		"cleave":
			var hit := p.duplicate(true)
			hit.kind = "melee"
			used = _fire_melee(hit, 1.0 + hero.m("area_pct"))
		"guard":
			active_guard = int(p.get("charges", 1))
			active_guard_t = float(p.get("duration", 4.0))
		"healing_aura":
			_heal_hero(float(p.heal))
			for e in enemies:
				if not e.dead and e.pos.distance_to(hero.pos) <= radius + e.radius:
					_hero_hit(e, p, false)
		"dash_weaken":
			var move_dir := dir.normalized() if dir.length() > 0.01 else Vector2(1, 0)
			var target_pos := hero.pos + move_dir * float(p.distance)
			for i in range(10, 0, -1):
				var candidate := hero.pos.lerp(target_pos, float(i) / 10.0)
				if hero.is_free(candidate):
					hero.pos = candidate
					break
			for e in enemies:
				if not e.dead and e.pos.distance_to(hero.pos) <= radius + e.radius:
					_apply_effects(e, {"weaken": p.weaken})
		"overdrive":
			active_buff_t = float(p.duration)
		"slam":
			used = _fire_nova(p, 1.0 + hero.m("area_pct"))
		"star_burst":
			var n := int(p.count)
			for k in n:
				var ang := TAU * float(k) / float(n)
				projectiles.append({"owner": "hero", "pos": hero.pos, "dir": Vector2(cos(ang), sin(ang)), "speed": float(p.speed),
					"life": float(p.range) / float(p.speed), "pierce": 1, "radius": 0.4, "p": p, "hit": {}})
		"charm":
			var charm_target := nearest(hero.pos, float(p.range))
			if charm_target == null or charm_target.is_boss():
				used = false
			else:
				charm_target.charmed_t = float(p.duration)
				events.append({"type": "text", "pos": charm_target.pos, "text": "dominado"})
		"time_stop":
			time_slow_t = float(p.duration)
		"guard_nova":
			active_guard = int(p.get("charges", 1))
			active_guard_t = 5.0
			used = _fire_nova(p, 1.0 + hero.m("area_pct")) or active_guard > 0
		_:
			used = false
	if not used:
		return false
	active_cd = maxf(3.0, float(p.cooldown) * (1.0 - hero.m("cd_pct") * 0.5))
	if _has_item_effect("projectile_slow_on_active"):
		projectile_slow_t = 4.0
	events.append({"type": "active", "pos": hero.pos, "radius": radius, "dtype": p.get("dtype", "radiante"), "name": p.name, "hero_id": hero.id, "ability_id": p.id})
	events.append({"type": "toast", "text": p.name})
	return true

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
	_update_effect_timers(dt)
	invuln = maxf(0.0, invuln - dt)
	hero.push = Vector2.ZERO
	_hero_moving = screen_dir != Vector2.ZERO
	_stage_rule_step(dt)
	hero.step(screen_dir, dt)
	if hero.m("regen") > 0.0:
		_heal_hero(hero.m("regen") * dt)
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
	if active_buff_t > 0.0:
		f *= 0.6
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
	p["_audio_id"] = w.id
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
	events.append({"type": "swing", "pos": hero.pos, "dir": dir, "range": reach, "cone": float(p.cone), "weapon": p.get("_audio_id", p.get("id", "")), "dtype": p.dtype})
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
	events.append({"type": "cast", "pos": hero.pos, "dir": dir, "weapon": p.get("_audio_id", p.get("id", "")), "dtype": p.dtype})
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
	events.append({"type": "nova", "pos": hero.pos, "radius": r, "dtype": p.dtype, "weapon": p.get("_audio_id", p.get("id", ""))})
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
	events.append({"type": "zone", "pos": at, "radius": r, "dtype": p.dtype, "weapon": p.get("_audio_id", p.get("id", ""))})
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
		if _has_boon_effect("dark_power") and hero.pos.distance_to(map_size * 0.5) > 8.0:
			pct += 0.18
		if _has_item_effect("control_damage") and (e.stun_t > 0.0 or e.slow_t > 0.0 or e.charmed_t > 0.0):
			pct += 0.25
		if shadow_charge:
			pct += 0.5
			shadow_charge = false
		if hero.hp < hero.max_hp * 0.5:
			pct += hero.m("low_hp_dmg")
		dmg *= maxf(0.2, pct) * (1.0 + e.mark) * float(e.resist.get(dtype, 1.0))
		if crit:
			dmg *= 2.0
			stats.crits += 1
			if _has_item_effect("crit_magnet"):
				for pickup in pickups:
					pickup.magnet = true
		dmg = maxf(1.0, round(dmg))
		e.hp -= dmg
		e.hit_flash = 0.12
		events.append({"type": "hit", "pos": e.pos, "amount": int(dmg), "crit": crit})
		if crit and _has_boon_effect("critical_wave"):
			for other in enemies:
				if other != e and not other.dead and other.pos.distance_to(e.pos) <= 2.0:
					var splash := maxf(1.0, round(dmg * 0.25))
					other.hp -= splash
					events.append({"type": "hit", "pos": other.pos, "amount": int(splash), "crit": false})
					if other.hp <= 0.0:
						_kill(other)
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
		var step_dt := dt * (0.3 if pr.owner == "enemy" and projectile_slow_t > 0.0 else 1.0)
		pr.pos += pr.dir * pr.speed * step_dt
		pr.life -= step_dt
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
			if bool(z.get("grows", false)):
				z.radius = minf(2.3, float(z.radius) + dt * 0.05)
			if hero.pos.distance_to(z.pos) <= z.radius:
				z.acc += dt
				if _has_boon_effect("friendly_puddles") or _has_item_effect("puddle_regen"):
					if z.acc >= 1.0:
						z.acc = 0.0
						_heal_hero(1.0 + hero.max_hp * 0.01)
				elif hero.m("puddle_immune") <= 0.0:
					hero.slow_t = 0.3
					if z.acc >= 0.9:
						z.acc = 0.0
						_hurt_hero(2.0 + tier(), "puddle")
			if z.life > 0.0:
				keep.append(z)
		elif z.kind == "rule_ritual":
			if hero.pos.distance_to(z.pos) <= z.radius:
				z.progress += dt
			else:
				z.progress = maxf(0.0, float(z.progress) - dt * 0.5)
			z.delay -= dt
			if z.progress >= z.interrupt:
				events.append({"type": "toast", "text": "Ritual interrompido."})
			elif z.delay <= 0.0:
				if stage.waves.is_empty():
					events.append({"type": "toast", "text": "O ritual se desfaz."})
				else:
					for i in 5:
						var wave: Dictionary = stage.waves[rng.randi() % stage.waves.size()]
						_spawn(String(wave.id), z.pos + Vector2(rng.randf_range(-1.5, 1.5), rng.randf_range(-1.5, 1.5)))
					events.append({"type": "toast", "text": "O ritual trouxe reforços!"})
			else:
				keep.append(z)
		elif z.kind == "sanctuary":
			z.acc += dt
			if hero.pos.distance_to(z.pos) <= z.radius and z.acc >= 1.0:
				z.acc = 0.0
				if bool(z.fake):
					_hurt_hero(2.0 + tier(), "false_sanctuary")
				else:
					_heal_hero(1.5 + hero.max_hp * 0.01)
			if z.life > 0.0:
				keep.append(z)
		else:   # telegraph
			z.delay -= dt
			if z.delay <= 0.0:
				events.append({"type": "boom", "pos": z.pos, "radius": z.radius})
				if hero.pos.distance_to(z.pos) <= z.radius + HERO_HIT_R:
					_hurt_hero(float(Dice.roll(rng, z.dice) + int(z.bonus / 2)), "aoe")
				if z.kind == "bubble":
					var away: Vector2 = (hero.pos - Vector2(z.pos)).normalized()
					hero.push += away * 4.0
				if bool(z.get("friendly", false)) or z.kind == "bubble":
					for e in enemies:
						if not e.dead and e.pos.distance_to(z.pos) <= z.radius + e.radius:
							var env_damage := float(Dice.roll(rng, z.dice) + int(z.bonus / 2))
							e.hp -= env_damage
							events.append({"type": "hit", "pos": e.pos, "amount": int(env_damage), "crit": false})
							if z.kind == "bubble" and not e.is_boss():
								e.pos += (e.pos - z.pos).normalized() * 1.2
							if e.hp <= 0.0:
								_kill(e)
			else:
				keep.append(z)
	zones = keep

func tier() -> int:
	return int(stage.get("tier", 0))

# ------------------------------------------------------------------ inimigos

func _charmed_step(e: Enemy, dt: float) -> void:
	e.charmed_t = maxf(0.0, e.charmed_t - dt)
	e.atk_cd = maxf(0.0, e.atk_cd - dt)
	var target: Enemy = null
	var best := 8.0
	for other in enemies:
		if other == e or other.dead or other.charmed_t > 0.0:
			continue
		var dist := e.pos.distance_to(other.pos)
		if dist < best:
			best = dist
			target = other
	if target == null:
		return
	if best > e.radius + target.radius + 0.7:
		var np := e.pos + (target.pos - e.pos).normalized() * e.speed * dt
		if hero.is_free(np, e.radius):
			e.pos = np
	elif e.atk_cd <= 0.0:
		e.atk_cd = ENEMY_ATK_CD
		var dmg := float(Dice.roll(rng, e.atk_dice) + maxi(0, e.atk_bonus))
		target.hp -= dmg
		events.append({"type": "hit", "pos": target.pos, "amount": int(dmg), "crit": false})
		if target.hp <= 0.0:
			_kill(target)

func _check_boss_phase(e: Enemy) -> void:
	if not e.is_boss() or e.phase_index >= e.phase_defs.size() or e.max_hp <= 0.0:
		return
	while e.phase_index < e.phase_defs.size():
		var phase: Dictionary = e.phase_defs[e.phase_index]
		if e.hp / e.max_hp > float(phase.at_hp):
			break
		e.phase_index += 1
		events.append({"type": "boss_phase", "pos": e.pos, "text": String(phase.announcement)})
		for action in phase.actions:
			_apply_boss_phase_action(e, action)

func _apply_boss_phase_action(e: Enemy, action: Dictionary) -> void:
	match String(action.t):
		"summon":
			for i in int(action.n):
				_spawn(String(action.id), e.pos + Vector2(rng.randf_range(-2.5, 2.5), rng.randf_range(-2.5, 2.5)))
		"ring":
			var n := int(action.n)
			var off := rng.randf() * TAU
			for k in n:
				var ang := off + TAU * float(k) / float(n)
				projectiles.append({"owner": "enemy", "pos": e.pos, "dir": Vector2(cos(ang), sin(ang)), "speed": float(action.speed), "life": 5.0,
					"radius": 0.25, "dice": action.dice, "bonus": e.atk_bonus, "dtype": "magico", "pierce": 0, "hit": {}, "p": {}})
		"hazard":
			for i in int(action.n):
				var at := hero.pos + Vector2(rng.randf_range(-5.0, 5.0), rng.randf_range(-5.0, 5.0))
				zones.append({"owner": "enemy", "kind": "puddle", "pos": at, "radius": float(action.radius), "delay": 0.0, "life": 9.0, "acc": 0.0})
		"strikes":
			for i in int(action.n):
				var at := hero.pos + Vector2(rng.randf_range(-4.0, 4.0), rng.randf_range(-4.0, 4.0))
				zones.append({"owner": "enemy", "kind": "telegraph", "pos": at, "radius": 1.4, "delay": 1.2, "total": 1.2, "life": 99.0,
					"dice": "2d6", "bonus": e.atk_bonus, "dtype": "magico", "friendly": false})
		"enrage":
			e.speed *= float(action.get("speed", 1.0))
			e.atk_bonus += int(action.get("bonus", 0))
			for i in e.ab_cd.size():
				e.ab_cd[i] *= 0.7

func _enemy_step(e: Enemy, dt: float) -> void:
	_check_boss_phase(e)
	if e.charmed_t > 0.0:
		_charmed_step(e, dt)
		return
	if time_slow_t > 0.0:
		dt *= 0.15
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
			events.append({"type": "enemy_action", "enemy_id": e.id, "pos": e.pos, "ability": "shoot"})
			return true
		"aoe":
			if dist > float(a.range):
				return false
			var lead := hero.pos
			zones.append({"owner": "enemy", "kind": "telegraph", "pos": lead, "radius": float(a.radius), "delay": float(a.delay), "life": 99.0,
				"dice": a.dice, "bonus": e.atk_bonus, "dtype": a.dtype})
			events.append({"type": "telegraph", "pos": lead, "radius": float(a.radius), "delay": float(a.delay), "enemy_id": e.id})
			return true
		"charge":
			if dist < 2.5 or dist > float(a.dist) + 3.0:
				return false
			e.windup = float(a.windup)
			e.charge_dir = to.normalized()
			e.charge_ab = a
			events.append({"type": "windup", "pos": e.pos, "dir": e.charge_dir, "len": float(a.dist), "enemy_id": e.id})
			return true
		"summon":
			if alive(String(a.id)) >= int(a.cap):
				return false
			for i in int(a.n):
				var at := e.pos + Vector2(rng.randf_range(-1.5, 1.5), rng.randf_range(-1.5, 1.5))
				_spawn(String(a.id), at)
			events.append({"type": "text", "pos": e.pos, "text": "invoca", "enemy_id": e.id})
			events.append({"type": "enemy_action", "enemy_id": e.id, "pos": e.pos, "ability": "summon"})
			return true
		"puddle":
			zones.append({"owner": "enemy", "kind": "puddle", "pos": e.pos, "radius": float(a.radius), "delay": 0.0, "life": float(a.life), "acc": 0.0})
			events.append({"type": "enemy_action", "enemy_id": e.id, "pos": e.pos, "ability": "puddle"})
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
			events.append({"type": "enemy_action", "enemy_id": e.id, "pos": e.pos, "ability": "ring"})
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
		if _has_boon_effect("shadow_dodge"):
			invuln = maxf(invuln, 0.45)
		if _has_item_effect("dodge_empower"):
			shadow_charge = true
		return
	var dmg := float(Dice.roll(rng, dice)) * (2.0 if r == 20 else 1.0)
	_hurt_hero(dmg, "hit")

func _hurt_hero(dmg: float, src: String) -> void:
	if hero.dead or invuln > 0.0:
		return
	if active_guard > 0:
		active_guard -= 1
		if active_guard <= 0:
			active_guard_t = 0.0
		events.append({"type": "text", "pos": hero.pos, "text": "GUARDA"})
		if String(active_def.kind) == "guard":
			for e in enemies:
				if not e.dead and e.pos.distance_to(hero.pos) <= 2.6:
					_hero_hit(e, {"dice": "2d8", "attr": "carisma", "dtype": "radiante", "knock": 1.0}, false)
		return
	dmg = maxf(1.0, dmg * difficulty - hero.m("dr"))
	if barrier > 0.0:
		var absorbed := minf(barrier, dmg)
		barrier -= absorbed
		dmg -= absorbed
		if dmg <= 0.0:
			events.append({"type": "text", "pos": hero.pos, "text": "BARREIRA"})
			return
	hero.hp -= dmg
	hero.hit_flash = 0.15
	invuln = maxf(invuln, HIT_INVULN)
	stats.damage_taken += dmg
	events.append({"type": "hurt", "pos": hero.pos, "amount": int(dmg)})
	if _has_boon_effect("pain_retaliation"):
		for e in enemies:
			if not e.dead and e.pos.distance_to(hero.pos) <= 2.2:
				var retaliation := maxf(1.0, round(dmg * 0.5))
				e.hp -= retaliation
				events.append({"type": "hit", "pos": e.pos, "amount": int(retaliation), "crit": false})
				if e.hp <= 0.0:
					_kill(e)
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
	if e.burn_t > 0.0 and _has_item_effect("burn_spread") and float(_effect_cd.get("burn_spread", 0.0)) <= 0.0:
		_effect_cd.burn_spread = 0.5
		for other in enemies:
			if other != e and not other.dead and other.pos.distance_to(e.pos) <= 2.4:
				other.burn_t = maxf(other.burn_t, 3.0)
				other.burn_dps = maxf(other.burn_dps, 4.0)
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
	events.append({"type": "pickup", "kind": kind, "pos": hero.pos})
	match kind:
		"xp": _add_xp(value * (1.0 + hero.m("xp_pct")))
		"gold": _add_gold(value)
		"potion":
			_heal_hero(hero.max_hp * value)
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
			events.append({"type": "interaction", "kind": it.kind, "pos": it.pos})
			if it.kind == "chest":
				_open_chest(it)
			else:
				var heal_pct := 0.4 * maxf(0.35, 1.0 - float(descent_depth) * 0.15)
				if _has_boon_effect("weak_fountains"):
					heal_pct *= 0.5
				_heal_hero(hero.max_hp * heal_pct)
				events.append({"type": "heal", "pos": hero.pos, "amount": int(hero.max_hp * heal_pct)})
				events.append({"type": "toast", "text": "Fonte: +%d%% PV" % int(round(heal_pct * 100.0))})
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
	events.append({"type": "interaction", "kind": best.kind, "pos": best.pos})
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
	var luck := hero.m("carisma") + hero.attr_mod("carisma")
	if _has_boon_effect("lucky_chests"):
		luck += 4.0
	give_item(Items.roll(rng, tier(), luck))

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
		offer.append({"t": "boon", "id": b.id, "name": "%s: %s" % [b.god, b.name], "desc": "%s\n%s" % [b.desc, _boon_effect_desc(String(b.id))], "boon": b})
	if offer.is_empty():
		return
	offer_kind = "altar"
	state = "altar"

func _boon_effect_desc(id: String) -> String:
	var effect := String(Data.table("boon_effects").get(id, {}).get("effect", ""))
	var descriptions := {
		"overheal_shield": "Excesso de cura vira barreira.", "stage_heal": "Recupera 15% de PV ao descer.",
		"shadow_dodge": "Esquivar concede breve invulnerabilidade.", "lucky_chests": "Baús têm itens melhores.",
		"moving_cooldown": "Mover-se acelera recargas.", "critical_wave": "Críticos atingem inimigos próximos.",
		"dark_power": "Longe do centro, causa mais dano.", "weak_fountains": "Fontes curam apenas metade.",
		"friendly_puddles": "Poças passam a curar lentamente.", "pain_retaliation": "Receber dano fere inimigos próximos.",
		"friendly_strikes": "Raios também ferem inimigos.", "level_insight": "A cada 5 níveis, ganha uma opção extra."
	}
	return String(descriptions.get(effect, ""))

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
	descent_depth += 1
	var recovery := 0.4 * maxf(0.35, 1.0 - float(descent_depth) * 0.15)
	_heal_hero(hero.max_hp * recovery)
	load_stage(nxt)
	events.append({"type": "toast", "text": "Você desce: %s — recompensa ×%.2f" % [Data.table("stages")[nxt].name, reward_multiplier()]})

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
	if _has_boon_effect("level_insight") and hero.level % 5 == 0:
		n += 1
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
			pool.append({"t": "evolve", "id": w.id, "into": w.def.evolve.into, "name": "EVOLUÇÃO: %s" % evo.name, "desc": evo.desc, "weight": 9.0, "role": "synergy"})
		elif w.level < w.max_level():
			pool.append({"t": "weapon_up", "id": w.id, "name": "%s → Nv %d" % [w.def.name, w.level + 1], "desc": _level_desc(w), "weight": 3.0, "role": "synergy"})
	if owned_w < hero.weapon_slots():
		for wid in wdata:
			var d: Dictionary = wdata[wid]
			if String(d.src).begins_with("Evolu") or String(d.src).begins_with("Item"):
				continue
			if hero.weapons.any(func(w): return w.id == wid):
				continue
			pool.append({"t": "weapon_new", "id": wid, "name": "NOVA: %s" % d.name, "desc": d.desc, "weight": 2.0, "role": _weapon_offer_role(d)})
	var owned_p := hero.passives.size()
	for pid in pdata:
		var lv := int(hero.passives.get(pid, 0))
		if lv >= 5:
			continue
		if lv > 0:
			pool.append({"t": "passive", "id": pid, "name": "%s → Nv %d" % [pdata[pid].name, lv + 1], "desc": pdata[pid].desc, "weight": 3.0, "role": "synergy"})
		elif owned_p < 5:
			pool.append({"t": "passive", "id": pid, "name": "NOVA: %s" % pdata[pid].name, "desc": pdata[pid].desc, "weight": 2.0, "role": _passive_offer_role(pdata[pid])})
	var out: Array = []
	for role in ["synergy", "defense", "direction"]:
		var candidates := pool.filter(func(c): return String(c.role) == role)
		if not candidates.is_empty() and out.size() < n:
			var picked: Dictionary = _weighted_pick(candidates)
			out.append(picked)
			pool.erase(picked)
	while out.size() < n and not pool.is_empty():
		var picked: Dictionary = _weighted_pick(pool)
		out.append(picked)
		pool.erase(picked)
	if out.size() < n:
		out.append({"t": "heal", "id": "heal", "name": "Provisões", "desc": "Recupera 40% dos PV.", "weight": 1.0})
	if out.size() < n:
		out.append({"t": "gold", "id": "gold", "name": "Bolsa de Moedas", "desc": "+40 moedas.", "weight": 1.0})
	return out

func _weighted_pick(candidates: Array) -> Dictionary:
	var total := 0.0
	for c in candidates:
		total += float(c.weight)
	var roll := rng.randf() * total
	for c in candidates:
		roll -= float(c.weight)
		if roll <= 0.0:
			return c
	return candidates.back()

func _weapon_offer_role(d: Dictionary) -> String:
	if d.has("heal") or d.has("stun") or d.has("slow"):
		return "defense"
	for owned in hero.weapons:
		if String(owned.def.get("attr", "")) == String(d.get("attr", "")) or String(owned.def.get("dtype", "")) == String(d.get("dtype", "")):
			return "synergy"
	return "direction"

func _passive_offer_role(d: Dictionary) -> String:
	var defensive := ["hp", "regen", "ca", "cam", "dr", "dodge"]
	for key in d.mods:
		if key in defensive:
			return "defense"
	for owned in hero.weapons:
		if String(owned.def.get("attr", "")) in d.mods:
			return "synergy"
	return "direction"

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
	if _stage_has_rule("illusions") and not e.is_boss() and not e.has_flag("elite_only") and rng.randf() < float(stage_rule.get("chance", 0.12)) and e.xp > 0:
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
			if _acc[wi] >= float(w.every) * SPAWN_SLOW:
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
	if descent_depth > 0 and not stage.elites.is_empty():
		var pressure_mark := int(time / maxf(70.0, 130.0 - float(descent_depth) * 10.0))
		var pressure_key := "pressure_%d" % pressure_mark
		if pressure_mark > 0 and not _elites_done.has(pressure_key):
			_elites_done[pressure_key] = true
			var pressure_elite: Dictionary = stage.elites[rng.randi() % stage.elites.size()]
			_spawn_elite(String(pressure_elite.id), _ring_pos())
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

func _stage_has_rule(kind: String) -> bool:
	var configured := String(stage_rule.get("kind", ""))
	if configured == kind:
		return true
	if configured == "rotation":
		var rules: Array = stage_rule.get("rules", [])
		if rules.is_empty():
			return false
		var idx := int(time / float(stage_rule.get("interval", 60.0))) % rules.size()
		return String(rules[idx]) == kind
	return false

func _stage_rule_step(dt: float) -> void:
	if stage_rule.is_empty():
		return
	var kind := String(stage_rule.kind)
	if kind == "rotation":
		var rules: Array = stage_rule.rules
		var idx := int(time / float(stage_rule.interval)) % rules.size()
		if idx != _rule_index:
			_rule_index = idx
			events.append({"type": "toast", "text": "Os Pilares despertam: %s" % String(rules[idx])})
		kind = String(rules[idx])
	_apply_rule_kind(kind, dt)

func _apply_rule_kind(kind: String, dt: float) -> void:
	match kind:
		"puddles":
			_amb_puddle -= dt
			if _amb_puddle <= 0.0:
				_amb_puddle = float(stage_rule.get("interval", 8.0)) + rng.randf() * 3.0
				var ang := rng.randf() * TAU
				zones.append({"owner": "enemy", "kind": "puddle", "pos": hero.pos + Vector2(cos(ang), sin(ang)) * rng.randf_range(2.5, 6.0),
					"radius": 1.0, "grows": true, "delay": 0.0, "life": 11.0, "acc": 0.0})
		"current":
			_cur_angle += 0.12 * dt
			var current := Vector2(cos(_cur_angle), sin(_cur_angle)) * float(stage_rule.get("force", 0.9))
			hero.push += current
			for pickup in pickups:
				pickup.pos = (pickup.pos + current * dt * 0.5).clamp(Vector2.ZERO, map_size)
			for e in enemies:
				if not e.dead and not e.is_boss():
					e.pos = (e.pos + current * dt * 0.25).clamp(Vector2(0.5, 0.5), map_size - Vector2(0.5, 0.5))
		"strikes":
			_amb_strike -= dt
			if _amb_strike <= 0.0:
				_amb_strike = float(stage_rule.get("interval", 4.5)) + rng.randf_range(-1.0, 1.0)
				var at := hero.pos + Vector2(rng.randf_range(-3, 3), rng.randf_range(-3, 3))
				zones.append({"owner": "stage", "kind": "telegraph", "pos": at, "radius": 1.5, "delay": 1.3, "total": 1.3, "life": 99.0,
					"dice": "2d6", "bonus": 4 + tier(), "dtype": "magico", "friendly": bool(stage_rule.get("friendly", false)) or _has_boon_effect("friendly_strikes")})
		"rituals":
			_rule_timer -= dt
			if _rule_timer <= 0.0:
				_rule_timer = float(stage_rule.interval)
				var at := _ring_pos()
				zones.append({"owner": "stage", "kind": "rule_ritual", "pos": at, "radius": 1.7, "delay": float(stage_rule.delay), "total": float(stage_rule.delay),
					"interrupt": float(stage_rule.interrupt), "progress": 0.0, "life": 99.0})
				events.append({"type": "toast", "text": "Ritual da Névoa: permaneça no selo para interromper!"})
		"bubbles":
			_rule_timer -= dt
			if _rule_timer <= 0.0:
				_rule_timer = float(stage_rule.interval)
				var at := hero.pos + Vector2(rng.randf_range(-4.0, 4.0), rng.randf_range(-4.0, 4.0))
				zones.append({"owner": "stage", "kind": "bubble", "pos": at, "radius": float(stage_rule.radius), "delay": float(stage_rule.delay),
					"total": float(stage_rule.delay), "life": 99.0, "dice": "2d6", "bonus": 3 + tier(), "dtype": "magico"})
		"sanctuary":
			_rule_timer -= dt
			if _rule_timer <= 0.0:
				_rule_timer = float(stage_rule.interval)
				var fake := rng.randf() < float(stage_rule.fake_chance)
				zones.append({"owner": "stage", "kind": "sanctuary", "pos": _ring_pos(), "radius": 2.2, "life": float(stage_rule.duration), "acc": 0.0, "fake": fake})
				events.append({"type": "toast", "text": "Um santuário surge no falso paraíso."})

# ------------------------------------------------------------------ resultado

func result() -> Dictionary:
	return {"won": state == "won", "dead": state == "dead", "extracted": extracted, "time": run_time, "kills": stats.kills,
		"gold": int(round(stats.gold * reward_multiplier())), "raw_gold": int(stats.gold), "reward_mult": reward_multiplier(), "descent_depth": descent_depth,
		"level": hero.level, "stage": stage_id, "hero": hero.id, "bosses": stats.bosses, "boss_ids": stats.boss_ids, "elites": stats.elites, "crits": stats.crits,
		"ones": stats.ones, "chests": stats.chests, "stages_cleared": stats.stages_cleared, "stage_ids": stats.stage_ids, "cleared_ids": stats.cleared_ids, "final_victory": final_victory, "weapons": hero.weapons.map(func(w): return w.id), "codex": codex}
