extends Node
## PLAN-105 B-001 (EVID-259): fotografa a marca (seguindo e travada), a varredura de 2 feixes e a armadura do chefe.
## godot --path . res://tools/capture_l5_b001.tscn --resolution 1280x720

var _dir := "res://.atena/generated/mariz-playtest/"

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_dir))
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345, "level": 8, "target_state": "boss", "prelude_seconds": 0.2}
	Game.run_stage = "molor"
	Game.run_hero = "durvall"
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	var b: Battle = run.battle
	b.stage.waves = []
	for _i in 30:
		Game.controls.focused = true
		get_tree().paused = false
		await get_tree().create_timer(0.1).timeout
		if b.boss != null:
			break
	b.hero.max_hp = 99999.0
	b.hero.hp = 99999.0
	b.boss.abilities = []
	var m: BossMechanics = b.boss_mech
	m._start({"t": "mark", "follow": 2.0, "lock": 2.0, "radius": 3.0, "dice": "2d6", "puddle": true})
	await _wait(b, 1.0)
	await _shot("l5_b001_marca_seguindo")
	await _wait(b, 1.6)
	await _shot("l5_b001_marca_travada")
	await _wait(b, 2.0)
	m._start({"t": "sweep", "warn": 0.5, "dur": 3.0, "arc": 90.0, "len": 9.0, "dice": "1d4", "beams": 2, "gap_deg": 180.0})
	await _wait(b, 1.6)
	await _shot("l5_b001_dois_feixes")
	await _wait(b, 2.5)
	m.armor_t = 5.0
	await _wait(b, 0.3)
	await _shot("l5_b001_armadura")
	get_tree().quit()

func _wait(b: Battle, seconds: float) -> void:
	var t := 0.0
	while t < seconds:
		Game.controls.focused = true
		get_tree().paused = false
		b.hero.hp = b.hero.max_hp
		await get_tree().create_timer(0.1).timeout
		t += 0.1

func _shot(label: String) -> void:
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("%s%s.png" % [_dir, label])
