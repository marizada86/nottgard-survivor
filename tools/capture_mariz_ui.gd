extends Node
## Relato T05/Mariz (EVID-250): fotografa a ficha C com o primeiro slot sob o cursor e a tela de resultado com 16 conquistas.
## godot --path . res://tools/capture_mariz_ui.tscn --resolution 1280x720 [-- --dir=res://pasta/ --tag=720]

var _dir := "res://.atena/generated/mariz-playtest/"
var _tag := "720"

func _ready() -> void:
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--dir="):
			_dir = argument.trim_prefix("--dir=")
		elif argument.begins_with("--tag="):
			_tag = argument.trim_prefix("--tag=")
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_dir))
	Playtest.visible = false
	Game.qa_sandbox = true
	var layer := CanvasLayer.new()
	add_child(layer)
	# 1) ficha C: cada aba, primeiro slot com foco (o mouse por cima faz o mesmo)
	var b := Battle.new(3, "durvall", "molor")
	var rng := RandomNumberGenerator.new()
	rng.seed = 7
	for i in 12:
		var it := Items.roll(rng, 2, 0.0)
		b.hero.items[it.slot] = it
	b.hero.recalc()
	var sheet := CharacterSheet.new()
	layer.add_child(sheet)
	sheet.show_sheet(b)
	for tab in 4:
		sheet.set_tab(tab)
		await get_tree().create_timer(0.3).timeout
		var first := _first_slot(sheet)
		if first != null:
			first.grab_focus()
		await get_tree().create_timer(0.2).timeout
		await _shot("ficha_aba%d_%s" % [tab, _tag])
	sheet.queue_free()
	await get_tree().process_frame
	# 2) tela de resultado com 16 conquistas
	var hud: CanvasLayer = load("res://ui/hud.tscn").instantiate()
	add_child(hud)
	var ids: Array = []
	for a in Data.table("achievements").achievements:
		ids.append(a.id)
		if ids.size() >= 16:
			break
	var res := {"won": false, "dead": true, "extracted": false, "hero": "durvall", "stage": "molor", "time": 2170.0,
		"level": 28, "kills": 2477, "bosses": 3, "descent_depth": 3, "reward_mult": 1.9, "abyss_level": 0}
	hud.show_result(res, {"earned": 1403, "reward_rate": 0.5, "coins": 2666, "achievements": ids})
	await get_tree().create_timer(0.6).timeout
	await _shot("resultado16_%s" % _tag)
	hud.show_result(res, {"earned": 1403, "reward_rate": 0.5, "coins": 2666, "achievements": ids.slice(0, 2)})
	await get_tree().create_timer(0.3).timeout
	await _shot("resultado2_%s" % _tag)
	get_tree().quit()

func _first_slot(node: Node) -> SheetSlot:
	if node is SheetSlot and node.is_visible_in_tree():
		return node
	for c in node.get_children():
		var r := _first_slot(c)
		if r != null:
			return r
	return null

func _shot(label: String) -> void:
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("%s%s.png" % [_dir, label])
