@tool
extends Node2D
## Chão isométrico texturizado. Cores continuam servindo de fallback no editor.

@export var map_size := Vector2i(40, 40): set = _set_size
@export var color_a := Color(0.13, 0.12, 0.14): set = _set_a
@export var color_b := Color(0.17, 0.15, 0.16): set = _set_b
var _texture: Texture2D
var _texture_path := ""

func _set_size(v: Vector2i) -> void:
	map_size = v
	queue_redraw()

func _set_a(v: Color) -> void:
	color_a = v
	queue_redraw()

func _set_b(v: Color) -> void:
	color_b = v
	queue_redraw()

func _stage_id() -> String:
	var cursor: Node = self
	while cursor != null:
		if cursor.scene_file_path != "":
			return cursor.scene_file_path.get_file().get_basename()
		cursor = cursor.get_parent()
	return ""

func _ground_texture() -> Texture2D:
	var stage_id := _stage_id()
	var path := "res://assets/tiles/%s_ground.png" % stage_id
	if path != _texture_path:
		_texture_path = path
		_texture = load(path) if ResourceLoader.exists(path) else null
	return _texture

func _draw() -> void:
	var hw := Iso.TILE_W * 0.5
	var hh := Iso.TILE_H * 0.5
	var texture := _ground_texture()
	var uvs := PackedVector2Array()
	if texture != null:
		uvs = PackedVector2Array([
			Vector2(0, 0), Vector2(texture.get_width(), 0),
			Vector2(texture.get_width(), texture.get_height()), Vector2(0, texture.get_height())
		])
	for x in map_size.x:
		for y in map_size.y:
			var c := Iso.to_screen(Vector2(x + 0.5, y + 0.5))
			var points := PackedVector2Array([c + Vector2(0, -hh), c + Vector2(hw, 0), c + Vector2(0, hh), c + Vector2(-hw, 0)])
			if texture != null:
				var tint := Color.WHITE if (x + y) % 2 == 0 else Color(0.9, 0.9, 0.94)
				draw_polygon(points, PackedColorArray([tint, tint, tint, tint]), uvs, texture)
			else:
				draw_colored_polygon(points, color_a if (x + y) % 2 == 0 else color_b)
