extends Node
## SPEC-182 (PLAN-107): capturas dos estados afetados pela integração da FILA-028.
## godot --path . res://tools/capture_fila028.tscn --resolution 1280x720 [-- <fase> <pasta>]
## Gera: ruína + baú, Eco perto, câmara selada e aberta, Arcanista, altar (3 instantes), 6 eventos aleatórios e a folha de 15 ícones.

var _dir := "res://.atena/generated/fila028-integration-2026-10-16/capturas/"
var _stage := "dagruve"
var _run: Node
var _b: Battle

func _shot(name: String) -> void:
	await get_tree().create_timer(0.15).timeout
	await RenderingServer.frame_post_draw
	_run.get_viewport().get_texture().get_image().save_png("%s%s_%s.png" % [_dir, _stage, name])

func _stage_spawn(kind: String, at: Vector2) -> Dictionary:
	_b._add_interaction(kind, at)
	var it: Dictionary = _b.interactions[-1]
	it.born_at = -10.0   # sem a animação de chegada
	return it

func _look_at(p: Vector2) -> void:
	_b.hero.pos = p + Vector2(0.0, 2.2)
	_run.set_process(false)
	_run.camera.position = Iso.to_screen(p) + Vector2(0.0, -40.0)
	await get_tree().create_timer(0.2).timeout

func _ready() -> void:
	for a in OS.get_cmdline_user_args():
		if a in ["dagruve", "docas", "shedaklah", "molor", "durao", "feng_tu", "shendilavri", "goranthis"]:
			_stage = a
		elif a != "--debug":
			_dir = a if a.ends_with("/") else a + "/"
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_dir))
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345}
	Game.run_stage = _stage
	Game.run_hero = "sylas"
	_run = load("res://ui/run.tscn").instantiate()
	add_child(_run)
	await get_tree().create_timer(0.6).timeout
	_run.set_physics_process(false)
	_run.set_process(false)
	_b = _run.battle
	var spec := _b.secrets_spec()
	# ruína + baú
	for it in _b.interactions:
		if it.has("ruin_art"):
			it.born_at = -10.0
			await _look_at(it.pos)
			await _shot("1_ruina_e_bau")
			break
	# Eco perto
	for eco in _b.ecos:
		_b.hero.pos = eco.pos + Vector2(0.0, 1.6)
		_run.camera.position = Iso.to_screen(eco.pos) + Vector2(0.0, -20.0)
		await get_tree().create_timer(0.2).timeout
		await _shot("2_eco_perto")
		break
	# câmara selada e aberta
	for it in _b.interactions:
		if String(it.kind) == "camara":
			it.born_at = -10.0
			await _look_at(it.pos)
			await _shot("3_camara_selada")
			_b.chamber_unlocked = true
			await get_tree().create_timer(0.2).timeout
			await _shot("4_camara_aberta")
			_b.chamber_unlocked = false
			break
	# Arcanista e altar em 3 instantes (900 ms de ciclo)
	var base := _b.hero.pos + Vector2(4.0, 0.0)
	_stage_spawn("arcanista", base)
	await _look_at(base)
	await _shot("5_arcanista")
	_stage_spawn("altar", base + Vector2(2.0, 0.0))
	await _look_at(base + Vector2(1.0, 0.0))
	for i in 3:
		await _shot("6_altar_%d" % i)
		await get_tree().create_timer(0.3).timeout
	# seis eventos aleatórios, lado a lado
	var ev_base := base + Vector2(0.0, 5.0)
	var kinds := ["pacto_sangue", "relicario", "peregrino", "contador", "carroca", "eclipse_pedra"]
	for i in kinds.size():
		_stage_spawn(kinds[i], ev_base + Vector2(float(i) * 1.6 - 4.0, 0.0))
	await _look_at(ev_base)
	await _shot("7_eventos")
	# folha de ícones a 48 px (legibilidade)
	var ids := [["weapons", "bola_de_fogo"], ["weapons", "tormenta_de_fogo"], ["weapons", "lamina_de_sombra"], ["weapons", "romper_armadura"],
		["weapons", "esmagar_defesas"], ["weapons", "dominio_da_vontade"], ["items", "cajado_familia_infernum"], ["items", "wave_of_terror"],
		["items", "colar_visao_verdadeira"], ["items", "detector_arcano"], ["items", "dispositivo_antimagia_gilly"], ["items", "dispositivo_das_docas"],
		["items", "coracao_da_dominancia"], ["boons", "lliira_juramento"], ["boons", "tou_um_caminho"]]
	var sheet := Image.create(15 * 56 + 8, 128 + 56 + 24, false, Image.FORMAT_RGBA8)
	sheet.fill(Color(0.12, 0.1, 0.1, 1.0))
	for i in ids.size():
		var img: Image = load("res://assets/icons/%s/%s.png" % [ids[i][0], ids[i][1]]).get_image()
		img.convert(Image.FORMAT_RGBA8)
		var big := img.duplicate()
		big.resize(64, 64, Image.INTERPOLATE_LANCZOS)
		sheet.blend_rect(big, Rect2i(0, 0, 64, 64), Vector2i(8 + (i % 8) * 72, 8 + (i / 8) * 72))
		var small := img.duplicate()
		small.resize(48, 48, Image.INTERPOLATE_LANCZOS)
		sheet.blend_rect(small, Rect2i(0, 0, 48, 48), Vector2i(8 + i * 56, 176))
	sheet.save_png("%sicones_64_e_48px.png" % _dir)
	print("capturas em ", _dir, " | pois: ", spec.get("pois", []).size(), " ecos: ", _b.ecos.size())
	get_tree().quit()
