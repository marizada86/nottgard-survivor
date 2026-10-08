extends RefCounted
## SPEC-147: correções dos playtests v0.3.2 (Manzi) e v0.3.3 (Daniel).

func _key(code: Key) -> InputEventKey:
	var k := InputEventKey.new()
	k.physical_keycode = code
	k.keycode = code
	k.pressed = true
	return k

func run() -> Array:
	var out: Array = []
	out.append_array(_entrada())
	out.append_array(_topo())
	out.append_array(_estige())
	return out

## B-001: C fecha a ficha; a ficha abre nas ofertas; a nota (F5) prende a HUD.
func _entrada() -> Array:
	var out: Array = []
	var tree := Engine.get_main_loop() as SceneTree
	var b := Battle.new(3, "sylas", "dagruve")
	var hud: Node = load("res://ui/hud.tscn").instantiate()
	tree.root.add_child(hud)
	hud.update_stats(b)
	var closed := [0]
	var opened := [0]
	hud.items_closed.connect(func(): closed[0] += 1)
	hud.pause_items_pressed.connect(func(): opened[0] += 1)

	# S-001: com a ficha aberta, C pede o fechamento (BUG-003)
	hud.show_items_panel(b)
	hud._unhandled_input(_key(KEY_C))
	if closed[0] != 1:
		out.append("C não fechou a ficha (fechamentos: %d)" % closed[0])
	if opened[0] != 0:
		out.append("C com a ficha aberta não pode pedir para abrir a ficha de novo")
	hud.hide_items_panel()

	# S-002: numa oferta (level-up, altar, item, loja) C abre a ficha; com ela aberta, fecha
	closed[0] = 0
	opened[0] = 0
	hud.levelup_panel.visible = true
	hud._unhandled_input(_key(KEY_C))
	if opened[0] != 1:
		out.append("C numa oferta não pediu a ficha (pedidos: %d)" % opened[0])
	hud.show_items_panel(b)
	hud._unhandled_input(_key(KEY_C))
	if closed[0] != 1 or opened[0] != 1:
		out.append("C na ficha aberta sobre uma oferta deve só fechar (fechou %d, abriu %d)" % [closed[0], opened[0]])
	hud.hide_items_panel()
	hud.levelup_panel.visible = false

	# S-003: com a nota, o guia ou a Central abertos a HUD não reage e conta como modal
	var was_open: bool = Playtest._note_open
	Playtest._note_open = true
	Playtest._refresh_shade()
	closed[0] = 0
	opened[0] = 0
	hud.show_items_panel(b)
	hud._unhandled_input(_key(KEY_C))
	hud._unhandled_input(_key(KEY_ESCAPE))
	if closed[0] != 0:
		out.append("com o bloco de notas aberto, a HUD não pode fechar a ficha")
	hud.hide_items_panel()
	hud.levelup_panel.visible = true
	hud._unhandled_input(_key(KEY_C))
	hud.levelup_panel.visible = false
	if opened[0] != 0:
		out.append("com o bloco de notas aberto, C não pode abrir a ficha por trás")
	if not hud.has_modal():
		out.append("has_modal() deve valer com o bloco de notas aberto")
	var shade: ColorRect = Playtest._overlay_shade
	if shade == null or not shade.visible or shade.mouse_filter != Control.MOUSE_FILTER_STOP:
		out.append("o bloco de notas precisa de um fundo que absorva o mouse")
	Playtest._note_open = was_open
	Playtest._refresh_shade()
	if Playtest._overlay_shade.visible and not Playtest.is_overlay_open():
		out.append("o fundo do bloco de notas deve sumir quando nada está aberto")
	if hud.has_modal() and not Playtest.is_overlay_open():
		out.append("has_modal() não deve valer sem painel aberto")
	hud.free()
	return out

## B-002 S-004: o topo central empilha chefe, quests, status e avisos sem interseção, em qualquer quantidade de linhas.
func _topo() -> Array:
	var out: Array = []
	var tree := Engine.get_main_loop() as SceneTree
	for count in [0, 1, 3, 6]:
		var b := Battle.new(3, "sylas", "dagruve")
		var hud: Node = load("res://ui/hud.tscn").instantiate()
		tree.root.add_child(hud)
		b.happenings.objectives.clear()
		for i in count:
			b.happenings.objectives.append(_objective(i))
		hud.update_stats(b)
		hud.boss_panel.visible = true
		hud.objective_label.text = "a\nb\nc\nd"
		hud.objective_label.visible = true
		for i in 4:
			hud.toast("Aviso %d com texto bem comprido para quebrar a linha na largura do bloco de avisos do topo da tela" % i)
		var stack: VBoxContainer = hud.top_stack
		stack.notification(Container.NOTIFICATION_SORT_CHILDREN)
		var rects: Array = []
		for c in stack.get_children():
			if (c as Control).visible:
				rects.append([c.name, (c as Control).get_rect()])
		for i in rects.size():
			for j in range(i + 1, rects.size()):
				if (rects[i][1] as Rect2).intersects(rects[j][1]):
					out.append("topo com %d objetivos: %s e %s se sobrepõem (%s / %s)" % [count, rects[i][0], rects[j][0], rects[i][1], rects[j][1]])
		if count > 0 and not hud.quest_panel.visible:
			out.append("com %d objetivos o painel de quests deve aparecer" % count)
		if count == 0 and hud.quest_panel.visible:
			out.append("sem objetivos o painel de quests não deve aparecer")
		if count == 6 and hud.quest_panel._rows.get_child_count() != QuestPanel.MAX_ROWS + 1:
			out.append("6 objetivos devem mostrar %d linhas e um '+N' (viu %d filhos)" % [QuestPanel.MAX_ROWS, hud.quest_panel._rows.get_child_count()])
		# o que não é aviso passageiro (chefe, quests, status) não pode passar de 60% da altura de 720 px com até 3 objetivos
		var fixed_bottom := stack.position.y
		for r in rects:
			if r[0] != "ToastBox":
				fixed_bottom = maxf(fixed_bottom, stack.position.y + (r[1] as Rect2).end.y)
		if count <= 3 and fixed_bottom > 720.0 * 0.6:
			out.append("chefe, quests e status ocupam demais a tela com %d objetivos (até y=%.0f)" % [count, fixed_bottom])
		hud.free()
	return out

## B-002 S-007: o Estige vira um indicador de estado na HUD (IN-064).
func _estige() -> Array:
	var out: Array = []
	var tree := Engine.get_main_loop() as SceneTree
	var b := Battle.new(3, "sylas", "durao")
	var hud: Node = load("res://ui/hud.tscn").instantiate()
	tree.root.add_child(hud)
	hud.update_stats(b)
	if hud.status_chip.visible:
		out.append("fora da água e sem Esquecimento o indicador do Estige deve estar escondido")
	b.styx_exposure = 2.5
	hud.update_stats(b)
	if not hud.status_chip.visible or hud.status_chip.kind != "water" or hud.status_chip._text.text.find("2.5") < 0 or hud.status_chip.tooltip_text == "":
		out.append("na água o indicador deve mostrar o tempo (2.5 s), a INT efetiva e uma dica")
	b.styx_exposure = 0.0
	b.hero.styx_forget_t = 4.0
	hud.update_stats(b)
	if not hud.status_chip.visible or hud.status_chip.kind != "forget":
		out.append("com Esquecimento o indicador deve aparecer como 'forget'")
	b.hero.styx_forget_t = 0.0
	hud.update_stats(b)
	if hud.status_chip.visible:
		out.append("o indicador deve sumir quando o Esquecimento acaba")
	var plain := Battle.new(3, "sylas", "dagruve")
	plain.styx_exposure = 3.0
	if not hud.styx_status(plain).is_empty():
		out.append("fases sem o contrato do Estige não mostram o indicador")
	hud.free()
	return out

