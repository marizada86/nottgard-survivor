extends RefCounted
## SPEC-127 (MEC-043/044): slot da habilidade ativa na HUD e descrição na ficha C.

func run() -> Array:
	var out: Array = []
	var abilities: Dictionary = Data.table("abilities")
	var heroes: Dictionary = Data.table("heroes")
	for hid in heroes:
		var a: Dictionary = abilities.get(hid, {})
		if a.is_empty():
			out.append("%s sem habilidade em abilities.json" % hid)
			continue
		for k in ["id", "name", "cooldown", "desc"]:
			if not a.has(k) or str(a[k]) == "":
				out.append("%s: habilidade sem '%s'" % [hid, k])
		if not ResourceLoader.exists("res://assets/icons/abilities/%s.png" % String(a.get("id", ""))):
			out.append("%s: falta o ícone da habilidade %s" % [hid, a.get("id", "?")])
	if AbilitySlot.cooldown_text(0.0) != "" or AbilitySlot.cooldown_text(4.26) != "4.3" or AbilitySlot.cooldown_text(9.99) != "10.0" or AbilitySlot.cooldown_text(12.2) != "13":
		out.append("cooldown_text: formato inesperado (%s / %s / %s)" % [AbilitySlot.cooldown_text(4.26), AbilitySlot.cooldown_text(9.99), AbilitySlot.cooldown_text(12.2)])
	var tree := Engine.get_main_loop() as SceneTree
	for hid in ["durvall", "sylas", "brook"]:
		var b := Battle.new(3, hid, "dagruve")
		var hud: Node = load("res://ui/hud.tscn").instantiate()
		tree.root.add_child(hud)
		hud.update_stats(b)
		var slot: AbilitySlot = hud.get_node("AbilitySlot")
		if slot == null or slot.tooltip_text.find(String(abilities[hid].name)) < 0:
			out.append("%s: slot da habilidade ausente ou sem tooltip com o nome" % hid)
		if hud.active_label.visible or hud.active_icon.visible:
			out.append("%s: texto e ícone antigos deveriam estar ocultos" % hid)
		b.active_cd = 5.0
		b.active_cd_max = 10.0
		hud.update_stats(b)
		hud.show_items_panel(b)
		var txt: String = hud.items_desc_label.text
		if txt.find("Habilidade [Q/RMB]: %s" % String(abilities[hid].name)) < 0 or txt.find(String(abilities[hid].desc).substr(0, 20)) < 0:
			out.append("%s: ficha C sem a seção da habilidade" % hid)
		if txt.find("Recarga %.1f s" % b.active_cooldown_effective()) < 0:
			out.append("%s: ficha C sem a recarga efetiva (%.1f)" % [hid, b.active_cooldown_effective()])
		hud.free()
	return out
