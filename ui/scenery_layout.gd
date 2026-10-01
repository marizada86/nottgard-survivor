class_name SceneryLayout
extends RefCounted
## MEC-035: layout de props por zonas (data/scenery.json -> "props"). Substitui os props soltos da cena
## da fase por aglomerados com sentido (praça, rua, armazém). Não usa a RNG da batalha.

const Prop := preload("res://ui/prop.gd")
const START_CLEARANCE := 5.0
const MARGIN := 2.0

## Cria os props da fase e remove os antigos da cena. Devolve quantos criou (0 = fase sem dados; nada é removido).
static func apply(sorted: Node2D, stage_key: String, start_ground: Vector2, map_size: Vector2) -> int:
	var spec: Dictionary = Data.table("scenery").get(stage_key, {})
	var entries := expanded_props(stage_key, start_ground, map_size)
	if spec.get("props", []).is_empty():
		return 0
	for child in sorted.get_children():
		if child is Prop:
			sorted.remove_child(child)
			child.queue_free()
	var kinds: Dictionary = Data.table("scenery").get("_kinds", {})
	for index in entries.size():
		var entry: Dictionary = entries[index]
		var dims: Dictionary = kinds.get(String(entry.kind), {})
		var prop := Prop.new()
		prop.name = "Cenario_%s_%d" % [String(entry.zone), index]
		prop.kind = String(entry.kind)
		prop.height = float(entry.get("height", dims.get("height", 50.0)))
		prop.half_width = float(entry.get("half_width", dims.get("half_width", 30.0)))
		prop.block_radius = float(entry.get("block_radius", dims.get("block_radius", 0.4)))
		prop.position = Iso.to_screen(entry.pos)
		sorted.add_child(prop)
	return entries.size()

## Lista final de props: aglomerados expandidos, dentro do mapa e fora da área de início.
static func expanded_props(stage_key: String, start_ground: Vector2, map_size: Vector2) -> Array:
	var out: Array = []
	var spec: Dictionary = Data.table("scenery").get(stage_key, {})
	for cluster in spec.get("props", []):
		var center := Vector2(float(cluster.center[0]), float(cluster.center[1]))
		for item in cluster.items:
			var offset: Array = item.get("off", [0, 0])
			var at := center + Vector2(float(offset[0]), float(offset[1]))
			if at.x < MARGIN or at.y < MARGIN or at.x > map_size.x - MARGIN or at.y > map_size.y - MARGIN:
				continue
			if at.distance_to(start_ground) < START_CLEARANCE:
				continue
			var entry: Dictionary = item.duplicate(true)
			entry.zone = String(cluster.zone)
			entry.pos = at
			out.append(entry)
	return out
