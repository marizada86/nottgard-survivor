extends Node
## QA local isolado: central e ranking sem acesso remoto.
func _ready() -> void:
	Game.profile.data.name = "QA sintetico"
	Game.profile.data.welcome_seen = true
	var menu: Node = load("res://ui/menu.tscn").instantiate()
	add_child(menu)
	await get_tree().create_timer(0.5).timeout
	if Playtest._guide_open:
		Playtest._close_guide_modal()
	Playtest.open_playtest()
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("res://.atena/generated/playtest-ranking/v01/central-1280.png")
	Playtest.close_playtest()
	var tabs := menu.get_node("Tabs") as TabContainer
	var rank := tabs.get_node("Ranking")
	tabs.current_tab = rank.get_index()
	rank.show_data({"ok": true, "entries": [{"rank": 1, "player": "Playtester sintetico", "score": 612, "active_seconds": 120}], "boards": [{"id": "test", "hero": "durvall", "stage": "dagruve", "difficulty": 1, "progress": "test"}], "board": "test"})
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("res://.atena/generated/playtest-ranking/v01/ranking-1280.png")
	print("capture: central e ranking sintetico")
	get_tree().quit()
