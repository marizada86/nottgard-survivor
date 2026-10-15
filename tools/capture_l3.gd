extends Node
## L3 (EVID-255): fotografa as faixas do número de dano com acertos sintéticos ao lado do herói.
## godot --path . res://tools/capture_l3.tscn --resolution 1280x720

var _dir := "res://.atena/generated/mariz-playtest/"

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_dir))
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345, "level": 6}
	Game.run_stage = "dagruve"
	Game.run_hero = "durvall"
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	for _i in 15:
		Game.controls.focused = true
		get_tree().paused = false
		await get_tree().create_timer(0.1).timeout
	var b: Battle = run.battle
	b.enemies.clear()
	b.hero.max_hp = 99999.0
	b.hero.hp = 99999.0
	var cases := [
		{"label": "comum 7", "amount": 7, "crit": false, "tier": "", "frac": 0.4},
		{"label": "comum crit 15", "amount": 15, "crit": true, "tier": "", "frac": 0.8},
		{"label": "elite 2%", "amount": 9, "crit": false, "tier": "elite", "frac": 0.02},
		{"label": "elite 5%", "amount": 22, "crit": false, "tier": "elite", "frac": 0.05},
		{"label": "elite 10%", "amount": 45, "crit": false, "tier": "elite", "frac": 0.10},
		{"label": "elite 20%", "amount": 90, "crit": false, "tier": "elite", "frac": 0.20},
		{"label": "chefe crit 12%", "amount": 140, "crit": true, "tier": "boss", "frac": 0.12},
	]
	for i in cases.size():
		var c: Dictionary = cases[i]
		b.events.append({"type": "hit", "pos": b.hero.pos + Vector2(-3.0 + i * 1.0, -1.5), "amount": c.amount, "crit": c.crit,
			"dtype": "fisico", "tid": 1000 + i, "tier": c.tier, "frac": c.frac})
	await get_tree().create_timer(0.2).timeout
	await _shot("l3_numeros_em_faixas")
	get_tree().quit()

func _shot(label: String) -> void:
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("%s%s.png" % [_dir, label])
