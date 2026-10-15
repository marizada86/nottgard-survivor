extends Node
## L4 (EVID-256): fotografa o aviso do Tentáculo (linha + círculo), a mira do atirador e o bote.
## godot --path . res://tools/capture_l4.tscn --resolution 1280x720

var _dir := "res://.atena/generated/mariz-playtest/"

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_dir))
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345, "level": 6}
	Game.run_stage = "docas"
	Game.run_hero = "durvall"
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	for _i in 15:
		Game.controls.focused = true
		get_tree().paused = false
		await get_tree().create_timer(0.1).timeout
	var b: Battle = run.battle
	b.enemies.clear()
	b.stage.waves = []
	b.hero.max_hp = 99999.0
	b.hero.hp = 99999.0
	var t: Enemy = b.spawn_for_test("tentaculo_kraken", b.hero.pos + Vector2(4.0, -1.0))
	var a: Enemy = b.spawn_for_test("cultista_arqueiro", b.hero.pos + Vector2(-5.5, 1.5))
	var c: Enemy = b.spawn_for_test("cultista_adaga", b.hero.pos + Vector2(-1.0, 3.2))
	t.ab_cd = [0.0]
	a.ab_cd = [0.0]
	for _i in 6:
		Game.controls.focused = true
		await get_tree().create_timer(0.1).timeout
	await _shot("l4_telegrafo_mira_bote")
	get_tree().quit()

func _shot(label: String) -> void:
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("%s%s.png" % [_dir, label])
