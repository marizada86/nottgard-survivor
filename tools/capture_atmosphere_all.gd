extends Node
## SPEC-177 R5-C/D: as 9 fases com a atmosfera real (Desligada e Leve) e o custo medido (tempo de quadro sem vsync).
## godot --path . res://tools/capture_atmosphere_all.tscn --resolution 1280x720 [-- --dir=res://pasta/ --stages=a,b]

var _dir := "res://.atena/generated/m2-game-feel/r5-cd-nove-fases/"
var _only: PackedStringArray = []

func _ready() -> void:
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--dir="):
			_dir = argument.trim_prefix("--dir=")
		elif argument.begins_with("--stages="):
			_only = argument.trim_prefix("--stages=").split(",")
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_dir))
	Playtest.visible = false
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	Engine.max_fps = 0
	var original: String = String(Game.profile.data.settings.get("atmosphere", "leve"))
	var report: Array = []
	for sid in Data.table("stages"):
		if not _only.is_empty() and not _only.has(String(sid)):
			continue
		Game.qa_sandbox = true
		Game.qa_launch = {"seed": 12345}
		Game.run_stage = sid
		Game.run_hero = "durvall"
		var run: Node = load("res://ui/run.tscn").instantiate()
		add_child(run)
		for _i in 40:
			Game.controls.focused = true
			get_tree().paused = false
			await get_tree().create_timer(0.1).timeout
		var row := {"stage": sid}
		for mode in ["off", "leve"]:
			Game.profile.data.settings["atmosphere"] = mode
			Game.visual_settings_changed.emit()
			await get_tree().create_timer(0.4).timeout
			await _shot("%s_%s" % [sid, mode])
			var start := Time.get_ticks_usec()
			for _f in 240:
				await get_tree().process_frame
			row["ms_%s" % mode] = snappedf(float(Time.get_ticks_usec() - start) / 240000.0, 0.01)
		report.append(row)
		print("atmosfera ", row)
		run.queue_free()
		await get_tree().process_frame
	Game.profile.data.settings["atmosphere"] = original
	var file := FileAccess.open("%sresumo.json" % _dir, FileAccess.WRITE)
	file.store_string(JSON.stringify(report, "\t"))
	file.close()
	get_tree().quit()

func _shot(label: String) -> void:
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("%s%s.png" % [_dir, label])
