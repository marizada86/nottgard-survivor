extends Node
## SPEC-164 (MEC-005): capturas dos seis eventos aleatórios (losangos no mapa, tela de oferta, chip do eclipse).
## godot --path . res://tools/capture_random_events.tscn --resolution 1280x720

var _dir := "res://.atena/generated/plan-091/capturas/"

func _shot(name: String) -> void:
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var size := get_viewport().get_visible_rect().size
	get_viewport().get_texture().get_image().save_png("%s%s_%dx%d.png" % [_dir, name, int(size.x), int(size.y)])

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_dir))
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345}
	Game.run_stage = "dagruve"
	Game.run_hero = "sylas"
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	await get_tree().create_timer(0.6).timeout
	run.set_process(false)
	run.set_physics_process(false)
	var b: Battle = run.battle
	var offsets := [Vector2(-5, -2), Vector2(-3, 2.5), Vector2(0, -3.5), Vector2(3, 2.5), Vector2(5, -2), Vector2(0, 4.5)]
	for i in RandomEvents.KINDS.size():
		b.interactions.append({"kind": RandomEvents.KINDS[i], "pos": b.hero.pos + offsets[i], "used": false, "born_at": -5.0})
	run.hud.update_stats(b)
	await get_tree().create_timer(0.3).timeout
	await _shot("01_losangos")
	b.interactions.clear()
	for kind in ["pacto_sangue", "contador", "eclipse_pedra"]:
		b.hero.gold = 300
		b._open_random_event(kind)
		run._refresh_offer()
		await get_tree().create_timer(0.2).timeout
		await _shot("02_oferta_%s" % kind)
		b.choose(b.offer.size() - 1)   # Sair
		run._refresh_offer()
	b.hero.hp = b.hero.max_hp
	b.world_mod = {"id": "rubro", "name": "Eclipse Rubro", "enemy_speed": 1.25, "enemy_dmg": 1.25, "xp": 1.5, "gold": 1.5, "t": 72.0}
	run.hud.update_stats(b)
	await get_tree().create_timer(0.2).timeout
	await _shot("03_chip_eclipse")
	get_tree().quit()
