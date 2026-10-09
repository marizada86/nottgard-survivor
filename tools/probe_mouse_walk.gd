extends Node
## PLAN-090 (BUG-007): quais controles da HUD seguram o mouse numa run normal (gui_get_hovered_control).
## godot --path . res://tools/probe_mouse_walk.tscn --resolution 1280x720

func _hover(p: Vector2) -> String:
	Input.warp_mouse(p)
	var ev := InputEventMouseMotion.new()
	ev.position = p
	ev.global_position = p
	Input.parse_input_event(ev)
	await get_tree().process_frame
	await get_tree().process_frame
	var c := get_viewport().gui_get_hovered_control()
	return "(%d,%d) -> %s" % [p.x, p.y, "nada" if c == null else "%s [%s, filtro %d]" % [c.get_path(), c.get_class(), c.mouse_filter]]

func _ready() -> void:
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345}
	Game.run_stage = "dagruve"
	Game.run_hero = "sylas"
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	await get_tree().create_timer(0.8).timeout
	run.set_process(false)
	run.set_physics_process(false)
	for p in [Vector2(640, 360), Vector2(900, 500), Vector2(1190, 36), Vector2(1245, 36), Vector2(200, 60), Vector2(200, 110), Vector2(640, 30), Vector2(100, 700), Vector2(640, 640)]:
		print("PROBE ", await _hover(p))
	# integração: com a física ligada, segurar o botão esquerdo sobre a HUD não move o herói; no mundo, move
	var b: Battle = run.battle
	b.stage.waves = []
	b.stage.elites = []
	b._inter_t = 99999.0
	b._breakable_t = 99999.0
	run.set_process(true)
	run.set_physics_process(true)
	for case in [["sobre o botao 1x", Vector2(1190, 36)], ["sobre o painel do heroi", Vector2(200, 110)], ["no mundo, a leste", Vector2(1000, 400)]]:
		var from := Vector2(b.hero.pos)
		var p: Vector2 = case[1]
		Input.warp_mouse(p)
		var mv := InputEventMouseMotion.new()
		mv.position = p
		mv.global_position = p
		Input.parse_input_event(mv)
		var down := InputEventMouseButton.new()
		down.button_index = MOUSE_BUTTON_LEFT
		down.pressed = true
		down.position = p
		down.global_position = p
		Input.parse_input_event(down)
		for i in 30:
			await get_tree().physics_frame
		var moved := b.hero.pos.distance_to(from)
		print("PROBE walk ", case[0], ": over_ui=", run.hud.pointer_over_ui(), " mouse_left=", Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT), " moveu=", snappedf(moved, 0.01))
		var up := InputEventMouseButton.new()
		up.button_index = MOUSE_BUTTON_LEFT
		up.pressed = false
		up.position = p
		up.global_position = p
		Input.parse_input_event(up)
		await get_tree().process_frame
	get_tree().quit()
