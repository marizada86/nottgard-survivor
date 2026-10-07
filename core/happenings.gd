class_name Happenings
extends RefCounted
## SPEC-118: acontecimentos exclusivos por fase. Objetivos opcionais com recompensa e consequência,
## aliados e NPCs, itens carregados, pactos. A Battle chama `fire`, `step`, `post_hero_step`, `on_kill`
## e `on_goal_reached`; a UI lê `objectives`, `allies` e `markers()`.
## Sem referência guardada à Battle (evita ciclo de RefCounted): ela vem sempre como parâmetro.

const KINDS := ["collect", "escort", "intercept", "invasion", "rescue", "pact", "arena", "map_shift", "pilgrimage", "quake"]
## Tipos de interação criados aqui; os de toque são resolvidos em `step`, `event_pact` pelo E da Battle.
const TOUCH_KINDS := ["event_item", "event_target", "event_npc", "event_star"]
const TOUCH_RADIUS := 0.9
const HINT_COOLDOWN := 6.0

var objectives: Array = []   # {id, kind, title, text, ends_at, def, need, got, done, failed, at}
var allies: Array = []       # {id, label, sprite, pos, hp, max_hp, life, dice, speed, aggro, goal, role, obj, atk_cd}
var carrying: Array = []     # [{obj, label}] itens que o herói carrega
var flags := {}
var boss_hp_bonus := 0.0
var enemy_speed_mult := 1.0
var arena: Dictionary = {}   # {obj, pos, radius}
var _serial := 0
var _hint_cd := 0.0

func reset() -> void:
	objectives.clear()
	allies.clear()
	carrying.clear()
	flags.clear()
	boss_hp_bonus = 0.0
	enemy_speed_mult = 1.0
	arena = {}
	_hint_cd = 0.0

## Escolhe os acontecimentos da fase: os fixos sempre; dos `"pool": "optional"`, sorteia 1 ou 2.
## Horário com variação (`jitter`). RNG própria (semente da run + fase) para não deslocar a da batalha.
static func select(stage_key: String, defs: Array, seed_value: int) -> Array:
	var r := RandomNumberGenerator.new()
	r.seed = hash("%d:%s" % [seed_value, stage_key])
	var fixed: Array = []
	var optional: Array = []
	for d in defs:
		var def: Dictionary = d.duplicate(true)
		var jitter := float(def.get("jitter", 0.0))
		if jitter > 0.0:
			def.at = float(def.at) * (1.0 + r.randf_range(-jitter, jitter))
		if String(def.get("pool", "fixed")) == "optional":
			optional.append(def)
		else:
			fixed.append(def)
	var hcfg: Dictionary = Data.table("difficulty").get("happenings", {})
	var lo := int(hcfg.get("optional_min", 1))
	var hi := maxi(lo, int(hcfg.get("optional_max", 2)))
	var picks := mini(optional.size(), lo + r.randi() % (hi - lo + 1))
	for i in picks:
		fixed.append(optional.pop_at(r.randi() % optional.size()))
	fixed.sort_custom(func(a, b): return float(a.at) < float(b.at))
	return fixed

# ------------------------------------------------------------------ disparo

func fire(b: Battle, def: Dictionary) -> bool:
	var kind := String(def.get("kind", ""))
	if not (kind in KINDS):
		return false
	var obj := _new_objective(b, def)
	match kind:
		"collect":
			_fire_collect(b, def, obj)
		"escort":
			_fire_escort(b, def, obj)
		"intercept":
			_fire_intercept(b, def, obj)
		"invasion":
			var e := b._spawn_elite(String(def.enemy_id), b._ring_pos())
			e.drops_chest = true
			e.event_tag = String(obj.id)
			obj.need = 1
			obj.pos = e.pos
		"rescue":
			var n := int(def.get("n", 3))
			obj.need = n
			for i in n:
				_add_point(b, "event_npc", _far_pos(b, 6.0, 12.0), obj, String(def.get("label", "sobrevivente")), _col(def, Color(0.95, 0.9, 0.6)))
		"pact":
			obj.need = 0
			var at := _far_pos(b, 4.0, 7.0)
			_add_point(b, "event_pact", at, obj, "%s [E/oeste]" % String(def.get("label", "pacto")), _col(def, Color(0.95, 0.6, 0.85)), String(def.get("asset", "")))
			obj.pos = at
		"arena":
			arena = {"obj": String(obj.id), "pos": b.hero.pos, "radius": float(def.get("radius", 3.5))}
			var e := b._spawn_elite(String(def.enemy_id), b.hero.pos + Vector2(2.0, 0.0))
			e.event_tag = String(obj.id)
			obj.need = 1
			obj.pos = b.hero.pos
		"map_shift":
			b.stage_rule = Dictionary(def.get("rule", b.stage_rule)).duplicate(true)
			b._rule_timer = 2.0
			var mult := float(def.get("enemy_speed", 1.0))
			enemy_speed_mult *= mult
			for e in b.enemies:
				if not e.is_boss():
					e.speed *= mult
			obj.done = true
		"pilgrimage":
			var curse: Dictionary = def.get("curse", {})
			b.hero.temp_mods = Dictionary(curse.get("mods", {})).duplicate()
			b.hero.temp_t = float(curse.get("duration", 120.0))
			b.hero.recalc()
			obj.ends_at = b.time + b.hero.temp_t
			var dir := Vector2(-1.0, -1.0).normalized()   # norte na tela
			var at := (b.hero.pos + dir * float(def.get("distance", 12.0))).clamp(Vector2(2, 2), b.map_size - Vector2(2, 2))
			_add_point(b, "event_star", at, obj, String(def.get("label", "a estrela")), _col(def, Color(0.75, 0.9, 1.0)))
			obj.pos = at
			obj.need = 1
		"quake":
			for i in int(def.get("n", 5)):
				var at := b.hero.pos + Vector2(b.rng.randf_range(-4.0, 4.0), b.rng.randf_range(-4.0, 4.0))
				b.zones.append({"owner": "stage", "kind": "telegraph", "pos": at, "radius": float(def.get("radius", 1.6)), "delay": float(def.get("delay", 1.4)),
					"total": float(def.get("delay", 1.4)), "life": 99.0, "dice": String(def.get("dice", "2d8")), "bonus": 4 + b.tier(), "dtype": "fisico", "friendly": true})
			obj.done = true
	if bool(obj.done):
		objectives.erase(obj)
	return true

func _new_objective(b: Battle, def: Dictionary) -> Dictionary:
	_serial += 1
	var deadline := float(def.get("deadline", 0.0))
	var obj := {"id": "%s#%d" % [String(def.get("id", "evento")), _serial], "kind": String(def.kind), "title": String(def.get("title", "")),
		"text": String(def.get("objective_text", "")), "ends_at": (b.time + deadline) if deadline > 0.0 else -1.0, "def": def,
		"need": 0, "got": 0, "done": false, "failed": false, "pos": b.hero.pos}
	objectives.append(obj)
	return obj

func _fire_collect(b: Battle, def: Dictionary, obj: Dictionary) -> void:
	var items: Array = def.get("items", [])
	obj.need = items.size()
	for item in items:
		var src := String(item.get("source", ""))
		if src.begins_with("elite:"):
			var e := b._spawn_elite(src.substr(6), b._ring_pos())
			e.event_tag = String(obj.id)
			e.event_item = String(item.label)
		else:
			_add_point(b, "event_item", _far_pos(b, 7.0, 11.0), obj, String(item.label), _col(item, Color(0.7, 0.95, 0.6)))
	var target: Dictionary = def.get("target", {})
	var tpos := _far_pos(b, 6.0, 10.0)
	if target.has("pos"):
		tpos = Vector2(float(target.pos[0]), float(target.pos[1])) * (b.map_size.x / 60.0)
	_add_point(b, "event_target", tpos, obj, String(target.get("label", "destino")), _col(target, Color(0.95, 0.75, 0.4)), String(target.get("asset", "")))
	obj.pos = tpos

func _fire_escort(b: Battle, def: Dictionary, obj: Dictionary) -> void:
	var npc: Dictionary = def.get("npc", {})
	var dir := (b.map_size * 0.5 - b.hero.pos)
	dir = dir.normalized() if dir.length() > 2.0 else Vector2(1, 0).rotated(b.rng.randf() * TAU)
	var goal := (b.hero.pos + dir * float(def.get("distance", 14.0))).clamp(Vector2(3, 3), b.map_size - Vector2(3, 3))
	_add_ally(b, {"label": String(npc.get("label", "peregrino")), "sprite": String(npc.get("sprite", "")), "pos": b.hero.pos + Vector2(1.0, 0.5),
		"hp": float(npc.get("hp", 60.0)), "speed": float(npc.get("speed", 1.0)), "aggro": 5.0, "goal": goal, "role": "escort", "obj": String(obj.id), "life": 9999.0})
	_add_point(b, "event_target", goal, obj, String(def.get("target_label", "destino")), _col(def, Color(0.75, 0.9, 1.0)), String(def.get("asset", "")), true)
	obj.need = 1
	obj.pos = goal

func _fire_intercept(b: Battle, def: Dictionary, obj: Dictionary) -> void:
	var mass := _far_pos(b, 7.0, 10.0)
	_add_point(b, "event_target", mass, obj, String(def.get("target_label", "destino")), _col(def, Color(0.85, 0.4, 0.4)), String(def.get("asset", "")), true)
	var n := int(def.get("n", 5))
	obj.need = n
	obj.arrived = 0
	obj.pos = mass
	for i in n:
		var ang := TAU * float(i) / float(n) + b.rng.randf() * 0.4
		var at := (mass + Vector2(cos(ang), sin(ang)) * b.rng.randf_range(9.0, 12.0)).clamp(Vector2(1, 1), b.map_size - Vector2(1, 1))
		var e := b._spawn(String(def.enemy_id), at)
		e.goal = mass
		e.event_tag = String(obj.id)

# ------------------------------------------------------------------ passo

func step(b: Battle, dt: float) -> void:
	_hint_cd = maxf(0.0, _hint_cd - dt)
	_touch_points(b)
	_update_allies(b, dt)
	for obj in objectives.duplicate():
		if bool(obj.done) or bool(obj.failed):
			continue
		if float(obj.ends_at) > 0.0 and b.time >= float(obj.ends_at):
			_timeout(b, obj)
	objectives = objectives.filter(func(o): return not (bool(o.done) or bool(o.failed)))

## Arena: depois que o herói andou, ele não sai do círculo enquanto o duelo durar.
func post_hero_step(b: Battle) -> void:
	if arena.is_empty():
		return
	var c: Vector2 = arena.pos
	var r := float(arena.radius)
	var off := b.hero.pos - c
	if off.length() > r:
		b.hero.pos = c + off.normalized() * r

func _touch_points(b: Battle) -> void:
	for it in b.interactions:
		if it.used or not (String(it.kind) in TOUCH_KINDS) or bool(it.get("passive", false)):
			continue
		if it.pos.distance_to(b.hero.pos) > TOUCH_RADIUS:
			continue
		var obj := _objective(String(it.get("obj", "")))
		if obj.is_empty():
			it.used = true
			continue
		match String(it.kind):
			"event_item":
				it.used = true
				carrying.append({"obj": obj.id, "label": String(it.label)})
				b.events.append({"type": "toast", "text": "Você carrega: %s" % String(it.label), "color": Color(0.7, 0.95, 0.6)})
			"event_target":
				var have := carrying.filter(func(c): return c.obj == obj.id)
				if have.size() + int(obj.got) >= int(obj.need) and not have.is_empty():
					carrying = carrying.filter(func(c): return c.obj != obj.id)
					obj.got = int(obj.need)
					it.used = true
					_complete(b, obj, it.pos)
				elif _hint_cd <= 0.0:
					_hint_cd = HINT_COOLDOWN
					var hint := String(Dictionary(obj.def).get("hint_text", ""))
					if hint != "":
						b.events.append({"type": "toast", "text": hint, "color": Color(0.85, 0.75, 0.95)})
			"event_npc":
				it.used = true
				obj.got = int(obj.got) + 1
				b.events.append({"type": "toast", "text": "%s a salvo (%d/%d)" % [String(it.label).capitalize(), int(obj.got), int(obj.need)], "color": Color(0.95, 0.9, 0.6)})
				if int(obj.got) >= int(obj.need):
					_complete(b, obj, it.pos)
			"event_star":
				it.used = true
				b.hero.temp_mods = {}
				b.hero.temp_t = 0.0
				b.hero.recalc()
				_complete(b, obj, it.pos)

func _update_allies(b: Battle, dt: float) -> void:
	if allies.is_empty():
		return
	var keep: Array = []
	for a in allies:
		a.life = float(a.life) - dt
		a.atk_cd = maxf(0.0, float(a.atk_cd) - dt)
		if float(a.hp) <= 0.0 or float(a.life) <= 0.0:
			_ally_gone(b, a)
			continue
		if String(a.role) == "escort":
			_escort_step(b, a, dt)
		else:
			_soldier_step(b, a, dt)
		if String(a.role) == "escort" and a.pos.distance_to(a.goal) <= 1.0:
			var obj := _objective(String(a.obj))
			if not obj.is_empty():
				obj.got = 1
				_complete(b, obj, a.pos)
			continue
		keep.append(a)
	allies = keep

## O peregrino segue o destino, mas espera se o herói ficar para trás.
func _escort_step(b: Battle, a: Dictionary, dt: float) -> void:
	if b.hero.pos.distance_to(a.pos) > 6.0:
		return
	var to: Vector2 = a.goal - a.pos
	if to.length() < 0.01:
		return
	_ally_move(b, a, to.normalized() * float(a.speed) * dt)

func _soldier_step(b: Battle, a: Dictionary, dt: float) -> void:
	var target: Enemy = null
	var bd := 8.0
	for e in b.enemies:
		if e.dead or e.has_flag("quebravel"):
			continue
		var d: float = e.pos.distance_to(a.pos)
		if d < bd:
			bd = d
			target = e
	if target == null:
		if a.pos.distance_to(b.hero.pos) > 3.0:
			_ally_move(b, a, (b.hero.pos - a.pos).normalized() * float(a.speed) * dt)
		return
	if bd > 0.9 + target.radius:
		_ally_move(b, a, (target.pos - a.pos).normalized() * float(a.speed) * dt)
	elif float(a.atk_cd) <= 0.0:
		a.atk_cd = 1.0
		var dmg := float(Dice.roll(b.rng, String(a.dice)))
		b.run_record.hit("effect:ally", dmg, target.hp)
		target.hp -= dmg
		target.hit_flash = 0.12
		b.events.append({"type": "hit", "pos": target.pos, "amount": int(dmg), "crit": false})
		if target.hp <= 0.0:
			b._kill(target)

func _ally_move(b: Battle, a: Dictionary, v: Vector2) -> void:
	for turn in [0.0, 0.6, -0.6, 1.2, -1.2]:
		var np: Vector2 = a.pos + v.rotated(turn)
		if b.hero.can_stand(np, 0.3):
			a.pos = np
			return

func _ally_gone(b: Battle, a: Dictionary) -> void:
	if String(a.role) == "escort":
		var obj := _objective(String(a.obj))
		if not obj.is_empty():
			_fail(b, obj, a.pos)
	elif float(a.hp) <= 0.0:
		b.events.append({"type": "toast", "text": "%s caiu." % String(a.label)})

func _add_ally(b: Battle, spec: Dictionary) -> void:
	_serial += 1
	var a := {"id": _serial, "label": "", "sprite": "", "pos": b.hero.pos, "hp": 40.0, "life": 45.0, "dice": "1d8", "speed": 1.4,
		"aggro": 3.0, "goal": Vector2.ZERO, "role": "soldier", "obj": "", "atk_cd": 0.0}
	a.merge(spec, true)
	a.max_hp = float(a.hp)
	allies.append(a)

## Inimigos atacam aliados e o peregrino como atacam a cópia-isca (Battle._decoy_for).
func lures() -> Array:
	return allies

# ------------------------------------------------------------------ ganchos da Battle

func on_kill(b: Battle, e: Enemy) -> void:
	if e.event_tag == "":
		return
	var obj := _objective(e.event_tag)
	if obj.is_empty():
		return
	if e.event_item != "":
		_add_point(b, "event_item", e.pos, obj, e.event_item, Color(0.7, 0.95, 0.6))
		b.events.append({"type": "toast", "text": "%s caiu no chão." % e.event_item, "color": Color(0.7, 0.95, 0.6)})
		return
	match String(obj.kind):
		"invasion", "arena":
			if String(obj.kind) == "arena":
				arena = {}
			_complete(b, obj, e.pos)
		"intercept":
			obj.got = int(obj.got) + 1
			if int(obj.got) + int(obj.get("arrived", 0)) >= int(obj.need):
				if int(obj.get("arrived", 0)) == 0:
					_complete(b, obj, e.pos)
				else:
					_fail(b, obj, e.pos)

## Carregador do Ritual de estagnação chegou à massa: reforça o chefe e some.
func on_goal_reached(b: Battle, e: Enemy) -> void:
	e.dead = true
	var obj := _objective(e.event_tag)
	if obj.is_empty():
		return
	obj.arrived = int(obj.get("arrived", 0)) + 1
	var per := float(Dictionary(obj.def).get("per_arrival_boss_hp", 0.1))
	boss_hp_bonus += per
	b.events.append({"type": "toast", "text": "%s alimentou a massa (+%d%% PV do chefe)." % [e.name, int(round(per * 100.0))], "color": Color(0.9, 0.45, 0.45)})
	if int(obj.got) + int(obj.arrived) >= int(obj.need):
		_fail(b, obj, e.pos)

func boss_id(b: Battle) -> String:
	for k in flags:
		var alt: Dictionary = flags[k]
		if alt.has("boss"):
			return String(alt.boss)
	return String(b.stage.boss)

func on_boss_spawn(b: Battle, boss: Enemy) -> void:
	# Pedidos que valem "até o chefe" (o de Zuggtmoy) somem sem punição quando ele chega.
	for obj in objectives:
		if bool(Dictionary(obj.def).get("until_boss", false)) and not bool(obj.done):
			obj.failed = true
			for it in b.interactions:
				if String(it.get("obj", "")) == String(obj.id):
					it.used = true
			carrying = carrying.filter(func(c): return c.obj != obj.id)
	if boss_hp_bonus > 0.0:
		boss.max_hp = round(boss.max_hp * (1.0 + boss_hp_bonus))
		boss.hp = boss.max_hp
	for k in flags:
		var alt: Dictionary = flags[k]
		var al: Dictionary = alt.get("allies", {})
		if al.is_empty():
			continue
		for i in int(al.get("n", 3)):
			var ang := TAU * float(i) / maxf(1.0, float(al.get("n", 3)))
			_add_ally(b, {"label": String(al.get("label", "aliado")), "sprite": String(al.get("id", "")), "pos": b.hero.pos + Vector2(cos(ang), sin(ang)) * 1.5,
				"hp": float(al.get("hp", 40.0)), "life": float(al.get("life", 60.0)), "dice": String(al.get("dice", "1d8")), "speed": float(al.get("speed", 1.4))})
		if String(alt.get("text", "")) != "":
			b.events.append({"type": "toast", "text": String(alt.text), "color": Color(0.85, 0.75, 0.95)})

## Pacto: abre uma oferta como a loja (estado "shop"); "Recusar" sempre existe e não custa nada.
func open_pact(b: Battle, it: Dictionary) -> void:
	var obj := _objective(String(it.get("obj", "")))
	if obj.is_empty():
		return
	var def: Dictionary = obj.def
	b.offer = []
	for c in def.get("choices", []):
		var cost: Dictionary = c.get("cost", {})
		var gold_cost := int(cost.get("gold", 0)) + int(round(b.hero.gold * float(cost.get("gold_pct", 0.0))))
		var row := b._shop_row("pact", String(c.name), String(c.desc), gold_cost, {"choice": c, "obj": String(obj.id), "brief": String(c.get("brief", c.desc))})
		if gold_cost > 0:
			row["price_text"] = "%d moedas" % gold_cost
		b.offer.append(row)
	b.offer.append({"t": "shop_leave", "name": String(def.get("leave_text", "Recusar")), "desc": "Seguir adiante sem pacto.", "price": 0})
	b._decorate_offers()
	b.offer_kind = "pact"
	b.pact_title = String(def.get("title", "Pacto"))
	b.state = "shop"
	obj.done = true

func choose_pact(b: Battle, c: Dictionary) -> void:
	if b.hero.gold < int(c.price):
		return
	b.hero.gold -= int(c.price)
	var choice: Dictionary = c.choice
	var cost: Dictionary = choice.get("cost", {})
	if float(cost.get("hp_pct", 0.0)) > 0.0:
		b._hurt_hero(b.hero.max_hp * float(cost.hp_pct), "pact", true)
	var effect: Dictionary = choice.get("effect", {})
	if bool(effect.get("illusion", false)) and b.rng.randf() < float(effect.get("illusion_chance", 0.33)):
		b.events.append({"type": "toast", "text": String(effect.get("illusion_text", "Era ilusão: não havia nada ali.")), "color": Color(0.9, 0.5, 0.8)})
		return
	_apply_reward(b, effect, b.hero.pos + Vector2(1.2, 0.0))

# ------------------------------------------------------------------ conclusão

func _complete(b: Battle, obj: Dictionary, at: Vector2) -> void:
	if bool(obj.done) or bool(obj.failed):
		return
	obj.done = true
	var def: Dictionary = obj.def
	b.stats.happenings = int(b.stats.get("happenings", 0)) + 1
	var text := String(def.get("success_text", "%s: concluído!" % String(obj.title)))
	b.events.append({"type": "toast", "text": text, "color": Color(0.65, 0.95, 0.7)})
	b.events.append({"type": "happening_done", "id": String(obj.id), "pos": at})
	_apply_reward(b, def.get("reward", {}), at)

func _fail(b: Battle, obj: Dictionary, at: Vector2) -> void:
	if bool(obj.done) or bool(obj.failed):
		return
	obj.failed = true
	var def: Dictionary = obj.def
	var fail: Dictionary = def.get("fail", {})
	var text := String(def.get("fail_text", ""))
	if text != "":
		b.events.append({"type": "toast", "text": text, "color": Color(0.95, 0.55, 0.45)})
	var sp: Dictionary = fail.get("spawn", {})
	if not sp.is_empty():
		for i in int(sp.get("n", 3)):
			b._spawn(String(sp.id), at + Vector2(b.rng.randf_range(-1.5, 1.5), b.rng.randf_range(-1.5, 1.5)))
	if String(fail.get("elite", "")) != "":
		b._spawn_elite(String(fail.elite), at)
	if bool(fail.get("hazard", false)):
		b.zones.append({"owner": "stage", "kind": "puddle", "pos": at, "radius": 1.6, "grows": true, "delay": 0.0, "life": 14.0, "acc": 0.0})
	boss_hp_bonus += float(fail.get("boss_hp", 0.0))
	# limpa o que sobrou do objetivo no mapa
	for it in b.interactions:
		if String(it.get("obj", "")) == String(obj.id):
			it.used = true
	carrying = carrying.filter(func(c): return c.obj != obj.id)

func _timeout(b: Battle, obj: Dictionary) -> void:
	match String(obj.kind):
		"invasion":
			for e in b.enemies:
				if e.event_tag == String(obj.id) and not e.dead:
					e.dead = true
					b.events.append({"type": "toast", "text": String(Dictionary(obj.def).get("leave_text", "%s vai embora." % e.name))})
			obj.failed = true
		"arena":
			arena = {}
			_fail(b, obj, b.hero.pos)
		"pilgrimage":
			obj.failed = true
			for it in b.interactions:
				if String(it.get("obj", "")) == String(obj.id):
					it.used = true
		_:
			_fail(b, obj, obj.pos)

func _apply_reward(b: Battle, r: Dictionary, at: Vector2) -> void:
	for i in int(r.get("chest", 0)):
		b._add_interaction("chest", at + Vector2(1.2 * float(i), 0.6))
	if bool(r.get("boss_chest", false)):
		b._add_interaction("boss_chest", at + Vector2(0.0, 1.2))
	if float(r.get("gold", 0.0)) > 0.0:
		b._drop("gold", at, float(r.gold) * float(b.stage.coin_mult))
	if float(r.get("heal_pct", 0.0)) > 0.0:
		var amount := b.hero.max_hp * float(r.heal_pct)
		b._heal_hero(amount)
		b.events.append({"type": "heal", "pos": b.hero.pos, "amount": int(amount)})
	var boon: Dictionary = r.get("boon", {})
	if not boon.is_empty():
		b.hero.temp_mods = Dictionary(boon.get("mods", {})).duplicate()
		b.hero.temp_t = float(boon.get("duration", 20.0))
		b.hero.recalc()
		b.events.append({"type": "toast", "text": "%s: %s por %d s" % [String(boon.get("name", "Bênção")), Items.mods_text(b.hero.temp_mods), int(b.hero.temp_t)], "color": Color(0.9, 0.85, 0.5)})
	var flag: Dictionary = r.get("flag", {})
	if not flag.is_empty():
		flags[String(flag.get("id", "flag"))] = flag
	if String(r.get("text", "")) != "":
		b.events.append({"type": "toast", "text": String(r.text), "color": Color(0.85, 0.75, 0.95)})
	var sp: Dictionary = r.get("spawn", {})
	if not sp.is_empty():
		for i in int(sp.get("n", 3)):
			b._spawn(String(sp.id), at + Vector2(b.rng.randf_range(-2.0, 2.0), b.rng.randf_range(-2.0, 2.0)))
	if bool(r.get("wipe", false)):
		b.wipe_map()
	var al: Dictionary = r.get("allies", {})
	if not al.is_empty():
		for i in int(al.get("n", 2)):
			_add_ally(b, {"label": String(al.get("label", "aliado")), "sprite": String(al.get("id", "")), "pos": b.hero.pos + Vector2(1.2, 0.0).rotated(float(i) * 2.0),
				"hp": float(al.get("hp", 40.0)), "life": float(al.get("life", 30.0)), "dice": String(al.get("dice", "1d8")), "speed": float(al.get("speed", 1.5))})

# ------------------------------------------------------------------ UI

## Linhas para o HUD: título, progresso e tempo restante de cada objetivo aberto.
func hud_lines(b: Battle) -> Array:
	var out: Array = []
	for obj in objectives:
		if bool(obj.done) or bool(obj.failed) or String(obj.text) == "":
			continue
		var line := "◆ %s — %s" % [String(obj.title), String(obj.text)]
		if int(obj.need) > 1:
			var have := int(obj.got) + carrying.filter(func(c): return c.obj == obj.id).size() if String(obj.kind) == "collect" else int(obj.got)
			line += " (%d/%d)" % [have, int(obj.need)]
		if float(obj.ends_at) > 0.0:
			line += " · %d s" % maxi(0, int(ceil(float(obj.ends_at) - b.time)))
		out.append(line)
	if not carrying.is_empty():
		out.append("Carregando: %s" % ", ".join(carrying.map(func(c): return String(c.label))))
	return out

## Pontos que merecem seta na borda da tela (destino, itens, NPCs, peregrino).
func markers(b: Battle) -> Array:
	var out: Array = []
	for it in b.interactions:
		if not it.used and String(it.kind).begins_with("event_"):
			out.append({"pos": it.pos, "color": it.get("color", Color.WHITE)})
	for a in allies:
		if String(a.role) == "escort":
			out.append({"pos": a.pos, "color": Color(0.75, 0.9, 1.0)})
	for e in b.enemies:
		if e.event_tag != "" and not e.dead and (e.event_item != "" or e.affix != ""):
			out.append({"pos": e.pos, "color": Color(1.0, 0.5, 0.4)})
	return out

# ------------------------------------------------------------------ util

func _objective(id: String) -> Dictionary:
	for o in objectives:
		if String(o.id) == id:
			return o
	return {}

func _add_point(b: Battle, kind: String, at: Vector2, obj: Dictionary, label: String, color: Color, asset: String = "", passive: bool = false) -> void:
	b._add_interaction(kind, at)
	var it: Dictionary = b.interactions[-1]
	it.obj = String(obj.id)
	it.label = label
	it.color = color
	it.asset = asset
	it.passive = passive

## Ponto livre a uma distância do herói, dentro do mapa (tenta 12 vezes, depois aceita o último).
func _far_pos(b: Battle, lo: float, hi: float) -> Vector2:
	var p := b.hero.pos
	for i in 12:
		var ang := b.rng.randf() * TAU
		p = (b.hero.pos + Vector2(cos(ang), sin(ang)) * b.rng.randf_range(lo, hi)).clamp(Vector2(2, 2), b.map_size - Vector2(2, 2))
		if b.hero.can_stand(p, 0.5):
			return p
	return p

func _col(d: Dictionary, fallback: Color) -> Color:
	var c: Array = d.get("color", [])
	if c.size() >= 3:
		return Color8(int(c[0]), int(c[1]), int(c[2]))
	return fallback
