extends RefCounted
## SPEC-144 (BUG-028): o diagnóstico de caminhada fica desligado por padrão e, ligado, enxerga troca de tira,
## queda ao idle e breakpoint; andar nas oito direções não pode trocar de tira nem cair ao idle.

const DIRECTIONS := {
	"e": [false, true, false, false], "se": [false, true, false, true], "s": [false, false, false, true],
	"sw": [true, false, false, true], "w": [true, false, false, false], "nw": [true, false, true, false],
	"n": [false, false, true, false], "ne": [false, true, true, false],
}

func run() -> Array[String]:
	var failures: Array[String] = []
	if WalkTrace.enabled():
		failures.append("WalkTrace deve ficar desligado sem --walk-debug")
	WalkTrace.disk_enabled = false
	WalkTrace.forced_enabled = true
	WalkTrace.forced_pressed = 1
	failures.append_array(_steady_walk_in_eight_directions())
	failures.append_array(_idle_drop_and_breakpoint())
	failures.append_array(_jitter_switches_and_smoothing())
	failures.append_array(_force_direction())
	WalkTrace.forced_enabled = false
	WalkTrace.forced_pressed = -1
	WalkTrace.disk_enabled = true
	WalkTrace.reset_owner()
	return failures

func _new_view() -> Node2D:
	WalkTrace.reset_owner()
	var packed: PackedScene = load("res://ui/hero_view.tscn")
	var view: Node2D = packed.instantiate()
	# Contêiner próprio: com irmãos chamados "Hero" na raiz o nó seria renomeado e perderia o papel de herói da run.
	var holder := Node.new()
	(Engine.get_main_loop() as SceneTree).root.add_child(holder)
	holder.add_child(view)
	view.apply_hero("durvall")
	return view

func _free_view(view: Node2D) -> void:
	var holder := view.get_parent()
	(Engine.get_main_loop() as SceneTree).root.remove_child(holder)
	holder.free()
	WalkTrace.reset_owner()

func _steady_walk_in_eight_directions() -> Array[String]:
	var failures: Array[String] = []
	for key in DIRECTIONS:
		var view := _new_view()
		var input: Array = DIRECTIONS[key]
		var hero := Hero.new()
		hero.map_size = Vector2(100, 100)
		hero.pos = Vector2(50, 50)
		var direction: Vector2 = Hero.movement_input(input[0], input[1], input[2], input[3])
		view._last_screen_position = Iso.to_screen(hero.pos)  # sem salto de teletransporte no primeiro tick
		for _i in 90:
			hero.step(direction, 1.0 / 60.0)
			view.sync_visual(Iso.to_screen(hero.pos), false, false)
		var trace: WalkTrace = view._trace
		if trace == null:
			failures.append("%s: o diagnóstico não abriu o log do herói" % key)
		else:
			var events: Dictionary = trace.events_total
			if int(events.get("start", 0)) != 1 or int(events.get("switch", 0)) != 0 or int(events.get("idle_drop", 0)) != 0 or int(events.get("reset", 0)) != 0:
				failures.append("%s: andar reto em linha deveria ter 1 início e nenhuma troca/queda/reinício: %s" % [key, str(events)])
		_free_view(view)
	return failures

func _idle_drop_and_breakpoint() -> Array[String]:
	var failures: Array[String] = []
	OS.set_environment("NOTT_WALK_BREAK", "idle,switch,reset")
	var view := _new_view()
	var position := Vector2.ZERO
	for tick in 40:
		if tick != 20:  # um tick sem deslocamento com a tecla pressionada: hipótese H2
			position += Vector2(3.17, 0.0)
		view.sync_visual(position, false, false)
	var trace: WalkTrace = view._trace
	if trace == null or int(trace.events_total.get("idle_drop", 0)) != 1:
		failures.append("queda ao idle com tecla pressionada não foi registrada: %s" % ("sem log" if trace == null else str(trace.events_total)))
	elif trace.break_hits < 1:
		failures.append("o gancho de breakpoint não disparou na queda ao idle")
	_free_view(view)
	OS.unset_environment("NOTT_WALK_BREAK")
	var quiet := _new_view()
	for tick in 40:
		quiet.sync_visual(Vector2(3.17 * tick, 0.0), false, false)
	if quiet._trace == null or quiet._trace.break_hits != 0:
		failures.append("sem --walk-break nenhum breakpoint deve disparar")
	_free_view(quiet)
	return failures

## Movimento que oscila na fronteira entre dois setores (22,5°): sem suavização a tira troca a cada tick (H1).
func _jitter_path(view: Node2D) -> void:
	var position := Vector2.ZERO
	for tick in 40:
		var angle := deg_to_rad(20.0 if tick % 2 == 0 else 25.0)
		position += Vector2.RIGHT.rotated(angle) * 3.17
		view.sync_visual(position, false, false)

func _jitter_switches_and_smoothing() -> Array[String]:
	var failures: Array[String] = []
	OS.set_environment("NOTT_WALK_BREAK", "switch")
	var raw := _new_view()
	_jitter_path(raw)
	var raw_switches := int(raw._trace.events_total.get("switch", 0)) if raw._trace != null else -1
	var raw_hits: int = raw._trace.break_hits if raw._trace != null else -1
	_free_view(raw)
	if raw_switches < 10:
		failures.append("movimento na fronteira de setor deveria trocar de tira várias vezes sem suavização (veio %d)" % raw_switches)
	if raw_hits < 1:
		failures.append("o gancho de breakpoint não disparou nas trocas de tira repetidas")
	OS.set_environment("NOTT_WALK_SMOOTH", "1")
	var smooth := _new_view()
	_jitter_path(smooth)
	var smooth_switches := int(smooth._trace.events_total.get("switch", 0)) if smooth._trace != null else -1
	_free_view(smooth)
	OS.unset_environment("NOTT_WALK_SMOOTH")
	OS.unset_environment("NOTT_WALK_BREAK")
	if smooth_switches != 0:
		failures.append("com --walk-smooth o mesmo movimento não deveria trocar de tira (veio %d)" % smooth_switches)
	return failures

func _force_direction() -> Array[String]:
	var failures: Array[String] = []
	OS.set_environment("NOTT_WALK_FORCE", "se")
	var view := _new_view()
	_jitter_path(view)
	var sprite := view.get_node("AnimatedSprite2D") as AnimatedSprite2D
	if sprite.animation != &"move_se" or int(view._trace.events_total.get("switch", 0)) != 0:
		failures.append("--walk-force=se deveria fixar a tira move_se (animação %s)" % sprite.animation)
	_free_view(view)
	OS.unset_environment("NOTT_WALK_FORCE")
	return failures
