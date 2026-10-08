extends Node
## SPEC-144 (BUG-028): anda numa run real (mapa, colisão, HeroView do jogo) e conta trocas de tira e quedas ao idle.
## godot --headless --fixed-fps 60 --path . res://tools/walk_trace_probe.tscn -- <heroi> <fase> <ticks> [angulos|oito]
## `oito` = as 8 direções do teclado; ou uma lista de graus separados por vírgula (ex.: 10,37,100,200).
## Cada tick = 1/60 s e 1 quadro renderizado (--fixed-fps), então a animação a 10 fps avança 1 quadro a cada 6 ticks.

func _ready() -> void:
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345}
	var a := OS.get_cmdline_user_args()
	var hero: String = a[0] if a.size() > 0 else "durvall"
	var stage: String = a[1] if a.size() > 1 else "dagruve"
	var ticks := int(a[2]) if a.size() > 2 else 180
	var spec: String = a[3] if a.size() > 3 else "oito"
	var angles: Array[float] = []
	if spec == "oito":
		for i in 8:
			angles.append(i * 45.0)
	else:
		for part in spec.split(","):
			angles.append(float(part))
	WalkTrace.forced_enabled = true
	WalkTrace.forced_pressed = 1
	Game.run_stage = stage
	Game.run_hero = hero
	print("direcao,graus,ticks,inicio,troca,queda_idle,reinicio,tira_final,trocas_de_quadro,deslocamento_px,bloqueado")
	for angle in angles:
		await _walk(hero, stage, angle, ticks)
	get_tree().quit()

func _walk(hero: String, stage: String, angle: float, ticks: int) -> void:
	WalkTrace.reset_owner()
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	await get_tree().create_timer(0.3).timeout
	run.set_physics_process(false)
	var hero_node: Node2D = run.hero_node
	var direction := Vector2.RIGHT.rotated(deg_to_rad(angle))
	run.battle.hero.pos = run.battle.hero.map_size * 0.5  # longe das bordas: bloqueio de mapa não conta como queda ao idle
	run._sync()
	var sprite: AnimatedSprite2D = hero_node.sprite
	var frame_changes := 0
	var last_frame := -1
	var start := hero_node.position
	var moved := 0
	for i in ticks:
		var before: Vector2 = run.battle.hero.pos
		run.battle.step(direction, 1.0 / 60.0)
		if run.battle.hero.pos.distance_to(before) < 0.0001:
			moved += 1
		run._sync()
		await get_tree().process_frame
		if sprite.frame != last_frame:
			frame_changes += 1
			last_frame = sprite.frame
	var trace: WalkTrace = hero_node._trace
	var events: Dictionary = trace.events_total if trace != null else {}
	var travelled := hero_node.position.distance_to(start)
	print("%s,%.0f,%d,%d,%d,%d,%d,%s,%d,%.0f,%d" % [_name(angle), angle, ticks, int(events.get("start", 0)), int(events.get("switch", 0)), int(events.get("idle_drop", 0)), int(events.get("reset", 0)), sprite.animation, frame_changes, travelled, moved])
	run.queue_free()
	await get_tree().process_frame

func _name(angle: float) -> String:
	var sectors := ["e", "se", "s", "sw", "w", "nw", "n", "ne"]
	return sectors[int(posmod(roundi(angle / 45.0), 8))]
