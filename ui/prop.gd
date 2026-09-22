@tool
extends Node2D
## Objeto de cenário que bloqueia movimento (grupo "blockers"). A posição do nó é em pixels de tela;
## o chão é derivado por Iso.to_ground(position). Mova/duplique no editor à vontade.

@export_enum("pilar", "cogumelo", "bolha", "rocha", "torii", "cristal", "cachoeira", "pilar_abissal") var kind := "pilar": set = _set_kind
@export var height := 60.0: set = _set_height
@export var half_width := 22.0: set = _set_hw
@export var block_radius := 0.4   ## raio de colisão em tiles
@export var color := Color(0.24, 0.22, 0.24): set = _set_color
var _texture: Texture2D
var _texture_path := ""

func _ready() -> void:
	add_to_group("blockers")

func _set_kind(v: String) -> void:
	kind = v
	queue_redraw()

func _set_height(v: float) -> void:
	height = v
	queue_redraw()

func _set_hw(v: float) -> void:
	half_width = v
	queue_redraw()

func _set_color(v: Color) -> void:
	color = v
	queue_redraw()

func _diamond(c: Vector2, hw: float, hh: float) -> PackedVector2Array:
	return PackedVector2Array([c + Vector2(0, -hh), c + Vector2(hw, 0), c + Vector2(0, hh), c + Vector2(-hw, 0)])

func _ellipse(c: Vector2, rx: float, ry: float, n: int = 20) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in n:
		var a := TAU * i / n
		pts.append(c + Vector2(cos(a) * rx, sin(a) * ry))
	return pts

func _prop_texture() -> Texture2D:
	var seed_value := absi(int(round(position.x / 32.0)) * 31 + int(round(position.y / 16.0)) * 17)
	var variant := seed_value % 3 + 1
	var path := "res://assets/props/%s_%02d.png" % [kind, variant]
	if path != _texture_path:
		_texture_path = path
		_texture = load(path) if ResourceLoader.exists(path) else null
	return _texture

func _draw() -> void:
	var w := half_width
	draw_colored_polygon(_ellipse(Vector2.ZERO, w * 1.05, w * 0.5), Color(0, 0, 0, 0.35))
	var texture := _prop_texture()
	if texture != null:
		var target_h := maxf(42.0, height + w * 0.8)
		var target_w := target_h * float(texture.get_width()) / float(texture.get_height())
		draw_texture_rect(texture, Rect2(-target_w * 0.5, -target_h, target_w, target_h), false)
		return
	match kind:
		"cogumelo":
			draw_rect(Rect2(-w * 0.3, -height, w * 0.6, height), color.darkened(0.35))
			draw_colored_polygon(_ellipse(Vector2(0, -height), w * 1.1, w * 0.6), color)
			draw_colored_polygon(_ellipse(Vector2(0, -height - 4), w * 0.8, w * 0.35), color.lightened(0.18))
		"bolha":
			draw_colored_polygon(_ellipse(Vector2(0, -height * 0.5), w * 0.9, height * 0.5), Color(color, 0.75))
			draw_colored_polygon(_ellipse(Vector2(-w * 0.25, -height * 0.7), w * 0.25, height * 0.15), color.lightened(0.4))
		"rocha":
			var pts := PackedVector2Array([Vector2(-w, 0), Vector2(-w * 0.8, -height * 0.7), Vector2(-w * 0.2, -height), Vector2(w * 0.5, -height * 0.8), Vector2(w, -height * 0.2), Vector2(w * 0.7, 0)])
			draw_colored_polygon(pts, color)
			draw_colored_polygon(PackedVector2Array([Vector2(-w * 0.2, -height), Vector2(w * 0.5, -height * 0.8), Vector2(0, -height * 0.5)]), color.lightened(0.15))
		"torii":
			var post := w * 0.28
			draw_rect(Rect2(-w, -height, post, height), color)
			draw_rect(Rect2(w - post, -height, post, height), color)
			draw_rect(Rect2(-w * 1.25, -height, w * 2.5, post * 1.1), color.darkened(0.15))
			draw_rect(Rect2(-w * 1.05, -height * 0.78, w * 2.1, post * 0.7), color)
		"cristal":
			draw_colored_polygon(PackedVector2Array([Vector2(-w * 0.6, 0), Vector2(0, -height), Vector2(w * 0.6, 0), Vector2(0, w * 0.25)]), color)
			draw_colored_polygon(PackedVector2Array([Vector2(0, -height), Vector2(w * 0.6, 0), Vector2(0, w * 0.25)]), color.lightened(0.22))
		"cachoeira":
			draw_rect(Rect2(-w * 0.55, -height, w * 1.1, height), Color(color, 0.55))
			draw_rect(Rect2(-w * 0.2, -height, w * 0.4, height), Color(color.lightened(0.5), 0.7))
			draw_colored_polygon(_ellipse(Vector2.ZERO, w * 0.9, w * 0.4), Color(color.lightened(0.3), 0.5))
		"pilar_abissal":
			draw_colored_polygon(_diamond(Vector2.ZERO, w, w * 0.5), color.darkened(0.3))
			draw_rect(Rect2(-w, -height, w * 2, height), color)
			draw_colored_polygon(_diamond(Vector2(0, -height), w, w * 0.5), color.lightened(0.15))
			draw_rect(Rect2(-2, -height, 4, height), Color(0.75, 0.5, 1.0, 0.55))
		_:
			draw_colored_polygon(_diamond(Vector2.ZERO, w, w * 0.5), color.darkened(0.1))
			draw_rect(Rect2(-w, -height, w * 2, height), color)
			draw_colored_polygon(_diamond(Vector2(0, -height), w, w * 0.5), color.lightened(0.15))
