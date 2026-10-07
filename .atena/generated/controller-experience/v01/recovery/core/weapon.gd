class_name Weapon
extends RefCounted
## Arma equipada na run: definição base + deltas por nível.

const MAX_LEVEL := 5

var id := ""
var level := 1
var timer := 0.0
var def: Dictionary
var granted := false   # veio de um item (não ocupa slot)

static func make(weapon_id: String, lvl: int = 1) -> Weapon:
	var w := Weapon.new()
	w.id = weapon_id
	w.def = Data.table("weapons")[weapon_id]
	w.level = lvl
	w.timer = 0.4
	return w

func max_level() -> int:
	return MAX_LEVEL if not def.get("levels", []).is_empty() else 1

## Parâmetros efetivos no nível atual.
func params() -> Dictionary:
	var p: Dictionary = def.duplicate()
	var lv: Array = def.get("levels", [])
	for i in mini(level - 1, lv.size()):
		for k in lv[i]:
			if k == "dice":
				p["dice"] = lv[i][k]
			else:
				p[k] = float(p.get(k, 0.0)) + float(lv[i][k])
	return p

func can_evolve() -> bool:
	return def.has("evolve") and level >= MAX_LEVEL

func display_name() -> String:
	return "%s %s" % [String(def.name), ("Nv %d" % level) if max_level() > 1 else "★"]
