class_name Hero
extends RefCounted
## Herói no plano de chão. Sem nós: testável headless.

const SPEED_PX := 220.0   # velocidade visual constante, em pixels de tela
const RADIUS := 0.3       # tiles

var pos := Vector2.ZERO
var map_size := Vector2(40, 40)
var blockers: Array = []  # Array[Vector3]: x, y, raio (tiles)

var id := ""
var name := ""
var attrs := {}
var hp := 1
var max_hp := 1
var ca := 10
var cam := 10
var prof := 2
var weapon_dice := "1d8"
var attack_cd := 1.2
var attack_range := 1.8
var skill_cd := 6.0
var skill_range := 2.5
var atk_timer := 0.0
var skill_timer := 0.0
var xp := 0
var dead := false

static func make(hero_id: String) -> Hero:
	var d: Dictionary = Data.table("heroes")[hero_id]
	var h := Hero.new()
	h.id = hero_id
	h.name = d.name
	for k in d.attrs:
		h.attrs[k] = int(d.attrs[k])
	h.max_hp = int(d.base_hp) + Dice.mod(h.attrs.constituicao) * 2
	h.hp = h.max_hp
	h.ca = 10 + int(d.armor.ca)
	h.cam = 10 + int(d.armor.cam)
	h.prof = int(d.prof)
	h.weapon_dice = d.weapon_dice
	h.attack_cd = float(d.attack_cd)
	h.attack_range = float(d.attack_range)
	h.skill_cd = float(d.skill_cd)
	h.skill_range = float(d.skill_range)
	return h

func hit_bonus() -> int:
	return prof + Dice.mod(int(attrs.forca))

func dmg_bonus() -> int:
	return Dice.mod(int(attrs.forca))

func step(screen_dir: Vector2, dt: float) -> void:
	if screen_dir == Vector2.ZERO or dead:
		return
	var delta := Iso.to_ground(screen_dir.normalized() * SPEED_PX * dt)
	var nx := Vector2(pos.x + delta.x, pos.y)
	if is_free(nx):
		pos = nx
	var ny := Vector2(pos.x, pos.y + delta.y)
	if is_free(ny):
		pos = ny

func is_free(p: Vector2, r: float = RADIUS) -> bool:
	if p.x < r or p.y < r or p.x > map_size.x - r or p.y > map_size.y - r:
		return false
	for b in blockers:
		if p.distance_to(Vector2(b.x, b.y)) < b.z + r:
			return false
	return true
