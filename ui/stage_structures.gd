class_name StageStructures
extends RefCounted
## Adds one safe, non-blocking Lot 2 structure to a stage's y-sorted layer.

const Prop := preload("res://ui/prop.gd")
const FOOTPRINT_OFFSETS := [
	Vector2.ZERO, Vector2(1.5, 0), Vector2(-1.5, 0), Vector2(0, 1.5), Vector2(0, -1.5),
	Vector2(1.0, 1.0), Vector2(1.0, -1.0), Vector2(-1.0, 1.0), Vector2(-1.0, -1.0)
]
const MIN_START_DISTANCE := 8.0
const BLOCKER_CLEARANCE := 3.5
const SEARCH_RADIUS := 12

static func attach_for_stage(parent: Node2D, stage_key: String, start_ground: Vector2, map_size: Vector2, blockers: Array) -> Node2D:
	var profile: Dictionary = Data.table("stage_structures").get(stage_key, {})
	if profile.is_empty():
		return null
	var target_data: Array = profile.get("target", [map_size.x * 0.5, map_size.y * 0.5])
	var target := Vector2(float(target_data[0]), float(target_data[1]))
	if profile.has("target"):
		target *= map_size.x / 60.0  # SPEC-152: o alvo foi desenhado para 60x60
	var ground := resolve_ground_position(stage_key, target, start_ground, map_size, blockers)
	if not is_finite(ground.x) or not is_finite(ground.y):
		return null
	var prop := Prop.new()
	prop.name = "Structure_%s" % stage_key
	prop.kind = String(profile.kind)
	prop.height = float(profile.get("height", 158.0))
	prop.half_width = float(profile.get("half_width", 50.0))
	prop.block_radius = 0.0
	prop.position = Iso.to_screen(ground)
	parent.add_child(prop)
	return prop

static func resolve_ground_position(stage_key: String, target: Vector2, start_ground: Vector2, map_size: Vector2, blockers: Array) -> Vector2:
	var first := Vector2(floor(target.x) + 0.5, floor(target.y) + 0.5)
	for radius in range(SEARCH_RADIUS + 1):
		for x in range(-radius, radius + 1):
			for y in range(-radius, radius + 1):
				if maxi(absi(x), absi(y)) != radius:
					continue
				var candidate := first + Vector2(x, y)
				if _is_safe(stage_key, candidate, start_ground, map_size, blockers):
					return candidate
	return Vector2(INF, INF)

static func _is_safe(stage_key: String, center: Vector2, start_ground: Vector2, map_size: Vector2, blockers: Array) -> bool:
	if center.distance_to(start_ground) < MIN_START_DISTANCE:
		return false
	for offset in FOOTPRINT_OFFSETS:
		var point: Vector2 = center + offset
		if point.x < 3.0 or point.y < 3.0 or point.x > map_size.x - 3.0 or point.y > map_size.y - 3.0:
			return false
		if TerrainLayout.is_styx_water(stage_key, point) or TerrainLayout.is_blocked(stage_key, point):
			return false
	for blocker in blockers:
		if not (blocker is Vector3):
			continue
		var clearance := float(blocker.z) + BLOCKER_CLEARANCE
		if center.distance_to(Vector2(blocker.x, blocker.y)) < clearance:
			return false
	return true
