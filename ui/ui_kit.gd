class_name UiKit
extends RefCounted
## SPEC-165 (MEC-003): o padrão visual da ficha C (SPEC-130) num lugar só, para as telas do jogo falarem a mesma língua.
## Tudo aqui é extraído da ficha C sem mudar o que o jogador vê; o menu de pausa novo (`PauseMenu`) e as próximas telas usam o kit.
## Recursos de arte são os já admitidos em `SheetArt` (assets/ui/ficha): nenhuma arte nova.

const GOLD := Color(0.93, 0.78, 0.4)
const GOLD_DIM := Color(0.62, 0.5, 0.28)
const IRON := Color(0.36, 0.35, 0.42)
const MUTED := Color(0.62, 0.62, 0.68)
const TEXT := Color(0.92, 0.9, 0.86)
const WINDOW_SIZE := Vector2(1088, 612)       # janela padrão (1280×720)
const WINDOW_SIZE_TOUCH := Vector2(1088, 650) # no toque os botões pedem mais altura
const TAB_HEIGHT := 40.0
const TAB_FONT := 14
const HINT_SIZE := Vector2(52, 32)

static func box(bg: Color, border: Color, width: int, radius: int) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = bg
	sb.border_color = border
	sb.set_border_width_all(width)
	sb.set_corner_radius_all(radius)
	return sb

static func label(text: String, size: int, color: Color = TEXT) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	return l

## Escurece o que está atrás de uma janela modal; não captura o mouse.
static func dim() -> ColorRect:
	var d := ColorRect.new()
	d.color = Color(0, 0, 0, 0.7)
	d.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	d.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return d

## Painel da janela padrão: fundo de textura e moldura desenhada por cima do fundo, atrás do conteúdo.
static func window(size: Vector2) -> PanelContainer:
	var panel := PanelContainer.new()
	apply_window(panel, size)
	return panel

## Dá a um painel que já existe (como o `PausePanel` da HUD) o estilo da janela padrão.
static func apply_window(panel: PanelContainer, size: Vector2) -> void:
	panel.custom_minimum_size = size
	panel.add_theme_stylebox_override("panel", SheetArt.background())
	panel.draw.connect(func(): panel.draw_texture_rect(SheetArt.PANEL, Rect2(Vector2.ZERO, panel.size), false))

## Moldura do detalhe e margem padrão (a mesma da ficha C).
static func detail_frame() -> PanelContainer:
	var frame := PanelContainer.new()
	frame.add_theme_stylebox_override("panel", SheetArt.detail())
	return frame

static func margin(all := 40) -> MarginContainer:
	var m := MarginContainer.new()
	for side in ["left", "right", "top", "bottom"]:
		m.add_theme_constant_override("margin_" + side, all)
	return m

## Botão de aba exatamente como o da ficha C. `icon` pode ser nulo (a pausa não tem ícones de aba).
static func tab_button(text: String, tooltip: String, icon: Texture2D, group: ButtonGroup) -> Button:
	var tb := Button.new()
	tb.text = text
	tb.tooltip_text = tooltip
	if icon != null:
		tb.icon = icon
		tb.expand_icon = true
		tb.add_theme_constant_override("icon_max_width", 28)
	tb.custom_minimum_size = Vector2(0, TAB_HEIGHT)
	tb.toggle_mode = true
	tb.button_group = group
	tb.focus_mode = Control.FOCUS_NONE
	tb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tb.add_theme_font_size_override("font_size", TAB_FONT)
	tb.add_theme_stylebox_override("normal", SheetArt.frame(SheetArt.TAB, 12, 8))
	tb.add_theme_stylebox_override("hover", SheetArt.frame(SheetArt.TAB, 12, 8, Color(1.15, 1.1, 0.9)))
	tb.add_theme_stylebox_override("pressed", SheetArt.frame(SheetArt.TAB, 12, 8, Color(1.55, 1.25, 0.6)))
	tb.add_theme_stylebox_override("hover_pressed", SheetArt.frame(SheetArt.TAB, 12, 8, Color(1.65, 1.35, 0.7)))
	tb.add_theme_color_override("font_pressed_color", GOLD)
	return tb

## Botão de dica de troca de aba (◂ Q / E ▸ ou L1/R1); não recebe foco.
static func hint_button() -> Button:
	var b := Button.new()
	b.flat = true
	b.custom_minimum_size = HINT_SIZE
	b.expand_icon = false
	b.focus_mode = Control.FOCUS_NONE
	return b

## Atualiza os dois botões de dica com o ícone e o texto do controle em uso.
static func update_tab_hints(previous: Button, next: Button) -> void:
	if previous == null or next == null:
		return
	previous.text = "◂" if Game.controls.is_controller() else "◂ Q"
	previous.icon = Game.controls.glyph("tab_previous")
	previous.add_theme_constant_override("icon_max_width", 32)
	next.text = "▸" if Game.controls.is_controller() else "E ▸"
	previous.tooltip_text = Game.controls.prompt("tab_previous", "Q") + " — Aba anterior"
	next.tooltip_text = Game.controls.prompt("tab_next", "E") + " — Próxima aba"
	next.icon = Game.controls.glyph("tab_next")
	next.add_theme_constant_override("icon_max_width", 32)

## Troca de aba por teclado (Q/E) ou controle (LB/RB): -1, +1 ou 0 se o evento não é de troca.
static func tab_step(ev: InputEvent) -> int:
	if ev is InputEventKey and ev.pressed and not ev.echo:
		if ev.keycode == KEY_Q:
			return -1
		if ev.keycode == KEY_E:
			return 1
	elif ev is InputEventJoypadButton and ev.pressed:
		if ev.button_index == JOY_BUTTON_LEFT_SHOULDER:
			return -1
		if ev.button_index == JOY_BUTTON_RIGHT_SHOULDER:
			return 1
	return 0

## SPEC-166 (MEC-003 lote 2): o padrão da ficha C num `TabContainer` nativo (o Quartel): abas com a moldura da ficha e painel
## de conteúdo com a moldura de detalhe. Só o estilo muda: nomes de nós, ordem das abas e navegação seguem os mesmos.
static func style_tab_container(tabs: TabContainer) -> void:
	# os itens de tema das abas pertencem ao TabContainer (que os repassa ao TabBar interno)
	var bar := tabs.get_tab_bar()
	for node in [tabs, bar]:
		node.add_theme_stylebox_override("tab_unselected", SheetArt.frame(SheetArt.TAB, 12, 8))
		node.add_theme_stylebox_override("tab_hovered", SheetArt.frame(SheetArt.TAB, 12, 8, Color(1.15, 1.1, 0.9)))
		node.add_theme_stylebox_override("tab_selected", SheetArt.frame(SheetArt.TAB, 12, 8, Color(1.55, 1.25, 0.6)))
		node.add_theme_stylebox_override("tab_focus", box(Color(0, 0, 0, 0), GOLD, 2, 4))
		node.add_theme_color_override("font_selected_color", GOLD)
		node.add_theme_color_override("font_unselected_color", TEXT)
		node.add_theme_color_override("font_hovered_color", Color(1.0, 0.95, 0.8))
		node.add_theme_font_size_override("font_size", 16)
	# painel de conteúdo discreto (fundo escuro e borda fina): as molduras ornamentadas ficam nos detalhes, sem moldura dentro de moldura
	var panel := box(Color(0.045, 0.04, 0.065, 0.84), GOLD_DIM, 2, 6)
	panel.set_content_margin_all(14)
	tabs.add_theme_stylebox_override("panel", panel)

## Lista (`ItemList`) no padrão: fundo escuro, borda de ouro apagado e seleção dourada.
static func style_list(list: ItemList) -> void:
	list.add_theme_stylebox_override("panel", box(Color(0.06, 0.05, 0.08, 0.88), GOLD_DIM, 1, 4))
	list.add_theme_stylebox_override("focus", box(Color(0, 0, 0, 0), GOLD, 2, 4))
	list.add_theme_stylebox_override("selected", box(Color(0.33, 0.26, 0.1, 0.9), GOLD_DIM, 1, 3))
	list.add_theme_stylebox_override("selected_focus", box(Color(0.45, 0.35, 0.13, 0.95), GOLD, 2, 3))
	list.add_theme_color_override("font_selected_color", Color(1.0, 0.93, 0.72))

## Texto rico de detalhe (herói, fase, códex, diário) dentro da moldura de detalhe.
## O `RichTextLabel` só recua o início do texto pelas margens do estilo e não recorta nelas: ao rolar, o texto passava por cima da
## moldura (BUG-040). Por isso a moldura fica num `PanelContainer` pai e o texto, recortado ao próprio retângulo, dentro das margens.
## Sem pai (nó solto), mantém a moldura no próprio texto.
static func style_text(text: RichTextLabel) -> void:
	var parent := text.get_parent()
	if parent == null:
		text.add_theme_stylebox_override("normal", SheetArt.detail())
		text.add_theme_stylebox_override("focus", SheetArt.detail(SheetArt.DETAIL_PADDING, Color(1.3, 1.15, 0.8)))
		return
	var frame := PanelContainer.new()
	frame.name = "%sFrame" % text.name
	frame.add_theme_stylebox_override("panel", SheetArt.detail())
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.size_flags_horizontal = text.size_flags_horizontal
	frame.size_flags_vertical = text.size_flags_vertical
	frame.size_flags_stretch_ratio = text.size_flags_stretch_ratio
	frame.custom_minimum_size = text.custom_minimum_size
	text.custom_minimum_size = Vector2.ZERO
	var index := text.get_index()
	parent.add_child(frame)
	parent.move_child(frame, index)
	text.reparent(frame, false)
	text.clip_contents = true
	text.size_flags_horizontal = Control.SIZE_FILL | Control.SIZE_EXPAND
	text.size_flags_vertical = Control.SIZE_FILL | Control.SIZE_EXPAND
	text.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
	text.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	# o foco aparece como antes: a moldura clareia
	text.focus_entered.connect(func(): frame.self_modulate = Color(1.3, 1.15, 0.8))
	text.focus_exited.connect(func(): frame.self_modulate = Color.WHITE)
