extends RefCounted
## PLAN-098 (SPEC-171): a grade de alcance por componentes é byte a byte a da busca em largura anterior.

## A busca em largura anterior, copiada: monta a grade de bloqueios e inunda a partir da célula do herói.
static func _reference(b: Battle) -> PackedByteArray:
	var d := b._reach_dims()
	var cell: float = Battle.REACH_CELL
	var start := Vector2i(clampi(int(b.hero.pos.x / cell), 0, d.x - 1), clampi(int(b.hero.pos.y / cell), 0, d.y - 1))
	var grid := PackedByteArray()
	grid.resize(d.x * d.y)
	var r := Hero.RADIUS
	for cy in d.y:
		for cx in d.x:
			var p := (Vector2(cx, cy) + Vector2(0.5, 0.5)) * cell
			if p.x < r or p.y < r or p.x > b.map_size.x - r or p.y > b.map_size.y - r or TerrainLayout.is_blocked(b.hero.terrain_id, p):
				grid[cy * d.x + cx] = 2
	for blk in b.hero.blockers:
		var reach_r: float = blk.z + r
		var x0 := maxi(0, int((blk.x - reach_r) / cell) - 1)
		var x1 := mini(d.x - 1, int((blk.x + reach_r) / cell) + 1)
		var y0 := maxi(0, int((blk.y - reach_r) / cell) - 1)
		var y1 := mini(d.y - 1, int((blk.y + reach_r) / cell) + 1)
		for cy in range(y0, y1 + 1):
			for cx in range(x0, x1 + 1):
				if (Vector2(cx, cy) + Vector2(0.5, 0.5)).distance_to(Vector2(blk.x, blk.y) / cell) * cell < reach_r:
					grid[cy * d.x + cx] = 2
	var queue: Array[Vector2i] = [start]
	grid[start.y * d.x + start.x] = 1
	var head := 0
	while head < queue.size():
		var c: Vector2i = queue[head]
		head += 1
		for dx in [-1, 0, 1]:
			for dy in [-1, 0, 1]:
				var n := Vector2i(c.x + dx, c.y + dy)
				if n.x < 0 or n.y < 0 or n.x >= d.x or n.y >= d.y or grid[n.y * d.x + n.x] != 0:
					continue
				grid[n.y * d.x + n.x] = 1
				queue.append(n)
	return grid

func run() -> Array:
	var out: Array = []
	var rng := RandomNumberGenerator.new()
	rng.seed = 20261010
	# durao tem montanhas no terreno; dagruve nao. Mapa de 40 e de 84, com cercas que fecham bolsoes de proposito.
	for stage_id in ["dagruve", "durao"]:
		for side in [40.0, 84.0]:
			var b := Battle.new(3, "durvall", stage_id, {})
			b.map_size = Vector2(side, side)
			b.hero.map_size = b.map_size
			TerrainLayout.scale = side / 40.0
			b.hero.terrain_id = stage_id
			for i in int(side * 2.0):
				b.hero.blockers.append(Vector3(rng.randf() * side, rng.randf() * side, rng.randf_range(0.3, 2.2)))
			# anel fechado de bloqueios ao redor de um ponto: o interior fica inalcancavel de fora
			var ring_center := Vector2(side * 0.3, side * 0.7)
			for k in 24:
				var a := TAU * float(k) / 24.0
				b.hero.blockers.append(Vector3(ring_center.x + cos(a) * 4.0, ring_center.y + sin(a) * 4.0, 1.1))
			var diff := 0
			var checked := 0
			var starts: Array = [ring_center, Vector2(side * 0.5, side * 0.5), Vector2(1.0, 1.0), Vector2(side - 0.2, side - 0.2)]
			for i in 6:
				starts.append(Vector2(rng.randf() * side, rng.randf() * side))
			for s in starts:
				b.hero.pos = s
				var got := b._reach_grid()
				var want := _reference(b)
				checked += 1
				if got != want:
					diff += 1
			if diff > 0:
				out.append("%s %d: %d de %d grades diferem da busca anterior" % [stage_id, int(side), diff, checked])
			# a mesma posicao pede de novo: vem do cache e continua igual
			b.hero.pos = Vector2(side * 0.5, side * 0.5)
			if b._reach_grid() != _reference(b):
				out.append("%s %d: grade em cache diferente da busca" % [stage_id, int(side)])
			# bloqueio novo muda o resultado (a chave inclui os bloqueios)
			b.hero.blockers.append(Vector3(side * 0.5 + 2.0, side * 0.5, 1.5))
			if b._reach_grid() != _reference(b):
				out.append("%s %d: bloqueio novo nao refletiu na grade" % [stage_id, int(side)])
	TerrainLayout.scale = 1.0
	return out
