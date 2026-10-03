extends Node
## Sonda de caminhada: dirige o herói por código e registra animação/quadro/posição do sprite a cada tick.
## godot --path . res://tools/korrak_walk_probe.tscn -- <heroi> <dx> <dy> <ticks>

func _ready() -> void:
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345}
	var a := OS.get_cmdline_user_args()
	var hero: String = a[0] if a.size() > 0 else "korrak"
	var dir := Vector2(float(a[1]) if a.size() > 1 else 1.0, float(a[2]) if a.size() > 2 else 0.0)
	var ticks := int(a[3]) if a.size() > 3 else 240
	Game.run_stage = "dagruve"
	Game.run_hero = hero
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	await get_tree().create_timer(0.4).timeout
	run.set_physics_process(false)
	var hv: Node2D = run.hero_node
	var rows: Array[String] = []
	var last_anim := ""
	var changes := 0
	var ys := []
	for i in ticks:
		run.battle.step(dir.normalized(), 1.0 / 60.0)
		run._sync()
		await get_tree().process_frame
		var s: AnimatedSprite2D = hv.sprite
		var name := String(s.animation)
		if name != last_anim:
			changes += 1
			last_anim = name
		ys.append(s.position.y)
		if i % 6 == 0:
			rows.append("%d %s f%d flip=%s pos=(%.1f,%.1f) rot=%.3f cam=%s" % [i, name, s.frame, str(s.flip_h), s.position.x, s.position.y, s.rotation, str(run.camera.position - hv.position)])
		if i == ticks / 2 or i == ticks / 2 + 3:
			get_viewport().get_texture().get_image().save_png("res://.atena/generated/ground-review/probe_%s_%d.png" % [hero, i])
	print("\n".join(rows))
	print("TROCAS de animação: ", changes, " hero.pos final=", run.battle.hero.pos)
	get_tree().quit()
