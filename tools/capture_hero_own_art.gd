extends Node

const OUT := "res://.atena/generated/hero-integration-2026-10-10/"

func _ready() -> void:
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 4242}
	Game._save_path = "user://hero-art-qa-profile.json"
	Game.profile = Profile.new({"name": "Arte QA", "welcome_seen": true})
	Game.profile.data["hqs_seen"] = {}
	for id in Data.table("hqs"):
		Game.profile.data["hqs_seen"][id] = true
	for hero in ["arlindo", "erik"]:
		Game.run_stage = "dagruve"
		Game.run_hero = hero
		var run: Node = load("res://ui/run.tscn").instantiate()
		add_child(run)
		await get_tree().create_timer(0.6).timeout
		run.set_process(false)
		run.set_physics_process(false)
		run.camera.position = run.hero_node.position + Vector2(0, -30)
		var sprite: AnimatedSprite2D = run.hero_node.sprite
		for animation in [&"idle", &"move_e", &"active"]:
			sprite.play(animation)
			sprite.frame = 2
			sprite.pause()
			await get_tree().create_timer(0.2).timeout
			await RenderingServer.frame_post_draw
			var shot := get_viewport().get_texture().get_image()
			shot.save_png(ProjectSettings.globalize_path(OUT + "%s-%s-runtime.png" % [hero, animation]))
		run.queue_free()
		await get_tree().process_frame
	print("hero own art: six runtime screenshots saved")
	get_tree().quit()
