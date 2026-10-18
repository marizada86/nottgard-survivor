extends Node
## SPEC-176 (M1, S-009): o Durvall andando nas 8 direções e atacando no HeroView do jogo (sem laboratório), com as tiras admitidas em assets/.
## godot --path . res://tools/capture_m1_durvall.tscn --resolution 1280x720 [-- --hero=<herói> <pasta>]

var _dir := "res://.atena/generated/chatgpt-integration-2026-10-17/m1-durvall/capturas/"
var _hero := "durvall"

func _shot(name: String) -> void:
	await get_tree().create_timer(0.05).timeout
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("%s%s.png" % [_dir, name])

func _ready() -> void:
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--hero="):
			_hero = a.substr(7)
		elif a != "--debug":
			_dir = a if a.ends_with("/") else a + "/"
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_dir))
	Playtest.visible = false
	var bg := ColorRect.new()
	bg.color = Color(0.2, 0.19, 0.21)
	bg.size = Vector2(1280, 720)
	add_child(bg)
	var packed: PackedScene = load("res://ui/hero_view.tscn")
	var names := ["e", "se", "s", "sw", "w", "nw", "n", "ne"]
	var views: Array = []
	for i in names.size():
		var v = packed.instantiate()
		add_child(v)
		v.apply_hero(_hero)
		v.position = Vector2(170 + (i % 4) * 310, 250 + (i / 4) * 280)
		v.scale = Vector2(3.0, 3.0)
		views.append(v)
	var report: Array = []
	var homes: Array = views.map(func(v): return v.position)
	var virtual: Array = homes.duplicate()
	for step in 24:
		for i in views.size():
			var angle: float = [0.0, 45.0, 90.0, 135.0, 180.0, 225.0, 270.0, 315.0][i]
			var d := Vector2.RIGHT.rotated(deg_to_rad(angle))
			virtual[i] += d * 3.0
			views[i].sync_visual(virtual[i], false, false)
			views[i].position = homes[i]   # anda no lugar: só a tira muda
		await get_tree().process_frame
	await _shot("%s_1_oito_direcoes_a" % _hero)
	await get_tree().create_timer(0.17).timeout
	await _shot("%s_1_oito_direcoes_b" % _hero)
	for i in views.size():
		var v = views[i]
		report.append("%s: animacao=%s flip_h=%s quadros=%d real=%s" % [names[i], v.sprite.animation, v.sprite.flip_h, v.sprite.sprite_frames.get_frame_count(v.sprite.animation), v._real_walk.has(v.sprite.animation)])
	for line in report:
		print(line)
	# ataque
	for v in views:
		v.play_action(&"attack")
	await get_tree().create_timer(0.12).timeout
	await _shot("%s_2_ataque" % _hero)
	get_tree().quit()
