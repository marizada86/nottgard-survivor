extends RefCounted

const ASSETS := {
	"res://assets/animations/heroes/durvall/idle.png": Vector2i(1024, 384),
	"res://assets/animations/heroes/durvall/move.png": Vector2i(1536, 384),
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
		if not ResourceLoader.exists(path):
			failures.append("asset ausente: %s" % path)
			continue
		var texture: Texture2D = load(path)
		var image := texture.get_image()
		if image.is_empty():
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
	return failures
