extends SceneTree
## Emite evidência persistente da diferença entre a base opaca e a âncora declarada.

const OUTPUT := "res://.atena/evidence/EVID-112-bug-013-auditoria-final-2026-09-29.md"

func _init() -> void:
	var profiles: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/prop_visuals.json")).get("assets", {})
	var dir := DirAccess.open("res://assets/props")
	var files: Array[String] = []
	for file_name in dir.get_files():
		if file_name.ends_with(".png"):
			files.append(file_name)
	files.sort()
	var rows: Array[String] = []
	var outside: Array[String] = []
	for file_name in files:
		var path := "res://assets/props/" + file_name
		var image := Image.load_from_file(ProjectSettings.globalize_path(path))
		if image == null:
			continue
		var bottom := _opaque_bottom(image)
		var opaque_fraction := float(bottom) / float(image.get_height())
		var profile: Dictionary = profiles.get(path, {})
		var raw_anchor: Array = profile.get("contact_anchor", [0.5, opaque_fraction])
		var anchor_fraction := float(raw_anchor[1])
		var delta_px := (anchor_fraction - opaque_fraction) * 80.0
		var verdict := "ok" if absf(delta_px) <= 2.0 else ("flutua" if delta_px > 0.0 else "afunda")
		rows.append("| `%s` | %.3f | %.3f | %+.1f | %s |" % [file_name, opaque_fraction, anchor_fraction, delta_px, verdict])
		if verdict != "ok":
			outside.append(file_name)
	var body := "# EVID-112A — Auditoria final do BUG-013\n\n"
	body += "Data: 2026-09-29  \nOrigem: `data/prop_visuals.json`, `assets/props/*.png`.\n\n"
	body += "A diferença é estimada para altura de renderização de 80 px. Valor positivo significa que a âncora fica abaixo da base opaca e a arte aparenta flutuar.\n\n"
	body += "| Asset | Base opaca | Âncora | Dif. px | Veredito |\n|---|---:|---:|---:|---|\n"
	body += "\n".join(rows) + "\n\n"
	body += "Fora da tolerância de 2 px: **%d** — %s.\n" % [outside.size(), ", ".join(outside) if not outside.is_empty() else "nenhum"]
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUTPUT.get_base_dir()))
	var output := FileAccess.open(OUTPUT, FileAccess.WRITE)
	output.store_string(body)
	output.close()
	quit()

func _opaque_bottom(image: Image) -> int:
	for y in range(image.get_height() - 1, -1, -1):
		for x in range(0, image.get_width(), 2):
			if image.get_pixel(x, y).a >= 0.30:
				return y + 1
	return 0
