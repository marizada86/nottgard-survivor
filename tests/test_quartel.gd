extends RefCounted
## SPEC-166 (MEC-003 lote 2): o Quartel no UiKit: abas por nome, opções do OptionsPanel (apelidos) e Códex igual ao Catalog.

func run() -> Array:
	var out: Array = []
	var tree := Engine.get_main_loop() as SceneTree
	var saved_path: String = Game._save_path
	var saved_profile = Game.profile
	Game._save_path = "res://tmp/test-quartel/profile.json"   # nunca o save real
	Game.profile = Profile.new({"name": "Teste Quartel", "welcome_seen": true})
	Game.profile.data.codex.enemies["zumbi"] = true
	Game.profile.data.codex.weapons["espada_sombria"] = true
	var menu: Control = load("res://ui/menu.tscn").instantiate()
	tree.root.add_child(menu)

	# abas: as oito, por nome, na ordem de sempre
	var tabs: TabContainer = menu.get_node("%Tabs")
	var names: Array = []
	for i in tabs.get_tab_count():
		names.append(String(tabs.get_child(i).name))
	if names != ["Jogar", "Marcas", "Melhorias", "Conquistas", "Códex", "Opções", "Diário", "Ranking"] and names != ["Jogar", "Marcas", "Melhorias", "Conquistas", "Códex", "Opções", "Diário"]:
		out.append("abas do Quartel fora da ordem: %s" % str(names))
	# estilo da ficha C nas abas e no painel
	if not tabs.has_theme_stylebox_override("tab_selected") or not tabs.has_theme_stylebox_override("panel"):
		out.append("o TabContainer deveria receber o estilo do UiKit (aba selecionada e painel)")
	if not menu.hero_list.has_theme_stylebox_override("selected"):
		out.append("a lista de heróis deveria usar o estilo do UiKit")

	# opções: apelidos do OptionsPanel
	if menu.options_panel == null:
		out.append("o Quartel deveria ter um OptionsPanel")
	else:
		var pairs := {"vol_opt": "master_vol", "music_vol_opt": "music_vol", "sfx_vol_opt": "sfx_vol", "ambience_vol_opt": "ambience_vol",
			"music_mute_opt": "music_mute", "sfx_mute_opt": "sfx_mute", "ambience_mute_opt": "ambience_mute", "reduced_impact_opt": "reduced_impact",
			"barks_opt": "barks", "display_mode_opt": "display_mode", "resolution_opt": "resolution", "aim_opt": "aim"}
		for alias in pairs:
			if menu.get(alias) == null or menu.get(alias) != menu.options_panel.get(pairs[alias]):
				out.append("%s deveria ser o mesmo controle de options_panel.%s" % [alias, pairs[alias]])
		if not menu.options_panel.is_visible_in_tree() and tabs.current_tab == names.find("Opções"):
			out.append("o OptionsPanel deveria aparecer na aba Opções")
		# reflete o perfil
		var s: Dictionary = Game.profile.data.settings
		if absf(menu.vol_opt.value - float(s.volume)) > 0.001 or absf(menu.music_vol_opt.value - float(s.music_volume)) > 0.001:
			out.append("os volumes deveriam refletir o perfil")
		if menu.barks_opt.button_pressed != bool(s.get("barks", true)):
			out.append("as falas deveriam refletir o perfil")
		# gravar pelo componente grava no perfil (arquivo de teste)
		menu.music_vol_opt.value = 0.35
		if absf(float(Game.profile.data.settings.music_volume) - 0.35) > 0.001:
			out.append("mexer no volume da música deveria gravar no perfil")
		menu.music_mute_opt.button_pressed = true
		if not bool(Game.profile.data.settings.get("music_muted", false)):
			out.append("silenciar a música deveria gravar no perfil")
		menu.barks_opt.button_pressed = not menu.barks_opt.button_pressed
		if bool(Game.profile.data.settings.get("barks", true)) != menu.barks_opt.button_pressed:
			out.append("alternar as falas deveria gravar no perfil")

	# códex: as mesmas entradas e detalhes do Catalog
	menu._fill_codex()
	var expected := Catalog.entries("enemies", Game.profile.data.codex)
	if menu.codex_list.item_count != expected.size():
		out.append("o códex deveria listar %d inimigos (listou %d)" % [expected.size(), menu.codex_list.item_count])
	var zumbi_at := -1
	for i in expected.size():
		if String(expected[i].id) == "zumbi":
			zumbi_at = i
	if zumbi_at >= 0:
		if menu.codex_list.get_item_text(zumbi_at) != String(expected[zumbi_at].name):
			out.append("o nome do inimigo conhecido deveria vir do Catalog")
		menu._show_codex(zumbi_at)
		if menu.codex_text.text != Catalog.detail("enemies", "zumbi", true):
			out.append("o detalhe do códex deveria ser o do Catalog")
	var locked := 0 if zumbi_at != 0 else 1
	if menu.codex_list.get_item_text(locked) != Catalog.UNKNOWN_NAME:
		out.append("inimigo bloqueado deveria aparecer como '???'")
	menu._show_codex(locked)
	if menu.codex_text.text != Catalog.UNKNOWN_DETAIL:
		out.append("detalhe bloqueado deveria ser 'ainda não descoberto'")
	menu.codex_cat.select(1)
	menu._fill_codex()
	if menu._codex_cat_cache != "weapons" or menu.codex_list.item_count != Catalog.entries("weapons", Game.profile.data.codex).size():
		out.append("categoria Armas do códex deveria vir do Catalog")
	if menu.codex_cat.get_item_text(2) != String(Catalog.LABELS["items"]):
		out.append("os nomes das categorias do códex são os do Catalog")

	menu.queue_free()
	Game.profile = saved_profile
	Game._save_path = saved_path
	return out
