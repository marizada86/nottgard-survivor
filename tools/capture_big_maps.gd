extends Node
## SPEC-152: capturas dos mapas 84x84 (visão geral e quatro cantos). Uso:
##   godot --path . res://tools/capture_big_maps.tscn -- <fase> <rotulo>
## Saída em .atena/generated/big-maps/.

func _ready() -> void:
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345}
	var a := OS.get_cmdline_user_args()
	var stage: String = a[0] if a.size() > 0 else "shedaklah"
	var tag: String = a[1] if a.size() > 1 else "v1"
	DirAccess.make_dir_recursive_absolute("res://.atena/generated/big-maps")
	Game.run_stage = stage
	Game.run_hero = "durvall"
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	await get_tree().create_timer(0.6).timeout
	run.set_process(false)
	run.set_physics_process(false)
	var side := float(run.battle.map_size.x)
	for spot in [Vector2(10, 10), Vector2(side - 10.0, 10), Vector2(10, side - 10.0), Vector2(side - 10.0, side - 10.0)]:
		run.camera.position = Iso.to_screen(spot)
		run.camera.zoom = Vector2(0.6, 0.6)
		await get_tree().create_timer(0.25).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png("res://.atena/generated/big-maps/%s_%s_%d_%d.png" % [stage, tag, spot.x, spot.y])
	run.camera.position = Iso.to_screen(Vector2(side, side) * 0.5)
	run.camera.zoom = Vector2(0.22, 0.22)
	await get_tree().create_timer(0.3).timeout
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("res://.atena/generated/big-maps/%s_%s_overview.png" % [stage, tag])
	# SPEC-152: cada ponto de interesse com o herói por perto (o Eco brilha a até eco_pista tiles)
	var b: Battle = run.battle
	for poi in b.secrets_spec().get("pois", []):
		var at := Vector2(float(poi.pos[0]), float(poi.pos[1]))
		b.hero.pos = at + Vector2(-3.0, 1.5)
		run.hero_node.position = Iso.to_screen(b.hero.pos)
		run.camera.position = Iso.to_screen(at)
		run.camera.zoom = Vector2(0.9, 0.9)
		await get_tree().create_timer(0.25).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png("res://.atena/generated/big-maps/%s_%s_poi_%s.png" % [stage, tag, String(poi.kind)])
	print("capture_big_maps: %s lado=%d props=%d" % [stage, int(side), run.sorted.get_child_count()])
	get_tree().quit()
