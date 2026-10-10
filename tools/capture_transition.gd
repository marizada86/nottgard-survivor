extends Node
## Transição jogo ↔ janela (fade ao abrir, dissolução ao fechar, fundo translúcido): fotos no meio e no fim de cada passo.
## godot --path . res://tools/capture_transition.tscn --resolution 1280x720 [-- --dir=res://pasta/]

var _dir := "res://.atena/generated/dev-033/capturas/"

func _shot(name: String) -> void:
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("%s%s.png" % [_dir, name])

func _wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func _ready() -> void:
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--dir="):
			_dir = argument.trim_prefix("--dir=")
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_dir))
	Playtest.visible = false
	Game.qa_sandbox = true   # só para montar a run sem mexer no save; os fades ligam logo depois
	Game.qa_launch = {"seed": 12345}
	Game.run_stage = "dagruve"
	Game.run_hero = "sylas"
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	await _wait(0.8)
	Game.qa_sandbox = false
	var b: Battle = run.battle
	var hud = run.hud
	await _shot("00_jogo")
	hud.show_items_panel(b)
	await _wait(0.09)
	await _shot("01_ficha_abrindo")
	await _wait(0.5)
	await _shot("02_ficha_aberta")
	hud.hide_items_panel()
	await _wait(0.06)
	await _shot("03_ficha_fechando")
	await _wait(0.5)
	await _shot("04_jogo_de_volta")
	hud.show_pause(true)
	await _wait(0.06)
	await _shot("05_pausa_abrindo")
	await _wait(0.5)
	await _shot("06_pausa_aberta")
	hud.show_pause(false)
	await _wait(0.06)
	await _shot("07_pausa_fechando")
	await _wait(0.5)
	print("capture ok transicao")
	get_tree().quit()
