extends Node
## Relato T05/Mariz IN-078: passa o cursor sobre o primeiro item do painel do herói na HUD da run e fotografa (tooltip incluído).
## godot --path . res://tools/capture_mariz_hud.tscn --resolution 1280x720 [-- --tag=720]

var _dir := "res://.atena/generated/mariz-playtest/"
var _tag := "720"

func _ready() -> void:
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--tag="):
			_tag = argument.trim_prefix("--tag=")
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_dir))
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345, "level": 6}
	Game.run_stage = "molor"
	Game.run_hero = "durvall"
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	for _i in 20:
		Game.controls.focused = true
		get_tree().paused = false
		await get_tree().create_timer(0.1).timeout
	var b: Battle = run.battle
	var boons: Array = Data.table("boons").boons
	for i in 3:
		b.hero.boons.append(boons[i])
	b.hero.recalc()
	for _i in 10:
		await get_tree().create_timer(0.1).timeout
	var hud: CanvasLayer = run.hud
	var targets: Array = []
	var panel: Control = hud.hero_panel
	targets.append(["portrait", panel._portrait.get_global_rect().get_center()])
	for key in panel._chips:
		targets.append(["chip_%s" % key, (panel._chips[key] as Control).get_global_rect().get_center()])
	var i := 0
	for icon in panel.boon_row.get_children():
		targets.append(["boon%d" % i, (icon as Control).get_global_rect().get_center()])
		i += 1
	await _shot("hud_base_%s" % _tag)
	for t in targets:
		_move(t[1] + Vector2(-6, 0))
		await get_tree().process_frame
		_move(t[1])
		await get_tree().create_timer(1.1).timeout
		await _shot("hud_hover_%s_%s" % [t[0], _tag])
		print("hover ", t[0], " ", t[1])
	get_tree().quit()

func _move(pos: Vector2) -> void:
	var ev := InputEventMouseMotion.new()
	ev.position = pos
	ev.global_position = pos
	get_viewport().push_input(ev)
	Input.warp_mouse(pos)

func _shot(label: String) -> void:
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("%s%s.png" % [_dir, label])
