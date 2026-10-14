extends SceneTree
const OUT := "res://.atena/generated/assets-l002-admission-2026-10-14/"
var counts := {"scenarios":0,"steps":0,"successful_actives":0,"failed_actives":0,"short_dash":0,"zero_dash":0,"target_metadata":0,"origin_metadata":0}

func _init() -> void:call_deferred("check")

func normalized(value: Variant,b: Battle) -> Variant:
	if value is Enemy:return b.enemies.find(value)
	if value is Dictionary:
		var result: Dictionary={}
		for key in value:
			if key in ["visual_origin","visual_target_id"]:continue
			if key=="tid":
				result[key]=-1
				for e in b.enemies:
					if e.get_instance_id()==value[key]:result[key]=b.enemies.find(e)
			else:result[key]=normalized(value[key],b)
		return result
	if value is Array:
		var result: Array=[]
		for v in value:result.append(normalized(v,b))
		return result
	return value

func snapshot(b: Battle) -> Dictionary:
	var enemies: Array=[]
	for e in b.enemies:enemies.append({"id":e.id,"hp":e.hp,"pos":e.pos,"dead":e.dead,"ca":e.ca,"cam":e.cam,"charm":e.charmed_t,"mark":e.mark,"mark_t":e.mark_t,"stun":e.stun_t,"slow":e.slow_t,"burn":e.burn_t,"burn_dps":e.burn_dps})
	var projectiles: Array=[]
	for pr in b.projectiles:
		var hits: Array=[]
		for enemy in pr.hit:hits.append(b.enemies.find(enemy))
		projectiles.append({"pos":pr.pos,"dir":pr.dir,"life":pr.life,"speed":pr.speed,"pierce":pr.pierce,"p":pr.p,"hit":hits})
	var weapons: Array=[]
	for w in b.hero.weapons:weapons.append([w.id,w.level,w.timer])
	return {"rng":b.rng.state,"hero":[b.hero.hp,b.hero.pos,b.hero.dead],"guard":[b.active_guard,b.active_guard_t],"timers":[b.active_cd,b.active_buff_t,b.time_slow_t,b.projectile_slow_t,b.barrier,b.invuln],"weapons":weapons,"stats":b.stats.duplicate(true),"damage":b.run_record.damage.duplicate(true),"healing":b.run_record.healing,"enemies":enemies,"projectiles":projectiles,"decoys":normalized(b.decoys,b),"zones":normalized(b.zones,b),"events":normalized(b.events,b),"state":b.state,"time":b.time}

func setup(b: Battle,mode: String) -> void:
	b.hero.pos=Vector2(20,20)
	b.hero.hp=b.hero.max_hp*.5
	b.hero.blockers=[]
	b.aim=Battle.Aim.MOUSE
	b.aim_dir=Vector2.RIGHT
	if mode!="empty":
		b.spawn_for_test(String(b.stage.boss),Vector2(21,20)) if mode=="boss" else b.spawn_for_test("zumbi",Vector2(21,20))
		b.enemies[-1].hp=10000
		b.enemies[-1].max_hp=10000
		if mode=="boss":assert(b.enemies[-1].is_boss())
	if mode=="blocked":b.hero.blockers=[Vector3(22,20,3.0)]
	if mode=="short":b.hero.blockers=[Vector3(23,20,.4)]
	b.events.clear()

func check() -> void:
	var baseline=load(OUT+"baseline_battle.gd")
	for hero in ["sylas","kayron","korrak","leoric","nyrelia","zynara","bromnor"]:
		for mode in ["normal","empty","boss","blocked","short"]:
			for seed_value in range(1,5):
				var old: Battle=baseline.new(seed_value,hero,"dagruve")
				var current:=Battle.new(seed_value,hero,"dagruve")
				setup(old,mode);setup(current,mode)
				var origin:=current.hero.pos
				var used:=current.use_active(Vector2.RIGHT)
				assert(old.use_active(Vector2.RIGHT)==used)
				if used:counts.successful_actives+=1
				else:counts.failed_actives+=1
				for event in current.events:
					if event.has("visual_origin"):
						assert(hero=="sylas" and event.visual_origin==origin)
						counts.origin_metadata+=1
						var length: float=event.pos.distance_to(origin)
						if length<=.01:counts.zero_dash+=1
						elif length<3.49:counts.short_dash+=1
					if event.has("visual_target_id"):
						assert(hero=="nyrelia" and current.enemies[0].get_instance_id()==event.visual_target_id)
						counts.target_metadata+=1
				assert(snapshot(old)==snapshot(current),"activation mismatch "+hero+"/"+mode)
				old.events.clear();current.events.clear()
				for step in 90:
					old.step(Vector2.ZERO,.1);current.step(Vector2.ZERO,.1)
					assert(snapshot(old)==snapshot(current),"step mismatch "+hero+"/"+mode+"/"+str(step))
					old.events.clear();current.events.clear()
					counts.steps+=1
				counts.scenarios+=1
	assert(counts.failed_actives>0 and counts.short_dash>0 and counts.zero_dash>0 and counts.target_metadata>0)
	var result:={"status":"PASS","comparison":"Original use_active baseline vs current, full Battle.step for9seconds/scenario; only visual_origin/visual_target_id excluded, Enemy/target instance IDs canonicalized.","counts":counts}
	FileAccess.open(OUT+"parity.json",FileAccess.WRITE).store_string(JSON.stringify(result,"\t")+"\n")
	print("L002 simulation parity PASS ",counts)
	quit()
