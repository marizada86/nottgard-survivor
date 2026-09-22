class_name Enemy
extends RefCounted

var id := ""
var name := ""
var pos := Vector2.ZERO
var hp := 1.0
var max_hp := 1.0
var ca := 10
var cam := 10
var atk_dice := "1d6"
var atk_bonus := 0
var xp := 0
var speed := 1.0
var radius := 0.3
var color := Color.WHITE
var scale := 1.0
var move := "chase"
var keep := 5.0
var abilities: Array = []
var resist := {}
var flags: Array = []
var split_id := ""
var note := ""

var atk_cd := 0.0
var ab_cd: Array = []      # cooldown por habilidade
var stun_t := 0.0
var slow_t := 0.0
var burn_t := 0.0
var burn_dps := 0.0
var mark_t := 0.0
var mark := 0.0
var windup := 0.0          # investida armada
var charge_t := 0.0
var charge_dir := Vector2.ZERO
var charge_ab: Dictionary = {}
var affix := ""
var dead := false
var drops_chest := false
var hit_flash := 0.0
var charmed_t := 0.0
var phase_index := 0
var phase_defs: Array = []

static func make(enemy_id: String, at: Vector2, minute: float = 0.0, hp_mult: float = 1.0, tier: int = 0) -> Enemy:
	var d: Dictionary = Data.table("enemies")[enemy_id]
	var e := Enemy.new()
	e.id = enemy_id
	e.name = d.name
	e.pos = at
	var scale_hp: float = hp_mult * (1.0 + 0.10 * minute)
	e.max_hp = maxf(1.0, round(float(d.hp) * scale_hp))
	e.hp = e.max_hp
	e.ca = int(d.ca)
	e.cam = int(d.cam)
	e.atk_dice = d.atk
	e.atk_bonus = int(d.bonus) + int(minute / 4.0) + tier
	e.xp = int(d.xp)
	e.speed = float(d.speed)
	e.radius = float(d.radius)
	e.color = Color(float(d.color[0]) / 255.0, float(d.color[1]) / 255.0, float(d.color[2]) / 255.0)
	e.scale = float(d.get("scale", 1.0))
	e.move = String(d.get("move", "chase"))
	e.keep = float(d.get("keep", 5.0))
	e.abilities = d.get("abilities", [])
	e.resist = d.get("resist", {})
	e.flags = d.get("flags", [])
	e.split_id = String(d.get("split", ""))
	e.note = String(d.get("note", ""))
	e.phase_defs = Data.table("boss_phases").get(enemy_id, []).duplicate(true)
	for a in e.abilities:
		e.ab_cd.append(float(a.cd) * 0.5 + 1.0)
	return e

func has_flag(f: String) -> bool:
	return f in flags

func is_boss() -> bool:
	return "boss" in flags
