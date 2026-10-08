extends SceneTree
## MEC-012: amplia as cenas de fase de 40x40 para 60x60 (fator 1,5). SPEC-152: aceita `de`, `para` e a lista de fases
## (ex.: `-- 60 84 shedaklah molor durao`, fator 1,4); sem argumentos mantém 40 -> 60 em todas as fases.
##  - multiplica a posição de todos os nós em Sorted (herói e props) e SpawnPoints pelo fator (a projeção é linear);
##  - define map_size = 60x60 no nó Ground;
##  - acrescenta cópias determinísticas de props (1,25 por prop original) para manter a densidade por tile,
##    evitando montanhas, água do Estige, o ponto inicial e outros props.
## É idempotente: cena cujo map_size já é o novo é ignorada; a que não está no tamanho `de` também.
## Uso: godot --headless --path . -s tools/enlarge_stage_maps.gd [-- <de> <para> <fase>...]

var FACTOR := 1.5        # posição nova = antiga x (para / de)
var NEW_SIZE := 60
var FROM_SIZE := 40
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
	var args := OS.get_cmdline_user_args()
	var only: Array = []
	if args.size() >= 3:
		FROM_SIZE = int(args[0])
		NEW_SIZE = int(args[1])
		only = Array(args).slice(2)
	FACTOR = float(NEW_SIZE) / float(FROM_SIZE)
	TerrainLayout.scale = float(NEW_SIZE) / 40.0  # o layout de terreno foi desenhado para 40x40
	for sid in Data.table("stages").keys():
		if only.is_empty() or only.has(String(sid)):
			_convert(String(sid))
	quit()

func _convert(sid: String) -> void:
	var path := "res://ui/stages/%s.tscn" % sid
	if not FileAccess.file_exists(path):
		return
	var text := FileAccess.get_file_as_string(path).replace("\r\n", "\n")
	var lines := text.split("\n")
	var out: PackedStringArray = []
	var re_header := RegEx.create_from_string("^\\[node name=\"([^\"]+)\"( type=\"[^\"]+\")?( parent=\"([^\"]+)\")?")
	var re_pos := RegEx.create_from_string("^position = Vector2\\((-?[0-9.]+), (-?[0-9.]+)\\)")
	var cur_name := ""
	var cur_parent := ""
	var in_ground := false
	var props: Array = []   # {name, header, body (Array), pos (Vector2 já escalada)}
	var cur_prop: Dictionary = {}
	for line in lines:
		var m := re_header.search(line)
		if m != null:
			cur_name = m.get_string(1)
			cur_parent = m.get_string(4)
			in_ground = cur_name == "Ground"
			cur_prop = {}
			if cur_parent == "Sorted" and cur_name != "Hero" and line.contains("instance="):
				cur_prop = {"name": cur_name, "header": line, "body": [], "pos": Vector2.ZERO}
				props.append(cur_prop)
			out.append(line)
			continue
		if in_ground and line.begins_with("map_size"):
			var current := RegEx.create_from_string("Vector2i\\((\\d+)").search(line)
			var side := int(current.get_string(1)) if current != null else 0
			if side != FROM_SIZE:
				print("%s: mapa %d, esperado %d (ou já convertida); ignorada" % [sid, side, FROM_SIZE])
				return
			out.append("map_size = Vector2i(%d, %d)" % [NEW_SIZE, NEW_SIZE])
			continue
		var pm := re_pos.search(line)
		if pm != null and (cur_parent == "Sorted" or cur_parent == "SpawnPoints"):
			var p := Vector2(float(pm.get_string(1)), float(pm.get_string(2))) * FACTOR
			var new_line := "position = Vector2(%s, %s)" % [_fmt(p.x), _fmt(p.y)]
			out.append(new_line)
			if not cur_prop.is_empty():
				cur_prop.pos = p
				cur_prop.body.append(new_line)
			continue
		out.append(line)
		if not cur_prop.is_empty() and line != "":
			cur_prop.body.append(line)
		if in_ground and line.begins_with("script = ") and FROM_SIZE == 40:
			out.append("map_size = Vector2i(%d, %d)" % [NEW_SIZE, NEW_SIZE])
	# cópias de props
	var placed: Array = []
	var used_names := {}
	for pr in props:
		placed.append(Iso.to_ground(pr.pos))
		used_names[String(pr.name)] = true
	var hero_start := Vector2(NEW_SIZE, NEW_SIZE) * 0.5
	var mountains := TerrainLayout.mountain_anchors(sid)
	var copies := 0
	var extra: PackedStringArray = []
	for i in props.size():
		var pr: Dictionary = props[i]
		var n_copies := 1 + (1 if i % 4 == 0 else 0)
		var base := Iso.to_ground(pr.pos)
		for k in n_copies:
			var h := hash("%s/%s/%d" % [sid, pr.name, k])
			for attempt in 40:
				var ang := _frac(h, attempt * 2) * TAU
				var rad := 6.0 + _frac(h, attempt * 2 + 1) * 8.0
				var g: Vector2 = base + Vector2.from_angle(ang) * rad
				if g.x < 2.0 or g.y < 2.0 or g.x > NEW_SIZE - 2.0 or g.y > NEW_SIZE - 2.0:
					continue
				if g.distance_to(hero_start) < 5.0:
					continue
				if TerrainLayout.is_styx_water(sid, g) or TerrainLayout.distance_to_styx(sid, g) < 0.8:
					continue
				var bad := false
				for mt in mountains:
					if g.distance_to(Vector2(mt.x, mt.y)) < mt.z + 1.8:
						bad = true
				for q in placed:
					if g.distance_to(q) < MIN_GAP:
						bad = true
						break
				if bad:
					continue
				placed.append(g)
				var s := Iso.to_screen(g)
				var header := String(pr.header)
				var hm := RegEx.create_from_string(" unique_id=[0-9]+").sub(header, "", true)
				var copy_name := "%s_c%d" % [pr.name, k + 1]
				var bump := 2
				while used_names.has(copy_name):  # SPEC-152: reconversão não pode repetir nome de cópia anterior
					copy_name = "%s_c%d_%d" % [pr.name, k + 1, bump]
					bump += 1
				used_names[copy_name] = true
				hm = hm.replace("name=\"%s\"" % pr.name, "name=\"%s\"" % copy_name)
				extra.append("")
				extra.append(hm)
				for bl in pr.body:
					if String(bl).begins_with("position = "):
						extra.append("position = Vector2(%s, %s)" % [_fmt(s.x), _fmt(s.y)])
					else:
						extra.append(bl)
				copies += 1
				break
	var result := "\n".join(out).rstrip("\n") + "\n" + "\n".join(extra) + "\n"
	var f := FileAccess.open(path, FileAccess.WRITE)
	f.store_string(result)
	f.close()
	print("%s: %d props originais, +%d cópias, mapa %dx%d" % [sid, props.size(), copies, NEW_SIZE, NEW_SIZE])
