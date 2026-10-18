extends Node
## SPEC-185 (PLAN-110, B-002): interações, NPCs, pontos de evento, eventos, segredos, ruínas e baús com as tiras de idle e de abertura.
## godot --path . res://tools/capture_b002.tscn --resolution 1280x720 [-- <pasta>]
## Gera, para cada grupo, 3 quadros espaçados (o ciclo de 4 quadros a 5 fps dura 0,8 s) e a abertura dos baús.

var _dir := "res://.atena/generated/chatgpt-integration-2026-10-17/b002/capturas/"
var _run: Node
var _b: Battle

func _shot(name: String) -> void:
	await get_tree().create_timer(0.05).timeout
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("%s%s.png" % [_dir, name])

func _spawn(kind: String, at: Vector2, extra: Dictionary = {}) -> void:
	_b.interactions.append({"kind": kind, "pos": at, "used": false, "born_at": -10.0}.merged(extra, true))

func _group(name: String, center: Vector2) -> void:
	_run.camera.position = Iso.to_screen(center) + Vector2(0.0, -50.0)
	_b.hero.pos = center + Vector2(0.0, 6.0)

func _frames(name: String) -> void:
	for i in 3:
		await get_tree().create_timer(0.27).timeout
		await _shot("%s_%d" % [name, i])

func _ready() -> void:
	for a in OS.get_cmdline_user_args():
		if a != "--debug":
			_dir = a if a.ends_with("/") else a + "/"
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_dir))
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345}
	Game.run_stage = "dagruve"
	Game.run_hero = "sylas"
	_run = load("res://ui/run.tscn").instantiate()
	add_child(_run)
	await get_tree().create_timer(0.6).timeout
	_run.set_process(false)
	_run.set_physics_process(false)
	_b = _run.battle
	_b.interactions.clear()
	_b.chamber_unlocked = false
	var base := Vector2(20.0, 20.0)
	# 1) interações de serviço e eventos de mesa
	var kinds := ["loja", "ferreiro", "curandeiro", "doacao", "aposta", "ampulheta", "arcanista"]
	for i in kinds.size():
		_spawn(kinds[i], base + Vector2(float(i) * 1.7 - 5.0, 0.0))
	_group("servicos", base)
	await _frames("1_servicos")
	_b.interactions.clear()
	# 2) eventos aleatórios e segredos
	var ev := ["pacto_sangue", "relicario", "peregrino", "contador", "carroca", "eclipse_pedra", "camara"]
	for i in ev.size():
		_spawn(ev[i], base + Vector2(float(i) * 1.7 - 5.0, 0.0))
	_group("eventos", base)
	await _frames("2_eventos")
	_b.chamber_unlocked = true
	await _frames("2b_camara_aberta")
	_b.chamber_unlocked = false
	_b.interactions.clear()
	# 3) pontos de evento (arte de acontecimento)
	var pts := ["trono_zuggtmoy", "arco_pedra", "massa_thullgrime", "estrela_do_norte", "coracao_limo", "esporo_zuggtmoy", "limo_juiblex"]
	for i in pts.size():
		_spawn("event_item", base + Vector2(float(i) * 1.7 - 5.0, 0.0), {"asset": pts[i], "label": pts[i], "color": Color(0.9, 0.8, 0.5)})
	_group("pontos", base)
	await _frames("3_pontos")
	_b.interactions.clear()
	# 4) NPCs aliados
	var npcs := ["npc_joao_barbosa", "npc_desertor_durao", "npc_vitima_enfeiticada", "npc_nyxara", "npc_vaelis", "npc_reaper_barqueiro", "npc_vhaerith_aetherion", "npc_mercador_rivenheart"]
	_b.happenings.allies.clear()
	for i in npcs.size():
		_b.happenings.allies.append({"pos": base + Vector2(float(i) * 1.5 - 5.0, 0.0), "asset": npcs[i], "sprite": "", "hp": 10, "max_hp": 10, "label": "", "role": "ally"})
	_group("npcs", base)
	await _frames("4_npcs")
	_b.happenings.allies.clear()
	# 5) ruínas atrás do baú e Eco
	_spawn("chest", base, {"ruin_art": "ruina_dagruve", "fixed": true, "name": "Capela"})
	_spawn("chest", base + Vector2(4.0, 0.0), {"ruin_art": "ruina_feng_tu", "fixed": true, "name": "Templo"})
	_spawn("chest", base + Vector2(8.0, 0.0), {"ruin_art": "ruina_molor", "fixed": true, "name": "Gruta"})
	_b.ecos.clear()
	_b.ecos.append({"id": "x", "pos": base + Vector2(12.0, 0.0), "found": false, "texto": "", "fonte": "", "onde": "ruina"})
	_group("ruinas", base + Vector2(6.0, 0.0))
	_b.hero.pos = base + Vector2(11.5, 1.5)
	await _frames("5_ruinas_e_eco")
	_b.interactions.clear()
	_b.ecos.clear()
	# 6) abertura dos baús
	_spawn("chest", base + Vector2(-1.5, 0.0))
	_spawn("boss_chest", base + Vector2(1.5, 0.0))
	_group("baus", base)
	await get_tree().create_timer(0.2).timeout
	await _shot("6_baus_fechados")
	_b.interactions.clear()
	_run._play_interaction({"kind": "chest", "pos": base + Vector2(-1.5, 0.0)})
	_run._play_interaction({"kind": "boss_chest", "pos": base + Vector2(1.5, 0.0)})
	await get_tree().create_timer(0.12).timeout
	await _shot("6_baus_abrindo_1")
	await get_tree().create_timer(0.2).timeout
	await _shot("6_baus_abrindo_2")
	await get_tree().create_timer(0.3).timeout
	await _shot("6_baus_abrindo_3")
	print("capturas em ", _dir)
	get_tree().quit()
