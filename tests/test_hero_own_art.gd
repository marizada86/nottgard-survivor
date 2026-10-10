extends RefCounted

func run() -> Array:
	var failures: Array = []
	var tree := Engine.get_main_loop() as SceneTree
	for hero in ["arlindo", "erik"]:
		var view: Node2D = load("res://ui/hero_view.tscn").instantiate()
		tree.root.add_child(view)
		view.apply_hero(hero)
		var frames: SpriteFrames = view.sprite.sprite_frames
		var expected := {&"idle": 4, &"move_e": 7 if hero == "erik" else 6, &"move_se": 6, &"move_s": 6, &"move_ne": 5 if hero == "erik" else 6, &"move_n": 6, &"attack": 4, &"active": 6, &"death": 6}
		for animation in expected:
			if not frames.has_animation(animation) or frames.get_frame_count(animation) != expected[animation]:
				failures.append("%s/%s: contagem incorreta" % [hero, animation])
				continue
			for index in expected[animation]:
				var texture: AtlasTexture = frames.get_frame_texture(animation, index)
				if not texture.atlas.resource_path.begins_with("res://assets/animations/heroes/%s/" % hero) or texture.region.end.x > texture.atlas.get_width():
					failures.append("%s/%s: frame usa outra arte ou excede a tira" % [hero, animation])
		for action in [&"attack", &"active"]:
			view.play_action(action)
			if view.sprite.animation != action: failures.append("%s: ação %s não acionada" % [hero, action])
		view.sync_visual(Vector2.ZERO, true, false)
		if view.sprite.animation != &"death": failures.append("%s: morte não acionada" % hero)
		view.queue_free()
	return failures
