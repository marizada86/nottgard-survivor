extends Node
## SPEC-139: capturas reais da ficha, sem gravar o perfil do dono.
var failures: Array[String] = []
var layouts: Array = []
var directory := "res://.atena/generated/ficha-c-integration/v01/"
var tag := "desktop"

func _ready() -> void:
	if Game.touch_controls_enabled():
		tag = "mobile"
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345}
	Game.run_stage = "dagruve"
	Game.run_hero = "sylas"
	for hq_id in Data.table("hqs"):
		Game.profile.data.hqs_seen[hq_id] = true
	Game.profile.data.settings.controller = {"family": "auto"}
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	await get_tree().create_timer(0.6).timeout
	run.set_process(false)
	run.set_physics_process(false)
	var battle: Battle = run.battle
	battle.active_cd = 4.0
	battle.active_cd_max = 10.0
	var sheet: CharacterSheet = run.hud.items_panel
	for tab in 4:
		run.hud.show_items_panel(battle)
		sheet.set_tab(tab)
		await capture(sheet, "inicio_aba%d" % tab)
	var rng := RandomNumberGenerator.new()
	rng.seed = 11
	for i in 14:
		var item := Items.roll(rng, 3, 0.0)
		battle.hero.items[item.slot] = item
	battle.hero.items["arma"]["level"] = Items.MAX_LEVEL
	var weapons: Dictionary = Data.table("weapons")
	for id in weapons:
		if battle.hero.weapons.size() >= battle.hero.weapon_slots():
			break
		if not battle.hero.weapons.any(func(w): return w.id == id) and not weapons[id].has("is_evolution"):
			battle.hero.weapons.append(Weapon.make(id, 5 if battle.hero.weapons.size() == 1 else 2))
	for id in ["forca", "inteligencia", "constituicao", "carisma"]:
		battle.hero.passives[id] = 3
	for id in Data.table("passives"):
		if battle.hero.passives.size() >= 9:
			break
		battle.hero.passives[id] = 2
	var boons: Array = Data.table("boons").boons
	for i in 3:
		battle.hero.boons.append(boons[i])
	battle.hero.recalc()
	for tab in 4:
		run.hud.show_items_panel(battle)
		sheet.set_tab(tab)
		await capture(sheet, "cheio_aba%d" % tab)
	run.hud.show_items_panel(battle)
	await get_tree().process_frame
	sheet._ca_btn.grab_focus()
	await capture(sheet, "tooltip_ca")
	if not Game.touch_controls_enabled():
		Game.controls.method = "controller"
		Game.profile.data.settings.controller["family"] = "xbox"
		Game.controls.changed.emit()
		await capture(sheet, "controle_xbox")
		Game.profile.data.settings.controller["family"] = "ps5"
		Game.controls.changed.emit()
		await capture(sheet, "controle_playstation")
	# Os nomes e as descricoes dos outros herois tambem precisam caber.
	for hero_id in Data.table("heroes"):
		var other := Battle.new(3, hero_id, "dagruve")
		sheet.show_sheet(other)
		await capture(sheet, "heroi_" + hero_id)
	var output := FileAccess.open(directory + tag + "-layout.json", FileAccess.WRITE)
	output.store_string(JSON.stringify({"layouts": layouts, "failures": failures}, "\t"))
	for failure in failures:
		printerr(failure)
	print("Ficha C ", tag, ": ", layouts.size(), " capturas, ", failures.size(), " falhas de geometria")
	get_tree().quit(0 if failures.is_empty() else 1)

func capture(sheet: CharacterSheet, label: String) -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var viewport := get_viewport().get_visible_rect()
	var panel := sheet._panel.get_global_rect()
	if not viewport.encloses(panel):
		failures.append(label + ": painel fora do viewport " + str(panel))
	for button in sheet._tab_buttons + [sheet._close_btn]:
		if not panel.encloses(button.get_global_rect()):
			failures.append(label + ": botao fora do painel " + button.text)
	layouts.append({"label": label, "panel": [panel.position.x, panel.position.y, panel.size.x, panel.size.y],
		"viewport": [viewport.size.x, viewport.size.y], "scroll_height": sheet._scroll.size.y})
	get_viewport().get_texture().get_image().save_png(directory + tag + "_" + label + ".png")
