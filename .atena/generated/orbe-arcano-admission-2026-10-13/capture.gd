extends Node

const OUT := "res://.atena/generated/orbe-arcano-admission-2026-10-13/"
var shots: Array[String] = []

func shot(tag: String, run: Node) -> void:
	run.over.queue_redraw()
	run.over._orb_layer.queue_redraw()
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	assert(get_viewport().get_texture().get_image().save_png(OUT+"captures/"+tag+".png") == OK)
	shots.append(tag)

func _ready() -> void:
	get_tree().create_timer(50).timeout.connect(func(): printerr("capture timeout"); get_tree().quit(1))
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUT+"captures"))
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed":4242}
	Game._save_path = "user://orb-qa-profile.json"
	Game.profile = Profile.new({"name":"Orbe QA","welcome_seen":true})
	for id in Data.table("hqs"): Game.profile.data.hqs_seen[id] = true
	Game.run_hero = "maelor"
	Game.run_stage = "dagruve"
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	await get_tree().create_timer(0.5).timeout
	run.set_process(false)
	run.set_physics_process(false)
	run.over._ensure_orb_layer()
	var layer: Node = run.over._orb_layer
	layer.set_process(false)
	run.camera.position = run.hero_node.position + Vector2(0,-30)
	run.battle.aim = Battle.Aim.MOUSE
	run.battle.aim_dir = Vector2.RIGHT
	var reports: Array = []
	for weapon in ArcaneOrbVfx.WEAPONS:
		run.battle.projectiles.clear()
		run.battle.events.clear()
		var w := Weapon.make(weapon)
		assert(run.battle._fire(w,w.params()))
		var spawned: int = run.battle.projectiles.size()
		for pr in run.battle.projectiles:
			assert(layer.can_draw_projectile(pr))
			pr.pos += pr.dir * 2.0
		layer.clock = 0.0
		await shot(weapon+"-flight",run)
		if weapon == "raio_enfraquecedor":
			var original: Dictionary = run.battle.projectiles[0].duplicate(true)
			run.battle.projectiles.clear()
			for i in 8:
				var pr := original.duplicate(true)
				pr.dir = Vector2.from_angle(i*TAU/8)
				pr.pos = run.battle.hero.pos + pr.dir * 2.7
				run.battle.projectiles.append(pr)
				assert(is_equal_approx(RadiantOrbVfx.flight_angle(pr.dir),Iso.to_screen(pr.dir).angle()))
			await shot("eight-directions",run)
			for frame in 4:
				layer.clock = float(frame)/12.0 + 0.001
				await shot("flight-phase-"+str(frame),run)
			layer.clock = 4.0/12.0 + 0.001
			assert(RadiantOrbVfx.flight_frame(layer.clock)==0)
			await shot("flight-loop-return",run)
		# Real Battle._fire -> moving projectiles -> primary hits -> Run consumption.
		run.battle.projectiles.clear()
		run.battle.enemies.clear()
		run.battle.spawn_for_test("zumbi",run.battle.hero.pos+Vector2(2,0))
		run.battle.enemies[-1].hp = 10000
		var hits: Array = []
		for attempt in 8:
			run.battle.rng.seed = 7200+attempt
			run.battle.projectiles.clear()
			run.battle.events.clear()
			assert(run.battle._fire(w,w.params()))
			for step in 40: run.battle._update_projectiles(1.0/60.0)
			hits = run.battle.events.filter(func(e: Dictionary) -> bool: return ArcaneOrbVfx.supports_hit(e))
			if not hits.is_empty(): break
		assert(not hits.is_empty())
		var event: Dictionary = hits[0].duplicate(true)
		run.battle.projectiles.clear()
		run.battle.events = hits.duplicate(true)
		layer.impacts.clear()
		run._numbers = 14 # Impact must not depend on damage-number capacity/merge.
		run._consume_events()
		assert(layer.impacts.size() == hits.size())
		for impact in layer.impacts: assert(impact.family == ArcaneOrbVfx)
		run._sync()
		for impact in layer.impacts: impact.age = 0.065
		await shot(weapon+"-impact",run)
		if weapon == "raio_enfraquecedor":
			for frame in 4:
				layer.impacts.clear()
				assert(layer.spawn_impact(event))
				layer.impacts[0].age = float(frame)*0.24/4.0 + 0.001
				await shot("impact-phase-"+str(frame),run)
			for god in ["Lliira","Tou Um"]:
				var tinted := event.duplicate(true)
				tinted.visual_theme = DivineVisuals.DIVINE_THEMES[god]
				layer.impacts.clear()
				assert(layer.spawn_impact(tinted))
				layer.impacts[0].age = 0.065
				assert(layer.impacts[0].color == tinted.visual_theme.impact_accent)
				await shot("tint-"+god.to_lower().replace(" ","-"),run)
			layer.impacts.clear()
			for i in RadiantOrbVfx.MAX_IMPACTS: assert(layer.spawn_impact(event))
			assert(not layer.spawn_impact(event))
			run.battle.state = "levelup"
			var age: float = layer.impacts[0].age
			var clock: float = layer.clock
			layer._process(1.0)
			assert(layer.clock == clock and layer.impacts[0].age == age)
			run.battle.state = "running"
			get_tree().paused = true
			layer._process(1.0)
			assert(layer.clock == clock and layer.impacts[0].age == age)
			get_tree().paused = false
			layer._process(0.25)
			assert(layer.impacts.is_empty())
			var secondary := event.duplicate()
			secondary.erase("weapon")
			secondary.erase("kind")
			assert(not layer.spawn_impact(secondary))
			# Existing procedural fallbacks, with the exact same supported projectile.
			var params := w.params()
			params["_audio_id"] = weapon
			var pr := {"owner":"hero","p":params,"pos":run.battle.hero.pos+Vector2(2,0),"dir":Vector2.RIGHT}
			run.battle.projectiles = [pr]
			Game.profile.data.settings.reduced_impact = true
			assert(not layer.can_draw_projectile(pr) and not layer.spawn_impact(event))
			await shot("reduced-fallback",run)
			Game.profile.data.settings.reduced_impact = false
			var flight: Texture2D = RadiantOrbVfx.texture(ArcaneOrbVfx.FLIGHT_PATH)
			RadiantOrbVfx._textures[ArcaneOrbVfx.FLIGHT_PATH] = null
			assert(not layer.can_draw_projectile(pr))
			await shot("missing-texture-fallback",run)
			RadiantOrbVfx._textures[ArcaneOrbVfx.FLIGHT_PATH] = flight
			var impact_texture: Texture2D = RadiantOrbVfx.texture(ArcaneOrbVfx.IMPACT_PATH)
			RadiantOrbVfx._textures[ArcaneOrbVfx.IMPACT_PATH] = null
			assert(not layer.spawn_impact(event))
			RadiantOrbVfx._textures[ArcaneOrbVfx.IMPACT_PATH] = impact_texture
			pr.p = Weapon.make("memoria_alterada").params()
			assert(not layer.can_draw_projectile(pr))
			await shot("unsupported-magic-fallback",run)
		reports.append({"weapon":weapon,"spawned":spawned,"real_hits":hits.size(),"number_cap_independent":true})
		layer.impacts.clear()
		run.battle.projectiles.clear()
	# Mixed-family dispatch through real Battle firing and primary-hit presentation.
	layer.impacts.clear()
	run.battle.projectiles.clear()
	run.battle.events.clear()
	for view in run.enemy_nodes.values(): view.free()
	run.enemy_nodes.clear()
	run.battle.enemies.clear()
	for wid in ["raio_enfraquecedor","raio_de_luz"]:
		run.battle.aim_dir = Vector2.RIGHT if wid=="raio_enfraquecedor" else Vector2.LEFT
		var w := Weapon.make(wid)
		var params := w.params()
		assert(run.battle._fire(w,params))
		var pr: Dictionary = run.battle.projectiles[-1]
		pr.pos = run.battle.hero.pos + pr.dir*1.3
		run.battle.spawn_for_test("zumbi",run.battle.hero.pos+pr.dir*2.6)
		run.battle.enemies[-1].hp = 10000
		assert(run.battle._hero_hit(run.battle.enemies[-1],params,false))
	run.battle.events = run.battle.events.filter(func(e: Dictionary) -> bool: return e.type=="hit")
	run._consume_events()
	assert(layer.impacts.size()==2)
	assert(layer.impacts[0].family == ArcaneOrbVfx and layer.impacts[1].family == RadiantOrbVfx)
	for impact in layer.impacts: impact.age=0.065
	run._sync()
	await shot("mixed-arcane-radiant",run)
	layer.impacts.clear()
	run.battle.projectiles.clear()
	# Existing two nova families remain independently routed.
	for weapon in ["sentenca_de_lliira","ampulheta"]:
		var event := {"type":"nova","pos":run.battle.hero.pos,"radius":3.0,"weapon":weapon,"dtype":"radiante" if weapon=="sentenca_de_lliira" else "magico"}
		run._nova_effect(event)
		var effect: Node = run.fx.get_child(run.fx.get_child_count()-1)
		assert(effect.get_child(0) is AnimatedSprite2D)
		await shot("regression-"+weapon,run)
		effect.free()
	var weak_layer: WeakRef = weakref(layer)
	run.queue_free()
	await get_tree().process_frame
	assert(weak_layer.get_ref()==null)
	var report := {"status":"PASS","weapons":reports,"screenshots":shots,"directions":8,"flight_frames":4,"impact_frames":4,"flight_loop_return":true,"tints":["Lliira","Tou Um"],"fallbacks":["reduced","missing flight","missing impact","arcane","secondary hit"],"pause_and_lifetime":true,"impact_cap":32,"layer_freed_with_run":true,"nova_regressions":true,"mixed_arcane_radiant":true,"human_playtest":false}
	FileAccess.open(OUT+"runtime-checks.json",FileAccess.WRITE).store_string(JSON.stringify(report,"\t")+"\n")
	print("capture PASS: ",shots.size()," rendered shots; real weapon events, pauses, caps, fallbacks and cleanup verified")
	get_tree().quit()
