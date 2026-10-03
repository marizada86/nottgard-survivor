extends Node

func _ready() -> void:
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345}
	DirAccess.make_dir_recursive_absolute("res://.atena/generated/priority-review")
	var title: Node = load("res://ui/title.tscn").instantiate()
	add_child(title)
	await get_tree().create_timer(0.8).timeout
	await _capture("title")
	title.queue_free()
	await get_tree().process_frame
	for stage in ["dagruve", "docas"]:
		Game.run_stage = stage
		Game.run_hero = "durvall"
		var run: Node = load("res://ui/run.tscn").instantiate()
		add_child(run)
		await get_tree().create_timer(0.5).timeout
		run.set_process(false)
		run.set_physics_process(false)
		for spot in ([Vector2(22, 24), Vector2(42, 38), Vector2(36, 41)] if stage == "dagruve" else [Vector2(22, 8), Vector2(40, 14), Vector2(28, 22), Vector2(32, 16), Vector2(9, 30)]):
			run.camera.position = Iso.to_screen(spot)
			await get_tree().create_timer(0.25).timeout
			await _capture("%s_%d_%d" % [stage, spot.x, spot.y])
		run.queue_free()
		await get_tree().process_frame
	Game.run_stage = "dagruve"
	Game.run_hero = "sylas"
	var sylas_run: Node = load("res://ui/run.tscn").instantiate()
	add_child(sylas_run)
	await get_tree().create_timer(0.5).timeout
	sylas_run.set_process(false)
	sylas_run.set_physics_process(false)
	var origin: Vector2 = sylas_run.battle.hero.pos
	sylas_run.battle.decoys.append({"id": 9999, "pos": origin + Vector2(2, 0)})
	sylas_run._sync_decoys()
	await _capture("sylas_decoy")
	sylas_run._shadow_blast(origin + Vector2(3, 0), 2.0)
	await get_tree().create_timer(0.17).timeout
	await _capture("sylas_blast")
	for i in 3:
		sylas_run.battle.interactions.append({"kind": ["ampulheta", "doacao", "aposta"][i], "pos": origin + Vector2(-3 + i * 3, 3), "used": false, "born_at": -5.0})
	await _capture("events")
	sylas_run._play_sheet_effect("res://assets/vfx/vfx_subida_de_nivel.png", origin, 1.8, 0.48)
	await get_tree().create_timer(0.27).timeout
	await _capture("levelup_effect")
	sylas_run.battle.evolve_cine = {"from": "espada_sombria", "into": "espada_do_receptaculo", "passive": "cota_de_malha", "level": 5}
	sylas_run.hud.show_evolution(sylas_run.battle)
	await get_tree().create_timer(0.6).timeout
	await _capture("evolution_panel")
	sylas_run.queue_free()
	await get_tree().process_frame
	get_tree().quit()

func _capture(label: String) -> void:
	await RenderingServer.frame_post_draw
	var image := get_viewport().get_texture().get_image()
	print("capture ", label, " result=", image.save_png("res://.atena/generated/priority-review/%s.png" % label))
