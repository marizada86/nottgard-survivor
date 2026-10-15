extends SceneTree
## Sonda do relato T05 (EVID-250 IN-079): inimigos que andam (speed > 0) e ficam parados a mais de 4 tiles do herói.
## Herói parado e imortal no centro; mede por fase quantos inimigos ficam presos por pelo menos 6 s.
##   godot --headless --path . -s tools/probe_stuck_enemies.gd -- <seed> <segundos> <lado>
func _init() -> void:
	var a := OS.get_cmdline_user_args()
	var seed_v := int(a[0]) if a.size() > 0 else 1
	var seconds := float(a[1]) if a.size() > 1 else 150.0
	var side := float(a[2]) if a.size() > 2 else 60.0
	TerrainLayout.scale = side / 40.0
	for stage_id in Data.table("stages"):
		var b := Battle.new(seed_v, "durvall", stage_id, {})
		b.map_size = Vector2(side, side)
		b.hero.map_size = b.map_size
		b.hero.pos = b.map_size * 0.5
		b.hero.max_hp = 1.0e9
		b.hero.hp = 1.0e9
		var track := {}   # instance_id -> {"pos", "since", "stuck_s", "id"}
		var stuck_ids := {}
		var spawned := {}
		var t := 0.0
		var next_sample := 0.0
		while t < seconds and b.state != "dead":
			if b.state == "levelup" or b.state == "altar" or b.state == "item_offer":
				b.choose(0)
				continue
			b.step(Vector2.ZERO, 0.05)
			b.hero.hp = 1.0e9
			b.events.clear()
			t += 0.05
			if t >= next_sample:
				next_sample += 0.5
				for e in b.enemies:
					if e.dead or e.speed <= 0.0 or e.is_boss():
						continue
					var key: int = e.get_instance_id()
					spawned[key] = e.id
					var d: float = e.pos.distance_to(b.hero.pos)
					if not track.has(key):
						track[key] = {"pos": e.pos, "since": t, "id": e.id}
						continue
					var tr: Dictionary = track[key]
					if e.pos.distance_to(tr.pos) > 0.15 or d <= 4.0:
						tr.pos = e.pos
						tr.since = t
					elif t - float(tr.since) >= 6.0 and not stuck_ids.has(key):
						stuck_ids[key] = {"id": e.id, "pos": e.pos, "t": t, "dist": d}
		var by_type := {}
		for k in stuck_ids:
			by_type[stuck_ids[k].id] = int(by_type.get(stuck_ids[k].id, 0)) + 1
		print("%-12s inimigos móveis vistos %4d | presos ≥6 s a >4 tiles: %3d | %s" % [stage_id, spawned.size(), stuck_ids.size(), JSON.stringify(by_type)])
	quit()
