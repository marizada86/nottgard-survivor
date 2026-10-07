extends RefCounted

func run() -> Array:
	var out: Array = []
	var packed := load("res://ui/menu.tscn") as PackedScene
	if packed == null:
		return ["cena de opções não carrega"]
	var menu := packed.instantiate()
	for path in [
		"Tabs/Opções/Content/MusicMuteOpt",
		"Tabs/Opções/Content/SfxMuteOpt",
		"Tabs/Opções/Content/AmbienceMuteOpt",
		"Tabs/Opções/Content/DisplayModeOpt",
		"Tabs/Opções/Content/ResolutionOpt",
	]:
		if menu.get_node_or_null(path) == null:
			out.append("controle ausente: %s" % path)
	menu.free()
	return out
