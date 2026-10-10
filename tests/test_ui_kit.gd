extends RefCounted
## SPEC-165 (MEC-003): o UiKit guarda o padrão visual da ficha C; estes valores não podem mudar sem querer.

func _key(code: int, pressed := true, echo := false) -> InputEventKey:
	var ev := InputEventKey.new()
	ev.keycode = code
	ev.pressed = pressed
	ev.echo = echo
	return ev

func _pad(button: int) -> InputEventJoypadButton:
	var ev := InputEventJoypadButton.new()
	ev.button_index = button
	ev.pressed = true
	return ev

func run() -> Array:
	var out: Array = []

	# valores da ficha C (SPEC-130, aceitos pelo dono em 2026-10-06): a ficha usa o kit, então os dois têm de ser iguais
	if UiKit.GOLD != Color(0.93, 0.78, 0.4) or UiKit.GOLD_DIM != Color(0.62, 0.5, 0.28) or UiKit.IRON != Color(0.36, 0.35, 0.42) or UiKit.MUTED != Color(0.62, 0.62, 0.68) or UiKit.TEXT != Color(0.92, 0.9, 0.86):
		out.append("a paleta do UiKit mudou em relação à ficha C")
	if UiKit.WINDOW_SIZE != Vector2(1088, 612) or UiKit.WINDOW_SIZE_TOUCH != Vector2(1088, 650):
		out.append("tamanho da janela padrão mudou")
	if CharacterSheet.GOLD != UiKit.GOLD or CharacterSheet.GOLD_DIM != UiKit.GOLD_DIM or CharacterSheet.IRON != UiKit.IRON or CharacterSheet.MUTED != UiKit.MUTED or CharacterSheet.PANEL_SIZE != UiKit.WINDOW_SIZE:
		out.append("a ficha C deveria tirar paleta e tamanho do UiKit")

	# caixa e rótulo
	var sb := UiKit.box(Color(0.1, 0.2, 0.3), Color(0.9, 0.8, 0.1), 2, 5)
	if sb.bg_color != Color(0.1, 0.2, 0.3) or sb.border_color != Color(0.9, 0.8, 0.1) or sb.border_width_left != 2 or sb.corner_radius_top_left != 5:
		out.append("UiKit.box não aplicou fundo, borda ou raio")
	var lb := UiKit.label("Oi", 18, Color(1, 0, 0))
	if lb.text != "Oi" or lb.get_theme_font_size("font_size") != 18 or lb.get_theme_color("font_color") != Color(1, 0, 0):
		out.append("UiKit.label não aplicou texto, tamanho ou cor")
	lb.free()
	var dflt := UiKit.label("x", 12)
	if dflt.get_theme_color("font_color") != UiKit.TEXT:
		out.append("a cor padrão do rótulo é a do texto da ficha")
	dflt.free()

	# aba: igual à da ficha C (alterna, não toma foco, altura 40, ícone só quando há)
	var group := ButtonGroup.new()
	var tab := UiKit.tab_button("Jogo", "dica", null, group)
	if not tab.toggle_mode or tab.button_group != group or tab.focus_mode != Control.FOCUS_NONE or tab.custom_minimum_size.y != 40.0 or tab.tooltip_text != "dica" or tab.icon != null:
		out.append("a aba sem ícone deveria alternar, não tomar foco e ter 40 px de altura")
	if tab.get_theme_color("font_pressed_color") != UiKit.GOLD or not tab.has_theme_stylebox_override("pressed"):
		out.append("a aba pressionada deveria ficar dourada, com moldura própria")
	tab.free()
	var tab_icon := UiKit.tab_button("Armas", "", SheetArt.TAB_ICONS[0], group)
	if tab_icon.icon != SheetArt.TAB_ICONS[0] or not tab_icon.expand_icon:
		out.append("a aba com ícone deveria mostrá-lo")
	tab_icon.free()
	var hint := UiKit.hint_button()
	if not hint.flat or hint.focus_mode != Control.FOCUS_NONE or hint.custom_minimum_size != Vector2(52, 32):
		out.append("o botão de dica é plano e não toma foco")
	hint.free()
	UiKit.update_tab_hints(null, null)   # sem botões (celular): não pode quebrar

	# troca de aba: Q/E e LB/RB; eco, soltar a tecla e outras teclas não trocam
	if UiKit.tab_step(_key(KEY_Q)) != -1 or UiKit.tab_step(_key(KEY_E)) != 1:
		out.append("Q volta e E avança")
	if UiKit.tab_step(_pad(JOY_BUTTON_LEFT_SHOULDER)) != -1 or UiKit.tab_step(_pad(JOY_BUTTON_RIGHT_SHOULDER)) != 1:
		out.append("LB volta e RB avança")
	if UiKit.tab_step(_key(KEY_E, true, true)) != 0 or UiKit.tab_step(_key(KEY_E, false)) != 0 or UiKit.tab_step(_key(KEY_W)) != 0 or UiKit.tab_step(_pad(JOY_BUTTON_A)) != 0:
		out.append("eco, soltar a tecla e outros botões não trocam de aba")

	# moldura de detalhe (DEV-029): o recorte cobre as estrelas dos cantos e o texto fica além da borda visível (22 px)
	# BUG-040: o texto rico fica num PanelContainer com a moldura e é recortado ao próprio retângulo; senão, ao rolar, passa por cima dela
	var holder := VBoxContainer.new()
	var before := Control.new()
	var rich := RichTextLabel.new()
	rich.custom_minimum_size = Vector2(0, 240)
	rich.size_flags_vertical = Control.SIZE_EXPAND_FILL
	holder.add_child(before)
	holder.add_child(rich)
	UiKit.style_text(rich)
	var wrapper := rich.get_parent() as PanelContainer
	if wrapper == null or wrapper.get_parent() != holder or wrapper.get_index() != 1:
		out.append("o texto rico deveria ganhar um PanelContainer de moldura no mesmo lugar do pai")
	else:
		var framed := wrapper.get_theme_stylebox("panel") as StyleBoxTexture
		if framed == null or framed.texture != SheetArt.DETAIL:
			out.append("a moldura do texto rico deveria ser a de detalhe")
		else:
			for side in [SIDE_LEFT, SIDE_TOP, SIDE_RIGHT, SIDE_BOTTOM]:
				if framed.get_texture_margin(side) < 34.0:
					out.append("o recorte da moldura de detalhe corta as estrelas dos cantos")
					break
				if framed.get_content_margin(side) < 22.0:
					out.append("o texto invade a borda visível da moldura de detalhe")
					break
		if not rich.clip_contents:
			out.append("o texto rico tem de ser recortado ao próprio retângulo (rolar não pode cobrir a moldura)")
		if wrapper.custom_minimum_size != Vector2(0, 240) or wrapper.size_flags_vertical != Control.SIZE_EXPAND_FILL:
			out.append("a moldura deveria herdar o tamanho mínimo e as flags do texto")
		if rich.get_theme_stylebox("normal").get_minimum_size() != Vector2.ZERO:
			out.append("o texto dentro da moldura não deveria ter margem própria")
	holder.free()
	var loose := RichTextLabel.new()
	UiKit.style_text(loose)   # sem pai: não pode quebrar
	if loose.get_theme_stylebox("normal") as StyleBoxTexture == null:
		out.append("o texto solto mantém a moldura no próprio estilo")
	loose.free()
	var detail_frame_node := UiKit.detail_frame()
	var detail_style := detail_frame_node.get_theme_stylebox("panel") as StyleBoxTexture
	if detail_style == null or detail_style.get_texture_margin(SIDE_TOP) < 34.0 or detail_style.get_content_margin(SIDE_TOP) < 22.0:
		out.append("a moldura de detalhe da pausa deveria usar o mesmo recorte e a mesma margem")
	detail_frame_node.free()

	# janela padrão
	var win := UiKit.window(Vector2(800, 500))
	if win.custom_minimum_size != Vector2(800, 500) or not win.has_theme_stylebox_override("panel"):
		out.append("a janela padrão tem o tamanho pedido e o fundo da ficha")
	win.free()
	var m := UiKit.margin(40)
	if m.get_theme_constant("margin_left") != 40 or m.get_theme_constant("margin_bottom") != 40:
		out.append("margem padrão de 40")
	m.free()
	return out
