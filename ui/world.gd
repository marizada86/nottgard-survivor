extends Node2D
## Mundo placeholder: chão xadrez, pilares e herói. Ordem de desenho por Y-sort.

const MAP := Vector2(40, 40)
const COL_A := Color(0.13, 0.12, 0.14)
const COL_B := Color(0.17, 0.15, 0.16)

var hero := Hero.new()
var hero_node: Node2D
var camera: Camera2D
var pillars: Array = []

func _ready() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 1
	hero.map_size = MAP
	hero.pos = MAP * 0.5
	for i in 60:
		var p := Vector2(rng.randi_range(2, 37), rng.randi_range(2, 37))
		if p.distance_to(hero.pos) < 3.0:
			continue
		pillars.append(p)
		hero.blockers.append(Vector3(p.x, p.y, 0.4))

	var ground := Node2D.new()
	ground.z_index = -100
	ground.draw.connect(_draw_ground.bind(ground))
	add_child(ground)

	var sorted := Node2D.new()
	sorted.y_sort_enabled = true
	add_child(sorted)
	for p in pillars:
		var n := Node2D.new()
		n.position = Iso.to_screen(p)
		n.draw.connect(_draw_pillar.bind(n))
		sorted.add_child(n)
	hero_node = Node2D.new()
	hero_node.draw.connect(_draw_hero.bind(hero_node))
	sorted.add_child(hero_node)

	camera = Camera2D.new()
	add_child(camera)
	_sync()

func _physics_process(dt: float) -> void:
	var d := Vector2(
		int(Input.is_physical_key_pressed(KEY_D) or Input.is_physical_key_pressed(KEY_RIGHT))
		- int(Input.is_physical_key_pressed(KEY_A) or Input.is_physical_key_pressed(KEY_LEFT)),
		int(Input.is_physical_key_pressed(KEY_S) or Input.is_physical_key_pressed(KEY_DOWN))
		- int(Input.is_physical_key_pressed(KEY_W) or Input.is_physical_key_pressed(KEY_UP)))
	hero.step(d, dt)
	_sync()

func _sync() -> void:
	hero_node.position = Iso.to_screen(hero.pos)
	camera.position = hero_node.position

func _diamond(c: Vector2, hw: float, hh: float) -> PackedVector2Array:
	return PackedVector2Array([c + Vector2(0, -hh), c + Vector2(hw, 0), c + Vector2(0, hh), c + Vector2(-hw, 0)])

func _draw_ground(n: Node2D) -> void:
	for x in int(MAP.x):
		for y in int(MAP.y):
			var c := Iso.to_screen(Vector2(x + 0.5, y + 0.5))
			n.draw_colored_polygon(_diamond(c, Iso.TILE_W * 0.5, Iso.TILE_H * 0.5), COL_A if (x + y) % 2 == 0 else COL_B)

func _draw_pillar(n: Node2D) -> void:
	n.draw_colored_polygon(_diamond(Vector2.ZERO, 22, 11), Color(0.28, 0.26, 0.28))
	n.draw_rect(Rect2(-22, -70, 44, 70), Color(0.3, 0.28, 0.3))
	n.draw_colored_polygon(_diamond(Vector2(0, -70), 22, 11), Color(0.4, 0.38, 0.4))

func _draw_hero(n: Node2D) -> void:
	n.draw_colored_polygon(_diamond(Vector2.ZERO, 14, 7), Color(0, 0, 0, 0.5))
	n.draw_rect(Rect2(-9, -42, 18, 42), Color(0.55, 0.15, 0.15))
	n.draw_circle(Vector2(0, -48), 8, Color(0.85, 0.75, 0.65))
