extends RefCounted
## SPEC-130 (MEC-045): ficha C em abas, grade de ícones, detalhe e ajuda de CA/CAM.

func run() -> Array:
	var out: Array = []
	var tree := Engine.get_main_loop() as SceneTree
	var heroes: Dictionary = Data.table("heroes")
	for hid in heroes:
		var b := Battle.new(3, hid, "dagruve")
		var sheet := CharacterSheet.new()
		tree.root.add_child(sheet)
		sheet.show_sheet(b)
		if CharacterSheet.TAB_NAMES.size() != 4:
			out.append("a ficha deveria ter 4 abas")
		if sheet.current_tab() != 0:
			out.append("%s: a ficha deveria abrir na aba 0" % hid)
		sheet.cycle_tab(-1)
		if sheet.current_tab() != 3:
			out.append("%s: Q na aba 0 deveria ir para a aba 3 (deu %d)" % [hid, sheet.current_tab()])
		sheet.cycle_tab(1)
		if sheet.current_tab() != 0:
			out.append("%s: E na aba 3 deveria voltar para a aba 0" % hid)
		var weapons: Array = sheet.tab_sections(0)
		var slots := b.hero.weapon_slots()
		var n := 0
		for e in weapons[0].entries:
			n += 1
		if n != slots:
			out.append("%s: aba de armas com %d slots, esperado %d (vazios incluídos)" % [hid, n, slots])
		var eq: Array = sheet.tab_sections(1)[0].entries
		if eq.size() != Items.SLOTS.size():
			out.append("%s: equipamento deveria mostrar os %d slots, mostrou %d" % [hid, Items.SLOTS.size(), eq.size()])
		for sec_i in 4:
			for sec in sheet.tab_sections(sec_i):
				for e in sec.entries:
					if String(e.get("detail", "")) == "":
						out.append("%s: aba %d com entrada sem detalhe" % [hid, sec_i])
					if not bool(e.get("empty", false)) and not ResourceLoader.exists(String(e.get("icon", ""))):
						out.append("%s: aba %d sem ícone em %s" % [hid, sec_i, e.get("icon", "")])
		if sheet._ability_name.text != String(b.active_def.get("name", "")):
			out.append("%s: cartão de habilidade sem o nome" % hid)
		sheet.free()

	# herói cheio: equipamento, passivas, bênçãos
	var b2 := Battle.new(3, "sylas", "dagruve")
	var rng := RandomNumberGenerator.new()
	rng.seed = 7
	for i in 12:
		var it := Items.roll(rng, 2, 0.0)
		b2.hero.items[it.slot] = it
	b2.hero.items["arma"]["level"] = Items.MAX_LEVEL
	b2.hero.passives["forca"] = 2
	var boons: Array = Data.table("boons").boons
	b2.hero.boons.append(boons[0])
	b2.hero.recalc()
	var sheet2 := CharacterSheet.new()
	(Engine.get_main_loop() as SceneTree).root.add_child(sheet2)
	sheet2.show_sheet(b2)
	var eq2: Array = sheet2.tab_sections(1)[0].entries
	for e in eq2:
		if bool(e.empty):
			out.append("equipamento cheio ainda mostra slot vazio")
	var rar: String = String(b2.hero.items[Items.SLOTS[0]].rarity)
	if eq2[0].border != Items.rarity_color(rar):
		out.append("borda do slot de equipamento não segue a raridade")
	if String(eq2[0].badge) != "Nv3" or not bool(eq2[0].badge_max):
		out.append("selo de nível máximo ausente no equipamento (%s)" % eq2[0].badge)
	var pb: Array = sheet2.tab_sections(2)
	if pb[0].entries.size() != 1 or pb[1].entries.size() != 1:
		out.append("aba de passivas e bênçãos deveria ter 1 passiva e 1 bênção")
	var groups: Array = sheet2.bonus_groups()
	var seen := {}
	for g in groups:
		for r in g.rows:
			if seen.has(r.key):
				out.append("bônus %s aparece em dois grupos" % r.key)
			seen[r.key] = true
	if not seen.has("forca"):
		out.append("bônus de FOR (passiva) deveria aparecer na lista total")
	sheet2.free()

	# ajuda de CA/CAM (IN-058)
	var tip_ca := CharacterSheet.defense_tip("ca", 14, 0.12)
	var tip_cam := CharacterSheet.defense_tip("cam", 9, 0.0)
	if tip_ca.find("Classe de Armadura (CA)") < 0 or tip_ca.find("12%") < 0 or tip_ca.find("físicos") < 0:
		out.append("texto de ajuda da CA incompleto")
	if tip_cam.find("Classe de Armadura Mágica (CAM)") < 0 or tip_cam.find("mágicos") < 0:
		out.append("texto de ajuda da CAM incompleto")
	if CharacterSheet.ability_cooldown_text(9.0, 12.0).find("base 12 s") < 0 or CharacterSheet.ability_cooldown_text(12.0, 12.0).find("base") >= 0:
		out.append("texto de recarga da habilidade fora do formato")

	# slot sem ícone não pode quebrar
	var slot := SheetSlot.new()
	slot.setup({"icon": "res://assets/icons/items/nao_existe.png", "letter": "X", "detail": "x"})
	if slot._icon != null:
		out.append("slot com ícone inexistente deveria cair no fallback de letra")
	slot.free()
	return out
