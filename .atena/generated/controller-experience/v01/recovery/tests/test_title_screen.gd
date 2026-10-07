extends RefCounted

func run() -> Array:
	var packed := load("res://ui/title.tscn") as PackedScene
	if packed == null:
		return ["cena de título não carrega"]
	var title := packed.instantiate()
	var out: Array = []
	if title.get_script() == null:
		out.append("cena de título sem script")
	title.free()
	if ProjectSettings.get_setting("application/run/main_scene") != "res://ui/title.tscn":
		out.append("cena principal deveria ser a tela de título")
	return out
