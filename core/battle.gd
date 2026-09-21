class_name Battle
extends RefCounted
## Simulação de combate pura (sem nós). `events` é consumido pela UI.

enum Aim { AUTO, MOUSE }

const ENEMY_ATK_RANGE := 0.9
const ENEMY_ATK_CD := 1.0
const MOUSE_CONE_COS := 0.5   # meio-ângulo 60°

var hero: Hero
var enemies: Array = []
var rng := RandomNumberGenerator.new()
var aim := Aim.AUTO
var aim_dir := Vector2(1, 1).normalized()   # direção no plano de chão (modo MOUSE)
var time := 0.0
var events: Array = []   # {type, pos, ...}

func _init(seed_value: int = 1, hero_id: String = "durvall") -> void:
	rng.seed = seed_value
	hero = Hero.make(hero_id)

func toggle_aim() -> void:
	aim = Aim.MOUSE if aim == Aim.AUTO else Aim.AUTO

func spawn(enemy_id: String, at: Vector2) -> Enemy:
	var e := Enemy.make(enemy_id, at)
	enemies.append(e)
	return e

func step(screen_dir: Vector2, dt: float) -> void:
	if hero.dead:
		return
	time += dt
	hero.step(screen_dir, dt)
	hero.atk_timer = maxf(0.0, hero.atk_timer - dt)
	hero.skill_timer = maxf(0.0, hero.skill_timer - dt)
	if hero.atk_timer <= 0.0:
		_auto_attack()
	for e in enemies:
		_enemy_step(e, dt)
	enemies = enemies.filter(func(x): return not x.dead)

func nearest(max_range: float) -> Enemy:
	var best: Enemy = null
	var bd := max_range
	for e in enemies:
		var d: float = e.pos.distance_to(hero.pos) - e.radius
		if not e.dead and d <= bd:
			bd = d
			best = e
	return best

func _auto_attack() -> void:
	var targets: Array = []
	if aim == Aim.AUTO:
		var t := nearest(hero.attack_range)
		if t != null:
			targets.append(t)
	else:
		for e in enemies:
			var off: Vector2 = e.pos - hero.pos
			if not e.dead and off.length() - e.radius <= hero.attack_range \
					and (off.length() < 0.05 or off.normalized().dot(aim_dir) >= MOUSE_CONE_COS):
				targets.append(e)
	if targets.is_empty():
		return
	hero.atk_timer = hero.attack_cd
	var dir: Vector2 = aim_dir if aim == Aim.MOUSE else (targets[0].pos - hero.pos).normalized()
	events.append({"type": "swing", "pos": hero.pos, "dir": dir})
	for t in targets:
		_hero_hit(t, hero.weapon_dice)

## Romper Armadura: 1d6 + FOR, CA do alvo -2. Retorna true se usada.
func use_skill() -> bool:
	if hero.dead or hero.skill_timer > 0.0:
		return false
	var t := nearest(hero.skill_range)
	if t == null:
		return false
	hero.skill_timer = hero.skill_cd
	events.append({"type": "swing", "pos": hero.pos, "dir": (t.pos - hero.pos).normalized()})
	if _hero_hit(t, "1d6") and not t.dead:
		t.ca -= 2
		events.append({"type": "text", "pos": t.pos, "text": "CA -2"})
	return true

func _hero_hit(t: Enemy, dice: String) -> bool:
	var r := Dice.d20(rng)
	var hit := r == 20 or (r != 1 and r + hero.hit_bonus() >= t.ca)
	if not hit:
		events.append({"type": "dmg", "pos": t.pos, "amount": 0, "crit": false, "hit": false})
		return false
	var dmg := Dice.roll(rng, dice) + hero.dmg_bonus()
	if r == 20:
		dmg *= 2
	dmg = maxi(1, dmg)
	t.hp -= dmg
	events.append({"type": "dmg", "pos": t.pos, "amount": dmg, "crit": r == 20, "hit": true})
	if t.hp <= 0 and not t.dead:
		t.dead = true
		hero.xp += t.xp
		events.append({"type": "kill", "pos": t.pos, "enemy": t})
	return true

func _enemy_step(e: Enemy, dt: float) -> void:
	e.atk_cd = maxf(0.0, e.atk_cd - dt)
	var to := hero.pos - e.pos
	var dist := to.length()
	if dist > ENEMY_ATK_RANGE * 0.6 and dist > 0.001:
		var move := to.normalized() * e.speed * dt
		var nx := Vector2(e.pos.x + move.x, e.pos.y)
		if hero.is_free(nx, e.radius):
			e.pos = nx
		var ny := Vector2(e.pos.x, e.pos.y + move.y)
		if hero.is_free(ny, e.radius):
			e.pos = ny
	for o in enemies:
		if o != e:
			var off: Vector2 = e.pos - o.pos
			var min_d: float = e.radius + o.radius
			if off.length() < min_d and off.length() > 0.001:
				e.pos += off.normalized() * (min_d - off.length()) * 0.5
	if dist <= ENEMY_ATK_RANGE and e.atk_cd <= 0.0:
		e.atk_cd = ENEMY_ATK_CD
		var r := Dice.d20(rng)
		if r == 20 or (r != 1 and r + e.atk_bonus >= hero.ca):
			var dmg := Dice.roll(rng, e.atk_dice)
			if r == 20:
				dmg *= 2
			hero.hp -= dmg
			events.append({"type": "hurt", "pos": hero.pos, "amount": dmg})
			if hero.hp <= 0:
				hero.hp = 0
				hero.dead = true
				events.append({"type": "dead", "pos": hero.pos})
		else:
			events.append({"type": "text", "pos": hero.pos, "text": "erra"})
