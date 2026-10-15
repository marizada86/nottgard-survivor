extends Node
## SPEC-177 R5-E: confere em run real a Maré do Abismo (MEC-031 D4) e a revelação do loot (D6), com capturas.
## godot --path . res://tools/capture_juice_check.tscn --resolution 1280x720 [-- --dir=res://pasta/ --stage=dagruve]

var _dir := "res://.atena/generated/m2-game-feel/r5-e/"
var _stage := "dagruve"

func _ready() -> void:
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--dir="):
			_dir = argument.trim_prefix("--dir=")
		elif argument.begins_with("--stage="):
			_stage = argument.trim_prefix("--stage=")
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_dir))
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345}
	Game.run_stage = _stage
	Game.run_hero = "durvall"
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	for _i in 25:
		Game.controls.focused = true
		get_tree().paused = false
		await get_tree().create_timer(0.1).timeout
	var b: Battle = run.battle
	var report := {"stage": _stage}
	# D4: marcos da Maré (os abates são injetados pela mesma função que o jogo chama ao matar)
	var marks: Array = []
	var done := 0
	for target in [10, 25, 50]:
		while done < target:
			b._tide_kill()
			done += 1
		for _i in 3:
			await get_tree().physics_frame
		await get_tree().create_timer(0.25).timeout
		await _shot("mare_%03d" % target)
		marks.append({"abates": target, "bonus_xp": snappedf(b.tide_xp_bonus(), 0.001)})
	report["mare"] = marks
	# D6: revelação do loot por raridade
	for rarity in ["comum", "magico", "raro", "unico"]:
		run._loot_reveal({"name": "Item %s de teste" % rarity, "rarity": rarity})
		await get_tree().create_timer(0.14).timeout
		await _shot("loot_%s" % rarity)
		await get_tree().create_timer(0.9).timeout
	report["limite_textos_aux"] = run.AUX_TEXT_MAX
	var file := FileAccess.open("%sresumo.json" % _dir, FileAccess.WRITE)
	file.store_string(JSON.stringify(report, "\t"))
	file.close()
	print("juice ", report)
	get_tree().quit()

func _shot(label: String) -> void:
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("%s%s.png" % [_dir, label])
