@tool
extends Node2D
## Chão isométrico xadrez (placeholder). Edite tamanho e cores no Inspector.

@export var map_size := Vector2i(40, 40): set = _set_size
@export var color_a := Color(0.13, 0.12, 0.14): set = _set_a
@export var color_b := Color(0.17, 0.15, 0.16): set = _set_b

func _set_size(v: Vector2i) -> void:
	map_size = v
	queue_redraw()

func _set_a(v: Color) -> void:
	color_a = v
	queue_redraw()

func _set_b(v: Color) -> void:
	color_b = v
	queue_redraw()

func _draw() -> void:
	var hw := Iso.TILE_W * 0.5
	var hh := Iso.TILE_H * 0.5
	for x in map_size.x:
		for y in map_size.y:
			var c := Iso.to_screen(Vector2(x + 0.5, y + 0.5))
			draw_colored_polygon(PackedVector2Array([c + Vector2(0, -hh), c + Vector2(hw, 0), c + Vector2(0, hh), c + Vector2(-hw, 0)]),
				color_a if (x + y) % 2 == 0 else color_b)
