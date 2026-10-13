extends Node

const OUT := "res://.atena/generated/hero-admission-2026-10-13/captures/"

func shot(name_: String) -> void:
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	assert(get_viewport().get_texture().get_image().save_png(OUT + name_ + ".png") == OK)

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUT))
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 4242}
	Game._save_path = "user://hero-admission-qa-profile.json"
	Game.profile = Profile.new({"name": "Hero admission QA", "welcome_seen": true})
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
		var view: Node2D = run.hero_node
		var sprite: AnimatedSprite2D = view.sprite
		var origin := view.position
		view._action_locked = false
		view.sync_visual(origin, false, false)
		sprite.play(&"idle")
		sprite.frame = 0
		sprite.pause()
		await shot(hero + "-idle-hud")
		for index in 8:
			var direction := Vector2.RIGHT.rotated(index * TAU / 8.0)
			view._action_locked = false
			view._last_screen_position = origin - direction * 10.0
			view.sync_visual(origin, false, false)
			assert(sprite.animation == view.walk_animation_for_direction(direction))
			assert(sprite.flip_h == view.walk_flips_horizontally(direction))
			sprite.frame = 2
			sprite.pause()
			await shot(hero + "-direction-" + str(index))
		for action in [&"attack", &"active", &"death"]:
			view._action_locked = false
			sprite.flip_h = false
			if action == &"death":
				view.sync_visual(origin, true, false)
			else:
				view.play_action(action)
			assert(sprite.animation == action)
			sprite.frame = 3
			sprite.pause()
			await shot(hero + "-" + String(action))
			if action == &"death":
				sprite.frame = 5
				await shot(hero + "-death-final")
		view.dead = false
		view._action_locked = false
		sprite.modulate = Color.WHITE
		view._last_screen_position = origin
		view.sync_visual(origin, false, false)
		sprite.play(&"idle")
		sprite.frame = 0
		sprite.pause()
		run.hud.show_items_panel(run.battle)
		run.hud.items_panel.set_tab(0)
		await get_tree().create_timer(0.25).timeout
		await shot(hero + "-ficha")
		run.hud.hide_items_panel()
		await get_tree().create_timer(0.25).timeout
		view._has_animation = false
		sprite.visible = false
		view.queue_redraw()
		await shot(hero + "-static-fallback")
		run.queue_free()
		await get_tree().process_frame
		var menu: Control = load("res://ui/menu.tscn").instantiate()
		add_child(menu)
		await get_tree().create_timer(0.3).timeout
		menu.hero_list.select(menu.heroes.find(hero))
		menu._refresh_hero()
		await shot(hero + "-selection")
		menu.queue_free()
		await get_tree().process_frame
	print("capture PASS: runtime eight directions, actions, death final, HUD/sheet, static fallback for both heroes")
	get_tree().quit()
