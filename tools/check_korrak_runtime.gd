extends SceneTree

func _init() -> void:
	call_deferred("_check")

func _check() -> void:
	var view: Node2D = load("res://ui/hero_view.tscn").instantiate()
	root.add_child(view)
	view.apply_hero("korrak")
	var at := Vector2.ZERO
	for index in 8:
		var direction := Vector2.RIGHT.rotated(index * PI / 4.0)
		at += direction * 10
		view.sync_visual(at, false, false)
		var expected := [&"move_e", &"move_se", &"move_s", &"idle", &"idle", &"idle", &"idle", &"move_ne"]
		assert(view.sprite.animation == expected[index])
		assert(not view.sprite.flip_h)
	view.queue_free()
	await process_frame
	print("Korrak runtime: E/SE/S/NE strips enabled, four provisional directions intact, weapon side preserved")
	quit()
