extends RefCounted
## As opções do Quartel (SPEC-166: agora vêm do OptionsPanel, o mesmo componente da pausa).

func run() -> Array:
	var out: Array = []
	var packed := load("res://ui/menu.tscn") as PackedScene
	if packed == null:
		return ["cena de opções não carrega"]
	var menu := packed.instantiate()
	# os controles antigos saíram da cena: quem os mostra é o OptionsPanel, criado no _ready
	for node_name in ["MusicMuteOpt", "SfxMuteOpt", "AmbienceMuteOpt", "DisplayModeOpt", "ResolutionOpt", "MusicVolOpt", "AimOpt", "VolOpt"]:
		if menu.get_node_or_null("Tabs/Opções/Content/" + node_name) != null:
			out.append("a cena não deveria mais ter %s (o OptionsPanel cuida disso)" % node_name)
	# o que continua sendo do Quartel
	for path in ["Tabs/Opções/Content/DiffOpt", "Tabs/Opções/Content/GuideBtn", "Tabs/Opções/Content/ResetBtn"]:
		if menu.get_node_or_null(path) == null:
			out.append("controle ausente: %s" % path)
	menu.free()
	return out
