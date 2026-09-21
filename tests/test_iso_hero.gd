extends RefCounted

func run() -> Array:
	var out: Array = []
	for g in [Vector2(3, 7), Vector2(0, 0), Vector2(12.5, 1.25)]:
		if Iso.to_ground(Iso.to_screen(g)).distance_to(g) > 0.0001:
			out.append("ida e volta falhou em %s" % g)
	var h := Hero.new()
	h.map_size = Vector2(10, 10)
	h.pos = Vector2(5, 5)
	for i in 600:
		h.step(Vector2(-1, -1), 0.016)
	if h.pos.x < Hero.RADIUS - 0.001 or h.pos.y < Hero.RADIUS - 0.001 or h.pos.x > 10 or h.pos.y > 10:
		out.append("herói saiu do mapa: %s" % h.pos)
	var b := Hero.new()
	b.map_size = Vector2(10, 10)
	b.pos = Vector2(5, 5)
	b.blockers = [Vector3(6, 5, 0.4)]
	for i in 200:
		b.step(Vector2(1, 1), 0.016)
	for i in 200:
		b.step(Vector2(1, -1), 0.016)
	if b.pos.distance_to(Vector2(6, 5)) < 0.4 + Hero.RADIUS - 0.001:
		out.append("herói atravessou o prop")
	return out
