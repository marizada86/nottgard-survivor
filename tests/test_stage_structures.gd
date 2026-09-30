extends RefCounted

const StageStructures := preload("res://ui/stage_structures.gd")

func run() -> Array:
	var out: Array[String] = []
	var profiles: Dictionary = Data.table("stage_structures")
	var stages: Dictionary = Data.table("stages")
	var previous_scale := TerrainLayout.scale
	for stage_key in stages:
		if not profiles.has(stage_key):
			out.append("missing structure configuration: %s" % stage_key)
			continue
		var profile: Dictionary = profiles[stage_key]
		var kind := String(profile.get("kind", ""))
		var texture_path := "res://assets/props/%s.png" % kind
		if not FileAccess.file_exists(texture_path):
			out.append("official structure asset missing: %s" % texture_path)
			continue
		var image := Image.load_from_file(ProjectSettings.globalize_path(texture_path))
		if image == null or image.is_empty() or image.get_size() != Vector2i(256, 256):
			out.append("structure must be a valid 256x256 image: %s" % texture_path)
			continue
		if image.get_pixel(0, 0).a > 0.03 or image.get_pixel(255, 255).a > 0.03:
			out.append("structure corner is not transparent: %s" % texture_path)
		if String(Data.table("prop_visuals").get("assets", {}).get(texture_path, {}).get("shadow_mode", "")) != "none":
			out.append("structure must use its alpha silhouette without dynamic shadow: %s" % texture_path)

		var packed: PackedScene = load("res://ui/stages/%s.tscn" % stage_key)
		var stage_root := packed.instantiate()
		var sorted: Node2D = stage_root.get_node("Sorted")
		if not sorted.y_sort_enabled:
			out.append("stage sorted layer must keep y-sort enabled for %s" % stage_key)
		var hero: Node2D = sorted.get_node("Hero")
		var ground: Node2D = stage_root.get_node("Ground")
		var map_size := Vector2(ground.get("map_size"))
		TerrainLayout.scale = map_size.x / 40.0
		var blockers: Array[Vector3] = []
		for child in sorted.get_children():
			if child.has_method("set_grounding_guide") and child.visible and float(child.get("block_radius")) > 0.0:
				var ground_pos := Iso.to_ground(child.position)
				blockers.append(Vector3(ground_pos.x, ground_pos.y, float(child.get("block_radius"))))
		var start_ground := Iso.to_ground(hero.position)
		var target_data: Array = profile.get("target", [])
		var target := Vector2(float(target_data[0]), float(target_data[1]))
		var placed := StageStructures.resolve_ground_position(stage_key, target, start_ground, map_size, blockers)
		if not is_finite(placed.x) or not is_finite(placed.y):
			out.append("no safe structure tile found for %s" % stage_key)
		else:
			if placed.distance_to(start_ground) < StageStructures.MIN_START_DISTANCE:
				out.append("structure too near start for %s" % stage_key)
			for offset in StageStructures.FOOTPRINT_OFFSETS:
				var point: Vector2 = placed + offset
				if TerrainLayout.is_styx_water(stage_key, point) or TerrainLayout.is_blocked(stage_key, point):
					out.append("structure footprint intersects unsafe ground in %s" % stage_key)
					break
			for blocker in blockers:
				if placed.distance_to(Vector2(blocker.x, blocker.y)) < float(blocker.z) + StageStructures.BLOCKER_CLEARANCE:
					out.append("structure too near a blocker in %s" % stage_key)
					break
			var structure := StageStructures.attach_for_stage(sorted, stage_key, start_ground, map_size, blockers)
			if structure == null:
				out.append("structure could not be attached for %s" % stage_key)
			elif float(structure.get("block_radius")) != 0.0:
				out.append("structure unexpectedly blocks movement in %s" % stage_key)
			elif String(structure.get("kind")) != kind:
				out.append("wrong structure kind in %s" % stage_key)
			elif structure.call("_prop_texture") == null:
				out.append("structure texture could not be loaded at runtime: %s" % texture_path)
		stage_root.free()
	TerrainLayout.scale = previous_scale
	for stage_key in profiles:
		if not stages.has(stage_key):
			out.append("structure configured for unknown stage: %s" % stage_key)
	return out
