extends Node
## M2 R5 (SPEC-177, opcoes A e B): fotografa a vinheta de vida baixa, o flash de golpe e os numeros de dano.
## godot --path . res://tools/capture_danger_feel.tscn --resolution 1280x720 [-- --dir=res://pasta/ --stage=dagruve --hero=durvall]
## Joga ~10 s com um kite simples, depois forca a vida a 25 %, recebe um golpe e repete com "impacto reduzido". Nao altera o save.

var _dir := "res://.atena/generated/m2-game-feel/r5/depois/"
var _stage := "dagruve"
var _hero := "durvall"
var _keys := {}

func _ready() -> void:
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--dir="):
			_dir = argument.trim_prefix("--dir=")
		elif argument.begins_with("--stage="):
			_stage = argument.trim_prefix("--stage=")
		elif argument.begins_with("--hero="):
			_hero = argument.trim_prefix("--hero=")
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_dir))
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345}
	Game.run_stage = _stage
	Game.run_hero = _hero
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	await get_tree().create_timer(0.4).timeout
	var b: Battle = run.battle
	var report := {"stage": _stage, "hero": _hero}
	await _play(b, run, 10.0)
	report["numeros_no_fim_do_kite"] = run.get("_text_fx").get_child_count()
	await _shot("%s_00_normal" % _stage)
	var max_hp: float = b.hero.max_hp
	b.hero.hp = max_hp * 0.25
	await _play(b, run, 1.2)
	await _shot("%s_01_vida_baixa" % _stage)
	await _play(b, run, 0.5)
	await _shot("%s_02_vida_baixa_pulso" % _stage)
	b.hero.hp = max_hp * 0.9
	await _play(b, run, 1.0)
	b.hero.hp = max_hp * 0.9
	b.hero.hp = max_hp * 0.9 - max_hp * 0.2
	b.events.append({"type": "hurt", "pos": b.hero.pos, "amount": int(max_hp * 0.2)})
	await get_tree().physics_frame
	await get_tree().physics_frame
	await _shot("%s_03_golpe_recebido" % _stage)
	Game.profile.data.settings["reduced_impact"] = true
	b.hero.hp = max_hp * 0.25
	await _play(b, run, 1.5)
	await _shot("%s_04_vida_baixa_impacto_reduzido" % _stage)
	var danger = run.get("_danger")
	report["vinheta"] = danger != null
	report["alpha_reduzido"] = snappedf(danger.alpha(), 0.001) if danger != null else -1.0
	_release()
	var file := FileAccess.open("%s%s_resumo.json" % [_dir, _stage], FileAccess.WRITE)
	file.store_string(JSON.stringify(report, "\t"))
	file.close()
	print("danger feel: ", report)
	run.queue_free()
	get_tree().quit()

func _play(b: Battle, run: Node, secs: float) -> void:
	var until := b.time + secs
	while b.time < until and b.state != "dead" and b.state != "won":
		if b.state in ["levelup", "altar", "item_offer", "shop"]:
			if b.state == "levelup":
				run._on_choose(0)
			else:
				break
			await get_tree().process_frame
			continue
		_drive(b)
		await get_tree().physics_frame

func _drive(b: Battle) -> void:
	var h := b.hero
	var v := Vector2.ZERO
	var nearest: Variant = null
	var nearest_d := 14.0
	for e in b.enemies:
		var off: Vector2 = h.pos - e.pos
		var d := off.length()
		if d < nearest_d:
			nearest_d = d
			nearest = e
		if d < 3.2 and d > 0.01:
			v += off / d * (1.0 / maxf(0.4, d * d))
	if nearest != null and v.length() < 0.5:
		v += (nearest.pos - h.pos).normalized() * 0.9
	var m := 3.0
	if h.pos.x < m: v.x += m - h.pos.x
	if h.pos.y < m: v.y += m - h.pos.y
	if h.pos.x > b.map_size.x - m: v.x -= h.pos.x - (b.map_size.x - m)
	if h.pos.y > b.map_size.y - m: v.y -= h.pos.y - (b.map_size.y - m)
	var s := Vector2.ZERO
	if v.length() > 0.05:
		s = Iso.to_screen(v.normalized()).normalized()
	_set_key(KEY_A, s.x < -0.38)
	_set_key(KEY_D, s.x > 0.38)
	_set_key(KEY_W, s.y < -0.38)
	_set_key(KEY_S, s.y > 0.38)

func _set_key(code: int, down: bool) -> void:
	if bool(_keys.get(code, false)) == down:
		return
	_keys[code] = down
	var ev := InputEventKey.new()
	ev.physical_keycode = code
	ev.keycode = code
	ev.pressed = down
	Input.parse_input_event(ev)

func _release() -> void:
	for code in [KEY_A, KEY_D, KEY_W, KEY_S]:
		_set_key(code, false)

func _shot(label: String) -> void:
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("%s%s.png" % [_dir, label])
