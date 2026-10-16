extends Node
## SPEC-184 (PLAN-109): captura do título real (ui/title.tscn) a 1280x720.
## godot --path . res://tools/capture_title.tscn --resolution 1280x720 [-- <pasta>]

var _dir := "res://.atena/generated/logo-ln01-2026-10-16/capturas/"

func _ready() -> void:
	for a in OS.get_cmdline_user_args():
		if a != "--debug":
			_dir = a if a.ends_with("/") else a + "/"
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_dir))
	Playtest.visible = false
	var title: Node = load("res://ui/title.tscn").instantiate()
	add_child(title)
	await get_tree().create_timer(1.5).timeout
	await RenderingServer.frame_post_draw
	var size := get_viewport().get_visible_rect().size
	get_viewport().get_texture().get_image().save_png("%stitulo_%dx%d.png" % [_dir, int(size.x), int(size.y)])
	get_tree().quit()
