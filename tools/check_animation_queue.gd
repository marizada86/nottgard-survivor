extends SceneTree

func _init() -> void:
	call_deferred("_check")

func _check() -> void:
	var failures: Array = []
	for path in ["res://tests/test_animation_assets.gd", "res://tests/test_melee_vfx.gd"]:
		var audit: RefCounted = load(path).new()
		for failure in audit.run():
			failures.append("%s: %s" % [path, failure])
	for failure in failures:
		printerr(failure)
	print("Animation queue: %d failure(s)" % failures.size())
	quit(0 if failures.is_empty() else 1)
