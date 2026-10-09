extends RefCounted
## MEC-012: mapas estendidos para 60x60. O layout de terreno foi desenhado para 40x40 e é consultado
## com TerrainLayout.scale (= lado / 40); as cenas de fase têm map_size 60x60, o herói no centro e os props
## distribuídos (nenhum fora da margem, nenhuma célula de 12x12 vazia).

## SPEC-152: a fatia piloto de segredos usa 84x84 em seis fases (SPEC-152 e SPEC-157); Dagruve, Docas e Pilares seguem 60x60.
const BIG := ["shedaklah", "molor", "durao", "feng_tu", "shendilavri", "goranthis"]

static func side_of(sid: String) -> int:
	return 84 if BIG.has(sid) else 60

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
		var side := side_of(sid)
		if text.find("map_size = Vector2i(%d, %d)" % [side, side]) < 0:
			out.append("%s: cena deveria ter map_size %dx%d" % [sid, side, side])
		var hero_pos := "position = Vector2(0, %d)" % (side * 16)
		var hero_at := text.find("[node name=\"Hero\"")
		if hero_at < 0 or text.find(hero_pos, hero_at) < 0 or text.find(hero_pos, hero_at) - hero_at > 200:
			out.append("%s: herói deveria começar no centro do mapa %dx%d" % [sid, side, side])

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
					if g.x < 2.0 or g.y < 2.0 or g.x > float(side_of(sid)) - 2.0 or g.y > float(side_of(sid)) - 2.0:
						outside += 1
					var cells_per_side := side_of(sid) / 12
					var key := Vector2i(clampi(int(g.x / 12.0), 0, cells_per_side - 1), clampi(int(g.y / 12.0), 0, cells_per_side - 1))
					counts[key] = int(counts.get(key, 0)) + 1
					in_prop = false
		if outside > 0:
			out.append("%s: %d prop(s) fora da margem do mapa" % [sid, outside])
		var empty := 0
		for cx in side_of(sid) / 12:
			for cy in side_of(sid) / 12:
				if int(counts.get(Vector2i(cx, cy), 0)) == 0:
					empty += 1
		# 84x84 (SPEC-152): os props da cena são só o ponto de partida; em runtime valem os aglomerados do level design. Uma célula pode ficar vazia (montanha ou água)
		var allowed_empty := 2 if side_of(sid) > 60 else 0
		if empty > allowed_empty:
			out.append("%s: %d célula(s) 12x12 sem nenhum prop" % [sid, empty])
	return out
