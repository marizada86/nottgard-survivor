extends Node
const OUT := "res://.atena/generated/assets-l002-admission-2026-10-14/"
var shots: Array[String]=[]
var checks: Array[String]=[]

func shot(tag: String) -> void:
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	assert(get_viewport().get_texture().get_image().save_png(OUT+"captures/"+tag+".png")==OK)
	shots.append(tag)

func snapshot(b: Battle) -> Dictionary:
	var enemies: Array=[]
	for e in b.enemies:enemies.append([e.hp,e.pos,e.dead,e.charmed_t,e.ca,e.mark,e.stun_t,e.burn_t])
	return {"rng":b.rng.state,"hp":b.hero.hp,"pos":b.hero.pos,"guard":b.active_guard,"guard_t":b.active_guard_t,"buff":b.active_buff_t,"slow":b.time_slow_t,"cd":b.active_cd,"healing":b.run_record.healing,"damage":b.run_record.damage.duplicate(true),"stats":b.stats.duplicate(true),"enemies":enemies,"projectiles":b.projectiles.size()}

func make_run(hero: String) -> Node:
	Game.run_hero=hero;Game.run_stage="dagruve"
	var run: Node=load("res://ui/run.tscn").instantiate()
	add_child(run)
	await get_tree().create_timer(.25).timeout
	run.set_process(false);run.set_physics_process(false)
	run.over._ensure_orb_layer();run.over._orb_layer.set_process(false)
	run.battle.aim=Battle.Aim.MOUSE;run.battle.aim_dir=Vector2.RIGHT
	run.battle.enemies.clear();run.battle.projectiles.clear();run.battle.events.clear()
	run.battle.hero.blockers=[]
	run.battle.spawn_for_test("zumbi",run.battle.hero.pos+Vector2(1,0))
	run.battle.enemies[-1].hp=10000
	run._sync()
	run.camera.position=run.hero_node.position+Vector2(0,-30)
	return run

func spawn_visual(run: Node,event: Dictionary) -> Node2D:
	if event.type=="nova":run._nova_effect(event)
	else:assert(run._hero_active_effect(event))
	var effect: Node2D=run._active_vfx[run.battle.hero.id]
	effect.set_process(false)
	return effect

func _ready() -> void:
	get_tree().create_timer(55).timeout.connect(func():printerr("L002 capture timeout");get_tree().quit(1))
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUT+"captures"))
	Playtest.visible=false;Game.qa_sandbox=true;Game.qa_launch={"seed":4242}
	Game._save_path="user://l002-capture-profile.json"
	Game.profile=Profile.new({"name":"L002 QA","welcome_seen":true})
	for id in Data.table("hqs"):Game.profile.data.hqs_seen[id]=true
	for hero in ["sylas","kayron","korrak","leoric","nyrelia","zynara","bromnor"]:
		var run: Node=await make_run(hero)
		var b: Battle=run.battle
		assert(b.use_active(Vector2.RIGHT))
		var events: Array=b.events.filter(func(e: Dictionary)->bool:return HeroActiveVfx.supports(e))
		assert(events.size()==1)
		var event: Dictionary=events[0].duplicate(true)
		var before:=snapshot(b)
		run._consume_events()
		assert(snapshot(b)==before)
		run._sync()
		var effect: Node2D=run._active_vfx[hero]
		effect.set_process(false)
		var fps: float=HeroActiveVfx.CONFIG[hero].fps
		for frame in 6:
			effect.age=float(frame)/fps+.0001
			effect._process(0.0)
			assert(effect.sprite.frame==frame)
			await shot(hero+"-phase-"+str(frame))
		var fixed_position:=effect.position
		b.hero.pos+=Vector2(.5,.5)
		if hero=="nyrelia":
			effect.target.pos+=Vector2(.5,-.5)
			b.spawn_for_test("zumbi",b.hero.pos+Vector2(.1,0))
			effect._process(0.0)
			assert(effect.position==Iso.to_screen(effect.target.pos) and effect.target==b.enemies[0])
		elif hero=="kayron":
			effect._process(0.0)
			assert(effect.position==Iso.to_screen(b.hero.pos))
		else:
			effect._process(0.0)
			assert(effect.position==fixed_position)
		run._sync()
		await shot(hero+"-anchor-or-follow")
		effect.age=.1;b.state="levelup";effect._process(1.0);assert(effect.age==.1)
		b.state="running";get_tree().paused=true;effect._process(1.0);assert(effect.age==.1);get_tree().paused=false
		for god in ["Lliira","Tou Um"]:
			b.visual_god=god;b.visual_boon_selected=true
			if event.type=="nova":event.visual_theme=DivineVisuals.DIVINE_THEMES[god]
			effect=spawn_visual(run,event)
			effect.age=2.0/fps+.0001;effect._process(0.0)
			var color: Color=DivineVisuals.DIVINE_THEMES[god].impact_accent if event.type=="nova" else DivineVisuals.DIVINE_THEMES[god].aura_accent
			assert(effect.sprite.modulate==color)
			await shot(hero+"-tint-"+god.to_lower().replace(" ","-"))
		if hero=="sylas":
			var origin: Vector2=event.visual_origin
			var length: float=event.pos.distance_to(origin)
			for i in 8:
				var oriented:=event.duplicate(true)
				var direction:=Vector2.from_angle(i*TAU/8)
				oriented.pos=origin+direction*length
				effect=spawn_visual(run,oriented)
				effect.age=.1001;effect._process(0.0)
				var endpoint:=effect.transform.basis_xform(Vector2(117.0*effect.sprite.scale.x,0))
				assert(endpoint.distance_to(Iso.to_screen(direction*length))<0.001)
				await shot("sylas-direction-"+str(i))
			effect.free()
			b.active_cd=0
			b.hero.blockers=[Vector3(b.hero.pos.x+3,b.hero.pos.y,.4)]
			var start:=b.hero.pos
			assert(b.use_active(Vector2.RIGHT))
			var short_events:=b.events.filter(func(e: Dictionary)->bool:return HeroActiveVfx.supports(e))
			assert(short_events.size()==1 and b.hero.pos.distance_to(start)<3.49 and b.hero.pos!=start)
			effect=spawn_visual(run,short_events[0]);effect.age=.1001;effect._process(0.0)
			run._sync();await shot("sylas-short-real-dash")
			effect.free()
			b.active_cd=0;b.events.clear()
			b.hero.blockers=[Vector3(b.hero.pos.x+2,b.hero.pos.y,3)]
			assert(b.use_active(Vector2.RIGHT))
			var zero_events:=b.events.filter(func(e: Dictionary)->bool:return e.type=="active")
			assert(zero_events.size()==1 and zero_events[0].pos==zero_events[0].visual_origin)
			assert(not run._hero_active_effect(zero_events[0]))
			run._consume_events();await shot("sylas-zero-real-dash-fallback")
			b.hero.blockers=[]
			effect=spawn_visual(run,event)
		if hero=="leoric":assert(b.projectiles.size()==8 and effect.radius==2.0 and event.radius==11.0)
		if hero=="zynara":assert(b.time_slow_t==4.0 and event.radius==7.0)
		if hero=="bromnor":assert(b.active_guard==1 and b.active_guard_t==5.0)
		if hero=="kayron":
			b._update_effect_timers(7.01);effect._process(0.0)
			assert(effect.is_queued_for_deletion())
			b.active_buff_t=7.0
		elif hero=="nyrelia":
			var target: Enemy=effect.target
			for ending in ["expired","dead","removed"]:
				effect=spawn_visual(run,event)
				if ending=="expired":target.charmed_t=0
				elif ending=="dead":target.dead=true
				else:b.enemies.erase(target)
				effect._process(0.0);assert(effect.is_queued_for_deletion())
				await get_tree().process_frame
				await shot("nyrelia-target-"+ending)
				target.charmed_t=7.0;target.dead=false
				if not b.enemies.has(target):b.enemies.append(target)
		else:
			before=snapshot(b)
			effect.age=0;effect._process(.36)
			assert(effect.is_queued_for_deletion() and snapshot(b)==before)
		await get_tree().process_frame
		await shot(hero+"-expired")
		effect=spawn_visual(run,event)
		var weak: WeakRef=weakref(effect)
		var old: Node=effect
		effect=spawn_visual(run,event)
		assert(old.is_queued_for_deletion())
		await get_tree().process_frame
		assert(weak.get_ref()==null)
		Game.profile.data.settings.reduced_impact=true
		effect._process(0.0);assert(effect.is_queued_for_deletion())
		b.events=[event];run._consume_events()
		assert(run.fx.get_child(run.fx.get_child_count()-1) is Line2D)
		await shot(hero+"-reduced-fallback")
		Game.profile.data.settings.reduced_impact=false
		var cached: SpriteFrames=HeroActiveVfx._frames[hero]
		HeroActiveVfx._frames[hero]=null
		b.events=[event];run._consume_events()
		assert(run.fx.get_child(run.fx.get_child_count()-1) is Line2D)
		await shot(hero+"-missing-texture-fallback")
		HeroActiveVfx._frames[hero]=cached
		if hero in ["sylas","nyrelia"]:
			var absent:=event.duplicate(true)
			absent.erase("visual_origin" if hero=="sylas" else "visual_target_id")
			assert(not run._hero_active_effect(absent))
			b.events=[absent];run._consume_events()
			assert(run.fx.get_child(run.fx.get_child_count()-1) is Line2D)
			await shot(hero+"-missing-metadata-fallback")
		effect=spawn_visual(run,event)
		b.state="dead";effect._process(0.0);assert(effect.is_queued_for_deletion())
		run.queue_free();await get_tree().process_frame
		checks.append(hero+": real activation/sixphases/tints/anchor/lifecycle/pause/fallback/recast/dead/runfree and presentation state parity")
	var result:={"status":"PASS","screenshots":shots,"checks":checks,"human_playtest":false,"simulation_unchanged_by_presentation":true,"sylas_directions":8,"sylas_short_and_zero_real_dash":true,"nyrelia_target_fixed_death_removal_expiry":true,"leoric_projectiles":8,"zynara_logical_duration":4,"bromnor_guard_duration":5}
	FileAccess.open(OUT+"runtime-checks.json",FileAccess.WRITE).store_string(JSON.stringify(result,"\t")+"\n")
	print("L002 capture PASS: ",shots.size()," rendered shots")
	get_tree().quit()
