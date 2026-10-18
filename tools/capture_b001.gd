extends Node
## SPEC-185 (PLAN-110, B-001): capturas das peças de UI e névoa integradas.
## godot --path . res://tools/capture_b001.tscn --resolution 1280x720 [-- <pasta>]
## Gera: menu com botão JOGAR, barra de progresso (fase e chefe), catálogo (inimigos e armas), pilar, névoa de borda e frente da Maré.

var _dir := "res://.atena/generated/chatgpt-integration-2026-10-17/b001/capturas/"
var _run: Node
var _b: Battle

func _shot(name: String) -> void:
	await get_tree().create_timer(0.2).timeout
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("%s%s.png" % [_dir, name])

func _ready() -> void:
	for a in OS.get_cmdline_user_args():
		if a != "--debug":
			_dir = a if a.ends_with("/") else a + "/"
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_dir))
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345}
	# menu (botão de ação)
	var menu: Node = load("res://ui/menu.tscn").instantiate()
	add_child(menu)
	await get_tree().create_timer(0.8).timeout
	await _shot("1_menu_botao_jogar")
	menu.queue_free()
	await get_tree().process_frame
	# partida
	Game.run_stage = "dagruve"
	Game.run_hero = "sylas"
	_run = load("res://ui/run.tscn").instantiate()
	add_child(_run)
	await get_tree().create_timer(0.6).timeout
	_run.set_process(false)
	_run.set_physics_process(false)
	_b = _run.battle
	_b.codex.enemies["cultista"] = true
	_b.codex.weapons["bola_de_fogo"] = true
	_b.time = float(_b.stage.duration) * 0.55
	_run.hud.update_stats(_b)
	await _shot("2_barra_fase")
	_b.boss_spawned = true
	_run.hud.update_stats(_b)
	await _shot("3_barra_chefe")
	_b.boss_spawned = false
	# catálogo
	_run.hud.show_pause(true)
	_run.hud.pause_menu.set_tab(1)
	await _shot("4_catalogo_inimigos")
	_run.hud.pause_menu.set_category(1)
	await _shot("5_catalogo_armas")
	_run.hud.show_pause(false)
	# pilar: um prop de cada variante lado a lado
	var base := _b.hero.pos + Vector2(3.0, 0.0)
	for i in 3:
		var p: Node2D = load("res://ui/prop.gd").new()
		p.set("kind", "pilar")
		p.position = Iso.to_screen(base + Vector2(float(i) * 2.0, 0.0))
		p.set("height", 120.0)
		_run.add_child(p)
	_run.camera.position = Iso.to_screen(base + Vector2(2.0, 0.0)) + Vector2(0.0, -40.0)
	await _shot("6_pilares")
	# névoa de borda: herói na margem do mapa
	var size: Vector2 = _b.map_size if "map_size" in _b else Vector2(60, 60)
	_b.hero.pos = Vector2(size.x * 0.5, 1.0)
	_run.camera.position = Iso.to_screen(_b.hero.pos)
	if _run._edge_fog != null:
		_run._edge_fog.proximity = 1.0
	await _shot("7_nevoa_de_borda")
	if _run._edge_fog != null:
		_run._edge_fog.proximity = 0.0
	# frente da Maré
	_b.boss_dead = true
	_b.fog_state = "advancing"
	_b.fog_intensity = 0.7
	_run._update_fog_overlay()
	await _shot("8_frente_da_mare")
	print("capturas em ", _dir)
	get_tree().quit()
