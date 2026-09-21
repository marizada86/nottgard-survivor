class_name Items
extends RefCounted
## Itens estilo Diablo II: comum, mágico (1 afixo), raro (3 afixos) e único (do vault).

const RANK := {"comum": 0, "magico": 1, "raro": 2, "unico": 3}
const SLOTS := ["arma", "armadura", "amuleto", "anel"]

static func roll(rng: RandomNumberGenerator, tier: int, luck: float) -> Dictionary:
	var db: Dictionary = Data.table("items")
	var r := rng.randf() - luck * 0.01
	var unique_chance := 0.05 + tier * 0.02
	if r < unique_chance:
		var pool: Array = db.uniques.filter(func(u): return int(u.tier) <= tier + 1)
		if not pool.is_empty():
			return unique(pool[rng.randi() % pool.size()])
	var slot: String = SLOTS[rng.randi() % SLOTS.size()]
	var bases: Array = db.bases[slot]
	var base: Dictionary = bases[rng.randi() % bases.size()]
	var rare_chance := 0.22 + tier * 0.03
	var magic_chance := 0.5
	var rarity := "comum"
	var rr := rng.randf() - luck * 0.01
	if rr < rare_chance:
		rarity = "raro"
	elif rr < rare_chance + magic_chance:
		rarity = "magico"
	var mods := {}
	Hero.add_mods(mods, base.mods)
	var name_: String = base.name
	var n_aff := 0 if rarity == "comum" else (1 if rarity == "magico" else 3)
	var used: Array = []
	var pre := ""
	var suf := ""
	for i in n_aff:
		var af: Dictionary = db.affixes[rng.randi() % db.affixes.size()]
		if af in used:
			continue
		used.append(af)
		for k in af.mods:
			var lo: float = float(af.mods[k][0])
			var hi: float = float(af.mods[k][1]) + tier * 0.1 * (hi_scale(k))
			mods[k] = float(mods.get(k, 0.0)) + snappedf(rng.randf_range(lo, hi), 0.01 if hi < 2.0 else 1.0)
		if af.pos == "pre" and pre == "":
			pre = af.n
		elif suf == "":
			suf = af.n
	if pre != "":
		name_ = "%s %s" % [name_, pre]
	if suf != "":
		name_ = "%s %s" % [name_, suf]
	return {"id": "%s_%s" % [base.id, rarity], "base": base.id, "name": name_, "slot": slot, "rarity": rarity, "mods": mods}

static func hi_scale(k: String) -> float:
	return 1.0 if k in ["dmg_pct", "speed_pct", "cd_pct", "area_pct", "gold_pct", "xp_pct"] else 0.0

static func unique(u: Dictionary) -> Dictionary:
	return {"id": u.id, "name": u.name, "slot": u.slot, "rarity": "unico", "mods": u.mods.duplicate(), "weapon": u.get("weapon", ""), "note": u.get("note", "")}

static func rarity_color(r: String) -> Color:
	match r:
		"magico": return Color(0.45, 0.6, 1.0)
		"raro": return Color(1.0, 0.9, 0.3)
		"unico": return Color(1.0, 0.55, 0.15)
	return Color(0.85, 0.85, 0.85)

static func mods_text(mods: Dictionary) -> String:
	var parts: Array = []
	var labels := {"dmg_pct": "dano", "speed_pct": "velocidade", "cd_pct": "recarga", "area_pct": "área", "gold_pct": "moedas", "xp_pct": "XP",
		"hp": "PV", "regen": "PV/s", "ca": "CA", "cam": "CAM", "hit": "precisão", "pickup": "coleta", "dr": "redução", "forca": "FOR", "inteligencia": "INT",
		"constituicao": "CON", "carisma": "CAR", "crit_range": "crítico", "dodge": "esquiva"}
	for k in mods:
		var v: float = float(mods[k])
		var lab: String = labels.get(k, k)
		if k.ends_with("_pct") or k == "dodge":
			parts.append("%+d%% %s" % [int(round(v * 100.0)), lab])
		elif absf(v) < 2.0 and v != floorf(v):
			parts.append("%+.1f %s" % [v, lab])
		else:
			parts.append("%+d %s" % [int(v), lab])
	return ", ".join(parts)
