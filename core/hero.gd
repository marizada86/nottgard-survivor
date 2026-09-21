class_name Hero
extends RefCounted
## Herói no plano de chão. Sem nós: testável headless.

const SPEED_PX := 220.0   # velocidade visual constante, em pixels de tela
const RADIUS := 0.3       # tiles

var pos := Vector2.ZERO
var map_size := Vector2(40, 40)
var blockers: Array = []  # Array[Vector3]: x, y, raio (tiles)

func step(screen_dir: Vector2, dt: float) -> void:
	if screen_dir == Vector2.ZERO:
		return
	var delta := Iso.to_ground(screen_dir.normalized() * SPEED_PX * dt)
	# eixos separados: desliza em vez de travar
	var nx := Vector2(pos.x + delta.x, pos.y)
	if _free(nx):
		pos = nx
	var ny := Vector2(pos.x, pos.y + delta.y)
	if _free(ny):
		pos = ny

func _free(p: Vector2) -> bool:
	if p.x < RADIUS or p.y < RADIUS or p.x > map_size.x - RADIUS or p.y > map_size.y - RADIUS:
		return false
	for b in blockers:
		if p.distance_to(Vector2(b.x, b.y)) < b.z + RADIUS:
			return false
	return true
