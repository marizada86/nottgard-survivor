extends Node
## SPEC-185 (PLAN-110, B-002): os 12 quebráveis antes de quebrar e em 3 instantes da tira de morte, lado a lado sobre o chão.
## godot --path . res://tools/capture_breakables.tscn --resolution 1280x720 [-- <pasta>]

var _dir := "res://.atena/generated/chatgpt-integration-2026-10-17/b002/capturas/"

func _shot(name: String) -> void:
	await get_tree().create_timer(0.05).timeout
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("%s%s.png" % [_dir, name])

func _ready() -> void:
	for a in OS.get_cmdline_user_args():
		if a != "--debug":
			_dir = a if a.ends_with("/") else a + "/"
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_dir))
	Playtest.visible = false
	var bg := ColorRect.new()
	bg.color = Color(0.2, 0.19, 0.21)
	bg.size = Vector2(1280, 720)
	add_child(bg)
	var ids: Array = load("res://ui/enemy_view.gd").DEATH_ONLY
	var packed: PackedScene = load("res://ui/enemy_view.tscn")
	var views: Array = []
	for i in ids.size():
		var v = packed.instantiate()
		add_child(v)
		v.setup(Enemy.make(String(ids[i]), Vector2.ZERO))
		v.position = Vector2(180 + (i % 4) * 300, 190 + (i / 4) * 220)
		v.scale = Vector2(2.2, 2.2)
		views.append(v)
	await get_tree().create_timer(0.3).timeout
	await _shot("quebraveis_0_antes")
	for v in views:
		v.play_death()
	await get_tree().create_timer(0.17).timeout
	await _shot("quebraveis_1_inicio")
	await get_tree().create_timer(0.22).timeout
	await _shot("quebraveis_2_meio")
	await get_tree().create_timer(0.16).timeout
	await _shot("quebraveis_3_fim")
	get_tree().quit()
