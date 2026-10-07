@tool
extends Node2D
## Módulos de penhasco desenhados como objetos do grupo y-sorted da fase.

const TerrainLayout := preload("res://core/terrain_layout.gd")

@export var terrain_layout_id := "": set = _set_layout
@export var visual_ground_offset := 0.0: set = _set_ground_offset

func _set_layout(value: String) -> void:
	terrain_layout_id = value
	if is_node_ready():
		_rebuild()

func _set_ground_offset(value: float) -> void:
	visual_ground_offset = value
	if is_node_ready():
		_rebuild()

func _ready() -> void:
	_rebuild()

func _rebuild() -> void:
	for child in get_children():
		child.queue_free()
	for anchor in TerrainLayout.mountain_anchors(terrain_layout_id):
		var ridge := Ridge.new()
		ridge.position = Iso.to_screen(Vector2(anchor.x, anchor.y))
		ridge.radius = anchor.z
		ridge.ground_offset = visual_ground_offset
		add_child(ridge)

class Ridge extends Node2D:
	var radius := 2.0: set = _set_radius
	var ground_offset := 0.0: set = _set_ground_offset

	func _set_radius(value: float) -> void:
		radius = value
		queue_redraw()

	func _set_ground_offset(value: float) -> void:
		ground_offset = value
		queue_redraw()

	## A colisão da montanha é um círculo de `radius` tiles no chão; sem esta base a rocha visível
	## ocupava menos da metade da área bloqueada e o herói travava no ar (BUG: obstrução invisível).
	func _draw_footprint(base: Vector2) -> void:
		var rim := PackedVector2Array()
		var inner := PackedVector2Array()
		var steps := 36
		for i in steps:
			var a := TAU * i / steps
			var jag := 1.0 - 0.06 * float(i % 3)
			var g := Vector2(cos(a), sin(a)) * radius
			rim.append(base + Iso.to_screen(g * jag))
			inner.append(base + Iso.to_screen(g * 0.72 * jag))
		draw_colored_polygon(rim, Color(0.17, 0.12, 0.15, 0.9))
		draw_colored_polygon(inner, Color(0.24, 0.17, 0.2, 0.9))
		rim.append(rim[0])
		draw_polyline(rim, Color("806050", 0.75), 2.0)

	func _draw() -> void:
		var w := 24.0 + radius * 12.0
		var h := 14.0 + radius * 7.0
		var base := Vector2(0, ground_offset)
		_draw_footprint(base)
		var shadow := PackedVector2Array([base + Vector2(-w, 3), base + Vector2(0, h), base + Vector2(w, 3), base + Vector2(0, -h)])
		draw_colored_polygon(shadow, Color(0.05, 0.035, 0.05, 0.62))
		var body := PackedVector2Array([base + Vector2(-w * 0.8, 0), base + Vector2(-w * 0.35, -h * 2.8), base + Vector2(w * 0.18, -h * 3.5), base + Vector2(w * 0.8, -h * 0.3), base + Vector2(w * 0.5, h * 0.3), base + Vector2(-w * 0.3, h * 0.45)])
		draw_colored_polygon(body, Color("493842"))
		draw_polyline(PackedVector2Array([base + Vector2(-w * 0.45, -h * 0.25), base + Vector2(-w * 0.10, -h * 1.9), base + Vector2(w * 0.18, -h * 0.35)]), Color("806050"), 2.0)
		draw_circle(base + Vector2(w * 0.35, -h * 0.4), 3.0, Color("9a6d55"))
