extends Node
## L1 (EVID-253): fotografa a lista de armas da HUD com a dica de evolução e a troca de item com o atual primeiro.
## godot --path . res://tools/capture_l1.tscn --resolution 1280x720

var _dir := "res://.atena/generated/mariz-playtest/"

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_dir))
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345, "level": 6}
	Game.run_stage = "dagruve"
	Game.run_hero = "durvall"
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	for _i in 15:
		Game.controls.focused = true
		get_tree().paused = false
		await get_tree().create_timer(0.1).timeout
	var b: Battle = run.battle
	b.hero.weapons[0].level = Weapon.MAX_LEVEL
	b.hero.recalc()
	for _i in 6:
		await get_tree().create_timer(0.1).timeout
	await _shot("l1_hud_arma_nivel_maximo")
	var rng := RandomNumberGenerator.new()
	rng.seed = 11
	var cur := Items.roll(rng, 1, 0.0)
	cur["level"] = 1
	b.hero.items[cur.slot] = cur
	b.hero.recalc()
	var better := cur.duplicate(true)
	better["name"] = "Peça melhor"
	better["id"] = "melhor_captura"
	better["mods"] = {}
	for k in cur.mods:
		better.mods[k] = float(cur.mods[k]) + 3.0
	b.give_item(better)
	for _i in 8:
		Game.controls.focused = true
		run.hud.pause_panel.visible = false
		await get_tree().create_timer(0.1).timeout
	await _shot("l1_troca_item_melhor")
	get_tree().quit()

func _shot(label: String) -> void:
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("%s%s.png" % [_dir, label])
