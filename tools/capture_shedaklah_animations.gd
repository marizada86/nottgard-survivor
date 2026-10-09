extends Node

func _ready() -> void:
	var id := "servo_de_zuggtmoy"
	var biome := "shedaklah"
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--id="): id = arg.substr(5)
		if arg.begins_with("--biome="): biome = arg.substr(8)
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345}
	Game.run_stage = biome
	Game.run_hero = "durvall"
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	await get_tree().create_timer(0.4).timeout
	run.set_process(false)
	run.set_physics_process(false)
	run.hud.visible = false
	var actor := Node2D.new()
	actor.position = Iso.to_screen(run.battle.hero.pos)
	run.add_child(actor)
	var row := 0
	var states: Dictionary = load("res://ui/enemy_view.gd").ANIMATED[id].states
	for state in states:
		for index in states[state]:
			var view: Node2D = load("res://ui/enemy_view.tscn").instantiate()
			actor.add_child(view)
			view.setup(Enemy.make(id, Vector2.ZERO))
			view.sync_visual(view.position)
			view.position = Vector2(-450 + index * 180, -170 + row * 100)
			view.sprite.play(state)
			view.sprite.pause()
			view.sprite.frame = index
		row += 1
	await RenderingServer.frame_post_draw
	print("Shedaklah capture result=", get_viewport().get_texture().get_image().save_png("res://.atena/generated/priority-review/%s_runtime.png" % id))
	get_tree().quit()
