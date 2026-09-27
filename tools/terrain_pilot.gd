extends Node2D
## Piloto reversível: duas grades 8x8 sem usar candidatos de arte como assets finais.

const Ground := preload("res://ui/ground.gd")

func _ready() -> void:
	add_child(_make_ground("dagruve", "res://assets/tiles/dagruve_ground_atlas_v3.png", Vector2(300, 175), Color(0.17, 0.105, 0.15), Color(0.235, 0.135, 0.20), 17))
	add_child(_make_ground("docas", "res://assets/tiles/docas_ground_atlas_v3.png", Vector2(930, 175), Color(0.105, 0.145, 0.17), Color(0.14, 0.20, 0.22), 31))

func _make_ground(stage_id: String, atlas_path: String, position_on_screen: Vector2, a: Color, b: Color, seed: int) -> Node2D:
	var ground := Ground.new()
	ground.name = stage_id.capitalize()
	ground.position = position_on_screen
	ground.map_size = Vector2i(8, 8)
	ground.color_a = a
	ground.color_b = b
	ground.visual_seed = seed
	ground.stage_visual_id = stage_id
	ground.use_modular_atlas = true
	ground.atlas_columns = 2
	ground.atlas_variants = 4
	ground.terrain_texture_path = atlas_path
	return ground
