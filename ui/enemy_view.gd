extends Node2D
## Visual placeholder de um inimigo (criado em runtime, um por Enemy).

var enemy: Enemy

func setup(e: Enemy) -> void:
	enemy = e
	position = Iso.to_screen(e.pos)

func _draw() -> void:
	if enemy == null:
		return
	draw_colored_polygon(PackedVector2Array([Vector2(0, -6), Vector2(12, 0), Vector2(0, 6), Vector2(-12, 0)]), Color(0, 0, 0, 0.5))
	draw_rect(Rect2(-8, -34, 16, 34), enemy.color)
	draw_circle(Vector2(0, -39), 7, enemy.color.lightened(0.2))
	var frac := clampf(float(enemy.hp) / enemy.max_hp, 0.0, 1.0)
	draw_rect(Rect2(-12, -56, 24, 3), Color(0.15, 0, 0))
	draw_rect(Rect2(-12, -56, 24 * frac, 3), Color(0.7, 0.1, 0.1))
