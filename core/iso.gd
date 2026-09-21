class_name Iso
extends RefCounted
## Projeção isométrica 2:1. Chão em tiles (x,y); tela em pixels.

const TILE_W := 64.0
const TILE_H := 32.0

static func to_screen(g: Vector2) -> Vector2:
	return Vector2((g.x - g.y) * TILE_W * 0.5, (g.x + g.y) * TILE_H * 0.5)

static func to_ground(s: Vector2) -> Vector2:
	return Vector2(s.x / TILE_W + s.y / TILE_H, s.y / TILE_H - s.x / TILE_W)
