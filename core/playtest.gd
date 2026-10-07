extends CanvasLayer
## Autoload "Playtest": evidências diretas, diagnóstico e navegação QA.
## F4 = Navegador QA pausado com prévia de HQ, F5 = nota textual, F6 = print; F1 = guia.
## As evidências ficam na pasta evidencias/ ao lado do executável de playtest.

const NOTE_MAX := 1000
const EVIDENCE_FOLDER := "evidencias"
const ALLOWED_EVIDENCE_EXTENSIONS := ["txt", "log", "png", "jpg", "jpeg", "webp"]
const GUIDE_MAX_SIZE := Vector2(820, 560)
const GUIDE_MARGIN := 24.0
const NOTE_MAX_SIZE := Vector2(760, 470)
const NOTE_MARGIN := 24.0
const HQ_SCREEN := preload("res://ui/hq_screen.tscn")
const QA_RUN_DESTINATIONS := [
	["Inicio da run", "running"],
	["Quadrinho (prévia)", "comic_preview"],
	["Oferta de level-up", "levelup"],
	["Altar", "altar"],
	["Chefe: entrada", "boss"],
	["Chefe: virada 70%", "boss_70"],
	["Chefe: virada 35%", "boss_35"],
	["Portal apos chefe", "portal"],
	["Resultado: vitoria", "victory"],
	["Resultado: derrota", "defeat"],
	["Oferta de revive", "revive_offer"],
	["Regra da fase", "rule"],
	["Props: contato visual", "prop_grounding"],
	["Estige: entrada", "styx_entry"],
	["Estige: margem", "styx_margin"],
	["Estige: falha de lucidez", "styx_lucidity"],
	["Estige: Esquecimento", "styx_forget"],
]

var _note_open := false
var _guide_open := false
var _guide_mode: StringName = &"playtest"
var _pending_ctx := {}
var _paused_before := false
var _qa_open := false
var _qa_paused_before := false
var _evidence_dir := ""
var _evidence_error := ""
var _logged_line_count := 0

var _toast: Label
var _pad: PanelContainer
var _edit: TextEdit
var _count: Label
var _guide_modal: Control
var _guide: PanelContainer
var _guide_content: VBoxContainer
var _guide_title: Label
var _guide_body: RichTextLabel
var _guide_name_label: Label
var _name_edit: LineEdit
var _guide_start: Button
var _guide_error: Label
var _console: PanelContainer
var _console_text: RichTextLabel
var _qa_modal: PanelContainer
var _qa_stage: OptionButton
var _qa_comic: OptionButton
var _qa_hero: OptionButton
var _qa_state: OptionButton
var _qa_seed: SpinBox
var _qa_level: SpinBox
var _qa_weapon: OptionButton
var _qa_item: OptionButton
var _qa_passive: OptionButton
var _qa_event: OptionButton
var _qa_launch_button: Button
var _qa_comic_reader: Node
var _qa_run_controls: Array[Control] = []

func _ready() -> void:
	layer = 100
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_ui()
	get_viewport().size_changed.connect(_layout_modals)
	call_deferred("_layout_modals")
	if not Version.evidence_enabled():
		return
	if _uses_executable_evidence_directory():
		_prepare_evidence_dir()
		_sync_game_log()
	await get_tree().process_frame
	if Game.profile.data.name == "" or not bool(Game.profile.data.welcome_seen):
		open_guide(true)

# ------------------------------------------------------------------ UI

func _build_ui() -> void:
	_toast = Label.new()
	_toast.set_anchors_preset(Control.PRESET_CENTER_TOP)
	_toast.position = Vector2(0, 8)
	_toast.custom_minimum_size = Vector2(700, 0)
	_toast.position.x = -350
	_toast.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_toast.add_theme_color_override("font_color", Color(1, 0.95, 0.6))
	_toast.add_theme_color_override("font_outline_color", Color(0, 0, 0))
	_toast.add_theme_constant_override("outline_size", 6)
	_toast.modulate.a = 0.0
	add_child(_toast)

	_pad = PanelContainer.new()
	_pad.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	_pad.visible = false
	add_child(_pad)
	var v := VBoxContainer.new()
	_pad.add_child(v)
	var t := Label.new()
	t.text = "Bloco de notas (F5) — salva um relato textual com o contexto atual"
	v.add_child(t)
	var note_scroll := ScrollContainer.new()
	note_scroll.custom_minimum_size = Vector2(0, 130)
	note_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(note_scroll)
	_edit = TextEdit.new()
	_edit.custom_minimum_size = Vector2(0, 300)
	_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_edit.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	_edit.placeholder_text = "Escreva o que viu: o que estranhou, o que funcionou, o que falhou..."
	_edit.text_changed.connect(_on_note_changed)
	note_scroll.add_child(_edit)
	_count = Label.new()
	v.add_child(_count)
	var actions := VBoxContainer.new()
	v.add_child(actions)
	var ok := Button.new()
	ok.text = "Guardar e fechar (F5)"
	ok.pressed.connect(close_note)
	actions.add_child(ok)
	var hint := Label.new()
	hint.text = "Ctrl+Z desfaz · Ctrl+A seleciona tudo · Esc fecha e grava"
	hint.modulate = Color(1, 1, 1, 0.6)
	hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hint.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	actions.add_child(hint)

	_guide_modal = Control.new()
	_guide_modal.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_guide_modal.mouse_filter = Control.MOUSE_FILTER_STOP
	_guide_modal.visible = false
	add_child(_guide_modal)
	var shade := ColorRect.new()
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.color = Color(0.015, 0.01, 0.025, 0.82)
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	_guide_modal.add_child(shade)
	_guide = PanelContainer.new()
	_guide.mouse_filter = Control.MOUSE_FILTER_STOP
	_guide_modal.add_child(_guide)
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_guide.add_child(scroll)
	var g := VBoxContainer.new()
	g.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(g)
	_guide_content = g
	_guide_title = Label.new()
	_guide_title.text = "Obrigado por ajudar a construir %s!" % Version.GAME_NAME
	_guide_title.add_theme_font_size_override("font_size", 26)
	_guide_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	g.add_child(_guide_title)
	_guide_body = RichTextLabel.new()
	_guide_body.bbcode_enabled = true
	_guide_body.fit_content = true
	_guide_body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_guide_body.text = _guide_text()
	g.add_child(_guide_body)
	_guide_name_label = Label.new()
	_guide_name_label.text = "Seu nome (aparece no contexto do playtest): "
	_guide_name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	g.add_child(_guide_name_label)
	_name_edit = LineEdit.new()
	_name_edit.max_length = 24
	_name_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_name_edit.text_submitted.connect(func(_t): close_guide())
	_name_edit.text_changed.connect(func(_t): _guide_error.visible = false)
	g.add_child(_name_edit)
	_guide_error = Label.new()
	_guide_error.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_guide_error.add_theme_color_override("font_color", Color(1.0, 0.48, 0.42))
	_guide_error.visible = false
	g.add_child(_guide_error)
	_guide_start = Button.new()
	_guide_start.text = "Começar"
	_guide_start.custom_minimum_size = Vector2(0, 44)
	_guide_start.pressed.connect(close_guide)
	g.add_child(_guide_start)

	_build_console()
	_build_qa_browser()

func _build_console() -> void:
	_console = PanelContainer.new()
	_console.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	_console.position = Vector2(-440, -290)
	_console.custom_minimum_size = Vector2(880, 260)
	_console.visible = false
	add_child(_console)
	var v := VBoxContainer.new()
	_console.add_child(v)
	var title := Label.new()
	title.text = "Console QA (somente diagnóstico)"
	v.add_child(title)
	_console_text = RichTextLabel.new()
	_console_text.bbcode_enabled = true
	_console_text.custom_minimum_size = Vector2(850, 190)
	_console_text.scroll_following = true
	v.add_child(_console_text)
	var close := Button.new()
	close.text = "Fechar (F12)"
	close.pressed.connect(func(): _console.visible = false)
	v.add_child(close)

func _build_qa_browser() -> void:
	_qa_modal = PanelContainer.new()
	_qa_modal.set_anchors_preset(Control.PRESET_CENTER)
	_qa_modal.position = Vector2(-390, -320)
	_qa_modal.custom_minimum_size = Vector2(780, 610)
	_qa_modal.visible = false
	add_child(_qa_modal)
	var v := VBoxContainer.new()
	_qa_modal.add_child(v)
	var title := Label.new()
	title.text = "Navegador QA — sandbox: progresso real preservado"
	title.add_theme_font_size_override("font_size", 22)
	v.add_child(title)
	var hint := Label.new()
	hint.text = "Quadrinho abre uma prévia sem alterar progresso. Eventos e entrada de chefe começam cinco segundos antes do gatilho."
	v.add_child(hint)
	_qa_hero = OptionButton.new()
	_qa_hero.tooltip_text = "Herói (bloqueios normais são ignorados apenas no sandbox)"
	for id in Data.table("heroes"):
		_qa_hero.add_item("Herói: %s [%s]" % [Data.table("heroes")[id].name, id])
		_qa_hero.set_item_metadata(_qa_hero.item_count - 1, id)
	v.add_child(_qa_hero)
	_qa_stage = OptionButton.new()
	for id in Data.table("stages"):
		_qa_stage.add_item("Fase: %s [%s]" % [Data.table("stages")[id].name, id])
		_qa_stage.set_item_metadata(_qa_stage.item_count - 1, id)
	_qa_stage.item_selected.connect(func(_idx):
		_fill_qa_events()
		_fill_qa_comics()
	)
	if _qa_stage.item_count > 0:
		_qa_stage.select(0)
	v.add_child(_qa_stage)
	_qa_state = OptionButton.new()
	_qa_state.tooltip_text = "Destino de teste para a fase selecionada"
	for state in QA_RUN_DESTINATIONS:
		_qa_state.add_item(state[0])
		_qa_state.set_item_metadata(_qa_state.item_count - 1, state[1])
	_qa_state.item_selected.connect(func(_idx): _update_qa_target_ui())
	v.add_child(_qa_state)
	_qa_comic = OptionButton.new()
	_qa_comic.visible = false
	_qa_comic.tooltip_text = "Prévia sem alterar progresso, save ou conquistas"
	_qa_comic.item_selected.connect(func(_idx): _update_qa_target_ui())
	v.add_child(_qa_comic)
	_qa_seed = SpinBox.new()
	_qa_seed.min_value = 1
	_qa_seed.max_value = 999999999
	_qa_seed.value = 1001
	_qa_seed.tooltip_text = "Seed determinística"
	v.add_child(_qa_seed)
	_qa_level = SpinBox.new()
	_qa_level.min_value = 1
	_qa_level.max_value = 20
	_qa_level.value = 5
	_qa_level.tooltip_text = "Nível inicial do herói no cenário"
	v.add_child(_qa_level)
	_qa_weapon = OptionButton.new()
	_qa_weapon.add_item("Arma extra: nenhuma")
	_qa_weapon.set_item_metadata(0, "")
	for id in Data.table("weapons"):
		_qa_weapon.add_item("Arma extra: %s" % Data.table("weapons")[id].name)
		_qa_weapon.set_item_metadata(_qa_weapon.item_count - 1, id)
	v.add_child(_qa_weapon)
	_qa_item = OptionButton.new()
	_qa_item.add_item("Item: nenhum")
	_qa_item.set_item_metadata(0, "")
	for item in Data.table("items").uniques:
		_qa_item.add_item("Item: %s" % item.name)
		_qa_item.set_item_metadata(_qa_item.item_count - 1, item.id)
	v.add_child(_qa_item)
	_qa_passive = OptionButton.new()
	_qa_passive.add_item("Passiva: nenhuma")
	_qa_passive.set_item_metadata(0, "")
	for id in Data.table("passives"):
		_qa_passive.add_item("Passiva: %s" % Data.table("passives")[id].name)
		_qa_passive.set_item_metadata(_qa_passive.item_count - 1, id)
	v.add_child(_qa_passive)
	_qa_event = OptionButton.new()
	v.add_child(_qa_event)
	_fill_qa_events()
	_fill_qa_comics()
	_qa_run_controls = [_qa_hero, _qa_seed, _qa_level, _qa_weapon, _qa_item, _qa_passive, _qa_event]
	if _qa_state.item_count > 0:
		_qa_state.select(0)
	_update_qa_target_ui()
	var h := HBoxContainer.new()
	v.add_child(h)
	_qa_launch_button = Button.new()
	_qa_launch_button.text = "Abrir destino"
	_qa_launch_button.pressed.connect(_launch_qa)
	h.add_child(_qa_launch_button)
	var menu := Button.new()
	menu.text = "Abrir Quartel"
	menu.pressed.connect(_launch_qa_menu)
	h.add_child(menu)
	var end := Button.new()
	end.text = "Encerrar sandbox"
	end.pressed.connect(_end_qa)
	h.add_child(end)
	var close := Button.new()
	close.text = "Fechar"
	close.pressed.connect(_close_qa_browser)
	h.add_child(close)

func _open_console() -> void:
	if not Version.evidence_enabled():
		return
	_console.visible = not _console.visible
	if _console.visible:
		var lines := Game.log_lines.slice(maxi(0, Game.log_lines.size() - 200))
		_console_text.text = "[color=#d8d8d8]%s[/color]" % scrub("\n".join(lines)).replace("[", "\\[")

func _open_qa_browser() -> void:
	if not Version.qa_enabled() or _qa_open:
		return
	var pause_state := qa_browser_pause_transition(true, _qa_paused_before, get_tree().paused)
	_qa_paused_before = bool(pause_state.paused_before)
	_qa_open = true
	_qa_modal.visible = true
	get_tree().paused = bool(pause_state.tree_paused)
	_update_qa_target_ui()

func _close_qa_browser() -> void:
	if not _qa_open:
		return
	_qa_open = false
	_qa_modal.visible = false
	get_viewport().gui_release_focus()
	if _qa_comic_reader != null:
		var reader := _qa_comic_reader
		_qa_comic_reader = null
		reader.call("finish")
		reader.queue_free()
	var pause_state := qa_browser_pause_transition(false, _qa_paused_before, get_tree().paused)
	_qa_paused_before = bool(pause_state.paused_before)
	get_tree().paused = bool(pause_state.tree_paused)

func _fill_qa_events() -> void:
	if _qa_event == null or _qa_stage == null or _qa_stage.selected < 0:
		return
	_qa_event.clear()
	_qa_event.add_item("Evento de fase: nenhum")
	_qa_event.set_item_metadata(0, "")
	var stage_id := String(_qa_stage.get_item_metadata(_qa_stage.selected))
	for event_def in Data.table("stage_events").get(stage_id, []):
		_qa_event.add_item("Evento: %s" % String(event_def.get("title", event_def.id)))
		_qa_event.set_item_metadata(_qa_event.item_count - 1, String(event_def.id))

static func qa_comic_ids_for_stage(hqs: Dictionary, stage_id: String) -> Array[String]:
	var ids: Array[String] = []
	for key in hqs.keys():
		ids.append(String(key))
	ids.sort()
	ids.sort_custom(func(a: String, b: String) -> bool:
		var a_trigger: Dictionary = hqs[a].get("trigger", {})
		var b_trigger: Dictionary = hqs[b].get("trigger", {})
		var a_matches := String(a_trigger.get("stage", "")) == stage_id and stage_id != ""
		var b_matches := String(b_trigger.get("stage", "")) == stage_id and stage_id != ""
		if a_matches != b_matches:
			return a_matches
		return a < b
	)
	return ids

func _fill_qa_comics() -> void:
	if _qa_comic == null:
		return
	_qa_comic.clear()
	if _qa_stage == null or _qa_stage.selected < 0:
		return
	var stage_id := String(_qa_stage.get_item_metadata(_qa_stage.selected))
	var stages: Dictionary = Data.table("stages")
	var hqs: Dictionary = Data.table("hqs")
	for hq_id in qa_comic_ids_for_stage(hqs, stage_id):
		var hq: Dictionary = hqs[hq_id]
		var trigger: Dictionary = hq.get("trigger", {})
		var category := "conquista" if hq.has("achievement") else "abertura"
		if trigger.get("type", "") == "stage_reached":
			category = "chegada: %s" % String(stages.get(String(trigger.get("stage", "")), {}).get("name", trigger.get("stage", "")))
		elif trigger.get("type", "") == "stage_cleared":
			category = "vitória: %s" % String(stages.get(String(trigger.get("stage", "")), {}).get("name", trigger.get("stage", "")))
		elif trigger.get("type", "") == "final_victory":
			category = "vitória final: %s" % String(stages.get(String(trigger.get("stage", "")), {}).get("name", trigger.get("stage", "")))
		_qa_comic.add_item("%s — %s · %s" % [hq_id.to_upper().replace("_", "-"), String(hq.get("title", hq_id)), category])
		_qa_comic.set_item_metadata(_qa_comic.item_count - 1, hq_id)
	if _qa_comic.item_count > 0:
		_qa_comic.select(0)
	_update_qa_target_ui()

func _update_qa_target_ui() -> void:
	if _qa_state == null:
		return
	var is_comic_preview := _qa_state.selected >= 0 and String(_qa_state.get_item_metadata(_qa_state.selected)) == "comic_preview"
	if _qa_comic != null:
		_qa_comic.visible = is_comic_preview
	for control in _qa_run_controls:
		control.visible = not is_comic_preview
	if _qa_launch_button != null:
		_qa_launch_button.text = "Pré-visualizar quadrinho" if is_comic_preview else "Abrir destino"
		_qa_launch_button.disabled = is_comic_preview and (_qa_comic == null or _qa_comic.selected < 0)

func _preview_qa_comic() -> void:
	if not _qa_open or _qa_comic == null or _qa_comic.selected < 0:
		return
	var hq_id := String(_qa_comic.get_item_metadata(_qa_comic.selected))
	var hq: Dictionary = Data.table("hqs").get(hq_id, {})
	if hq.is_empty():
		return
	_qa_modal.visible = false
	_qa_comic_reader = HQ_SCREEN.instantiate()
	_qa_comic_reader.process_mode = Node.PROCESS_MODE_ALWAYS
	_qa_comic_reader.connect("closed", _on_qa_comic_closed)
	add_child(_qa_comic_reader)
	_qa_comic_reader.call_deferred("start_hq", hq)

func _on_qa_comic_closed() -> void:
	if _qa_comic_reader != null:
		_qa_comic_reader.queue_free()
		_qa_comic_reader = null
	if _qa_open:
		_qa_modal.visible = true

func _launch_qa() -> void:
	var target := String(_qa_state.get_item_metadata(_qa_state.selected))
	if target == "comic_preview":
		_preview_qa_comic()
		return
	var request := {
		"id": "qa.%s.%s" % [String(_qa_stage.get_item_metadata(_qa_stage.selected)), String(_qa_state.get_item_metadata(_qa_state.selected))],
		"seed": int(_qa_seed.value),
		"hero_id": String(_qa_hero.get_item_metadata(_qa_hero.selected)),
		"stage_id": String(_qa_stage.get_item_metadata(_qa_stage.selected)),
		"target_state": target,
		"event_id": String(_qa_event.get_item_metadata(_qa_event.selected)),
		"prelude_seconds": 5.0,
		"level": int(_qa_level.value),
		"weapons": [String(_qa_weapon.get_item_metadata(_qa_weapon.selected))].filter(func(id): return id != ""),
		"item_id": String(_qa_item.get_item_metadata(_qa_item.selected)),
		"passive_id": String(_qa_passive.get_item_metadata(_qa_passive.selected)),
		"passive_level": 1
	}
	_close_qa_browser()
	if not Game.start_qa_run(request):
		_open_qa_browser()
		toast(Game.qa_error)

func _launch_qa_menu() -> void:
	if not Game.begin_qa_sandbox("qa-menu-%d" % Time.get_ticks_msec()):
		toast(Game.qa_error)
		return
	Game.qa_menu_tab = 0
	_close_qa_browser()
	Game.goto_menu()

func _end_qa() -> void:
	_close_qa_browser()
	var unchanged := Game.end_qa_sandbox()
	toast("Sandbox encerrado; save real %s." % ("preservado" if unchanged else "ALTERADO — verifique"))
	Game.goto_menu()

func _layout_guide() -> void:
	if _guide == null:
		return
	var viewport_size := get_viewport().get_visible_rect().size
	var panel_size := guide_panel_size(viewport_size)
	_guide.custom_minimum_size = panel_size
	_guide.size = panel_size
	_guide.position = (viewport_size - panel_size) * 0.5
	# ScrollContainer mede o filho pela largura mínima; mantemos o texto dentro
	# da largura visível para que apenas a rolagem vertical seja necessária.
	_guide_content.custom_minimum_size.x = maxf(1.0, panel_size.x - 32.0)

func _layout_modals() -> void:
	_layout_guide()
	_layout_note()

func _layout_note() -> void:
	if _pad == null:
		return
	var viewport_size := get_viewport().get_visible_rect().size
	var panel_size := note_panel_size(viewport_size)
	_pad.custom_minimum_size = panel_size
	_pad.size = panel_size
	_pad.position = (viewport_size - panel_size) * 0.5

static func guide_panel_size(viewport_size: Vector2) -> Vector2:
	var available := viewport_size - Vector2(GUIDE_MARGIN * 2.0, GUIDE_MARGIN * 2.0)
	return Vector2(minf(GUIDE_MAX_SIZE.x, maxf(1.0, available.x)), minf(GUIDE_MAX_SIZE.y, maxf(1.0, available.y)))

static func note_panel_size(viewport_size: Vector2) -> Vector2:
	var available := viewport_size - Vector2(NOTE_MARGIN * 2.0, NOTE_MARGIN * 2.0)
	return Vector2(minf(NOTE_MAX_SIZE.x, maxf(1.0, available.x)), minf(NOTE_MAX_SIZE.y, maxf(1.0, available.y)))

static func is_qa_shortcut(ev: InputEvent, o_pressed: bool = false) -> bool:
	if not (ev is InputEventKey) or not ev.pressed or ev.echo:
		return false
	if ev.physical_keycode == KEY_F4:
		return true
	return ev.physical_keycode == KEY_P and ev.ctrl_pressed and o_pressed

static func should_handle_qa_shortcut(ev: InputEvent, browser_open: bool, has_ui_focus: bool, o_pressed: bool = false) -> bool:
	return is_qa_shortcut(ev, o_pressed) and (browser_open or not has_ui_focus)

static func qa_browser_pause_transition(opening: bool, paused_before: bool, currently_paused: bool) -> Dictionary:
	if opening:
		return {"paused_before": currently_paused, "tree_paused": true}
	return {"paused_before": paused_before, "tree_paused": paused_before}

static func shortcut_action(ev: InputEvent) -> StringName:
	if not (ev is InputEventKey) or not ev.pressed or ev.echo:
		return &""
	match ev.physical_keycode:
		KEY_F5:
			return &"note"
		KEY_F6:
			return &"screenshot"
		KEY_F11:
			return &"fullscreen"
		KEY_F12:
			return &"console"
		KEY_F1:
			return &"guide"
	return &""

static func qa_run_destinations() -> Array:
	return QA_RUN_DESTINATIONS.duplicate(true)

static func qa_shortcuts_text(qa_enabled: bool) -> String:
	var shortcuts := "[b]Teclas de teste[/b]: "
	if qa_enabled:
		shortcuts += "F4 Navegador QA (pausa e prévia de HQ) · "
	shortcuts += "F5 nota · F6 print · F11 tela cheia · F12 diagnóstico · F1 este guia\n"
	return shortcuts

static func _guide_text() -> String:
	return "Este jogo [b]ainda não foi lançado[/b]: você está testando uma versão em construção (v%s). O que você reportar muda o jogo de verdade.\n\n" % Version.VERSION \
		+ "[b]O que fazer[/b]\n" \
		+ "1. Jogue seguindo o que foi pedido a você (uma fase, um herói, um chefe...). Não precisa jogar tudo.\n" \
		+ "2. [b]F6[/b] tira um print na hora certa (não pausa).\n" \
		+ "3. [b]F5[/b] abre o bloco de notas: escreva o que estranhou ou gostou. Ao fechar, o relato textual é salvo.\n" \
		+ "4. Envie individualmente o relato, o log e os prints de [b]evidencias[/b] na task correspondente do Discord.\n\n" \
		+ "[b]Controles do jogo[/b]\n" \
		+ "Teclado/mouse: WASD/setas movem; Tab alterna mira; Q/botão direito usa habilidade; E interage; X extrai; 1-5 escolhe; R rerrola; T/F acelera; Esc pausa. Controle: analógico esquerdo/direcional move; direito mira no modo manual; RB usa habilidade; oeste interage; norte alterna mira ou extrai; LB rerrola; Start pausa; Back abre itens. Leste confirma e sul volta nas telas.\n" \
		+ "Todas as armas atacam sozinhas. Sobreviva, evolua, derrote o chefe da fase e desça pelo portal.\n\n" \
		+ qa_shortcuts_text(Version.qa_enabled()) \
		+ "[color=#aaaaaa]Os prints mostram a tela do jogo. Notas e log têm o nome de usuário do Windows removido.[/color]"

static func game_rules_text() -> String:
	return "[b]Objetivo[/b]\nSobreviva às ondas, evolua sua build e derrote o chefe da fase. Depois, escolha entre extrair a recompensa atual ou entrar no portal para continuar com mais risco e mais recompensa.\n\n" \
		+ "[b]Controles[/b]\nTeclado/mouse: WASD ou setas movem; Tab alterna mira automática/manual; Q ou botão direito usa habilidade; E interage; X extrai; T acelera; Esc pausa. Controle: analógico esquerdo ou direcional move; analógico direito mira no modo manual; RB usa habilidade; oeste interage; norte alterna mira ou extrai; Start pausa; Back abre itens. Nas telas, direcional navega, leste confirma e sul volta.\n\n" \
		+ "[b]Combate e evolução[/b]\nSuas armas atacam automaticamente. Ao subir de nível, escolha uma melhoria pelo foco ou com 1–5; R ou LB rerrola a oferta quando houver rerrolagens. Cada personagem tem uma habilidade ativa própria.\n\n" \
		+ "[b]Decisões da run[/b]\nAltares oferecem uma bênção com uma maldição. Cada andar tem uma regra ambiental: observe os avisos e adapte seu movimento. Chefes mudam de fase quando a vida baixa.\n\n" \
		+ "[b]Progresso[/b]\nMoedas, desbloqueios e descobertas são garantidos ao encerrar a tentativa. O portal preserva sua build e aumenta o multiplicador de recompensa; extrair encerra a run com segurança."

func toast(text: String) -> void:
	_toast.text = text
	_toast.modulate.a = 1.0
	var tw := create_tween()
	tw.tween_interval(2.6)
	tw.tween_property(_toast, "modulate:a", 0.0, 0.6)

# ------------------------------------------------------------------ teclas

func _input(ev: InputEvent) -> void:
	if not ev.is_pressed() or (ev is InputEventKey and ev.echo):
		return
	if ev.is_action_pressed(&"ui_cancel"):
		if _note_open:
			close_note()
			get_viewport().set_input_as_handled()
			return
		if _guide_open and (_guide_mode == &"rules" or Game.profile.data.name != ""):
			close_guide()
			get_viewport().set_input_as_handled()
			return
		if _qa_open and _qa_modal.visible:
			_close_qa_browser()
			get_viewport().set_input_as_handled()
			return
	if not ev is InputEventKey:
		return
	var shortcut := shortcut_action(ev)
	if shortcut == &"fullscreen":
		Game.toggle_fullscreen()
		get_viewport().set_input_as_handled()
		return
	if not Version.evidence_enabled():
		return
	if shortcut == &"console":
		_open_console()
		get_viewport().set_input_as_handled()
		return
	var has_ui_focus := get_viewport().gui_get_focus_owner() != null
	if Version.qa_enabled() and should_handle_qa_shortcut(ev, _qa_open, has_ui_focus, Input.is_key_pressed(KEY_O)):
		if _qa_open:
			_close_qa_browser()
		else:
			_open_qa_browser()
		get_viewport().set_input_as_handled()
		return
	match shortcut:
		&"note":
			if _guide_open:
				return
			if _note_open:
				close_note()
			else:
				open_note()
			get_viewport().set_input_as_handled()
		&"screenshot":
			take_print()
			get_viewport().set_input_as_handled()
		&"guide":
			if _guide_open:
				close_guide()
			elif not _note_open:
				open_guide(false)
			get_viewport().set_input_as_handled()

# ------------------------------------------------------------------ contexto

func context() -> Dictionary:
	var ctx := {"tela": Game.screen_name, "build": Version.profile_slug(), "commit": Version.build_id()}
	var cs := get_tree().current_scene
	if cs != null and cs.has_method("playtest_context"):
		ctx.merge(cs.playtest_context())
	if Game.qa_sandbox:
		ctx.qa = {"cenario": Game.qa_launch.get("id", ""), "seed": Game.qa_launch.get("seed", 0)}
	return ctx

static func scrub(text: String) -> String:
	var out := text
	var user := OS.get_environment("USERNAME")
	if user != "" and user.length() > 2:
		out = out.replace(user, "<usuario>")
	for p in [OS.get_user_data_dir(), OS.get_executable_path().get_base_dir()]:
		if String(p) != "":
			out = out.replace(String(p), "<pasta>").replace(String(p).replace("/", "\\"), "<pasta>")
	return out

# ------------------------------------------------------------------ captura

func _capture() -> PackedByteArray:
	visible = false
	await RenderingServer.frame_post_draw
	var img := get_viewport().get_texture().get_image()
	visible = true
	return img.save_png_to_buffer()

static func evidence_directory_for_executable(executable_path: String) -> String:
	return executable_path.get_base_dir().path_join(EVIDENCE_FOLDER)

static func is_allowed_evidence_path(path: String) -> bool:
	return ALLOWED_EVIDENCE_EXTENSIONS.has(path.get_extension().to_lower())

func _uses_executable_evidence_directory() -> bool:
	return OS.has_feature("public_playtest") or OS.has_feature("qa_internal")

## O Game grava o primeiro log antes do _ready do Playtest: resolve a pasta sob demanda
## para que o caminho nunca saia relativo.
func _evidence_root() -> String:
	if _evidence_dir == "":
		_evidence_dir = evidence_directory_for_executable(OS.get_executable_path())
	return _evidence_dir

func _images_dir() -> String:
	return _evidence_root().path_join("imagens")

func _log_path() -> String:
	return _evidence_root().path_join("logs/jogo.log")

func _relato_path() -> String:
	return _evidence_root().path_join("relato.txt")

func _prepare_evidence_dir() -> bool:
	if _evidence_error != "":
		_show_evidence_error(_evidence_error)
		return false
	for path in [_evidence_root(), _evidence_root().path_join("logs"), _images_dir()]:
		if DirAccess.make_dir_recursive_absolute(path) != OK:
			_show_evidence_error("Não foi possível criar evidencias ao lado do executável. Mova a build para uma pasta com permissão de gravação e abra o jogo novamente.")
			return false
	if not _ensure_text_file(_relato_path()) or not _ensure_text_file(_log_path()):
		_show_evidence_error("A pasta evidencias ao lado do executável não permite gravação. Mova a build para uma pasta gravável e abra o jogo novamente.")
		return false
	return true

func _ensure_text_file(path: String) -> bool:
	if not is_allowed_evidence_path(path):
		return false
	var file := FileAccess.open(path, FileAccess.READ_WRITE) if FileAccess.file_exists(path) else FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return false
	file.close()
	return true

func _show_evidence_error(message: String) -> void:
	_evidence_error = message
	if _toast != null:
		toast(message)

func _append_text(path: String, text: String) -> bool:
	if not _prepare_evidence_dir() or not is_allowed_evidence_path(path):
		return false
	var file := FileAccess.open(path, FileAccess.READ_WRITE)
	if file == null:
		_show_evidence_error("Não foi possível gravar em evidencias ao lado do executável. Verifique a permissão da pasta da build.")
		return false
	file.seek_end()
	file.store_string(text)
	file.close()
	return true

func _write_binary(path: String, bytes: PackedByteArray) -> bool:
	if not _prepare_evidence_dir() or not is_allowed_evidence_path(path):
		return false
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		_show_evidence_error("Não foi possível gravar o print em evidencias/imagens. Verifique a permissão da pasta da build.")
		return false
	file.store_buffer(bytes)
	file.close()
	return true

func _write_note(text: String, ctx: Dictionary) -> bool:
	var entry := "\n[%s]\nContexto: %s\n%s\n" % [Time.get_datetime_string_from_system(), scrub(JSON.stringify(ctx)), scrub(text)]
	return _append_text(_relato_path(), entry)

func append_game_log(line: String) -> void:
	if Version.evidence_enabled() and (_evidence_dir != "" or _uses_executable_evidence_directory()) and _append_text(_log_path(), "%s\n" % scrub(line)):
		_logged_line_count += 1

func _sync_game_log() -> void:
	if not Version.evidence_enabled():
		return
	for line in Game.log_lines.slice(_logged_line_count):
		append_game_log(String(line))

func take_print() -> void:
	if _note_open:
		toast("Feche o bloco de notas (F5) antes de tirar um print.")
		return
	if _guide_open:
		return
	if not _prepare_evidence_dir():
		return
	var png: PackedByteArray = await _capture()
	if png.is_empty():
		_show_evidence_error("Não foi possível capturar a tela para salvar o print.")
		return
	var dt := Time.get_datetime_dict_from_system()
	var stem := "print-%04d-%02d-%02d-%02d%02d%02d" % [dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second]
	var path := "%s/%s.png" % [_images_dir(), stem]
	var sequence := 2
	while FileAccess.file_exists(path):
		path = "%s/%s-%02d.png" % [_images_dir(), stem, sequence]
		sequence += 1
	if not _write_binary(path, png):
		return
	Game.logline("Evidência: print salvo em imagens/%s" % path.get_file())
	toast("Print salvo em evidencias/imagens/%s" % path.get_file())

func is_note_open() -> bool:
	return _note_open

func open_note() -> void:
	_pending_ctx = context()
	_note_open = true
	_paused_before = get_tree().paused
	get_tree().paused = true
	_pad.visible = true
	_edit.text = ""
	_on_note_changed()
	_edit.grab_focus()

func close_note() -> void:
	if not _note_open:
		return
	_note_open = false
	_pad.visible = false
	get_tree().paused = _paused_before
	var text := _edit.text.strip_edges().substr(0, NOTE_MAX)
	if text != "":
		if _write_note(text, _pending_ctx):
			Game.logline("Evidência: relato registrado")
			toast("Relato salvo em evidencias/relato.txt")

func _on_note_changed() -> void:
	if _edit.text.length() > NOTE_MAX:
		_edit.text = _edit.text.substr(0, NOTE_MAX)
		_edit.set_caret_column(NOTE_MAX)
	_count.text = "%d/%d caracteres" % [_edit.text.length(), NOTE_MAX]

func open_guide(first: bool) -> void:
	TouchUI.prepare(self)
	_guide_mode = &"playtest"
	_guide_open = true
	_paused_before = get_tree().paused
	get_tree().paused = true
	_guide_error.visible = false
	_guide_modal.visible = true
	_layout_guide()
	_guide_title.text = "Obrigado por ajudar a construir %s!" % Version.GAME_NAME
	_guide_body.text = _guide_text()
	_guide_name_label.visible = true
	_name_edit.visible = true
	_name_edit.text = Game.profile.data.name
	_guide_start.text = "Começar" if first else "Fechar"
	_name_edit.grab_focus()

func open_game_rules() -> void:
	TouchUI.prepare(self)
	if _guide_open:
		return
	_guide_mode = &"rules"
	_guide_open = true
	_paused_before = get_tree().paused
	get_tree().paused = true
	_guide_error.visible = false
	_guide_modal.visible = true
	_layout_guide()
	_guide_title.text = "Como jogar"
	_guide_body.text = game_rules_text()
	_guide_name_label.visible = false
	_name_edit.visible = false
	_guide_start.text = "Fechar"
	_guide_start.grab_focus()

func close_guide() -> void:
	if _guide_mode == &"rules":
		_close_guide_modal()
		return
	var nm := _name_edit.text.strip_edges()
	if nm == "":
		if Game.profile.data.name == "":
			_guide_error.text = "Digite um nome para continuar."
			_guide_error.visible = true
			_name_edit.grab_focus()
			return
		nm = Game.profile.data.name
	Game.profile.data.name = nm
	Game.profile.data.welcome_seen = true
	Game.save()
	_close_guide_modal()

func _close_guide_modal() -> void:
	_guide_open = false
	_guide_modal.visible = false
	get_tree().paused = _paused_before
	_guide_mode = &"playtest"
	call_deferred("_restore_menu_focus")

func _restore_menu_focus() -> void:
	var scene := get_tree().current_scene
	if scene == null:
		return
	var play_btn := scene.get_node_or_null("Tabs/Jogar/Right/PlayBtn") as Button
	if play_btn != null and not play_btn.disabled:
		play_btn.grab_focus()
