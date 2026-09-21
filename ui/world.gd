extends Node2D
## Controla a run. Toda a cena (chão, props, herói, spawns, câmera, HUD) vem do world.tscn — edite no editor.

const ENEMY_VIEW := preload("res://ui/enemy_view.tscn")
const RING_IDS := ["zumbi", "zumbi", "cultista_adaga", "slime_corrosivo"]

@onready var ground: Node2D = $Ground
@onready var sorted: Node2D = $Sorted
@onready var hero_node: Node2D = $Sorted/Hero
@onready var fx: Node2D = $Fx
@onready var camera: Camera2D = $Camera
@onready var hud: Label = $Hud/Label
@onready var spawn_points: Node = $SpawnPoints

var battle: Battle
var hero: Hero
var enemy_nodes := {}   # Enemy -> Node2D
var seed_n := 1
var map_size := Vector2(40, 40)
var start_screen_pos := Vector2.ZERO

func _ready() -> void:
	map_size = Vector2(ground.map_size)
	start_screen_pos = hero_node.position
	_new_battle()

func _new_battle() -> void:
	for n in enemy_nodes.values():
		n.queue_free()
	enemy_nodes.clear()
	var prev_aim := battle.aim if battle != null else Battle.Aim.AUTO
	battle = Battle.new(seed_n)
	battle.aim = prev_aim
	hero = battle.hero
	hero.map_size = map_size
	hero.pos = Iso.to_ground(start_screen_pos)
	hero_node.dead = false
	for b in get_tree().get_nodes_in_group("blockers"):
		var g := Iso.to_ground(b.position)
		hero.blockers.append(Vector3(g.x, g.y, b.block_radius))
	for sp in spawn_points.get_children():
		for i in int(sp.count):
			var off: Vector2 = Vector2(battle.rng.randf_range(-1, 1), battle.rng.randf_range(-1, 1)) * float(sp.scatter)
			_spawn(sp.enemy_id, Iso.to_ground(sp.position) + off)
	_sync()

func _spawn(id: String, at: Vector2) -> void:
	var e := battle.spawn(id, at.clamp(Vector2(1, 1), map_size - Vector2(1, 1)))
	var node := ENEMY_VIEW.instantiate()
	sorted.add_child(node)
	node.setup(e)
	enemy_nodes[e] = node

func _spawn_ring(n: int) -> void:
	for i in n:
		var ang := battle.rng.randf() * TAU
		_spawn(RING_IDS[battle.rng.randi() % RING_IDS.size()], hero.pos + Vector2(cos(ang), sin(ang)) * battle.rng.randf_range(6.0, 9.0))

func _unhandled_input(ev: InputEvent) -> void:
	if ev is InputEventKey and ev.pressed and not ev.echo:
		match ev.physical_keycode:
			KEY_TAB: battle.toggle_aim()
			KEY_Q: battle.use_skill()
			KEY_F: _spawn_ring(5)
			KEY_R:
				seed_n += 1
				_new_battle()
	elif ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_RIGHT:
		battle.use_skill()

func _physics_process(dt: float) -> void:
	var d := Vector2(
		int(Input.is_physical_key_pressed(KEY_D) or Input.is_physical_key_pressed(KEY_RIGHT))
		- int(Input.is_physical_key_pressed(KEY_A) or Input.is_physical_key_pressed(KEY_LEFT)),
		int(Input.is_physical_key_pressed(KEY_S) or Input.is_physical_key_pressed(KEY_DOWN))
		- int(Input.is_physical_key_pressed(KEY_W) or Input.is_physical_key_pressed(KEY_UP)))
	var to_mouse := Iso.to_ground(get_global_mouse_position() - hero_node.position)
	if to_mouse.length() > 0.01:
		battle.aim_dir = to_mouse.normalized()
	battle.step(d, dt)
	_sync()
	_consume_events()

func _sync() -> void:
	hero_node.position = Iso.to_screen(hero.pos)
	hero_node.dead = hero.dead
	hero_node.queue_redraw()
	camera.position = hero_node.position
	for e in enemy_nodes.keys():
		var n: Node2D = enemy_nodes[e]
		if e.dead:
			n.queue_free()
			enemy_nodes.erase(e)
		else:
			n.position = Iso.to_screen(e.pos)
			n.queue_redraw()
	hud.text = "%s  PV %d/%d  CA %d   XP %d\nModo: %s (Tab)   Q/botao dir: Romper Armadura %s\nF: +inimigos   R: reiniciar%s" % [
		hero.name, hero.hp, hero.max_hp, hero.ca, hero.xp,
		"AUTO" if battle.aim == Battle.Aim.AUTO else "MOUSE",
		"pronto" if hero.skill_timer <= 0.0 else "%.1fs" % hero.skill_timer,
		"\n\nVOCE MORREU - R para reiniciar" if hero.dead else ""]

func _consume_events() -> void:
	for ev in battle.events:
		var at := Iso.to_screen(ev.pos)
		match ev.type:
			"dmg":
				_float_text(at + Vector2(0, -40), str(ev.amount) if ev.hit else "erra",
					Color(1, 0.85, 0.3) if ev.crit else Color(0.9, 0.9, 0.9))
			"hurt": _float_text(at + Vector2(0, -60), "-%d" % ev.amount, Color(0.9, 0.2, 0.2))
			"text": _float_text(at + Vector2(0, -50), ev.text, Color(0.6, 0.7, 1.0))
			"swing": _swing(at, ev.dir)
	battle.events.clear()

func _float_text(at: Vector2, text: String, col: Color) -> void:
	var l := Label.new()
	l.text = text
	l.position = at
	l.modulate = col
	fx.add_child(l)
	var t := create_tween()
	t.tween_property(l, "position:y", at.y - 24, 0.7)
	t.parallel().tween_property(l, "modulate:a", 0.0, 0.7)
	t.tween_callback(l.queue_free)

func _swing(at: Vector2, dir: Vector2) -> void:
	var line := Line2D.new()
	var s := Iso.to_screen(dir).normalized()
	line.points = PackedVector2Array([at + Vector2(0, -20) + s * 20, at + Vector2(0, -20) + s * 70])
	line.width = 3
	line.default_color = Color(0.9, 0.9, 0.95, 0.8)
	fx.add_child(line)
	var t := create_tween()
	t.tween_property(line, "modulate:a", 0.0, 0.15)
	t.tween_callback(line.queue_free)
