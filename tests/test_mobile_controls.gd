extends RefCounted

func run() -> Array:
	var out: Array = []
	var old_preview := Game.touch_preview
	var old_aim: String = Game.profile.data.settings.aim
	Game.touch_preview = true
	Game.profile.data.settings.aim = "mouse"
	if Game.aim_mode() != Battle.Aim.AUTO or Game.profile.data.settings.aim != "mouse":
		out.append("mira de toque deve ser automática sem mudar preferência salva")
	var tree := Engine.get_main_loop() as SceneTree
	var controls := MobileControls.new()
	tree.root.add_child(controls)
	controls.set_combat_enabled(true)
	var commands: Array = []
	controls.command.connect(func(action): commands.append(action))
	var start := Vector2(180, 500)
	if not controls.press(1, start, true):
		out.append("toque em arena esquerda não capturou movimento")
	controls.drag(1, start + Vector2(100, 100))
	if controls.movement.length() > 1.001 or controls.movement.length() < 0.99:
		out.append("diagonal deve limitar intensidade a 1")
	var origin := controls.origin
	var movement := controls.movement
	controls.press(2, controls.regions[&"hero_active"].get_center(), false)
	controls.drag(2, Vector2(10, 10))
	if commands != [&"hero_active"] or controls.origin != origin or controls.movement != movement:
		out.append("segundo dedo deveria usar habilidade sem mudar o joystick")
	controls.press(2, controls.regions[&"hero_active"].get_center(), false)
	if commands.size() != 1:
		out.append("mesmo toque ativou habilidade mais de uma vez")
	controls.release(2)
	if controls.movement != movement:
		out.append("soltar habilidade interrompeu movimento")
	controls.release(1)
	if controls.movement != Vector2.ZERO:
		out.append("soltura do joystick deixou movimento preso")
	var arena := Game.touch_safe_rect()
	var right := arena.position + arena.size * Vector2(0.75, 0.6)
	if not controls.press(8, right, true) or controls.movement_finger != 8:
		out.append("arena direita deve iniciar o mesmo joystick de movimento")
	controls.drag(8, right + Vector2(-90, 0))
	if controls.movement.x > -0.99:
		out.append("joystick iniciado a direita nao move para a esquerda")
	controls.press(9, start, true)
	if controls.movement_finger != 8 or controls.origin != right:
		out.append("segundo dedo roubou joystick iniciado a direita")
	controls.release(8)
	if controls.movement != Vector2.ZERO:
		out.append("soltar joystick direito deixou movimento preso")
	for action in controls.regions:
		controls.clear_input()
		controls.labels[action] = "Teste"
		var before := commands.size()
		controls.press(10, controls.regions[action].get_center(), true)
		controls.press(10, controls.regions[action].get_center(), true)
		if commands.size() != before + 1 or commands.back() != action or controls.movement_finger != -1:
			out.append("botao %s falhou ou iniciou joystick" % action)
		controls.release(10)
	controls.clear_input()
	controls.press(3, start, true)
	controls.drag(3, start + Vector2(2, 2))
	if controls.movement != Vector2.ZERO:
		out.append("zona morta não elimina movimento pequeno")
	controls.set_combat_enabled(false)
	controls.set_combat_enabled(true)
	controls.drag(3, start + Vector2(100, 0))
	if controls.movement != Vector2.ZERO:
		out.append("fechar modal reutilizou dedo antigo")
	controls.press(5, start, false)
	if controls.movement_finger != -1:
		out.append("toque consumido pela UI iniciou joystick")
	for canvas in [Rect2(16, 16, 1248, 688), Rect2(56, 16, 1568, 688), Rect2(16, 48, 1248, 864)]:
		controls.layout_controls(canvas)
		for rect in controls.regions.values():
			if not canvas.encloses(rect):
				out.append("comando saiu da área segura")
	controls.free()
	var hud: Node = load("res://ui/hud.tscn").instantiate()
	tree.root.add_child(hud)
	var battle := Battle.new(42, "durvall", "dagruve")
	battle._open_levelup()
	hud.show_offer(battle)
	var chosen: Array = []
	hud.offer_chosen.connect(func(i): chosen.append(i))
	hud._select_offer(0)
	if not chosen.is_empty():
		out.append("seleção de carta aplicou oferta antes da confirmação")
	hud._confirm_offer()
	hud._confirm_offer()
	if chosen != [0]:
		out.append("confirmação não aplicou exatamente uma oferta")
	hud.show_offer(battle)
	if hud._offer_selected != -1 or not hud._offer_confirm.disabled:
		out.append("nova oferta reutilizou escolha anterior")
	hud.free()
	_test_touch_list(tree, out)
	Game.profile.data.settings.aim = old_aim
	Game.touch_preview = old_preview
	if not Game.touch_controls_enabled():
		var desktop: Node = load("res://ui/hud.tscn").instantiate()
		tree.root.add_child(desktop)
		desktop.show_offer(battle)
		var desktop_choices: Array = []
		desktop.offer_chosen.connect(func(i): desktop_choices.append(i))
		desktop.offer_box.get_child(0).pressed.emit()
		if desktop_choices != [0] or desktop.mobile != null:
			out.append("desktop perdeu escolha direta ou recebeu controles de toque")
		desktop.free()
	return out

func _test_touch_list(tree: SceneTree, out: Array) -> void:
	var root := Control.new()
	root.size = Vector2(1280, 720)
	tree.root.add_child(root)
	var scroll := ScrollContainer.new()
	scroll.position = Vector2(40, 40)
	scroll.size = Vector2(300, 180)
	root.add_child(scroll)
	var box := VBoxContainer.new()
	box.custom_minimum_size = Vector2(280, 500)
	scroll.add_child(box)
	var button := Button.new()
	button.text = "Comprar"
	button.custom_minimum_size = Vector2(200, 60)
	box.add_child(button)
	var router := TouchUI.new()
	router.ui_root = root
	root.add_child(router)
	# Medidas explícitas porque o runner é síncrono, sem esperar layout de container.
	box.position = Vector2.ZERO
	button.position = Vector2.ZERO
	button.size = Vector2(200, 60)
	var clicks: Array = []
	button.pressed.connect(func(): clicks.append(true))
	var point := button.global_position + Vector2(30, 30)
	router.begin_touch(0, point)
	router.move_touch(0, point + Vector2(0, 30))
	router.end_touch(0, point + Vector2(0, 30))
	if not clicks.is_empty():
		out.append("arrastar lista acionou compra")
	router.begin_touch(1, point)
	router.end_touch(1, point)
	if clicks.size() != 1:
		out.append("toque simples deveria acionar uma compra")
	var emulated := InputEventMouseButton.new()
	emulated.device = InputEvent.DEVICE_ID_EMULATION
	emulated.pressed = false
	router._input(emulated)
	if clicks.size() != 1:
		out.append("mouse emulado duplicou comando")
	var previous_guide := Playtest._guide_open
	Playtest._guide_open = true
	var modal_touch := InputEventScreenTouch.new()
	modal_touch.index = 2
	modal_touch.position = point
	modal_touch.pressed = true
	router._input(modal_touch)
	if router._gestures.has(2):
		out.append("interface atras da ajuda capturou toque do modal global")
	Playtest._guide_open = previous_guide
	root.free()
