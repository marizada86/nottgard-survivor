class_name EdgeFog
extends Node2D
## SPEC-158 (MEC-059): faixa de névoa junto às bordas do mapa, desenhada no mundo (losango isométrico).
## Gradiente de névoa sem textura nova: forte na borda, leve no limite interno da faixa (onde o dano começa).
## Só aparece quando o herói se aproxima (proximity 0..1, vinda de Battle.edge_proximity).

const Z_INDEX := -80   # acima do chão (-100) e dos decais (-90), abaixo dos sprites (y-sort em 0)
const MAX_ALPHA := 0.62
const INNER_ALPHA := 0.16
const TINT := Color(0.34, 0.62, 0.46)   # mesmo verde da Maré de Dagruve (run.gd)

var map_size := Vector2(60, 60)
var band := 3.0
var proximity := 0.0: set = _set_proximity

func _ready() -> void:
	z_index = Z_INDEX
	queue_redraw()

func _set_proximity(v: float) -> void:
	v = clampf(v, 0.0, 1.0)
	if absf(v - proximity) < 0.02 and (v > 0.0) == (proximity > 0.0):
		return
	proximity = v
	queue_redraw()

## Os quatro trapézios de canto a canto (sem sobreposição), em tiles: cada um com 2 vértices na borda e 2 no limite interno.
static func strips(size: Vector2, width: float) -> Array:
	var b := minf(width, minf(size.x, size.y) * 0.5)
	return [
		[Vector2(0, 0), Vector2(size.x, 0), Vector2(size.x - b, b), Vector2(b, b)],
		[Vector2(size.x, 0), Vector2(size.x, size.y), Vector2(size.x - b, size.y - b), Vector2(size.x - b, b)],
		[Vector2(size.x, size.y), Vector2(0, size.y), Vector2(b, size.y - b), Vector2(size.x - b, size.y - b)],
		[Vector2(0, size.y), Vector2(0, 0), Vector2(b, b), Vector2(b, size.y - b)],
	]

func _draw() -> void:
	if proximity <= 0.0:
		return
	var outer := Color(TINT.r, TINT.g, TINT.b, MAX_ALPHA * proximity)
	var inner := Color(TINT.r, TINT.g, TINT.b, INNER_ALPHA * proximity)   # o limite da faixa fica legível
	for quad in strips(map_size, band):
		var pts := PackedVector2Array()
		for p in quad:
			pts.append(Iso.to_screen(p))
		draw_polygon(pts, PackedColorArray([outer, outer, inner, inner]))
