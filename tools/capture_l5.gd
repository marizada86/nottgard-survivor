extends Node
## L5 (EVID-257): fotografa as mecânicas de chefe do piloto em janela real.
## godot --path . res://tools/capture_l5.tscn --resolution 1280x720

var _dir := "res://.atena/generated/mariz-playtest/"

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_dir))
	Playtest.visible = false
	await _scene("dagruve", [
		{"label": "l5_sacerdote_turibulos", "hp": 0.69, "wait": 0.8},
		{"label": "l5_sacerdote_sussurro", "hp": 0.34, "wait": 0.0, "until": "cast", "after": 1.5},
	])
	await _scene("docas", [
		{"label": "l5_guardiao_varredura", "hp": 0.69, "wait": 0.0, "until": "sweep", "after": 1.4},
	])
	await _scene("molor", [
		{"label": "l5_blogbog_imune", "hp": 0.69, "wait": 0.8},
		{"label": "l5_blogbog_quadrantes", "hp": 0.34, "wait": 0.0, "until": "quad", "after": 1.0, "kill_adds": true},
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
		b.hero.hp = b.hero.max_hp
		await get_tree().create_timer(0.1).timeout
		if b.boss != null:
			break
	for s in shots:
		b.hero.max_hp = 99999.0
		b.hero.hp = 99999.0
		b.boss.hp = b.boss.max_hp * float(s.hp)
		b._check_boss_phase(b.boss)
		if bool(s.get("kill_adds", false)):
			for e in b.enemies:
				if e.id == "slime_de_juiblex":
					b._kill(e)
		var m: BossMechanics = b.boss_mech
		var tries := 0
		while s.has("until") and m != null and tries < 150:
			tries += 1
			Game.controls.focused = true
			get_tree().paused = false
			await get_tree().create_timer(0.1).timeout
			var ready := false
			match String(s.until):
				"cast": ready = not m.cast.is_empty()
				"sweep": ready = not m.sweep.is_empty()
				"quad": ready = not m.quad.is_empty()
			if ready:
				break
		var extra := float(s.get("after", s.get("wait", 0.5)))
		var waited := 0.0
		while waited < extra:
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
