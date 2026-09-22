extends Node2D
## Controla a run: cena da fase (ui/stages/*.tscn), simulação (Battle), efeitos e HUD.

const ENEMY_VIEW := preload("res://ui/enemy_view.gd")

@onready var slot: Node2D = $StageSlot
@onready var under: Node2D = $Under
@onready var over: Node2D = $Over
@onready var fx: Node2D = $Fx
@onready var camera: Camera2D = $Camera
@onready var hud: CanvasLayer = $Hud

var battle: Battle
var stage_root: Node2D
var sorted: Node2D
var hero_node: Node2D
var enemy_nodes := {}
var start_pos := Vector2.ZERO
var _result_shown := false
var _shake := 0.0
var _numbers := 0
var _paused := false

func _ready() -> void:
	Game.screen_name = "run"
	battle = Battle.new(int(Time.get_ticks_usec() % 1000000), Game.run_hero, Game.run_stage, Game.battle_ctx())
	battle.aim = Game.aim_mode()
	under.battle = battle
	over.battle = battle
	hud.offer_chosen.connect(_on_choose)
	hud.reroll_pressed.connect(func(): battle.reroll(); _refresh_offer())
	hud.resume_pressed.connect(_toggle_pause)
	hud.quit_pressed.connect(_abandon)
	hud.again_pressed.connect(func(): Game.start_run(Game.run_hero, Game.run_stage))
	hud.menu_pressed.connect(Game.goto_menu)
	hud.aim_pressed.connect(_toggle_aim)
	_load_stage()
	Sfx.start_music()
	hud.toast("%s — %s" % [battle.stage.name, battle.stage.sub], Color(0.9, 0.85, 0.6))

func playtest_context() -> Dictionary:
	var h := battle.hero
	return {"heroi": h.name, "fase": battle.stage_id, "tempo": int(battle.time), "nivel": h.level, "pv": "%d/%d" % [int(h.hp), int(h.max_hp)],
		"armas": h.weapons.map(func(w): return "%s nv%d" % [w.id, w.level]), "habilidade": battle.active_def.id, "profundidade": battle.descent_depth,
		"estado": battle.state, "inimigos": battle.enemies.size()}

# ------------------------------------------------------------------ fase

func _load_stage() -> void:
	for n in enemy_nodes.values():
		n.queue_free()
	enemy_nodes.clear()
	if stage_root != null:
		stage_root.queue_free()
	var scene: PackedScene = load("res://ui/stages/%s.tscn" % battle.stage_id)
	stage_root = scene.instantiate()
	slot.add_child(stage_root)
	sorted = stage_root.get_node("Sorted")
	hero_node = sorted.get_node("Hero")
	hero_node.apply_hero(battle.hero.id)
	var ground: Node2D = stage_root.get_node("Ground")
	var msize := Vector2(ground.map_size)
	battle.map_size = msize
	battle.hero.map_size = msize
	start_pos = hero_node.position
	battle.hero.pos = Iso.to_ground(start_pos)
	battle.hero.blockers.clear()
	for b in sorted.get_children():
		if b.is_in_group("blockers"):
			var g := Iso.to_ground(b.position)
			battle.hero.blockers.append(Vector3(g.x, g.y, b.block_radius))
	var bg: Array = battle.stage.bg
	RenderingServer.set_default_clear_color(Color(float(bg[0]) / 255.0, float(bg[1]) / 255.0, float(bg[2]) / 255.0))
	for sp in stage_root.get_node("SpawnPoints").get_children():
		for i in int(sp.count):
			var off := Vector2(battle.rng.randf_range(-1, 1), battle.rng.randf_range(-1, 1)) * float(sp.scatter)
			battle.spawn_for_test(String(sp.enemy_id), Iso.to_ground(sp.position) + off)
	battle.stage_changed = false
	camera.position = hero_node.position

# ------------------------------------------------------------------ entrada

func _unhandled_input(ev: InputEvent) -> void:
	if _result_shown:
		return
	if battle.state == "running" and ev.is_action_pressed("hero_active"):
		if battle.use_active(battle.aim_dir):
			Sfx.play("cast", -8.0)
		get_viewport().set_input_as_handled()
		return
	if ev is InputEventKey and ev.pressed and not ev.echo:
		var k: int = ev.physical_keycode
		if battle.state == "levelup" or battle.state == "altar":
			if k >= KEY_1 and k <= KEY_9:
				_on_choose(k - KEY_1)
			elif k == KEY_R:
				battle.reroll()
				_refresh_offer()
			return
		match k:
			KEY_ESCAPE: _toggle_pause()
			KEY_TAB: _toggle_aim()
			KEY_E:
				if battle.interact():
					Sfx.play("click")
			KEY_X:
				battle.extract()

func _toggle_aim() -> void:
	battle.toggle_aim()
	Game.set_aim(battle.aim)
	hud.toast("Mira: %s" % ("AUTOMÁTICA" if battle.aim == Battle.Aim.AUTO else "MOUSE"), Color(0.8, 0.9, 1.0))
	if _paused:
		hud.show_pause(true)

func _toggle_pause() -> void:
	if battle.state != "running":
		return
	_paused = not _paused
	get_tree().paused = _paused
	hud.show_pause(_paused)

func _abandon() -> void:
	get_tree().paused = false
	_paused = false
	hud.show_pause(false)
	battle.state = "dead"
	battle.hero.dead = true

func _on_choose(i: int) -> void:
	battle.choose(i)
	Sfx.play("click")
	_refresh_offer()

func _refresh_offer() -> void:
	if battle.state == "levelup" or battle.state == "altar":
		hud.show_offer(battle)
	else:
		hud.hide_offer()

# ------------------------------------------------------------------ loop

func _physics_process(dt: float) -> void:
	if get_tree().paused or _result_shown:
		return
	var d := Vector2(
		int(Input.is_physical_key_pressed(KEY_D) or Input.is_physical_key_pressed(KEY_RIGHT))
		- int(Input.is_physical_key_pressed(KEY_A) or Input.is_physical_key_pressed(KEY_LEFT)),
		int(Input.is_physical_key_pressed(KEY_S) or Input.is_physical_key_pressed(KEY_DOWN))
		- int(Input.is_physical_key_pressed(KEY_W) or Input.is_physical_key_pressed(KEY_UP)))
	var m_ground := Iso.to_ground(get_global_mouse_position() - hero_node.position)
	if m_ground.length() > 0.01:
		battle.aim_dir = m_ground.normalized()
		battle.aim_pos = battle.hero.pos + m_ground
	var prev_state := battle.state
	battle.step(d, dt)
	if battle.stage_changed:
		_load_stage()
		battle.hero.pos = Iso.to_ground(start_pos)
	_sync()
	_consume_events()
	hud.update_stats(battle)
	if battle.state != prev_state or (battle.state in ["levelup", "altar"] and not hud.levelup_panel.visible):
		_refresh_offer()
	if (battle.state == "dead" or battle.state == "won") and not _result_shown:
		_show_result()

func _process(dt: float) -> void:
	if hero_node == null:
		return
	_shake = maxf(0.0, _shake - dt * 3.0)
	camera.position = hero_node.position + Vector2(randf_range(-1, 1), randf_range(-1, 1)) * _shake * 6.0

func _sync() -> void:
	var h := battle.hero
	hero_node.position = Iso.to_screen(h.pos)
	hero_node.dead = h.dead
	hero_node.flash = h.hit_flash > 0.0
	hero_node.queue_redraw()
	for e in battle.enemies:
		if not enemy_nodes.has(e):
			var n: Node2D = ENEMY_VIEW.new()
			sorted.add_child(n)
			n.setup(e)
			enemy_nodes[e] = n
	for e in enemy_nodes.keys():
		var n: Node2D = enemy_nodes[e]
		if e.dead or not battle.enemies.has(e):
			n.queue_free()
			enemy_nodes.erase(e)
		else:
			n.position = Iso.to_screen(e.pos)
			n.queue_redraw()

func _show_result() -> void:
	_result_shown = true
	get_tree().paused = false
	var res := battle.result()
	Game.finish_run(res)
	hud.show_result(res, Game.last_summary)
	Sfx.play("win" if res.won else "dead", -4.0)
	Sfx.stop_music()

# ------------------------------------------------------------------ efeitos

func _consume_events() -> void:
	for ev in battle.events:
		var at := Iso.to_screen(ev.pos) if ev.has("pos") else Vector2.ZERO
		match String(ev.type):
			"hit":
				Sfx.play("crit" if ev.crit else "hit", -14.0)
				if _numbers < 14:
					_float_text(at + Vector2(randf_range(-6, 6), -36), str(ev.amount), Color(1, 0.85, 0.3) if ev.crit else Color(0.92, 0.92, 0.92), 16 if ev.crit else 12)
			"miss":
				pass
			"hurt":
				Sfx.play("hurt")
				_shake = 0.6
				_float_text(at + Vector2(0, -58), "-%d" % ev.amount, Color(1.0, 0.3, 0.3), 16)
			"text":
				_float_text(at + Vector2(0, -50), ev.text, Color(0.7, 0.8, 1.0), 12)
			"heal":
				_float_text(at + Vector2(0, -60), "+%d" % ev.amount, Color(0.4, 1.0, 0.5), 14)
			"swing":
				Sfx.play("swing", -16.0)
				_swing(ev)
			"cast":
				Sfx.play("cast", -18.0)
			"nova":
				Sfx.play("nova", -12.0)
				_ring(ev.pos, ev.radius, _dcol(String(ev.dtype)), 0.35)
			"zone":
				_ring(ev.pos, ev.radius, _dcol(String(ev.dtype)), 0.25)
			"boom":
				Sfx.play("boom", -8.0)
				_shake = 0.8
				_ring(ev.pos, ev.radius, Color(1.0, 0.3, 0.2), 0.3)
			"kill":
				if ev.enemy.is_boss():
					_shake = 1.5
			"item":
				Sfx.play("item")
			"levelup":
				Sfx.play("levelup")
			"boss":
				Sfx.play("boss")
				_shake = 1.2
			"active":
				_shake = 0.35
				_ring(ev.pos, float(ev.get("radius", 2.0)), _dcol(String(ev.get("dtype", "radiante"))), 0.3)
			"boss_phase":
				Sfx.play("boss")
				_shake = 1.0
				hud.toast(ev.text, Color(1.0, 0.55, 0.35))
			"toast":
				hud.toast(ev.text, ev.get("color", Color(1, 1, 1)))
				Game.logline(String(ev.text))
	battle.events.clear()

func _dcol(dtype: String) -> Color:
	match dtype:
		"fogo": return Color(1.0, 0.5, 0.15)
		"radiante": return Color(1.0, 0.95, 0.65)
		"magico": return Color(0.65, 0.45, 1.0)
	return Color(0.85, 0.85, 0.9)

func _float_text(at: Vector2, text: String, col: Color, size: int) -> void:
	var l := Label.new()
	l.text = text
	l.position = at
	l.modulate = col
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_outline_color", Color(0, 0, 0))
	l.add_theme_constant_override("outline_size", 4)
	fx.add_child(l)
	_numbers += 1
	var t := create_tween()
	t.tween_property(l, "position:y", at.y - 22, 0.6)
	t.parallel().tween_property(l, "modulate:a", 0.0, 0.6)
	t.tween_callback(func():
		_numbers -= 1
		l.queue_free())

func _swing(ev: Dictionary) -> void:
	var poly := Polygon2D.new()
	var pts := PackedVector2Array([Iso.to_screen(ev.pos) + Vector2(0, -18)])
	var cone: float = deg_to_rad(float(ev.cone))
	for i in 9:
		var a := lerpf(-cone, cone, float(i) / 8.0)
		pts.append(Iso.to_screen(ev.pos + ev.dir.rotated(a) * float(ev.range)) + Vector2(0, -18))
	poly.polygon = pts
	poly.color = Color(1, 1, 1, 0.28)
	fx.add_child(poly)
	var t := create_tween()
	t.tween_property(poly, "modulate:a", 0.0, 0.16)
	t.tween_callback(poly.queue_free)

func _ring(center: Vector2, radius: float, col: Color, dur: float) -> void:
	var line := Line2D.new()
	var pts := PackedVector2Array()
	for i in 33:
		var a := TAU * i / 32.0
		pts.append(Iso.to_screen(Vector2(cos(a), sin(a)) * radius))
	line.points = pts
	line.width = 4.0
	line.default_color = col
	line.position = Iso.to_screen(center)
	line.scale = Vector2(0.25, 0.25)
	fx.add_child(line)
	var t := create_tween()
	t.tween_property(line, "scale", Vector2.ONE, dur)
	t.parallel().tween_property(line, "modulate:a", 0.0, dur)
	t.tween_callback(line.queue_free)
