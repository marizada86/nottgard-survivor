extends Node
## SPEC-173 (MEC-065): capturas das variantes do filtro visual em alguns biomas e custo de quadro com e sem filtro.
##   godot --path . res://tools/capture_visual_filter.tscn -- [pasta] [fases=dagruve,molor,goranthis] [quadros=180]
## Precisa de janela (GPU). O custo e o tempo de quadro desta maquina com VSync desligado, nao uma estimativa de outras.
## Nao grava no save: so muda o perfil em memoria e o restaura.

var _dir := "res://.atena/generated/plan-100/capturas/"

func _shot(name: String) -> void:
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var size := get_viewport().get_visible_rect().size
	get_viewport().get_texture().get_image().save_png("%s%s_%dx%d.png" % [_dir, name, int(size.x), int(size.y)])

func _cost(frames: int) -> Dictionary:
	var times: Array[float] = []
	await RenderingServer.frame_post_draw
	var last := Time.get_ticks_usec()
	for i in frames:
		await RenderingServer.frame_post_draw
		var now := Time.get_ticks_usec()
		times.append(float(now - last) / 1000.0)
		last = now
	times.sort()
	var sum := 0.0
	for t in times:
		sum += t
	return {"medio": sum / float(times.size()), "p95": times[int(times.size() * 0.95)], "max": times[times.size() - 1]}

func _ready() -> void:
	var a := OS.get_cmdline_user_args()
	if a.size() > 0:
		_dir = a[0] if a[0].ends_with("/") else a[0] + "/"
	var stages: Array = Array((a[1] if a.size() > 1 else "dagruve,molor,goranthis").split(","))
	var frames := int(a[2]) if a.size() > 2 else 180
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_dir))
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	Engine.max_fps = 0
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345}
	var settings: Dictionary = Game.profile.data.settings
	var original := String(settings.get("visual_filter", "off"))
	for sid in stages:
		Game.run_stage = String(sid)
		Game.run_hero = "sylas"
		var run: Node = load("res://ui/run.tscn").instantiate()
		add_child(run)
		await get_tree().create_timer(0.8).timeout
		run.set_process(false)
		run.set_physics_process(false)
		var vf: VisualFilter = run._visual_filter
		print("CAMADAS;fase=%s;mundo=0;filtro=%d;hud=%d;encontros=%d" % [sid, vf.layer, run.hud.layer, run._encounter_layer.layer])
		for mode in VisualFilter.MODES:
			settings.visual_filter = mode
			Game.visual_settings_changed.emit()
			await get_tree().create_timer(0.15).timeout
			await _shot("%s_%s" % [sid, mode])
			var c: Dictionary = await _cost(frames)
			print("CUSTO;fase=%s;modo=%s;ms_medio=%.2f;ms_p95=%.2f;ms_max=%.2f;desenha=%s" % [sid, mode, c.medio, c.p95, c.max, str(vf.is_drawing())])
		run.queue_free()
		await get_tree().process_frame
	settings.visual_filter = original
	get_tree().quit()
