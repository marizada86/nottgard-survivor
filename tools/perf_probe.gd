extends Node
## PLAN-098 (SPEC-171): medicao de desempenho e prova de equivalencia. Somente leitura sobre o jogo.
##   godot --headless --path . res://tools/perf_probe.tscn -- sim   [segundos=300] [semente=7] [heroi=durvall] [fases=todas|id,id]
##   godot --headless --path . res://tools/perf_probe.tscn -- scene [quadros=900]  [semente=7] [heroi=durvall] [fases=todas|id,id]
## sim:   joga Battle sem janela com politica fixa (sem aleatoriedade global). Por fase: custo de step() (real) e por sub-rotina
##        (replica do step), e o hash do estado final. Dois hashes iguais antes/depois de uma otimizacao provam que o
##        resultado nao mudou. A replica tambem e comparada com o step real (fidelidade da medicao).
## scene: abre ui/run.tscn por quadros e mede o custo de CPU por quadro (sem GPU), nos, orfaos e inimigos.
## Saida: linhas "PROBE;..." faceis de comparar; resumo no fim.

const SECTIONS := ["effect_timers", "stage_rule", "stage_event", "hero_step", "kinds", "happenings_post", "postboss_fog", "world_mod",
	"edge_fog", "grid", "weapons", "projectiles", "zones", "decoys", "happenings", "enemies", "filter", "pickups", "interactions",
	"ecos", "director"]

var _dt := 1.0 / 60.0
var _with_scenery := true

func _ready() -> void:
	var a := OS.get_cmdline_user_args()
	var mode: String = a[0] if a.size() > 0 else "sim"
	var amount := float(a[1]) if a.size() > 1 else (300.0 if mode == "sim" else 900.0)
	var seed_v := int(a[2]) if a.size() > 2 else 7
	var hero: String = a[3] if a.size() > 3 else "durvall"
	var stage_arg: String = a[4] if a.size() > 4 else "todas"
	_with_scenery = not (a.size() > 5 and a[5] == "vazio")
	var stages: Array = _stage_ids() if stage_arg == "todas" else Array(stage_arg.split(","))
	Playtest.visible = false
	Game._save_path = "user://perf-probe-profile.json"   # nunca o save real
	Game.profile = Profile.new({"name": "Probe", "welcome_seen": true})
	print("PROBE;modo=%s;quantidade=%s;semente=%d;heroi=%s;fases=%s;godot=%s" % [mode, str(amount), seed_v, hero, ",".join(stages), Engine.get_version_info().string])
	if mode == "funcoes":
		_funcs_mode(amount, seed_v, hero, stages)
	elif mode == "scene":
		await _scene_mode(int(amount), seed_v, hero, stages)
	else:
		_sim_mode(amount, seed_v, hero, stages)
	print("PROBE;fim")
	get_tree().quit()

func _stage_ids() -> Array:
	var ids: Array = Data.table("stages").keys()
	ids.sort_custom(func(x, y): return int(Data.table("stages")[x].order) < int(Data.table("stages")[y].order))
	return ids

# ------------------------------------------------------------------ sim

func _sim_mode(seconds: float, seed_v: int, hero: String, stages: Array) -> void:
	var total_real := 0.0
	var all_equal := true
	for sid in stages:
		var real := _run(seed_v, hero, sid, seconds, false)
		var rep := _run(seed_v, hero, sid, seconds, true)
		var same: bool = real.hash == rep.hash
		all_equal = all_equal and same
		total_real += float(real.wall)
		var steps: int = real.steps
		var lat: PackedInt32Array = real.lat
		lat.sort()
		var p95: int = lat[int(lat.size() * 0.95)] if lat.size() > 0 else 0
		var avg: float = float(real.wall) * 1000000.0 / maxf(1.0, steps)
		print("PROBE;fase=%s;passos=%d;fim=%s;t=%.0fs;bloqueios=%d;inimigos_medio=%.1f;inimigos_max=%d;us_passo_medio=%.1f;us_p95=%d;us_max=%d;hash_real=%s;hash_replica=%s;replica_fiel=%s" % [
			sid, steps, real.state, real.time, real.blockers, real.enemy_avg, real.enemy_max, avg, p95, lat[lat.size() - 1] if lat.size() > 0 else 0, str(real.hash), str(rep.hash), str(same)])
		var acc: Dictionary = rep.sections
		var tot := 0.0
		for k in acc:
			tot += float(acc[k])
		var parts: Array = []
		var keys: Array = acc.keys()
		keys.sort_custom(func(x, y): return float(acc[x]) > float(acc[y]))
		for k in keys.slice(0, 8):
			parts.append("%s=%.1f%%(%.1fus)" % [k, 100.0 * float(acc[k]) / maxf(1.0, tot), float(acc[k]) / maxf(1.0, steps)])
		print("PROBE;fase=%s;secoes=%s" % [sid, ",".join(parts)])
		var spikes: Array = []
		var smax: Dictionary = rep.sec_max
		var skeys: Array = smax.keys()
		skeys.sort_custom(func(x, y): return int(smax[x]) > int(smax[y]))
		for k in skeys.slice(0, 4):
			spikes.append("%s=%dus@passo%d" % [k, int(smax[k]), int(rep.sec_worst_step[k])])
		print("PROBE;fase=%s;picos=%s" % [sid, ",".join(spikes)])
	print("PROBE;resumo;tempo_real_total=%.2fs;replica_fiel_em_todas=%s" % [total_real, str(all_equal)])

func _funcs_mode(seconds: float, seed_v: int, hero: String, stages: Array) -> void:
	_use_timed = true
	for sid in stages:
		TimedBattle.spans = {}
		var r := _run(seed_v, hero, sid, seconds, false)
		var spans: Dictionary = TimedBattle.spans
		var keys: Array = spans.keys()
		keys.sort_custom(func(x, y): return int(spans[x].max) > int(spans[y].max))
		var parts: Array = []
		for k in keys.slice(0, 7):
			var s: Dictionary = spans[k]
			parts.append("%s=max%dus@t%.1fs(n=%d,medio=%.1fus)" % [k, int(s.max), float(s.at_time), int(s.count), float(s.total) / maxf(1.0, float(s.count))])
		print("PROBE;fase=%s;bloqueios=%d;funcoes_por_pico=%s" % [sid, r.blockers, ",".join(parts)])
		var by_total: Array = spans.keys()
		by_total.sort_custom(func(x, y): return int(spans[x].total) > int(spans[y].total))
		var tparts: Array = []
		for k in by_total.slice(0, 5):
			tparts.append("%s=%.0fms" % [k, float(spans[k].total) / 1000.0])
		print("PROBE;fase=%s;funcoes_por_total=%s" % [sid, ",".join(tparts)])
	_use_timed = false

var _use_timed := false

## Uma rodada. replica=false usa Battle.step; true usa a copia cronometrada do step. Politica determinista.
func _run(seed_v: int, hero_id: String, stage_id: String, seconds: float, replica: bool) -> Dictionary:
	seed(seed_v)   # nada deveria depender do RNG global; se depender, a semente fixa o resultado
	var b: Battle = TimedBattle.new(seed_v, hero_id, stage_id, {}) if _use_timed else Battle.new(seed_v, hero_id, stage_id, {})
	var blockers := _prepare_scenery(b, stage_id)
	var sections := {}
	_sec_max = {}
	_sec_worst_step = {}
	_cur_step = 0
	for k in SECTIONS:
		sections[k] = 0
		_sec_max[k] = 0
		_sec_worst_step[k] = 0
	var lat := PackedInt32Array()
	var steps := 0
	var enemy_sum := 0
	var enemy_max := 0
	var max_steps := int(seconds / _dt)
	var wall_start := Time.get_ticks_usec()
	while steps < max_steps:
		if b.state == "levelup" or b.state == "altar":
			b.choose(_pick(b))
			continue
		if b.state == "item_offer":
			var equip_index := 0   # L1: o atual vem primeiro; estas ferramentas sempre equipavam o novo
			for oi in b.offer.size():
				if bool(b.offer[oi].get("equips", false)):
					equip_index = oi
			b.choose(equip_index)
			continue
		if b.state == "dead" or b.state == "revive_offer" or b.state == "won":
			break
		if steps % 30 == 0:
			b.hero.hp = b.hero.max_hp   # nao morre: o objetivo e medir, nao jogar
		if b.active_cd <= 0.0 and not b.enemies.is_empty():
			var target := b.nearest(b.hero.pos, 10.0)
			b.use_active((target.pos - b.hero.pos).normalized() if target != null else Vector2(1, 0))
		var dir := _move(b)
		var t0 := Time.get_ticks_usec()
		if replica:
			_step_timed(b, dir, _dt, sections)
		else:
			b.step(dir, _dt)
		lat.append(Time.get_ticks_usec() - t0)
		_cur_step = steps
		b.events.clear()
		_interact(b)
		if b.stage_cleared and b.stage.get("next", "") != "":
			for it in b.interactions:
				if it.kind == "portal" and not it.used:
					b.hero.pos = it.pos
					b.interact()
		steps += 1
		enemy_sum += b.enemies.size()
		enemy_max = maxi(enemy_max, b.enemies.size())
	var wall := float(Time.get_ticks_usec() - wall_start) / 1000000.0
	var lat_sum := 0
	for v in lat:
		lat_sum += v
	return {"steps": steps, "state": b.state, "time": b.time, "enemy_avg": float(enemy_sum) / maxf(1.0, steps), "enemy_max": enemy_max,
		"wall": float(lat_sum) / 1000000.0, "lat": lat, "sections": sections, "hash": _state_hash(b), "wall_total": wall,
		"blockers": blockers, "sec_max": _sec_max.duplicate(), "sec_worst_step": _sec_worst_step.duplicate()}

var _sec_max := {}
var _sec_worst_step := {}
var _cur_step := 0

## Reproduz o que ui/run.gd faz ao abrir a fase para o que importa ao custo: tamanho do mapa, bloqueios do cenario
## (props + estruturas) e destrutiveis. Sem isto os inimigos andam num mapa vazio e o custo de colisao some.
func _prepare_scenery(b: Battle, stage_id: String) -> int:
	if not _with_scenery:
		return 0
	var scene: PackedScene = load("res://ui/stages/%s.tscn" % stage_id)
	var root: Node = scene.instantiate()
	add_child(root)
	var sorted: Node = root.get_node("Sorted")
	var ground: Node2D = root.get_node("Ground")
	var msize := Vector2(ground.map_size)
	TerrainLayout.scale = msize.x / 40.0
	b.map_size = msize
	b.hero.map_size = msize
	b.hero.terrain_id = String(ground.get("terrain_layout_id"))
	b.hero.pos = Iso.to_ground(sorted.get_node("Hero").position)
	SceneryLayout.apply(sorted, stage_id, b.hero.pos, msize)
	b.hero.blockers.clear()
	for p in sorted.get_children():
		if p.is_in_group("blockers"):
			var g := Iso.to_ground(p.position)
			b.hero.blockers.append(Vector3(g.x, g.y, p.block_radius))
	StageStructures.attach_for_stage(sorted, stage_id, b.hero.pos, msize, b.hero.blockers)
	b.place_scenery()
	var n := b.hero.blockers.size()
	root.queue_free()
	return n

## Copia de Battle.step (ramo "running") com cronometro. A fidelidade e provada pelo hash igual ao do step real.
func _step_timed(b: Battle, screen_dir: Vector2, dt: float, acc: Dictionary) -> void:
	if b.state == "evolve_cine" or b.state != "running" or b.hero.dead or b.boss_intro_remaining > 0.0 or (not b._cine_queue.is_empty()):
		b.step(screen_dir, dt)
		return
	b.time += dt
	b.run_time += dt
	if b.tide_kills > 0 and b.time - b.tide_last_t > Battle.TIDE_WINDOW:
		b.tide_kills = 0
	var t := Time.get_ticks_usec()
	b._update_effect_timers(dt)
	t = _lap(acc, "effect_timers", t)
	b.invuln = maxf(0.0, b.invuln - dt)
	b.hero.push = Vector2.ZERO
	b._hero_moving = screen_dir != Vector2.ZERO
	b.still_t = 0.0 if b._hero_moving else b.still_t + dt
	b.stats.still_best = maxf(float(b.stats.still_best), b.still_t)
	t = Time.get_ticks_usec()
	b._stage_rule_step(dt)
	t = _lap(acc, "stage_rule", t)
	b._stage_event_step()
	t = _lap(acc, "stage_event", t)
	b.hero.step(screen_dir, dt)
	t = _lap(acc, "hero_step", t)
	b.kinds.step(b, dt)
	t = _lap(acc, "kinds", t)
	b.happenings.post_hero_step(b)
	t = _lap(acc, "happenings_post", t)
	b._update_postboss_fog(dt)
	t = _lap(acc, "postboss_fog", t)
	b._update_world_mod(dt)
	t = _lap(acc, "world_mod", t)
	b._update_edge_fog(dt)
	t = _lap(acc, "edge_fog", t)
	if b.hero.m("regen") > 0.0:
		b._heal_hero(b.hero.m("regen") * dt)
	t = Time.get_ticks_usec()
	b._build_grid()
	t = _lap(acc, "grid", t)
	b._update_weapons(dt)
	t = _lap(acc, "weapons", t)
	b._update_projectiles(dt)
	t = _lap(acc, "projectiles", t)
	b._update_zones(dt)
	t = _lap(acc, "zones", t)
	b._update_decoys(dt)
	t = _lap(acc, "decoys", t)
	b.happenings.step(b, dt)
	t = _lap(acc, "happenings", t)
	for e in b.enemies:
		if not e.dead:
			b._enemy_step(e, dt)
	t = _lap(acc, "enemies", t)
	b.enemies = b.enemies.filter(func(x): return not x.dead)
	t = _lap(acc, "filter", t)
	b._update_pickups(dt)
	t = _lap(acc, "pickups", t)
	b._update_interactions(dt)
	t = _lap(acc, "interactions", t)
	b._update_ecos()
	t = _lap(acc, "ecos", t)
	b._director(dt)
	_lap(acc, "director", t)

func _lap(acc: Dictionary, name: String, since: int) -> int:
	var now := Time.get_ticks_usec()
	acc[name] = int(acc[name]) + (now - since)
	if now - since > int(_sec_max[name]):
		_sec_max[name] = now - since
		_sec_worst_step[name] = _cur_step
	return now

## Hash do estado observavel: o que um jogador veria ou que decide o resultado da partida.
func _state_hash(b: Battle) -> int:
	var parts: Array = ["%d" % b.enemies.size(), "%.4f" % b.time, "%.4f" % b.run_time, "%.3f" % b.hero.hp, "%d" % b.hero.level,
		"%.4f,%.4f" % [b.hero.pos.x, b.hero.pos.y], "%d" % b.projectiles.size(), "%d" % b.pickups.size(), "%d" % b.zones.size(),
		str(b.stats), b.state, b.stage_id]
	var ex := 0.0
	var ey := 0.0
	var ehp := 0.0
	for e in b.enemies:
		ex += e.pos.x
		ey += e.pos.y
		ehp += e.hp
	parts.append("%.3f,%.3f,%.3f" % [ex, ey, ehp])
	for w in b.hero.weapons:
		parts.append("%s%d" % [w.id, int(w.level)])
	return "|".join(parts).hash()

func _pick(b: Battle) -> int:
	var best := 0
	var best_s := -1.0
	for i in b.offer.size():
		var s := 1.0
		match String(b.offer[i].t):
			"evolve": s = 10.0
			"weapon_up": s = 6.0
			"weapon_new": s = 4.0 if b.hero.weapons.size() < 3 else 2.0
			"passive": s = 3.0
			"boon": s = 5.0
			"heal": s = 2.0
		if s > best_s:
			best_s = s
			best = i
	return best

func _interact(b: Battle) -> void:
	for it in b.interactions:
		if not it.used and it.kind in ["altar"] and it.pos.distance_to(b.hero.pos) < 1.6:
			b.interact()
			return

## Politica do bot de balanceamento (afastar de inimigos, desviar de projeteis, recolher), sem aleatoriedade.
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
	for p in b.projectiles:
		if p.owner == "enemy":
			var off: Vector2 = h.pos - p.pos
			var d := off.length()
			if d < 3.0 and d > 0.01:
				var perp := Vector2(-p.dir.y, p.dir.x)
				v += perp * (1.0 if perp.dot(off) >= 0.0 else -1.0) * 1.5 / maxf(0.5, d)
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
	var m := 3.0
	if h.pos.x < m: v.x += (m - h.pos.x)
	if h.pos.y < m: v.y += (m - h.pos.y)
	if h.pos.x > b.map_size.x - m: v.x -= (h.pos.x - (b.map_size.x - m))
	if h.pos.y > b.map_size.y - m: v.y -= (h.pos.y - (b.map_size.y - m))
	if b.boss != null and not b.boss.dead and near < 3:
		v += (b.boss.pos - h.pos).normalized() * 0.5
	if v.length() < 0.05:
		return Vector2.ZERO
	return Iso.to_screen(v.normalized()).normalized()

# ------------------------------------------------------------------ scene

func _scene_mode(frames: int, seed_v: int, hero: String, stages: Array) -> void:
	# Com janela (sem --headless) mede o quadro real: sem vsync, contando chamadas de desenho. Sem janela so conta CPU.
	var windowed := DisplayServer.get_name() != "headless"
	if windowed:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		Engine.max_fps = 0
	for sid in stages:
		Game.run_stage = sid
		Game.run_hero = hero
		var load_t0 := Time.get_ticks_usec()
		var run: Node = load("res://ui/run.tscn").instantiate()
		add_child(run)
		await get_tree().process_frame
		await get_tree().process_frame   # o primeiro _draw do chao acontece no quadro seguinte ao add_child
		var load_ms := float(Time.get_ticks_usec() - load_t0) / 1000.0
		print("PROBE;carga=%s;ms=%.1f;janela=%s" % [sid, load_ms, str(windowed)])
		# densidade de fim de partida: _extra inimigos da onda principal em anel ao redor do heroi (ids fixos, sem aleatoriedade)
		var wave_id: String = String(run.battle.stage.waves[0].id)
		for k in _extra_enemies:
			var ang := TAU * float(k) / float(maxi(1, _extra_enemies))
			run.battle.spawn_for_test(wave_id, run.battle.hero.pos + Vector2(cos(ang), sin(ang)) * (6.0 + float(k % 4)))
		var times := PackedInt32Array()
		var draws := PackedInt32Array()
		var enemies_max := 0
		for i in frames:
			var t0 := Time.get_ticks_usec()
			await get_tree().process_frame
			times.append(Time.get_ticks_usec() - t0)
			if windowed:
				draws.append(int(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)))
			if run.battle != null:
				if i % 30 == 0:
					run.battle.hero.hp = run.battle.hero.max_hp
				enemies_max = maxi(enemies_max, run.battle.enemies.size())
		var sum := 0
		for v in times:
			sum += v
		times.sort()
		var draw_avg := 0.0
		for v in draws:
			draw_avg += float(v)
		draw_avg /= maxf(1.0, draws.size())
		print("PROBE;cena=%s;quadros=%d;ms_medio=%.3f;ms_p95=%.3f;ms_max=%.3f;inimigos_max=%d;nos=%d;orfaos=%d;objetos=%d;proc_ms=%.3f;fis_ms=%.3f;draw_calls=%.0f;primitivas=%d;vram_mb=%.0f" % [
			sid, frames, float(sum) / frames / 1000.0, float(times[int(times.size() * 0.95)]) / 1000.0, float(times[times.size() - 1]) / 1000.0,
			enemies_max, int(Performance.get_monitor(Performance.OBJECT_NODE_COUNT)), int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)),
			int(Performance.get_monitor(Performance.OBJECT_COUNT)), Performance.get_monitor(Performance.TIME_PROCESS) * 1000.0, Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS) * 1000.0,
			draw_avg, int(Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME)), float(Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED)) / 1048576.0])
		run.queue_free()
		await get_tree().process_frame

var _extra_enemies := 60

## Subclasse so do probe: cronometra funcoes internas de Battle (via super) para achar a origem dos picos.
class TimedBattle extends Battle:
	static var spans := {}   # nome -> {max, at_time, count, total}

	func _init(seed_value: int = 1, hero_id: String = "durvall", stage_key: String = "dagruve", ctx: Dictionary = {}) -> void:
		super(seed_value, hero_id, stage_key, ctx)

	func _rec(name: String, t0: int) -> void:
		var dt := Time.get_ticks_usec() - t0
		var s: Dictionary = spans.get(name, {"max": 0, "at_time": 0.0, "count": 0, "total": 0})
		s.count += 1
		s.total += dt
		if dt > int(s.max):
			s.max = dt
			s.at_time = time
		spans[name] = s

	func _spawn(id: String, at: Vector2, minute_override: float = -1.0) -> Enemy:
		var t := Time.get_ticks_usec()
		var r := super(id, at, minute_override)
		_rec("spawn", t)
		return r

	func _spawn_elite(id: String, at: Vector2) -> Enemy:
		var t := Time.get_ticks_usec()
		var r := super(id, at)
		_rec("spawn_elite", t)
		return r

	func _ring_pos() -> Vector2:
		var t := Time.get_ticks_usec()
		var r := super()
		_rec("ring_pos", t)
		return r

	func _spawn_random_interaction() -> void:
		var t := Time.get_ticks_usec()
		super()
		_rec("spawn_random_interaction", t)

	func _spawn_random_breakable() -> void:
		var t := Time.get_ticks_usec()
		super()
		_rec("spawn_random_breakable", t)

	func _horde_step(dt: float) -> void:
		var t := Time.get_ticks_usec()
		super(dt)
		_rec("horde_step", t)

	func _fire_stage_event(event_def: Dictionary) -> void:
		var t := Time.get_ticks_usec()
		super(event_def)
		_rec("fire_stage_event:%s" % String(event_def.get("id", "?")), t)

	func _fire(w: Weapon, p: Dictionary) -> bool:
		var t := Time.get_ticks_usec()
		var r := super(w, p)
		_rec("fire:%s" % w.id, t)
		return r

	func _kill(e: Enemy) -> void:
		var t := Time.get_ticks_usec()
		super(e)
		_rec("kill", t)

	func _drop(kind: String, at: Vector2, value: float, src: String = "") -> void:
		var t := Time.get_ticks_usec()
		super(kind, at, value, src)
		_rec("drop", t)

	func _build_offer() -> Array:
		var t := Time.get_ticks_usec()
		var r := super()
		_rec("build_offer", t)
		return r

	func _combat_count() -> int:
		var t := Time.get_ticks_usec()
		var r := super()
		_rec("combat_count", t)
		return r

	func _enemy_step(e: Enemy, dt: float) -> void:
		var t := Time.get_ticks_usec()
		super(e, dt)
		_rec("enemy_step", t)

	func _enemy_move(e: Enemy, step_v: Vector2) -> void:
		var t := Time.get_ticks_usec()
		super(e, step_v)
		_rec("enemy_move", t)
