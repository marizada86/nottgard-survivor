class_name SceneryLayout
extends RefCounted
## MEC-035: layout de props por zonas (data/scenery.json -> "props"). Substitui os props soltos da cena
## da fase por aglomerados com sentido (praça, rua, armazém). Não usa a RNG da batalha.

const Prop := preload("res://ui/prop.gd")
const START_CLEARANCE := 5.0
const MARGIN := 2.0

## Cria os props da fase e remove os antigos da cena. Devolve quantos criou (0 = fase sem dados; nada é removido).
static func apply(sorted: Node2D, stage_key: String, start_ground: Vector2, map_size: Vector2) -> int:
	var spec: Dictionary = stage_spec(stage_key)
	var entries := expanded_props(stage_key, start_ground, map_size)
	if spec.get("props", []).is_empty():
		return 0
	for child in sorted.get_children():
		if child is Prop:
			sorted.remove_child(child)
			child.queue_free()
	var kinds: Dictionary = Data.table("scenery").get("_kinds", {}).duplicate()
	kinds.merge(Data.table("level_design").get("_kinds", {}))
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

## Dados do layout da fase: scenery.json (Dagruve, Docas) ou, se ele não tiver props, level_design.json (PLAN-054 F1).
static func stage_spec(stage_key: String) -> Dictionary:
	var spec: Dictionary = Data.table("scenery").get(stage_key, {})
	if spec.get("props", []).is_empty():
		return Data.table("level_design").get(stage_key, {})
	return spec

## SPEC-152: o level design foi desenhado em 60x60. Mapas maiores multiplicam os centros dos aglomerados por lado/60
## (os desvios dentro do aglomerado ficam como estão) e ganham uma cópia deslocada de cada aglomerado, para manter a densidade por tile.
const DESIGN_SIDE := 60.0
const COPY_MIN := 4.0
const COPY_SPAN := 3.0

static func design_scale(map_size: Vector2) -> float:
	return maxf(1.0, map_size.x / DESIGN_SIDE)

## Fração determinística em [0, 1) a partir de um hash e um sal (sem RNG da batalha).
static func _frac(h: int, salt: int) -> float:
	var x: int = (absi(h) + salt * 7919 + 104729) & 0x7fffffff
	x = ((x >> 13) ^ x) & 0x7fffffff
	x = (x * 1274126177) & 0x7fffffff
	x = ((x >> 16) ^ x) & 0x7fffffff
	x = (x * 2246822519) & 0x7fffffff
	return float(x % 10000) / 10000.0

static func _bad_ground(stage_key: String, at: Vector2) -> bool:
	if TerrainLayout.is_styx_water(stage_key, at) or TerrainLayout.is_blocked(stage_key, at):
		return true
	var material := String(TerrainLayout.material_at(stage_key, at))
	return material.ends_with("bank") or material.ends_with("wall") or material.ends_with("foundation") or material == "slope"

## Lista final de props: aglomerados expandidos, dentro do mapa e fora da área de início.
static func expanded_props(stage_key: String, start_ground: Vector2, map_size: Vector2) -> Array:
	var out: Array = []
	var spec: Dictionary = stage_spec(stage_key)
	var f := design_scale(map_size)
	var clusters: Array = []
	for index in spec.get("props", []).size():
		var cluster: Dictionary = spec.props[index]
		var center := Vector2(float(cluster.center[0]), float(cluster.center[1])) * f
		clusters.append({"cluster": cluster, "center": center, "zone": String(cluster.zone)})
		if f > 1.001:
			var h := hash("%s/%s/%d" % [stage_key, cluster.zone, index])
			var angle := _frac(h, 1) * TAU
			var radius := COPY_MIN + _frac(h, 2) * COPY_SPAN * f
			var moved := center + Vector2.from_angle(angle) * radius
			if not TerrainLayout.is_blocked(stage_key, moved) and not TerrainLayout.is_styx_water(stage_key, moved):
				clusters.append({"cluster": cluster, "center": moved, "zone": "%s_c" % cluster.zone, "copy": true})
	var taken := {}
	for entry_cluster in clusters:
		var center: Vector2 = entry_cluster.center
		for item in entry_cluster.cluster.items:
			var offset: Array = item.get("off", [0, 0])
			var at := center + Vector2(float(offset[0]), float(offset[1]))
			if at.x < MARGIN or at.y < MARGIN or at.x > map_size.x - MARGIN or at.y > map_size.y - MARGIN:
				continue
			if at.distance_to(start_ground) < START_CLEARANCE:
				continue
			if f > 1.001:
				# em mapa maior o desvio dentro do aglomerado não acompanha o terreno escalado: não pode cair em água, margem, parede nem em cima de outro prop
				var cell := Vector2i(int(round(at.x)), int(round(at.y)))
				if taken.has(cell) or _bad_ground(stage_key, at):
					continue
			taken[Vector2i(int(round(at.x)), int(round(at.y)))] = true
			var entry: Dictionary = item.duplicate(true)
			entry.zone = String(entry_cluster.zone)
			entry.pos = at
			out.append(entry)
	return out
