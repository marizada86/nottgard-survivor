extends SceneTree
## DPS esperado das armas iniciais por herói (SPEC-122 B-003), alvo único, sem crítico, nível 1 e 5 da arma:
##   godot --headless --path . -s tools/bal_armas.gd
## Saída: "ARMA;heroi;arma;kind;dps_nv1;dps_nv5;area" (area = raio/cone/pierce/count que multiplicam alvos)

func _dps(b: Battle, w: Weapon) -> float:
	var p := w.params()
	var flat := b.hero.attr_mod(String(p.get("attr", "forca"))) + int(p.get("dmg", 0)) + int(b.hero.m("dmg_flat"))
	var avg := Dice.avg(String(p.get("dice", "1d4"))) + flat
	var n := maxf(1.0, float(p.get("count", 1)))
	return avg * n / maxf(0.1, float(p.get("cd", 1.0)) * (1.0 - b.hero.m("cd_pct")))

func _init() -> void:
	var heroes: Dictionary = Data.table("heroes")
	for id in heroes:
		var b := Battle.new(1, String(id), "dagruve")
		var w1: Weapon = b.hero.weapons[0]
		var w5 := Weapon.make(w1.id, 5)
		var p := w1.params()
		var area := "r%.1f" % float(p.radius) if p.has("radius") else ("c%d" % int(p.get("cone", 0)) if p.has("cone") else "p%d" % int(p.get("pierce", 0)))
		print("ARMA;%s;%s;%s;%.2f;%.2f;%s" % [id, w1.id, p.kind, _dps(b, w1), _dps(b, w5), area])
	quit()
