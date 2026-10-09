extends RefCounted
## SPEC-165 (MEC-003): o menu de pausa em abas dentro da HUD de verdade (nós antigos reaproveitados, navegação, catálogo, configurações).

func _key(code: int) -> InputEventKey:
	var ev := InputEventKey.new()
	ev.keycode = code
	ev.pressed = true
	return ev

func _inside(node: Node, ancestor: Node) -> bool:
	return node != null and ancestor.is_ancestor_of(node)

func run() -> Array:
	var out: Array = []
	var tree := Engine.get_main_loop() as SceneTree
	var b := Battle.new(3, "sylas", "dagruve")
	var hud: Node = load("res://ui/hud.tscn").instantiate()
	tree.root.add_child(hud)
	hud.update_stats(b)
	var menu: PauseMenu = hud.pause_menu
	if menu == null:
		out.append("a HUD deveria ter o PauseMenu")
		hud.free()
		return out

	# abas
	if PauseMenu.TAB_NAMES != ["Jogo", "Catálogo", "Configurações"]:
		out.append("abas: Jogo, Catálogo e Configurações")
	hud.show_pause(true)
	if menu.current_tab() != 0 or not hud.pause_panel.visible:
		out.append("abrir a pausa leva à aba Jogo")

	# os nós antigos seguem vivos dentro da aba Jogo e os nomes únicos continuam valendo
	for node_name in ["ResumeBtn", "AimBtn", "PauseHelpBtn", "QuitBtn"]:
		var n: Node = hud.get_node_or_null("%" + node_name)
		if n == null:
			out.append("%%%s deixou de ser achado (dono perdido ao mover)" % node_name)
		elif not (n as Control).is_visible_in_tree():
			out.append("%s deveria estar visível na aba Jogo" % node_name)
	if hud._pause_items == null or not _inside(hud._pause_items, menu) or not hud._pause_items.is_visible_in_tree():
		out.append("o botão Ficha do herói fica na aba Jogo")
	if hud._extract_button == null or not _inside(hud._extract_button, menu):
		out.append("o botão Extrair fica na aba Jogo")
	if not _inside(hud.vol_slider, menu) or hud.vol_slider.is_visible_in_tree():
		out.append("o volume geral mora na aba Configurações (escondido na aba Jogo)")
	if hud.has_node("PausePanel/VBox"):
		out.append("a caixa antiga saiu de PausePanel/VBox (agora está dentro da aba Jogo)")

	# navegação por abas: Q/E (teclado), LB/RB (controle) e dica de botão
	menu.set_tab(1)
	if menu.current_tab() != 1 or hud.get_node("%ResumeBtn").is_visible_in_tree():
		out.append("aba Catálogo: esconde os botões do Jogo")
	menu.cycle_tab(1)
	if menu.current_tab() != 2 or not hud.vol_slider.is_visible_in_tree():
		out.append("aba Configurações mostra o volume geral")
	menu.cycle_tab(1)
	if menu.current_tab() != 0:
		out.append("depois da última aba volta à primeira")
	menu.cycle_tab(-1)
	if menu.current_tab() != 2:
		out.append("antes da primeira aba vai para a última")
	menu.set_tab(0)
	if not menu.handle_input(_key(KEY_E)) or menu.current_tab() != 1:
		out.append("E avança a aba")
	if not menu.handle_input(_key(KEY_Q)) or menu.current_tab() != 0:
		out.append("Q volta a aba")
	if menu.handle_input(_key(KEY_W)) or menu.current_tab() != 0:
		out.append("outras teclas não trocam de aba")
	menu.is_blocked = func(): return true
	if menu.handle_input(_key(KEY_E)) or menu.current_tab() != 0:
		out.append("com ficha, controles ou confirmação por cima, Q/E não trocam a aba da pausa")
	menu.is_blocked = func(): return hud.items_panel.visible or hud._controls_panel.visible or hud._confirm_dialog.visible or Playtest.is_overlay_open()
	menu.set_tab(99)
	if menu.current_tab() != 2:
		out.append("aba fora do limite fica na última")
	menu.set_tab(-5)
	if menu.current_tab() != 0:
		out.append("aba negativa fica na primeira")

	# catálogo: tudo bloqueado no perfil de teste, e o que apareceu na run é descoberto e marcado
	var codex_saved: Dictionary = Game.profile.data.codex.duplicate(true)
	Game.profile.data.codex = {"enemies": {}, "items": {}, "weapons": {}}
	b.codex.enemies["zumbi"] = true
	menu.show_menu(b)
	menu.set_tab(1)
	var grid_count := 0
	for c in menu._grid.get_children():
		grid_count += 1
	if grid_count != Data.table("enemies").size():
		out.append("a grade de inimigos deveria ter %d células (tem %d)" % [Data.table("enemies").size(), grid_count])
	if String((menu._cat_buttons[0] as Button).text).find("1/%d" % Data.table("enemies").size()) < 0:
		out.append("o botão da categoria mostra os descobertos (1 nesta run): '%s'" % (menu._cat_buttons[0] as Button).text)
	menu.set_category(2)
	if menu.current_category() != 2 or menu._grid.get_child_count() != Data.table("items").uniques.size():
		out.append("categoria Itens únicos: %d células" % menu._grid.get_child_count())
	menu.set_category(1)
	var first: Button = menu.first_cell()
	if first == null:
		out.append("a grade de armas deveria ter células")
	else:
		first.emit_signal("pressed")
		if menu._detail.text != Catalog.UNKNOWN_DETAIL:
			out.append("célula bloqueada mostra 'ainda não descoberto'")
	Game.profile.data.codex = codex_saved

	# configurações refletem o perfil sem gravar
	var settings: Dictionary = Game.profile.data.settings
	var saved_settings := settings.duplicate(true)
	settings.music_volume = 0.35
	settings["music_muted"] = true
	settings["barks"] = false
	menu.set_tab(2)
	if absf(menu.options.music_vol.value - 0.35) > 0.001 or not menu.options.music_mute.button_pressed or menu.options.barks.button_pressed:
		out.append("configurações deveriam refletir o perfil (música %.2f, muda %s, falas %s)" % [menu.options.music_vol.value, menu.options.music_mute.button_pressed, menu.options.barks.button_pressed])
	if menu.options.aim.get_parent().visible:
		out.append("a mira fica só na aba Jogo (botão com Tab)")
	for k in saved_settings:
		settings[k] = saved_settings[k]
	for k in ["music_muted", "barks"]:
		if not saved_settings.has(k):
			settings.erase(k)

	hud.show_pause(false)
	hud.free()
	return out
