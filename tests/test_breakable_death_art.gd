extends RefCounted
## SPEC-185 (LOT04 e LOT05): os 12 quebráveis tocam a tira de morte própria no lugar da arte estática, sem mudar a arte antes de quebrar.

const EnemyViewScript := preload("res://ui/enemy_view.gd")

func run() -> Array:
	var out: Array = []
	var tree := Engine.get_main_loop() as SceneTree
	var packed: PackedScene = load("res://ui/enemy_view.tscn")
	if tree == null or packed == null:
		return ["não foi possível instanciar o visual de inimigo"]
	if EnemyViewScript.DEATH_ONLY.size() != 12:
		out.append("deveria haver 12 quebráveis com tira de morte, há %d" % EnemyViewScript.DEATH_ONLY.size())
	for id in EnemyViewScript.DEATH_ONLY:
		var strip := "res://assets/animations/enemies/%s/death.png" % id
		if not ResourceLoader.exists(strip):
			out.append("tira de morte ausente: %s" % id)
			continue
		var tex: Texture2D = load(strip)
		if tex.get_width() != EnemyViewScript.DEATH_ONLY_CELL.x * EnemyViewScript.DEATH_ONLY_FRAMES or tex.get_height() != EnemyViewScript.DEATH_ONLY_CELL.y:
			out.append("%s: tira com %dx%d, esperado %dx%d" % [id, tex.get_width(), tex.get_height(), EnemyViewScript.DEATH_ONLY_CELL.x * EnemyViewScript.DEATH_ONLY_FRAMES, EnemyViewScript.DEATH_ONLY_CELL.y])
		var view = packed.instantiate()
		tree.root.add_child(view)
		view.setup(Enemy.make(id, Vector2.ZERO))
		if view.sprite.visible:
			out.append("%s: a tira não pode aparecer antes de quebrar" % id)
		if view.tex == null:
			out.append("%s: sem a arte estática antes de quebrar" % id)
		if not view._death_only or view._static_hidden:
			out.append("%s: estado inicial errado (death_only=%s, static_hidden=%s)" % [id, view._death_only, view._static_hidden])
		view.play_death()
		if not view.sprite.visible or view.sprite.animation != &"death" or not view._static_hidden:
			out.append("%s: ao quebrar, a tira de morte deveria tocar e esconder a arte estática" % id)
		elif view.sprite.sprite_frames.get_frame_count(&"death") != EnemyViewScript.DEATH_ONLY_FRAMES:
			out.append("%s: a tira deveria ter %d quadros" % [id, EnemyViewScript.DEATH_ONLY_FRAMES])
		else:
			# a base da arte no primeiro quadro assenta na linha de base da célula, na escala da arte estática
			var first: Image = view.sprite.sprite_frames.get_frame_texture(&"death", 0).get_image()
			var used := first.get_used_rect()
			if absi(used.end.y - int(EnemyViewScript.DEATH_ONLY_BASELINE)) > 40:
				out.append("%s: base do primeiro quadro em %d, esperada perto de %d" % [id, used.end.y, int(EnemyViewScript.DEATH_ONLY_BASELINE)])
		view.free()
	# inimigo comum (sem tira de morte) segue com o desvanecer
	var plain = packed.instantiate()
	tree.root.add_child(plain)
	plain.setup(Enemy.make("zumbi", Vector2.ZERO))
	if plain._death_only:
		out.append("inimigo comum não deveria ter tira de morte de quebrável")
	plain.free()
	return out
