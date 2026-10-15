extends Node
## SPEC-177 F-7: fotografa o efeito de cada arma em pose (quadro 2), à esquerda o desenho procedural de antes
## (efeitos reduzidos) e à direita a arte nova, na mesma run.
## godot --path . res://tools/capture_weapon_vfx.tscn --resolution 1280x720 -- [--weapons=a,b] [--dir=res://pasta/]

var _dir := "res://.atena/generated/m2-game-feel/armas-vfx-v01/"
var _weapons: PackedStringArray = ["maca_demolidora", "esmagar_defesas", "romper_armadura", "raio_da_ruina", "dominio_coletivo", "constelacao_de_silva"]

func _ready() -> void:
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--dir="):
			_dir = argument.trim_prefix("--dir=")
		elif argument.begins_with("--weapons="):
			_weapons = argument.trim_prefix("--weapons=").split(",")
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_dir))
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345}
	Game.run_stage = "dagruve"
	Game.run_hero = "durvall"
	var original: bool = Game.reduced_impact()
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	await get_tree().create_timer(0.5).timeout
	run.set_process(false)
	run.set_physics_process(false)
	var weapons: Dictionary = Data.table("weapons")
	var origin: Vector2 = run.battle.hero.pos
	for weapon_id in _weapons:
		var w: Dictionary = weapons[weapon_id]
		for child in run.fx.get_children():
			child.queue_free()
		await get_tree().process_frame
		for side in 2:   # 0 = procedural (antes), 1 = arte (depois)
			Game.profile.data.settings["reduced_impact"] = side == 0
			var offset := Vector2(-170 if side == 0 else 170, 0)
			var at := origin + Iso.to_ground(offset)
			var theme: Dictionary = run._divine_theme()
			var event := {"pos": at, "dir": Vector2(1, -1).normalized(), "range": float(w.get("range", 2.0)), "cone": float(w.get("cone", 60)), "dtype": String(w.dtype), "weapon": weapon_id, "radius": 2.6}
			match String(w.kind):
				"melee":
					run._swing(event, theme)
					var effect: Node = run.fx.get_child(run.fx.get_child_count() - 1)
					if effect.get_child_count() > 0 and effect.get_child(0) is AnimatedSprite2D:
						var sprite: AnimatedSprite2D = effect.get_child(0)
						sprite.pause()
						sprite.frame = 2
				"nova":
					event["type"] = "nova"
					run._nova_effect(event)
					var pulse: Node = run.fx.get_child(run.fx.get_child_count() - 1)
					for c in pulse.get_children():
						if c is AnimatedSprite2D:
							c.pause()
							c.frame = 3
				"bolt":
					var projectile := {"owner": "hero", "p": {"id": weapon_id, "dtype": String(w.dtype)}, "pos": at, "dir": Vector2(1, 0)}
					if side == 1 and ProjectileVfx.handles(projectile, false):
						var flight := ProjectileVfx.create_flight(projectile, theme.impact_accent)
						flight.position = Iso.to_screen(at)
						run.fx.add_child(flight)
						flight.pause()
						flight.frame = 1
					else:
						var dot := Polygon2D.new()
						dot.polygon = PackedVector2Array([Vector2(-6, 0), Vector2(0, -6), Vector2(6, 0), Vector2(0, 6)])
						dot.position = Iso.to_screen(at) + Vector2(0, -16)
						dot.color = theme.impact_accent
						run.fx.add_child(dot)
		await RenderingServer.frame_post_draw
		var image := get_viewport().get_texture().get_image()
		print("weapon ", weapon_id, " ", w.kind, " ", image.save_png("%s%s.png" % [_dir, weapon_id]))
	Game.profile.data.settings["reduced_impact"] = original
	get_tree().quit()
