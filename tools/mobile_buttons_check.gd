extends "res://tools/mobile_preview.gd"
## Provas funcionais em perfil descartável. Sem exportação, upload ou save real.

var checks: Array[Dictionary] = []
var finger := 100

func _start() -> void:
	root.size = Vector2i(1280, 720)
	root.gui_embed_subwindows = true
	Game.touch_preview = true
	_real_save_before = Game.real_save_signature()
	Input.use_accumulated_input = false
	Game._save_path = OUTPUT + "buttons-profile.json"
	Game.profile = Profile.new({"name": "Teste botoes mobile", "welcome_seen": true})
	if Playtest._guide_open:
		Playtest._close_guide_modal()
	get_tree().paused = false
	capture = "--mobile-capture" in OS.get_cmdline_user_args()
	await super._check()
	await _check_all_buttons()
	_record("save_real_preservado", Game.real_save_signature() == _real_save_before)
	var file := FileAccess.open(OUTPUT + "buttons-report.json", FileAccess.WRITE)
	file.store_string(JSON.stringify({"pilot": "P067-v02", "native_device": false, "checks": checks, "failures": failures}, "\t"))
	for failure in failures:
		printerr("FALHA MOBILE: ", failure)
	print("mobile buttons: %d verificacoes; %d falha(s)" % [checks.size(), failures.size()])
	get_tree().quit(0 if failures.is_empty() else 1)

func _record(id: String, passed: bool) -> void:
	checks.append({"id": id, "passed": passed})
	if not passed:
		failures.append(id)
	print("botao/caso ", id, ": ", "PASS" if passed else "FAIL")

func _mouse(viewport: Viewport, point: Vector2) -> void:
	for pressed in [true, false]:
		_mouse_event(viewport, point, pressed)

func _mouse_event(viewport: Viewport, point: Vector2, pressed: bool) -> void:
	var event := InputEventMouseButton.new()
	event.device = InputEvent.DEVICE_ID_EMULATION
	event.button_index = MOUSE_BUTTON_LEFT
	event.button_mask = MOUSE_BUTTON_MASK_LEFT if pressed else 0
	event.pressed = pressed
	event.position = point
	event.global_position = point
	viewport.push_input(event, true)

func _screen_tap(point: Vector2) -> void:
	finger += 1
	_touch(finger, point, true)
	# O push_input sintetizado não passa pelo emulador do DisplayServer.
	# Entregar também o mouse que um toque nativo geraria prova a não duplicação.
	_mouse_event(root, point, true)
	_touch(finger, point, false)
	_mouse_event(root, point, false)

func _button(button: BaseButton) -> void:
	var button_name := String(button.name)
	var disabled := button.disabled
	var ancestor := button.get_parent()
	while ancestor != null:
		if ancestor is ScrollContainer:
			ancestor.ensure_control_visible(button)
		ancestor = ancestor.get_parent()
	await _frames()
	var count: Array = [0]
	var listener := func(): count[0] += 1
	button.pressed.connect(listener)
	if button.get_viewport() == root:
		_screen_tap(button.get_global_rect().get_center())
	else:
		var window: Window = button.get_viewport()
		_mouse(root, Vector2(window.position) + button.get_global_rect().get_center())
	await _frames()
	_record("entrada_unica_" + button_name, count[0] == (0 if disabled else 1))
	if is_instance_valid(button):
		button.pressed.disconnect(listener)

func _command(run: Node, action: StringName) -> void:
	run.hud.update_stats(run.battle)
	await _frames()
	_screen_tap(run.hud.mobile.regions[action].get_center())
	await _frames()

func _fresh_battle(run: Node) -> void:
	get_tree().paused = false
	run._paused = false
	run.battle = Battle.new(710, "durvall", "dagruve", {"cleared": {"dagruve": true}})
	run.battle.cleared_stages = ["dagruve"]
	Game.profile.data.cleared["dagruve"] = true
	run.battle.aim = Battle.Aim.AUTO
	run.hud.hide_offer()
	run.hud.hide_revive_offer()
	run.hud.result_panel.hide()
	run.hud.show_pause(false)
	run.hud.update_stats(run.battle)

func _choose(run: Node, index: int, id: String) -> void:
	run.hud.show_offer(run.battle)
	await _frames()
	await _button(run.hud._offer_buttons[index])
	_record(id + "_seleciona", run.hud._offer_selected == index)
	await _button(run.hud._offer_confirm)

func _check_all_buttons() -> void:
	# Título -> Quartel -> tentativa: callbacks reais, com save separado.
	var title = load("res://ui/title.tscn").instantiate()
	root.add_child(title)
	get_tree().current_scene = title
	await _frames()
	_screen_tap(Vector2(640, 600))
	await get_tree().create_timer(0.65).timeout
	var menu = get_tree().current_scene
	_record("titulo_entrar_quartel", menu != null and menu.scene_file_path == "res://ui/menu.tscn")
	if menu == null or menu.scene_file_path != "res://ui/menu.tscn":
		return
	await _check_menu(menu)
	menu.get_node("%Tabs").current_tab = 0
	await _frames()
	await _button(menu.play_btn)
	var run = get_tree().current_scene
	_record("quartel_jogar", run != null and run.scene_file_path == "res://ui/run.tscn")
	if run == null or run.scene_file_path != "res://ui/run.tscn":
		return
	run.set_physics_process(false)
	_fresh_battle(run)
	await _frames()
	var mobile: MobileControls = run.hud.mobile
	for point in [Vector2(180, 450), Vector2(1000, 450)]:
		finger += 1
		_touch(finger, point, true)
		_drag(finger, point + Vector2(-72, 0))
		var before: Vector2 = run.battle.hero.pos
		run._physics_process(0.2)
		_record("joystick_lado_" + str(point.x), mobile.movement_finger == finger and before.distance_to(run.battle.hero.pos) > 0.01)
		run.battle.active_cd = 0
		run.battle._spawn("zumbi", run.battle.hero.pos + Vector2(1, 0))
		run.hud.update_stats(run.battle)
		var origin := mobile.origin
		await _command(run, &"hero_active")
		_record("habilidade_com_joystick_" + str(point.x), run.battle.active_cd > 0 and mobile.origin == origin and mobile.movement_finger == finger - 1)
		if point.x > 640:
			await _shot("joystick-direita")
		_touch(mobile.movement_finger, point, false, true)
		_record("cancelamento_joystick_" + str(point.x), mobile.movement == Vector2.ZERO)
	var cooldown: float = run.battle.active_cd
	await _command(run, &"hero_active")
	_record("habilidade_bloqueada_na_recarga", is_equal_approx(run.battle.active_cd, cooldown))
	await _command(run, Game.ACTION_RUN_SPEED)
	_record("velocidade_1_5x", is_equal_approx(run.battle.speed_mult, 1.5))
	await _command(run, Game.ACTION_RUN_SPEED)
	_record("velocidade_2x", is_equal_approx(run.battle.speed_mult, 2.0))
	await _command(run, Game.ACTION_RUN_SPEED)
	_record("velocidade_1x", is_equal_approx(run.battle.speed_mult, 1.0))
	await _command(run, &"touch_help")
	_record("ajuda_combate", Playtest._guide_open and get_tree().paused)
	await _button(Playtest._guide_start)
	_record("fechar_ajuda_combate", not Playtest._guide_open and not get_tree().paused)
	await _command(run, Game.ACTION_RUN_ITEMS)
	var sheet: CharacterSheet = run.hud.items_panel
	_record("abrir_ficha", sheet.visible and get_tree().paused)
	for i in sheet._tab_buttons.size():
		await _button(sheet._tab_buttons[i])
		_record("ficha_aba_" + str(i), sheet._tab == i)
	for stat in [sheet._ca_btn, sheet._cam_btn]:
		await _button(stat)
		_record("ficha_detalhe_" + stat.text, sheet._detail.text != "")
	await _button(sheet._close_btn)
	_record("fechar_ficha", not sheet.visible and not get_tree().paused)
	await _command(run, Game.ACTION_RUN_PAUSE)
	_record("pausa", get_tree().paused and run.hud.pause_panel.visible)
	await _button(run.hud.get_node("%PauseHelpBtn"))
	_record("ajuda_pausa", Playtest._guide_open)
	await _button(Playtest._guide_start)
	await _slider(run.hud.vol_slider, "volume", "volume_pausa")
	await _button(run.hud.get_node("%ResumeBtn"))
	_record("continuar", not get_tree().paused)
	await _check_offers(run)
	await _command(run, Game.ACTION_RUN_PAUSE)
	await _button(run.hud.get_node("%QuitBtn"))
	_record("abandonar_pede_confirmacao", run.hud._confirm_dialog.visible and run.battle.state == "running")
	await _button(run.hud._confirm_dialog.get_cancel_button())
	_record("cancelar_abandono", get_tree().paused and run.battle.state == "running")
	await _button(run.hud.get_node("%QuitBtn"))
	await _button(run.hud._confirm_dialog.get_ok_button())
	_record("confirmar_abandono", run.battle.state == "dead" and not get_tree().paused)
	_fresh_battle(run)
	run.battle.state = "revive_offer"
	run.battle.hero.dead = true
	run.hud.show_revive_offer(run.battle)
	await _button(run.hud.get_node("%ReviveBtn"))
	_record("reviver", run.battle.state == "running" and not run.battle.hero.dead)
	run.battle.state = "revive_offer"
	run.battle.hero.dead = true
	run.hud.show_revive_offer(run.battle)
	await _button(run.hud.get_node("%DeclineReviveBtn"))
	_record("recusar_reviver", run.battle.state == "dead")
	_fresh_battle(run)
	run.battle.stage_cleared = true
	await _command(run, Game.ACTION_RUN_EXTRACT)
	await _button(run.hud._confirm_dialog.get_cancel_button())
	_record("cancelar_extracao_por_botao", run.battle.state == "running" and not get_tree().paused)
	await _command(run, Game.ACTION_RUN_EXTRACT)
	await _button(run.hud._confirm_dialog.get_ok_button())
	_record("confirmar_extracao", run.battle.state == "won" and run.battle.extracted)
	var result: Dictionary = run.battle.result()
	run.hud.show_result(result, {"earned": 0, "coins": Game.profile.coins(), "achievements": [], "reward_rate": 1.0})
	await _button(run.hud.get_node("%AgainBtn"))
	var again = get_tree().current_scene
	_record("resultado_jogar_novamente", again != run and again.scene_file_path == "res://ui/run.tscn")
	again.set_physics_process(false)
	again.hud.show_result(result, {"earned": 0, "coins": Game.profile.coins(), "achievements": [], "reward_rate": 1.0})
	await _button(again.hud.get_node("%MenuBtn"))
	_record("resultado_quartel", get_tree().current_scene.scene_file_path == "res://ui/menu.tscn")
	get_tree().current_scene.queue_free()
	await _frames()

func _check_menu(menu: Node) -> void:
	var tabs: TabContainer = menu.get_node("%Tabs")
	var bar := tabs.get_tab_bar()
	for i in bar.tab_count:
		_screen_tap(bar.global_position + bar.get_tab_rect(i).get_center())
		await _frames()
		_record("quartel_aba_" + str(i), tabs.current_tab == i)
	tabs.current_tab = 0
	await _frames()
	await _list_item(menu.hero_list, 0, "heroi")
	await _list_item(menu.stage_list, 0, "fase")
	tabs.current_tab = 3
	await _frames()
	await _popup_option(menu.codex_cat, 1, "categoria_codex")
	_record("categoria_codex_conteudo", menu._codex_cat_cache == "weapons")
	await _list_item(menu.codex_list, 0, "entrada_codex")
	_record("detalhe_codex", menu.codex_text.text != "")
	tabs.current_tab = 4
	await _frames()
	for pair in [[menu.vol_opt, "volume"], [menu.music_vol_opt, "music_volume"], [menu.sfx_vol_opt, "sfx_volume"], [menu.ambience_vol_opt, "ambience_volume"]]:
		await _slider(pair[0], pair[1], "opcao_" + pair[1])
	await _popup_option(menu.diff_opt, 1, "dificuldade")
	_record("dificuldade_salva", int(Game.profile.data.settings.difficulty) == 1)
	for pair in [[menu.music_mute_opt, "music_muted"], [menu.sfx_mute_opt, "sfx_muted"], [menu.ambience_mute_opt, "ambience_muted"], [menu.reduced_impact_opt, "reduced_impact"], [menu.barks_opt, "barks"]]:
		var before: bool = pair[0].button_pressed
		await _button(pair[0])
		_record("opcao_" + pair[1], Game.profile.data.settings.get(pair[1], false) != before)
	await _button(menu.guide_btn)
	_record("guia_quartel", Playtest._guide_open)
	await _button(Playtest._guide_start)
	_record("fechar_guia_quartel", not Playtest._guide_open)
	for disabled in [menu.aim_opt, menu.display_mode_opt, menu.resolution_opt]:
		await _button(disabled)
		_record("opcao_desktop_desativada_" + disabled.name, disabled.disabled and not disabled.get_popup().visible)
	# Reset apenas do perfil descartável; recuperar a cópia para o restante da prova.
	var saved := Game.profile.data.duplicate(true)
	await _button(menu.reset_btn)
	_record("reset_pede_segundo_toque", menu._reset_armed)
	await _button(menu.reset_btn)
	_record("reset_perfil_descartavel", not menu._reset_armed and Game.profile.coins() == 0)
	Game.profile = Profile.new(saved)
	Game.profile.data.coins = 10000
	menu._refresh_all()
	tabs.current_tab = 1
	await _frames()
	for row in menu.upgrade_box.get_children():
		var button := row.get_child(1) as Button
		if not button.disabled:
			var coins := Game.profile.coins()
			await _button(button)
			_record("comprar_melhoria_quartel", Game.profile.coins() < coins)
			break
	tabs.current_tab = 5
	await _frames()
	await _list_item(menu.hq_list, 0, "lista_hq")
	await _button(menu.hq_play_btn)
	var reader: Node
	for child in menu.get_children():
		if child.scene_file_path == "res://ui/hq_screen.tscn":
			reader = child
	_record("abrir_hq_diario", reader != null)
	if reader != null:
		var buttons: Array = []
		_collect_buttons(reader, buttons)
		for button in buttons:
			if button.text == "Próximo":
				await _button(button)
				_record("hq_proximo", reader.panel_index == 1)
		for button in buttons:
			if button.text == "Fechar":
				await _button(button)
				_record("hq_fechar", not is_instance_valid(reader) or reader.is_closed)

func _collect_buttons(node: Node, out: Array) -> void:
	if node is Button:
		out.append(node)
	for child in node.get_children():
		_collect_buttons(child, out)

func _reveal(control: Control) -> void:
	var ancestor := control.get_parent()
	while ancestor != null:
		if ancestor is ScrollContainer:
			ancestor.ensure_control_visible(control)
		ancestor = ancestor.get_parent()
	await _frames()

func _slider(slider: Slider, key: String, id: String) -> void:
	await _reveal(slider)
	var point := slider.global_position + Vector2(slider.size.x * 0.25, slider.size.y * 0.5)
	_screen_tap(point)
	await _frames()
	_record(id, absf(slider.value - 0.25) <= 0.1 and is_equal_approx(float(Game.profile.data.settings[key]), slider.value))

func _list_item(list: ItemList, index: int, id: String) -> void:
	var selected: Array = []
	var listener := func(i): selected.append(i)
	list.item_selected.connect(listener)
	_screen_tap(list.global_position + list.get_item_rect(index).get_center())
	await _frames()
	_record("selecionar_" + id, selected == [index] and list.is_selected(index))
	list.item_selected.disconnect(listener)

func _popup_option(option: OptionButton, index: int, id: String) -> void:
	await _button(option)
	var popup := option.get_popup()
	_record("abrir_" + id, popup.visible)
	var panel := popup.get_theme_stylebox("panel")
	var top := panel.get_content_margin(SIDE_TOP)
	var bottom := panel.get_content_margin(SIDE_BOTTOM)
	var height := (popup.size.y - top - bottom) / popup.item_count
	_mouse(root, Vector2(popup.position) + Vector2(40, top + height * (index + 0.5)))
	await _frames()
	_record("escolher_" + id, option.selected == index and not popup.visible)

func _check_offers(run: Node) -> void:
	run.battle._open_levelup()
	run.battle.rerolls = 1
	run.hud.show_offer(run.battle)
	await _frames()
	await _button(run.hud.reroll_btn)
	_record("rerrolar", run.battle.rerolls == 0 and run.hud._offer_selected == -1)
	await _choose(run, 0, "melhoria")
	_record("confirmar_melhoria", run.battle.state == "running")
	run.battle._open_altar()
	await _choose(run, run.battle.offer.size() - 1, "recusar_bencao")
	_record("recusar_bencao", run.battle.state == "running")
	run.battle._open_altar()
	await _choose(run, 0, "bencao")
	_record("confirmar_bencao", run.battle.state == "running")
	run.battle.hero.gold = 10000
	run.battle.interactions.append({"kind": "loja", "pos": run.battle.hero.pos, "used": false, "born_at": -1.0})
	await _command(run, Game.ACTION_RUN_INTERACT)
	_record("interagir_loja", run.battle.state == "shop")
	var gold: float = run.battle.hero.gold
	await _choose(run, 0, "comprar_loja")
	_record("comprar_loja", run.battle.hero.gold < gold)
	# Retomar com uma saída por toque, mesmo se compra abriu comparação de equipamento.
	if run.battle.state == "item_offer":
		await _choose(run, 0, "equipar_item")
	run.battle._open_shop_event("loja")
	var leave: int = run.battle.offer.size() - 1
	await _choose(run, leave, "sair_loja")
	_record("sair_loja", run.battle.state == "running")
	var item: Dictionary = Items.roll(run.battle.rng, 0, 0)
	run.battle._equip_item(item)
	for choice in [0, 1]:
		var replacement := item.duplicate(true)
		replacement.name = "Item teste " + str(choice)
		replacement.id = "teste_mobile_" + str(choice)
		run.battle.give_item(replacement)
		gold = run.battle.hero.gold
		await _choose(run, choice, "equipar_vender_" + str(choice))
		_record("equipar_vender_" + str(choice), run.battle.state == "running" and run.battle.hero.gold > gold)
