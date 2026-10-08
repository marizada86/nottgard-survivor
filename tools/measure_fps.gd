extends Node
## SPEC-152 S-020: FPS médio de uma fase em janela (60 FPS = teto do VSync). Uso:
##   godot --path . --resolution 1280x720 res://tools/measure_fps.tscn -- <fase> [segundos]
## Saída: "fps;fase;lado;media;minimo;quadros_lentos(<50)".

func _ready() -> void:
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 777}
	var a := OS.get_cmdline_user_args()
	var stage: String = a[0] if a.size() > 0 else "shedaklah"
	var seconds := float(a[1]) if a.size() > 1 else 8.0
	Game.run_stage = stage
	Game.run_hero = "durvall"
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	await get_tree().create_timer(1.0).timeout
	var samples: Array = []
	var slow := 0
	var t := 0.0
	while t < seconds:
		await get_tree().process_frame
		var dt := get_process_delta_time()
		t += dt
		samples.append(1.0 / maxf(dt, 0.0001))
		if dt > 1.0 / 50.0:
			slow += 1
	var sum := 0.0
	var low := 1.0e9
	for s in samples:
		sum += float(s)
		low = minf(low, float(s))
	print("fps;%s;%d;%.1f;%.1f;%d de %d" % [stage, int(run.battle.map_size.x), sum / float(samples.size()), low, slow, samples.size()])
	get_tree().quit()
