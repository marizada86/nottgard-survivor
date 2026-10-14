extends Node

const OUT := "res://.atena/generated/assets-l001-admission-2026-10-13/"
var shots: Array[String] = []
var checks: Array[String] = []

func shot(tag: String) -> void:
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	assert(get_viewport().get_texture().get_image().save_png(OUT+"captures/"+tag+".png")==OK)
	shots.append(tag)

func snapshot(b: Battle) -> Dictionary:
	var enemies: Array = []
	for e in b.enemies: enemies.append([e.hp,e.pos,e.ca,e.mark,e.stun_t,e.burn_t])
	return {"rng":b.rng.state,"hp":b.hero.hp,"guard":b.active_guard,"guard_t":b.active_guard_t,"cd":b.active_cd,"healing":b.run_record.healing,"damage":b.run_record.damage.duplicate(true),"stats":b.stats.duplicate(true),"enemies":enemies}

func make_run(hero: String) -> Node:
	Game.run_hero=hero
	Game.run_stage="dagruve"
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	await get_tree().create_timer(0.25).timeout
	run.set_process(false)
	run.set_physics_process(false)
	run.over._ensure_orb_layer()
	run.over._orb_layer.set_process(false)
	run.camera.position=run.hero_node.position+Vector2(0,-30)
	run.battle.aim=Battle.Aim.MOUSE
	run.battle.aim_dir=Vector2.RIGHT
	run.battle.enemies.clear()
	run.battle.projectiles.clear()
	run.battle.events.clear()
	run.battle.spawn_for_test("zumbi",run.battle.hero.pos+Vector2(1,0))
	run.battle.enemies[-1].hp=10000
	run._sync()
	return run

func animated_effect(run: Node) -> Node2D:
	for child in run.fx.get_children():
		if child.get_child_count()>0 and child.get_child(0) is AnimatedSprite2D:
			return child
	return null

func _ready() -> void:
	get_tree().create_timer(55).timeout.connect(func(): printerr("capture timeout");get_tree().quit(1))
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUT+"captures"))
	Playtest.visible=false
	Game.qa_sandbox=true
	Game.qa_launch={"seed":4242}
	Game._save_path="user://l001-capture-profile.json"
	Game.profile=Profile.new({"name":"L001 QA","welcome_seen":true})
	for id in Data.table("hqs"):Game.profile.data.hqs_seen[id]=true
	for weapon in ["golpe_do_juizo","martelo_da_gloria","machado_de_xargath","ruptura_sombria"]:
		var run: Node = await make_run("durvall")
		var b: Battle=run.battle
		if weapon=="ruptura_sombria":assert(b.use_active())
		else:
			var w:=Weapon.make(weapon)
			assert(b._fire(w,w.params()))
		var events: Array = b.events.filter(func(e: Dictionary)->bool:return e.type=="swing")
		assert(events.size()==1 and events[0].weapon==weapon)
		var event: Dictionary=events[0].duplicate(true)
		var before:=snapshot(b)
		run._consume_events()
		assert(snapshot(b)==before)
		var effect:=animated_effect(run)
		assert(effect!=null)
		var sprite:=effect.get_child(0) as AnimatedSprite2D
		sprite.pause()
		for frame in 6:
			sprite.frame=frame
			await shot(weapon+"-phase-"+str(frame))
		sprite.frame=2
		for i in 8:
			var direction:=Vector2.from_angle(i*TAU/8)
			effect.transform=MeleeVfx.projection(direction)
			var shape:=MeleeVfx.shape_for(weapon,event.dtype)
			var reach:=effect.transform.basis_xform(Vector2(float(MeleeVfx.CALIBRATED_RADII[shape])*sprite.scale.x,0))
			assert(reach.is_equal_approx(Iso.to_screen(direction*float(event.range))))
			await shot(weapon+"-direction-"+str(i))
		for god in ["Lliira","Tou Um"]:
			sprite.modulate=DivineVisuals.DIVINE_THEMES[god].primary
			await shot(weapon+"-tint-"+god.to_lower().replace(" ","-"))
		effect.free()
		Game.profile.data.settings.reduced_impact=true
		run._swing(event,run._divine_theme())
		assert(run.fx.get_child(run.fx.get_child_count()-1) is Polygon2D)
		await shot(weapon+"-reduced")
		Game.profile.data.settings.reduced_impact=false
		var shape:=MeleeVfx.shape_for(weapon,event.dtype)
		var cached: SpriteFrames=MeleeVfx._frames[shape]
		MeleeVfx._frames[shape]=null
		run._swing(event,run._divine_theme())
		assert(run.fx.get_child(run.fx.get_child_count()-1) is Polygon2D)
		await shot(weapon+"-missing-fallback")
		MeleeVfx._frames[shape]=cached
		run.queue_free()
		await get_tree().process_frame
	checks.append("four real swing events, 24 phases, 32 directions, eight tint cases, reduced/missing fallback, calibrated reach, simulation snapshot parity")
	for hero in ["brook","maelor"]:
		var run: Node=await make_run(hero)
		var b: Battle=run.battle
		b.hero.hp=1
		assert(b.use_active())
		var events: Array=b.events.filter(func(e: Dictionary)->bool:return e.type=="active")
		assert(events.size()==1)
		var event: Dictionary=events[0].duplicate(true)
		var before:=snapshot(b)
		run._consume_events()
		assert(snapshot(b)==before)
		var effect: Node2D=run._active_vfx[hero]
		effect.set_process(false)
		var fps: float=HeroActiveVfx.CONFIG[hero].fps
		for frame in 6:
			effect.age=float(frame)/fps+.001
			effect._process(0.0)
			assert(effect.sprite.frame==frame)
			await shot(hero+"-phase-"+str(frame))
		for god in ["Lliira","Tou Um"]:
			effect.sprite.modulate=DivineVisuals.DIVINE_THEMES[god].aura_accent
			await shot(hero+"-tint-"+god.to_lower().replace(" ","-"))
		b.hero.pos+=Vector2(1,1)
		run._sync()
		effect._process(0.0)
		assert(effect.position.is_equal_approx(Iso.to_screen(b.hero.pos)))
		await shot(hero+"-follow")
		effect.age=.1
		b.state="levelup"
		effect._process(1.0)
		assert(effect.age==.1)
		b.state="running"
		get_tree().paused=true
		effect._process(1.0)
		assert(effect.age==.1)
		get_tree().paused=false
		before=snapshot(b)
		if hero=="brook":
			b.invuln=0
			var hp: float=b.hero.hp
			b._hurt_hero(1.0,"hit")
			assert(b.active_guard==0 and b.hero.hp==hp)
			effect._process(0.0)
			assert(effect.is_queued_for_deletion())
			await get_tree().process_frame
			assert(not is_instance_valid(effect))
			b.active_cd=0
			assert(b.use_active())
			assert(run._hero_active_effect(event))
			effect=run._active_vfx[hero]
			effect.set_process(false)
			b._update_effect_timers(4.01)
			effect._process(0.0)
			assert(effect.is_queued_for_deletion())
		else:
			effect.age=0
			effect._process(.61)
			assert(effect.is_queued_for_deletion() and snapshot(b)==before)
		await get_tree().process_frame
		await shot(hero+"-expired")
		if hero=="brook":b.active_guard=1;b.active_guard_t=4.0
		assert(run._hero_active_effect(event))
		var old: Node=run._active_vfx[hero]
		assert(run._hero_active_effect(event))
		assert(old.is_queued_for_deletion())
		await get_tree().process_frame
		effect=run._active_vfx[hero]
		effect.set_process(false)
		Game.profile.data.settings.reduced_impact=true
		effect._process(0.0)
		assert(effect.is_queued_for_deletion())
		b.events=[event]
		run._consume_events()
		assert(run.fx.get_child(run.fx.get_child_count()-1) is Line2D)
		await shot(hero+"-reduced-fallback")
		Game.profile.data.settings.reduced_impact=false
		var cached: SpriteFrames=HeroActiveVfx._frames[hero]
		HeroActiveVfx._frames[hero]=null
		b.events=[event]
		run._consume_events()
		assert(run.fx.get_child(run.fx.get_child_count()-1) is Line2D)
		await shot(hero+"-missing-fallback")
		HeroActiveVfx._frames[hero]=cached
		assert(run._hero_active_effect(event))
		effect=run._active_vfx[hero]
		b.state="won"
		effect._process(0.0)
		assert(effect.is_queued_for_deletion())
		var weak: WeakRef=weakref(effect)
		run.queue_free()
		await get_tree().process_frame
		assert(weak.get_ref()==null)
	checks.append("two real actives, 12 phases, follow, pause, guard consumed/4s expiry, Maelor 0.6s/no repeated heal, replace bound, reduced/missing fallbacks, won/runfree cleanup, simulation snapshot parity")
	var run: Node=await make_run("maelor")
	for wid in ["estocada_mistica","chicote_avarento","espada_sombria","golpe_atordoante"]:
		var w:=Weapon.make(wid)
		run.battle.events.clear()
		assert(run.battle._fire(w,w.params()))
		run._consume_events()
		var effect:=animated_effect(run)
		assert(effect!=null)
		var sprite:=effect.get_child(0) as AnimatedSprite2D
		sprite.pause();sprite.frame=2
		await shot("regression-"+wid)
		effect.free()
	run.queue_free()
	await get_tree().process_frame
	for hero in ["sylas","kayron","korrak","leoric","nyrelia","zynara","bromnor","arlindo","erik"]:
		var other: Node=await make_run(hero)
		assert(other.battle.use_active(Vector2.RIGHT))
		var active_events: Array=other.battle.events.filter(func(e: Dictionary)->bool:return e.type=="active")
		assert(active_events.size()==1 and not HeroActiveVfx.supports(active_events[0]))
		var before:=snapshot(other.battle)
		other._consume_events()
		assert(other._active_vfx.is_empty() and snapshot(other.battle)==before)
		await shot("regression-active-"+hero)
		other.queue_free()
		await get_tree().process_frame
	checks.append("nine other hero actives unchanged, no new dispatch; simulation snapshot parity")
	var report:={"status":"PASS","screenshots":shots,"checks":checks,"human_playtest":false,"simulation_unchanged_by_presentation":true}
	FileAccess.open(OUT+"runtime-checks.json",FileAccess.WRITE).store_string(JSON.stringify(report,"\t")+"\n")
	print("L001 capture PASS: ",shots.size()," rendered shots")
	get_tree().quit()
