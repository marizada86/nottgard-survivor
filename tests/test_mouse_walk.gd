extends RefCounted
## SPEC-072 / BUG-007: segurar o botão esquerdo para andar (conta pura em `Hero.mouse_walk_dir`).
## Que o cursor sobre a HUD seja detectado (`Hud.pointer_over_ui`) é conferido com a janela aberta em `tools/probe_mouse_walk.tscn`.

func _near(a: Vector2, b: Vector2) -> bool:
	return a.distance_to(b) < 0.001

func run() -> Array:
	var out: Array = []
	var Z := Vector2.ZERO

	# sem clique, nada muda
	if Hero.mouse_walk_dir(Z, false, false, Vector2(50, 0)) != Z:
		out.append("sem o botão segurado o herói não anda")
	# clique no mundo: anda até o cursor, vetor unitário
	if not _near(Hero.mouse_walk_dir(Z, true, false, Vector2(30, 40)), Vector2(0.6, 0.8)):
		out.append("clique no mundo deveria andar na direção do cursor (unitário)")
	if not _near(Hero.mouse_walk_dir(Z, true, false, Vector2(-100, 0)), Vector2(-1, 0)):
		out.append("clique à esquerda deveria andar para a esquerda")
	# clique sobre a HUD: não anda (o bug)
	if Hero.mouse_walk_dir(Z, true, true, Vector2(300, -200)) != Z:
		out.append("clicar num botão ou painel da HUD não pode mover o herói")
	# WASD tem prioridade sobre o clique, mesmo no mundo
	if Hero.mouse_walk_dir(Vector2(1, 0), true, false, Vector2(0, 80)) != Vector2(1, 0):
		out.append("tecla de movimento deveria ter prioridade sobre o clique")
	if Hero.mouse_walk_dir(Vector2(0, -1), true, true, Vector2(0, 80)) != Vector2(0, -1):
		out.append("tecla de movimento continua valendo com o cursor sobre a HUD")
	# zona morta: cursor colado no herói não faz tremer
	if Hero.mouse_walk_dir(Z, true, false, Vector2(3, 0)) != Z or Hero.mouse_walk_dir(Z, true, false, Vector2(4, 0)) != Z:
		out.append("dentro da zona morta (4 px) o herói fica parado")
	if not _near(Hero.mouse_walk_dir(Z, true, false, Vector2(5, 0)), Vector2(1, 0)):
		out.append("logo fora da zona morta o herói anda")
	if Hero.mouse_walk_dir(Z, true, false, Vector2(3, 0), 1.0) == Z:
		out.append("a zona morta é um parâmetro (1 px: 3 px já anda)")
	return out
