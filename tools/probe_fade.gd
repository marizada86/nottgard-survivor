extends Node
## Mede, quadro a quadro, o alfa da ficha ao abrir (fade) e se a janela segue visível; só leitura.
## godot --path . res://tools/probe_fade.tscn --resolution 1280x720
func _ready() -> void:
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345}
	Game.run_stage = "dagruve"
	Game.run_hero = "sylas"
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	await get_tree().create_timer(0.8).timeout
	Game.qa_sandbox = false
	var sheet: CanvasItem = run.hud.items_panel
	var t0 := Time.get_ticks_msec()
	run.hud.show_items_panel(run.battle)
	var rows: Array = []
	for i in 30:
		await get_tree().process_frame
		rows.append("%d ms alfa=%.2f visivel=%s" % [Time.get_ticks_msec() - t0, sheet.modulate.a, str(sheet.visible)])
	print("\n".join(rows))
	get_tree().quit()
