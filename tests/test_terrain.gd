extends RefCounted

const Ground := preload("res://ui/ground.gd")
const TerrainLayout := preload("res://core/terrain_layout.gd")

func run() -> Array:
	var out: Array = []
	var stable := Ground.deterministic_variant("dagruve", 3, 7, 17, 4)
	if stable != Ground.deterministic_variant("dagruve", 3, 7, 17, 4):
		out.append("variante de terreno não é determinística")
	if stable < 0 or stable >= 4:
		out.append("variante de terreno fora dos limites")
	if Ground.deterministic_variant("docas", 8, 2, 31, 1) != 0:
		out.append("atlas de uma variação deveria usar sempre o índice zero")
	var current := TerrainLayout.styx_sample("durao")
	if not TerrainLayout.is_styx_current("durao", current):
		out.append("amostra do Estige deveria cair na corrente central")
	if not TerrainLayout.is_styx_water("durao", current):
		out.append("corrente central deveria ser atravessável como água")
	if TerrainLayout.is_styx_water("durao", Vector2(20, 20)):
		out.append("centro inicial de Durao não deveria nascer dentro do Estige")
	if not TerrainLayout.is_blocked("durao", Vector2(7, 9)):
		out.append("âncora de montanha deveria ter bloqueio lógico")
	if TerrainLayout.material_at("durao", current) != TerrainLayout.MATERIAL_CURRENT:
		out.append("corrente central deveria ter material próprio")
	if TerrainLayout.material_at("durao", TerrainLayout.styx_sample("durao", TerrainLayout.MATERIAL_BANK)) != TerrainLayout.MATERIAL_BANK:
		out.append("margem do Estige deveria ter material próprio")
	var shedaklah_left_branch := Vector2(TerrainLayout.shedaklah_styx_center_x(20.0, true), 20.0)
	var shedaklah_right_branch := Vector2(TerrainLayout.shedaklah_styx_center_x(20.0, false), 20.0)
	if not TerrainLayout.is_shedaklah_styx("shedaklah", shedaklah_left_branch) or not TerrainLayout.is_shedaklah_styx("shedaklah", shedaklah_right_branch):
		out.append("Shedaklah deveria ter dois braços do Estige nas bordas")
	if TerrainLayout.is_shedaklah_styx("shedaklah", Vector2(20.0, 20.0)):
		out.append("centro de Shedaklah deveria permanecer terreno fúngico")
	if TerrainLayout.is_styx_water("shedaklah", shedaklah_left_branch):
		out.append("Estige visual de Shedaklah não deveria ativar a regra hídrica de Durao")
	if TerrainLayout.material_at("molor", Vector2(7.0, 10.0)) != TerrainLayout.MATERIAL_MOLOR_OOZE:
		out.append("Molor deveria ter bolsão determinístico de ooze")
	if TerrainLayout.material_at("molor", Vector2(20.0, 20.0)) == TerrainLayout.MATERIAL_MOLOR_OOZE:
		out.append("centro de Molor não deveria ser inteiramente ooze")
	if TerrainLayout.is_styx_water("molor", Vector2(7.0, 10.0)):
		out.append("bolsão de ooze em Molor não deveria ativar regra do Estige")
	for asset_path in ["res://assets/tiles/dagruve_ground_atlas_v3.png", "res://assets/tiles/docas_ground_atlas_v3.png", "res://assets/tiles/shedaklah_ground_atlas_v1.png", "res://assets/tiles/molor_ground_atlas_v1.png"]:
		var atlas: Texture2D = load(asset_path)
		if atlas == null:
			out.append("atlas modular ausente: %s" % asset_path)
		elif atlas.get_size() != Vector2(128, 64):
			out.append("atlas modular deveria ter 128x64: %s" % asset_path)
		else:
			var ground := Ground.new()
			ground.use_modular_atlas = true
			ground.atlas_columns = 2
			ground.atlas_variants = 4
			if ground._available_atlas_variants(atlas) != 4:
				out.append("atlas modular não expõe quatro variações: %s" % asset_path)
			ground.free()
	for scene_path in ["res://ui/stages/dagruve.tscn", "res://ui/stages/docas.tscn", "res://ui/stages/shedaklah.tscn", "res://ui/stages/molor.tscn"]:
		var stage: Node = load(scene_path).instantiate()
		var stage_ground: Node = stage.get_node("Ground")
		if not stage_ground.use_modular_atlas or stage_ground.terrain_texture_path.is_empty():
			out.append("fase sem atlas modular configurado: %s" % scene_path)
		stage.free()
	var durao: Node = load("res://ui/stages/durao.tscn").instantiate()
	var durao_ground: Node = durao.get_node("Ground")
	if durao_ground.terrain_layout_id != "durao":
		out.append("Durao deveria usar o layout regional de macroterreno")
	if durao.get_node_or_null("Sorted/TerrainFeatures") == null:
		out.append("Durao deveria instanciar módulos y-sorted de penhasco")
	durao.free()
	var shedaklah: Node = load("res://ui/stages/shedaklah.tscn").instantiate()
	var shedaklah_ground: Node = shedaklah.get_node("Ground")
	if shedaklah_ground.terrain_layout_id != "shedaklah":
		out.append("Shedaklah deveria usar o macroterreno fúngico entre os braços do Estige")
	shedaklah.free()
	var molor: Node = load("res://ui/stages/molor.tscn").instantiate()
	var molor_ground: Node = molor.get_node("Ground")
	if molor_ground.terrain_layout_id != "molor":
		out.append("Molor deveria usar o macroterreno de caverna e ooze")
	molor.free()
	var pilot_scene := load("res://tools/terrain_pilot.tscn")
	if pilot_scene == null or not pilot_scene.can_instantiate():
		out.append("cena piloto de terreno não está disponível")
	else:
		var pilot: Node = pilot_scene.instantiate()
		if pilot == null:
			out.append("cena piloto de terreno não instancia")
		elif pilot.get_script() == null:
			out.append("cena piloto de terreno perdeu seu controlador")
		else:
			pilot.free()
	return out
