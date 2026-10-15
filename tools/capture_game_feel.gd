extends Node
## Auditoria de game feel (SPEC-177, B-003/M2): joga cada fase com um kite simples por teclas e fotografa a run.
## godot --path . res://tools/capture_game_feel.tscn --resolution 1280x720 [-- --dir=res://pasta/ --secs=40 --stage=dagruve]
## Mede: numeros de dano simultaneos, filhos de Fx, estado e quadros; nao altera o save (qa_sandbox).

var _dir := "res://.atena/generated/m2-game-feel/auditoria-v01/"
var _secs := 40.0
var _only := ""
var _keys := {}

func _ready() -> void:
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--dir="):
			_dir = argument.trim_prefix("--dir=")
		elif argument.begins_with("--secs="):
			_secs = float(argument.trim_prefix("--secs="))
		elif argument.begins_with("--stage="):
			_only = argument.trim_prefix("--stage=")
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_dir))
	Playtest.visible = false
	var heroes: Array = Data.table("heroes").keys()
	var index := 0
	var report: Array = []
	for sid in Data.table("stages"):
		if _only != "" and sid != _only:
			continue
		var hero_id: String = heroes[index % heroes.size()]
		index += 1
		report.append(await _play(sid, hero_id))
	var file := FileAccess.open("%sresumo.json" % _dir, FileAccess.WRITE)
	file.store_string(JSON.stringify(report, "\t"))
	file.close()
	print("game feel: ok ", report.size(), " fases")
	get_tree().quit()

func _play(sid: String, hero_id: String) -> Dictionary:
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 12345}
	Game.run_stage = sid
	Game.run_hero = hero_id
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	await get_tree().create_timer(0.4).timeout
	var b: Battle = run.battle
	var shots := 0
	var next_shot := 2.0
	var max_numbers := 0
	var max_fx := 0
	var max_labels := 0
	var peak_texts: Array = []
	var max_enemies := 0
	var levelups := 0
	var wall := Time.get_ticks_msec()
	while b.time < _secs and b.state != "dead" and b.state != "won" and Time.get_ticks_msec() - wall < 240000:
		if b.state in ["levelup", "altar", "item_offer", "shop"]:
			if b.state == "levelup":
				levelups += 1
			await _shot("%s_%s_%02d_%s" % [sid, hero_id, shots, b.state])
			shots += 1
			run._on_choose(0)
			await get_tree().process_frame
			continue
		if b.state == "revive_offer":
			break
		_drive(b)
		max_numbers = maxi(max_numbers, int(run.get("_numbers")))
		var label_count: int = run.get("_text_fx").get_child_count()
		if label_count > max_labels:
			max_labels = label_count
			peak_texts = []
			for lb in run.get("_text_fx").get_children():
				if lb is Label:
					peak_texts.append(lb.text)
		max_fx = maxi(max_fx, run.fx.get_child_count())
		max_enemies = maxi(max_enemies, b.enemies.size())
		if b.time >= next_shot:
			next_shot += 3.0
			await _shot("%s_%s_%02d" % [sid, hero_id, shots])
			shots += 1
		await get_tree().physics_frame
	_release()
	var result := {"stage": sid, "hero": hero_id, "time": snappedf(b.time, 0.1), "state": b.state, "level": b.hero.level, "shots": shots, "max_numbers": max_numbers, "max_labels": max_labels, "peak_texts": peak_texts, "numbers_end": int(run.get("_numbers")), "labels_end": run.get("_text_fx").get_child_count(), "max_fx_children": max_fx, "max_enemies": max_enemies, "levelups": levelups}
	print("game feel ", result)
	run.queue_free()
	await get_tree().process_frame
	return result

func _drive(b: Battle) -> void:
	var h := b.hero
	var v := Vector2.ZERO
	var near := 0
	var nearest: Variant = null
	var nearest_d := 14.0
	for e in b.enemies:
		var off: Vector2 = h.pos - e.pos
		var d := off.length()
		if d < 2.8:
			near += 1
		if d < nearest_d:
			nearest_d = d
			nearest = e
		if d < 3.2 and d > 0.01:
			v += off / d * (1.0 / maxf(0.4, d * d))
	if near < 3 and nearest != null and v.length() < 0.5:
		v += (nearest.pos - h.pos).normalized() * 0.9
	if v.length() < 0.4:
		for pk in b.pickups:
			var off2: Vector2 = pk.pos - h.pos
			if off2.length() < 9.0:
				v += off2.normalized() * 0.6
				break
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
