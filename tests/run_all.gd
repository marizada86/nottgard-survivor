extends SceneTree
## Runner mínimo: cada tests/test_*.gd expõe run() -> Array[String] de falhas.

func _init() -> void:
	var failures: Array = []
	var dir := DirAccess.open("res://tests")
	for f in dir.get_files():
		if f.begins_with("test_") and f.ends_with(".gd"):
			var t = load("res://tests/" + f).new()
			for msg in t.run():
				failures.append("%s: %s" % [f, msg])
	for m in failures:
		printerr("FALHA ", m)
	print("testes: %d falha(s)" % failures.size())
	quit(1 if failures.size() > 0 else 0)
