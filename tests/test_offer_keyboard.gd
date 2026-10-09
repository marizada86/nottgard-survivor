extends RefCounted
## MEC-001 (SPEC-156): decisões da run só com o teclado. W/S (e A/D) movem o foco entre as opções, Enter confirma o botão focado
## e 1 a 9 escolhem direto (já existia). Opções travadas (sem moeda) nunca recebem o foco.

const HudScript := preload("res://ui/hud.gd")

func _focused_index(hud: Node) -> int:
	var owner: Control = hud.get_viewport().gui_get_focus_owner()
	var i := 0
	for c in hud.offer_box.get_children():
		if c == owner:
			return i
		i += 1
	return -1

func run() -> Array:
	var out: Array = []
	_keys(out)
	var tree := Engine.get_main_loop() as SceneTree
	_levelup(out, tree)
	_shop(out, tree)
	return out

func _keys(out: Array) -> void:
	for pair in [[KEY_W, -1], [KEY_A, -1], [KEY_S, 1], [KEY_D, 1], [KEY_UP, 0], [KEY_ENTER, 0], [KEY_1, 0], [KEY_Q, 0]]:
		if HudScript.offer_key_step(pair[0]) != pair[1]:
			out.append("a tecla %s deveria mover o foco %d (moveu %d)" % [OS.get_keycode_string(pair[0]), pair[1], HudScript.offer_key_step(pair[0])])

func _levelup(out: Array, tree: SceneTree) -> void:
	var hud: Node = load("res://ui/hud.tscn").instantiate()
	tree.root.add_child(hud)
	var b := Battle.new(42, "durvall", "dagruve")
	b._open_levelup()
	hud.show_offer(b)
	var buttons: Array = []   # índices dos botões entre os filhos (os detalhes ficam em outros nós)
	var k := 0
	for c in hud.offer_box.get_children():
		if c is Button:
			buttons.append(k)
		k += 1
	var n: int = buttons.size()
	if n < 2:
		out.append("a oferta de nível deveria ter ao menos 2 opções (%d)" % n)
		hud.free()
		return
	if _focused_index(hud) != buttons[0]:
		out.append("a primeira opção deveria nascer focada (%d)" % _focused_index(hud))
	var seq: Array = []
	for i in n:
		hud.offer_focus_step(1)
		seq.append(_focused_index(hud))
	var want: Array = []
	for i in n:
		want.append(buttons[(i + 1) % n])
	if seq != want:
		out.append("S deveria percorrer as opções e voltar ao início (%s, esperado %s)" % [str(seq), str(want)])
	hud.offer_focus_step(-1)
	if _focused_index(hud) != buttons[n - 1]:
		out.append("W deveria voltar uma opção (%d)" % _focused_index(hud))
	# Enter (ui_accept) confirma o botão focado
	var chosen: Array = []
	hud.offer_chosen.connect(func(i): chosen.append(i))
	var focused: int = _focused_index(hud)
	(hud.offer_box.get_child(focused) as Button).pressed.emit()
	if chosen != [focused]:
		out.append("confirmar o botão focado deveria escolher a opção %d (%s)" % [focused, str(chosen)])
	hud.free()

func _shop(out: Array, tree: SceneTree) -> void:
	var hud: Node = load("res://ui/hud.tscn").instantiate()
	tree.root.add_child(hud)
	var b := Battle.new(43, "durvall", "dagruve")
	b.hero.gold = 0
	b._open_shop_event("ferreiro")
	hud.show_offer(b)
	var locked: Array = []
	var i := 0
	for c in hud.offer_box.get_children():
		if c is Button and (c as Button).disabled:
			locked.append(i)
		i += 1
	for step in range(1, 8):
		if hud.offer_focus_step(1) and _focused_index(hud) in locked:
			out.append("a opção travada %d recebeu o foco no passo %d" % [_focused_index(hud), step])
	hud.free()
