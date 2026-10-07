extends Node

@onready var root: Window = get_tree().root
## Piloto local com perfil separado. --mobile-check executa provas de integração.

const OUTPUT := "res://.atena/generated/mobile-controls/v02/"
var failures: Array[String] = []
var capture := false
var _real_save_before: Dictionary

func _ready() -> void:
	call_deferred("_start")

func _start() -> void:
	root.size = Vector2i(1280, 720)
	Game.touch_preview = true
	_real_save_before = Game.real_save_signature()
	Input.use_accumulated_input = false
	var suffix := "check" if "--mobile-check" in OS.get_cmdline_user_args() else ("smoke" if "--mobile-smoke" in OS.get_cmdline_user_args() or "--desktop-smoke" in OS.get_cmdline_user_args() else "preview")
	Game._save_path = OUTPUT + suffix + "-profile.json"
	Game.load_profile()
	Game.profile.data.name = "Teste mobile local"
	Game.profile.data.welcome_seen = true
	if Playtest._guide_open:
		Playtest._close_guide_modal()
	get_tree_pause(false)
	if "--mobile-smoke" in OS.get_cmdline_user_args() or "--desktop-smoke" in OS.get_cmdline_user_args():
		Game.touch_preview = "--mobile-smoke" in OS.get_cmdline_user_args()
		for id in Data.table("hqs"):
			Game.profile.data.hqs_seen[id] = true
		get_tree().change_scene_to_file("res://tools/smoke.tscn")
	elif "--mobile-check" in OS.get_cmdline_user_args():
		capture = "--mobile-capture" in OS.get_cmdline_user_args()
		await _check()
		if Game.real_save_signature() != _real_save_before:
			failures.append("save real alterado durante piloto")
		for failure in failures:
			printerr("FALHA MOBILE: ", failure)
		print("mobile integration: %d falha(s)" % failures.size())
		get_tree().quit(0 if failures.is_empty() else 1)
	else:
		Game.logline("Piloto mobile local P067-v02; joystick nos dois lados, perfil isolado.")
		get_tree().change_scene_to_file("res://ui/title.tscn")

func get_tree_pause(value: bool) -> void:
	get_tree().paused = value

func _touch(index: int, point: Vector2, pressed: bool, canceled: bool = false) -> void:
	var event := InputEventScreenTouch.new()
	event.index = index
	event.position = point
	event.pressed = pressed
	event.canceled = canceled
	root.push_input(event, true)

func _drag(index: int, point: Vector2) -> void:
	var event := InputEventScreenDrag.new()
	event.index = index
	event.position = point
	root.push_input(event, true)

func _tap(index: int, point: Vector2) -> void:
	_touch(index, point, true)
	_touch(index, point, false)

func _frames(count: int = 3) -> void:
	for i in count:
		await get_tree().process_frame

func _shot(name: String) -> void:
	if not capture:
		return
	await RenderingServer.frame_post_draw
	var error := root.get_texture().get_image().save_png(OUTPUT + name + ".png")
	if error != OK:
		failures.append("captura falhou: " + name)

func _check() -> void:
	print("Perfil de teste: ", Game._save_path)
	# Evita HQ de boas-vindas durante a prova de movimento; leitor é testado abaixo.
	for id in Data.table("hqs"):
		Game.profile.data.hqs_seen[id] = true
	for id in Data.table("stages"):
		Game.profile.data.achievements["stage_reached_" + id] = true
	var menu = load("res://ui/menu.tscn").instantiate()
	root.add_child(menu)
	await _frames()
	await _shot("menu-16x9")
	menu.queue_free()
	await _frames()
	var run = load("res://ui/run.tscn").instantiate()
	root.add_child(run)
	get_tree().current_scene = run
	await _frames(6)
	run.set_physics_process(false)
	run.battle.state = "running"
	run.hud.update_stats(run.battle)
	await _frames()
	var mobile: MobileControls = run.hud.mobile
	var point := Vector2(180, root.get_visible_rect().size.y - 160)
	print("Antes do toque: viewport=", root.get_visible_rect(), " enabled=", mobile.combat_enabled, " paused=", get_tree().paused, " state=", run.battle.state)
	_touch(1, point, true)
	_drag(1, point + Vector2(100, 0))
	print("Depois do toque: dedo=", mobile.movement_finger, " movimento=", mobile.movement)
	await _frames()
	var before: Vector2 = run.battle.hero.pos
	run._physics_process(0.2)
	if run.battle.hero.pos.distance_to(before) < 0.01:
		failures.append("toque real nao deslocou heroi")
	var held := mobile.movement
	run.battle._spawn("zumbi", run.battle.hero.pos + Vector2(1, 0))
	_tap(2, mobile.regions[&"hero_active"].get_center())
	if mobile.movement != held or run.battle.active_cd <= 0:
		failures.append("habilidade simultanea falhou ou roubou joystick")
	run.hud.update_stats(run.battle)
	await _shot("combate-16x9")
	_touch(1, point, false)
	if mobile.movement != Vector2.ZERO:
		failures.append("soltar dedo deixou heroi andando")
	_touch(3, point, true)
	_drag(3, point + Vector2(72, 0))
	_tap(4, mobile.regions[Game.ACTION_RUN_ITEMS].get_center())
	if not get_tree().paused or mobile.movement != Vector2.ZERO:
		failures.append("inventario nao limpou movimento ou nao pausou")
	await _frames()
	await _shot("ficha-16x9")
	var close: Button = run.hud.items_panel._close_btn
	_tap(5, close.get_global_rect().get_center())
	await _frames()
	if get_tree().paused or run.hud.items_panel.visible:
		failures.append("ficha nao fechou por toque")
	_drag(3, point + Vector2(150, 0))
	if mobile.movement != Vector2.ZERO:
		failures.append("modal reutilizou dedo antigo")
	for hero in Data.table("heroes"):
		var b := Battle.new(43, hero, "dagruve")
		b.aim = Battle.Aim.AUTO
		b._spawn("zumbi", b.hero.pos + Vector2(1, 0))
		run.battle = b
		run._mobile_command(&"hero_active")
		if b.active_cd <= 0:
			failures.append("habilidade nao ativou: " + hero)
	run.battle = Battle.new(43, "durvall", "dagruve")
	run.battle._open_levelup()
	run.hud.show_offer(run.battle)
	await _frames()
	var offer: Button = run.hud._offer_buttons[0]
	_tap(6, offer.get_global_rect().get_center())
	if run.battle.state != "levelup" or run.hud._offer_selected != 0:
		failures.append("oferta nao foi selecionada sem aplicar")
	await _frames()
	await _shot("oferta-16x9")
	_tap(7, run.hud._offer_confirm.get_global_rect().get_center())
	await _frames()
	if run.battle.state == "levelup":
		failures.append("oferta nao confirmou por toque")
	# Interação contextual e cancelamento de extração preservam a tentativa.
	run.battle.interactions.append({"kind": "loja", "pos": run.battle.hero.pos, "used": false, "born_at": -1.0})
	run.hud.update_stats(run.battle)
	await _frames()
	_tap(10, mobile.regions[Game.ACTION_RUN_INTERACT].get_center())
	if run.battle.state != "shop" or mobile.movement != Vector2.ZERO:
		failures.append("interacao contextual nao abriu loja")
	var leave := -1
	for i in run.battle.offer.size():
		if run.battle.offer[i].t == "shop_leave":
			leave = i
	if leave >= 0:
		run._on_choose(leave)
	run.battle.stage_cleared = true
	run.hud.update_stats(run.battle)
	await _frames()
	_tap(11, mobile.regions[Game.ACTION_RUN_EXTRACT].get_center())
	if not run.hud._confirm_dialog.visible or not get_tree().paused:
		failures.append("extracao nao solicitou confirmacao")
	run.hud._confirm_dialog.hide()
	run.hud._cancel_mobile_action()
	await _frames()
	if get_tree().paused or run.battle.state != "running":
		failures.append("cancelar extracao nao restaurou combate")
	_touch(12, point, true)
	_drag(12, point + Vector2(72, 0))
	run._notification(Node.NOTIFICATION_APPLICATION_FOCUS_OUT)
	if not get_tree().paused or mobile.movement != Vector2.ZERO:
		failures.append("perda de foco nao pausou e limpou movimento")
	run._toggle_pause()
	await _frames()
	for resolution in [Vector2i(1600, 720), Vector2i(1280, 960)]:
		root.size = resolution
		await _frames(6)
		print("Layout: janela=", root.size, " viewport=", root.get_visible_rect().size)
		run.hud.update_stats(run.battle)
		await _shot("combate-" + str(resolution.x) + "x" + str(resolution.y))
		run._toggle_items_panel()
		await _frames()
		await _shot("ficha-" + str(resolution.x) + "x" + str(resolution.y))
		run._close_items_panel()
		await _frames()
	run.queue_free()
	await _frames()
	for resolution in [Vector2i(1280, 720), Vector2i(1600, 720), Vector2i(1280, 960)]:
		var menu_layout = load("res://ui/menu.tscn").instantiate()
		root.add_child(menu_layout)
		await _frames()
		root.size = resolution
		await _frames(6)
		await _shot("menu-" + str(resolution.x) + "x" + str(resolution.y))
		menu_layout.queue_free()
		await _frames()
	root.size = Vector2i(1280, 720)
	var reader = load("res://ui/hq_screen.tscn").instantiate()
	root.add_child(reader)
	reader.start_hq(Data.table("hqs").values()[0])
	await _frames()
	var buttons: HBoxContainer = reader.get_node("TouchUI").get_parent().get_child(reader.get_child_count() - 2)
	_tap(8, buttons.get_child(0).get_global_rect().get_center())
	if reader.panel_index != 1:
		failures.append("HQ nao avancou por toque")
	_tap(9, buttons.get_child(1).get_global_rect().get_center())
	if not reader.is_closed:
		failures.append("HQ nao fechou por toque")
	reader.queue_free()
	await _frames()
