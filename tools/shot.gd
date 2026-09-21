extends Node
## Screenshot: godot --path . res://tools/shot.tscn -- <saida.png> <segundos> <menu|run> [fase] [heroi] [tab]
func _ready() -> void:
	var a := OS.get_cmdline_user_args()
	var out: String = a[0] if a.size() > 0 else "shot.png"
	var secs := float(a[1]) if a.size() > 1 else 1.0
	var mode: String = a[2] if a.size() > 2 else "menu"
	Game.profile.data.name = "Teste"
	Game.profile.data.welcome_seen = true
	Playtest.visible = false
	if mode == "run":
		Game.run_stage = a[3] if a.size() > 3 else "dagruve"
		Game.run_hero = a[4] if a.size() > 4 else "durvall"
		add_child(load("res://ui/run.tscn").instantiate())
	else:
		var m: Node = load("res://ui/menu.tscn").instantiate()
		add_child(m)
		if a.size() > 5:
			await get_tree().process_frame
			m.get_node("%Tabs").current_tab = int(a[5])
	await get_tree().create_timer(secs).timeout
	get_viewport().get_texture().get_image().save_png(out)
	get_tree().quit()
