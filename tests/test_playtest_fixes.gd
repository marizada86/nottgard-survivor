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

