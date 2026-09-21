@tool
extends Node2D
## Ponto de spawn inicial. Escolha o inimigo (id de data/enemies.json) e a quantidade no Inspector.
## Posição do nó em pixels de tela. No jogo, `count` inimigos nascem espalhados perto do ponto.

@export var enemy_id := "zumbi": set = _set_id
@export var count := 1
@export var scatter := 1.0   ## dispersão em tiles

func _set_id(v: String) -> void:
	enemy_id = v
	queue_redraw()

func _draw() -> void:
	if not Engine.is_editor_hint():
		return
	draw_circle(Vector2.ZERO, 10, Color(0.9, 0.3, 0.2, 0.6))
	draw_string(ThemeDB.fallback_font, Vector2(-30, -14), "%s x%d" % [enemy_id, count], HORIZONTAL_ALIGNMENT_LEFT, -1, 14)
