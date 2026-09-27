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
	var prop := Prop.new()
	prop._texture_path = "res://assets/props/doca_01.png"
	if String(prop._visual_profile().get("shadow_mode", "")) != "none":
		out.append("prop plano não deveria receber sombra dinâmica")
	prop.free()
	return out
