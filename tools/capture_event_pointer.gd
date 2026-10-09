extends Node
## SPEC-159 (MEC-061): capturas da seta de evento na borda (distância, fusão, pulso de entrada e fuga da HUD).
## godot --path . res://tools/capture_event_pointer.tscn --resolution 1280x720 [-- <pasta>]

var _dir := "res://.atena/generated/mec-061-seta-de-evento/"
var _prefix := ""

func _shot(name: String) -> void:
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var size := get_viewport().get_visible_rect().size
	get_viewport().get_texture().get_image().save_png("%s%s%s_%dx%d.png" % [_dir, _prefix, name, int(size.x), int(size.y)])

func _add(b: Battle, kind: String, off: Vector2, label: String, color: Color, obj: String) -> void:
	b.interactions.append({"kind": kind, "pos": b.hero.pos + off, "used": false, "born_at": 0.0, "label": label, "color": color, "obj": obj})

func _ready() -> void:
	for a in OS.get_cmdline_user_args():
		if a == "--debug":
			continue
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
	b.happenings.objectives.clear()
	b.happenings.objectives.append({"id": "o1", "kind": "collect", "title": "Fragmentos do santuário", "text": "Reúna os fragmentos e leve-os ao altar", "ends_at": b.time + 95.0, "need": 3, "got": 1, "done": false, "failed": false})
	_add(b, "event_item", Vector2(14, 6), "Fragmento sagrado", Color(0.7, 0.95, 0.6), "o1")      # longe, leste
	_add(b, "event_target", Vector2(-9, -12), "Altar do poço", Color(0.95, 0.8, 0.4), "o1")      # longe, norte
	_add(b, "event_npc", Vector2(-18, 10), "Sobrevivente", Color(0.95, 0.9, 0.6), "o1")          # longe, oeste
	_add(b, "event_item", Vector2(2.5, 1.0), "Perto do herói", Color(0.7, 0.95, 0.6), "o1")     # dentro da tela: anel, sem seta
	_add(b, "event_item", Vector2(14.5, 6.5), "Fragmento vizinho", Color(0.7, 0.95, 0.6), "o1") # funde com o primeiro
	run.hud.update_stats(b)
	await get_tree().create_timer(0.1).timeout
	await _shot("pulso_de_entrada")
	await get_tree().create_timer(0.8).timeout
	await _shot("setas_na_borda")
	var tri: EventPointer = run.hud.event_pointer
	var arr := tri.arrows(b, Time.get_ticks_msec())
	print("setas: ", arr.map(func(a): return EventPointer.caption(a)))
	if "--debug" in OS.get_cmdline_user_args():
		for a in arr:
			print("DBG ", a.pos, " w=", a.caption_w, " box=", EventPointer.box_rect(a.pos, tri.get_viewport_rect().grow(-EventPointer.MARGIN), float(a.caption_w)))
		if tri.mobile != null:
			print("DBG regions ", tri.mobile.regions)
	get_tree().quit()
