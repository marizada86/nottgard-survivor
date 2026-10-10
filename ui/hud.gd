extends CanvasLayer
## HUD da run. Os nós vêm de hud.tscn (nomes únicos %); este script só os atualiza.

signal offer_chosen(index: int)
signal reroll_pressed
signal resume_pressed
signal quit_pressed
signal again_pressed
signal menu_pressed
signal aim_pressed
signal help_pressed
signal speed_pressed
signal revive_pressed
signal decline_revive_pressed
signal items_closed
signal mobile_command(action: StringName)
signal extract_pressed
signal pause_items_pressed

const STATUS_MAX_LINES := 4
const STACK_TOP := 90.0   # abaixo do relógio, do nome da fase e do ícone da regra
const STACK_WIDTH := 640.0   # a barra do chefe tem 580 px; 640 deixa a direita livre para o questlog (x >= 968)
const QUESTLOG_TOP := 66.0        # abaixo dos botões 1x e ? (y 12 a 58)
const QUESTLOG_MARGIN := 12.0
const TOAST_MAX_COUNT := 4
const TOAST_MAX_HEIGHT := 120.0   # cabe a epígrafe de 2 linhas e mais 3 avisos curtos; abaixo disso fica acima da fala do herói
const TOAST_WIDTH := 470.0        # 640 - 235 = 405 > 385: não encosta na ficha do herói
const TOAST_LONG_CHARS := 60

@onready var info_label: Label = %InfoLabel  # sem uso desde a SPEC-147 (o Estige virou o StatusChip); o herói está no HeroPanel
@onready var stage_rule_icon: TextureRect = %StageRuleIcon
@onready var timer_label: Label = %TimerLabel
@onready var stage_label: Label = %StageLabel
@onready var boss_panel: Control = %BossPanel
@onready var boss_name: Label = %BossName
@onready var boss_bar: ProgressBar = %BossBar
@onready var weapons_label: Label = %WeaponsLabel
@onready var toast_box: VBoxContainer = %ToastBox
@onready var prompt_label: Label = %PromptLabel
@onready var levelup_panel: PanelContainer = %LevelUpPanel
@onready var lv_title: Label = %LvTitle
@onready var offer_box: VBoxContainer = %OfferBox
@onready var reroll_btn: Button = %RerollBtn
@onready var pause_panel: PanelContainer = %PausePanel
@onready var aim_btn: Button = %AimBtn
@onready var vol_slider: HSlider = %VolSlider
@onready var result_panel: PanelContainer = %ResultPanel
@onready var result_title: Label = %ResultTitle
@onready var result_text: Label = %ResultText
@onready var result_background: TextureRect = %ResultBackground
@onready var revive_panel: PanelContainer = %RevivePanel
@onready var revive_text: Label = %ReviveText
var items_panel: CharacterSheet  # SPEC-130: ficha C em abas (ui/character_sheet.gd)
var hero_panel: HeroPanel  # SPEC-131 (ui/hero_panel.gd)
var _active_icon_id := ""
var _ability_slot: AbilitySlot
var _stage_icon_id := ""
var objective_label: Label  # linhas de status (juramento, buffs, Favor) abaixo do painel de quests
var quest_panel: QuestPanel  # SPEC-147: objetivos dos acontecimentos da fase (SPEC-118)
var top_stack: VBoxContainer  # SPEC-147: chefe, quests, status e avisos empilhados no topo central
var status_chip: StatusChip  # SPEC-147: Estige (na água) e Esquecimento
var eco_banner: EcoBanner     # SPEC-152: faixa do Eco de Nottgard (6 s, sem pausar)
var _long_toast: Label            # SPEC-167: o aviso longo vivo (só um por vez)
var _long_toast_queue: Array = []   # avisos longos à espera: [texto, cor]
var eco_counter: Label        # SPEC-152: "Ecos 1/4", só depois do primeiro achado na fase
var mobile: MobileControls
var event_pointer: EventPointer  # SPEC-159 (MEC-061): setas de evento na borda da tela
var pause_menu: PauseMenu   # SPEC-165 (MEC-003): menu de pausa em abas
var _pause_box: VBoxContainer  # os botões antigos da pausa; ficam dentro da aba Jogo
var stage_progress: StageProgress  # SPEC-163 (MEC-002): barra de progresso da fase sob o relógio
var _battle: Battle
var _confirm_callback: Callable
var _cancel_callback: Callable
var _confirm_dialog: ConfirmationDialog
var _offer_confirm: Button
var _offer_selected := -1
var _offer_buttons: Array[Button] = []
var _controller_detail_on := false
var _extract_button: Button
var _pause_speed: Button
var _pause_items: Button
var _controls_panel: PanelContainer
var _controls_close: Button
var _focus_before_modal: WeakRef
var _offer_hint: Label

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_pause_box = $PausePanel/VBox   # SPEC-165: antes de qualquer uso; a caixa vai para dentro da aba Jogo no fim do _ready
	reroll_btn.pressed.connect(func(): reroll_pressed.emit())
	%ResumeBtn.pressed.connect(func(): resume_pressed.emit())
	%QuitBtn.pressed.connect(func():
		confirm_mobile("Abandonar esta tentativa?", func(): quit_pressed.emit()))
	%AgainBtn.pressed.connect(func(): again_pressed.emit())
	%MenuBtn.pressed.connect(func(): menu_pressed.emit())
	%HelpBtn.pressed.connect(func(): help_pressed.emit())
	%SpeedBtn.pressed.connect(func(): speed_pressed.emit())
	%PauseHelpBtn.pressed.connect(func(): help_pressed.emit())
	%ReviveBtn.pressed.connect(func(): revive_pressed.emit())
	%DeclineReviveBtn.pressed.connect(func(): decline_revive_pressed.emit())
	aim_btn.pressed.connect(func(): aim_pressed.emit())
	vol_slider.value_changed.connect(func(v: float):
		Game.profile.data.settings.volume = v
		Game.apply_settings())
	# SPEC-131: painel do herói no padrão da ficha C, acima das linhas do Estige
	hero_panel = HeroPanel.new()
	hero_panel.name = "HeroPanel"
	$StatBox.add_child(hero_panel)
	$StatBox.move_child(hero_panel, 0)
	# SPEC-127: o slot com ícone e recarga fica no centro inferior
	_ability_slot = AbilitySlot.new()
	_ability_slot.name = "AbilitySlot"
	_ability_slot.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	_ability_slot.offset_left = -AbilitySlot.SIZE.x * 0.5
	_ability_slot.offset_right = AbilitySlot.SIZE.x * 0.5
	_ability_slot.offset_top = -138.0
	_ability_slot.offset_bottom = -138.0 + AbilitySlot.SIZE.y
	_ability_slot.grow_horizontal = Control.GROW_DIRECTION_BOTH
	add_child(_ability_slot)
	boss_panel.visible = false
	levelup_panel.visible = false
	pause_panel.visible = false
	result_panel.visible = false
	revive_panel.visible = false
	items_panel = CharacterSheet.new()
	items_panel.name = "ItemsPanel"
	items_panel.closed.connect(func(): items_closed.emit())
	add_child(items_panel)
	prompt_label.text = ""
	_build_top_stack()
	status_chip = StatusChip.new()
	$StatBox.add_child(status_chip)
	eco_counter = Label.new()
	eco_counter.name = "EcoCounter"
	eco_counter.visible = false
	eco_counter.mouse_filter = Control.MOUSE_FILTER_IGNORE
	eco_counter.add_theme_font_size_override("font_size", 14)
	eco_counter.add_theme_color_override("font_color", Color(0.85, 0.72, 1.0))
	eco_counter.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85))
	eco_counter.add_theme_constant_override("outline_size", 4)
	$StatBox.add_child(eco_counter)
	eco_banner = EcoBanner.new()
	eco_banner.anchor_left = 0.5
	eco_banner.anchor_right = 0.5
	eco_banner.anchor_top = 1.0
	eco_banner.anchor_bottom = 1.0
	eco_banner.offset_left = -310.0
	eco_banner.offset_right = 310.0
	eco_banner.offset_top = -210.0
	eco_banner.offset_bottom = -110.0
	eco_banner.grow_vertical = Control.GROW_DIRECTION_BEGIN
	add_child(eco_banner)
	if Game.touch_controls_enabled():
		mobile = MobileControls.new()
		mobile.name = "MobileControls"
		add_child(mobile)
		mobile.command.connect(func(action: StringName): mobile_command.emit(action))
		%HelpBtn.hide()
		%SpeedBtn.hide()
		aim_btn.hide()
		weapons_label.hide()
		prompt_label.hide()
		$StatBox.position = Game.touch_safe_rect().position
		_pause_box.get_node("PauseItemsHint").text = "Toque em Ficha durante o combate para consultar itens e habilidades."
		%ResumeBtn.text = "Continuar"
		%PauseHelpBtn.text = "Como jogar"
		_setup_mobile_offers()
		TouchUI.prepare(self)
		_place_questlog()
		get_viewport().size_changed.connect(func():
			mobile.layout_controls(Game.touch_safe_rect())
			_place_questlog())
		_confirm_dialog = ConfirmationDialog.new()
		_confirm_dialog.title = "Confirmar"
		_confirm_dialog.ok_button_text = "Confirmar"
		_confirm_dialog.cancel_button_text = "Cancelar"
		_confirm_dialog.confirmed.connect(_confirm_mobile_action)
		_confirm_dialog.canceled.connect(_cancel_mobile_action)
		add_child(_confirm_dialog)
	if _confirm_dialog == null:
		_confirm_dialog = ConfirmationDialog.new()
		_confirm_dialog.title = "Confirmar"
		_confirm_dialog.ok_button_text = "Confirmar"
		_confirm_dialog.cancel_button_text = "Cancelar"
		_confirm_dialog.confirmed.connect(_confirm_mobile_action)
		_confirm_dialog.canceled.connect(_cancel_mobile_action)
		add_child(_confirm_dialog)
	_setup_controller_pause()
	_confirm_dialog.window_input.connect(_confirmation_input)
	Game.controls.changed.connect(_update_controller_prompts)
	_update_controller_prompts()
	# SPEC-159 (MEC-061): setas na borda para os eventos de quest fora da tela; ficam sob os painéis e fogem deles
	event_pointer = EventPointer.new()
	event_pointer.name = "EventPointer"
	event_pointer.mobile = mobile
	event_pointer.avoid_nodes = [top_stack, $StatBox, timer_label, stage_label, stage_rule_icon, _ability_slot]
	add_child(event_pointer)
	move_child(event_pointer, 0)
	# SPEC-163 (MEC-002): barra fina colada à base do relógio (fica entre o relógio e o nome da fase)
	stage_progress = StageProgress.new()
	stage_progress.name = "StageProgress"
	stage_progress.set_anchors_preset(Control.PRESET_CENTER_TOP)
	stage_progress.offset_left = -90.0
	stage_progress.offset_right = 90.0
	stage_progress.offset_top = 43.0
	stage_progress.offset_bottom = 47.0
	add_child(stage_progress)
	event_pointer.avoid_nodes.append(stage_progress)
	event_pointer.avoid_nodes.append(quest_panel)   # SPEC-168: a seta de evento não cobre o questlog
	_build_pause_menu()

func _setup_controller_pause() -> void:
	var box: VBoxContainer = _pause_box
	_pause_items = Button.new()
	_pause_items.text = "Ficha do herói"
	_pause_items.pressed.connect(func(): pause_items_pressed.emit())
	box.add_child(_pause_items)
	box.move_child(_pause_items, 3)
	_pause_speed = Button.new()
	_pause_speed.pressed.connect(func(): speed_pressed.emit())
	box.add_child(_pause_speed)
	box.move_child(_pause_speed, 4)
	_extract_button = Button.new()
	_extract_button.text = "Extrair e encerrar"
	_extract_button.pressed.connect(func(): extract_pressed.emit())
	box.add_child(_extract_button)
	box.move_child(_extract_button, 5)
	var options := Button.new()
	options.text = "Controles"
	options.pressed.connect(func():
		Game.controls.transition()
		_focus_before_modal = weakref(get_viewport().gui_get_focus_owner()) if get_viewport().gui_get_focus_owner() != null else null
		_controls_panel.show()
		_controls_close.call_deferred("grab_focus"))
	box.add_child(options)
	box.move_child(options, 6)
	_controls_panel = PanelContainer.new()
	var controls_style := StyleBoxFlat.new()
	controls_style.bg_color = Color(0.045, 0.04, 0.065, 0.99)
	controls_style.border_color = Color(0.62, 0.5, 0.28)
	controls_style.set_border_width_all(2)
	controls_style.set_content_margin_all(14)
	_controls_panel.add_theme_stylebox_override("panel", controls_style)
	_controls_panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	_controls_panel.offset_left = -290
	_controls_panel.offset_right = 290
	_controls_panel.offset_top = -310
	_controls_panel.offset_bottom = 310
	var content := VBoxContainer.new()
	_controls_panel.add_child(content)
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(560, 510)
	scroll.follow_focus = true
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	content.add_child(scroll)
	var preferences := preload("res://ui/controller_options.gd").new()
	preferences.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(preferences)
	_controls_close = Button.new()
	_controls_close.text = "Fechar controles"
	_controls_close.pressed.connect(_close_controls)
	content.add_child(_controls_close)
	add_child(_controls_panel)
	_controls_panel.hide()

func _close_controls() -> void:
	Game.controls.cancel_capture()
	Game.controls.transition()
	_controls_panel.hide()
	_restore_modal_focus()

func _restore_modal_focus() -> void:
	if _focus_before_modal != null:
		var owner = _focus_before_modal.get_ref()
		if is_instance_valid(owner) and owner.is_visible_in_tree():
			owner.grab_focus()

## SPEC-147 (IN-064): estado do Estige para o StatusChip; {} quando não há nada a mostrar.
static func styx_status(b: Battle) -> Dictionary:
	var h := b.hero
	if b.has_styx_contract() and b.styx_exposure > 0.0:
		return {"kind": "water", "title": "RIO ESTIGE", "text": "%.1f s na água · INT efetiva %d" % [b.styx_exposure, h.styx_intelligence()],
			"tip": "Rio Estige: a cada segundo na água há um teste de lucidez; cada falha tira 1 de INT por alguns minutos. Ao sair depois de 2 s ou mais, o Esquecimento impede de voltar à água por um tempo."}
	if h.styx_forget_t > 0.0:
		return {"kind": "forget", "title": "ESQUECIMENTO", "text": "%.1f s sem poder voltar à água" % h.styx_forget_t,
			"tip": "Esquecimento do Estige: você não consegue se aproximar do rio enquanto durar."}
	return {}

## SPEC-147 (IN-069, IN-072): barra do chefe, linhas de status e avisos numa pilha só (as quests moraram aqui até a SPEC-168); o container empilha,
## então nenhum desses blocos cobre outro, qualquer que seja o número de linhas.
func _build_top_stack() -> void:
	top_stack = VBoxContainer.new()
	top_stack.name = "TopStack"
	top_stack.set_anchors_preset(Control.PRESET_CENTER_TOP)
	top_stack.offset_left = -STACK_WIDTH * 0.5
	top_stack.offset_right = STACK_WIDTH * 0.5
	top_stack.offset_top = STACK_TOP
	top_stack.grow_horizontal = Control.GROW_DIRECTION_BOTH
	top_stack.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_stack.add_theme_constant_override("separation", 6)
	add_child(top_stack)
	boss_panel.reparent(top_stack, false)
	boss_panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	# SPEC-168: o questlog mora no canto direito, fora da pilha do topo, abaixo dos botões 1x e ?
	quest_panel = QuestPanel.new()
	quest_panel.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	quest_panel.offset_left = -(QuestPanel.LOG_WIDTH + QUESTLOG_MARGIN)
	quest_panel.offset_right = -QUESTLOG_MARGIN
	quest_panel.offset_top = QUESTLOG_TOP
	quest_panel.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	quest_panel.grow_vertical = Control.GROW_DIRECTION_END
	add_child(quest_panel)
	objective_label = Label.new()
	objective_label.name = "ObjectiveLabel"
	objective_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	objective_label.add_theme_font_size_override("font_size", 15)
	objective_label.add_theme_color_override("font_color", Color(0.98, 0.86, 0.55))
	objective_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85))
	objective_label.add_theme_constant_override("outline_size", 5)
	objective_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	objective_label.visible = false
	top_stack.add_child(objective_label)
	toast_box.reparent(top_stack, false)
	toast_box.size_flags_horizontal = Control.SIZE_SHRINK_CENTER   # SPEC-167: só a largura do aviso, livre da ficha
	toast_box.custom_minimum_size.x = TOAST_WIDTH
	# a pilha fica na ordem de desenho que o ToastBox tinha: abaixo da ficha C, das ofertas e das pausas
	move_child(top_stack, prompt_label.get_index())
	move_child(quest_panel, prompt_label.get_index())

## SPEC-168: no celular os botões de topo (Pausa, Ficha, Ajuda, 1x) ocupam o canto; o questlog desce para baixo deles.
func _place_questlog() -> void:
	var top := QUESTLOG_TOP
	if mobile != null and is_instance_valid(mobile) and mobile.regions.has(Game.ACTION_RUN_PAUSE):
		top = maxf(top, (mobile.regions[Game.ACTION_RUN_PAUSE] as Rect2).end.y + 8.0)
	quest_panel.offset_top = top

func has_modal() -> bool:
	return _confirm_dialog.visible or _controls_panel.visible or items_panel.visible or pause_panel.visible or Playtest.is_overlay_open()

func _confirmation_input(event: InputEvent) -> void:
	if not Game.controls.accepts(event):
		_confirm_dialog.set_input_as_handled()
		Game.controls._input(event)
		return
	if event is InputEventJoypadButton and event.pressed and event.is_action_pressed("ui_cancel") and Game.controls.accepts(event):
		_confirm_dialog.set_input_as_handled()
		_confirm_dialog.hide()
		_cancel_mobile_action()

func _update_controller_prompts() -> void:
	for entry in [[reroll_btn, "run_reroll", "Rerrolar"], [%ResumeBtn, "run_pause", "Continuar"], [_pause_items, "run_items", "Ficha"], [aim_btn, "run_toggle_aim", "Alternar mira"]]:
		var button: Button = entry[0]
		button.icon = Game.controls.glyph(entry[1])
		button.expand_icon = true
		button.add_theme_constant_override("icon_max_width", 28)
	_pause_box.get_node("PauseItemsHint").text = "Ficha: %s · Detalhes: %s · Abas: %s / %s" % [Game.controls.prompt("run_items", "C"), Game.controls.prompt("offer_details", "Shift"), Game.controls.prompt("tab_previous", "Q"), Game.controls.prompt("tab_next", "E")]
	%ResumeBtn.text = "Continuar (%s)" % Game.controls.prompt("run_pause", "Esc") if mobile == null else "Continuar"
	if is_instance_valid(_offer_hint):
		_offer_hint.text = "%s Confirmar · %s Detalhes · %s Ficha" % [Game.controls.prompt("ui_accept", "Enter"), Game.controls.prompt("offer_details", "Shift"), Game.controls.prompt("run_items", "C")] if Game.controls.is_controller() else "W/S ou setas escolhem, Enter confirma, 1 a 9 escolhem direto. Passe o mouse ou segure Shift para ver detalhes e comparação."
	if _battle != null and levelup_panel.visible and mobile == null:
		reroll_btn.text = "Rerrolar (%s) — %d restantes" % [Game.controls.prompt("run_reroll", "R"), _battle.rerolls]

func confirm_mobile(text: String, callback: Callable, on_cancel: Callable = Callable()) -> void:
	Game.controls.transition()
	var focused := get_viewport().gui_get_focus_owner()
	_focus_before_modal = weakref(focused) if focused != null else null
	_confirm_callback = callback
	_cancel_callback = on_cancel
	clear_mobile_input()
	_confirm_dialog.dialog_text = text
	_confirm_dialog.popup_centered(Vector2i(440, 180))
	_confirm_dialog.get_cancel_button().call_deferred("grab_focus")

func _confirm_mobile_action() -> void:
	Game.controls.transition()
	var callback := _confirm_callback
	_confirm_callback = Callable()
	_cancel_callback = Callable()
	if callback.is_valid():
		callback.call()

func _cancel_mobile_action() -> void:
	Game.controls.transition()
	var callback := _cancel_callback
	_confirm_callback = Callable()
	_cancel_callback = Callable()
	if callback.is_valid():
		callback.call()
	_restore_modal_focus()

## SPEC-072 / BUG-007: o cursor está sobre algum controle da HUD (botão, painel); clicar ali não faz o herói andar.
func pointer_over_ui() -> bool:
	return get_viewport().gui_get_hovered_control() != null

func clear_mobile_input() -> void:
	if mobile != null:
		mobile.set_combat_enabled(false)

func _setup_mobile_offers() -> void:
	var parent := offer_box.get_parent()
	parent.remove_child(offer_box)
	var scroll := ScrollContainer.new()
	scroll.name = "TouchOfferScroll"
	scroll.custom_minimum_size = Vector2(720, 320)
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	parent.add_child(scroll)
	parent.move_child(scroll, 1)
	scroll.add_child(offer_box)
	offer_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_offer_confirm = Button.new()
	_offer_confirm.text = "Confirmar escolha"
	_offer_confirm.disabled = true
	_offer_confirm.custom_minimum_size.y = 56
	_offer_confirm.pressed.connect(_confirm_offer)
	parent.add_child(_offer_confirm)
	parent.move_child(_offer_confirm, 2)
	levelup_panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	levelup_panel.offset_left = -380
	levelup_panel.offset_right = 380
	levelup_panel.offset_top = -280
	levelup_panel.offset_bottom = 280

func _select_offer(index: int) -> void:
	_offer_selected = index
	_offer_confirm.disabled = false
	for i in _offer_buttons.size():
		_offer_buttons[i].modulate = Color(1.0, 0.87, 0.55) if i == index else Color.WHITE
	for detail in _detail_nodes:
		detail.visible = int(detail.get_meta("offer_index", -1)) == index

func _confirm_offer() -> void:
	if _offer_selected < 0 or _offer_confirm.disabled:
		return
	var index := _offer_selected
	_offer_selected = -1
	_offer_confirm.disabled = true
	offer_chosen.emit(index)

func _unhandled_input(ev: InputEvent) -> void:
	if not Game.controls.accepts(ev):
		return
	if not ev.is_pressed() or (ev is InputEventKey and ev.echo):
		return
	if _confirm_dialog.visible:
		return
	if _controls_panel.visible:
		if ev.is_action_pressed("ui_cancel") or ev.is_action_pressed(Game.ACTION_RUN_PAUSE):
			_close_controls()
			get_viewport().set_input_as_handled()
		return
	if Playtest.is_overlay_open():
		return  # SPEC-147: nota (F5), guia (F1) e Central (F4) prendem o foco; a HUD não reage a nada
	if items_panel.visible:
		# SPEC-147 (BUG-003): C fecha a ficha, como o botão "Fechar (C)" promete; Esc fecha pelo `_input` da própria ficha.
		if ev.is_action_pressed(Game.ACTION_RUN_ITEMS) or ev.is_action_pressed(&"ui_cancel"):
			items_closed.emit()
			get_viewport().set_input_as_handled()
		return
	if levelup_panel.visible and not pause_panel.visible and ev.is_action_pressed(Game.ACTION_RUN_ITEMS):
		pause_items_pressed.emit()
		get_viewport().set_input_as_handled()
		return
	if levelup_panel.visible and ev is InputEventJoypadButton and ev.is_action_pressed(Game.ACTION_OFFER_DETAILS):
		_controller_detail_on = not _controller_detail_on
		get_viewport().set_input_as_handled()
		return
	if (ev.is_action_pressed(Game.ACTION_RUN_PAUSE) or ev.is_action_pressed(&"ui_cancel")) and pause_panel.visible:
		resume_pressed.emit()
		get_viewport().set_input_as_handled()

## MEC-027: segurar Shift abre o detalhe de todas as opções, para quem joga sem mouse.
var _detail_nodes: Array = []
var _detail_on := false

func _process(_delta: float) -> void:
	if event_pointer != null:
		event_pointer.battle = _battle
		event_pointer.visible = _battle != null and _battle.state == "running" and not (items_panel.visible or levelup_panel.visible or pause_panel.visible or result_panel.visible or revive_panel.visible)
	if stage_progress != null:   # SPEC-163: some junto do relógio (mesmos casos do EventPointer)
		stage_progress.battle = _battle
		stage_progress.visible = _battle != null and _battle.state == "running" and not (items_panel.visible or levelup_panel.visible or pause_panel.visible or result_panel.visible or revive_panel.visible)
	if mobile != null:
		var running := _battle != null and _battle.state == "running" and not get_tree().paused
		mobile.set_combat_enabled(running and not (Playtest.is_overlay_open() or items_panel.visible or levelup_panel.visible or pause_panel.visible or result_panel.visible or revive_panel.visible or _confirm_dialog.visible))
	if _ability_slot != null:
		_ability_slot.visible = mobile == null and not (items_panel.visible or levelup_panel.visible or pause_panel.visible or result_panel.visible or revive_panel.visible)
	if not levelup_panel.visible or _detail_nodes.is_empty():
		return
	if mobile != null:
		return
	var on := _controller_detail_on if Game.controls.is_controller() else Input.is_action_pressed(Game.ACTION_OFFER_DETAILS)
	if on != _detail_on:
		_detail_on = on
		for n in _detail_nodes:
			n.visible = on

func update_stats(b: Battle) -> void:
	_battle = b
	var h := b.hero
	hero_panel.update(b)
	status_chip.show_status(styx_status(b))
	var ability: Dictionary = Data.table("abilities").get(h.id, {})
	var ability_id := String(ability.get("id", ""))
	if ability_id != _active_icon_id:
		_active_icon_id = ability_id
		var ability_path := "res://assets/icons/abilities/%s.png" % ability_id
		_ability_slot.set_ability(String(ability.get("name", "")), String(ability.get("desc", "")),
			load(ability_path) if ResourceLoader.exists(ability_path) else null, "Q/RMB")
	_ability_slot.set_state(b.active_cd, b.active_cd_max, b.active_guard > 0, get_process_delta_time())
	_ability_slot._key_text = Game.controls.prompt("hero_active", "Q/RMB")
	_ability_slot.key_icon = Game.controls.glyph("hero_active")
	_pause_speed.visible = b.can_speed_2x()
	_pause_speed.text = "Velocidade: %s" % b.speed_label()
	_extract_button.visible = b.stage_cleared or b.final_victory
	if mobile != null:
		mobile.configure(b)
		mobile.ability_slot.set_ability(String(ability.get("name", "")), String(ability.get("desc", "")), _ability_slot._icon, "Habilidade")
		mobile.ability_slot.set_state(b.active_cd, b.active_cd_max, b.active_guard > 0, get_process_delta_time())
	var stage_icons := {
		"dagruve": "dagruve_rituals", "shedaklah": "shedaklah_puddles", "molor": "molor_bubbles",
		"durao": "", "feng_tu": "feng_tu_strikes", "shendilavri": "shendilavri_illusions",
		"goranthis": "goranthis_sanctuary", "pilares": "pilares_rotation"
	}
	var stage_icon_id := String(stage_icons.get(b.stage_id, ""))
	if stage_icon_id != _stage_icon_id:
		_stage_icon_id = stage_icon_id
		var stage_icon_path := "res://assets/icons/stages/%s.png" % stage_icon_id
		stage_rule_icon.texture = load(stage_icon_path) if ResourceLoader.exists(stage_icon_path) else null
	var t := int(b.time)
	var dur := int(b.stage.duration)
	if b.boss_spawned and not b.boss_dead:
		timer_label.text = "CHEFE"
	else:
		timer_label.text = "%02d:%02d" % [t / 60, t % 60]
	stage_label.text = "%s%s%s" % [b.stage.name, "  (Mira: %s)" % ("AUTO" if b.aim == Battle.Aim.AUTO else "MOUSE"), "  [%s]" % b.speed_label() if b.speed_scale() > 1.0 else ""]
	# SPEC-164: o eclipse ativo aparece ao lado do nome da fase, com o tempo que falta
	if not b.world_mod.is_empty():
		stage_label.text += "   ◐ %s %d s" % [String(b.world_mod.name), int(ceil(float(b.world_mod.t)))]
		stage_label.add_theme_color_override("font_color", Color(0.95, 0.4, 0.4) if String(b.world_mod.id) == "rubro" else Color(0.75, 0.85, 1.0))
	else:
		stage_label.add_theme_color_override("font_color", Color(0.75, 0.7, 0.6, 1))
	%SpeedBtn.visible = b.can_speed_2x()
	if mobile != null:
		%SpeedBtn.hide()
	%SpeedBtn.set_pressed_no_signal(b.speed_scale() > 1.0)
	%SpeedBtn.text = b.speed_label() if b.can_speed_2x() else "1x"
	if b.boss != null and not b.boss.dead and b.boss_spawned:
		boss_panel.visible = true
		boss_name.text = b.boss.name
		boss_bar.max_value = b.boss.max_hp
		boss_bar.value = maxf(0.0, b.boss.hp)
	else:
		boss_panel.visible = false
	var lines: Array = []
	for w in h.weapons:
		lines.append("⚔ %s%s" % [w.display_name(), " (item)" if w.granted else ""])
	var pl: Array = []
	for pid in h.passives:
		pl.append("%s %d" % [Data.table("passives")[pid].name, h.passives[pid]])
	if not pl.is_empty():
		lines.append("✦ " + ", ".join(pl))
	for slot in h.items:
		var it: Dictionary = h.items[slot]
		lines.append("◆ %s" % it.name)
	for bn in h.boons:
		lines.append("☼ %s" % bn.name)
	weapons_label.text = "\n".join(lines)
	var pr := ""
	for it in b.interactions:
		if not it.used and (it.kind in ["altar", "ritual", "portal", "loja", "ferreiro", "arcanista", "curandeiro", "ampulheta", "doacao", "aposta", "event_pact", "camara"] or RandomEvents.is_kind(String(it.kind))) and it.pos.distance_to(h.pos) <= 1.6:
			pr = "[%s] " % Game.controls.prompt("run_interact", "E") + {"altar": "rezar no altar", "ritual": "iniciar o ritual", "portal": "descer pelo portal",
				"loja": "negociar na loja", "ferreiro": "forjar no ferreiro", "arcanista": "estudar com o arcanista", "camara": "abrir a câmara selada", "curandeiro": "buscar cura", "ampulheta": "girar a ampulheta (+60 s, inimigos acumulados)", "doacao": "doar um item por uma bênção", "aposta": "arriscar moedas na mesa",
				"event_pact": "%s" % String(it.get("label", "pacto")).replace(" [E/oeste]", "")}[it.kind]
	if pr == "" and (b.stage_cleared or b.final_victory):
		pr = "[%s] Pausa → Extrair ×%.2f" % [Game.controls.prompt("run_pause", "Esc"), b.reward_multiplier()]
		if b.stage.get("next", "") != "":
			pr += "   [%s] Descer ×%.2f" % [Game.controls.prompt("run_interact", "E"), b.next_reward_multiplier()]
	prompt_label.text = pr
	quest_panel.update_entries(b.happenings.hud_entries(b), b.happenings.carrying_text())
	var eco_progress := b.ecos_progress()
	eco_counter.visible = eco_progress.x > 0
	eco_counter.text = "✦ Ecos %d/%d" % [eco_progress.x, eco_progress.y]
	var status_lines: Array = b.kinds.hud_lines(b) + Favor.hud_lines(h.boons)
	if status_lines.size() > STATUS_MAX_LINES:
		status_lines = status_lines.slice(0, STATUS_MAX_LINES - 1) + ["+%d efeitos" % (status_lines.size() - STATUS_MAX_LINES + 1)]
	objective_label.text = "
".join(status_lines)
	objective_label.visible = objective_label.text != ""

func show_offer(b: Battle) -> void:
	Game.controls.transition()
	_controller_detail_on = false
	clear_mobile_input()
	_offer_selected = -1
	_offer_buttons.clear()
	if _offer_confirm != null:
		_offer_confirm.disabled = true
	for c in offer_box.get_children():
		offer_box.remove_child(c)
		c.queue_free()
	_detail_nodes.clear()
	_detail_on = false
	_offer_hint = null
	var shop_titles := {"shop_loja": "Loja — compre ou saia", "shop_ferreiro": "Ferreiro — forje uma arma ou equipamento", "shop_arcanista": "Arcanista — aprimore uma magia", "shop_curandeiro": "Curandeiro — cure suas feridas", "shop_doacao": "Altar da Doação — troque um item por uma bênção", "shop_aposta": "Mesa de Aposta — arrisque suas moedas"}
	if b.offer_kind == "levelup":
		lv_title.text = "Nível %d — escolha (1-%d)" % [b.hero.level, b.offer.size()]
	elif b.offer_kind == "item":
		lv_title.text = "Item encontrado no baú — equipar" if b.offer.size() == 1 else "Item encontrado — equipar ou manter?"
	elif b.offer_kind == "pact":
		lv_title.text = "%s — escolha ou recuse" % b.pact_title
	elif b.offer_kind.begins_with("shop_") and RandomEvents.is_kind(b.offer_kind.substr(5)):   # SPEC-164
		lv_title.text = RandomEvents.title(b.offer_kind.substr(5))
	elif shop_titles.has(b.offer_kind):
		lv_title.text = String(shop_titles[b.offer_kind])
	else:
		lv_title.text = "Altar — escolha uma bênção (e sua maldição) ou recuse"
	for i in b.offer.size():
		var o: Dictionary = b.offer[i]
		var is_card := o.has("brief")
		var btn: Button = OfferCard.new() if is_card else Button.new()
		var role_names := {"synergy": "SINERGIA", "defense": "DEFESA", "direction": "NOVA DIREÇÃO"}
		var role := String(role_names.get(o.get("role", ""), ""))
		if not is_card:
			btn.text = "%d.  %s%s\n      %s" % [i + 1, "[%s] " % role if role != "" else "", o.name, o.desc]
			btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
			btn.custom_minimum_size = Vector2(620, 62)
		var icon_path := offer_icon_path(o)
		var icon_tex: Texture2D = load(icon_path) if ResourceLoader.exists(icon_path) else null
		if icon_tex != null and not is_card:
			btn.icon = icon_tex
			btn.expand_icon = true
			btn.icon_alignment = HORIZONTAL_ALIGNMENT_LEFT
		match String(o.t):
			"evolve": btn.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))
			"weapon_new": btn.add_theme_color_override("font_color", Color(0.6, 1.0, 0.6))
			"boon": btn.add_theme_color_override("font_color", Color(0.85, 0.6, 1.0))
			"item_swap":
				# ART-016: a cor é a raridade do item da opção, não "o novo está verde" (empurrava trocar raro por comum)
				btn.add_theme_color_override("font_color", Items.rarity_color(String(o.keep.get("rarity", "comum"))))
			"shop_item": btn.add_theme_color_override("font_color", Items.rarity_color(String(o.item.get("rarity", "comum"))))
			"shop_item_up": btn.add_theme_color_override("font_color", Items.rarity_color(String(o.get("rarity", "comum"))))
			"shop_weapon_up", "shop_heal": btn.add_theme_color_override("font_color", Color(1.0, 0.9, 0.5))
			"shop_leave", "boon_skip": btn.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
		if is_card:
			(btn as OfferCard).setup(i, o, btn.get_theme_color("font_color"), icon_tex)
		else:
			var tip := String(o.get("tooltip", ""))
			if tip != "":
				btn.tooltip_text = tip
		if bool(o.get("locked", false)):
			# MEC-023: sem moedas (ou linha informativa): visível, esmaecida e sem efeito
			btn.disabled = true
			btn.modulate = Color(1, 1, 1, 0.9)
		if mobile != null:
			btn.pressed.connect(_select_offer.bind(i))
			_offer_buttons.append(btn)
		else:
			btn.pressed.connect(func(): offer_chosen.emit(i))
		offer_box.add_child(btn)
		if i == 0:
			btn.grab_focus()
		if is_card:
			var detail := (btn as OfferCard).build_detail(true)
			if detail != null:
				var wrap := MarginContainer.new()
				wrap.add_theme_constant_override("margin_left", 56)
				wrap.add_theme_constant_override("margin_bottom", 6)
				wrap.add_child(detail)
				wrap.visible = false
				wrap.set_meta("offer_index", i)
				offer_box.add_child(wrap)
				_detail_nodes.append(wrap)
	if b.offer.any(func(o): return o.has("brief")):
		var hint := Label.new()
		hint.text = "Toque em uma opção para ver os detalhes; depois confirme." if mobile != null else ""
		_offer_hint = hint
		hint.add_theme_font_size_override("font_size", 14)
		hint.add_theme_color_override("font_color", Color(0.72, 0.72, 0.72))
		hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		offer_box.add_child(hint)
	reroll_btn.visible = b.offer_kind == "levelup"
	reroll_btn.text = "Rerrolar (%s) — %d restantes" % [Game.controls.prompt("run_reroll", "R"), b.rerolls]
	if mobile != null:
		reroll_btn.text = "Rerrolar — %d restantes" % b.rerolls
		lv_title.text = lv_title.text.get_slice(" — escolha (", 0)
	reroll_btn.disabled = b.rerolls <= 0
	if mobile != null:
		TouchUI.adapt_sizes(offer_box)
	levelup_panel.visible = true
	_update_controller_prompts()
	if mobile == null:
		if b.offer_kind == "levelup" and Game.controls.is_controller():
			lv_title.text = "Nível %d — escolha" % b.hero.level
		for choice in offer_box.get_children():
			if choice is Button and not choice.disabled:
				choice.call_deferred("grab_focus")
				break

func hide_offer() -> void:
	levelup_panel.visible = false

# ------------------------------------------------------------------ MEC-009: mini-cinemática de evolução

var _evo_root: Control = null
var _evo_key := ""

func show_evolution(b: Battle) -> void:
	var cine: Dictionary = b.evolve_cine
	if cine.is_empty():
		hide_evolution()
		return
	var key := "%s>%s" % [String(cine.from), String(cine.into)]
	if _evo_root != null and _evo_key == key:
		return
	hide_evolution()
	_evo_key = key
	var wdata: Dictionary = Data.table("weapons")
	var from_w: Dictionary = wdata.get(String(cine.from), {})
	var into_w: Dictionary = wdata.get(String(cine.into), {})
	var passive_name := String(Data.table("passives").get(String(cine.passive), {}).get("name", String(cine.passive)))
	var root := ColorRect.new()
	root.color = Color(0, 0, 0, 0.74)
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(root)
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_child(center)
	var col := VBoxContainer.new()
	col.alignment = BoxContainer.ALIGNMENT_CENTER
	col.add_theme_constant_override("separation", 14)
	col.z_index = 2
	var panel_path := "res://assets/ui/evolucao_painel_moldura.png"
	if ResourceLoader.exists(panel_path):
		var panel := PanelContainer.new()
		panel.custom_minimum_size = Vector2(800, 520)
		var style := StyleBoxTexture.new()
		style.texture = load(panel_path)
		for edge in [SIDE_LEFT, SIDE_RIGHT, SIDE_TOP, SIDE_BOTTOM]:
			style.set_texture_margin(edge, 70)
			style.set_content_margin(edge, 90 if edge == SIDE_BOTTOM else 70)
		panel.add_theme_stylebox_override("panel", style)
		center.add_child(panel)
		panel.add_child(col)
	else:
		center.add_child(col)
	var flare_path := "res://assets/vfx/vfx_evolucao_flare.png"
	if ResourceLoader.exists(flare_path) and not Game.reduced_impact():
		var flare := TextureRect.new()
		var atlas := AtlasTexture.new()
		atlas.atlas = load(flare_path)
		atlas.region = Rect2(0, 0, 256, 256)
		flare.texture = atlas
		flare.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		flare.set_anchors_preset(Control.PRESET_CENTER)
		flare.offset_left = -240
		flare.offset_right = 240
		flare.offset_top = -240
		flare.offset_bottom = 240
		flare.mouse_filter = Control.MOUSE_FILTER_IGNORE
		flare.modulate.a = 0.5
		flare.z_index = 1
		root.add_child(flare)
		var flash := root.create_tween()
		for frame in 4:
			flash.tween_callback(func(): atlas.region = Rect2((frame % 2) * 256, (frame / 2) * 256, 256, 256))
			flash.tween_interval(0.12)
		flash.tween_callback(flare.queue_free)
	var title := Label.new()
	title.text = "★  EVOLUÇÃO  ★"
	title.add_theme_font_size_override("font_size", 38)
	title.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	col.add_child(title)
	var icons := HBoxContainer.new()
	icons.alignment = BoxContainer.ALIGNMENT_CENTER
	icons.add_theme_constant_override("separation", 26)
	col.add_child(icons)
	for pair in [[String(cine.from), 96.0], ["", 0.0], [String(cine.into), 132.0]]:
		if String(pair[0]) == "":
			var arrow := Label.new()
			arrow.text = "→"
			arrow.add_theme_font_size_override("font_size", 54)
			arrow.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))
			icons.add_child(arrow)
			continue
		var icon := TextureRect.new()
		var path := Items.weapon_icon(String(pair[0]))
		icon.texture = load(path) if ResourceLoader.exists(path) else null
		icon.custom_minimum_size = Vector2(float(pair[1]), float(pair[1]))
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icons.add_child(icon)
	var names := Label.new()
	names.text = "%s  →  %s" % [String(from_w.get("name", cine.from)), String(into_w.get("name", cine.into))]
	names.add_theme_font_size_override("font_size", 24)
	names.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	col.add_child(names)
	var cond := Label.new()
	cond.text = "Condições cumpridas: nível %d (máximo) + passiva %s" % [int(cine.level), passive_name]
	cond.add_theme_color_override("font_color", Color(0.62, 0.71, 0.85))
	cond.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	col.add_child(cond)
	var desc := Label.new()
	desc.text = String(into_w.get("desc", ""))
	desc.custom_minimum_size = Vector2(560, 0)
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	col.add_child(desc)
	var hint := Label.new()
	hint.text = "clique ou tecle para continuar"
	hint.add_theme_color_override("font_color", Color(0.55, 0.55, 0.55))
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	col.add_child(hint)
	_evo_root = root
	root.modulate.a = 0.0
	col.pivot_offset = col.size * 0.5
	col.scale = Vector2(0.85, 0.85)
	var tw := root.create_tween().set_parallel(true)
	tw.tween_property(root, "modulate:a", 1.0, 0.35)
	tw.tween_property(col, "scale", Vector2.ONE, 0.45).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func hide_evolution() -> void:
	if _evo_root != null:
		_evo_root.queue_free()
		_evo_root = null
	_evo_key = ""

## MEC-001 (SPEC-156): W e A voltam uma opção, S e D avançam (as setas já movem o foco pelo próprio Godot); outras teclas não mexem.
static func offer_key_step(physical_keycode: int) -> int:
	match physical_keycode:
		KEY_W, KEY_A: return -1
		KEY_S, KEY_D: return 1
	return 0

## Move o foco para a opção anterior (-1) ou seguinte (+1) da oferta aberta, dando a volta e pulando as travadas
## (sem moeda). Devolve false se não houver opção que aceite foco. Enter ou Espaço confirmam o botão focado.
func offer_focus_step(step: int) -> bool:
	var options: Array = []
	for c in offer_box.get_children():
		if c is Button and not (c as Button).disabled and (c as Button).focus_mode != Control.FOCUS_NONE and (c as Button).is_visible_in_tree():
			options.append(c)
	if options.is_empty():
		return false
	var current := options.find(get_viewport().gui_get_focus_owner())
	var next := 0 if current < 0 and step > 0 else (options.size() - 1 if current < 0 else posmod(current + step, options.size()))
	(options[next] as Button).grab_focus()
	return true

## Caminho do ícone de uma opção de oferta ("" = sem ícone). MEC-050: a linha "Doar" do Altar da Doação usa o ícone do item doado.
static func offer_icon_path(o: Dictionary) -> String:
	match String(o.t):
		"item_swap": return Items.item_icon(String(o.keep.get("base", o.keep.get("id", ""))))
		"weapon_new", "weapon_up": return Items.weapon_icon(String(o.id))
		"evolve": return Items.weapon_icon(String(o.into))
		"passive": return "res://assets/icons/passives/%s.png" % String(o.id)
		"boon": return BoonKinds.icon_path_for_id(String(o.id))
		"heal", "shop_heal": return "res://assets/pickups/health_potion.png"
		"gold": return "res://assets/pickups/gold_coin.png"
		"shop_item": return Items.item_icon(String(o.item.get("base", o.item.get("id", ""))))
		"shop_weapon_up": return Items.weapon_icon(String(o.weapon_id))
		"shop_item_up": return "res://assets/icons/items/%s.png" % String(o.base)
		"donate": return Items.item_icon(String(o.get("base", "")))
	return ""

## SPEC-152: Eco de Nottgard recolhido (faixa de `faixa_segundos`, sem pausar).
func show_eco(text: String, source: String, known: bool) -> void:
	eco_banner.show_eco(text, source, known, float(Data.table("secrets").get("_regras", {}).get("faixa_segundos", 6.0)))

## SPEC-167 (BUG-042): avisos do topo. No máximo `TOAST_MAX_COUNT` vivos e `TOAST_MAX_HEIGHT` px de altura (o mais antigo sai na
## hora, sem esperar o `queue_free`), na largura `TOAST_WIDTH` que deixa a ficha livre; avisos longos (epígrafe, rumor) entram um por vez.
func toast(text: String, color: Color = Color(1, 1, 1)) -> void:
	if text.length() > TOAST_LONG_CHARS and is_instance_valid(_long_toast):
		_long_toast_queue.append([text, color])
		return
	_show_toast(text, color)

func _show_toast(text: String, color: Color) -> void:
	var l := Label.new()
	l.text = text
	l.modulate = color
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.add_theme_color_override("font_outline_color", Color(0, 0, 0))
	l.add_theme_constant_override("outline_size", 5)
	var long := text.length() > TOAST_LONG_CHARS
	if long:
		# epígrafes de fase (SPEC-117) são longas: quebram na largura do aviso e ficam mais tempo na tela
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_long_toast = l
	l.custom_minimum_size.x = TOAST_WIDTH
	l.set_meta("toast_h", _toast_height(l, text))
	toast_box.add_child(l)
	_trim_toasts()
	var tw := l.create_tween()
	tw.tween_interval(3.0 + maxf(0.0, float(text.length() - TOAST_LONG_CHARS)) * 0.04)
	tw.tween_property(l, "modulate:a", 0.0, 0.6)
	tw.tween_callback(_drop_toast.bind(l))

## Altura estimada do aviso na largura do bloco (o layout só mede no quadro seguinte).
func _toast_height(l: Label, text: String) -> float:
	var font := l.get_theme_font("font")
	var font_size := l.get_theme_font_size("font_size")
	return font.get_multiline_string_size(text, HORIZONTAL_ALIGNMENT_CENTER, TOAST_WIDTH, font_size,
			-1, TextServer.BREAK_WORD_BOUND | TextServer.BREAK_MANDATORY).y

func _live_toasts() -> Array:
	var live: Array = []
	for c in toast_box.get_children():
		if not c.is_queued_for_deletion():
			live.append(c)
	return live

func _trim_toasts() -> void:
	var live := _live_toasts()
	var gap := float(toast_box.get_theme_constant("separation"))
	while live.size() > 1:
		var height := 0.0
		for c in live:
			height += float(c.get_meta("toast_h", 20.0)) + gap
		if live.size() <= TOAST_MAX_COUNT and height - gap <= TOAST_MAX_HEIGHT:
			break
		_drop_toast(live.pop_front())

func _drop_toast(l: Variant) -> void:
	if not is_instance_valid(l) or l.is_queued_for_deletion():
		return
	toast_box.remove_child(l)
	l.queue_free()
	if l == _long_toast:
		_long_toast = null
		if not _long_toast_queue.is_empty():
			var next: Array = _long_toast_queue.pop_front()
			_show_toast(String(next[0]), next[1])

## Retângulo na tela ocupado pelos avisos vivos (vazio quando não há aviso); a fala do herói o consulta.
func toast_rect() -> Rect2:
	if _live_toasts().is_empty():
		return Rect2()
	return toast_box.get_global_rect()

func show_items_panel(b: Battle) -> void:
	hero_panel.note_sheet_opened()
	var was_open := items_panel.visible
	items_panel.show_sheet(b)
	if not was_open:
		UiKit.fade_in(items_panel)

func hide_items_panel() -> void:
	if items_panel.visible:
		UiKit.dissolve_from_screen(get_tree())   # antes de esconder: a foto leva a ficha
	items_panel.hide_sheet()

func show_pause(v: bool) -> void:
	Game.controls.transition()
	clear_mobile_input()
	var was_open := pause_panel.visible
	if was_open and not v:
		UiKit.dissolve_from_screen(get_tree())
	pause_panel.visible = v
	if v and not was_open:
		UiKit.fade_in(pause_panel)
	if v:
		pause_menu.show_menu(_battle)   # SPEC-165: volta à aba Jogo e marca o que apareceu nesta run
		aim_btn.text = "Mira: %s (%s)" % ["AUTO" if Game.aim_mode() == Battle.Aim.AUTO else "MANUAL", Game.controls.prompt("run_toggle_aim", "Tab")]
		vol_slider.value = float(Game.profile.data.settings.volume)
		_focus_visible.call_deferred(%ResumeBtn)

func show_revive_offer(b: Battle) -> void:
	Game.controls.transition()
	hide_offer()
	pause_panel.visible = false
	result_panel.visible = false
	var preview := b.result()
	preview.reward_rate = 0.3
	var pending := Game.profile.preview_earned(preview)
	revive_text.text = "Seu herói caiu. Deseja reviver com 50%% de PV?\n\nSe encerrar agora, receberá +%d moedas (30%% da tentativa)." % pending
	var revive_was_open := revive_panel.visible
	revive_panel.visible = true
	if not revive_was_open:
		UiKit.fade_in(revive_panel)
	%ReviveBtn.grab_focus()

func hide_revive_offer() -> void:
	if revive_panel.visible:
		UiKit.dissolve_from_screen(get_tree())
	revive_panel.visible = false

func show_result(res: Dictionary, summary: Dictionary) -> void:
	Game.controls.transition()
	hide_offer()
	pause_panel.visible = false
	hide_revive_offer()
	result_title.text = "Vitória!" if res.won else "Você caiu..."
	var background_path := "res://assets/ui/backgrounds/victory_background.png" if res.won else "res://assets/ui/backgrounds/defeat_background.png"
	result_background.texture = load(background_path) if ResourceLoader.exists(background_path) else null
	var t := int(res.time)
	var txt := "%s · %s\nTempo %02d:%02d · Nível %d · Abates %d · Chefes %d\nModo: %s · Profundidade %d · Multiplicador ×%.2f\n\n+%d moedas%s (total %d)" % [
		Data.table("heroes")[res.hero].name, Data.table("stages")[res.stage].name, t / 60, t % 60, res.level, res.kills, res.bosses,
		"extraído" if res.extracted else ("derrota" if res.dead else "final"), int(res.get("descent_depth", 0)), float(res.get("reward_mult", 1.0)),
		summary.earned, (" (%d%% da tentativa)" % int(round(float(summary.reward_rate) * 100.0))) if float(summary.reward_rate) < 1.0 else "", summary.coins]
	if int(res.get("abyss_level", 0)) > 0:
		txt += "\nMarcas do Abismo: nível %d (moedas +%d%%)%s" % [int(res.abyss_level), int(round(AbyssMarks.reward_bonus(res.abyss_marks) * 100.0)), "  ★ novo recorde" if bool(summary.get("abyss_record", false)) else ""]
	var names: Array = []
	for id in summary.achievements:
		for a in Data.table("achievements").achievements:
			if a.id == id:
				names.append("★ %s — %s" % [a.name, a.reward.get("text", "")])
	if not names.is_empty():
		txt += "\n\nConquistas:\n" + "\n".join(names)
	result_text.text = txt
	var result_was_open := result_panel.visible
	result_panel.visible = true
	if not result_was_open:
		UiKit.fade_in(result_panel)
	_focus_visible.call_deferred(%AgainBtn)

func _focus_visible(button: Control) -> void:
	if is_instance_valid(button) and button.is_inside_tree() and button.is_visible_in_tree():
		button.grab_focus()

## SPEC-116 D3: a barra de XP pisca ao receber moeda ou XP.
var _xp_pulse: Tween

func pulse_xp() -> void:
	if _xp_pulse != null and _xp_pulse.is_valid():
		_xp_pulse.kill()
	hero_panel.xp_bar.modulate = Color(1.6, 1.5, 1.2)
	_xp_pulse = create_tween()
	_xp_pulse.tween_property(hero_panel.xp_bar, "modulate", Color.WHITE, 0.18)

## SPEC-165 (MEC-003): o painel de pausa vira a janela padrão com abas (Jogo, Catálogo, Configurações).
## Os botões antigos são reaproveitados dentro da aba Jogo e a linha de volume dentro de Configurações.
func _build_pause_menu() -> void:
	UiKit.apply_window(pause_panel, UiKit.WINDOW_SIZE_TOUCH if Game.touch_controls_enabled() else UiKit.WINDOW_SIZE)
	var margin := UiKit.margin(40)
	pause_panel.add_child(margin)
	pause_menu = PauseMenu.new()
	pause_menu.name = "PauseMenu"
	margin.add_child(pause_menu)
	var title: Control = _pause_box.get_node_or_null("PauseTitle")
	if title != null:
		title.hide()   # o cabeçalho "PAUSA" agora é do PauseMenu
	pause_menu.build(_pause_box, _pause_box.get_node("VolRow"))
	pause_menu.is_blocked = func(): return items_panel.visible or _controls_panel.visible or _confirm_dialog.visible or Playtest.is_overlay_open()
