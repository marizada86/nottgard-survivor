extends Node
## SPEC-166 (MEC-003, lote 2): capturas do título e das abas do Quartel (antes/depois do UiKit).
## godot --path . res://tools/capture_quartel.tscn --resolution 1280x720 [-- <pasta>] [-- --mobile]

var _dir := "res://.atena/generated/plan-093/capturas/"
var _prefix := ""

func _shot(name: String) -> void:
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var size := get_viewport().get_visible_rect().size
	get_viewport().get_texture().get_image().save_png("%s%s%s_%dx%d.png" % [_dir, _prefix, name, int(size.x), int(size.y)])

func _ready() -> void:
	for a in OS.get_cmdline_user_args():
		if a == "--mobile":
			Game.touch_preview = true
			_prefix = "mobile_"
		else:
			_dir = a if a.ends_with("/") else a + "/"
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_dir))
	# perfil e save descartáveis: nunca tocar no save real
	Game._save_path = "user://capture-quartel-profile.json"
	Game.profile = Profile.new({"name": "Captura Quartel", "welcome_seen": true, "coins": 1234})
	for id in Data.table("hqs"):
		Game.profile.data.hqs_seen[id] = true
	Playtest.visible = false
	var title: Control = load("res://ui/title.tscn").instantiate()
	add_child(title)
	await get_tree().create_timer(1.0).timeout
	await _shot("00_titulo")
	title.queue_free()
	await get_tree().process_frame
	var menu: Control = load("res://ui/menu.tscn").instantiate()
	add_child(menu)
	await get_tree().create_timer(0.6).timeout
	var tabs: TabContainer = menu.get_node("%Tabs")
	var names := []
	for i in tabs.get_tab_count():
		tabs.current_tab = i
		await get_tree().create_timer(0.3).timeout
		var tab_name := String(tabs.get_child(i).name)
		names.append(tab_name)
		await _shot("%02d_quartel_%s" % [i + 1, tab_name.to_lower().replace("í", "i").replace("ó", "o").replace("ç", "c").replace("õ", "o")])
	print("abas: ", names)
	get_tree().quit()
