extends Node
## SPEC-179 R2: dispara cada dica de primeira vez numa run real e fotografa; confere teto, repeticao e a opcao Desligadas.
## godot --path . res://tools/capture_hints.tscn --resolution 1280x720 [-- --dir=res://pasta/]

var _dir := "res://.atena/generated/m3-onboarding/dicas/"

func _ready() -> void:
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--dir="):
			_dir = argument.trim_prefix("--dir=")
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_dir))
	Playtest.visible = false
	var report: Array = []
	var cases := [
		{"id": "extrair_descer", "stage": "dagruve", "target": "portal"},
		{"id": "ritual", "stage": "dagruve", "target": "ritual"},
		{"id": "bau_fonte", "stage": "dagruve", "target": "chest"},
		{"id": "altar", "stage": "dagruve", "target": "altar"},
		{"id": "item_novo", "stage": "dagruve", "target": "running"},
		{"id": "mare", "stage": "dagruve", "target": "running"},
		{"id": "questlog", "stage": "dagruve", "target": "running"},
	]
	for c in cases:
		report.append(await _case(c))
	# opcao Desligadas e teto entre dicas
	report.append(await _case({"id": "ritual", "stage": "dagruve", "target": "ritual", "off": true}))
	report.append(await _case({"id": "bau_fonte", "stage": "dagruve", "target": "chest", "block_with": "ritual"}))
	var file := FileAccess.open("%sresumo.json" % _dir, FileAccess.WRITE)
	file.store_string(JSON.stringify(report, "\t"))
	file.close()
	get_tree().quit()

func _case(c: Dictionary) -> Dictionary:
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345, "target_state": c.target}
	Game.run_stage = c.stage
	Game.run_hero = "durvall"
	Game.profile.data.settings["hints_seen"] = {}
	Game.profile.data.settings["hints"] = "off" if c.get("off", false) else "on"
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	for _i in 6:
		Game.controls.focused = true
		get_tree().paused = false
		await get_tree().create_timer(0.1).timeout
	var b: Battle = run.battle
	b.time = maxf(b.time, 40.0 if c.id == "questlog" else 14.0)
	if b.state == "levelup":   # o portal de QA mata o chefe e sobe de nível: escolhe e segue
		run._on_choose(0)
	if c.has("block_with"):
		run._hints.mark(String(c.block_with), b.time - 10.0)   # 10 s depois da ultima: deve ser barrado pelo intervalo
	if c.id == "questlog":
		b.chamber_seen = true   # a câmara selada aparece no Questlog quando o herói chega perto dela
	if c.id == "item_novo":
		run._hint_flags["item_novo"] = true
	if c.id == "mare":
		for _i in 10:
			b._tide_kill()
	for _i in 12:
		Game.controls.focused = true
		get_tree().paused = false
		await get_tree().create_timer(0.1).timeout
	for _i in 40:   # a dica entra na fila de avisos longos, atras da epigrafe da fase
		Game.controls.focused = true
		get_tree().paused = false
		await get_tree().create_timer(0.1).timeout
	var shown: bool = run._hints.seen.has(String(c.id))
	var label := String(c.id) + ("_desligadas" if c.get("off", false) else "") + ("_barrada" if c.has("block_with") else "")
	await _shot(label)
	var row := {"case": label, "mostrou": shown, "estado": b.state, "tempo": snappedf(b.time, 0.1)}
	print("dica ", row)
	run.queue_free()
	await get_tree().process_frame
	return row

func _shot(label: String) -> void:
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("%s%s.png" % [_dir, label])
