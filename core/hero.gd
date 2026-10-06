class_name Hero
extends RefCounted
## Herói no plano de chão. Sem nós: testável headless.

const TerrainLayout := preload("res://core/terrain_layout.gd")

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
var temp_mods := {}       # bênção temporária (ritual); vale enquanto temp_t > 0
var temp_t := 0.0
var kind_buffs := {}      # SPEC-129: bônus temporários das bênçãos de família (id -> {"mods": {}, "t": s}); vale enquanto t > 0
var passives := {}        # id -> nível
var items := {}           # slot -> item
var boons: Array = []
var weapons: Array = []   # Array[Weapon]
var synergies := {}       # id da arma evoluída -> true (SPEC-075)
var descent_depth := 0
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
## Efeitos exclusivos da run no Estige. Nunca alteram a ficha persistente.
var terrain_id := ""
var styx_lucidity_loss := 0
var styx_forget_t := 0.0

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
	if temp_t > 0.0:
		add_mods(m, temp_mods)
	for kb in kind_buffs.values():
		if float(kb.t) > 0.0:
			add_mods(m, kb.mods)
	var pdata: Dictionary = Data.table("passives")
	for pid in passives:
		add_mods(m, pdata[pid].mods, float(passives[pid]))
	for slot in items:
		var it: Dictionary = items[slot]
		add_mods(m, it.mods, Items.level_scale(it))
		if int(it.get("level", 1)) >= Items.MAX_LEVEL:
			add_mods(m, Items.super_mods(it))
	if not synergies.is_empty():
		var wdata: Dictionary = Data.table("weapons")
		for wid in synergies:
			var syn: Dictionary = wdata.get(wid, {}).get("synergy", {})
			if not syn.is_empty():
				add_mods(m, syn.bonus_per_depth, float(maxi(1, descent_depth)))
	for b in boons:
		add_mods(m, b.mods)
	mods = m
	var old_max := max_hp
	max_hp = maxf(10.0, float(base_hp) + attr_mod("constituicao") * 2.0 + float(m.get("hp", 0.0)) + level_growth_hp())
	if old_max > 1.0 and max_hp > old_max:
		hp += max_hp - old_max
	hp = minf(hp, max_hp)

## MEC-014: a partir de start_level cada nível dá PV fixos, para o herói não estagnar na fase tardia (dados em data/difficulty.json).
func level_growth_hp() -> float:
	var g: Dictionary = Data.table("difficulty").get("level_growth", {})
	return float(maxi(0, level - int(g.get("start_level", 999)) + 1)) * float(g.get("hp_per_level", 0.0))

## SPEC-129: aplica (ou renova) um bônus temporário de uma bênção de família.
func set_kind_buff(id: String, buff_mods: Dictionary, seconds: float) -> void:
	kind_buffs[id] = {"mods": buff_mods.duplicate(), "t": seconds}
	recalc()

func m(key: String) -> float:
	return float(mods.get(key, 0.0))

func attr(name_: String) -> int:
	return int(base_attrs.get(name_, 10)) + int(m(name_))

func attr_mod(name_: String) -> int:
	return Dice.mod(attr(name_))

func styx_intelligence() -> int:
	return maxi(1, attr("inteligencia") - styx_lucidity_loss)

func styx_intelligence_mod() -> int:
	return Dice.mod(styx_intelligence())

func ca() -> int:
	return base_ca + int(m("ca"))

func cam() -> int:
	return base_cam + int(m("cam"))

func typed_evasion(dtype: String) -> float:
	var defense := ca() if dtype == "fisico" else cam()
	return clampf(float(defense - 10) * 0.03, 0.0, 0.30)

func evasion(dtype: String, precision: int = 0) -> float:
	# Precisão reduz apenas a parcela tipada; esquiva genérica continua útil.
	var typed := maxf(0.0, typed_evasion(dtype) - float(precision) * 0.01)
	var generic := clampf(m("dodge"), 0.0, 0.45)
	return minf(0.45, 1.0 - (1.0 - typed) * (1.0 - generic))

func crit_overflow_bonus() -> float:
	var bonus := m("crit_overflow_bonus")
	if m("crit_overflow_step") > 0.0:
		bonus += float(int((m("crit_overflow_step") + 1.0) / 2.0)) * 0.03
	return minf(0.40, bonus)

func crit_chance(attack_total: int) -> float:
	return minf(0.40, maxf(0.0, float(attack_total - 20) * 0.03) + crit_overflow_bonus())

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
	if temp_t > 0.0:
		temp_t = maxf(0.0, temp_t - dt)
		if temp_t <= 0.0:
			temp_mods = {}
			recalc()
	if not kind_buffs.is_empty():
		var expired := false
		for id in kind_buffs.keys():
			kind_buffs[id].t = maxf(0.0, float(kind_buffs[id].t) - dt)
			if float(kind_buffs[id].t) <= 0.0:
				kind_buffs.erase(id)
				expired = true
		if expired:
			recalc()
	slow_t = maxf(0.0, slow_t - dt)
	stun_t = maxf(0.0, stun_t - dt)
	styx_forget_t = maxf(0.0, styx_forget_t - dt)
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
	if not can_stand(p, r):
		return false
	if styx_forget_t > 0.0 and TerrainLayout.distance_to_styx(terrain_id, p) < TerrainLayout.distance_to_styx(terrain_id, pos):
		return false
	return true

## Só geometria (mapa, montanhas, objetos). Inimigos usam esta: o Esquecimento do Estige é restrição do herói (BUG-012).
func can_stand(p: Vector2, r: float = RADIUS) -> bool:
	if p.x < r or p.y < r or p.x > map_size.x - r or p.y > map_size.y - r:
		return false
	if TerrainLayout.is_blocked(terrain_id, p):
		return false
	for b in blockers:
		if p.distance_to(Vector2(b.x, b.y)) < b.z + r:
			return false
	return true
