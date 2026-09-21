@tool
extends Node2D
## Visual placeholder do herói. A posição inicial do nó no editor = ponto de partida da run.

@export var body_color := Color(0.55, 0.15, 0.15): set = _set_body
@export var skin_color := Color(0.85, 0.75, 0.65)
var dead := false

func _set_body(v: Color) -> void:
	body_color = v
	queue_redraw()

func _draw() -> void:
	draw_colored_polygon(PackedVector2Array([Vector2(0, -7), Vector2(14, 0), Vector2(0, 7), Vector2(-14, 0)]), Color(0, 0, 0, 0.5))
	draw_rect(Rect2(-9, -42, 18, 42), body_color.darkened(0.5) if dead else body_color)
	draw_circle(Vector2(0, -48), 8, skin_color)
