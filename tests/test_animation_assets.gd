extends RefCounted

const ASSETS := {
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
	return failures
