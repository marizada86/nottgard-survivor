extends SceneTree

func _init() -> void:
	call_deferred("_check")

func _check() -> void:
	var id := "bolha_de_slime"
	var actual_actor := false
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--id="):
			id = arg.substr(5)
		if arg == "--actual-actor": actual_actor = true
	var view: Node2D = load("res://ui/enemy_view.tscn").instantiate()
	root.add_child(view)
	var actor_scale := 1.0
	if actual_actor:
		var actor: Enemy = Enemy.make(id, Vector2.ZERO)
		actor_scale = actor.scale
		view.setup(actor)
	else:
		view.preview_enemy_id = id
		view._apply_id(id)
	assert(view._has_animation)
	if actual_actor and id in ["ilusao_de_sucubo", "ilusao_de_socothbenoth"]:
		view.sync_visual(view.position)
		assert(is_equal_approx(view.sprite.modulate.a, 0.45))
		var reused_source := "sucubo" if id == "ilusao_de_sucubo" else "cultista_de_socothbenoth"
		assert(String(view.ANIMATED[id].source_id) == reused_source)
		for state in view.ANIMATED[id].states:
			var texture: AtlasTexture = view.sprite.sprite_frames.get_frame_texture(state, 0)
			assert(texture.atlas.resource_path == "res://assets/animations/enemies/%s/%s.png" % [reused_source, state])
	var body_height := float(view.ANIMATED[id].get("body_height", 384.0))
	assert(is_equal_approx(view.sprite.scale.x * body_height, 62.0 * actor_scale))
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
