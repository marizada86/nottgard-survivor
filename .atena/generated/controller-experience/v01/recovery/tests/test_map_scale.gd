extends RefCounted
## MEC-012: mapas estendidos para 60x60. O layout de terreno foi desenhado para 40x40 e é consultado
## com TerrainLayout.scale (= lado / 40); as cenas de fase têm map_size 60x60, o herói no centro e os props
## distribuídos (nenhum fora da margem, nenhuma célula de 12x12 vazia).

const STAGES := ["dagruve", "docas", "shedaklah", "molor", "durao", "feng_tu", "shendilavri", "goranthis", "pilares"]

func run() -> Array:
	var out: Array = []
	var old_scale := TerrainLayout.scale

	# o desenho escalado em 1,5 é o original visto de 1,5x mais longe
	for sid in STAGES:
		for pt in [Vector2(6, 9), Vector2(20, 20), Vector2(31, 12), Vector2(3, 35), Vector2(37, 22)]:
			TerrainLayout.scale = 1.0
			var original := TerrainLayout.material_at(sid, pt)
			TerrainLayout.scale = 1.5
			var scaled := TerrainLayout.material_at(sid, pt * 1.5)
			if original != scaled:
				out.append("%s: material em %s deveria acompanhar o mapa escalado (%s x %s)" % [sid, str(pt), str(original), str(scaled)])

	# montanhas de Durao e água do Estige acompanham a escala
	TerrainLayout.scale = 1.5
	for m in TerrainLayout.mountain_anchors("durao"):
		if not TerrainLayout.is_blocked("durao", Vector2(m.x, m.y)):
			out.append("centro da montanha escalada deveria bloquear: %s" % str(m))
	if TerrainLayout.mountain_anchors("durao").is_empty() or absf(TerrainLayout.mountain_anchors("durao")[0].z - 2.2 * 1.5) > 0.001:
		out.append("raio da montanha deveria escalar junto com o mapa")
	var sample := TerrainLayout.styx_sample("durao")
	if not TerrainLayout.is_styx_water("durao", sample):
		out.append("styx_sample escalado deveria cair na água do Estige em Durao")
	if TerrainLayout.distance_to_styx("durao", sample) != 0.0:
		out.append("distância ao Estige dentro da água deveria ser 0")
	TerrainLayout.scale = old_scale

	# cenas: 60x60 e herói no centro (screen (0, 960) = chão (30, 30))
	for sid in STAGES:
		var text := FileAccess.get_file_as_string("res://ui/stages/%s.tscn" % sid)
		if text.find("map_size = Vector2i(60, 60)") < 0:
			out.append("%s: cena deveria ter map_size 60x60" % sid)
		var hero_at := text.find("[node name=\"Hero\"")
		if hero_at < 0 or text.find("position = Vector2(0, 960)", hero_at) < 0 or text.find("position = Vector2(0, 960)", hero_at) - hero_at > 200:
			out.append("%s: herói deveria começar no centro do mapa 60x60" % sid)

	# distribuição dos props: nenhum fora da margem e nenhuma célula de 12x12 vazia
	var re_header := RegEx.create_from_string("^\\[node name=\"([^\"]+)\"[^\n]*parent=\"Sorted\"[^\n]*instance=")
	var re_pos := RegEx.create_from_string("^position = Vector2\\((-?[0-9.]+), (-?[0-9.]+)\\)")
	for sid in STAGES:
		var counts := {}
		var outside := 0
		var in_prop := false
		var lines := FileAccess.get_file_as_string("res://ui/stages/%s.tscn" % sid).replace("\r\n", "\n").split("\n")
		for line in lines:
			var hm := re_header.search(line)
			if hm != null:
				in_prop = hm.get_string(1) != "Hero"
				continue
			if line.begins_with("[node"):
				in_prop = false
				continue
			if in_prop:
				var pm := re_pos.search(line)
				if pm != null:
					var g := Iso.to_ground(Vector2(float(pm.get_string(1)), float(pm.get_string(2))))
					if g.x < 2.0 or g.y < 2.0 or g.x > 58.0 or g.y > 58.0:
						outside += 1
					var key := Vector2i(clampi(int(g.x / 12.0), 0, 4), clampi(int(g.y / 12.0), 0, 4))
					counts[key] = int(counts.get(key, 0)) + 1
					in_prop = false
		if outside > 0:
			out.append("%s: %d prop(s) fora da margem do mapa" % [sid, outside])
		var empty := 0
		for cx in 5:
			for cy in 5:
				if int(counts.get(Vector2i(cx, cy), 0)) == 0:
					empty += 1
		if empty > 0:
			out.append("%s: %d célula(s) 12x12 sem nenhum prop" % [sid, empty])
	return out
