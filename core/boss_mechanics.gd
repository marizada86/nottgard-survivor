class_name BossMechanics
extends RefCounted
## L5 (PROPOSTA-l5-mecanicas-de-chefe, aprovada pelo dono em 2026-10-14): mecânicas de chefe no estilo de raide.
## Verbos: totems (V1), quadrants (V2), sweep (V3), cast interrompível (V4), immune_adds (V5) e enrage suave (V7).
## Os chefes e as fases vêm de data/boss_mechanics.json; a regra geral, o orçamento de caos e os interruptores, de
## `boss_mech` em data/difficulty.json. Tudo desliga com `boss_mech.enabled = false`.

const SECTOR_COUNT := 4

var b: Battle
var boss: Enemy
var defs: Dictionary = {}
var phase := 0
var fight_t := 0.0
var enrage_steps := 0
var totems: Array = []
var shield := 0.0
var cast: Dictionary = {}
var sweep: Dictionary = {}
var quad: Dictionary = {}
var adds: Array = []
var immune_t := 0.0
var _verbs: Array = []        # verbos que se repetem na fase atual: {"def", "timer"}
var _hit_cd := 0.0
var _told_interrupt := false
var finished := false

static func config() -> Dictionary:
	var cfg: Dictionary = Data.table("difficulty").get("boss_mech", {})
	return cfg if bool(cfg.get("enabled", false)) else {}

static func verb_on(name: String) -> bool:
	var cfg := config()
	if cfg.is_empty():
		return false
	return bool(cfg.get("verbs", {}).get(name, true))

static func create(battle: Battle, e: Enemy) -> BossMechanics:
	if config().is_empty():
		return null
	var defs: Dictionary = Data.table("boss_mechanics").get(e.id, {})
	if defs.is_empty():
		return null
	var m := BossMechanics.new()
	m.b = battle
	m.boss = e
	m.defs = defs
	return m

## Quantas mecânicas podem estar ativas juntas: cresce com a ordem da fase (2 nas três primeiras, 3 nas três seguintes, 4 no fim).
static func budget_for_order(order: int) -> int:
	var cfg: Dictionary = config().get("budget", {})
	return int(cfg.get("base", 2)) + int(order / int(maxi(1, int(cfg.get("every_stages", 3)))))

func budget() -> int:
	return budget_for_order(int(b.stage.get("order", 0)))

func active_count() -> int:
	var n := 0
	if _alive_totems() > 0:
		n += 1
	if not cast.is_empty():
		n += 1
	if not sweep.is_empty():
		n += 1
	if not quad.is_empty():
		n += 1
	if is_immune(boss):
		n += 1
	return n

func _alive_totems() -> int:
	var n := 0
	for t in totems:
		if is_instance_valid(t) and not t.dead:
			n += 1
	return n

# ------------------------------------------------------------------ consultas do Battle

func is_immune(e: Enemy) -> bool:
	if e != boss or immune_t <= 0.0:
		return false
	for a in adds:
		if is_instance_valid(a) and not a.dead:
			return true
	return false

## Multiplicador do dano que o herói causa ao chefe (turíbulos de pé blindam).
func damage_taken_mult(e: Enemy) -> float:
	if e != boss or _alive_totems() <= 0:
		return 1.0
	return 1.0 - clampf(shield, 0.0, 0.9)

func enrage_mult() -> float:
	var cfg: Dictionary = config().get("enrage", {})
	return 1.0 + float(cfg.get("step", 0.08)) * float(enrage_steps)

func skips_action(phase_index: int, action_type: String) -> bool:
	var skip: Array = defs.get(str(phase_index), {}).get("skip", [])
	return skip.has(action_type)

# ------------------------------------------------------------------ eventos do Battle

func on_phase(phase_index: int) -> void:
	phase = phase_index
	var entry: Dictionary = defs.get(str(phase_index), {})
	_verbs.clear()
	for v in entry.get("verbs", []):
		var verb := String(v.t)
		if not verb_on(verb):
			continue
		match verb:
			"totems":
				_start_totems(v)
			"immune_adds":
				_start_immune(v)
			_:
				_verbs.append({"def": v, "timer": float(v.get("first", 3.0))})

## O herói usou a habilidade ativa: se há conjuração em curso, interrompe e atordoa o chefe.
func on_hero_active() -> void:
	if cast.is_empty():
		return
	_interrupt("Interrompido!")

func on_boss_dead() -> void:
	finished = true
	for t in totems:
		if is_instance_valid(t) and not t.dead:
			t.hp = 0.0
			b._kill(t)
	totems.clear()
	cast.clear()
	sweep.clear()
	quad.clear()
	adds.clear()
	immune_t = 0.0

# ------------------------------------------------------------------ passo

func step(dt: float) -> void:
	if finished or boss == null or boss.dead:
		return
	fight_t += dt
	_hit_cd = maxf(0.0, _hit_cd - dt)
	_step_enrage()
	if immune_t > 0.0:
		immune_t = maxf(0.0, immune_t - dt)
		if not is_immune(boss):
			immune_t = 0.0
			adds.clear()
			b.events.append({"type": "toast", "text": "O chefe volta a sangrar.", "color": Color(0.8, 0.95, 0.6)})
	for v in _verbs:
		v.timer = float(v.timer) - dt
		if float(v.timer) <= 0.0:
			if active_count() >= budget():
				v.timer = 1.0   # orçamento cheio: tenta de novo em 1 s
				continue
			_start(v.def)
			v.timer = float(v.def.get("cd", 12.0))
	_step_cast(dt)
	_step_sweep(dt)
	_step_quad(dt)

func _step_enrage() -> void:
	var cfg: Dictionary = config().get("enrage", {})
	if cfg.is_empty() or not bool(cfg.get("enabled", true)) or not verb_on("enrage"):
		return
	var start := float(cfg.get("start_s", 90.0))
	var every := maxf(1.0, float(cfg.get("every_s", 15.0)))
	var want := 0 if fight_t < start else mini(int(cfg.get("max_steps", 5)), 1 + int((fight_t - start) / every))
	if want > enrage_steps:
		enrage_steps = want
		b.events.append({"type": "toast", "text": "O chefe se enfurece! (+%d%% de dano)" % int(round(float(cfg.get("step", 0.08)) * float(enrage_steps) * 100.0)), "color": Color(1.0, 0.45, 0.3)})

func _start(v: Dictionary) -> void:
	match String(v.t):
		"cast":
			cast = {"name": String(v.get("name", "Conjuração")), "t": float(v.get("windup", 2.5)), "total": float(v.get("windup", 2.5)),
				"dice": String(v.get("dice", "2d8")), "stun": float(v.get("stun", 2.0))}
			b.events.append({"type": "trap_warn", "pos": boss.pos})
			b.events.append({"type": "toast", "text": "%s! Use a habilidade (%s) para interromper." % [cast.name, "Q"] if not _told_interrupt else "%s!" % cast.name, "color": Color(1.0, 0.8, 0.4)})
			_told_interrupt = true
		"sweep":
			var to := b.hero.pos - boss.pos
			var sign := 1.0 if b.rng.randf() < 0.5 else -1.0
			var arc := deg_to_rad(float(v.get("arc", 90.0)))
			var a0 := to.angle() - sign * arc * 0.5
			sweep = {"origin": boss.pos, "a": a0, "a0": a0, "sign": sign, "arc": arc, "warn": float(v.get("warn", 1.0)), "dur": float(v.get("dur", 2.2)),
				"t": 0.0, "len": float(v.get("len", 9.0)), "dice": String(v.get("dice", "2d6"))}
			b.events.append({"type": "windup", "pos": boss.pos, "dir": Vector2.from_angle(a0), "len": float(sweep.len), "enemy_id": boss.id})
		"quadrants":
			var all := [0, 1, 2, 3]
			all.shuffle()
			quad = {"center": boss.pos, "sectors": [all[0], all[1]], "t": float(v.get("warn", 1.5)), "total": float(v.get("warn", 1.5)),
				"radius": float(v.get("radius", 9.0)), "dice": String(v.get("dice", "2d8"))}
			b.events.append({"type": "trap_warn", "pos": boss.pos})

func _start_totems(v: Dictionary) -> void:
	totems.clear()
	var n := int(v.get("n", 2))
	shield = float(v.get("shield", 0.3))
	var off := b.rng.randf() * TAU
	for i in n:
		var placed := false
		for radius in [3.4, 2.6, 4.4]:
			var p: Vector2 = boss.pos + Vector2.from_angle(off + TAU * float(i) / float(n)) * radius
			if b.hero.can_stand(p, 0.45):
				var t: Enemy = b._spawn("totem_de_chefe", p, 0.0)
				t.max_hp = float(v.get("hp", t.max_hp))
				t.hp = t.max_hp
				totems.append(t)
				placed = true
				break
		if not placed:
			totems.append(b._spawn("totem_de_chefe", boss.pos + Vector2(2.0 * float(i + 1), 0.0), 0.0))
	b.events.append({"type": "toast", "text": "Quebre os turíbulos: eles blindam o chefe!", "color": Color(1.0, 0.6, 0.4)})

func _start_immune(v: Dictionary) -> void:
	adds.clear()
	var n := int(v.get("n", 3))
	var off := b.rng.randf() * TAU
	for i in n:
		var p: Vector2 = boss.pos + Vector2.from_angle(off + TAU * float(i) / float(n)) * 3.0
		var a: Enemy = b._spawn(String(v.get("id", "zumbi")), p, 0.0)
		adds.append(a)
	immune_t = float(v.get("max_s", 12.0))
	b.events.append({"type": "toast", "text": "O chefe fica imune: derrote os servos!", "color": Color(0.7, 0.9, 1.0)})

func _step_cast(dt: float) -> void:
	if cast.is_empty():
		return
	if boss.stun_t > 0.0:
		_interrupt("Interrompido!")
		return
	cast.t = float(cast.t) - dt
	if float(cast.t) <= 0.0:
		var dmg := float(Dice.roll(b.rng, String(cast.dice)) + boss.atk_bonus)
		b.events.append({"type": "text", "pos": b.hero.pos, "text": String(cast.name)})
		b._hurt_hero(dmg, "aoe")
		b.events.append({"type": "telegraph_burst", "pos": boss.pos})
		cast.clear()

func _interrupt(text: String) -> void:
	var stun := float(cast.get("stun", 2.0))
	boss.stun_t = maxf(boss.stun_t, stun)
	b.events.append({"type": "text", "pos": boss.pos, "text": text})
	b.events.append({"type": "toast", "text": "%s O chefe fica atordoado." % text, "color": Color(0.6, 1.0, 0.6)})
	cast.clear()

func _step_sweep(dt: float) -> void:
	if sweep.is_empty():
		return
	sweep.t = float(sweep.t) + dt
	var t := float(sweep.t) - float(sweep.warn)
	if t < 0.0:
		return
	var dur := maxf(0.1, float(sweep.dur))
	if t >= dur:
		sweep.clear()
		return
	sweep.a = float(sweep.a0) + float(sweep.sign) * float(sweep.arc) * (t / dur)
	var rel: Vector2 = b.hero.pos - (sweep.origin as Vector2)
	var dir := Vector2.from_angle(float(sweep.a))
	var along := rel.dot(dir)
	var across := absf(rel.cross(dir))
	if along > 0.0 and along <= float(sweep.len) and across <= 0.7 and _hit_cd <= 0.0:
		_hit_cd = 0.7
		b._hurt_hero(float(Dice.roll(b.rng, String(sweep.dice)) + boss.atk_bonus), "aoe")

func _step_quad(dt: float) -> void:
	if quad.is_empty():
		return
	quad.t = float(quad.t) - dt
	if float(quad.t) > 0.0:
		return
	var rel: Vector2 = b.hero.pos - (quad.center as Vector2)
	if rel.length() <= float(quad.radius):
		var idx := int(floor(wrapf(rel.angle(), 0.0, TAU) / (TAU / float(SECTOR_COUNT))))
		if (quad.sectors as Array).has(idx):
			b._hurt_hero(float(Dice.roll(b.rng, String(quad.dice)) + boss.atk_bonus), "aoe")
	b.events.append({"type": "telegraph_burst", "pos": quad.center})
	quad.clear()

# ------------------------------------------------------------------ desenho (chamado pelo overlay)

func draw_fx(ci: CanvasItem) -> void:
	if finished or boss == null or boss.dead:
		return
	for t in totems:
		if is_instance_valid(t) and not t.dead:
			var a := Iso.to_screen(t.pos) + Vector2(0, -10)
			var c := Iso.to_screen(boss.pos) + Vector2(0, -20)
			ci.draw_line(a, c, Color(1.0, 0.5, 0.3, 0.55), 2.0)
			ci.draw_arc(a, 14.0, 0.0, TAU, 20, Color(1.0, 0.6, 0.3, 0.9), 2.0)
	if is_immune(boss):
		var pulse := 0.5 + 0.5 * sin(Time.get_ticks_msec() / 120.0)
		ci.draw_arc(Iso.to_screen(boss.pos) + Vector2(0, -30), 30.0 + 3.0 * pulse, 0.0, TAU, 28, Color(0.6, 0.85, 1.0, 0.9), 3.0)
		for a in adds:
			if is_instance_valid(a) and not a.dead:
				ci.draw_line(Iso.to_screen(a.pos) + Vector2(0, -10), Iso.to_screen(boss.pos) + Vector2(0, -24), Color(0.6, 0.85, 1.0, 0.5), 1.5)
	if not cast.is_empty():
		var top := Iso.to_screen(boss.pos) + Vector2(-34.0, -92.0 * boss.scale)
		var ratio := clampf(1.0 - float(cast.t) / maxf(0.01, float(cast.total)), 0.0, 1.0)
		ci.draw_rect(Rect2(top, Vector2(68, 8)), Color(0, 0, 0, 0.75))
		ci.draw_rect(Rect2(top + Vector2(1, 1), Vector2(66.0 * ratio, 6)), Color(1.0, 0.55, 0.2))
		ci.draw_rect(Rect2(top, Vector2(68, 8)), Color(1.0, 0.85, 0.5), false, 1.0)
		ci.draw_string(ThemeDB.fallback_font, top + Vector2(-20, -4), "%s (Q interrompe)" % String(cast.name), HORIZONTAL_ALIGNMENT_LEFT, 150, 12, Color(1.0, 0.9, 0.6))
	if not sweep.is_empty():
		var origin := Iso.to_screen(sweep.origin) + Vector2(0, -8)
		var warn_phase := float(sweep.t) < float(sweep.warn)
		var tip := Iso.to_screen((sweep.origin as Vector2) + Vector2.from_angle(float(sweep.a)) * float(sweep.len)) + Vector2(0, -8)
		var col := Color(1.0, 0.85, 0.3, 0.55) if warn_phase else Color(1.0, 0.2, 0.15, 0.85)
		ci.draw_line(origin, tip, col, 3.0 if warn_phase else 7.0)
	if not quad.is_empty():
		var ratio2 := clampf(1.0 - float(quad.t) / maxf(0.01, float(quad.total)), 0.0, 1.0)
		for s in quad.sectors:
			var pts := PackedVector2Array()
			pts.append(Iso.to_screen(quad.center))
			var a0 := float(s) * TAU / float(SECTOR_COUNT)
			for k in 11:
				var ang := a0 + (TAU / float(SECTOR_COUNT)) * float(k) / 10.0
				pts.append(Iso.to_screen((quad.center as Vector2) + Vector2.from_angle(ang) * float(quad.radius)))
			ci.draw_colored_polygon(pts, Color(0.95, 0.12, 0.08, 0.12 + 0.25 * ratio2))
			ci.draw_polyline(pts, Color(1.0, 0.35, 0.2, 0.55 + 0.35 * ratio2), 2.0)
