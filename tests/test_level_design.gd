extends RefCounted
## PLAN-054 F1: level design por bioma (data/level_design.json) lido por SceneryLayout.

const SceneryLayoutRef := preload("res://ui/scenery_layout.gd")

func run() -> Array:
	var out: Array = []
	var design: Dictionary = Data.table("level_design")
	var map_size := Vector2(60, 60)
	var start := Vector2(30, 30)
	var saved_scale := TerrainLayout.scale
	for stage_id in design:
		if String(stage_id).begins_with("_"):
			continue
		TerrainLayout.scale = map_size.x / 40.0
		var props := SceneryLayoutRef.expanded_props(stage_id, start, map_size)
		if props.is_empty():
			out.append("%s: level_design sem props" % stage_id)
		if props != SceneryLayoutRef.expanded_props(stage_id, start, map_size):
			out.append("%s: layout de props não é determinístico" % stage_id)
		var kinds: Dictionary = design.get("_kinds", {})
		for p in props:
			if not kinds.has(String(p.kind)):
				out.append("%s: tipo de prop sem dimensões: %s" % [stage_id, p.kind])
			var at: Vector2 = p.pos
			var material := String(TerrainLayout.material_at(stage_id, at))
			if TerrainLayout.is_styx_water(stage_id, at) or material.ends_with("bank") or material == "bank":
				out.append("%s: prop %s em água ou margem (%.1f, %.1f)" % [stage_id, p.kind, at.x, at.y])
		for key in ["clareira", "regioes", "trilhas"]:
			if not design[stage_id].get("chao", {}).has(key):
				out.append("%s: chao sem %s" % [stage_id, key])
		var seen := {}
		for p in props:
			var cell := Vector2i(int(round(p.pos.x)), int(round(p.pos.y)))
			if seen.has(cell):
				out.append("%s: dois props na mesma célula %s" % [stage_id, cell])
			seen[cell] = true
	TerrainLayout.scale = saved_scale
	return out
