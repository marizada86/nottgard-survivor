extends SceneTree

func _init() -> void:
	call_deferred("check")

func check() -> void:
	var result = load("res://tests/test_arcane_orb_vfx.gd").new().run()
	if not result is Array:
		printerr("orb test aborted")
		quit(1)
		return
	var failures: Array = result
	for failure in failures: printerr(failure)
	print("arcane focused: ", failures.size(), " failures")
	quit(0 if failures.is_empty() else 1)
