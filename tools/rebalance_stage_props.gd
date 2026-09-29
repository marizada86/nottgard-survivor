extends SceneTree
## MEC-012 (ajuste): redistribui os props dos mapas 60x60.
##  1. props fora da margem (2,5 tiles da borda; ex.: docas e margens de Dagruve que ficavam "fora do cenário")
##     são realocados para a região menos povoada;
##  2. a área é dividida em 5x5 células de 12 tiles; toda célula com menos props que o alvo
##     (densidade original de props por tile) recebe cópias de props da própria fase, em posições válidas.
## Idempotente: depois de aplicado, nada mais é movido nem acrescentado.
## Uso: godot --headless --path . -s tools/rebalance_stage_props.gd

const SIZE := 60.0
const MARGIN := 2.5
const CELL := 12.0
const CELLS := 5
const MIN_GAP := 2.3

func _fmt(v: float) -> String:
	var r := roundf(v)
	return str(int(r)) if absf(v - r) < 0.05 else "%.1f" % v

func _frac(h: int, salt: int) -> float:
	# mistura inteira (hash de strings vizinhas dá valores quase iguais)
	var x: int = (absi(h) + salt * 7919 + 104729) & 0x7fffffff
	x = ((x >> 13) ^ x) & 0x7fffffff
	x = (x * 1274126177) & 0x7fffffff
	x = ((x >> 16) ^ x) & 0x7fffffff
	x = (x * 2246822519) & 0x7fffffff
	return float(x % 10000) / 10000.0

func _init() -> void:
	TerrainLayout.scale = SIZE / 40.0
	for sid in Data.table("stages").keys():
		_rebalance(String(sid))
	quit()

func _cell_of(g: Vector2) -> int:
	var cx := clampi(int(floor(g.x / CELL)), 0, CELLS - 1)
	var cy := clampi(int(floor(g.y / CELL)), 0, CELLS - 1)
	return cy * CELLS + cx

func _valid(sid: String, g: Vector2, placed: Array, hero_start: Vector2, mountains: Array) -> bool:
	if g.x < MARGIN or g.y < MARGIN or g.x > SIZE - MARGIN or g.y > SIZE - MARGIN:
		return false
	if g.distance_to(hero_start) < 5.0:
		return false
	if TerrainLayout.is_styx_water(sid, g) or TerrainLayout.distance_to_styx(sid, g) < 0.8:
		return false
	for mt in mountains:
		if g.distance_to(Vector2(mt.x, mt.y)) < mt.z + 1.8:
			return false
	for q in placed:
		if g.distance_to(q) < MIN_GAP:
			return false
	return true

func _rebalance(sid: String) -> void:
	var path := "res://ui/stages/%s.tscn" % sid
	var lines := FileAccess.get_file_as_string(path).replace("\r\n", "\n").split("\n")
	var re_header := RegEx.create_from_string("^\\[node name=\"([^\"]+)\"( type=\"[^\"]+\")?( parent=\"([^\"]+)\")?")
	var re_pos := RegEx.create_from_string("^position = Vector2\\((-?[0-9.]+), (-?[0-9.]+)\\)")
	var props: Array = []      # {name, header, body, pos_idx, g}
	var cur: Dictionary = {}
	for i in lines.size():
		var m := re_header.search(lines[i])
		if m != null:
			cur = {}
			if m.get_string(4) == "Sorted" and m.get_string(1) != "Hero" and lines[i].contains("instance="):
				cur = {"name": m.get_string(1), "header": lines[i], "body": [], "pos_idx": -1, "g": Vector2.ZERO}
				props.append(cur)
			continue
		if cur.is_empty() or lines[i] == "":
			continue
		var pm := re_pos.search(lines[i])
		if pm != null and cur.pos_idx < 0:
			cur.pos_idx = i
			cur.g = Iso.to_ground(Vector2(float(pm.get_string(1)), float(pm.get_string(2))))
		cur.body.append(lines[i])
	var hero_start := Vector2(SIZE, SIZE) * 0.5
	var mountains := TerrainLayout.mountain_anchors(sid)
	var placed: Array = []
	var counts: Array = []
	counts.resize(CELLS * CELLS)
	counts.fill(0)
	var outsiders: Array = []
	for pr in props:
		var g: Vector2 = pr.g
		var inside: bool = g.x >= MARGIN and g.y >= MARGIN and g.x <= SIZE - MARGIN and g.y <= SIZE - MARGIN
		if inside:
			placed.append(g)
			counts[_cell_of(g)] += 1
		else:
			outsiders.append(pr)
	# 1) realoca props fora da margem para a célula menos povoada
	var moved := 0
	for pr in outsiders:
		var h := hash("%s/%s/move" % [sid, pr.name])
		var best := Vector2(-1, -1)
		var best_count := 1 << 30
		for attempt in 80:
			var g := Vector2(MARGIN + _frac(h, attempt * 2) * (SIZE - 2.0 * MARGIN), MARGIN + _frac(h, attempt * 2 + 1) * (SIZE - 2.0 * MARGIN))
			if not _valid(sid, g, placed, hero_start, mountains):
				continue
			var c := int(counts[_cell_of(g)])
			if c < best_count:
				best_count = c
				best = g
		if best.x < 0.0:
			best = Vector2(SIZE * 0.5 + 8.0, SIZE * 0.5 + 8.0)
		placed.append(best)
		counts[_cell_of(best)] += 1
		var s := Iso.to_screen(best)
		lines[pr.pos_idx] = "position = Vector2(%s, %s)" % [_fmt(s.x), _fmt(s.y)]
		pr.g = best
		moved += 1
	# 2) completa células abaixo do alvo
	var total := props.filter(func(p): return RegEx.create_from_string("_[cf][0-9]+$").search(String(p.name)) == null).size()
	# densidade das originais no mapa 40x40 (props por tile) aplicada a cada célula de 12x12
	var target := int(ceil(float(total) / 1600.0 * CELL * CELL))
	var extra: PackedStringArray = []
	var added := 0
	var sources: Array = props.filter(func(p): return not String(p.name).contains("Espelho"))
	for c in CELLS * CELLS:
		var need: int = target - int(counts[c])
		if need <= 0 or sources.is_empty():
			continue
		var cx := c % CELLS
		var cy := c / CELLS
		for k in need:
			var src: Dictionary = sources[absi(hash("%s/%d/%d/src" % [sid, c, k])) % sources.size()]
			var h := hash("%s/%d/%d/fill" % [sid, c, k])
			for attempt in 50:
				var g := Vector2(float(cx) * CELL + 1.0 + _frac(h, attempt * 2) * (CELL - 2.0), float(cy) * CELL + 1.0 + _frac(h, attempt * 2 + 1) * (CELL - 2.0))
				if not _valid(sid, g, placed, hero_start, mountains):
					continue
				placed.append(g)
				counts[c] += 1
				var s := Iso.to_screen(g)
				var header := RegEx.create_from_string(" unique_id=[0-9]+").sub(String(src.header), "", true)
				header = header.replace("name=\"%s\"" % src.name, "name=\"%s_f%d\"" % [src.name, added + 1])
				extra.append("")
				extra.append(header)
				for bl in src.body:
					if String(bl).begins_with("position = "):
						extra.append("position = Vector2(%s, %s)" % [_fmt(s.x), _fmt(s.y)])
					else:
						extra.append(bl)
				added += 1
				break
	if moved == 0 and added == 0:
		print("%s: já balanceada" % sid)
		return
	var result := "\n".join(lines).rstrip("\n") + "\n" + "\n".join(extra) + "\n"
	var f := FileAccess.open(path, FileAccess.WRITE)
	f.store_string(result)
	f.close()
	print("%s: %d props movidos para dentro, +%d preenchendo células vazias (alvo %d por célula)" % [sid, moved, added, target])
