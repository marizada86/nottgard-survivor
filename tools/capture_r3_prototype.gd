extends Node
## SPEC-179 R3: PROTÓTIPO só desta ferramenta (nenhum arquivo do jogo muda): aplica a moldura da janela padrão (UiKit)
## às ofertas e ao painel de reviver, para mostrar a proposta antes/depois.
## godot --path . res://tools/capture_r3_prototype.tscn --resolution 1280x720 [-- --dir=res://pasta/]

var _dir := "res://.atena/generated/m3-onboarding/r3-prototipo/"

func _ready() -> void:
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--dir="):
			_dir = argument.trim_prefix("--dir=")
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_dir))
	Playtest.visible = false
	for t in [{"id": "levelup", "target": "levelup"}, {"id": "altar", "target": "altar"}, {"id": "reviver", "target": "revive_offer"}]:
		Game.qa_sandbox = true
		Game.qa_launch = {"seed": 12345, "target_state": t.target}
		Game.run_stage = "dagruve"
		Game.run_hero = "durvall"
		var run: Node = load("res://ui/run.tscn").instantiate()
		add_child(run)
		for _i in 12:
			Game.controls.focused = true
			get_tree().paused = false
			await get_tree().create_timer(0.1).timeout
		var hud = run.hud
		var panel: PanelContainer = hud.revive_panel if t.id == "reviver" else hud.levelup_panel
		UiKit.apply_window(panel, Vector2(panel.size.x + 80.0, panel.size.y + 80.0))
		await get_tree().create_timer(0.3).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png("%s%s.png" % [_dir, t.id])
		print("r3 prototipo ", t.id, " ", panel.size)
		run.queue_free()
		await get_tree().process_frame
	get_tree().quit()
