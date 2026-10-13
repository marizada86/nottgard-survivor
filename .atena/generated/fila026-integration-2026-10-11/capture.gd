extends Node

var host: Node
var directory := "res://.atena/generated/fila026-integration-2026-10-11/"
var records: Array = []

func _finish() -> void:
	var size := Vector2i(records[-1].size[0], records[-1].size[1])
	var report := FileAccess.open(directory + "captures_%dx%d.json" % [size.x, size.y], FileAccess.WRITE)
	report.store_string(JSON.stringify({"records": records, "profile": Game._save_path, "kind": "real_runtime_synthetic_QA", "touch_preview": Game.touch_controls_enabled()}, "  ") + "\n")
	report.close()
	get_tree().quit(0)

func _ready() -> void:
	call_deferred("_run")

func _shot(tag: String) -> void:
	await get_tree().create_timer(0.35).timeout
	await RenderingServer.frame_post_draw
	var image := get_viewport().get_texture().get_image()
	var size := image.get_size()
	var path := directory + "%s_%dx%d.png" % [tag, size.x, size.y]
	var status := image.save_png(path)
	records.append({"screen": tag, "size": [size.x, size.y], "path": path, "save_status": status})
	print("capture ", tag, " ", size, " status=", status)

func _run() -> void:
	host = Node.new()
	add_child(host)
	Game.profile = Profile.new({"name": "QA Lettering", "welcome_seen": true, "coins": 1234})
	Game.profile.data.settings.volume = 0
	Game.profile.data.settings.reduced_impact = true
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345}
	var args := OS.get_cmdline_user_args()
	if Game.touch_controls_enabled():
		directory += "mobile/"
		DirAccess.make_dir_recursive_absolute(directory)
	var size_arg := args.find("--capture-size")
	if size_arg >= 0 and size_arg + 1 < args.size():
		DisplayServer.window_set_size(Game.resolution_to_size(args[size_arg + 1]))
	for id in Data.table("hqs"):
		Game.profile.data.hqs_seen[id] = true
	Playtest.visible = false
	var title := load("res://ui/title.tscn").instantiate() as Control
	host.add_child(title)
	await get_tree().create_timer(0.8).timeout
	await _shot("titulo")
	title.queue_free()
	await get_tree().process_frame
	var menu := load("res://ui/menu.tscn").instantiate() as Control
	host.add_child(menu)
	await _shot("quartel")
	if Game.touch_controls_enabled():
		var title_rect: Rect2 = menu.get_node("Title").get_global_rect()
		var subtitle_rect: Rect2 = menu.get_node("Subtitle").get_global_rect()
		var tabs_rect: Rect2 = menu.get_node("Tabs").get_global_rect()
		var layout := {"title_bottom": title_rect.end.y, "subtitle_top": subtitle_rect.position.y, "subtitle_bottom": subtitle_rect.end.y, "tabs_top": tabs_rect.position.y, "overlap": title_rect.intersects(subtitle_rect) or subtitle_rect.intersects(tabs_rect)}
		var report := FileAccess.open(directory + "header-layout.json", FileAccess.WRITE)
		report.store_string(JSON.stringify(layout, "  ") + "\n")
		report.close()
		_finish()
		return
	menu.queue_free()
	await get_tree().process_frame
	var hq := load("res://ui/hq_screen.tscn").instantiate() as Control
	host.add_child(hq)
	hq.start_hq(Data.table("hqs").values()[0])
	await _shot("hq")
	hq.queue_free()
	await get_tree().process_frame
	Game.run_stage = "dagruve"
	Game.run_hero = "durvall"
	var run := load("res://ui/run.tscn").instantiate() as Node
	host.add_child(run)
	await get_tree().create_timer(0.5).timeout
	run.set_process(false)
	run.set_physics_process(false)
	var battle: Battle = run.battle
	var hud = run.hud
	var res: Dictionary = battle.result()
	var summary := {"earned": 123, "coins": 1357, "reward_rate": 1.0, "achievements": []}
	res.won = true
	hud.show_result(res, summary)
	await _shot("vitoria")
	res.won = false
	hud.show_result(res, summary)
	await _shot("derrota")
	hud.result_panel.hide()
	battle.evolve_cine = {"from": "espada_sombria", "into": "espada_do_receptaculo", "passive": "cota_de_malha", "level": 5}
	hud.show_evolution(battle)
	await get_tree().create_timer(0.3).timeout
	await _shot("evolucao")
	hud.hide_evolution()
	run._show_boss_intro({"enemy": {"id": "sacerdote_mente_derretida", "name": "Sacerdote da Mente Derretida"}, "presentation": Data.table("boss_presentations")["sacerdote_mente_derretida"]})
	await _shot("chefe")
	run._boss_intro_panel.hide()
	hud.show_items_panel(battle)
	await _shot("ficha")
	_finish()
