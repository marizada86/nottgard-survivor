class_name Battle
extends RefCounted
## Simulação da run (sem nós, RNG por seed). A UI lê o estado e consome `events`.

const TerrainLayout := preload("res://core/terrain_layout.gd")

enum Aim { AUTO, MOUSE }

const ENEMY_ATK_RANGE := 0.95
const ENEMY_ATK_CD := 1.3
const SPAWN_SLOW := 1.35   # multiplica o intervalo das ondas (ritmo lento)
const HIT_INVULN := 0.4
const HERO_HIT_R := 0.3
const MAX_PICKUPS := 140
const AFFIXES := ["veloz", "resistente", "mortal", "avaro"]
const AFFIX_NAMES := {"veloz": "Veloz", "resistente": "Resistente", "mortal": "Mortal", "avaro": "Avaro"}
## Cada bioma tem seu próprio quebrável temático, alinhado à família de prop
## já usada na fase (ART-PROMPTS-024). Candelabro/caixote continuam
## exclusivos de Dagruve/Docas (tema de cais/porto); arbusto é o fallback
## genérico para qualquer fase sem tipo próprio.
const BREAKABLE_TYPES_BY_STAGE := {
	"dagruve": ["candelabro_quebravel", "caixote_quebravel", "arbusto_quebravel"],
	"docas": ["candelabro_quebravel", "caixote_quebravel", "arbusto_quebravel"],
	"shedaklah": ["saco_de_esporos_quebravel", "arbusto_quebravel"],
	"molor": ["casulo_viscoso_quebravel", "arbusto_quebravel"],
	"durao": ["urna_funeraria_quebravel", "arbusto_quebravel"],
	"feng_tu": ["lanterna_de_papel_quebravel", "arbusto_quebravel"],
	"shendilavri": ["espelho_ilusorio_quebravel", "arbusto_quebravel"],
	"goranthis": ["estatua_rachada_quebravel", "arbusto_quebravel"],
	"pilares": ["relicario_instavel_quebravel", "arbusto_quebravel"],
}
const BREAKABLE_DEFAULT_TYPES := ["arbusto_quebravel"]

var rng := RandomNumberGenerator.new()
var hero: Hero
var stage_id := ""
var stage: Dictionary = {}
var enemies: Array = []
var projectiles: Array = []
var zones: Array = []
var decoys: Array = []  # MEC-029: cópias-isca do Passo pelas Sombras
var pickups: Array = []
var interactions: Array = []
var events: Array = []
var aim := Aim.AUTO
var aim_dir := Vector2(1, 1).normalized()
var aim_pos := Vector2.ZERO
var time := 0.0
var run_time := 0.0
var state := "running"   # running | levelup | altar | item_offer | shop | evolve_cine | revive_offer | dead | won
var offer: Array = []
var offer_kind := ""
var pending_levels := 0
var rerolls := 0
var boss: Enemy = null
var boss_spawned := false
var boss_dead := false
var boss_repeat := 0
var stage_cleared := false
## Pausa breve, dirigida por dados, antes de liberar o primeiro chefe.
var boss_intro_remaining := 0.0
## Maré de Névoa pós-chefe. Exposta para a UI e para os testes, sem depender dela.
var fog_state := "inactive" # inactive | grace | warning | advancing
var fog_elapsed := 0.0
var fog_intensity := 0.0
var fog_config: Dictionary = {}
var final_victory := false
var extracted := false
var stage_changed := false
var map_size := Vector2(40, 40)
var difficulty := 1.0
## A primeira oferta é gratuita; a melhoria Segunda Chance concede ofertas extras.
var revive_left := 0
var free_revive_used := false
var death_reward_rate := 0.5
var death_reason := ""
var invuln := 0.0
var stats := {"kills": 0, "crits": 0, "ones": 0, "elites": 0, "bosses": 0, "chests": 0, "gold": 0.0, "damage_taken": 0.0, "stages_cleared": 0, "rituals": 0, "bets_won": 0, "loyalty": 0, "boss_ids": [], "stage_ids": [], "cleared_ids": []}
var codex := {"enemies": {}, "items": {}, "weapons": {}}
var _acc := {}
var _elites_done := {}
var _inter_t := 4.0
var _breakable_t := 20.0
var _amb_puddle := 9.0
var _amb_strike := 6.0
var _cur_angle := 0.0
var _trickle := 0.0
var _grid := {}
var _first_inter := true
var _spawn_serial := 0
var _cine_queue: Array = []      # MEC-009: evoluções aguardando a mini-cinemática
var evolve_cine: Dictionary = {}   # {from, into, passive, level} da cinemática em curso
var evolve_cine_t := 0.0

func skip_cine() -> void:
	if state == "evolve_cine":
		state = "running"
		evolve_cine = {}
		evolve_cine_t = 0.0
var keep_streak := {}          # MEC-021: recusas seguidas de trocar o item de cada slot
const KEEP_STREAK_NEEDED := 3
var speed_mult := 1.0          # MEC-010: simulação ×1,5 ou ×2, só em fase já vencida
var cleared_stages: Array = []  # ids das fases que o perfil já venceu (preenchido por ui/run.gd)
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
var stage_events: Array = []
var _rule_timer := 0.0
var _rule_index := -1
var _effect_cd := {}
var _stage_events_done := {}
var _hero_moving := false
## Afinidade estritamente visual; a aura só é habilitada por uma escolha divina.
var visual_god := ""
var visual_boon_selected := false
## Estado ambiental do Estige. A RNG é separada para não deslocar a batalha.
var styx_rng := RandomNumberGenerator.new()
var styx_exposure := 0.0
var styx_test_next := 1.0
var _styx_loss_expiry: Array = []   # run_time em que cada ponto de INT perdido volta (MEC-022)
var styx_in_water := false

func _init(seed_value: int = 1, hero_id: String = "durvall", stage_key: String = "dagruve", ctx: Dictionary = {}) -> void:
	rng.seed = seed_value
	styx_rng.seed = seed_value ^ 0x5179
	difficulty = float(ctx.get("difficulty", 1.0))
	hero = Hero.make(hero_id, ctx.get("meta_mods", {}), ctx.get("bonus_mods", {}))
	visual_god = String(Data.table("heroes")[hero_id].get("patron", ""))
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
	stage_events = Data.table("stage_events").get(stage_key, []).duplicate(true)
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
	boss_intro_remaining = 0.0
	fog_state = "inactive"
	fog_elapsed = 0.0
	fog_intensity = 0.0
	fog_config.clear()
	_acc.clear()
	_elites_done.clear()
	_stage_events_done.clear()
	_inter_t = 4.0
	_first_inter = true
	_breakable_t = 20.0 + rng.randf() * 10.0
	_amb_puddle = 9.0
	_amb_strike = 6.0
	_rule_timer = minf(8.0, float(stage_rule.get("interval", 8.0)))
	_rule_index = -1
	styx_exposure = 0.0
	styx_test_next = 1.0
	styx_in_water = false
	_styx_loss_expiry.clear()
	hero.styx_lucidity_loss = 0
	hero.styx_forget_t = 0.0
	hero.terrain_id = stage_key
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

func qa_prepare(request: Variant) -> void:
	var qa: Dictionary = request if request is Dictionary else {"target_state": String(request)}
	_apply_qa_build(qa)
	var event_id := String(qa.get("event_id", ""))
	if event_id != "":
		_prepare_qa_stage_event(event_id, float(qa.get("prelude_seconds", 5.0)))
		return
	var target_state := String(qa.get("target_state", "running"))
	if target_state == "boss":
		time = maxf(0.0, float(stage.duration) - float(qa.get("prelude_seconds", 5.0)))
		_skip_stage_events_before(time)
		return
	match target_state:
		"levelup":
			_add_xp(float(xp_need_for(hero.level)))
		"altar":
			_open_altar()
		"boss_70", "boss_35", "portal":
			_spawn_qa_boss()
			if target_state == "boss_70":
				boss.hp = boss.max_hp * 0.69
				_check_boss_phase(boss)
			elif target_state == "boss_35":
				boss.phase_index = 1
				boss.hp = boss.max_hp * 0.34
				_check_boss_phase(boss)
			elif target_state == "portal":
				_kill(boss)
		"victory":
			stage_cleared = true
			state = "won"
		"defeat":
			hero.dead = true
			hero.hp = 0.0
			state = "dead"
		"revive_offer":
			hero.dead = true
			hero.hp = 0.0
			stats.gold = 10.0
			state = "revive_offer"
		"rule":
			_stage_rule_step(99.0)
		"prop_grounding":
			events.append({"type": "toast", "text": "QA: cruz verde = contato; contorno amarelo = sombra; inspecione o y-sort."})
		"styx_entry":
			hero.pos = TerrainLayout.styx_sample(stage_id)
			events.append({"type": "toast", "text": "QA: entrada no Rio Estige preparada."})
		"styx_margin":
			hero.pos = TerrainLayout.styx_sample(stage_id, TerrainLayout.MATERIAL_BANK)
			events.append({"type": "toast", "text": "QA: margem do Estige preparada."})
		"styx_forget":
			hero.styx_forget_t = 4.0
			hero.styx_lucidity_loss = 1
			hero.pos = Vector2(20.0, 20.0)
			events.append({"type": "toast", "text": "QA: Esquecimento do Estige ativo por 4 s."})
		"styx_lucidity":
			hero.pos = TerrainLayout.styx_sample(stage_id)
			_styx_lucidity_test(99)
			events.append({"type": "toast", "text": "QA: falha de Lucidez do Estige preparada."})
		"chest", "fountain", "altar", "ritual":
			_add_interaction(target_state, hero.pos + Vector2(1.0, 0.0))

func _apply_qa_build(qa: Dictionary) -> void:
	var level := clampi(int(qa.get("level", 1)), 1, 20)
	hero.level = level
	hero.xp = 0.0
	hero.xp_need = xp_need_for(level)
	var weapon_ids: Array = qa.get("weapons", [])
	for weapon_id in weapon_ids:
		var wid := String(weapon_id)
		if Data.table("weapons").has(wid) and not hero.weapons.any(func(w): return w.id == wid):
			hero.weapons.append(Weapon.make(wid))
			codex.weapons[wid] = true
	var passive_id := String(qa.get("passive_id", ""))
	if passive_id != "" and Data.table("passives").has(passive_id):
		hero.passives[passive_id] = clampi(int(qa.get("passive_level", 1)), 1, 5)
	var item_id := String(qa.get("item_id", ""))
	if item_id != "":
		for item in Data.table("items").uniques:
			if String(item.id) == item_id:
				hero.items[String(item.slot)] = item.duplicate(true)
				break
	hero.recalc()
	hero.hp = hero.max_hp

func _prepare_qa_stage_event(event_id: String, prelude: float) -> void:
	for event_def in stage_events:
		if String(event_def.get("id", "")) != event_id:
			continue
		var at := float(event_def.get("at", 0.0))
		time = maxf(0.0, at - maxf(0.0, prelude))
		_skip_stage_events_before(at)
		return

func _skip_stage_events_before(at: float) -> void:
	for event_def in stage_events:
		if float(event_def.get("at", 0.0)) < at:
			var event_id := String(event_def.get("id", ""))
			_stage_events_done[event_id] = true
			_stage_events_done["%s.warning" % event_id] = true

func _spawn_qa_boss() -> void:
	boss = spawn_for_test(String(stage.boss), hero.pos + Vector2(2, 0))
	boss_spawned = true
	events.append({"type": "boss", "enemy": boss})
	_start_boss_intro(boss)
	events.append({"type": "toast", "text": "%s surge!" % boss.name})

func toggle_aim() -> void:
	aim = Aim.MOUSE if aim == Aim.AUTO else Aim.AUTO

func active_status() -> String:
	if active_guard > 0:
		return "[Q/RMB/RB] %s — GUARDA ATIVA" % active_def.name
	if active_cd <= 0.0:
		return "[Q/RMB/RB] %s — PRONTA" % active_def.name
	return "[Q/RMB/RB] %s — %.1fs" % [active_def.name, active_cd]

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
			if float(p.get("decoy_life", 0.0)) > 0.0:
				_spawn_decoy(p)
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
				"life": float(p.range) / float(p.speed), "pierce": 1, "radius": 0.4, "p": p, "hit": {}, "visual_theme": DivineVisuals.resolve(hero.id, visual_god, visual_boon_selected)})
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
	# MEC-009: mini-cinemática de evolução; o jogo fica parado enquanto ela roda
	if state == "evolve_cine":
		evolve_cine_t -= dt
		if evolve_cine_t <= 0.0:
			skip_cine()
		return
	if state == "running" and not _cine_queue.is_empty() and not hero.dead:
		evolve_cine = _cine_queue.pop_front()
		evolve_cine_t = float(Data.table("difficulty").get("evolve_cinematic_seconds", 2.6))
		state = "evolve_cine"
		return
	if state != "running" or hero.dead:
		return
	if boss_intro_remaining > 0.0:
		boss_intro_remaining = maxf(0.0, boss_intro_remaining - dt)
		if is_zero_approx(boss_intro_remaining):
			events.append({"type": "boss_intro_end"})
			if boss != null and not boss.dead:
				events.append({"type": "telegraph", "pos": boss.pos, "radius": 2.2, "delay": 0.8, "enemy_id": boss.id})
		return
	time += dt
	run_time += dt
	_update_effect_timers(dt)
	invuln = maxf(0.0, invuln - dt)
	hero.push = Vector2.ZERO
	_hero_moving = screen_dir != Vector2.ZERO
	_stage_rule_step(dt)
	_stage_event_step()
	hero.step(screen_dir, dt)
	_update_postboss_fog(dt)
	if hero.m("regen") > 0.0:
		_heal_hero(hero.m("regen") * dt)
	_build_grid()
	_update_weapons(dt)
	_update_projectiles(dt)
	_update_zones(dt)
	_update_decoys(dt)
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
			"pierce": int(p.get("pierce", 0)), "radius": 0.4, "p": p, "hit": {}, "visual_theme": DivineVisuals.resolve(hero.id, visual_god, visual_boon_selected)})
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
	var visual_theme := DivineVisuals.resolve(hero.id, visual_god, visual_boon_selected)
	zones.append({"owner": "hero", "kind": "zone", "pos": at, "radius": r, "life": float(p.get("duration", 3.0)), "tick": float(p.get("tick", 0.5)), "acc": 0.0, "p": p, "visual_theme": visual_theme})
	events.append({"type": "zone", "pos": at, "radius": r, "dtype": p.dtype, "weapon": p.get("_audio_id", p.get("id", "")), "visual_theme": visual_theme})
	return true

## Golpe do herói. `roll`: usa d20 para erro/crítico e precisão contra evasão tipada.
func _hero_hit(e: Enemy, p: Dictionary, roll: bool, visual_theme: Dictionary = {}) -> bool:
	var resolved_theme: Dictionary = visual_theme if not visual_theme.is_empty() else DivineVisuals.resolve(hero.id, visual_god, visual_boon_selected)
	if e.dead:
		return false
	var attr := String(p.get("attr", "forca"))
	var dtype := String(p.get("dtype", "fisico"))
	var r := 0
	var crit := false
	if roll:
		r = Dice.d20(rng)
		var acc := hero.prof + hero.attr_mod(attr) + int(hero.m("hit")) + int(p.get("acc", 0))
		if r == 1:
			stats.ones += 1
		if r == 1 or (r != 20 and rng.randf() >= _hit_chance(acc, e.typed_evasion(dtype))):
			events.append({"type": "miss", "pos": e.pos})
			return false
		crit = r == 20 or rng.randf() < hero.crit_chance(r + acc)
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
		events.append({"type": "hit", "pos": e.pos, "amount": int(dmg), "crit": crit, "visual_theme": resolved_theme})
		if crit and _has_boon_effect("critical_wave"):
			for other in enemies:
				if other != e and not other.dead and other.pos.distance_to(e.pos) <= 2.0:
					var splash := maxf(1.0, round(dmg * 0.25))
					other.hp -= splash
					events.append({"type": "hit", "pos": other.pos, "amount": int(splash), "crit": false, "visual_theme": resolved_theme})
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
		if hero.can_stand(e.pos + away, e.radius):
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
						_hero_hit(e, pr.p, true, pr.get("visual_theme", {}))
						pr.pierce -= 1
						if pr.pierce < 0:
							gone = true
							break
			elif pr.pos.distance_to(hero.pos) <= HERO_HIT_R + pr.radius:
				_enemy_hit_hero(int(pr.bonus), String(pr.dice), String(pr.dtype), true, float(pr.get("damage_mult", 1.0)))
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
						_hero_hit(e, z.p, false, z.get("visual_theme", {}))
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
				events.append({"type": "toast", "text": "Ritual interrompido: os reforços foram impedidos."})
				stats.rituals += 1
				_grant_ritual_blessing()
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
					_hurt_hero(float(Dice.roll(rng, z.dice) + int(z.bonus / 2)) * float(z.get("damage_mult", 1.0)), "aoe")
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
		if hero.can_stand(np, e.radius):
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
	var lure: Dictionary = _decoy_for(e)
	var to: Vector2 = (lure.pos if not lure.is_empty() else hero.pos) - e.pos
	var dist: float = to.length()
	if e.charge_t > 0.0:
		e.charge_t -= dt
		var np: Vector2 = e.pos + e.charge_dir * float(e.charge_ab.speed) * dt
		if hero.can_stand(np, e.radius):
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
			mv = _chase_dir(e, dir, dist)
		if mv != Vector2.ZERO:
			_enemy_move(e, mv * spd * dt)
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
	if e.has_flag("inerte"):
		return
	var reach := 1.4 if e.speed == 0.0 else ENEMY_ATK_RANGE + e.radius * 0.3
	if dist <= reach and e.atk_cd <= 0.0:
		e.atk_cd = ENEMY_ATK_CD
		if not lure.is_empty():
			_hit_decoy(lure, float(Dice.roll(rng, e.atk_dice) + maxi(0, e.atk_bonus)))
		else:
			_enemy_hit_hero(e.atk_bonus, e.atk_dice, "fisico", false)

# ------------------------------------------------------------------ cópia-isca (MEC-029)

func _spawn_decoy(p: Dictionary) -> void:
	decoys.append({"pos": hero.pos, "life": float(p.decoy_life), "hp": float(p.get("decoy_hp", 24.0)),
		"aggro": float(p.get("decoy_aggro", 12.0)), "p": p})
	events.append({"type": "decoy_spawn", "pos": hero.pos, "hero_id": hero.id})

## Isca mais próxima que atrai este inimigo; chefes e inimigos imóveis a ignoram.
func _decoy_for(e: Enemy) -> Dictionary:
	if decoys.is_empty() or e.is_boss() or e.speed <= 0.0:
		return {}
	var best: Dictionary = {}
	var best_d := INF
	for d in decoys:
		var dist := e.pos.distance_to(d.pos)
		if dist <= float(d.aggro) and dist < best_d:
			best = d
			best_d = dist
	return best

func _hit_decoy(d: Dictionary, amount: float) -> void:
	d.hp = float(d.hp) - amount
	events.append({"type": "hit", "pos": d.pos, "amount": int(amount), "crit": false})

func _update_decoys(dt: float) -> void:
	if decoys.is_empty():
		return
	var keep: Array = []
	for d in decoys:
		d.life = float(d.life) - dt
		if float(d.life) <= 0.0 or float(d.hp) <= 0.0:
			_detonate_decoy(d)
		else:
			keep.append(d)
	decoys = keep

func _detonate_decoy(d: Dictionary) -> void:
	var p: Dictionary = d.p
	var radius := float(p.get("blast_radius", 2.5)) * (1.0 + hero.m("area_pct"))
	var hit := {"dice": p.get("blast_dice", "3d8"), "dtype": p.get("dtype", "magico"), "attr": p.get("attr", "inteligencia"), "weaken": p.get("weaken", 0)}
	events.append({"type": "decoy_blast", "pos": d.pos, "radius": radius, "dtype": hit.dtype})
	for e in enemies:
		if not e.dead and e.pos.distance_to(d.pos) - e.radius <= radius:
			if _hero_hit(e, hit, false):
				if int(hit.weaken) > 0:
					_apply_effects(e, {"weaken": hit.weaken})

## Move o inimigo deslizando pelos eixos; se quase não saiu do lugar (obstáculo redondo no caminho),
## contorna girando o passo e mantém o lado escolhido até andar livre (BUG-012).
func _enemy_move(e: Enemy, step_v: Vector2) -> void:
	var before := e.pos
	var nx := Vector2(e.pos.x + step_v.x, e.pos.y)
	if hero.can_stand(nx, e.radius):
		e.pos = nx
	var ny := Vector2(e.pos.x, e.pos.y + step_v.y)
	if hero.can_stand(ny, e.radius):
		e.pos = ny
	var want := step_v.length()
	if want < 0.0001:
		return
	if e.pos.distance_to(before) >= want * 0.5:
		e.detour_side = 0
		return
	if e.detour_side == 0:
		e.detour_side = 1 if (int(floor(e.pos.x * 7.0)) + int(floor(e.pos.y * 7.0))) % 2 == 0 else -1
	for turn in [0.9, 1.6, 2.4]:
		for side in [e.detour_side, -e.detour_side]:
			var cand: Vector2 = e.pos + step_v.rotated(turn * float(side))
			if hero.can_stand(cand, e.radius):
				e.pos = cand
				e.detour_side = side
				return

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

func _enemy_hit_hero(bonus: int, dice: String, dtype: String, is_proj: bool, damage_mult: float = 1.0) -> void:
	if hero.dead or invuln > 0.0:
		return
	var r := Dice.d20(rng)
	if r == 1 or (r != 20 and rng.randf() >= _hit_chance(bonus, 0.0)):
		events.append({"type": "text", "pos": hero.pos, "text": "erra"})
		return
	if rng.randf() < hero.evasion(dtype, bonus):
		events.append({"type": "text", "pos": hero.pos, "text": "esquiva"})
		if _has_boon_effect("shadow_dodge"):
			invuln = maxf(invuln, 0.45)
		if _has_item_effect("dodge_empower"):
			shadow_charge = true
		return
	var dmg := float(Dice.roll(rng, dice)) * (2.0 if r == 20 else 1.0) * damage_mult
	_hurt_hero(dmg, "hit")

func _hit_chance(accuracy: int, evasion: float) -> float:
	# Bônus de ataque preserva a escala anterior do d20; evasão reduz o resultado.
	return clampf((11.0 + float(accuracy)) / 20.0, 0.10, 0.95) * (1.0 - evasion)

func _hurt_hero(dmg: float, src: String, bypass_generic_defenses: bool = false) -> void:
	if hero.dead or (invuln > 0.0 and not bypass_generic_defenses):
		return
	if active_guard > 0 and not bypass_generic_defenses:
		active_guard -= 1
		if active_guard <= 0:
			active_guard_t = 0.0
		events.append({"type": "text", "pos": hero.pos, "text": "GUARDA"})
		if String(active_def.kind) == "guard":
			for e in enemies:
				if not e.dead and e.pos.distance_to(hero.pos) <= 2.6:
					_hero_hit(e, {"dice": "2d8", "attr": "carisma", "dtype": "radiante", "knock": 1.0}, false)
		return
	if not bypass_generic_defenses:
		dmg = maxf(1.0, dmg * difficulty - hero.m("dr"))
	if barrier > 0.0 and not bypass_generic_defenses:
		var absorbed := minf(barrier, dmg)
		barrier -= absorbed
		dmg -= absorbed
		if dmg <= 0.0:
			events.append({"type": "text", "pos": hero.pos, "text": "BARREIRA"})
			return
	hero.hp -= dmg
	hero.hit_flash = 0.15
	if not bypass_generic_defenses:
		invuln = maxf(invuln, HIT_INVULN)
	stats.damage_taken += dmg
	events.append({"type": "hurt", "pos": hero.pos, "amount": int(dmg)})
	if _has_boon_effect("pain_retaliation") and not bypass_generic_defenses:
		for e in enemies:
			if not e.dead and e.pos.distance_to(hero.pos) <= 2.2:
				var retaliation := maxf(1.0, round(dmg * 0.5))
				e.hp -= retaliation
				events.append({"type": "hit", "pos": e.pos, "amount": int(retaliation), "crit": false})
				if e.hp <= 0.0:
					_kill(e)
	if hero.hp <= 0.0:
		if not free_revive_used or revive_left > 0:
			hero.hp = 0.0
			hero.dead = true
			state = "revive_offer"
			events.append({"type": "revive_offer", "pos": hero.pos})
		else:
			hero.hp = 0.0
			hero.dead = true
			state = "dead"
			death_reason = "exhausted_revives"
			events.append({"type": "dead", "pos": hero.pos})

func accept_revive() -> bool:
	if state != "revive_offer":
		return false
	if not free_revive_used:
		free_revive_used = true
	elif revive_left > 0:
		revive_left -= 1
	else:
		return false
	hero.dead = false
	hero.hp = hero.max_hp * 0.5
	invuln = 3.0
	for e in enemies:
		if e.pos.distance_to(hero.pos) < 4.0 and not e.is_boss():
			e.stun_t = 2.0
	state = "running"
	events.append({"type": "revived", "pos": hero.pos})
	events.append({"type": "toast", "text": "Segunda Chance!"})
	return true

func decline_revive() -> bool:
	if state != "revive_offer":
		return false
	state = "dead"
	death_reward_rate = 0.3
	death_reason = "declined_revive"
	events.append({"type": "dead", "pos": hero.pos})
	return true

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
	if e.split_id != "":
		for i in 2:
			_spawn(e.split_id, e.pos + Vector2(rng.randf_range(-0.6, 0.6), rng.randf_range(-0.6, 0.6)))
	if e.has_flag("quebravel"):
		## Drop garantido, mas enviesado: ouro é o mais comum; item de verdade
		## ("algo bom") é raro.
		var roll := rng.randf()
		if roll < 0.65:
			_drop("gold", e.pos, 6.0 * float(stage.coin_mult))
		elif roll < 0.85:
			_drop("potion", e.pos, 0.25)
		elif roll < 0.95:
			_drop("magnet", e.pos, 0.0)
		else:
			give_item(Items.roll(rng, tier(), hero.m("carisma") + hero.attr_mod("carisma")))
	if e.affix != "" or e.drops_chest:
		stats.elites += 1
		if e.drops_chest or rng.randf() < 0.5:
			_add_interaction("chest", e.pos)
		_drop("gold", e.pos, 12.0 * float(stage.coin_mult))
		if rng.randf() < 0.06:
			_drop("potion", e.pos, 0.25)
	if e.is_boss():
		_on_boss_dead(e)

func _on_boss_dead(e: Enemy) -> void:
	boss_dead = true
	stats.bosses += 1
	stats.boss_ids.append(e.id)
	_drop("gold", e.pos, 60.0 * float(stage.coin_mult))
	_add_interaction("chest", e.pos + Vector2(1.2, 0))
	_add_interaction("chest", e.pos + Vector2(-1.2, 0))
	_add_interaction("boss_chest", e.pos + Vector2(0, 1.6))
	events.append({"type": "toast", "text": "%s caiu!" % e.name})
	if bool(stage.get("endless", false)):
		if not final_victory:
			final_victory = true
			stats.cleared_ids.append(stage_id)
			events.append({"type": "toast", "text": "Vitória final! Continue nos Pilares ou extraia (X/norte)."})
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
		_start_postboss_fog(e.id)
		events.append({"type": "toast", "text": "Portal aberto: %s (E/oeste). Ou extraia (X/norte)." % String(stage.essence)})
	else:
		state = "won"

func _boss_presentation(boss_id: String) -> Dictionary:
	return Data.table("boss_presentations").get(boss_id, {}).duplicate(true)

func _start_boss_intro(e: Enemy) -> void:
	var presentation := _boss_presentation(e.id)
	if presentation.is_empty():
		return
	boss_intro_remaining = clampf(float(presentation.get("pause_seconds", 1.0)), 0.8, 1.2)
	events.append({"type": "boss_intro", "enemy": e, "presentation": presentation})

func _start_postboss_fog(boss_id: String) -> void:
	var presentation := _boss_presentation(boss_id)
	var config: Dictionary = presentation.get("fog", {})
	if not bool(config.get("enabled", false)):
		return
	fog_config = config.duplicate(true)
	fog_state = "grace"
	fog_elapsed = 0.0
	fog_intensity = 0.0
	events.append({"type": "postboss_fog", "state": fog_state})
	events.append({"type": "toast", "text": "A Maré de Névoa se aproxima. Extraia (X/norte) ou atravesse o portal (E/oeste)."})

func _update_postboss_fog(dt: float) -> void:
	if fog_state == "inactive":
		return
	fog_elapsed += dt
	var grace := float(fog_config.get("grace_seconds", 8.0))
	var warning := float(fog_config.get("warning_seconds", 2.0))
	if fog_elapsed < grace:
		return
	if fog_elapsed < grace + warning:
		if fog_state != "warning":
			fog_state = "warning"
			events.append({"type": "postboss_fog", "state": fog_state})
		return
	if fog_state != "advancing":
		fog_state = "advancing"
		events.append({"type": "postboss_fog", "state": fog_state})
	var advance_time := fog_elapsed - grace - warning
	var advance_seconds := maxf(1.0, float(fog_config.get("advance_seconds", 28.0)))
	fog_intensity = clampf(advance_time / advance_seconds, 0.0, 1.0)
	var edge_distance := minf(minf(hero.pos.x, map_size.x - hero.pos.x), minf(hero.pos.y, map_size.y - hero.pos.y))
	var fog_depth := minf(map_size.x, map_size.y) * 0.5 * fog_intensity
	if edge_distance > fog_depth:
		return
	_hurt_hero(hero.max_hp * fog_damage_per_second() * dt, "mare_nevoa", true)

func fog_damage_per_second() -> float:
	if fog_state != "advancing":
		return 0.0
	var ramp := maxf(1.0, float(fog_config.get("ramp_seconds", 20.0)))
	var since_advance := maxf(0.0, fog_elapsed - float(fog_config.get("grace_seconds", 8.0)) - float(fog_config.get("warning_seconds", 2.0)))
	var ratio := clampf(since_advance / ramp, 0.0, 1.0)
	return lerpf(float(fog_config.get("start_dps_pct", 0.01)), float(fog_config.get("max_dps_pct", 0.03)), ratio)

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
		"magnet":
			for p in pickups:
				p.magnet = true

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
		hero.recalc()
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

## MEC-010: o 2x só vale em fase que o perfil já venceu.
func can_speed_2x() -> bool:
	return cleared_stages.has(stage_id)

func speed_scale() -> float:
	return speed_mult if can_speed_2x() else 1.0

## Alterna 1x → 1,5x → 2x → 1x. Devolve true se a velocidade final é acelerada; em fase nova recusa e explica.
func toggle_speed() -> bool:
	if not can_speed_2x():
		speed_mult = 1.0
		events.append({"type": "toast", "text": "A velocidade extra libera depois de vencer este mapa."})
		return false
	speed_mult = 1.5 if speed_mult < 1.4 else (2.0 if speed_mult < 1.9 else 1.0)
	events.append({"type": "toast", "text": "Velocidade %s." % speed_label() if speed_mult > 1.0 else "Velocidade normal."})
	return speed_mult > 1.0

func speed_label() -> String:
	return "2x" if speed_mult > 1.9 else ("1,5x" if speed_mult > 1.4 else "1x")

## MEC-010: a Ampulheta adianta o relógio do mapa; os spawns que seriam gerados no intervalo chegam de uma vez.
func _use_hourglass() -> bool:
	var cfg: Dictionary = Data.table("difficulty").get("hourglass", {})
	if boss_spawned:
		events.append({"type": "toast", "text": "A ampulheta não tem mais efeito: o chefe já chegou."})
		return false
	var skip := minf(float(cfg.get("skip_seconds", 60.0)), float(stage.duration) - time - 5.0)
	if skip < 5.0:
		events.append({"type": "toast", "text": "Falta pouco para o chefe; a ampulheta não ajuda."})
		return false
	var burst := 0
	var burst_max := int(cfg.get("burst_max", 18))
	for w in stage.waves:
		var lo := maxf(time, float(w.t0))
		var hi := minf(time + skip, float(w.t1))
		if hi <= lo:
			continue
		var batches := int(floor((hi - lo) / (float(w.every) * SPAWN_SLOW)))
		for b in batches:
			for i in int(w.n):
				if burst >= burst_max or alive(String(w.id)) >= int(w.max):
					continue
				_spawn(String(w.id), _ring_pos())
				burst += 1
	time += skip
	events.append({"type": "toast", "text": "A ampulheta adiantou %d s! %d inimigos acumulados chegam de uma vez." % [int(skip), burst]})
	return true

func _add_interaction(kind: String, at: Vector2) -> void:
	at = at.clamp(Vector2(1, 1), map_size - Vector2(1, 1))
	interactions.append({"kind": kind, "pos": at, "used": false, "born_at": time})

func _update_interactions(dt: float) -> void:
	for it in interactions:
		if it.used:
			continue
		if time - float(it.get("born_at", 0.0)) < 0.65:
			continue
		var d: float = it.pos.distance_to(hero.pos)
		if d <= 0.8 and (it.kind == "chest" or it.kind == "boss_chest" or it.kind == "fountain"):
			it.used = true
			events.append({"type": "interaction", "kind": it.kind, "pos": it.pos})
			if it.kind == "chest" or it.kind == "boss_chest":
				_open_chest(it)
			else:
				var heal_pct := 0.4 * maxf(0.35, 1.0 - float(descent_depth) * 0.15)
				if _has_boon_effect("weak_fountains"):
					heal_pct *= 0.5
				_heal_hero(hero.max_hp * heal_pct)
				events.append({"type": "heal", "pos": hero.pos, "amount": int(hero.max_hp * heal_pct)})
				events.append({"type": "toast", "text": "Fonte: +%d%% PV" % int(round(heal_pct * 100.0))})
	interactions = interactions.filter(func(i): return not i.used)

## Interação manual (E): altar, ritual, portal, loja, ferreiro, curandeiro.
func interact() -> bool:
	if state != "running":
		return false
	var best: Dictionary = {}
	var bd := 1.6
	for it in interactions:
		if not it.used and time - float(it.get("born_at", 0.0)) >= 0.65 and it.kind in ["altar", "ritual", "portal", "loja", "ferreiro", "curandeiro", "ampulheta", "doacao", "aposta"]:
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
		"loja", "ferreiro", "curandeiro":
			_open_shop_event(String(best.kind))
		"doacao", "aposta":
			_open_risk_event(String(best.kind))
		"ampulheta":
			if not _use_hourglass():
				best.used = false
				return false
	return true

## Evento econômico: sempre pausa e sempre oferece "Sair" sem custo.
## MEC-023: a loja mostra TODAS as opções; as que o herói não paga ficam travadas (locked) com o que falta.
func _shop_row(t: String, name: String, desc: String, price: int, extra: Dictionary = {}) -> Dictionary:
	var row := {"t": t, "name": name, "desc": desc, "price": price, "locked": hero.gold < price}
	if row.locked:
		row.desc = "%s\n(faltam %d moedas)" % [desc, price - int(hero.gold)]
	row.merge(extra)
	if row.locked:
		var miss := "faltam %d" % (price - int(hero.gold))
		row["price_text"] = ("%s · %s" % [row.price_text, miss]) if row.has("price_text") else miss
	return row

func _shop_item_detail(item: Dictionary, cur: Variant, price: int) -> Dictionary:
	var cur_mods := {}
	var cur_label := "Slot livre"
	if cur != null:
		cur_mods = Items.scaled_mods(cur, int(cur.get("level", 1)))
		cur_label = "%s Nv %d" % [String(cur.name), int(cur.get("level", 1))]
	var d := Items.compare_table(item.mods, cur_mods, "%s [%s]" % [String(item.name), String(item.rarity)], cur_label)
	if int(hero.gold) >= price:
		d.footer.append("Preço %d moedas · saldo depois: %d" % [price, int(hero.gold) - price])
	else:
		d.footer.append("Preço %d moedas · faltam %d" % [price, price - int(hero.gold)])
	return d

func _forge_detail(it: Dictionary, lvl: int) -> Dictionary:
	var d := Items.compare_table(Items.scaled_mods(it, lvl + 1), Items.scaled_mods(it, lvl), "Nv %d" % (lvl + 1), "Nv %d (atual)" % lvl)
	if lvl + 1 >= Items.MAX_LEVEL:
		d.footer.append("Bônus final: %s" % Items.mods_text(Items.super_mods(it)))
	return d

## MEC-027 fase 3: toda oferta vira cartão. Sem brief próprio, o destaque é a primeira linha do desc
## e o texto completo vai para o hover quando é maior que o cartão comporta.
func _decorate_offer(o: Dictionary) -> Dictionary:
	var desc := String(o.get("desc", ""))
	var lines := desc.split("\n")
	if not o.has("brief"):
		o["brief"] = lines[0]
	if not o.has("detail") and (lines.size() > 1 or desc.length() > 58):
		o["detail"] = {"columns": [], "rows": [], "footer": Array(lines)}
	return o

func _decorate_offers() -> void:
	for o in offer:
		_decorate_offer(o)

## MEC-027: bênção e maldição de uma bênção do altar em uma linha cada (a partir dos mods).
func _boon_sign_count(b: Dictionary, positive: bool) -> int:
	var n := 0
	for k in b.get("mods", {}):
		if (float(b.mods[k]) >= 0.0) == positive:
			n += 1
	return n

func _boon_brief(b: Dictionary) -> String:
	var pos := {}
	var neg := {}
	for k in b.get("mods", {}):
		if float(b.mods[k]) >= 0.0:
			pos[k] = b.mods[k]
		else:
			neg[k] = b.mods[k]
	if pos.is_empty() and neg.is_empty():
		return String(b.desc)
	var parts: Array = []
	if not pos.is_empty():
		parts.append("Bênção: %s" % Items.mods_text(pos))
	if not neg.is_empty():
		parts.append("Maldição: %s" % Items.mods_text(neg))
	return " · ".join(parts)

func _shop_info(name: String, desc: String) -> Dictionary:
	return {"t": "shop_info", "name": name, "desc": desc, "price": 0, "locked": true}

func _open_shop_event(kind: String) -> void:
	offer = []
	match kind:
		"loja":
			for i in 2:
				var item := Items.roll(rng, tier(), hero.m("carisma") + hero.attr_mod("carisma"))
				var price := int(round((16.0 + 8.0 * float(Items.RANK[item.rarity])) * float(stage.coin_mult)))
				var cur: Variant = hero.items.get(String(item.slot))
				var compare := ""
				if cur == null:
					compare = "Slot livre (%s)." % String(item.slot)
				else:
					var cur_mods := Items.scaled_mods(cur, int(cur.get("level", 1)))
					compare = "Substitui %s Nv %d\nTroca: %s" % [String(cur.name), int(cur.get("level", 1)), Items.compare_text(item.mods, cur_mods)]
				offer.append(_shop_row("shop_item", "%s [%s] — %d moedas" % [item.name, item.rarity, price],
					"%s\n%s" % [Items.mods_text(item.mods), compare], price, {"item": item, "tooltip": compare,
						"brief": Items.brief_text(item.mods), "price_text": "%d moedas" % price,
						"badge": ({"text": "Slot livre"} if cur == null else Items.verdict(item.mods, Items.scaled_mods(cur, int(cur.get("level", 1))))),
						"detail": _shop_item_detail(item, cur, price)}))
		"ferreiro":
			var eligible: Array = hero.weapons.filter(func(w): return not w.granted and w.level < w.max_level())
			for w in eligible.slice(0, 2):
				var price := int(round((20.0 + 10.0 * float(w.level)) * float(stage.coin_mult)))
				offer.append(_shop_row("shop_weapon_up", "%s → Nv %d — %d moedas" % [w.def.name, w.level + 1, price],
					_level_desc(w), price, {"weapon_id": w.id, "brief": _level_brief(w), "badge": {"text": "Nv %d → %d" % [w.level, w.level + 1]},
						"price_text": "%d moedas" % price, "detail": {"columns": [], "rows": [], "footer": Array(_level_desc(w).split("\n"))}}))
			for slot in hero.items:
				var it: Dictionary = hero.items[slot]
				var lvl := int(it.get("level", 1))
				if String(it.get("base", "")) == "" or lvl >= Items.MAX_LEVEL:
					continue
				var item_price := int(round((25.0 + 15.0 * float(lvl)) * float(stage.coin_mult)))
				var next_desc: String = Items.upgrade_preview(it)
				if lvl + 1 >= Items.MAX_LEVEL:
					next_desc += " + bônus final: " + Items.mods_text(Items.super_mods(it))
				offer.append(_shop_row("shop_item_up", "%s → Nv %d — %d moedas" % [it.name, lvl + 1, item_price], next_desc, item_price,
					{"slot": slot, "base": String(it.base), "rarity": String(it.get("rarity", "comum")),
						"brief": "Ganho: %s" % Items.compare_text(Items.scaled_mods(it, lvl + 1), Items.scaled_mods(it, lvl)), "badge": {"text": "Nv %d → %d" % [lvl, lvl + 1]},
						"price_text": "%d moedas" % item_price, "detail": _forge_detail(it, lvl)}))
			if offer.is_empty():
				offer.append(_shop_info("Nada para melhorar", "Suas armas e equipamentos já estão no nível máximo, ou não há nada forjável equipado."))
		"curandeiro":
			var missing := hero.max_hp - hero.hp
			if missing > 1.0:
				var price := maxi(8, int(round(missing * 0.5 * float(stage.coin_mult))))
				offer.append(_shop_row("shop_heal", "Cura completa — %d moedas" % price, "Restaura %d PV." % int(ceil(missing)), price, {"amount": missing, "brief": "Restaura %d PV" % int(ceil(missing)), "price_text": "%d moedas" % price,
					"detail": {"columns": [], "rows": [], "footer": ["PV %d/%d → %d/%d" % [int(ceil(hero.hp)), int(hero.max_hp), int(hero.max_hp), int(hero.max_hp)]]}}))
			else:
				offer.append(_shop_info("Vida cheia", "Não há nada a curar agora."))
	offer.append({"t": "shop_leave", "name": "Sair", "desc": "Nada te obriga a comprar.", "price": 0})
	_decorate_offers()
	offer_kind = "shop_%s" % kind
	state = "shop"

## MEC-005: eventos de risco e recompensa. Doação: sacrifica um equipamento por uma bênção à escolha. Aposta: moedas em jogo.
func _open_risk_event(kind: String) -> void:
	offer = []
	var cfg: Dictionary = Data.table("difficulty").get("risk_events", {})
	if kind == "doacao":
		var have: Array = hero.boons.map(func(b): return b.id)
		var left: Array = Data.table("boons").boons.filter(func(b): return not (b.id in have))
		if left.is_empty() or hero.items.is_empty():
			offer.append(_shop_info("Nada a trocar", "Sem equipamento para doar ou sem bênçãos restantes."))
		else:
			for slot in hero.items:
				var it: Dictionary = hero.items[slot]
				offer.append({"t": "donate", "name": "Doar %s [%s]" % [String(it.name), String(it.rarity)],
					"desc": "Perde: %s\nGanha: uma bênção à escolha entre 3." % Items.mods_text(Items.scaled_mods(it, int(it.get("level", 1)))),
					"slot": slot, "price": 0, "locked": false,
					"brief": "Perde %s · ganha 1 bênção (escolha entre 3)" % Items.brief_text(Items.scaled_mods(it, int(it.get("level", 1)))),
					"detail": {"columns": [], "rows": [], "footer": ["Perde: %s" % Items.mods_text(Items.scaled_mods(it, int(it.get("level", 1)))), "Ganha: uma bênção à escolha entre 3."]}})
	else:
		var chance := float(cfg.get("bet_win_chance", 0.45))
		var gold := int(hero.gold)
		for pct in [0.2, 0.5, 1.0]:
			var bet := maxi(int(cfg.get("bet_min", 20)), int(round(float(gold) * pct)))
			offer.append(_shop_row("gamble", "Apostar %d moedas" % bet,
				"%d%% de chance de dobrar; %d%% de perder tudo." % [int(round(chance * 100.0)), int(round((1.0 - chance) * 100.0))], bet, {"bet": bet}))
	offer.append({"t": "shop_leave", "name": "Sair", "desc": "Nada te obriga a arriscar.", "price": 0})
	_decorate_offers()
	offer_kind = "shop_%s" % kind
	state = "shop"

func _open_chest(it: Dictionary) -> void:
	stats.chests += 1
	if String(it.kind) == "boss_chest":
		_open_boss_chest()
		return
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

## MEC-013: o baú do chefe nunca vem com item comum ou mágico (raro ou único) e nunca é mímico.
func _open_boss_chest() -> void:
	var luck := hero.m("carisma") + hero.attr_mod("carisma") + 4.0
	var item := Items.roll(rng, tier() + 1, luck)
	for i in 12:
		if int(Items.RANK[item.rarity]) >= int(Items.RANK["raro"]):
			break
		item = Items.roll(rng, tier() + 1, luck)
	events.append({"type": "toast", "text": "Baú do Chefe!", "color": Color(1.0, 0.85, 0.3)})
	give_item(item)

func give_item(item: Dictionary) -> void:
	codex.items[item.id] = true
	var slot: String = item.slot
	var cur: Variant = hero.items.get(slot)
	if cur == null:
		_equip_item(item)
		events.append({"type": "item", "item": item})
		events.append({"type": "toast", "text": "%s [%s]" % [item.name, item.rarity], "color": Items.rarity_color(item.rarity)})
		return
	var cur_now := Items.scaled_mods(cur, int(cur.get("level", 1)))
	var gold_for_cur: float = 8.0 * float(Items.RANK[cur.rarity] + 1)
	var gold_for_new: float = 8.0 * float(Items.RANK[item.rarity] + 1)
	offer = [
		{"t": "item_swap", "name": "Equipar %s [%s]" % [item.name, item.rarity],
			"desc": "%s\nContra o atual: %s\n(vende %s por %d moedas)" % [Items.mods_text(item.mods), Items.compare_text(item.mods, cur_now), cur.name, int(gold_for_cur)],
			"keep": item, "sell": cur, "equips": true, "tooltip": "Equipado agora: %s\n%s" % [cur.name, Items.mods_text(cur_now)],
			"brief": Items.brief_text(item.mods), "badge": Items.verdict(item.mods, cur_now), "price_text": "vende %s: %d" % [cur.name, int(gold_for_cur)],
			"detail": _swap_detail(item, item.mods, cur, cur_now, "vende %s por %d moedas" % [cur.name, int(gold_for_cur)])},
		{"t": "item_swap", "name": "Manter %s [%s]" % [cur.name, cur.rarity],
			"desc": "%s\nContra o novo: %s\n(vende %s por %d moedas)%s" % [Items.mods_text(cur_now), Items.compare_text(cur_now, item.mods), item.name, int(gold_for_new), _keep_hint(String(cur.slot), cur)],
			"keep": cur, "sell": item, "tooltip": "Novo item: %s\n%s" % [item.name, Items.mods_text(item.mods)],
			"brief": Items.brief_text(cur_now), "badge": Items.verdict(cur_now, item.mods), "price_text": "vende %s: %d" % [item.name, int(gold_for_new)],
			"detail": _swap_detail(cur, cur_now, item, item.mods, "vende %s por %d moedas" % [item.name, int(gold_for_new)], _keep_hint(String(cur.slot), cur).strip_edges())},
	]
	offer_kind = "item"
	state = "item_offer"
	events.append({"type": "item_offer", "new_item": item, "current_item": cur})

func _equip_item(item: Dictionary) -> void:
	var slot: String = item.slot
	hero.items[slot] = item
	var wid: String = item.get("weapon", "")
	if wid != "" and not hero.weapons.any(func(w): return w.id == wid):
		var w := Weapon.make(wid)
		w.granted = true
		hero.weapons.append(w)
		codex.weapons[wid] = true
	hero.recalc()

## A peça que não fica equipada é sempre vendida, nunca só descartada.
func _resolve_item_choice(keep: Dictionary, sell: Dictionary) -> void:
	if String(sell.get("weapon", "")) != "" and String(sell.get("weapon", "")) != String(keep.get("weapon", "")):
		hero.weapons = hero.weapons.filter(func(w): return not (w.granted and w.id == sell.weapon))
	_equip_item(keep)
	var g: float = 8.0 * float(Items.RANK[sell.rarity] + 1)
	_add_gold(g)
	events.append({"type": "toast", "text": "%s vendido (+%d moedas)" % [sell.name, int(g)], "color": Items.rarity_color(sell.rarity)})

## MEC-027: tabela do hover da troca de item (lado principal contra o outro, ambos já escalados).
func _swap_detail(main: Dictionary, main_mods: Dictionary, other: Dictionary, other_mods: Dictionary, sale_line: String, extra := "") -> Dictionary:
	var d := Items.compare_table(main_mods, other_mods, "%s [%s]" % [String(main.name), String(main.rarity)], "%s [%s]" % [String(other.name), String(other.rarity)])
	d.footer.append(sale_line)
	if extra != "":
		d.footer.append(extra)
	return d

func _keep_hint(slot: String, cur: Dictionary) -> String:
	if String(cur.get("base", "")) == "" or int(cur.get("level", 1)) >= Items.MAX_LEVEL:
		return ""
	return "\nFidelidade %d/%d: manter %d vezes seguidas sobe o nível." % [int(keep_streak.get(slot, 0)) + 1, KEEP_STREAK_NEEDED, KEEP_STREAK_NEEDED]

## MEC-021: recusar a troca 3 vezes seguidas no mesmo slot sobe o nível do item equipado (só itens com nível).
func _register_keep(slot: String) -> void:
	var cur: Variant = hero.items.get(slot)
	if cur == null or String(cur.get("base", "")) == "" or int(cur.get("level", 1)) >= Items.MAX_LEVEL:
		return
	keep_streak[slot] = int(keep_streak.get(slot, 0)) + 1
	if int(keep_streak[slot]) < KEEP_STREAK_NEEDED:
		events.append({"type": "toast", "text": "Fidelidade: %s (%d/%d)" % [String(cur.name), int(keep_streak[slot]), KEEP_STREAK_NEEDED]})
		return
	keep_streak[slot] = 0
	stats.loyalty += 1
	cur.level = int(cur.get("level", 1)) + 1
	hero.recalc()
	events.append({"type": "toast", "text": "Fidelidade recompensada: %s sobe para Nv %d!" % [String(cur.name), int(cur.level)], "color": Color(1.0, 0.85, 0.3)})

func _open_altar() -> void:
	var boons: Array = Data.table("boons").boons.duplicate()
	var have: Array = hero.boons.map(func(b): return b.id)
	boons = boons.filter(func(b): return not (b.id in have))
	_shuffle(boons)
	offer = []
	for b in boons.slice(0, 3):
		offer.append({"t": "boon", "id": b.id, "name": "%s: %s" % [b.god, b.name], "desc": "%s\n%s" % [b.desc, _boon_effect_desc(String(b.id))], "boon": b,
			"brief": _boon_brief(b), "badge": {"up": _boon_sign_count(b, true), "down": _boon_sign_count(b, false)},
			"detail": {"columns": [], "rows": [], "footer": [String(b.desc), _boon_effect_desc(String(b.id))]}})
	_decorate_offers()
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
	hero.descent_depth = descent_depth
	hero.recalc()
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
			pool.append({"t": "evolve", "id": w.id, "into": w.def.evolve.into, "name": "★ EVOLUÇÃO: %s" % evo.name, "desc": evo.desc, "weight": 9.0, "role": "synergy"})
		elif w.level < w.max_level():
			pool.append({"t": "weapon_up", "id": w.id, "name": "%s → Nv %d" % [w.def.name, w.level + 1], "desc": _level_desc(w) + (("\n" + evolve_hint(w)) if w.def.has("evolve") else ""), "weight": 3.0, "role": "synergy",
				"brief": _level_brief(w), "badge": {"text": "Nv %d → %d" % [w.level, w.level + 1]}})
		var syn: Dictionary = w.def.get("synergy", {})
		if not syn.is_empty() and not hero.synergies.has(w.id) and _has_maxed_accessory(String(syn.item_base)):
			pool.append({"t": "synergy_activate", "id": w.id, "name": "SINERGIA: %s" % String(syn.name), "desc": "%s por camada descida (agora: ×%d)." % [Items.mods_text(syn.bonus_per_depth), maxi(1, descent_depth)], "weight": 9.0, "role": "synergy"})
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
			pool.append({"t": "passive", "id": pid, "name": "%s → Nv %d" % [pdata[pid].name, lv + 1], "desc": pdata[pid].desc, "weight": 3.0, "role": "synergy", "badge": {"text": "Nv %d → %d" % [lv, lv + 1]}})
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
	for o in out:
		_decorate_offer(o)
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

## MEC-018: dano mínimo e máximo da arma com os atributos e bônus atuais do herói (sem crítico, que dobra).
func weapon_damage_range(p: Dictionary) -> Vector2i:
	var dice := String(p.get("dice", ""))
	if dice == "":
		return Vector2i.ZERO
	var b := Dice.bounds(dice)
	var flat := hero.attr_mod(String(p.get("attr", "forca"))) + int(p.get("dmg", 0)) + int(hero.m("dmg_flat"))
	var pct := maxf(0.2, 1.0 + hero.m("dmg_pct"))
	return Vector2i(maxi(1, int(round(float(b.x + flat) * pct))), maxi(1, int(round(float(b.y + flat) * pct))))

func weapon_damage_text(p: Dictionary) -> String:
	var r := weapon_damage_range(p)
	if r == Vector2i.ZERO:
		return ""
	var attrs := {"forca": "FOR", "inteligencia": "INT", "carisma": "CAR", "constituicao": "CON"}
	var types := {"fisico": "físico", "magico": "mágico", "radiante": "radiante", "fogo": "fogo"}
	return "Dano %d–%d (%s, escala com %s)" % [r.x, r.y, types.get(String(p.get("dtype", "fisico")), String(p.get("dtype", "fisico"))), attrs.get(String(p.get("attr", "forca")), "FOR")]

## MEC-008: como evoluir a arma (nível máximo + passiva) e o que ainda falta.
func evolve_hint(w: Weapon) -> String:
	if not w.def.has("evolve"):
		return ""
	var pname := String(Data.table("passives").get(String(w.def.evolve.passive), {}).get("name", String(w.def.evolve.passive)))
	var into := String(Data.table("weapons").get(String(w.def.evolve.into), {}).get("name", String(w.def.evolve.into)))
	var missing: Array = []
	if w.level < Weapon.MAX_LEVEL:
		missing.append("nível %d (agora %d)" % [Weapon.MAX_LEVEL, w.level])
	if int(hero.passives.get(String(w.def.evolve.passive), 0)) <= 0:
		missing.append("passiva %s" % pname)
	if missing.is_empty():
		return "Pronta para evoluir em %s: escolha a evolução no próximo level-up." % into
	return "Evolui em %s com nível %d + passiva %s. Falta: %s." % [into, Weapon.MAX_LEVEL, pname, ", ".join(missing)]

func _level_desc(w: Weapon) -> String:
	var lv: Array = w.def.get("levels", [])
	if w.level - 1 >= lv.size():
		return ""
	var labels := {"dice": "dado", "cd": "recarga (s)", "cone": "cone", "dmg": "dano", "range": "alcance", "stun": "atordoamento", "radius": "raio",
		"pierce": "perfuração", "count": "projéteis", "weaken": "enfraquece", "duration": "duração", "heal": "cura", "mark": "marca",
		"gold_hit": "moedas/golpe", "knock": "empurrão", "burn": "queimadura", "lifesteal": "roubo de vida", "slow": "lentidão"}
	var parts: Array = []
	for k in lv[w.level - 1]:
		var v: Variant = lv[w.level - 1][k]
		parts.append("%s %s" % [labels.get(k, k), v if k == "dice" else "%+.1f" % float(v)])
	var text := ", ".join(parts)
	var next_p := Weapon.make(w.id, w.level + 1).params()
	var r_now := weapon_damage_range(w.params())
	var r_next := weapon_damage_range(next_p)
	if r_now != Vector2i.ZERO and r_next != r_now:
		text += "\nDano %d–%d → %d–%d" % [r_now.x, r_now.y, r_next.x, r_next.y]
	return text

## MEC-027: destaque do cartão de melhoria de arma: a faixa de dano quando existe, senão a primeira linha.
func _level_brief(w: Weapon) -> String:
	var lines := _level_desc(w).split("\n")
	for l in lines:
		if l.begins_with("Dano"):
			return l
	return lines[0]

func _has_maxed_accessory(base_id: String) -> bool:
	for slot in hero.items:
		var it: Dictionary = hero.items[slot]
		if String(it.get("base", "")) == base_id and int(it.get("level", 1)) >= Items.MAX_LEVEL:
			return true
	return false

func choose(i: int) -> void:
	if state != "levelup" and state != "altar" and state != "item_offer" and state != "shop":
		return
	if i < 0 or i >= offer.size():
		return
	var c: Dictionary = offer[i]
	if state == "shop":
		if bool(c.get("locked", false)):
			return  # sem moedas ou linha informativa: a loja continua aberta
		match String(c.t):
			"shop_item":
				if hero.gold >= int(c.price):
					hero.gold -= int(c.price)
					give_item(c.item)
			"shop_weapon_up":
				if hero.gold >= int(c.price):
					for w in hero.weapons:
						if w.id == c.weapon_id and not w.granted:
							w.level += 1
							hero.gold -= int(c.price)
							break
			"shop_heal":
				if hero.gold >= int(c.price):
					hero.gold -= int(c.price)
					_heal_hero(float(c.amount))
			"donate":
				var donated: Dictionary = hero.items.get(String(c.slot), {})
				if not donated.is_empty():
					hero.items.erase(String(c.slot))
					var donated_weapon := String(donated.get("weapon", ""))
					if donated_weapon != "":
						hero.weapons = hero.weapons.filter(func(w): return not (w.granted and w.id == donated_weapon))
					hero.recalc()
					events.append({"type": "toast", "text": "%s foi doado ao altar." % String(donated.name)})
					_open_altar()
					return
			"gamble":
				var risk: Dictionary = Data.table("difficulty").get("risk_events", {})
				if hero.gold >= int(c.bet):
					if rng.randf() < float(risk.get("bet_win_chance", 0.45)):
						stats.bets_won += 1
						hero.gold += int(c.bet)  # ganho não entra em stats.gold: não infla a recompensa da run
						events.append({"type": "toast", "text": "A sorte sorri: +%d moedas!" % int(c.bet), "color": Color(1.0, 0.85, 0.3)})
					else:
						hero.gold -= int(c.bet)
						events.append({"type": "toast", "text": "A casa vence: -%d moedas." % int(c.bet), "color": Color(0.9, 0.4, 0.4)})
			"shop_item_up":
				if hero.gold >= int(c.price) and hero.items.has(String(c.slot)):
					hero.items[String(c.slot)].level = int(hero.items[String(c.slot)].get("level", 1)) + 1
					hero.gold -= int(c.price)
					hero.recalc()
		if state == "item_offer":
			return
		state = "running"
		offer.clear()
		return
	match String(c.t):
		"item_swap":
			_resolve_item_choice(c.keep, c.sell)
			if c.get("equips", false):
				keep_streak[String(c.keep.slot)] = 0
				events.append({"type": "item", "item": c.keep})
			else:
				_register_keep(String(c.keep.slot))
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
					_cine_queue.append({"from": String(w.id), "into": String(c.into), "passive": String(w.def.get("evolve", {}).get("passive", "")), "level": w.level})
					nw.granted = w.granted
					hero.weapons[hero.weapons.find(w)] = nw
					codex.weapons[String(c.into)] = true
					break
		"synergy_activate":
			hero.synergies[String(c.id)] = true
			hero.recalc()
		"passive":
			hero.passives[c.id] = int(hero.passives.get(c.id, 0)) + 1
		"heal":
			hero.hp = minf(hero.max_hp, hero.hp + hero.max_hp * 0.4)
		"gold":
			_add_gold(40.0)
		"boon":
			hero.boons.append(c.boon)
	if offer_kind == "item":
		state = "running"
		offer.clear()
		return
	var offered_boon: Dictionary = c.get("boon", {})
	var chosen_god := String(c.get("god", offered_boon.get("god", "")))
	if offer_kind == "altar" and DivineVisuals.is_divine_affinity(chosen_god):
		visual_god = chosen_god
		visual_boon_selected = true
		events.append({"type": "divinity", "god": visual_god})
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
		if p.x > 1.0 and p.y > 1.0 and p.x < map_size.x - 1.0 and p.y < map_size.y - 1.0 and hero.can_stand(p, 0.4):
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
	_spawn_serial += 1
	e.flank_side = _flank_side_for(e, _spawn_serial)
	enemies.append(e)
	codex.enemies[id] = codex.enemies.get(id, false)
	return e

## MEC-011: parte dos perseguidores contorna pelos lados em vez de formar fila (sem consumir o RNG da run).
func _flank_side_for(e: Enemy, serial: int) -> int:
	if e.is_boss() or e.move != "chase" or e.speed <= 0.0:
		return 0
	var share := float(Data.table("difficulty").get("flank", {}).get("share", 0.0))
	if share <= 0.0 or float((serial * 37) % 100) / 100.0 >= share:
		return 0
	return 1 if serial % 2 == 0 else -1

## Direção de perseguição: quem flanqueia abre um arco que fecha ao chegar perto do herói.
func _chase_dir(e: Enemy, dir: Vector2, dist: float) -> Vector2:
	if e.flank_side == 0:
		return dir
	var f: Dictionary = Data.table("difficulty").get("flank", {})
	var reach := float(f.get("close_distance", 2.5))
	var span := maxf(1.0, float(f.get("open_distance", 10.0)) - reach)
	var arc := float(f.get("max_arc", 1.0)) * clampf((dist - reach) / span, 0.0, 1.0)
	return dir.rotated(arc * float(e.flank_side))

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

## MEC-024: força da abertura de cada fase, 1.0 no começo, constante por hold_seconds e decaindo até 0 em fade_seconds.
func opening_factor() -> float:
	var o: Dictionary = Data.table("difficulty").get("opening", {})
	var hold := float(o.get("hold_seconds", 0.0))
	var fade := float(o.get("fade_seconds", 0.0))
	if fade <= hold or time >= fade:
		return 0.0
	return 1.0 if time <= hold else 1.0 - (time - hold) / (fade - hold)

func _director(dt: float) -> void:
	var opening := opening_factor()
	var o: Dictionary = Data.table("difficulty").get("opening", {})
	var cap := int(stage.cap) + int(minute()) * 3 + int(round(float(o.get("cap_bonus", 0)) * opening))
	if enemies.size() < cap:
		for wi in stage.waves.size():
			var w: Dictionary = stage.waves[wi]
			if time < float(w.t0) or time > float(w.t1):
				continue
			_acc[wi] = float(_acc.get(wi, 0.0)) + dt
			var every := float(w.every) * SPAWN_SLOW * lerpf(1.0, float(o.get("every_mult", 1.0)), opening)
			if _acc[wi] >= every:
				_acc[wi] = 0.0
				var max_alive := int(ceil(float(w.max) * lerpf(1.0, float(o.get("max_mult", 1.0)), opening)))
				var per_wave := int(ceil(float(w.n) * lerpf(1.0, float(o.get("n_mult", 1.0)), opening)))
				var room := max_alive - alive(String(w.id))
				for i in mini(per_wave, room):
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
		_start_boss_intro(boss)
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
	_breakable_t -= dt
	if _breakable_t <= 0.0:
		_breakable_t = _breakable_interval()
		_spawn_random_breakable()

## MEC-026: interromper o ritual dá uma bênção temporária (dados em data/difficulty.json).
func _grant_ritual_blessing() -> void:
	var b: Dictionary = Data.table("difficulty").get("ritual_blessing", {})
	if b.is_empty():
		return
	hero.temp_mods = b.mods.duplicate()
	hero.temp_t = float(b.duration)
	hero.recalc()
	events.append({"type": "toast", "text": "Bênção do Selo: %s por %d s" % [Items.mods_text(hero.temp_mods), int(hero.temp_t)]})

## MEC-007: quebráveis mais frequentes; o Carisma encurta o intervalo (até -40%).
func _breakable_interval() -> float:
	var cfg: Dictionary = Data.table("difficulty").get("breakables", {})
	var base := float(cfg.get("min_seconds", 35.0)) + rng.randf() * float(cfg.get("spread_seconds", 20.0))
	return base * clampf(1.0 - float(cfg.get("charisma_step", 0.0)) * float(hero.attr_mod("carisma")), 0.6, 1.0)

func _spawn_random_breakable() -> void:
	var types: Array = BREAKABLE_TYPES_BY_STAGE.get(stage_id, BREAKABLE_DEFAULT_TYPES)
	if types.is_empty():
		return
	var id: String = types[rng.randi() % types.size()]
	var ang := rng.randf() * TAU
	_spawn(id, hero.pos + Vector2(cos(ang), sin(ang)) * rng.randf_range(6.0, 11.0))

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
	# O Estige é uma camada ambiental comum: a regra principal do andar continua
	# em paralelo, sem uma cópia de timers ou RNG por mapa.
	if has_styx_contract():
		_styx_step(dt)
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

func _stage_event_step() -> void:
	for event_def in stage_events:
		var event_id := String(event_def.get("id", ""))
		if event_id == "" or _stage_events_done.has(event_id):
			continue
		var at := float(event_def.get("at", 0.0))
		var warning := float(event_def.get("warning", 5.0))
		var warning_key := "%s.warning" % event_id
		if time >= at - warning and not _stage_events_done.has(warning_key):
			_stage_events_done[warning_key] = true
			events.append({"type": "stage_event_warning", "id": event_id, "text": String(event_def.get("warning_text", event_def.get("title", ""))), "pos": hero.pos})
		if time >= at:
			_stage_events_done[event_id] = true
			_fire_stage_event(event_def)

func _fire_stage_event(event_def: Dictionary) -> void:
	var kind := String(event_def.get("kind", ""))
	var at := _ring_pos()
	match kind:
		"ritual":
			zones.append({"owner": "stage", "kind": "rule_ritual", "pos": at, "radius": 1.7, "delay": float(stage_rule.get("delay", 7.0)), "total": float(stage_rule.get("delay", 7.0)),
				"interrupt": float(stage_rule.get("interrupt", 1.5)), "progress": 0.0, "life": 99.0})
		"hazard":
			zones.append({"owner": "stage", "kind": "puddle", "pos": at, "radius": 1.35, "grows": true, "delay": 0.0, "life": 10.0, "acc": 0.0})
		"wave":
			for i in int(event_def.get("count", 1)):
				_spawn(String(event_def.get("enemy_id", "zumbi")), at + Vector2(rng.randf_range(-1.4, 1.4), rng.randf_range(-1.4, 1.4)))
		"elite":
			_spawn_elite(String(event_def.get("enemy_id", "criatura_corrompida")), at)
	events.append({"type": "stage_event", "id": String(event_def.get("id", "")), "text": String(event_def.get("result_text", event_def.get("title", ""))), "pos": at})

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
			if stage_id == "durao":
				_styx_step(dt)
				return
			_cur_angle += 0.12 * dt
			var current := Vector2(cos(_cur_angle), sin(_cur_angle)) * float(stage_rule.get("force", 0.9))
			hero.push += current
			for pickup in pickups:
				pickup.pos = (pickup.pos + current * dt * 0.5).clamp(Vector2.ZERO, map_size)
			for e in enemies:
				if not e.dead and not e.is_boss():
					e.pos = (e.pos + current * dt * 0.25).clamp(Vector2(0.5, 0.5), map_size - Vector2(0.5, 0.5))
		"styx_memory":
			pass # Já aplicado pela camada ambiental compartilhada acima.
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
				events.append({"type": "toast", "text": "Ritual da Névoa: fique no selo para impedir os reforços!"})
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

func _styx_step(dt: float) -> void:
	while not _styx_loss_expiry.is_empty() and run_time >= float(_styx_loss_expiry[0]):
		_styx_loss_expiry.pop_front()
		hero.styx_lucidity_loss = maxi(0, hero.styx_lucidity_loss - 1)
		events.append({"type": "toast", "text": "A lucidez volta: -1 de perda de INT."})
	var in_water := TerrainLayout.is_styx_water(stage_id, hero.pos)
	if not in_water:
		if styx_in_water and styx_exposure >= 2.0:
			var duration := minf(floor(styx_exposure), 6.0)
			hero.styx_forget_t = maxf(hero.styx_forget_t, duration)
			events.append({"type": "styx_forget", "pos": hero.pos, "duration": duration})
		styx_exposure = 0.0
		styx_test_next = 1.0
		styx_in_water = false
		return
	if not styx_in_water:
		styx_in_water = true
		_styx_lucidity_test(11)
	styx_exposure += dt
	while styx_exposure >= styx_test_next:
		_styx_lucidity_test(mini(16, 11 + int(styx_test_next)))
		styx_test_next += 1.0

func has_styx_contract() -> bool:
	return "styx_memory" in stage.get("ambient", [])

func _styx_lucidity_test(dc: int) -> void:
	var roll := styx_rng.randi_range(1, 20)
	var total := roll + hero.styx_intelligence_mod() + maxi(0, hero.cam() - 10)
	var passed := total >= dc
	if not passed:
		hero.styx_lucidity_loss += 1
		_styx_loss_expiry.append(run_time + float(Data.table("difficulty").get("styx_lucidity_seconds", 300.0)))
	events.append({"type": "styx_test", "pos": hero.pos, "passed": passed, "roll": roll, "dc": dc, "loss": hero.styx_lucidity_loss})

# ------------------------------------------------------------------ resultado

func result() -> Dictionary:
	return {"won": state == "won", "dead": state == "dead", "extracted": extracted, "time": run_time, "kills": stats.kills,
		"gold": int(round(stats.gold * reward_multiplier())), "raw_gold": int(stats.gold), "reward_mult": reward_multiplier(), "descent_depth": descent_depth,
		"level": hero.level, "stage": stage_id, "hero": hero.id, "bosses": stats.bosses, "boss_ids": stats.boss_ids, "elites": stats.elites, "crits": stats.crits,
		"ones": stats.ones, "rituals": stats.rituals, "bets_won": stats.bets_won, "loyalty": stats.loyalty, "chests": stats.chests, "stages_cleared": stats.stages_cleared, "stage_ids": stats.stage_ids, "cleared_ids": stats.cleared_ids, "final_victory": final_victory, "weapons": hero.weapons.map(func(w): return w.id), "codex": codex,
		"reward_rate": death_reward_rate if state == "dead" else 1.0, "death_reason": death_reason}
