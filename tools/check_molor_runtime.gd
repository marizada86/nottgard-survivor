extends SceneTree

func _init() -> void:
	call_deferred("_check")

func _check() -> void:
	var id := "bolha_de_slime"
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--id="):
			id = arg.substr(5)
	var view: Node2D = load("res://ui/enemy_view.tscn").instantiate()
	root.add_child(view)
	view.preview_enemy_id = id
	view._apply_id(id)
	assert(view._has_animation)
	var body_height := float(view.ANIMATED[id].get("body_height", 384.0))
	assert(is_equal_approx(view.sprite.scale.x * body_height, 62.0))
	assert(view.sprite.offset.y == -164.0)
	for state in view.ANIMATED[id].states:
		var frames: SpriteFrames = view.sprite.sprite_frames
		assert(frames.has_animation(state))
		assert(frames.get_animation_loop(state) == (state in ["idle", "move"]))
	view.play_action()
	assert(view._action_locked)
	await create_timer(0.45).timeout
	assert(not view._action_locked)
	if view.sprite.sprite_frames.has_animation(&"special"):
		view.play_action(&"special")
		assert(view._action_locked)
		await create_timer(0.65).timeout
		assert(not view._action_locked)
	view.play_death()
	await create_timer(0.8).timeout
	assert(not is_instance_valid(view))
	print("Molor runtime: scale, anchor, action unlock and death cleanup OK")
	quit()
