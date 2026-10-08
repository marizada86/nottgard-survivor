extends SceneTree
## Roda um tests/test_*.gd isolado: godot --headless --path . -s tools/run_one_test.gd -- test_nome
func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var name := ""
	for a in OS.get_cmdline_user_args():
		name = a
	var scr = load("res://tests/%s.gd" % name)
	var res = scr.new().run()
	for m in res:
		printerr("FALHA ", m)
	print("%s: %d falha(s)" % [name, res.size()])
	quit(1 if res.size() > 0 else 0)
