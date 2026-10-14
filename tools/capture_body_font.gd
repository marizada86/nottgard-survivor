extends Node
## Avaliacao (nao commitada): fonte do corpo do jogo. Troca o default_font do tema do projeto em memoria e captura telas.
##   godot --path . res://tools/capture_body_font.tscn -- [pasta]

var _dir := "res://.atena/generated/plan-100/capturas-corpo3/"

func _shot(name: String) -> void:
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("%s%s.png" % [_dir, name])

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_dir))
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345}
	var theme := ThemeDB.get_project_theme()
	var alegreya: Font = theme.default_font
	var variants := {"tema": [alegreya, theme.default_font_size]}  # o tema real do projeto, sem troca
	for key in variants:
		theme.default_font = variants[key][0]
		theme.default_font_size = variants[key][1]
		for tab in [0, 1, 5]:
			Game.qa_menu_tab = tab
			var menu: Node = load("res://ui/menu.tscn").instantiate()
			add_child(menu)
			await get_tree().create_timer(0.5).timeout
			await _shot("%s_menu_aba%d" % [key, tab])
			menu.queue_free()
			await get_tree().process_frame
		Game.run_stage = "dagruve"
		Game.run_hero = "sylas"
		var run: Node = load("res://ui/run.tscn").instantiate()
		add_child(run)
		await get_tree().create_timer(0.8).timeout
		run.set_process(false)
		run.set_physics_process(false)
		run.battle.time = 95.0
		run.hud.update_stats(run.battle)
		await get_tree().create_timer(0.2).timeout
		await _shot("%s_hud" % key)
		run.queue_free()
		await get_tree().process_frame
	theme.default_font = alegreya
	theme.default_font_size = 20
	get_tree().quit()
