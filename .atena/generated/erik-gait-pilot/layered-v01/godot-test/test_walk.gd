extends SceneTree

const Loader = preload("res://sprite_strip_frames.gd")
var seen: Array[int] = []

func _initialize() -> void:
	_run.call_deferred()

func _run() -> void:
	var frames: SpriteFrames = Loader.empty()
	assert(Loader.add_strip(frames, &"move_e", "res://move_e.png", Vector2i(256, 384), 6, 10.0, true))
	assert(frames.get_frame_count(&"move_e") == 6)
	assert(frames.get_animation_loop(&"move_e"))
	for index in 6:
		var texture: AtlasTexture = frames.get_frame_texture(&"move_e", index)
		assert(texture.region == Rect2(index * 256, 0, 256, 384))
	var sprite := AnimatedSprite2D.new()
	sprite.sprite_frames = frames
	root.add_child(sprite)
	sprite.frame_changed.connect(func(): seen.append(sprite.frame))
	sprite.play(&"move_e")
	for tick in 90:
		await process_frame
	for index in 6:
		assert(seen.has(index), "Frame not reproduced: %d" % index)
	var wrap_found := false
	for index in range(1, seen.size()):
		assert(seen[index] == (seen[index - 1] + 1) % 6)
		if seen[index - 1] == 5 and seen[index] == 0:
			wrap_found = true
	assert(wrap_found)
	print(JSON.stringify({"result":"PASS", "frame_count":6,"fps":10,"seen":seen,"distinct_atlas_regions":true,"loop_wrap":wrap_found}))
	quit(0)
