@tool
extends Node2D
## Ponto de spawn inicial. Escolha o inimigo (id de data/enemies.json) e a quantidade no Inspector.
## Posição do nó em pixels de tela. No jogo, `count` inimigos nascem espalhados perto do ponto.

@export var enemy_id := "zumbi": set = _set_id
@export var count := 1: set = _set_count
@export var scatter := 1.0   ## dispersão em tiles

func _set_id(v: String) -> void:
	enemy_id = v
	queue_redraw()

func _set_count(v: int) -> void:
	count = maxi(1, v)
	queue_redraw()

func _draw() -> void:
	if not Engine.is_editor_hint():
		return
	var path := "res://assets/enemies/%s.png" % enemy_id
	if ResourceLoader.exists(path):
		var texture: Texture2D = load(path)
		var height := 54.0
		var width := height * float(texture.get_width()) / float(texture.get_height())
		draw_texture_rect(texture, Rect2(-width * 0.5, -height, width, height), false, Color(1, 1, 1, 0.72))
	draw_circle(Vector2.ZERO, 10, Color(0.9, 0.3, 0.2, 0.6))
	draw_string(ThemeDB.fallback_font, Vector2(-48, -62), "%s x%d" % [enemy_id, count], HORIZONTAL_ALIGNMENT_CENTER, 96, 14, Color.WHITE)
