extends SceneTree
## Runner mínimo: cada tests/test_*.gd expõe run() -> Array[String] de falhas.

func _init() -> void:
	var failures: Array = []
	var dir := DirAccess.open("res://tests")
	for f in dir.get_files():
		if f.begins_with("test_") and f.ends_with(".gd"):
			var t = load("res://tests/" + f).new()
			var res = t.run()
			if not (res is Array):
				failures.append("%s: teste abortou por erro de script" % f)
				continue
			for msg in res:
				failures.append("%s: %s" % [f, msg])
	for m in failures:
		printerr("FALHA ", m)
	print("testes: %d falha(s)" % failures.size())
	quit(1 if failures.size() > 0 else 0)
