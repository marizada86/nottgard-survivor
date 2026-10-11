extends SceneTree

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var failures: Array = []
	var imported: Array = []
	var receipt: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://.atena/generated/fila026-remaining-2026-10-11/admission-receipt.json"))
	for record in receipt.records:
		var path: String = "res://" + String(record.destination)
		var tex := load(path) as Texture2D
		if tex == null:
			failures.append("PNG não importado: " + path)
			continue
		if Vector2i(tex.get_size()) != Vector2i(int(record.size[0]), int(record.size[1])):
			failures.append("Tamanho importado divergente: " + path)
		imported.append({"path": path, "size": [tex.get_width(), tex.get_height()], "resource_exists": ResourceLoader.exists(path)})
	if imported.size() != 10:
		failures.append("Esperados dez PNGs importados")
	for path in ["res://tests/test_cursor.gd", "res://tests/test_lettering_assets.gd"]:
		var scr = load(path)
		if scr == null or not scr.can_instantiate():
			failures.append("Teste não compila: " + path)
			continue
		var result = scr.new().run()
		if not result is Array:
			failures.append("Teste não retornou resultado: " + path)
			continue
		for message in result:
			failures.append(path + ": " + String(message))
	var report := {"status": "PASS" if failures.is_empty() else "FAIL", "imported": imported, "failures": failures, "tests": ["test_cursor.gd", "test_lettering_assets.gd"], "scope": "S013 admission; not S014 hookups or S015 full suite/playtest"}
	var output := FileAccess.open("res://.atena/generated/fila026-remaining-2026-10-11/admission-godot-check.json", FileAccess.WRITE)
	output.store_string(JSON.stringify(report, "  ") + "\n")
	output.close()
	for message in failures:
		printerr(message)
	print("admission: %d textures; %d failure(s)" % [imported.size(), failures.size()])
	quit(0 if failures.is_empty() else 1)
