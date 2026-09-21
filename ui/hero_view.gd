@tool
extends Node2D
## Visual placeholder do herói. A posição inicial do nó no editor = ponto de partida da run.

@export var body_color := Color(0.55, 0.15, 0.15): set = _set_body
@export var skin_color := Color(0.85, 0.75, 0.65)
@export var hair_color := Color(0.9, 0.9, 0.95)
var dead := false
var flash := false
var facing := Vector2(1, 1)

func _set_body(v: Color) -> void:
	body_color = v
	queue_redraw()

func apply_hero(hero_id: String) -> void:
	var d: Dictionary = Data.table("heroes")[hero_id]
	body_color = Color(float(d.color[0]) / 255.0, float(d.color[1]) / 255.0, float(d.color[2]) / 255.0)
	hair_color = Color(float(d.hair[0]) / 255.0, float(d.hair[1]) / 255.0, float(d.hair[2]) / 255.0)
	queue_redraw()

func _draw() -> void:
	draw_colored_polygon(PackedVector2Array([Vector2(0, -8), Vector2(16, 0), Vector2(0, 8), Vector2(-16, 0)]), Color(0, 0, 0, 0.5))
	var body := body_color
	if dead:
		body = body.darkened(0.6)
	elif flash:
		body = Color(1, 0.6, 0.6)
	draw_rect(Rect2(-9, -40, 18, 40), body)
	draw_rect(Rect2(-9, -22, 18, 4), body.darkened(0.4))
	draw_circle(Vector2(0, -47), 8, skin_color)
	draw_arc(Vector2(0, -47), 8.5, PI, TAU, 12, hair_color, 4.0)
