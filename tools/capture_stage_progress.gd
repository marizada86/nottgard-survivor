extends Node
## SPEC-163 (MEC-002): capturas da barra de progresso da fase (início, esquentando, chefe, Maré) e sobreposição com a HUD.
## godot --path . res://tools/capture_stage_progress.tscn --resolution 1280x720 [-- --mobile] [-- <pasta>]

var _dir := "res://.atena/generated/plan-089/capturas/"
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
	var dur := float(b.stage.duration)
	for step in [["01_inicio", 0.02], ["02_meio", 0.5], ["03_esquentando", 0.9]]:
		b.time = dur * float(step[1])
		run.hud.update_stats(b)
		await get_tree().create_timer(0.1).timeout
		await _shot(String(step[0]))
	b.boss_spawned = true
	run.hud.update_stats(b)
	await get_tree().create_timer(0.1).timeout
	await _shot("04_chefe_vivo")
	b.boss_dead = true
	b.fog_state = "advancing"
	b.fog_config = {"grace_seconds": 8.0, "warning_seconds": 2.0, "advance_seconds": 28.0}
	b.fog_elapsed = 19.0
	run.hud.update_stats(b)
	await get_tree().create_timer(0.1).timeout
	await _shot("05_mare_metade")
	var sp: StageProgress = run.hud.stage_progress
	print("barra: visivel=", sp.visible, " rect=", sp.get_global_rect(), " estado=", StageProgress.state(b))
	var tl: Control = run.hud.timer_label
	var sl: Control = run.hud.stage_label
	print("relogio=", tl.get_global_rect(), " nome_fase=", sl.get_global_rect())
	get_tree().quit()
