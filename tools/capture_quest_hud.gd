extends Node
## SPEC-147: capturas do topo da HUD com quest, chefe e avisos; do realce no mundo; do indicador do Estige; da ficha com próximo nível.
## godot --path . res://tools/capture_quest_hud.tscn --resolution 1280x720

const DIR := "res://.atena/generated/playtest-fixes-080/"

func _shot(name: String) -> void:
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var size := get_viewport().get_visible_rect().size
	get_viewport().get_texture().get_image().save_png("%s%s_%dx%d.png" % [DIR, name, int(size.x), int(size.y)])

func _run_scene(stage: String) -> Node:
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345}
	Game.run_stage = stage
	Game.run_hero = "sylas"
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	await get_tree().create_timer(0.6).timeout
	run.set_process(false)
	run.set_physics_process(false)
	return run

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(DIR))
	var run: Node = await _run_scene("dagruve")
	var b: Battle = run.battle
	b.happenings.objectives.clear()
	b.happenings.objectives.append({"id": "o1", "kind": "collect", "title": "Fragmentos do santuário", "text": "Reúna os fragmentos e leve-os ao altar", "ends_at": b.time + 95.0, "need": 3, "got": 1, "done": false, "failed": false})
	b.happenings.objectives.append({"id": "o2", "kind": "rescue", "title": "Peregrino ferido", "text": "Escolte o peregrino até o poço", "ends_at": b.time + 8.0, "need": 1, "got": 0, "done": false, "failed": false})
	b.interactions.append({"kind": "event_item", "pos": b.hero.pos + Vector2(2.5, 1.0), "used": false, "born_at": 0.0, "label": "Fragmento sagrado", "color": Color(0.7, 0.95, 0.6), "obj": "o1"})
	b.interactions.append({"kind": "event_target", "pos": b.hero.pos + Vector2(-2.0, -1.5), "used": false, "born_at": 0.0, "label": "Altar do poço", "color": Color(0.95, 0.8, 0.4), "obj": "o1"})
	run.hud.boss_panel.visible = true
	for t in ["Um peregrino pede ajuda", "Você ouve passos entre as árvores", "Fragmento coletado (1/3)"]:
		run.hud.toast(t, Color(1, 0.95, 0.7))
	run.hud.update_stats(b)
	run.hud.boss_panel.visible = true
	await _shot("topo_quests")
	run.queue_free()
	await get_tree().process_frame
	run = await _run_scene("durao")
	b = run.battle
	b.styx_exposure = 3.4
	run.hud.update_stats(b)
	await _shot("estige_na_agua")
	b.styx_exposure = 0.0
	b.hero.styx_forget_t = 4.0
	run.hud.update_stats(b)
	await _shot("estige_esquecimento")
	b.hero.weapons.clear()
	b.hero.weapons.append(Weapon.make("espada_sombria", 2))
	b.hero.passives["forca"] = 2
	run.hud.show_items_panel(b)
	var sheet: CharacterSheet = run.hud.items_panel
	sheet.set_tab(0)
	await get_tree().process_frame
	sheet._on_slot_chosen(sheet._first_slot(sheet._content))
	await _shot("ficha_arma_proximo_nivel")
	sheet.set_tab(2)
	await get_tree().process_frame
	sheet._on_slot_chosen(sheet._first_slot(sheet._content))
	await _shot("ficha_passiva")
	sheet.set_tab(3)
	await get_tree().process_frame
	await _shot("ficha_bonus")
	get_tree().quit()
