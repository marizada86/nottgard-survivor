extends Node

const DIRECTORY := "res://.atena/generated/art032-implementation-2026-10-12/"
var viewport: SubViewport
var run: Node
var records: Array = []

func _ready() -> void:
	call_deferred("_capture_all")

func _definition(stage: String, id: String) -> Dictionary:
	for d in Data.table("stage_events")[stage]:
		if String(d.id) == id:
			return d.duplicate(true)
	return {}

func _fire(id: String) -> void:
	run.battle.happenings.fire(run.battle, _definition(run.battle.stage_id, id))

func _new_stage(stage: String) -> void:
	if is_instance_valid(viewport):
		viewport.queue_free()
		await get_tree().process_frame
	Game.run_stage = stage
	viewport = SubViewport.new()
	viewport.size = Vector2i(1280, 720)
	viewport.disable_3d = true
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	add_child(viewport)
	run = load("res://ui/run.tscn").instantiate()
	viewport.add_child(run)
	await get_tree().process_frame
	run.set_process(false)
	run.set_physics_process(false)
	run.battle.time = 60.0
	run.battle.enemies.clear()
	run.battle.interactions.clear()
	run.battle.pickups.clear()
	run.battle.zones.clear()
	run.battle.events.clear()
	run.battle.happenings.reset()
	run.battle.hero.max_hp = 9999
	run.battle.hero.hp = 9999
	run.battle.stage.waves = []
	run.battle.stage.elites = []
	run.camera.zoom = Vector2.ONE
	await get_tree().process_frame

func _position_for(index: int) -> Vector2:
	var x := -330.0 + (index % 4) * 220.0
	var y := -60.0 + floori(index / 4.0) * 145.0
	return run.battle.hero.pos + Iso.to_ground(Vector2(x, y))

func _place() -> void:
	var index := 0
	for it in run.battle.interactions:
		if bool(it.used):
			continue
		it.pos = _position_for(index)
		it.born_at = -5.0
		index += 1
	for ally in run.battle.happenings.allies:
		ally.pos = _position_for(index)
		index += 1
	for enemy in run.battle.enemies:
		if not enemy.dead:
			enemy.pos = _position_for(index)
			index += 1
	run.battle.events.clear()
	run._sync()
	run.hud.update_stats(run.battle)
	run.camera.position = run.hero_node.position
	await get_tree().process_frame
	await get_tree().process_frame

func _shot(tag: String) -> void:
	await _place()
	# Let entry toasts/barks expire before inspecting objective text and actor art.
	await get_tree().create_timer(5.0).timeout
	run.hud.toast_box.hide() # Suppress only transient entry text in this controlled QA fixture.
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var path := DIRECTORY.path_join(tag + ".png")
	var status := viewport.get_texture().get_image().save_png(path)
	var assets: Array = []
	for it in run.battle.interactions:
		if not bool(it.used) and String(it.get("asset", "")) != "":
			assets.append(String(it.asset))
	for ally in run.battle.happenings.allies:
		if String(ally.get("asset", "")) != "":
			assets.append(String(ally.asset))
	for enemy in run.battle.enemies:
		if not enemy.dead:
			assets.append(String(enemy.id))
	records.append({"stage":run.battle.stage_id,"tag":tag,"path":path,"size":[1280,720],"save_status":status,"assets":assets,"transient_intro_toasts_cleared":true,"kind":"SYNTHETIC_REAL_RUNTIME_CAPTURE_NOT_PLAYTEST"})
	print("Captured ",tag," status=",status)
	if status != OK:
		get_tree().quit(1)

func _capture_all() -> void:
	Game.profile = Profile.new({"name":"QA ART032", "welcome_seen":true})
	Game.profile.data.settings.volume = 0
	Game.profile.data.settings.music_volume = 0
	Game.profile.data.settings.sfx_volume = 0
	for id in Data.table("hqs"):
		Game.profile.data.hqs_seen[id] = true
	Game.qa_sandbox = true
	Game.qa_launch = {"seed":12345}
	Game.run_hero = "durvall"
	Playtest.visible = false
	await _new_stage("shedaklah")
	_fire("pedido_de_zuggtmoy")
	var carrier: Array = run.battle.enemies.filter(func(e):return e.event_item != "")
	run.battle._kill(carrier[0])
	run.battle.enemies.clear()
	run.battle.pickups.clear()
	_fire("portal_sem_vao")
	_fire("barqueiro_do_estige")
	run.battle._spawn("manifestacao_de_juiblex", run.battle.hero.pos)
	await _shot("shedaklah")
	await _new_stage("molor")
	_fire("ritual_de_estagnacao")
	run.battle.enemies.clear()
	await _shot("molor")
	await _new_stage("durao")
	_fire("desertores")
	_fire("vhaerith_na_jaula")
	await _shot("durao")
	await _new_stage("feng_tu")
	_fire("escolta_do_peregrino")
	_fire("peregrinacao_da_estrela")
	await _shot("feng_tu")
	await _new_stage("shendilavri")
	_fire("vitimas_drenadas")
	_fire("mercador_de_rivenheart")
	run.battle.happenings._apply_reward(run.battle, _definition("shendilavri","vitimas_drenadas").reward, run.battle.hero.pos)
	await _shot("shendilavri")
	await _new_stage("goranthis")
	_fire("o_nome_tres_vezes")
	await _shot("goranthis_pacto")
	run.battle.interactions.clear()
	run.battle.happenings._apply_reward(run.battle, _definition("goranthis","o_nome_tres_vezes").choices[0].effect, run.battle.hero.pos)
	await _shot("goranthis_aliado")
	var file := FileAccess.open(DIRECTORY.path_join("captures.json"), FileAccess.WRITE)
	file.store_string(JSON.stringify({"status":"PASS", "records":records, "profile":Game._save_path, "simulation_frozen":true, "layout":"controlled for asset visibility, rendered by actual run/overlay/enemy scenes", "human_playtest":"NOT_PERFORMED"},"  ")+"\n")
	file.close()
	get_tree().quit(0)
