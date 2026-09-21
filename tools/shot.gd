extends SceneTree
## Uso: godot --path . -s tools/shot.gd -- out.png  (precisa de janela, sem --headless)
func _init() -> void:
	var main = load("res://ui/main.tscn").instantiate()
	root.add_child(main)
	await create_timer(float(OS.get_cmdline_user_args()[1]) if OS.get_cmdline_user_args().size() > 1 else 0.5).timeout
	var out := "shot.png"
	var a := OS.get_cmdline_user_args()
	if a.size() > 0: out = a[0]
	root.get_texture().get_image().save_png(out)
	quit()
