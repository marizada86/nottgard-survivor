class_name Hero
extends RefCounted
## Herói no plano de chão. Sem nós: testável headless.

const SPEED_PX := 190.0   # velocidade visual base, em pixels de tela
const RADIUS := 0.3       # tiles

var pos := Vector2.ZERO
var map_size := Vector2(40, 40)
var blockers: Array = []  # Array[Vector3]: x, y, raio (tiles)

var id := ""
var name := ""
var base_attrs := {}
var base_hp := 30
var prof := 2
var base_ca := 10
var base_cam := 10
var hero_mods := {}
var meta_mods := {}
var bonus_mods := {}      # conquistas
var passives := {}        # id -> nível
var items := {}           # slot -> item
var boons: Array = []
var weapons: Array = []   # Array[Weapon]
var mods := {}

var hp := 1.0
var max_hp := 1.0
var level := 1
var xp := 0.0
var xp_need := 30
var gold := 0
var dead := false
var slow_t := 0.0
var stun_t := 0.0
var push := Vector2.ZERO  # empurrão externo (tiles/s)
var hit_flash := 0.0

static func make(hero_id: String, meta: Dictionary = {}, bonus: Dictionary = {}) -> Hero:
	var d: Dictionary = Data.table("heroes")[hero_id]
	var h := Hero.new()
	h.id = hero_id
	h.name = d.name
	for k in d.attrs:
		h.base_attrs[k] = int(d.attrs[k])
	h.base_hp = int(d.base_hp)
	h.prof = int(d.prof)
	h.base_ca = 10 + int(d.armor.ca)
	h.base_cam = 10 + int(d.armor.cam)
	h.hero_mods = d.passive.mods
	h.meta_mods = meta
	h.bonus_mods = bonus
	h.recalc()
	h.hp = h.max_hp
	return h

static func add_mods(into: Dictionary, src: Dictionary, times: float = 1.0) -> void:
	for k in src:
		into[k] = float(into.get(k, 0.0)) + float(src[k]) * times

func recalc() -> void:
	var m := {}
	add_mods(m, hero_mods)
	add_mods(m, meta_mods)
	add_mods(m, bonus_mods)
	var pdata: Dictionary = Data.table("passives")
	for pid in passives:
		add_mods(m, pdata[pid].mods, float(passives[pid]))
	for slot in items:
		add_mods(m, items[slot].mods)
	for b in boons:
		add_mods(m, b.mods)
	mods = m
	var old_max := max_hp
	max_hp = maxf(10.0, float(base_hp) + attr_mod("constituicao") * 2.0 + float(m.get("hp", 0.0)))
	if old_max > 1.0 and max_hp > old_max:
		hp += max_hp - old_max
	hp = minf(hp, max_hp)

func m(key: String) -> float:
	return float(mods.get(key, 0.0))

func attr(name_: String) -> int:
	return int(base_attrs.get(name_, 10)) + int(m(name_))

func attr_mod(name_: String) -> int:
	return Dice.mod(attr(name_))

func ca() -> int:
	return base_ca + int(m("ca"))

func cam() -> int:
	return base_cam + int(m("cam"))

func crit_range() -> int:
	var r := int(m("crit_range"))
	if m("crit_step") > 0.0:
		r += int((m("crit_step") + 1.0) / 2.0)
	return mini(r, 6)

func speed_px() -> float:
	var f := 1.0 + m("speed_pct")
	if slow_t > 0.0:
		f *= 0.6
	return SPEED_PX * clampf(f, 0.4, 2.0)

static func movement_input(left: bool, right: bool, up: bool, down: bool) -> Vector2:
	return Vector2(int(right) - int(left), int(down) - int(up))

func pickup_range() -> float:
	return 1.4 + m("pickup") + attr_mod("carisma") * 0.1

func weapon_slots() -> int:
	return 4 + int(m("weapon_slots"))

func step(screen_dir: Vector2, dt: float) -> void:
	if dead:
		return
	slow_t = maxf(0.0, slow_t - dt)
	stun_t = maxf(0.0, stun_t - dt)
	hit_flash = maxf(0.0, hit_flash - dt)
	var delta := Vector2.ZERO
	if screen_dir != Vector2.ZERO and stun_t <= 0.0:
		delta += Iso.to_ground(screen_dir.normalized() * speed_px() * dt)
	delta += push * dt
	if delta == Vector2.ZERO:
		return
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
