extends Node
## SPEC-130: capturas da ficha C (4 abas, herói em início de run e herói cheio, foco em CA).
## godot --path . res://tools/capture_character_sheet.tscn --resolution 1280x720 -- --hero=sylas

func _ready() -> void:
	var hero := "sylas"
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--hero="):
			hero = argument.trim_prefix("--hero=")
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345}
	Game.run_stage = "dagruve"
	Game.run_hero = hero
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	await get_tree().create_timer(0.6).timeout
	run.set_process(false)
	run.set_physics_process(false)
	var size := get_viewport().get_visible_rect().size
	var tag := "%s_%dx%d" % [hero, int(size.x), int(size.y)]
	var dir := "res://.atena/generated/spec-130/"
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(dir))
	var b: Battle = run.battle
	b.active_cd = 4.0
	b.active_cd_max = 10.0
	var sheet: CharacterSheet = run.hud.items_panel
	for i in 4:
		run.hud.show_items_panel(b)
		sheet.set_tab(i)
		await get_tree().process_frame
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png("%s%s_inicio_aba%d.png" % [dir, tag, i])
	# herói cheio
	var rng := RandomNumberGenerator.new()
	rng.seed = 11
	for i in 14:
		var it := Items.roll(rng, 3, 0.0)
		b.hero.items[it.slot] = it
	b.hero.items["arma"]["level"] = Items.MAX_LEVEL
	var wdata: Dictionary = Data.table("weapons")
	for wid in wdata:
		if b.hero.weapons.size() >= b.hero.weapon_slots():
			break
		if not b.hero.weapons.any(func(w): return w.id == wid) and not wdata[wid].has("is_evolution"):
			b.hero.weapons.append(Weapon.make(wid, 5 if b.hero.weapons.size() == 1 else 2))
	for pid in ["forca", "inteligencia", "constituicao", "carisma"]:
		b.hero.passives[pid] = 3
	for pid in Data.table("passives"):
		if b.hero.passives.size() >= 9:
			break
		b.hero.passives[pid] = 2
	var boons: Array = Data.table("boons").boons
	for k in 3:
		b.hero.boons.append(boons[k])
	b.hero.recalc()
	for i in 4:
		run.hud.show_items_panel(b)
		sheet.set_tab(i)
		await get_tree().process_frame
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png("%s%s_cheio_aba%d.png" % [dir, tag, i])
	run.hud.show_items_panel(b)
	await get_tree().process_frame
	sheet._ca_btn.grab_focus()
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("%s%s_tooltip_ca.png" % [dir, tag])
	print("capture ok ", tag)
	get_tree().quit()
