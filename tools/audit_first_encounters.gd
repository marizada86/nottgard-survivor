extends Node
## SPEC-179 R1 (B-004/M3): quando cada sistema aparece pela primeira vez numa run, e o que o jogo diz nesse momento.
## godot --headless --path . res://tools/audit_first_encounters.tscn [-- --stages=dagruve,docas --minutes=12 --hero=durvall]
## Joga a Battle sem janela com kite simples e vida sempre cheia (so mede quando as coisas acontecem).

var _stages: PackedStringArray = ["dagruve", "docas"]
var _minutes := 12.0
var _hero := "durvall"

func _ready() -> void:
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--stages="):
			_stages = argument.trim_prefix("--stages=").split(",")
		elif argument.begins_with("--minutes="):
			_minutes = float(argument.trim_prefix("--minutes="))
		elif argument.begins_with("--hero="):
			_hero = argument.trim_prefix("--hero=")
	var out := {}
	for sid in _stages:
		out[sid] = _play(sid)
	var path := "res://.atena/generated/m3-onboarding/primeiros-encontros.json"
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://.atena/generated/m3-onboarding/"))
	var file := FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(out, "\t"))
	file.close()
	for sid in out:
		print("== ", sid)
		for key in out[sid].first:
			print("  %6.1fs  %s" % [out[sid].first[key], key])
	get_tree().quit()

func _play(sid: String) -> Dictionary:
	var b := Battle.new(7, _hero, sid, {})
	var first := {}
	var toasts := {}
	var steps := 0
	var dt := 0.05
	while b.time < _minutes * 60.0 and steps < 400000:
		steps += 1
		b.hero.hp = b.hero.max_hp
		if b.state in ["levelup", "altar", "item_offer", "shop"]:
			_mark(first, "estado:%s" % b.state, b.time)
			b.choose(0)
			continue
		if b.state == "revive_offer" or b.state == "dead" or b.state == "won":
			_mark(first, "estado:%s" % b.state, b.time)
			break
		b.step(_move(b), dt)
		for ev in b.events:
			var key := "evento:%s" % String(ev.type)
			if ev.has("kind"):
				key += ":%s" % String(ev.kind)
			_mark(first, key, b.time)
			if String(ev.type) == "toast" and not toasts.has(String(ev.text)):
				toasts[String(ev.text)] = snappedf(b.time, 0.1)
		if b.boss != null:
			_mark(first, "chefe_presente", b.time)
		for it in b.interactions:
			_mark(first, "interacao:%s" % String(it.kind), float(it.get("born_at", b.time)))
		if not b.zones.is_empty():
			for z in b.zones:
				_mark(first, "zona:%s" % String(z.get("kind", "?")), b.time)
	return {"stage": sid, "hero": _hero, "final_time": snappedf(b.time, 0.1), "state": b.state, "level": b.hero.level, "first": first, "toasts": toasts}

func _mark(first: Dictionary, key: String, t: float) -> void:
	if not first.has(key):
		first[key] = snappedf(t, 0.1)

func _move(b: Battle) -> Vector2:
	var h := b.hero
	var v := Vector2.ZERO
	for e in b.enemies:
		var off: Vector2 = h.pos - e.pos
		var d := off.length()
		if d < 3.2 and d > 0.01:
			v += off / d * (1.0 / maxf(0.4, d * d))
	var m := 4.0
	if h.pos.x < m: v.x += m - h.pos.x
	if h.pos.y < m: v.y += m - h.pos.y
	if h.pos.x > b.map_size.x - m: v.x -= h.pos.x - (b.map_size.x - m)
	if h.pos.y > b.map_size.y - m: v.y -= h.pos.y - (b.map_size.y - m)
	if v.length() < 0.05:
		return Vector2.ZERO
	return Iso.to_screen(v.normalized()).normalized()
