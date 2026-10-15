extends RefCounted
## SPEC-178: retratos próprios da Ficha (C) e do HUD, com fallback para o retrato do menu.

const SIZES := {"ficha": Vector2i(768, 256), "hud": Vector2i(256, 256)}

func run() -> Array:
	var out: Array = []
	var heroes: Dictionary = Data.table("heroes")
	for hid in heroes:
		var menu_path := "res://assets/portraits/%s.png" % hid
		if HeroPortraits.path(hid, HeroPortraits.MENU) != menu_path:
			out.append("%s: o menu deveria usar %s" % [hid, menu_path])
		for kind in [HeroPortraits.FICHA, HeroPortraits.HUD]:
			var p := HeroPortraits.path(hid, kind)
			if p == "":
				out.append("%s/%s: sem retrato nem fallback" % [hid, kind])
				continue
			if HeroPortraits.has_own(hid, kind):
				if p != "res://assets/portraits/%s/%s.png" % [kind, hid]:
					out.append("%s/%s: deveria usar a imagem própria, usou %s" % [hid, kind, p])
				var tex := HeroPortraits.texture(hid, kind)
				if tex == null or Vector2i(tex.get_width(), tex.get_height()) != SIZES[kind]:
					out.append("%s/%s: imagem própria deveria ter %s" % [hid, kind, SIZES[kind]])
			elif p != menu_path:
				out.append("%s/%s: sem imagem própria deveria cair no menu, deu %s" % [hid, kind, p])
			if HeroPortraits.texture(hid, kind) == null:
				out.append("%s/%s: textura nula" % [hid, kind])
	if HeroPortraits.path("heroi_inexistente", HeroPortraits.HUD) != "" or HeroPortraits.has_own("heroi_inexistente", HeroPortraits.FICHA):
		out.append("herói inexistente não deveria ter retrato")
	# a Ficha só preenche a caixa quando a faixa 3:1 própria existe; o 3:2 do menu segue inteiro
	var tree := Engine.get_main_loop() as SceneTree
	for hid in heroes:
		var sheet := CharacterSheet.new()
		tree.root.add_child(sheet)
		sheet.show_sheet(Battle.new(3, hid, "dagruve"))
		var want := TextureRect.STRETCH_KEEP_ASPECT_COVERED if HeroPortraits.has_own(hid, HeroPortraits.FICHA) else TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		if sheet._portrait.stretch_mode != want:
			out.append("%s: modo de escala do retrato da Ficha errado (%d)" % [hid, sheet._portrait.stretch_mode])
		sheet.free()
	return out
