extends SceneTree
func _init() -> void:
	call_deferred("check")
func check() -> void:
	var result = load("res://tests/test_assets_l002_vfx.gd").new().run()
	if not result is Array:
		printerr("L002 test aborted")
		quit(1)
		return
	for failure in result: printerr(failure)
	print("L002 focused: ",result.size()," failures")
	quit(0 if result.is_empty() else 1)
