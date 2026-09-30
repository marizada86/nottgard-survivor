class_name GroundDecals
extends Node2D
## Decais oficiais do Lote 2. Não participam de física nem y-sort.

const GROUND_Z_INDEX := -100
const DECAL_Z_INDEX := -90
## Docas ainda não declara terra seca no layout lógico: até existir âncora de
## cais, nenhuma candidata é desenhada sobre sua lâmina d'água.
const PREVIEW_DISABLED_STAGES := [&"docas"]
const FOOTPRINT_SAMPLES := [Vector2.ZERO, Vector2(-3, 0), Vector2(3, 0), Vector2(0, -3), Vector2(0, 3), Vector2(-2, -2), Vector2(2, -2), Vector2(-2, 2), Vector2(2, 2)]

var stage_id := ""
var visual_seed := 0
var enabled := true
var _textures: Dictionary = {}

func _ready() -> void:
	z_index = DECAL_Z_INDEX
	queue_redraw()

static func deterministic_offset(stage_key: String, seed: int, entry_index: int) -> Vector2:
	var hash_value := 2166136261
	for byte in stage_key.to_utf8_buffer():
		hash_value = int((hash_value ^ byte) * 16777619) & 0x7fffffff
	hash_value = int((hash_value ^ seed) * 16777619) & 0x7fffffff
	hash_value = int((hash_value ^ (entry_index * 73856093)) * 16777619) & 0x7fffffff
	return Vector2(posmod(hash_value, 33) - 16, posmod(hash_value / 33, 17) - 8)

static func placements(stage_key: String, seed: int) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if stage_key in PREVIEW_DISABLED_STAGES:
		return result
	var entries: Array = Data.table("ground_decals").get(stage_key, [])
	for index in entries.size():
		var source: Dictionary = entries[index]
		var base: Array = source.get("position", [0, 0])
		var placement := source.duplicate(true)
		var desired := Vector2(float(base[0]), float(base[1])) + deterministic_offset(stage_key, seed, index)
		placement.position = _nearest_dry_position(stage_key, desired)
		result.append(placement)
	return result

static func _nearest_dry_position(stage_key: String, desired: Vector2) -> Vector2:
	var origin := Iso.to_ground(desired)
	var first := Vector2(floor(origin.x) + 0.5, floor(origin.y) + 0.5)
	for radius in range(0, 13):
		for x in range(-radius, radius + 1):
			for y in range(-radius, radius + 1):
				if maxi(absi(x), absi(y)) != radius:
					continue
				var candidate := first + Vector2(x, y)
				if _is_dry_footprint(stage_key, candidate):
					return Iso.to_screen(candidate)
	return desired

static func _is_dry_footprint(stage_key: String, center: Vector2) -> bool:
	for offset in FOOTPRINT_SAMPLES:
		var point: Vector2 = center + Vector2(offset)
		if point.x < 2.0 or point.y < 2.0 or point.x > 37.0 or point.y > 37.0:
			return false
		if TerrainLayout.is_styx_water(stage_key, point) or TerrainLayout.is_blocked(stage_key, point):
			return false
	return true

func _texture(path: String) -> Texture2D:
	if _textures.has(path):
		return _textures[path]
	var image := Image.load_from_file(ProjectSettings.globalize_path(path))
	var texture := ImageTexture.create_from_image(image) if image != null and not image.is_empty() else null
	_textures[path] = texture
	return texture

func _draw() -> void:
	if not enabled:
		return
	for placement in placements(stage_id, visual_seed):
		var texture := _texture(String(placement.path))
		var dimensions: Array = placement.get("size", [320, 160])
		var size := Vector2(float(dimensions[0]), float(dimensions[1]))
		if texture != null:
			draw_texture_rect(texture, Rect2(Vector2(placement.position) - size * 0.5, size), false)
