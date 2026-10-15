extends Node
## SPEC-179 R1: fotografa o que o jogador novo ve em cada momento-chave (level-up, altar, bau, fonte, ritual, chefe, portal, vitoria).
## godot --path . res://tools/capture_first_ui.tscn --resolution 1280x720 [-- --dir=res://pasta/ --stage=dagruve]

var _dir := "res://.atena/generated/m3-onboarding/ui-primeiros-encontros/"
var _stage := "dagruve"
## alvo do qa_prepare; interact = true chama Battle.interact() em seguida (bau, fonte, ritual)
const TARGETS := [
	{"id": "levelup", "target": "levelup", "interact": false},
	{"id": "altar", "target": "altar", "interact": false},
	{"id": "bau_perto", "target": "chest", "interact": false},
	{"id": "bau_aberto", "target": "chest", "interact": true},
	{"id": "fonte_perto", "target": "fountain", "interact": false},
	{"id": "fonte_usada", "target": "fountain", "interact": true},
	{"id": "ritual_perto", "target": "ritual", "interact": false},
	{"id": "ritual_usado", "target": "ritual", "interact": true},
	{"id": "chefe_70", "target": "boss_70", "interact": false},
	{"id": "portal", "target": "portal", "interact": false},
	{"id": "vitoria", "target": "victory", "interact": false},
]

func _ready() -> void:
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--dir="):
			_dir = argument.trim_prefix("--dir=")
		elif argument.begins_with("--stage="):
			_stage = argument.trim_prefix("--stage=")
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_dir))
	Playtest.visible = false
	var report: Array = []
	for t in TARGETS:
		Game.qa_sandbox = true
		Game.qa_launch = {"seed": 12345, "target_state": t.target}
		Game.run_stage = _stage
		Game.run_hero = "durvall"
		var run: Node = load("res://ui/run.tscn").instantiate()
		add_child(run)
		for _i in 12:
			Game.controls.focused = true
			get_tree().paused = false
			await get_tree().create_timer(0.1).timeout
		var b: Battle = run.battle
		if t.interact:
			b.hero.pos = b.hero.pos   # o interativo nasce ao lado do heroi
			var ok: bool = b.interact()
			for _i in 8:
				await get_tree().create_timer(0.1).timeout
			report.append({"id": t.id, "interact": ok, "state": b.state})
		else:
			report.append({"id": t.id, "state": b.state})
		await _shot(String(t.id))
		print("primeira ui ", report[-1])
		run.queue_free()
		await get_tree().process_frame
	var file := FileAccess.open("%sresumo.json" % _dir, FileAccess.WRITE)
	file.store_string(JSON.stringify(report, "\t"))
	file.close()
	get_tree().quit()

func _shot(label: String) -> void:
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("%s%s.png" % [_dir, label])
