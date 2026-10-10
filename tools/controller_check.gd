extends Node
@onready var root: Window = get_tree().root
## Provas por eventos sinteticos e capturas; perfil separado do progresso real.
const OUTPUT := "res://.atena/generated/controller-experience/v02/"
var checks: Array[Dictionary] = []
var failures: Array[String] = []
var capture := false
var real_before: Dictionary

func _pair(name: String) -> void:
	if not capture:
		return
	for size in [Vector2i(1280, 720), Vector2i(1920, 1080)]:
		root.size = size
		await _frames(8)
		await _shot(name + "_%dx%d" % [size.x, size.y])
	root.size = Vector2i(1280, 720)
	await _frames(4)

func _ready() -> void:
	call_deferred("_run_checks")
	get_tree().create_timer(240.0).timeout.connect(func():
		printerr("controller integration: timeout de seguranca")
		get_tree().quit(2))

func _frames(count: int = 3) -> void:
	for i in count:
		await get_tree().process_frame

func _record(id: String, passed: bool) -> void:
	checks.append({"id": id, "passed": passed})
	if not passed:
		failures.append(id)
	print("controller ", id, ": ", "PASS" if passed else "FAIL")

func _send(index: int, pressed: bool, device: int = 0) -> void:
	var event := InputEventJoypadButton.new()
	event.button_index = index
	event.device = device
	event.pressed = pressed
	root.push_input(event, true)

func _button(index: int, device: int = 0) -> void:
	_send(index, true, device)
	await _frames(2)
	_send(index, false, device)
	await _frames(2)

func _shot(name: String) -> void:
	if not capture:
		return
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(OUTPUT + name + ".png")

func _run_checks() -> void:
	get_tree().current_scene = null
	root.size = Vector2i(1280, 720)
	root.gui_embed_subwindows = true
	capture = "--controller-capture" in OS.get_cmdline_user_args()
	Input.use_accumulated_input = false
	real_before = Game.real_save_signature()
	# Perfil e save de teste: sem isto qualquer Game.save() do fluxo (fim de run, Ecos, opções) grava o perfil de teste no save real (user://profile.json)
	Game._save_path = OUTPUT + "integration-profile.json"
	Game.profile = Profile.new({"name": "Controle local", "welcome_seen": true})
	for id in Data.table("hqs"):
		Game.profile.data.hqs_seen[id] = true
	if Playtest._guide_open:
		Playtest._close_guide_modal()
	Game.controls._held.clear()
	Game.controls._blocked.clear()
	Game.controls.active_device = 0
	Game.controls.method = "controller"
	Game.controls.disconnected = false
	Game.controls.focused = true
	Game.profile.data.settings.controller = {"family": "xbox"}
	Game.save()   # o título recarrega o perfil do arquivo: o fixture precisa estar no arquivo de teste (antes isso só funcionava por gravar no save real)
	Game.ensure_input_actions()
	var title: Control = load("res://ui/title.tscn").instantiate()
	root.add_child(title)
	get_tree().current_scene = title
	await _frames()
	await _button(JOY_BUTTON_A)
	await get_tree().create_timer(0.7).timeout
	_record("titulo_ao_quartel", get_tree().current_scene != title and Game.screen_name == "menu")
	var menu = get_tree().current_scene
	var tabs: TabContainer = menu.get_node("Tabs")
	await _pair("quartel_xbox")
	await _button(JOY_BUTTON_RIGHT_SHOULDER)
	_record("quartel_aba_proxima", tabs.current_tab == 1)
	await _button(JOY_BUTTON_LEFT_SHOULDER)
	_record("quartel_aba_anterior", tabs.current_tab == 0)
	tabs.current_tab = tabs.get_tab_idx_from_control(menu.get_node("Tabs/Opções"))
	await _frames()
	menu.guide_btn.grab_focus()
	Playtest.open_game_rules()
	await _frames()
	await _button(JOY_BUTTON_B)
	_record("guia_volta_ao_foco", not Playtest._guide_open and root.gui_get_focus_owner() == menu.guide_btn)
	var reader = load("res://ui/hq_screen.tscn").instantiate()
	root.add_child(reader)
	reader.start_hq(Data.table("hqs").values()[0])
	await _button(JOY_BUTTON_A)
	_record("hq_avanca", reader.panel_index == 1)
	await _button(JOY_BUTTON_B)
	_record("hq_volta", reader.is_closed)
	reader.queue_free()
	await _frames()
	tabs.current_tab = 0
	await _frames()
	await _button(JOY_BUTTON_DPAD_RIGHT)
	_record("direcional_heroi_para_fase", root.gui_get_focus_owner() == menu.stage_list)
	await _button(JOY_BUTTON_DPAD_RIGHT)
	_record("direcional_fase_para_jogar", root.gui_get_focus_owner() == menu.play_btn)
	await _button(JOY_BUTTON_A)
	await _frames(12)
	var run = get_tree().current_scene
	_record("quartel_inicia_run", Game.screen_name == "run" and run.get("battle") != null)
	if run.get("battle") == null:
		_finish()
		return
	var battle: Battle = run.battle
	var hud = run.hud
	await _pair("hud_xbox")
	await _button(JOY_BUTTON_BACK)
	_record("ficha_por_view", hud.items_panel.visible and get_tree().paused)
	var sheet: CharacterSheet = hud.items_panel
	var before_cd := battle.active_cd
	for family in ["xbox", "ps4", "ps5", "generic"]:
		Game.profile.data.settings.controller.family = family
		Game.controls.changed.emit()
		for index in 4:
			await _button(JOY_BUTTON_RIGHT_SHOULDER)
			_record("%s_aba_detalhes_%d" % [family, index], sheet.current_tab() == (index + 1) % 4)
		await _button(JOY_BUTTON_LEFT_SHOULDER)
		_record("%s_aba_anterior" % family, sheet.current_tab() == 3)
		await _button(JOY_BUTTON_RIGHT_SHOULDER)
		_record("%s_abas_sem_habilidade" % family, battle.active_cd == before_cd)
		await _shot("ficha_" + family)
	Game.profile.data.settings.controller.family = "ps5"
	Game.controls.changed.emit()
	_record("prompts_r1_l1", sheet._previous_hint.tooltip_text.contains("L1") and sheet._next_hint.tooltip_text.contains("R1") and sheet._next_hint.icon != null)
	await _pair("ficha_ps5")
	await _button(JOY_BUTTON_B)
	_record("ficha_volta_com_circulo", not sheet.visible and not get_tree().paused)
	await _button(JOY_BUTTON_START)
	_record("pausa_options", hud.pause_panel.visible and get_tree().paused)
	hud._pause_items.grab_focus()
	await _button(JOY_BUTTON_A)
	_record("ficha_pela_pausa", sheet.visible and get_tree().paused)
	await _button(JOY_BUTTON_B)
	_record("ficha_retorna_pausa", not sheet.visible and hud.pause_panel.visible and get_tree().paused and root.gui_get_focus_owner() == hud._pause_items)
	await _shot("pausa_ps5")
	await _pair("pausa_ps5")
	hud._controls_panel.show()
	await _pair("opcoes_ps5")
	hud._controls_close.grab_focus()
	await _button(JOY_BUTTON_B)
	_record("opcoes_volta_a_pausa", not hud._controls_panel.visible and hud.pause_panel.visible and get_tree().paused)
	await _button(JOY_BUTTON_B)
	_record("pausa_volta_sem_abandonar", not get_tree().paused and battle.state == "running")
	var speed := battle.speed_scale()
	await _button(JOY_BUTTON_DPAD_UP)
	_record("direcional_nao_muda_velocidade", battle.speed_scale() == speed)
	battle.stage_cleared = true
	var aim_before := battle.aim
	await _button(JOY_BUTTON_Y)
	_record("triangulo_muda_mira_sem_extrair", battle.aim != aim_before and battle.state == "running")
	await _button(JOY_BUTTON_START)
	hud._extract_button.grab_focus()
	await _button(JOY_BUTTON_A)
	_record("extracao_exige_confirmacao", hud._confirm_dialog.visible and battle.state == "running")
	await _button(JOY_BUTTON_B)
	_record("cancelar_extracao_preserva_run", not hud._confirm_dialog.visible and battle.state == "running" and get_tree().paused)
	await _button(JOY_BUTTON_B)
	var time_before := battle.time
	Game.controls.active_device = 0
	Game.controls.connection_changed(0, false)
	await _frames()
	_record("desconexao_pausa", get_tree().paused and hud.pause_panel.visible and Game.controls.disconnected)
	await _button(JOY_BUTTON_RIGHT_SHOULDER, 1)
	_record("segundo_controle_nao_retoma", get_tree().paused and battle.time == time_before)
	Game.controls.select_device(0)
	_record("reconexao_nao_retoma", get_tree().paused)
	await _button(JOY_BUTTON_B)
	run.set_physics_process(false)
	battle.state = "levelup"
	battle.offer_kind = "levelup"
	battle.offer = [{"t": "gold", "name": "Moedas de teste", "desc": "Teste local", "n": 5, "brief": "Teste", "detail": {"rows": [], "footer": ["Detalhe de teste"]}}]
	hud.show_offer(battle)
	await _frames()
	await _button(JOY_BUTTON_RIGHT_STICK)
	_record("detalhes_alternaveis", hud._controller_detail_on)
	await _button(JOY_BUTTON_RIGHT_STICK)
	_record("detalhes_fecham_sem_manter", not hud._controller_detail_on)
	await _shot("oferta_ps5")
	await _pair("oferta_ps5")
	var offer_focus := root.gui_get_focus_owner()
	var rerolls_before := battle.rerolls
	await _button(JOY_BUTTON_BACK)
	_record("ficha_sobre_oferta", sheet.visible and get_tree().paused)
	for i in 4:
		await _button(JOY_BUTTON_RIGHT_SHOULDER)
	await _button(JOY_BUTTON_LEFT_SHOULDER)
	_record("abas_sobre_oferta_sem_rerrolar", battle.rerolls == rerolls_before and battle.active_cd == before_cd and battle.state == "levelup")
	await _button(JOY_BUTTON_B)
	_record("ficha_retorna_oferta", not sheet.visible and not get_tree().paused and root.gui_get_focus_owner() == offer_focus)
	Game.controls.connection_changed(0, false)
	await _frames()
	_record("desconexao_na_oferta", get_tree().paused and hud.pause_panel.visible and battle.state == "levelup")
	Game.controls.select_device(0)
	await _button(JOY_BUTTON_B)
	_record("reconexao_preserva_oferta", not get_tree().paused and battle.state == "levelup")
	hud.hide_offer()
	battle.state = "running"
	Game.profile.data.settings.controller = {"preset": "legacy", "family": "xbox"}
	Game.ensure_input_actions()
	Game.controls.changed.emit()
	await _button(JOY_BUTTON_START)
	await _button(JOY_BUTTON_A)
	_record("legado_sul_volta", not get_tree().paused)
	Game.profile.data.settings.controller = {"family": "xbox"}
	Game.ensure_input_actions()
	Game.controls.changed.emit()
	await _rare_contexts(run)
	Game.controls.set_setting("move_deadzone", 0.31)
	Game.controls.set_setting("aim_deadzone", 0.18)
	Game.controls.remap_button("hero_active", JOY_BUTTON_LEFT_STICK)
	Game.load_profile()
	Game.ensure_input_actions()
	_record("preferencias_persistem_reload", is_equal_approx(Game.controls.deadzone(), 0.31) and is_equal_approx(Game.controls.deadzone(true), 0.18) and Game.controls.button("hero_active") == JOY_BUTTON_LEFT_STICK)
	_record("zona_morta_navegacao", is_equal_approx(InputMap.action_get_deadzone("ui_up"), 0.31))
	Game.controls.restore_defaults()
	_record("restaurar_defaults", Game.controls.preset() == "standard" and Game.controls.button("hero_active") == JOY_BUTTON_RIGHT_SHOULDER)
	Game.controls._notification(Node.NOTIFICATION_APPLICATION_FOCUS_OUT)
	await _button(JOY_BUTTON_RIGHT_SHOULDER)
	_record("perda_foco_bloqueia", get_tree().paused and hud.pause_panel.visible)
	Game.controls._notification(Node.NOTIFICATION_APPLICATION_FOCUS_IN)
	await _button(JOY_BUTTON_B)
	_record("foco_nao_retoma_sozinho", not get_tree().paused)
	Game.controls.method = "controller"
	var idle_family := Game.controls.family()
	var idle_focus := root.gui_get_focus_owner()
	print("controller repouso de 60 segundos iniciado")
	await get_tree().create_timer(60.0).timeout
	_record("repouso_60s_sem_troca", Game.controls.family() == idle_family and Game.controls.method == "controller" and root.gui_get_focus_owner() == idle_focus)
	run.battle.stage_cleared = true
	hud.update_stats(run.battle)
	await _button(JOY_BUTTON_START)
	hud._extract_button.grab_focus()
	await _button(JOY_BUTTON_A)
	hud._confirm_dialog.get_ok_button().grab_focus()
	await _button(JOY_BUTTON_A)
	run._show_result()
	await _frames(8)
	_record("extracao_ao_resultado", hud.result_panel.visible and run.battle.state == "won")
	await _pair("resultado_xbox")
	hud.get_node("%AgainBtn").grab_focus()
	await _button(JOY_BUTTON_A)
	await _frames(12)
	_record("resultado_nova_tentativa", get_tree().current_scene != run and Game.screen_name == "run")
	_record("save_real_preservado", Game.real_save_signature() == real_before)
	_finish()

func _choice(run: Node, index: int) -> void:
	run.hud.show_offer(run.battle)
	await _frames()
	var options: Array = []
	for child in run.hud.offer_box.get_children():
		if child is Button:
			options.append(child)
	options[index].grab_focus()
	await _button(JOY_BUTTON_A)
	if run.hud._confirm_dialog.visible:
		run.hud._confirm_dialog.get_ok_button().grab_focus()
		await _button(JOY_BUTTON_A)
	await _frames()

func _rare_contexts(run: Node) -> void:
	var original: Battle = run.battle
	for hero in Data.table("heroes"):
		var sample := Battle.new(43, hero, "dagruve")
		sample._spawn("zumbi", sample.hero.pos + Vector2(1, 0))
		run.battle = sample
		await _button(JOY_BUTTON_RIGHT_SHOULDER)
		var cooldown := sample.active_cd
		await _button(JOY_BUTTON_RIGHT_SHOULDER)
		_record("habilidade_%s_recarga" % hero, cooldown > 0 and sample.active_cd == cooldown)
	run.battle = original
	run.battle.stage_cleared = false
	run.battle.state = "running"
	_send(JOY_BUTTON_A, true)
	run.battle._open_levelup()
	run.hud.show_offer(run.battle)
	await _frames(8)
	_record("confirmar_mantido_nao_aceita_oferta", run.battle.state == "levelup")
	_send(JOY_BUTTON_A, false)
	await _frames()
	run.battle.rerolls = 1
	await _button(JOY_BUTTON_LEFT_SHOULDER)
	_record("rerrolar_por_lb", run.battle.rerolls == 0 and run.battle.state == "levelup")
	await _choice(run, 0)
	_record("melhoria_confirma_uma_vez", run.battle.state == "running")
	run.battle._open_altar()
	await _choice(run, 0)
	_record("bencao_por_controle", run.battle.state == "running")
	run.battle._open_altar()
	run.hud.show_offer(run.battle)
	await _frames()
	var buttons: Array = []
	for child in run.hud.offer_box.get_children():
		if child is Button:
			buttons.append(child)
	buttons.back().grab_focus()
	await _button(JOY_BUTTON_A)
	# d702247 (2026-10-07): no desktop e no controle recusar a bênção aplica direto, sem janela "Confirmar ...?"
	_record("recusa_bencao_aplica_direto", not run.hud._confirm_dialog.visible and run.battle.state == "running" and int(run.battle.stats.boons_declined) >= 1)
	run.battle.hero.gold = 10000
	for kind in ["loja", "ferreiro", "curandeiro", "doacao", "aposta"]:
		run.battle._open_shop_event(kind)
		await _choice(run, run.battle.offer.size() - 1)
		_record("sair_%s_por_controle" % kind, run.battle.state == "running")
	var item := Items.roll(run.battle.rng, 0, 0)
	run.battle._equip_item(item)
	for index in [0, 1]:
		var replacement := item.duplicate(true)
		replacement.id = "controller_test_%d" % index
		run.battle.give_item(replacement)
		await _choice(run, index)
		_record("equipar_vender_%d" % index, run.battle.state == "running")
	run.battle.state = "revive_offer"
	run.battle.hero.dead = true
	run.battle.free_revive_used = false
	run.hud.show_revive_offer(run.battle)
	await _frames()
	await _button(JOY_BUTTON_A)
	_record("reviver_por_controle", run.battle.state == "running" and not run.battle.hero.dead)

func _finish() -> void:
	var devices: Array = []
	for id in Input.get_connected_joypads():
		devices.append({"id": id, "name": Input.get_joy_name(id), "guid": Input.get_joy_guid(id)})
	var file := FileAccess.open(OUTPUT + "integration-report.json", FileAccess.WRITE)
	file.store_string(JSON.stringify({"checks": checks, "failures": failures, "devices_detected": devices, "synthetic_input": true, "hardware_acceptance": false}, "\t"))
	print("controller integration: %d verificacoes; %d falha(s)" % [checks.size(), failures.size()])
	get_tree().quit(0 if failures.is_empty() else 1)
