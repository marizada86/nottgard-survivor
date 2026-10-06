extends Node
## SPEC-131: capturas do painel do herói da HUD (início de run, herói cheio com barreira e bênçãos, Estige).
## godot --path . res://tools/capture_hero_panel.tscn --resolution 1280x720 -- --hero=sylas

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
	var size := Vector2(DisplayServer.window_get_size())  # o viewport visível fica na base 1280x720 (stretch)
	var tag := "%s_%dx%d" % [hero, int(size.x), int(size.y)]
	var dir := "res://.atena/generated/spec-131/"
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(dir))
	var b: Battle = run.battle
	run.hud.update_stats(b)
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png(dir + tag + "_inicio.png")
	b.hero.hp = b.hero.max_hp * 0.55
	b.hero.xp = b.hero.xp_need * 0.6
	b.hero.gold = 123
	b.stats.kills = 87
	b.barrier = 9.0
	var boons: Array = Data.table("boons").boons
	for k in 3:
		b.hero.boons.append(boons[k])
	b.hero.recalc()
	run.hud.update_stats(b)
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png(dir + tag + "_cheio.png")
	b.hero.styx_forget_t = 4.0
	run.hud.update_stats(b)
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png(dir + tag + "_estige.png")
	print("capture ok ", tag)
	get_tree().quit()
