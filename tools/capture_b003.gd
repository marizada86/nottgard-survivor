extends Node
## SPEC-185 (PLAN-110, B-003): Manifestação de Juiblex, Mímico e Turíbulo animados no EnemyView (idle, movimento, ataque, especial e morte).
## godot --path . res://tools/capture_b003.tscn --resolution 1280x720 [-- <pasta>]

var _dir := "res://.atena/generated/chatgpt-integration-2026-10-17/b003/capturas/"

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
	var ids := ["manifestacao_de_juiblex", "mimico", "totem_de_chefe", "zumbi"]
	var packed: PackedScene = load("res://ui/enemy_view.tscn")
	var views: Array = []
	for i in ids.size():
		var v = packed.instantiate()
		add_child(v)
		v.setup(Enemy.make(String(ids[i]), Vector2.ZERO))
		v.position = Vector2(180 + i * 300, 330)
		v.scale = Vector2(2.0, 2.0)
		views.append(v)
	await get_tree().create_timer(0.4).timeout
	await _shot("1_idle")
	# movimento
	for v in views:
		v.sync_visual(v.position + Vector2(8, 0))
	await get_tree().create_timer(0.25).timeout
	for v in views:
		v.sync_visual(v.position + Vector2(8, 0))
	await _shot("2_movimento")
	# ataque e especial
	for v in views:
		v.play_action(&"attack")
	await get_tree().create_timer(0.2).timeout
	await _shot("3_ataque")
	for v in views:
		v.play_action(&"special")
	await get_tree().create_timer(0.25).timeout
	await _shot("4_especial")
	for v in views:
		v.play_death()
	await get_tree().create_timer(0.2).timeout
	await _shot("5_morte_inicio")
	await get_tree().create_timer(0.3).timeout
	await _shot("6_morte_meio")
	await get_tree().create_timer(0.3).timeout
	await _shot("7_morte_fim")
	get_tree().quit()
