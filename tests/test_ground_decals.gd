extends RefCounted

const GroundDecals := preload("res://ui/ground_decals.gd")

func run() -> Array:
	var out: Array = []
	var stages: Dictionary = Data.table("stages")
	var preview := GroundDecals.new()
	for stage_id in stages:
		var stable := GroundDecals.placements(stage_id, 701)
		if stable != GroundDecals.placements(stage_id, 701):
			out.append("%s: posições dos decais não são determinísticas" % stage_id)
		var expected_count := 0 if stage_id in GroundDecals.PREVIEW_DISABLED_STAGES else 2
		if stable.size() != expected_count:
			out.append("%s: esperado remendo e trilha" % stage_id)
		var kinds := []
		for placement in stable:
			kinds.append(String(placement.get("kind", "")))
			var path := String(placement.get("path", ""))
			if not path.begins_with("res://assets/decals/"):
				out.append("%s: decal validado não foi admitido em assets: %s" % [stage_id, path])
			elif not FileAccess.file_exists(path):
				out.append("%s: candidata de decal ausente: %s" % [stage_id, path])
			elif preview._texture(path) == null:
				out.append("%s: candidata de decal não pôde ser carregada: %s" % [stage_id, path])
			elif not _has_transparent_outer_band(path):
				out.append("%s: fundo cromático ainda visível: %s" % [stage_id, path])
			elif not GroundDecals._is_dry_footprint(stage_id, Iso.to_ground(Vector2(placement.position))):
				out.append("%s: decal foi posicionado sobre água ou área bloqueada" % stage_id)
		if expected_count == 2 and (not kinds.has("remendo") or not kinds.has("trilha")):
			out.append("%s: faltou remendo ou trilha" % stage_id)
	if GroundDecals.placements("docas", 701).size() != 0:
		out.append("Docas não deve pré-visualizar decais até receber âncora seca")
	for path in ["res://assets/decals/docas_remendo_01.png", "res://assets/decals/docas_trilha_01.png"]:
		if not FileAccess.file_exists(path):
			out.append("official Docas decal missing: %s" % path)
		elif not _has_transparent_outer_band(path):
			out.append("Docas decal has chroma background: %s" % path)
	if preview.has_method("get_collision_layer"):
		out.append("camada de decais não pode criar colisão")
	if preview.z_index != 0:
		out.append("z-index só deve ser aplicado quando a prévia entra na árvore")
	preview.free()
	if not (GroundDecals.DECAL_Z_INDEX > GroundDecals.GROUND_Z_INDEX and GroundDecals.DECAL_Z_INDEX < 0):
		out.append("z-index dos decais precisa ficar acima do chão e abaixo dos atores")
	return out

func _has_transparent_outer_band(path: String) -> bool:
	var image := Image.load_from_file(ProjectSettings.globalize_path(path))
	if image == null or image.is_empty():
		return false
	var width := image.get_width()
	var height := image.get_height()
	var samples := [
		Vector2i(width / 20, height / 20), Vector2i(width / 2, height / 20), Vector2i(width * 19 / 20, height / 20),
		Vector2i(width / 20, height * 19 / 20), Vector2i(width / 2, height * 19 / 20), Vector2i(width * 19 / 20, height * 19 / 20)
	]
	for point in samples:
		if image.get_pixelv(point).a > 0.03:
			return false
	return true
