class_name Enemy
extends RefCounted

var id := ""
var name := ""
var pos := Vector2.ZERO
var hp := 1
var max_hp := 1
var ca := 10
var cam := 10
var atk_dice := "1d6"
var atk_bonus := 0
var xp := 0
var speed := 1.0
var radius := 0.3
var color := Color.WHITE
var atk_cd := 0.0
var dead := false

static func make(enemy_id: String, at: Vector2) -> Enemy:
	var d: Dictionary = Data.table("enemies")[enemy_id]
	var e := Enemy.new()
	e.id = enemy_id
	e.name = d.name
	e.pos = at
	e.hp = int(d.hp)
	e.max_hp = e.hp
	e.ca = int(d.ca)
	e.cam = int(d.cam)
	e.atk_dice = d.atk_dice
	e.atk_bonus = int(d.atk_bonus)
	e.xp = int(d.xp)
	e.speed = float(d.speed)
	e.radius = float(d.radius)
	e.color = Color(d.color[0], d.color[1], d.color[2])
	return e
