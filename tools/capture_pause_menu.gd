extends Node
## SPEC-165 (MEC-003): capturas do novo menu de pausa (abas Jogo, Catálogo e Configurações) e da ficha C (antes/depois do UiKit).
## godot --path . res://tools/capture_pause_menu.tscn --resolution 1280x720 [-- --mobile] [-- <pasta>]

var _dir := "res://.atena/generated/plan-092/capturas/"
var _prefix := ""

func _shot(name: String) -> void:
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var size := get_viewport().get_visible_rect().size
	get_viewport().get_texture().get_image().save_png("%s%s%s_%dx%d.png" % [_dir, _prefix, name, int(size.x), int(size.y)])

func _ready() -> void:
	for a in OS.get_cmdline_user_args():
		if a == "--mobile":
			Game.touch_preview = true
			_prefix = "mobile_"
		else:
			_dir = a if a.ends_with("/") else a + "/"
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_dir))
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345}
	Game.run_stage = "dagruve"
	Game.run_hero = "sylas"
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	await get_tree().create_timer(0.6).timeout
	run.set_process(false)
	run.set_physics_process(false)
	var b: Battle = run.battle
	b.codex.enemies["cultista"] = true
	run.hud.update_stats(b)
	# ficha C (sem mudança visual com o UiKit)
	run.hud.items_panel.show_sheet(b)
	await get_tree().create_timer(0.2).timeout
	await _shot("00_ficha_c")
	run.hud.items_panel.hide_sheet()
	run.hud.show_pause(true)
	await get_tree().create_timer(0.2).timeout
	await _shot("01_pausa_jogo")
	run.hud.pause_menu.set_tab(1)
	await get_tree().create_timer(0.2).timeout
	await _shot("02_pausa_catalogo_inimigos")
	run.hud.pause_menu.set_category(1)
	await get_tree().create_timer(0.2).timeout
	var first = run.hud.pause_menu.first_cell()
	if first != null:
		first.emit_signal("pressed")
	await _shot("03_pausa_catalogo_armas")
	run.hud.pause_menu.set_tab(2)
	await get_tree().create_timer(0.2).timeout
	await _shot("04_pausa_configuracoes")
	print("pausa: aba=", run.hud.pause_menu.current_tab(), " visivel=", run.hud.pause_panel.visible, " tamanho=", run.hud.pause_panel.size)
	get_tree().quit()
