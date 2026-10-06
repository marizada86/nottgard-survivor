extends RefCounted
## SPEC-131 (MEC-048): painel do herói da HUD da run no padrão da ficha C.

func run() -> Array:
	var out: Array = []
	if HeroPanel.hp_text(27.2, 48.0, 0.0) != "28 / 48":
		out.append("hp_text sem barreira: '%s'" % HeroPanel.hp_text(27.2, 48.0, 0.0))
	if HeroPanel.hp_text(27.0, 48.0, 4.2) != "27 / 48  +5":
		out.append("hp_text com barreira: '%s'" % HeroPanel.hp_text(27.0, 48.0, 4.2))
	if HeroPanel.defense_text(15, 0.15) != "15 (15%)":
		out.append("defense_text: '%s'" % HeroPanel.defense_text(15, 0.15))
	if CharacterSheet.plain_text("[font_size=22][b]CA[/b][/font_size]\nok [color=#e6c76e]x[/color]") != "CA\nok x":
		out.append("plain_text não removeu o BBCode: '%s'" % CharacterSheet.plain_text("[font_size=22][b]CA[/b][/font_size]\nok [color=#e6c76e]x[/color]"))
	var tree := Engine.get_main_loop() as SceneTree
	for hid in Data.table("heroes"):
		var b := Battle.new(3, hid, "dagruve")
		var hud: Node = load("res://ui/hud.tscn").instantiate()
		tree.root.add_child(hud)
		hud.update_stats(b)
		var p: HeroPanel = hud.hero_panel
		if p == null:
			out.append("%s: HUD sem HeroPanel" % hid)
			hud.free()
			continue
		var h := b.hero
		if p.name_label.text != h.name or p.level_label.text != "Nv %d" % h.level:
			out.append("%s: nome/nível errados (%s / %s)" % [hid, p.name_label.text, p.level_label.text])
		if p.hp_label.text != HeroPanel.hp_text(h.hp, h.max_hp, b.barrier):
			out.append("%s: texto de PV errado (%s)" % [hid, p.hp_label.text])
		if p.ca_label.text != HeroPanel.defense_text(h.ca(), h.typed_evasion("fisico")) or p.cam_label.text != HeroPanel.defense_text(h.cam(), h.typed_evasion("magico")):
			out.append("%s: CA/CAM errados (%s / %s)" % [hid, p.ca_label.text, p.cam_label.text])
		if p.gold_label.text != str(int(h.gold)) or p.kills_label.text != str(b.stats.kills):
			out.append("%s: moedas/abates errados" % hid)
		for a in HeroPanel.ATTR_NAMES:
			if (p._attr_labels[a] as Label).text != "%s %d" % [HeroPanel.ATTR_NAMES[a], h.attr(a)]:
				out.append("%s: atributo %s errado" % [hid, a])
		if p._portrait.texture == null:
			out.append("%s: sem retrato no painel" % hid)
		for chip in ["ca", "cam"]:
			var tip := (p._chips[chip] as Control).tooltip_text
			if tip.find("Classe de Armadura") < 0 or tip.find("[") >= 0:
				out.append("%s: tooltip de %s sem texto ou com BBCode ('%s')" % [hid, chip, tip])
		if p.boon_row.visible:
			out.append("%s: fileira de bênçãos deveria estar oculta sem bênção" % hid)
		b.barrier = 7.0
		var boons: Array = Data.table("boons").boons
		h.boons.append(boons[0])
		h.boons.append({"id": "sem_icone_xyz", "name": "Xis", "god": "Teste", "desc": "sem ícone", "mods": {}})
		h.recalc()
		hud.update_stats(b)
		if not p.barrier_bar.visible or int(p.barrier_bar.value) != 7:
			out.append("%s: barreira não aparece na barra de PV" % hid)
		if not p.boon_row.visible or p.boon_row.get_child_count() != 2:
			out.append("%s: fileira de bênçãos com %d ícones, esperado 2" % [hid, p.boon_row.get_child_count()])
		elif (p.boon_row.get_child(1) as Control).tooltip_text.find("Teste") < 0:
			out.append("%s: tooltip da bênção sem o deus" % hid)
		hud.pulse_xp()
		hud.free()
	return out
