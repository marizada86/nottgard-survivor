extends Node

const OUT := "res://.atena/generated/ampulheta-admission-2026-10-13/"

func shot(tag: String) -> void:
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	assert(get_viewport().get_texture().get_image().save_png(OUT + "captures/" + tag + ".png") == OK)

func clear_fx(run: Node) -> void:
	for node in run.fx.get_children():
		node.free()

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUT + "captures"))
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 4242}
	Game._save_path = "user://pulso-qa-profile.json"
	Game.profile = Profile.new({"name": "Pulso QA", "welcome_seen": true})
	for id in Data.table("hqs"): Game.profile.data["hqs_seen"][id] = true
	Game.run_hero = "maelor"
	Game.run_stage = "dagruve"
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	await get_tree().create_timer(0.6).timeout
	run.set_process(false)
	run.set_physics_process(false)
	run.camera.position = run.hero_node.position + Vector2(0, -30)
	var report: Array = []
	for weapon in ["ampulheta"]:
		clear_fx(run)
		run.battle.events.clear()
		run.battle.spawn_for_test("zumbi", run.battle.hero.pos + Vector2(0.4, 0))
		var w := Weapon.make(weapon)
		assert(run.battle._fire(w, w.params()))
		var novas: Array = run.battle.events.filter(func(e: Dictionary) -> bool: return e.type == "nova")
		assert(novas.size() == 1 and novas[0].weapon == weapon)
		var nova: Dictionary = novas[0].duplicate(true)
		run.battle.events = novas
		run._consume_events()
		assert(run.fx.get_child_count() == 1)
		var pulse: Node2D = run.fx.get_child(0)
		var sprite := pulse.get_child(0) as AnimatedSprite2D
		assert(sprite != null and pulse.position == Iso.to_screen(nova.pos))
		assert(sprite.scale.is_equal_approx(HourglassVfx.scale_for_radius(nova.radius)))
		sprite.pause()
		sprite.frame = 2
		await shot(weapon + "-peak")
		if weapon == "ampulheta":
			for frame in 6:
				sprite.frame = frame
				await shot("phase-" + str(frame))
		report.append({"weapon": weapon, "radius": nova.radius, "event_route": "Battle._fire -> nova -> Run._consume_events", "rendered": true})
	clear_fx(run)
	var event := {"type": "nova", "weapon": "ampulheta", "dtype": "magico", "pos": run.battle.hero.pos, "radius": 4.0}
	for theme in ["Lliira", "Tou Um"]:
		var pulse := HourglassVfx.create_effect(event, DivineVisuals.DIVINE_THEMES[theme].impact_accent)
		run.fx.add_child(pulse)
		var sprite := pulse.get_child(0) as AnimatedSprite2D
		sprite.pause()
		sprite.frame = 2
		await shot("tint-" + theme.to_lower().replace(" ", "-"))
		clear_fx(run)
	Game.profile.data.settings["reduced_impact"] = true
	run._nova_effect(event)
	assert(run.fx.get_child(0) is Line2D)
	await shot("reduced-impact-ring")
	clear_fx(run)
	Game.profile.data.settings["reduced_impact"] = false
	var unsupported := event.duplicate()
	unsupported.weapon = "not-supported"
	run._nova_effect(unsupported)
	assert(run.fx.get_child(0) is Line2D)
	await shot("unsupported-ring")
	clear_fx(run)
	var radiant := event.duplicate()
	radiant.weapon = "sentenca_de_lliira"
	radiant.dtype = "radiante"
	run._nova_effect(radiant)
	var pulse_sprite := run.fx.get_child(0).get_child(0) as AnimatedSprite2D
	assert(pulse_sprite.sprite_frames.get_frame_texture(&"default", 0).atlas.resource_path == RadiantPulseVfx.TEXTURE_PATH)
	pulse_sprite.pause()
	pulse_sprite.frame = 2
	await shot("radiant-pulse-regression")
	clear_fx(run)
	var animated := HourglassVfx.create_effect(event, Color.WHITE)
	run.fx.add_child(animated)
	await get_tree().create_timer(0.55).timeout
	assert(not is_instance_valid(animated))
	var file := FileAccess.open(OUT + "runtime-checks.json", FileAccess.WRITE)
	file.store_string(JSON.stringify({"result": "PASS", "weapons": report, "phases": 6, "tints": ["Lliira", "Tou Um"], "reduced_impact_fallback": true, "unsupported_fallback": true, "freed_after_completion": true, "radiant_pulse_regression": true, "appdata": OS.get_environment("APPDATA")}, "\t") + "\n")
	run.queue_free()
	await get_tree().process_frame
	print("capture PASS: actual ampulheta event; phases/tints/fallbacks/lifetime verified")
	get_tree().quit()
