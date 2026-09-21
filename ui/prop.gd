@tool
extends Node2D
## Objeto de cenário que bloqueia movimento (grupo "blockers"). A posição do nó é em pixels de tela;
## o chão é derivado por Iso.to_ground(position). Mova/duplique no editor à vontade.

@export var height := 60.0: set = _set_height
@export var half_width := 22.0: set = _set_hw
@export var block_radius := 0.4   ## raio de colisão em tiles
@export var color := Color(0.24, 0.22, 0.24): set = _set_color

func _ready() -> void:
	add_to_group("blockers")

func _set_height(v: float) -> void:
	height = v
	queue_redraw()

func _set_hw(v: float) -> void:
	half_width = v
	queue_redraw()

func _set_color(v: Color) -> void:
	color = v
	queue_redraw()

func _diamond(c: Vector2, hw: float, hh: float) -> PackedVector2Array:
	return PackedVector2Array([c + Vector2(0, -hh), c + Vector2(hw, 0), c + Vector2(0, hh), c + Vector2(-hw, 0)])

func _draw() -> void:
	draw_colored_polygon(_diamond(Vector2.ZERO, half_width, half_width * 0.5), color.darkened(0.1))
	draw_rect(Rect2(-half_width, -height, half_width * 2, height), color)
	draw_colored_polygon(_diamond(Vector2(0, -height), half_width, half_width * 0.5), color.lightened(0.15))
