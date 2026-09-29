extends Node2D
## Controla a run: cena da fase (ui/stages/*.tscn), simulação (Battle), efeitos e HUD.

const ENEMY_VIEW := preload("res://ui/enemy_view.tscn")

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
var _items_shown := false
var _divine_aura: Line2D
var _divine_aura_accent: Line2D
var _encounter_layer: CanvasLayer
var _boss_intro_panel: Control
var _boss_intro_art: TextureRect
var _boss_intro_title: Label
var _boss_intro_subtitle: Label
var _fog_edges: Array[ColorRect] = []

func _ready() -> void:
	Game.screen_name = "run"
	var seed := int(Game.qa_launch.get("seed", Time.get_ticks_usec() % 1000000)) if Game.qa_sandbox else int(Time.get_ticks_usec() % 1000000)
	battle = Battle.new(seed, Game.run_hero, Game.run_stage, Game.battle_ctx())
	battle.aim = Game.aim_mode()
	under.battle = battle
	over.battle = battle
	hud.offer_chosen.connect(_on_choose)
	hud.reroll_pressed.connect(func(): battle.reroll(); _refresh_offer())
	hud.resume_pressed.connect(_toggle_pause)
	hud.quit_pressed.connect(_abandon)
	hud.again_pressed.connect(func(): Game.start_run(Game.run_hero, Game.run_stage))
	hud.menu_pressed.connect(Game.goto_menu)
	hud.help_pressed.connect(func(): Playtest.open_game_rules())
	hud.aim_pressed.connect(_toggle_aim)
	hud.revive_pressed.connect(_accept_revive)
	hud.decline_revive_pressed.connect(_decline_revive)
	hud.items_closed.connect(_close_items_panel)
	_setup_encounter_overlays()
	_load_stage()
	if Game.qa_sandbox:
		battle.qa_prepare(Game.qa_launch)
	if battle.state == "revive_offer":
		hud.show_revive_offer(battle)
	hud.toast("%s — %s" % [battle.stage.name, battle.stage.sub], Color(0.9, 0.85, 0.6))

func playtest_context() -> Dictionary:
	var h := battle.hero
	return {"heroi": h.name, "fase": battle.stage_id, "tempo": int(battle.time), "nivel": h.level, "pv": "%d/%d" % [int(h.hp), int(h.max_hp)],
		"armas": h.weapons.map(func(w): return "%s nv%d" % [w.id, w.level]), "habilidade": battle.active_def.id, "profundidade": battle.descent_depth,
		"estado": battle.state, "regra": battle.stage_rule.get("kind", ""), "inimigos": battle.enemies.size()}

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
	battle.hero.terrain_id = String(ground.get("terrain_layout_id"))
	start_pos = hero_node.position
	battle.hero.pos = Iso.to_ground(start_pos)
	battle.hero.blockers.clear()
	for b in sorted.get_children():
		if b.has_method("set_grounding_guide"):
			b.set_grounding_guide(Game.qa_sandbox and String(Game.qa_launch.get("target_state", "")) == "prop_grounding")
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
	Sfx.set_context(battle.hero.id, battle.stage_id)
	Sfx.start_music(battle.stage_id)
	Sfx.start_ambience(battle.stage_id)

func _setup_encounter_overlays() -> void:
	_encounter_layer = CanvasLayer.new()
	_encounter_layer.layer = 20
	add_child(_encounter_layer)
	for edge in 4:
		var fog := ColorRect.new()
		fog.color = Color(0.18, 0.42, 0.25, 0.0)
		fog.mouse_filter = Control.MOUSE_FILTER_IGNORE
		fog.visible = false
		_encounter_layer.add_child(fog)
		_fog_edges.append(fog)
	_boss_intro_panel = Control.new()
	_boss_intro_panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_boss_intro_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_boss_intro_panel.visible = false
	_encounter_layer.add_child(_boss_intro_panel)
	var veil := ColorRect.new()
	veil.color = Color(0.01, 0.02, 0.015, 0.74)
	veil.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_boss_intro_panel.add_child(veil)
	_boss_intro_art = TextureRect.new()
	_boss_intro_art.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_boss_intro_art.offset_left = 72.0
	_boss_intro_art.offset_right = -72.0
	_boss_intro_art.offset_top = 42.0
	_boss_intro_art.offset_bottom = -128.0
	_boss_intro_art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_boss_intro_art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_boss_intro_panel.add_child(_boss_intro_art)
	_boss_intro_title = Label.new()
	_boss_intro_title.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	_boss_intro_title.offset_left = -460.0
	_boss_intro_title.offset_right = 460.0
	_boss_intro_title.offset_top = -112.0
	_boss_intro_title.offset_bottom = -66.0
	_boss_intro_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_boss_intro_title.add_theme_font_size_override("font_size", 32)
	_boss_intro_title.add_theme_color_override("font_outline_color", Color(0.01, 0.01, 0.01))
	_boss_intro_title.add_theme_constant_override("outline_size", 8)
	_boss_intro_panel.add_child(_boss_intro_title)
	_boss_intro_subtitle = Label.new()
	_boss_intro_subtitle.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	_boss_intro_subtitle.offset_left = -460.0
	_boss_intro_subtitle.offset_right = 460.0
	_boss_intro_subtitle.offset_top = -61.0
	_boss_intro_subtitle.offset_bottom = -32.0
	_boss_intro_subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_boss_intro_subtitle.add_theme_font_size_override("font_size", 18)
	_boss_intro_subtitle.modulate = Color(0.72, 0.92, 0.75)
	_boss_intro_panel.add_child(_boss_intro_subtitle)

func _show_boss_intro(ev: Dictionary) -> void:
	var presentation: Dictionary = ev.get("presentation", {})
	var image_path := String(presentation.get("image", ""))
	_boss_intro_art.texture = load(image_path) if image_path != "" and ResourceLoader.exists(image_path) else null
	_boss_intro_title.text = String(presentation.get("title", ev.enemy.name))
	_boss_intro_subtitle.text = String(presentation.get("subtitle", ""))
	_boss_intro_panel.modulate.a = 0.0
	_boss_intro_panel.visible = true
	var duration := clampf(float(presentation.get("overlay_seconds", 1.8)), 1.5, 2.0)
	var tween := create_tween()
	tween.tween_property(_boss_intro_panel, "modulate:a", 1.0, 0.16)
	tween.tween_interval(maxf(0.1, duration - 0.46))
	tween.tween_property(_boss_intro_panel, "modulate:a", 0.0, 0.30)
	tween.tween_callback(func(): _boss_intro_panel.visible = false)

func _update_fog_overlay() -> void:
	if battle == null or fog_state_is_inactive():
		for fog in _fog_edges:
			fog.visible = false
		return
	var viewport_size := get_viewport().get_visible_rect().size
	var depth := maxf(14.0, minf(viewport_size.x, viewport_size.y) * 0.5 * battle.fog_intensity)
	var alpha := 0.08 if battle.fog_state == "warning" else 0.12 + battle.fog_intensity * 0.20
	for fog in _fog_edges:
		fog.visible = true
		fog.color.a = alpha
	_fog_edges[0].position = Vector2.ZERO
	_fog_edges[0].size = Vector2(depth, viewport_size.y)
	_fog_edges[1].position = Vector2(viewport_size.x - depth, 0.0)
	_fog_edges[1].size = Vector2(depth, viewport_size.y)
	_fog_edges[2].position = Vector2.ZERO
	_fog_edges[2].size = Vector2(viewport_size.x, depth)
	_fog_edges[3].position = Vector2(0.0, viewport_size.y - depth)
	_fog_edges[3].size = Vector2(viewport_size.x, depth)

func fog_state_is_inactive() -> bool:
	return battle.fog_state == "inactive"

# ------------------------------------------------------------------ entrada

func _unhandled_input(ev: InputEvent) -> void:
	if _result_shown or battle.state == "revive_offer":
		return
	if battle.state == "running" and ev.is_action_pressed("hero_active"):
		if battle.use_active(battle.aim_dir):
			get_viewport().set_input_as_handled()
		return
	if ev is InputEventKey and ev.pressed and not ev.echo:
		var k: int = ev.physical_keycode
		if battle.state == "levelup" or battle.state == "altar" or battle.state == "item_offer" or battle.state == "shop":
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
			KEY_C:
				_toggle_items_panel()

func _toggle_items_panel() -> void:
	if battle.state != "running":
		return
	_items_shown = not _items_shown
	get_tree().paused = _items_shown
	if _items_shown:
		hud.show_items_panel(battle)
	else:
		hud.hide_items_panel()

func _close_items_panel() -> void:
	_items_shown = false
	get_tree().paused = false
	hud.hide_items_panel()

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
	Sfx.play("ui.confirm")
	_refresh_offer()

func _accept_revive() -> void:
	if battle.accept_revive():
		hud.hide_revive_offer()
		Sfx.play("player.revive")

func _decline_revive() -> void:
	if battle.decline_revive():
		hud.hide_revive_offer()

func _refresh_offer() -> void:
	if battle.state == "levelup" or battle.state == "altar" or battle.state == "item_offer" or battle.state == "shop":
		hud.show_offer(battle)
	else:
		hud.hide_offer()

# ------------------------------------------------------------------ loop

func _physics_process(dt: float) -> void:
	if get_tree().paused or _result_shown:
		return
	var d := Hero.movement_input(
		Input.is_physical_key_pressed(KEY_A) or Input.is_physical_key_pressed(KEY_LEFT),
		Input.is_physical_key_pressed(KEY_D) or Input.is_physical_key_pressed(KEY_RIGHT),
		Input.is_physical_key_pressed(KEY_W) or Input.is_physical_key_pressed(KEY_UP),
		Input.is_physical_key_pressed(KEY_S) or Input.is_physical_key_pressed(KEY_DOWN))
	if d == Vector2.ZERO and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var screen_to_mouse := get_global_mouse_position() - hero_node.position
		if screen_to_mouse.length() > 4.0:
			d = screen_to_mouse.normalized()
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
	if battle.state != prev_state or (battle.state in ["levelup", "altar", "item_offer", "shop"] and not hud.levelup_panel.visible):
		_refresh_offer()
	if battle.state == "revive_offer" and prev_state != "revive_offer":
		hud.show_revive_offer(battle)
	if (battle.state == "dead" or battle.state == "won") and not _result_shown:
		_show_result()

func _process(dt: float) -> void:
	if hero_node == null:
		return
	_shake = maxf(0.0, _shake - dt * 3.0)
	camera.position = hero_node.position + Vector2(randf_range(-1, 1), randf_range(-1, 1)) * _shake * 6.0
	_update_fog_overlay()

func _sync() -> void:
	var h := battle.hero
	hero_node.sync_visual(Iso.to_screen(h.pos), h.dead, h.hit_flash > 0.0)
	for e in battle.enemies:
		if not enemy_nodes.has(e):
			var n: Node2D = ENEMY_VIEW.instantiate()
			sorted.add_child(n)
			n.setup(e)
			enemy_nodes[e] = n
	for e in enemy_nodes.keys():
		var n: Node2D = enemy_nodes[e]
		if e.dead or not battle.enemies.has(e):
			n.play_death()
			enemy_nodes.erase(e)
		else:
			n.sync_visual(Iso.to_screen(e.pos))
	_update_divine_aura()

func _show_result() -> void:
	_result_shown = true
	get_tree().paused = false
	var res := battle.result()
	Game.finish_run(res)
	hud.show_result(res, Game.last_summary)
	Sfx.stop_ambience()
	Sfx.play("result.victory" if res.won else "result.defeat", -4.0)
	Sfx.start_music("victory" if res.won else "defeat")

# ------------------------------------------------------------------ efeitos

func _consume_events() -> void:
	for ev in battle.events:
		var at := Iso.to_screen(ev.pos) if ev.has("pos") else Vector2.ZERO
		match String(ev.type):
			"hit":
				Sfx.play("combat.critical" if ev.crit else "combat.impact", -14.0)
				if _numbers < 14:
					var theme: Dictionary = ev.get("visual_theme", _divine_theme())
					var divine_col: Color = theme.primary
					_float_text(at + Vector2(randf_range(-6, 6), -36), str(ev.amount), divine_col.lightened(0.2) if ev.crit else divine_col, 18 if ev.crit else 14, ev.crit, theme.outline)
					if ev.has("visual_theme") and under.has_method("spawn_impact"):
						under.call("spawn_impact", ev.pos, 3, theme.impact_accent)
			"miss":
				Sfx.play("combat.miss", -18.0)
			"hurt":
				Sfx.play("player.hurt")
				_shake = 0.6
				_float_text(at + Vector2(0, -58), "-%d" % ev.amount, Color(1.0, 0.3, 0.3), 16)
			"text":
				var cue := String(ev.text).to_lower()
				if cue == "guarda": Sfx.play("player.guard")
				elif cue == "barreira": Sfx.play("combat.barrier")
				elif cue == "esquiva": Sfx.play("combat.dodge")
				elif cue == "invoca":
					Sfx.play("enemy.summon")
					if ev.has("enemy_id"): Sfx.play_enemy(String(ev.enemy_id), "action")
				_float_text(at + Vector2(0, -50), ev.text, Color(0.7, 0.8, 1.0), 12)
			"heal":
				Sfx.play("player.heal")
				_float_text(at + Vector2(0, -60), "+%d" % ev.amount, Color(0.4, 1.0, 0.5), 14)
			"swing":
				Sfx.play_weapon(String(ev.get("weapon", "")), "combat.swing")
				hero_node.play_action(&"attack")
				_swing(ev, _divine_theme())
			"cast":
				Sfx.play_weapon(String(ev.get("weapon", "")), "combat.magic")
				hero_node.play_action(&"attack")
			"nova":
				Sfx.play_weapon(String(ev.get("weapon", "")), "combat.nova")
				_ring(ev.pos, ev.radius, _divine_theme().impact_accent, 0.35)
			"zone":
				Sfx.play_weapon(String(ev.get("weapon", "")), "combat.zone")
				var zone_theme: Dictionary = ev.get("visual_theme", _divine_theme())
				_ring(ev.pos, ev.radius, zone_theme.impact_accent, 0.25)
			"boom":
				Sfx.play("combat.explosion", -8.0)
				_shake = 0.8
				_ring(ev.pos, ev.radius, Color(1.0, 0.3, 0.2), 0.3)
				if under.has_method("spawn_impact"):
					under.call("spawn_impact", ev.pos, 8)
			"kill":
				if ev.enemy.is_boss():
					_shake = 1.5
					Sfx.play_boss(String(ev.enemy.id), "defeat")
				else:
					Sfx.play_enemy(String(ev.enemy.id), "death")
			"pickup":
				var pickup_key := String(ev.kind)
				Sfx.play("player.heal" if pickup_key == "potion" else "progress.%s" % pickup_key)
			"interaction":
				Sfx.play("world.%s" % String(ev.kind))
				_play_interaction(ev)
			"item":
				Sfx.play("progress.item")
			"levelup":
				Sfx.play("progress.levelup")
			"boss":
				Sfx.play_boss(String(ev.enemy.id), "arrival")
				Sfx.start_music("boss")
				_shake = 1.2
			"boss_intro":
				_show_boss_intro(ev)
			"stage_event_warning":
				hud.toast(String(ev.text), Color(0.95, 0.77, 0.38))
				_ring(ev.pos, 1.7, Color(0.9, 0.62, 0.26), 0.45)
			"stage_event":
				hud.toast(String(ev.text), Color(0.65, 0.88, 0.72))
				_ring(ev.pos, 1.5, Color(0.5, 0.85, 0.65), 0.35)
			"postboss_fog":
				if ev.state == "warning":
					hud.toast("A névoa avança pelas bordas!", Color(0.58, 0.9, 0.58))
			"styx_test":
				if not bool(ev.passed):
					hud.toast("Estige: lucidez falhou (−1 INT efetiva).", Color(0.42, 0.78, 0.95))
			"styx_forget":
				hud.toast("Esquecimento do Estige: afaste-se da água por %.0f s." % float(ev.duration), Color(0.48, 0.8, 1.0))
			"active":
				Sfx.play_hero(String(ev.get("hero_id", battle.hero.id)))
				hero_node.play_action(&"active")
				_shake = 0.35
				_ring(ev.pos, float(ev.get("radius", 2.0)), _dcol(String(ev.get("dtype", "radiante"))), 0.3)
			"boss_phase":
				var active_boss: String = String(battle.stage.get("boss", ""))
				Sfx.play_boss(active_boss, "phase")
				_shake = 1.0
				hud.toast(ev.text, Color(1.0, 0.55, 0.35))
				_play_enemy_action(active_boss, ev.pos, &"phase")
			"enemy_action":
				Sfx.play_enemy(String(ev.enemy_id), "action")
				var action: StringName = &"attack"
				if String(ev.get("ability", "")) == "summon": action = &"special_a"
				elif String(ev.get("ability", "")) == "ring": action = &"special_b"
				_play_enemy_action(String(ev.enemy_id), ev.pos, action)
			"telegraph":
				Sfx.play("enemy.telegraph")
				Sfx.play_enemy(String(ev.get("enemy_id", "")), "action")
			"windup":
				Sfx.play("enemy.charge")
			"dead":
				Sfx.play("player.death")
			"divinity":
				hud.toast("Afinidade: %s" % String(ev.god), _divine_theme().primary)
			"toast":
				hud.toast(ev.text, ev.get("color", Color(1, 1, 1)))
				Game.logline(String(ev.text))
	battle.events.clear()

func _play_enemy_action(enemy_id: String, ground_position: Vector2, action: StringName) -> void:
	var best: Node2D
	var best_distance := INF
	for enemy_key in enemy_nodes:
		if enemy_key.id != enemy_id:
			continue
		var distance: float = enemy_key.pos.distance_squared_to(ground_position)
		if distance < best_distance:
			best_distance = distance
			best = enemy_nodes[enemy_key]
	if best != null:
		best.play_action(action)

func _play_interaction(ev: Dictionary) -> void:
	var sequence: String = {"chest": "chest_open", "fountain": "fountain_active", "altar": "altar_active", "ritual": "ritual", "portal": "portal"}.get(String(ev.kind), "")
	var count: int = {"chest_open": 6, "fountain_active": 6, "altar_active": 6, "ritual": 8, "portal": 8}.get(sequence, 0)
	var path := "res://assets/animations/interactions/%s.png" % sequence
	if count == 0 or not ResourceLoader.exists(path):
		return
	var frames := SpriteStripFrames.empty()
	SpriteStripFrames.add_strip(frames, &"activate", path, Vector2i(192, 192), count, 10.0, false)
	var animated := AnimatedSprite2D.new()
	animated.sprite_frames = frames
	animated.position = Iso.to_screen(ev.pos)
	animated.offset = Vector2(0, -96)
	var height := 70.0 if ev.kind == "portal" else 54.0
	animated.scale = Vector2.ONE * (height / 192.0)
	fx.add_child(animated)
	animated.animation_finished.connect(animated.queue_free)
	animated.play(&"activate")

func _dcol(dtype: String) -> Color:
	match dtype:
		"fogo": return Color(1.0, 0.5, 0.15)
		"radiante": return Color(1.0, 0.95, 0.65)
		"magico": return Color(0.65, 0.45, 1.0)
	return Color(0.85, 0.85, 0.9)

func _float_text(at: Vector2, text: String, col: Color, size: int, critical: bool = false, outline: Color = Color(0, 0, 0)) -> void:
	var l := Label.new()
	l.text = text
	l.position = at
	l.modulate = col
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_outline_color", outline)
	l.add_theme_constant_override("outline_size", 5 if critical else 4)
	l.pivot_offset = Vector2(18, 12)
	l.scale = Vector2.ONE * (0.7 if critical else 0.82)
	fx.add_child(l)
	_numbers += 1
	var t := create_tween()
	t.tween_property(l, "scale", Vector2.ONE * (1.15 if critical else 1.0), 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t.tween_property(l, "position:y", at.y - 22, 0.6)
	t.parallel().tween_property(l, "modulate:a", 0.0, 0.6)
	t.tween_callback(func():
		_numbers -= 1
		l.queue_free())

func _update_divine_aura() -> void:
	if hero_node == null or battle == null:
		return
	if _divine_aura == null:
		_divine_aura = _make_divine_aura(22.0, 7.0, 2.5)
		_divine_aura_accent = _make_divine_aura(25.0, 8.0, 1.2)
		fx.add_child(_divine_aura)
		fx.add_child(_divine_aura_accent)
	_divine_aura.position = hero_node.position + Vector2(0, 2)
	_divine_aura_accent.position = hero_node.position + Vector2(0, 2)
	_divine_aura.visible = battle.visual_boon_selected
	_divine_aura_accent.visible = battle.visual_boon_selected
	if _divine_aura.visible:
		var theme := _divine_theme()
		_divine_aura.default_color = Color(theme.primary, 0.8)
		_divine_aura_accent.default_color = Color(theme.aura_accent, 0.55)

func _make_divine_aura(radius_x: float, radius_y: float, width: float) -> Line2D:
	var aura := Line2D.new()
	var points := PackedVector2Array()
	for i in 25:
		var angle := TAU * float(i) / 24.0
		points.append(Vector2(cos(angle) * radius_x, sin(angle) * radius_y))
	aura.points = points
	aura.width = width
	aura.antialiased = true
	return aura

func _divine_theme() -> Dictionary:
	return DivineVisuals.resolve(battle.hero.id, battle.visual_god, battle.visual_boon_selected)

func _swing(ev: Dictionary, theme: Dictionary) -> void:
	var poly := Polygon2D.new()
	var pts := PackedVector2Array([Iso.to_screen(ev.pos) + Vector2(0, -18)])
	var cone: float = deg_to_rad(float(ev.cone))
	for i in 9:
		var a := lerpf(-cone, cone, float(i) / 8.0)
		pts.append(Iso.to_screen(ev.pos + ev.dir.rotated(a) * float(ev.range)) + Vector2(0, -18))
	poly.polygon = pts
	poly.color = Color(theme.primary, 0.28)
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
