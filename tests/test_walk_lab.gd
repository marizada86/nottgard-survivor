extends RefCounted
## SPEC-176 (S-005): laboratório de passada. Fica desligado por padrão; a fórmula de fps casa o passo com o chão
## e o reforço procedural (C2) só age quando ligado.

const EXPECTED_FPS := {
	"durvall": 17.0, "zynara": 17.0, "leoric": 26.0, "nyrelia": 17.0, "kayron": 16.0, "korrak": 12.0,
	"bromnor": 22.0, "sylas": 16.0, "brook": 26.0, "maelor": 16.0, "arlindo": 17.0, "erik": 16.0,
}

func run() -> Array[String]:
	var failures: Array[String] = []
	failures.append_array(_fps_formula())
	failures.append_array(_speed_override())
	failures.append_array(_stride_reinforcement())
	return failures

func _fps_formula() -> Array[String]:
	var failures: Array[String] = []
	var script: Script = load("res://ui/hero_view.gd")
	for hero in EXPECTED_FPS:
		var fps: float = script.lab_walk_fps(hero)
		if absf(fps - float(EXPECTED_FPS[hero])) > 0.01:
			failures.append("%s: fps do laboratório %.0f, esperado %.0f" % [hero, fps, float(EXPECTED_FPS[hero])])
	# Velocidade explícita manda; mais lento pede menos quadros por segundo.
	if script.lab_walk_fps("durvall", 120.0) >= script.lab_walk_fps("durvall", 190.0):
		failures.append("a 120 px/s o ciclo deveria ser mais lento que a 190 px/s")
	# O ritmo nunca sai dos limites.
	var fast: float = script.lab_walk_fps("leoric", 900.0)
	var slow: float = script.lab_walk_fps("leoric", 10.0)
	if fast > script.LAB_FPS_MAX or slow < script.LAB_FPS_MIN:
		failures.append("o fps do laboratório deveria ficar entre %d e %d" % [int(script.LAB_FPS_MIN), int(script.LAB_FPS_MAX)])
	return failures

func _speed_override() -> Array[String]:
	var failures: Array[String] = []
	var hero := Hero.new()
	Hero.dev_speed_override = 0.0
	var normal := hero.speed_px()
	if absf(normal - Hero.SPEED_PX) > 0.01:
		failures.append("sem o laboratório a velocidade deveria ser %.0f, veio %.2f" % [Hero.SPEED_PX, normal])
	Hero.dev_speed_override = 120.0
	var lab := hero.speed_px()
	Hero.dev_speed_override = 0.0
	if absf(lab - 120.0) > 0.01:
		failures.append("com --walk-speed=120 a velocidade deveria ser 120, veio %.2f" % lab)
	return failures

func _stride_reinforcement() -> Array[String]:
	var failures: Array[String] = []
	var packed: PackedScene = load("res://ui/hero_view.tscn")
	var view: Node2D = packed.instantiate()
	var holder := Node.new()
	(Engine.get_main_loop() as SceneTree).root.add_child(holder)
	holder.add_child(view)
	view.apply_hero("durvall")
	var sprite: AnimatedSprite2D = view.sprite
	sprite.play(&"move_e")
	sprite.frame = 1
	view._walking = true
	# Desligado: nada se mexe.
	view._process(0.016)
	if sprite.position != Vector2.ZERO or sprite.rotation != 0.0:
		failures.append("sem --walk-bob e --walk-lean o sprite não pode se mexer (pos %s, rot %.3f)" % [str(sprite.position), sprite.rotation])
	# Ligado: sobe e inclina no quadro 1 de 6.
	view._dbg_bob = 3.0
	view._dbg_lean = 0.05
	view._process(0.016)
	if sprite.position.y >= -0.5:
		failures.append("com bob 3 o sprite deveria subir no quadro 1, y = %.2f" % sprite.position.y)
	if absf(sprite.rotation) < 0.01:
		failures.append("com lean 0,05 o sprite deveria inclinar no quadro 1")
	# Parado: assenta de volta.
	view._walking = false
	for _i in 120:
		view._process(0.016)
	if absf(sprite.position.y) > 0.05 or absf(sprite.rotation) > 0.002:
		failures.append("parado, o reforço deveria assentar em zero (y %.2f, rot %.3f)" % [sprite.position.y, sprite.rotation])
	(Engine.get_main_loop() as SceneTree).root.remove_child(holder)
	holder.free()
	return failures
