extends RefCounted

const Prop := preload("res://ui/prop.gd")

func run() -> Array:
	var out: Array = []
	var profiles: Dictionary = Data.table("prop_visuals").get("assets", {})
	var kinds := ["rocha", "pilar_abissal", "barril", "braseiro", "caixote", "carga", "livros", "velas", "doca", "margem", "ossos", "rede"]
	for kind in kinds:
		for variant in range(1, 4):
			var path := "res://assets/props/%s_%02d.png" % [kind, variant]
			if not profiles.has(path):
				out.append("asset sem ficha visual: %s" % path)
				continue
			var profile: Dictionary = profiles[path]
			var anchor: Variant = profile.get("contact_anchor", [])
			if not (anchor is Array) or anchor.size() < 2 or float(anchor[0]) < 0.0 or float(anchor[0]) > 1.0 or float(anchor[1]) < 0.0 or float(anchor[1]) > 1.0:
				out.append("âncora inválida: %s" % path)
			var shadow_mode := String(profile.get("shadow_mode", ""))
			if not ["dynamic", "embedded", "none"].has(shadow_mode):
				out.append("modo de sombra inválido: %s" % path)
			if shadow_mode == "dynamic" and not profile.has("shadow_size"):
				out.append("sombra dinâmica sem dimensão: %s" % path)
	# BUG-013: com sombra dinâmica, o contato declarado não pode ficar acima da base opaca da arte (senão o objeto "flutua")
	for path in profiles:
		var fp: Dictionary = profiles[path]
		if String(fp.get("shadow_mode", "")) != "dynamic":
			continue
		var img := Image.load_from_file(ProjectSettings.globalize_path(String(path)))
		if img == null:
			continue
		var base_row := img.get_height()
		for y in range(img.get_height() - 1, -1, -1):
			var opaque := false
			for x in range(0, img.get_width(), 2):
				if img.get_pixel(x, y).a >= 0.30:
					opaque = true
					break
			if opaque:
				base_row = y + 1
				break
		var lift_px := (float(fp.contact_anchor[1]) - float(base_row) / float(img.get_height())) * 80.0
		if lift_px > 2.5:
			out.append("prop flutuando %.1fpx acima do chão: %s" % [lift_px, path])
	var prop := Prop.new()
	prop._texture_path = "res://assets/props/doca_01.png"
	if String(prop._visual_profile().get("shadow_mode", "")) != "none":
		out.append("prop plano não deveria receber sombra dinâmica")
	prop.free()
	return out
