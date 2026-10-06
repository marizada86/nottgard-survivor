extends Node
## SPEC-127: capturas do slot da habilidade (pronta, em recarga) e da ficha C.
## godot --path . res://tools/capture_ability_hud.tscn --resolution 1280x720 -- --hero=sylas

func _ready() -> void:
	var hero := "sylas"
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--hero="):
			hero = argument.trim_prefix("--hero=")
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345}
	Game.run_stage = "dagruve"
	Game.run_hero = hero
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	await get_tree().create_timer(0.6).timeout
	run.set_process(false)
	run.set_physics_process(false)
	var size := get_viewport().get_visible_rect().size
	var tag := "%s_%dx%d" % [hero, int(size.x), int(size.y)]
	var dir := "res://.atena/generated/spec-127/"
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(dir))
	var b: Battle = run.battle
	b.active_cd = 0.0
	run.hud.update_stats(b)
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png(dir + tag + "_pronta.png")
	b.active_cd = 6.0
	b.active_cd_max = 10.0
	run.hud.update_stats(b)
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png(dir + tag + "_recarga.png")
	run.hud.show_items_panel(b)
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png(dir + tag + "_ficha_c.png")
	print("capture ok ", tag)
	get_tree().quit()
