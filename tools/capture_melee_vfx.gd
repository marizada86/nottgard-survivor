extends Node

func _ready() -> void:
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345}
	Game.run_stage = "dagruve"
	Game.run_hero = "durvall"
	var reduced: bool = Game.reduced_impact()
	Game.profile.data.settings["reduced_impact"] = false
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	await get_tree().create_timer(0.4).timeout
	run.set_process(false)
	run.set_physics_process(false)
	var origin: Vector2 = run.battle.hero.pos
	for shape in MeleeVfx.SHAPE_PATHS:
		_clear(run)
		await get_tree().process_frame
		var index := 0
		for theme in DivineVisuals.DIVINE_THEMES.values():
			var offset := Vector2(-360 + (index % 4) * 240, -120 + (index / 4) * 200)
			var weapon := "espada_sombria" if shape == "corte_medio" else "espada_do_receptaculo"
			if shape == "estocada_longa":
				weapon = "estocada_mistica"
			if shape == "chicote":
				weapon = "chicote_avarento"
			var dtype := "magico" if shape == "estocada_longa" else "fisico"
			run._swing({"pos": origin + Iso.to_ground(offset), "dir": Vector2(1, -1).normalized(), "range": 2.3, "cone": 60, "dtype": dtype, "weapon": weapon}, theme)
			var effect: Node = run.fx.get_child(run.fx.get_child_count() - 1)
			var sprite: AnimatedSprite2D = effect.get_child(0)
			sprite.pause()
			sprite.frame = 2
			index += 1
		await _capture("melee_%s_themes" % shape)
	_clear(run)
	await get_tree().process_frame
	for index in 8:
		var angle := index * PI / 4.0
		var screen_offset := Vector2(cos(angle), sin(angle)) * 250
		run._swing({"pos": origin + Iso.to_ground(screen_offset), "dir": Iso.to_ground(Vector2(cos(angle), sin(angle))).normalized(), "range": 1.9, "cone": 60, "dtype": "fisico", "weapon": "espada_sombria"}, DivineVisuals.DIVINE_THEMES["Shar"])
		var sprite: AnimatedSprite2D = run.fx.get_child(run.fx.get_child_count() - 1).get_child(0)
		sprite.pause()
		sprite.frame = 2
	await _capture("melee_directions")
	_clear(run)
	await get_tree().process_frame
	# O efeito deve desaparecer ao terminar os seis quadros.
	var effect := MeleeVfx.create_effect({"pos": origin, "dir": Vector2.RIGHT, "range": 2.0, "dtype": "fisico", "weapon": "espada_sombria"}, Color.WHITE)
	run.fx.add_child(effect)
	await get_tree().create_timer(0.3).timeout
	assert(not is_instance_valid(effect), "Melee VFX leaked after animation")
	print("melee lifetime: ok")
	Game.profile.data.settings["reduced_impact"] = true
	run._swing({"pos": origin, "dir": Vector2.RIGHT, "range": 2.0, "cone": 60, "dtype": "fisico", "weapon": "espada_sombria"}, DivineVisuals.DIVINE_THEMES["Shar"])
	assert(run.fx.get_child(run.fx.get_child_count() - 1) is Polygon2D, "Reduced effects must retain procedural fallback")
	await _capture("melee_reduced")
	Game.profile.data.settings["reduced_impact"] = reduced
	print("melee reduced fallback: ok")
	get_tree().quit()

func _clear(run: Node) -> void:
	for child in run.fx.get_children():
		child.queue_free()

func _capture(label: String) -> void:
	await RenderingServer.frame_post_draw
	var image := get_viewport().get_texture().get_image()
	print(label, " result=", image.save_png("res://.atena/generated/priority-review/%s.png" % label))
