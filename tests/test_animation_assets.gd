extends RefCounted

const ASSETS := {
	"res://assets/animations/heroes/brook/idle.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/brook/move_n.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/brook/move_ne.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/brook/move_e.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/brook/move_se.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/brook/move_s.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/brook/attack.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/brook/active.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/brook/death.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/nyrelia/idle.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/nyrelia/move_n.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/nyrelia/move_ne.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/nyrelia/move_e.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/nyrelia/move_se.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/nyrelia/move_s.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/nyrelia/attack.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/nyrelia/active.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/nyrelia/death.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/bromnor/idle.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/bromnor/move_n.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/bromnor/move_ne.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/bromnor/move_e.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/bromnor/move_se.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/bromnor/move_s.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/bromnor/attack.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/bromnor/active.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/bromnor/death.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/zynara/idle.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/zynara/move_n.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/zynara/move_ne.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/zynara/move_e.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/zynara/move_se.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/zynara/move_s.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/zynara/attack.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/zynara/active.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/zynara/death.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/leoric/idle.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/leoric/move_n.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/leoric/move_ne.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/leoric/move_e.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/leoric/move_se.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/leoric/move_s.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/leoric/attack.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/leoric/active.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/leoric/death.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/kayron/idle.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/kayron/move_n.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/kayron/move_ne.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/kayron/move_e.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/kayron/move_se.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/kayron/move_s.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/kayron/move_sw.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/kayron/move_w.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/kayron/move_nw.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/kayron/attack.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/kayron/active.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/kayron/death.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/maelor/idle.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/maelor/move_n.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/maelor/move_ne.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/maelor/move_e.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/maelor/move_se.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/maelor/move_s.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/maelor/move_sw.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/maelor/move_w.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/maelor/move_nw.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/maelor/attack.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/maelor/active.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/maelor/death.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/sylas/idle.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/sylas/move_n.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/sylas/move_ne.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/sylas/move_e.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/sylas/move_se.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/sylas/move_s.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/sylas/move_sw.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/sylas/move_w.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/sylas/move_nw.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/sylas/attack.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/sylas/active.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/sylas/death.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/durvall/idle.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/durvall/move.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/durvall/move_n.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/durvall/move_ne.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/durvall/move_e.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/durvall/move_se.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/durvall/move_s.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/durvall/move_sw.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/durvall/move_w.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/durvall/move_nw.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/durvall/attack.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/durvall/active.png": Vector2i(1536, 384),
	"res://assets/animations/heroes/durvall/death.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/zumbi/idle.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/zumbi/move.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/zumbi/attack.png": Vector2i(1024, 384),
	"res://assets/animations/enemies/zumbi/death.png": Vector2i(1536, 384),
	"res://assets/animations/enemies/sacerdote_mente_derretida/idle.png": Vector2i(1920, 480),
	"res://assets/animations/enemies/sacerdote_mente_derretida/move.png": Vector2i(2560, 480),
	"res://assets/animations/enemies/sacerdote_mente_derretida/attack.png": Vector2i(1920, 480),
	"res://assets/animations/enemies/sacerdote_mente_derretida/special_a.png": Vector2i(2560, 480),
	"res://assets/animations/enemies/sacerdote_mente_derretida/special_b.png": Vector2i(2560, 480),
	"res://assets/animations/enemies/sacerdote_mente_derretida/phase.png": Vector2i(2560, 480),
	"res://assets/animations/enemies/sacerdote_mente_derretida/death.png": Vector2i(3200, 480),
	"res://assets/animations/interactions/chest_open.png": Vector2i(1152, 192),
	"res://assets/animations/interactions/fountain_active.png": Vector2i(1152, 192),
	"res://assets/animations/interactions/altar_active.png": Vector2i(1152, 192),
	"res://assets/animations/interactions/ritual.png": Vector2i(1536, 192),
	"res://assets/animations/interactions/portal.png": Vector2i(1536, 192),
}

const MINIMUM_VISIBLE_COVERAGE := {
	"res://assets/animations/heroes/brook/move_n.png": 0.01,
	"res://assets/animations/heroes/brook/move_ne.png": 0.01,
	"res://assets/animations/heroes/brook/move_e.png": 0.01,
	"res://assets/animations/heroes/brook/move_se.png": 0.01,
	"res://assets/animations/heroes/maelor/move_n.png": 0.01,
}

func run() -> Array[String]:
	var failures: Array[String] = []
	for path in ASSETS:
		if not FileAccess.file_exists(path):
			failures.append("asset ausente: %s" % path)
			continue
		if not ResourceLoader.exists(path):
			failures.append("asset não importado: %s" % path)
			continue
		var image := Image.new()
		if image.load(ProjectSettings.globalize_path(path)) != OK:
			failures.append("PNG inválido: %s" % path)
		elif image.get_size() != ASSETS[path]:
			failures.append("dimensão %s em %s; esperada %s" % [image.get_size(), path, ASSETS[path]])
		elif image.detect_alpha() == Image.ALPHA_NONE:
			failures.append("sem canal alfa: %s" % path)
		elif path in MINIMUM_VISIBLE_COVERAGE and _visible_coverage(image) < MINIMUM_VISIBLE_COVERAGE[path]:
			failures.append("conteúdo visível insuficiente: %s" % path)
	for scene_path in ["res://ui/hero_view.tscn", "res://ui/enemy_view.tscn"]:
		var packed: PackedScene = load(scene_path)
		if packed == null:
			failures.append("cena inválida: %s" % scene_path)
			continue
		var instance := packed.instantiate()
		if instance.get_node_or_null("AnimatedSprite2D") == null:
			failures.append("AnimatedSprite2D ausente: %s" % scene_path)
		instance.free()
	var hero_script: Script = load("res://ui/hero_view.gd")
	var directions := {
		Vector2.UP: &"move_n", Vector2(1, -1): &"move_ne", Vector2.RIGHT: &"move_e", Vector2(1, 1): &"move_se",
		Vector2.DOWN: &"move_s", Vector2(-1, 1): &"move_sw", Vector2.LEFT: &"move_w", Vector2(-1, -1): &"move_nw",
	}
	for direction in directions:
		if hero_script.directional_walk_animation(direction) != directions[direction]:
			failures.append("direção incorreta para %s" % direction)
	var southwest_input: Vector2 = Hero.movement_input(true, false, false, true)
	var mirrors := {
		Vector2.LEFT: &"move_e", Vector2(-1, -1): &"move_ne", Vector2(-1, 1): &"move_se",
	}
	for direction in mirrors:
		if hero_script.walk_animation_for_direction(direction) != mirrors[direction]:
			failures.append("espelhamento incorreto para %s" % direction)
		if not hero_script.walk_flips_horizontally(direction):
			failures.append("espelhamento horizontal ausente para %s" % direction)
	if hero_script.walk_flips_horizontally(Vector2.RIGHT):
		failures.append("move_e nao deveria ser espelhado")
	if southwest_input != Vector2(-1, 1):
		failures.append("A+S não resolve para baixo e esquerda: %s" % southwest_input)
	var hero := Hero.new()
	hero.map_size = Vector2(100, 100)
	hero.pos = Vector2(50, 50)
	var before := Iso.to_screen(hero.pos)
	hero.step(southwest_input, 1.0 / 60.0)
	var southwest_delta := Iso.to_screen(hero.pos) - before
	if hero_script.directional_walk_animation(southwest_delta) != &"move_sw":
		failures.append("A+S não seleciona move_sw após o deslocamento: %s" % southwest_delta)
	failures.append_array(_validate_bromnor_runtime())
	failures.append_array(_validate_zynara_runtime())
	return failures

func _validate_bromnor_runtime() -> Array[String]:
	var failures: Array[String] = []
	var tree := Engine.get_main_loop() as SceneTree
	var packed: PackedScene = load("res://ui/hero_view.tscn")
	if tree == null or packed == null:
		return ["não foi possível instanciar o visual de Bromnor"]
	var hero_view: Node2D = packed.instantiate()
	tree.root.add_child(hero_view)
	hero_view.apply_hero("bromnor")
	var sprite := hero_view.get_node_or_null("AnimatedSprite2D") as AnimatedSprite2D
	if sprite == null or sprite.sprite_frames == null:
		failures.append("Bromnor não recebeu AnimatedSprite2D")
	else:
		var expected := {
			&"idle": 4, &"move_n": 6, &"move_ne": 6, &"move_e": 6, &"move_se": 6, &"move_s": 6,
			&"attack": 4, &"active": 6, &"death": 6,
		}
		for animation in expected:
			if not sprite.sprite_frames.has_animation(animation):
				failures.append("animação de Bromnor ausente em jogo: %s" % animation)
			elif sprite.sprite_frames.get_frame_count(animation) != expected[animation]:
				failures.append("quadros incorretos em Bromnor/%s" % animation)
		hero_view.play_action(&"attack")
		if sprite.animation != &"attack":
			failures.append("ataque de Bromnor não foi acionado")
		hero_view.play_action(&"active")
		if sprite.animation != &"active":
			failures.append("ativa de Bromnor não foi acionada")
		hero_view.sync_visual(Vector2(10, 10), true, false)
		if sprite.animation != &"death":
			failures.append("morte de Bromnor não foi acionada")
	hero_view.queue_free()
	return failures

func _validate_zynara_runtime() -> Array[String]:
	var failures: Array[String] = []
	var tree := Engine.get_main_loop() as SceneTree
	var packed: PackedScene = load("res://ui/hero_view.tscn")
	if tree == null or packed == null:
		return ["não foi possível instanciar o visual de Zynara"]
	var hero_view: Node2D = packed.instantiate()
	tree.root.add_child(hero_view)
	hero_view.apply_hero("zynara")
	var sprite := hero_view.get_node_or_null("AnimatedSprite2D") as AnimatedSprite2D
	if sprite == null or sprite.sprite_frames == null:
		failures.append("Zynara não recebeu AnimatedSprite2D")
	else:
		var expected := {
			&"idle": 4, &"move_n": 6, &"move_ne": 6, &"move_e": 6, &"move_se": 6, &"move_s": 6,
			&"attack": 4, &"active": 6, &"death": 6,
		}
		for animation in expected:
			if not sprite.sprite_frames.has_animation(animation):
				failures.append("animação de Zynara ausente em jogo: %s" % animation)
			elif sprite.sprite_frames.get_frame_count(animation) != expected[animation]:
				failures.append("quadros incorretos em Zynara/%s" % animation)
		hero_view.play_action(&"attack")
		if sprite.animation != &"attack":
			failures.append("ataque de Zynara não foi acionado")
		hero_view.play_action(&"active")
		if sprite.animation != &"active":
			failures.append("ativa de Zynara não foi acionada")
		hero_view.sync_visual(Vector2(10, 10), true, false)
		if sprite.animation != &"death":
			failures.append("morte de Zynara não foi acionada")
	hero_view.queue_free()
	return failures

func _visible_coverage(image: Image) -> float:
	var visible := 0
	var sampled := 0
	for y in range(0, image.get_height(), 8):
		for x in range(0, image.get_width(), 8):
			sampled += 1
			if image.get_pixel(x, y).a > 0.04:
				visible += 1
	return float(visible) / float(sampled) if sampled > 0 else 0.0
