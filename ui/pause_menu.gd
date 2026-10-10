class_name PauseMenu
extends VBoxContainer
## SPEC-165 (MEC-003): menu de pausa em abas, no padrão da ficha C (`UiKit`).
##   Jogo (os botões que já existiam), Catálogo (inimigos, armas, itens únicos; bloqueados escuros) e Configurações (áudio, falas, tela).
## Os nós do menu antigo (`%ResumeBtn`, ficha, velocidade, extrair, Controles, `%VolSlider`...) são reaproveitados dentro das abas:
## sinais, foco por controle e testes seguem valendo. O HUD só chama `build`, `show_menu` e `handle_input`.

const TAB_NAMES := ["Jogo", "Catálogo", "Configurações"]
const TAB_TIPS := ["Continuar, ficha, velocidade, extrair", "Inimigos, armas e itens únicos já descobertos", "Áudio, falas e tela"]
const GRID_COLUMNS := 8
const CELL := Vector2(64, 64)
const DETAIL_PLACEHOLDER := "[color=#9a9aa6]Escolha uma entrada na grade para ver o detalhe.[/color]"

signal tab_changed(index: int)

var is_blocked: Callable = func(): return false   # HUD: ficha, controles, confirmação ou bloco de notas por cima
var options: OptionsPanel
var _tab := 0
var _tab_buttons: Array = []
var _previous_hint: Button
var _next_hint: Button
var _pages: Array = []
var _category := 0
var _cat_buttons: Array = []
var _grid: GridContainer
var _detail: RichTextLabel
var _run_codex: Dictionary = {}
var _game_scroll: ScrollContainer
var _game_holder: Control
var _settings_box: VBoxContainer

## Monta o menu. `game_box` é o VBox antigo do painel de pausa e `volume_row` a linha de volume geral.
func build(game_box: Control, volume_row: Control) -> void:
	add_theme_constant_override("separation", 10)
	var header := HBoxContainer.new()
	header.add_child(UiKit.label("PAUSA", 24, UiKit.GOLD))
	add_child(header)
	add_child(_build_tabs())
	var stack := Control.new()
	stack.size_flags_vertical = Control.SIZE_EXPAND_FILL
	stack.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(stack)
	_pages = [_build_game_page(game_box), _build_catalog_page(), _build_settings_page(volume_row)]
	for p in _pages:
		(p as Control).set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		stack.add_child(p)
	# só agora as páginas estão na árvore: o dono da cena (HUD) é ancestral e os nomes únicos continuam valendo
	_move(game_box, _game_holder)
	_move(volume_row, _settings_box)
	_settings_box.move_child(volume_row, 1)
	Game.controls.changed.connect(_update_hints)
	_update_hints()
	set_tab(0)

func _build_tabs() -> Control:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	if not Game.touch_controls_enabled():
		_previous_hint = UiKit.hint_button()
		_previous_hint.pressed.connect(cycle_tab.bind(-1))
		row.add_child(_previous_hint)
	var group := ButtonGroup.new()
	for i in TAB_NAMES.size():
		var tb := UiKit.tab_button(TAB_NAMES[i], TAB_TIPS[i], null, group)
		tb.pressed.connect(set_tab.bind(i))
		_tab_buttons.append(tb)
		row.add_child(tb)
	if not Game.touch_controls_enabled():
		_next_hint = UiKit.hint_button()
		_next_hint.pressed.connect(cycle_tab.bind(1))
		row.add_child(_next_hint)
	return row

func _build_game_page(game_box: Control) -> Control:
	_game_scroll = ScrollContainer.new()
	_game_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_game_scroll.follow_focus = true
	var center := CenterContainer.new()
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_game_scroll.add_child(center)
	_game_holder = center
	return _game_scroll

func _build_settings_page(volume_row: Control) -> Control:
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.follow_focus = true
	_settings_box = VBoxContainer.new()
	_settings_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_settings_box.add_theme_constant_override("separation", 8)
	scroll.add_child(_settings_box)
	_settings_box.add_child(UiKit.label("VOLUME GERAL", 16, UiKit.GOLD))
	options = OptionsPanel.new()
	_settings_box.add_child(options)
	# a mira já tem o botão da aba Jogo (com a tecla Tab) e o volume mestre já está na linha acima; aqui só confundiriam
	options.aim.get_parent().hide()
	options.master_vol.get_parent().hide()
	return scroll

func _build_catalog_page() -> Control:
	var page := VBoxContainer.new()
	page.add_theme_constant_override("separation", 8)
	var cats := HBoxContainer.new()
	cats.add_theme_constant_override("separation", 6)
	var group := ButtonGroup.new()
	for i in Catalog.CATEGORIES.size():
		var b := Button.new()
		b.toggle_mode = true
		b.button_group = group
		b.custom_minimum_size = Vector2(190, 36)
		b.add_theme_font_size_override("font_size", 15)
		b.add_theme_color_override("font_pressed_color", UiKit.GOLD)
		b.pressed.connect(set_category.bind(i))
		_cat_buttons.append(b)
		cats.add_child(b)
	page.add_child(cats)
	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 14)
	page.add_child(body)
	var scroll := ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.follow_focus = true
	body.add_child(scroll)
	_grid = GridContainer.new()
	_grid.columns = GRID_COLUMNS
	_grid.add_theme_constant_override("h_separation", 6)
	_grid.add_theme_constant_override("v_separation", 6)
	scroll.add_child(_grid)
	var frame := UiKit.detail_frame()
	frame.custom_minimum_size = Vector2(390, 0)
	_detail = RichTextLabel.new()
	_detail.bbcode_enabled = true
	_detail.focus_mode = Control.FOCUS_NONE
	_detail.add_theme_font_size_override("normal_font_size", 16)
	_detail.add_theme_font_size_override("bold_font_size", 16)
	frame.add_child(_detail)
	body.add_child(frame)
	return page

# ---------------------------------------------------------------- estado e navegação

func current_tab() -> int:
	return _tab

func current_category() -> int:
	return _category

func cycle_tab(d: int) -> void:
	set_tab(posmod(_tab + d, TAB_NAMES.size()))

func set_tab(i: int) -> void:
	_tab = clampi(i, 0, TAB_NAMES.size() - 1)
	for k in _tab_buttons.size():
		(_tab_buttons[k] as Button).set_pressed_no_signal(k == _tab)
	for k in _pages.size():
		(_pages[k] as Control).visible = k == _tab
	if _tab == 1:
		_fill_catalog()
	elif _tab == 2:
		options.refresh()
	tab_changed.emit(_tab)

func set_category(i: int) -> void:
	_category = clampi(i, 0, Catalog.CATEGORIES.size() - 1)
	_fill_catalog()

## Ao abrir a pausa: volta à aba Jogo e guarda o que apareceu nesta run (marca "visto agora" no catálogo).
func show_menu(battle: Battle) -> void:
	_run_codex = battle.codex if battle != null else {}
	set_tab(0)

func _input(ev: InputEvent) -> void:
	if handle_input(ev):
		get_viewport().set_input_as_handled()

## Q/E e LB/RB trocam de aba quando nada está por cima. Devolve verdadeiro se tratou o evento.
func handle_input(ev: InputEvent) -> bool:
	if not is_visible_in_tree() or is_blocked.call():
		return false
	var d := UiKit.tab_step(ev)
	if d == 0:
		return false
	cycle_tab(d)
	return true

func _update_hints() -> void:
	UiKit.update_tab_hints(_previous_hint, _next_hint)

# ---------------------------------------------------------------- catálogo

func _fill_catalog() -> void:
	if _grid == null:
		return
	var profile_codex: Dictionary = Game.profile.data.codex
	for i in _cat_buttons.size():
		var cat: String = Catalog.CATEGORIES[i]
		var n := Catalog.counts(cat, profile_codex, _run_codex)
		(_cat_buttons[i] as Button).text = "%s  %d/%d" % [Catalog.LABELS[cat], n.known, n.total]
		(_cat_buttons[i] as Button).set_pressed_no_signal(i == _category)
	for c in _grid.get_children():
		_grid.remove_child(c)
		c.queue_free()
	var cat_id: String = Catalog.CATEGORIES[_category]
	var first: Button = null
	for e in Catalog.entries(cat_id, profile_codex, _run_codex):
		var b := Button.new()
		b.custom_minimum_size = CELL
		b.expand_icon = true
		b.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		b.add_theme_constant_override("icon_max_width", 48)
		b.tooltip_text = String(e.name)
		var border := UiKit.GOLD if bool(e.seen_run) else (UiKit.GOLD_DIM if bool(e.known) else UiKit.IRON)
		b.add_theme_stylebox_override("normal", UiKit.box(Color(0.08, 0.07, 0.1, 0.9) if bool(e.known) else Color(0.04, 0.04, 0.05, 0.9), border, 2 if bool(e.seen_run) else 1, 4))
		b.add_theme_stylebox_override("hover", UiKit.box(Color(0.16, 0.14, 0.2, 0.95), UiKit.GOLD, 2, 4))
		b.add_theme_stylebox_override("focus", UiKit.box(Color(0.16, 0.14, 0.2, 0.95), UiKit.GOLD, 3, 4))
		if bool(e.known):
			var icon: Texture2D = load(String(e.icon)) if ResourceLoader.exists(String(e.icon)) else null
			if icon != null:
				b.icon = icon
			else:
				b.text = String(e.name).substr(0, 2)
		else:
			b.text = "?"
			b.modulate = Color(0.55, 0.55, 0.6)
		var show := _show_detail.bind(cat_id, String(e.id), bool(e.known), bool(e.seen_run))
		b.pressed.connect(show)
		b.focus_entered.connect(show)
		b.mouse_entered.connect(show)
		_grid.add_child(b)
		if first == null:
			first = b
	_detail.text = DETAIL_PLACEHOLDER

func _show_detail(category: String, id: String, known: bool, seen_run: bool) -> void:
	var text := Catalog.detail(category, id, known)
	if known and seen_run:
		text += "\n\n[color=#e0c070]Visto nesta run.[/color]"
	_detail.text = text

## Primeira célula da grade (para o HUD dar foco ao abrir a aba por controle).
func first_cell() -> Control:
	return _grid.get_child(0) if _grid != null and _grid.get_child_count() > 0 else null

## Move um nó (e seus filhos) para outro pai preservando o dono da cena: sem isso os nomes únicos (`%ResumeBtn`...) deixam de ser achados.
static func _move(node: Node, new_parent: Node) -> void:
	var scene_owner := node.owner
	var owned: Array = []
	_collect_owned(node, scene_owner, owned)
	node.reparent(new_parent)
	if scene_owner != null:
		for n in owned:
			n.owner = scene_owner

static func _collect_owned(node: Node, scene_owner: Node, into: Array) -> void:
	if node.owner == scene_owner:
		into.append(node)
	for c in node.get_children():
		_collect_owned(c, scene_owner, into)
