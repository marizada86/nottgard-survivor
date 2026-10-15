extends Node
## SPEC-177 R3: dispara a habilidade ativa de cada herói numa run real e fotografa o efeito.
## godot --path . res://tools/capture_ability_vfx.tscn --resolution 1280x720 [-- --dir=res://pasta/]

var _dir := "res://.atena/generated/m2-game-feel/habilidades-v01/"
var _only := ""

func _ready() -> void:
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--dir="):
			_dir = argument.trim_prefix("--dir=")
		elif argument.begins_with("--hero="):
			_only = argument.trim_prefix("--hero=")
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_dir))
	Playtest.visible = false
	var report: Array = []
	for hero_id in Data.table("heroes"):
		if _only != "" and not _only.split(",").has(hero_id):
			continue
		Game.qa_sandbox = true
		Game.qa_launch = {"seed": 12345, "level": 6}
		Game.run_stage = "dagruve"
		Game.run_hero = hero_id
		var run: Node = load("res://ui/run.tscn").instantiate()
		add_child(run)
		for _i in 60:   # 6 s de jogo; se a janela perder o foco o jogo pausa, entao desfazemos
			Game.controls.focused = true
			get_tree().paused = false
			await get_tree().create_timer(0.1).timeout
		var b: Battle = run.battle
		b.active_cd = 0.0
		b.hero.hp = b.hero.max_hp
		var fx_before: int = run.fx.get_child_count()
		b.aim_dir = Vector2(1, 0)
		for n in 3:   # alvos na frente: golpes corpo a corpo só disparam com inimigo no cone
			b.spawn_for_test("zumbi", b.hero.pos + Vector2(1.4 + n * 0.5, (n - 1) * 0.4))
		var fired: bool = b.use_active(Vector2(1, 0))
		var ability_id := String(b.active_def.get("id", ""))
		await get_tree().create_timer(0.18).timeout
		var fx_after: int = run.fx.get_child_count()
		await _shot("%s_%s" % [hero_id, ability_id])
		report.append({"hero": hero_id, "ability": ability_id, "fired": fired, "time": snappedf(b.time, 0.1), "fx_before": fx_before, "fx_after": fx_after, "has_vfx": HeroAbilityVfx.supports(ability_id)})
		print("ability ", report[-1])
		run.queue_free()
		await get_tree().process_frame
	var file := FileAccess.open("%sresumo.json" % _dir, FileAccess.WRITE)
	file.store_string(JSON.stringify(report, "\t"))
	file.close()
	get_tree().quit()

func _shot(label: String) -> void:
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("%s%s.png" % [_dir, label])
