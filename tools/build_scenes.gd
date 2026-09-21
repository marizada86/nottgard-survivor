extends SceneTree
## Gera as cenas editáveis (ui/*.tscn) a partir dos scripts. Uso:
##   godot --headless --path . -s tools/build_scenes.gd
## Depois do 1º build, edite as cenas no editor; NÃO rode de novo sem querer sobrescrever suas edições.

func _save(root: Node, path: String) -> void:
	var p := PackedScene.new()
	p.pack(root)
	var err := ResourceSaver.save(p, path)
	print("%s -> %s" % [path, error_string(err)])
	root.free()

func _simple(script_path: String, node_name: String, path: String) -> void:
	var n := Node2D.new()
	n.name = node_name
	n.set_script(load(script_path))
	_save(n, path)

func _inst(path: String, node_name: String, pos: Vector2, owner_node: Node, parent: Node) -> Node:
	var n: Node = load(path).instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	n.name = node_name
	n.position = pos
	parent.add_child(n)
	n.owner = owner_node
	return n

func _own(n: Node, owner_node: Node, parent: Node) -> Node:
	parent.add_child(n)
	n.owner = owner_node
	return n

func _init() -> void:
	_simple("res://ui/hero_view.gd", "Hero", "res://ui/hero_view.tscn")
	_simple("res://ui/enemy_view.gd", "EnemyView", "res://ui/enemy_view.tscn")
	_simple("res://ui/prop.gd", "Pillar", "res://ui/pillar.tscn")
	_simple("res://ui/spawn_point.gd", "SpawnPoint", "res://ui/spawn_point.tscn")

	var w := Node2D.new()
	w.name = "World"
	w.set_script(load("res://ui/world.gd"))

	var ground := Node2D.new()
	ground.name = "Ground"
	ground.z_index = -100
	ground.set_script(load("res://ui/ground.gd"))
	_own(ground, w, w)

	var sorted := Node2D.new()
	sorted.name = "Sorted"
	sorted.y_sort_enabled = true
	_own(sorted, w, w)
	_inst("res://ui/hero_view.tscn", "Hero", Iso.to_screen(Vector2(20, 20)), w, sorted)

	var rng := RandomNumberGenerator.new()
	rng.seed = 1
	var idx := 1
	for i in 40:
		var p := Vector2(rng.randi_range(2, 37), rng.randi_range(2, 37))
		if p.distance_to(Vector2(20, 20)) < 4.0:
			continue
		_inst("res://ui/pillar.tscn", "Pillar%d" % idx, Iso.to_screen(p), w, sorted)
		idx += 1

	var fx := Node2D.new()
	fx.name = "Fx"
	fx.z_index = 100
	_own(fx, w, w)

	var spawns := Node2D.new()
	spawns.name = "SpawnPoints"
	_own(spawns, w, w)
	var layout := [["zumbi", 3, Vector2(28, 20)], ["zumbi", 2, Vector2(12, 26)],
		["cultista_adaga", 2, Vector2(20, 10)], ["slime_corrosivo", 2, Vector2(26, 27)]]
	var n := 1
	for s in layout:
		var sp := _inst("res://ui/spawn_point.tscn", "Spawn%d" % n, Iso.to_screen(s[2]), w, spawns)
		sp.enemy_id = s[0]
		sp.count = s[1]
		n += 1

	var cam := Camera2D.new()
	cam.name = "Camera"
	cam.position = Iso.to_screen(Vector2(20, 20))
	_own(cam, w, w)

	var hud := CanvasLayer.new()
	hud.name = "Hud"
	_own(hud, w, w)
	var label := Label.new()
	label.name = "Label"
	label.position = Vector2(12, 8)
	label.text = "HUD"
	_own(label, w, hud)

	_save(w, "res://ui/world.tscn")

	var main := Node.new()
	main.name = "Main"
	main.set_script(load("res://ui/main.gd"))
	var wi: Node = load("res://ui/world.tscn").instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	wi.name = "World"
	main.add_child(wi)
	wi.owner = main
	_save(main, "res://ui/main.tscn")
	quit()
