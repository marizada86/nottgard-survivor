extends Node
## PLAN-105 B-003 (EVID-261): fotografa as mecânicas de Zuggtmoy e Molydeus em janela real.
## godot --path . res://tools/capture_l5_b003.tscn --resolution 1280x720

var _dir := "res://.atena/generated/mariz-playtest/"

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_dir))
	Playtest.visible = false
	await _scene("feng_tu", [
		{"label": "l5_b003_discipulo_peste", "hp": 0.69, "until": "mark", "after": 1.2},
		{"label": "l5_b003_discipulo_grito", "hp": 0.34, "until": "cast", "after": 1.4},
	])
	await _scene("shendilavri", [
		{"label": "l5_b003_malcanthet_ilusoes", "hp": 0.69, "after": 1.2},
		{"label": "l5_b003_malcanthet_beijo", "hp": 0.34, "until": "cast", "after": 1.4},
	])
	get_tree().quit()

func _scene(stage_id: String, shots: Array) -> void:
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345, "level": 8, "target_state": "boss", "prelude_seconds": 0.2}
	Game.run_stage = stage_id
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
	for s in shots:
		b.hero.max_hp = 99999.0
		b.hero.hp = 99999.0
		b.boss.hp = b.boss.max_hp * float(s.hp)
		b._check_boss_phase(b.boss)
		var m: BossMechanics = b.boss_mech
		var tries := 0
		while s.has("until") and m != null and tries < 200:
			tries += 1
			Game.controls.focused = true
			get_tree().paused = false
			b.hero.hp = b.hero.max_hp
			await get_tree().create_timer(0.1).timeout
			var ready := false
			match String(s.until):
				"quad": ready = not m.quad.is_empty()
				"sweep": ready = not m.sweep.is_empty()
				"mark": ready = not m.mark.is_empty()
				"cast": ready = not m.cast.is_empty()
			if ready:
				break
		var waited := 0.0
		while waited < float(s.get("after", 0.5)):
			Game.controls.focused = true
			get_tree().paused = false
			b.hero.hp = b.hero.max_hp
			await get_tree().create_timer(0.1).timeout
			waited += 0.1
		await _shot(String(s.label))
	run.queue_free()
	await get_tree().process_frame

func _shot(label: String) -> void:
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("%s%s.png" % [_dir, label])
