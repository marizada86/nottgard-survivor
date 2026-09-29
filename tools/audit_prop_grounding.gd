extends SceneTree
## Auditoria de ancoragem (BUG-013): compara o contato declarado em data/prop_visuals.json com a última linha
## realmente opaca de cada textura de prop. Diferença positiva = a arte fica FLUTUANDO acima do contato.
## Uso: godot --headless --path . -s tools/audit_prop_grounding.gd

func _init() -> void:
	var profiles: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/prop_visuals.json")).get("assets", {})
	var dir := DirAccess.open("res://assets/props")
	var files: Array = []
	for f in dir.get_files():
		if f.ends_with(".png"):
			files.append(f)
	files.sort()
	var worst := 0
	for f: String in files:
		var path: String = "res://assets/props/" + f
		var img := Image.load_from_file(ProjectSettings.globalize_path(path))
		if img == null:
			continue
		var h := img.get_height()
		var bottom := h
		for y in range(h - 1, -1, -1):
			var hit := false
			for x in range(0, img.get_width(), 2):
				if img.get_pixel(x, y).a >= 0.30:
					hit = true
					break
			if hit:
				bottom = y + 1
				break
		var frac := float(bottom) / float(h)
		var prof: Dictionary = profiles.get(path, {})
		var anchor_y := float(prof.get("contact_anchor", [0.5, frac])[1])
		var px := (anchor_y - frac) * 80.0  # aprox. em pixels de tela para altura-alvo ~80
		var mark := ""
		if not prof.is_empty() and absf(px) > 2.5:
			mark = "  <== " + ("FLUTUA" if px > 0 else "AFUNDA")
			worst += 1
		print("%-34s base_opaca=%.3f ancora=%.3f %s dif=%+.1fpx%s" % [f, frac, anchor_y, "perfil" if not prof.is_empty() else "SEM-PERFIL", px, mark])
	print("fora da tolerância: %d" % worst)
	quit()
