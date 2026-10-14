extends Node
## SPEC-175 (MEC-068): capturas do questlog com a linha da câmara selada nos 3 tipos de chave.
## godot --path . res://tools/capture_chamber_log.tscn --resolution 1280x720 [-- <pasta>]
## Cenários: dagruve (ritual: pendente, em curso, perdido), docas (onda 1/3) e goranthis (aberta).

var _dir := "res://.atena/generated/mec-068-camara-selada/"
var _stage := "dagruve"

func _shot(name: String) -> void:
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var size := get_viewport().get_visible_rect().size
	get_viewport().get_texture().get_image().save_png("%s%s_%s_%dx%d.png" % [_dir, _stage, name, int(size.x), int(size.y)])

func _event(stage: String, id: String) -> Dictionary:
	for ev in Data.table("stage_events")[stage]:
		if String(ev.id) == id:
			return ev
	return {}

func _ready() -> void:
	for a in OS.get_cmdline_user_args():
		if a in ["dagruve", "docas", "goranthis"]:
			_stage = a
		elif a != "--debug":
			_dir = a if a.ends_with("/") else a + "/"
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_dir))
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345}
	Game.run_stage = _stage
	Game.run_hero = "sylas"
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	await get_tree().create_timer(0.6).timeout
	run.set_process(false)
	run.set_physics_process(false)
	var b: Battle = run.battle
	var chamber: Array = b.interactions.filter(func(i): return String(i.kind) == "camara")
	if chamber.is_empty():
		print("sem câmara nesta fase")
		get_tree().quit()
		return
	b.hero.pos = chamber[0].pos + Vector2(3.0, 0.0)
	b._update_chamber_seen()
	var hud = run.hud
	hud.update_stats(b)
	await get_tree().create_timer(0.2).timeout
	await _shot("1_pendente")
	match _stage:
		"dagruve":
			b._stage_events_done["ritual_da_nevoa"] = true
			b._fire_stage_event(_event("dagruve", "ritual_da_nevoa"))
			hud.update_stats(b)
			await get_tree().create_timer(0.2).timeout
			await _shot("2_em_curso")
			b.hero.pos = Vector2(1.0, 1.0)
			for i in 400:
				b._update_zones(0.1)
			b.hero.pos = chamber[0].pos + Vector2(3.0, 0.0)
			hud.update_stats(b)
			await get_tree().create_timer(0.2).timeout
			await _shot("3_perdida")
		"docas":
			b._stage_events_done["cais_atacado"] = true
			b._fire_stage_event(_event("docas", "cais_atacado"))
			var raiders: Array = b._key_wave.duplicate()
			if raiders.size() > 0:
				b._kill(raiders[0])
			hud.update_stats(b)
			await get_tree().create_timer(0.2).timeout
			await _shot("2_onda_1_de_3")
		"goranthis":
			b.happenings.fire(b, _event("goranthis", "do_trono_ao_lodo"))
			hud.update_stats(b)
			await get_tree().create_timer(0.2).timeout
			await _shot("2_aberta")
	print("linha: ", b.chamber_entry())
	get_tree().quit()
