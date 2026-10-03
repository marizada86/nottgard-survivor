extends Node

func _ready() -> void:
	var sequence := "move_e"
	var hero := "korrak"
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--seq="):
			sequence = argument.trim_prefix("--seq=")
		elif argument.begins_with("--hero="):
			hero = argument.trim_prefix("--hero=")
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345}
	Game.run_stage = "dagruve"
	Game.run_hero = hero
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	await get_tree().create_timer(0.4).timeout
	run.set_process(false)
	run.set_physics_process(false)
	var at: Vector2 = Iso.to_screen(run.battle.hero.pos)
	var frame_count: int = 4 if sequence == "attack" else 6
	for index in frame_count:
		var view: Node2D = load("res://ui/hero_view.tscn").instantiate()
		run.add_child(view)
		view.apply_hero(hero)
		view.position = at + Vector2(-(frame_count - 1) * 60 + index * 120, 90)
		view.sprite.play(sequence)
		view.sprite.pause()
		view.sprite.frame = index
	await RenderingServer.frame_post_draw
	print("Hero capture result=", get_viewport().get_texture().get_image().save_png("res://.atena/generated/priority-review/%s_%s_runtime.png" % [hero, sequence]))
	get_tree().quit()
