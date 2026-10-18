extends RefCounted
## SPEC-185 (LOT13 e LOT14): Manifestação de Juiblex, Mímico e Turíbulo animados; a ruptura do Turíbulo (TD) segue retida.

const EnemyViewScript := preload("res://ui/enemy_view.gd")
const STATES := {
	"manifestacao_de_juiblex": {"idle": 4, "move": 6, "attack": 4, "death": 6, "special": 6},
	"mimico": {"idle": 4, "move": 6, "attack": 4, "death": 6},
	"totem_de_chefe": {"idle": 4},
}

func run() -> Array:
	var out: Array = []
	var tree := Engine.get_main_loop() as SceneTree
	var packed: PackedScene = load("res://ui/enemy_view.tscn")
	if tree == null or packed == null:
		return ["não foi possível instanciar o visual de inimigo"]
	for id in STATES:
		if not EnemyViewScript.ANIMATED.has(id):
			out.append("%s: falta a entrada em ANIMATED" % id)
			continue
		var spec: Dictionary = EnemyViewScript.ANIMATED[id]
		if spec.states != STATES[id]:
			out.append("%s: estados %s, esperado %s" % [id, str(spec.states), str(STATES[id])])
		if not EnemyViewScript.FEET_Y.has(id):
			out.append("%s: falta a linha dos pés em FEET_Y" % id)
		for state in STATES[id]:
			var path := "res://assets/animations/enemies/%s/%s.png" % [id, state]
			if not ResourceLoader.exists(path):
				out.append("%s: tira ausente (%s)" % [id, state])
				continue
			var tex: Texture2D = load(path)
			var cell: Vector2i = spec.cell
			if tex.get_width() != cell.x * int(STATES[id][state]) or tex.get_height() != cell.y:
				out.append("%s/%s: tira com %dx%d, esperado %dx%d" % [id, state, tex.get_width(), tex.get_height(), cell.x * int(STATES[id][state]), cell.y])
		var view = packed.instantiate()
		tree.root.add_child(view)
		view.setup(Enemy.make(id, Vector2.ZERO))
		if not view._has_animation or not view.sprite.visible:
			out.append("%s: deveria usar a animação" % id)
		elif view.sprite.animation != &"idle":
			out.append("%s: deveria começar no idle" % id)
		view.free()
	# a ruptura do Turíbulo (TD) está retida: sem tira de morte para ele
	if ResourceLoader.exists("res://assets/animations/enemies/totem_de_chefe/death.png"):
		out.append("totem_de_chefe: a ruptura TD está retida e não pode entrar")
	return out
