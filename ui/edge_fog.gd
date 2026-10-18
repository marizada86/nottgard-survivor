class_name EdgeFog
extends Node2D
## SPEC-158 (MEC-059): faixa de névoa junto às bordas do mapa, desenhada no mundo (losango isométrico).
## Gradiente de névoa: forte na borda, leve no limite interno da faixa (onde o dano começa); por cima, a faixa rasteira NB01 (SPEC-185).
## Só aparece quando o herói se aproxima (proximity 0..1, vinda de Battle.edge_proximity).

const Z_INDEX := -80   # acima do chão (-100) e dos decais (-90), abaixo dos sprites (y-sort em 0)
const MAX_ALPHA := 0.62
const INNER_ALPHA := 0.16
const TINT := Color(0.34, 0.62, 0.46)   # mesmo verde da Maré de Dagruve (run.gd)
const TEXTURE_PATH := "res://assets/fx/nevoa_mundo_borda_01.png"   # SPEC-185 (FILA-030 NB01): faixa rasteira, base densa embaixo e 128 px superiores transparentes
const TEXTURE_SCREEN_WIDTH := 768.0   # largura na tela de uma repetição (a fonte tem 1536 px)
const TEXTURE_DEPTH_FACTOR := 2.4   # a faixa rasteira entra 2,4 vezes a profundidade da faixa de dano
const TEXTURE_ALPHA := 0.55            # sobre o gradiente, que segue marcando o limite do dano

var _texture: Texture2D

var map_size := Vector2(60, 60)
var band := 3.0
var proximity := 0.0: set = _set_proximity

func _ready() -> void:
	z_index = Z_INDEX
	texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	_texture = load(TEXTURE_PATH) if ResourceLoader.exists(TEXTURE_PATH) else null
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
	if _texture != null:
		# a névoa rasteira entra por cima do gradiente e mais fundo que a faixa de dano (TEXTURE_DEPTH_FACTOR): base densa na borda do mapa, rarefeita para dentro; u repete ao longo da borda
		var tint := Color(TINT.r, TINT.g, TINT.b, TEXTURE_ALPHA * proximity)
		for quad in strips(map_size, band * TEXTURE_DEPTH_FACTOR):
			var pts := PackedVector2Array()
			for p in quad:
				pts.append(Iso.to_screen(p))
			var u := pts[0].distance_to(pts[1]) / TEXTURE_SCREEN_WIDTH
			draw_polygon(pts, PackedColorArray([tint, tint, tint, tint]), PackedVector2Array([Vector2(0, 1), Vector2(u, 1), Vector2(u, 0), Vector2(0, 0)]), _texture)
