extends RefCounted
## PLAN-098 (SPEC-171): o índice espacial dos bloqueios de Hero.can_stand decide igual à varredura completa.

## A regra antiga, copiada: percorre todos os bloqueios.
static func _reference(h: Hero, p: Vector2, r: float) -> bool:
	if p.x < r or p.y < r or p.x > h.map_size.x - r or p.y > h.map_size.y - r:
		return false
	if Hero.TerrainLayout.is_blocked(h.terrain_id, p):
		return false
	for b in h.blockers:
		if p.distance_to(Vector2(b.x, b.y)) < b.z + r:
			return false
	return true

func run() -> Array:
	var out: Array = []
	var rng := RandomNumberGenerator.new()
	rng.seed = 20261010
	for map_side in [40.0, 84.0]:
		var h := Hero.new()
		h.map_size = Vector2(map_side, map_side)
		var count := 0
		for i in 200:
			h.blockers.append(Vector3(rng.randf() * map_side, rng.randf() * map_side, rng.randf_range(0.25, 3.0)))
		# pontos aleatorios, raios de herói e de inimigo
		var wrong := 0
		for i in 6000:
			var p := Vector2(rng.randf() * map_side, rng.randf() * map_side)
			var r := rng.randf_range(0.2, 1.1)
			count += 1
			if h.can_stand(p, r) != _reference(h, p, r):
				wrong += 1
		# na borda exata de cada bloqueio (o caso em que um arredondamento mudaria a resposta)
		for b in h.blockers:
			for k in 3:
				var ang := rng.randf() * TAU
				var r: float = rng.randf_range(0.2, 1.1)
				for eps in [-0.0005, 0.0, 0.0005]:
					var p: Vector2 = Vector2(b.x, b.y) + Vector2(cos(ang), sin(ang)) * (float(b.z) + r + float(eps))
					count += 1
					if h.can_stand(p, r) != _reference(h, p, r):
						wrong += 1
		if wrong > 0:
			out.append("mapa %d: %d de %d consultas diferem da varredura completa" % [int(map_side), wrong, count])
		# o array muda por dentro (anexar, trocar elemento, limpar): o índice acompanha sem aviso
		h.blockers.append(Vector3(10.0, 10.0, 2.5))
		if h.can_stand(Vector2(10.0, 10.0), 0.3):
			out.append("bloqueio anexado deveria barrar o ponto central")
		h.blockers[h.blockers.size() - 1] = Vector3(20.0, 20.0, 1.0)
		if not h.can_stand(Vector2(10.0, 10.0), 0.3) == _reference(h, Vector2(10.0, 10.0), 0.3):
			out.append("bloqueio trocado: o índice ficou velho")
		if h.can_stand(Vector2(20.0, 20.0), 0.3):
			out.append("bloqueio trocado deveria barrar o novo ponto")
		h.blockers.clear()
		if not h.can_stand(Vector2(20.0, 20.0), 0.3):
			out.append("sem bloqueios o ponto deveria estar livre")
		h.blockers = [Vector3(5.0, 5.0, 1.0)]
		if h.can_stand(Vector2(5.0, 5.0), 0.3):
			out.append("array novo atribuído deveria valer")
	return out
