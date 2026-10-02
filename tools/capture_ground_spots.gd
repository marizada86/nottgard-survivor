extends Node
## Capturas do chão por pontos do mapa. Uso: godot --path . res://tools/capture_ground_spots.tscn -- <fase> <rotulo>

func _ready() -> void:
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345}
	var a := OS.get_cmdline_user_args()
	var stage: String = a[0] if a.size() > 0 else "docas"
	var tag: String = a[1] if a.size() > 1 else "v1"
	var spots := {
		"dagruve": [Vector2(22, 24), Vector2(42, 38), Vector2(30, 8), Vector2(10, 40)],
		"shedaklah": [Vector2(10, 30), Vector2(30, 30), Vector2(50, 30)], "molor": [Vector2(30, 30), Vector2(12, 12), Vector2(5, 30)], "durao": [Vector2(30, 30), Vector2(20, 20), Vector2(42, 30)], "feng_tu": [Vector2(30, 30), Vector2(20, 40), Vector2(10, 10)], "shendilavri": [Vector2(30, 30), Vector2(8, 30), Vector2(40, 15)], "goranthis": [Vector2(30, 30), Vector2(54, 30), Vector2(15, 20)], "pilares": [Vector2(30, 30), Vector2(15, 40), Vector2(45, 15)],
		"docas": [Vector2(6, 30), Vector2(22, 8), Vector2(40, 28), Vector2(22, 43), Vector2(45, 18)],
	}
	DirAccess.make_dir_recursive_absolute("res://.atena/generated/ground-review")
	Game.run_stage = stage
	Game.run_hero = "durvall"
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	await get_tree().create_timer(0.5).timeout
	run.set_process(false)
	run.set_physics_process(false)
	for spot in spots.get(stage, []):
		run.camera.position = Iso.to_screen(spot)
		await get_tree().create_timer(0.25).timeout
		await RenderingServer.frame_post_draw
		var image := get_viewport().get_texture().get_image()
		image.save_png("res://.atena/generated/ground-review/%s_%s_%d_%d.png" % [stage, tag, spot.x, spot.y])
	get_tree().quit()
