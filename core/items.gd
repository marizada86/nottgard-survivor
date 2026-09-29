class_name Items
extends RefCounted
## Itens estilo Diablo II: comum, mágico (1 afixo), raro (3 afixos) e único (do vault).

const RANK := {"comum": 0, "magico": 1, "raro": 2, "unico": 3}
const SLOTS := ["arma", "armadura", "amuleto", "anel"]
const MAX_LEVEL := 3
const LEVEL_SCALE_STEP := 0.15  ## +15% nos mods do item por nível acima de 1

## Bônus fixo de nível máximo da base do item; {} para itens sem base (únicos).
static func super_mods(item: Dictionary) -> Dictionary:
	var base_id: String = item.get("base", "")
	if base_id == "":
		return {}
	var slot: String = item.get("slot", "")
	var bases: Array = Data.table("items").bases.get(slot, [])
	for b in bases:
		if b.id == base_id:
			return b.get("super", {})
	return {}

## Multiplicador aplicado aos mods do item ao agregar em Hero.mods.
static func level_scale(item: Dictionary) -> float:
	return 1.0 + LEVEL_SCALE_STEP * float(int(item.get("level", 1)) - 1)

## Mods do item já multiplicados pela escala de um nível (para prévia e ficha).
static func scaled_mods(item: Dictionary, level: int) -> Dictionary:
	var scale := 1.0 + LEVEL_SCALE_STEP * float(level - 1)
	var out := {}
	for k in item.get("mods", {}):
		out[k] = float(item.mods[k]) * scale
	return out

## Diferença entre dois conjuntos de mods (novo menos atual), só chaves que mudam.
static func diff_mods(new_mods: Dictionary, old_mods: Dictionary) -> Dictionary:
	var out := {}
	for k in new_mods:
		var d := float(new_mods[k]) - float(old_mods.get(k, 0.0))
		if absf(d) >= 0.05:
			out[k] = d
	for k in old_mods:
		if not new_mods.has(k) and absf(float(old_mods[k])) >= 0.05:
			out[k] = -float(old_mods[k])
	return out

## MEC-019: texto de comparação ("+5 CA, -3 CAM") de um item novo contra o equipado.
static func compare_text(new_mods: Dictionary, old_mods: Dictionary) -> String:
	var d := diff_mods(new_mods, old_mods)
	return "sem diferença nos atributos" if d.is_empty() else mods_text(d)

## Prévia do ferreiro: mostra o que o item dá agora e o que dará no próximo nível.
static func upgrade_preview(item: Dictionary) -> String:
	var lvl := int(item.get("level", 1))
	var now := scaled_mods(item, lvl)
	var next := scaled_mods(item, lvl + 1)
	return "Nv %d: %s\n      Nv %d: %s\n      Ganho: %s" % [lvl,mods_text(now), lvl + 1, mods_text(next), compare_text(next, now)]

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
	return {"id": "%s_%s" % [base.id, rarity], "base": base.id, "name": name_, "slot": slot, "rarity": rarity, "mods": mods, "level": 1}

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
		"hp": "PV", "regen": "PV/s", "ca": "CA", "cam": "CAM", "hit": "precisão", "pickup": "coleta", "dr": "redução de dano", "forca": "FOR", "inteligencia": "INT",
		"constituicao": "CON", "carisma": "CAR", "crit_overflow_bonus": "crítico", "crit_overflow_step": "crítico/2 níveis", "dodge": "esquiva"}
	for k in mods:
		var v: float = float(mods[k])
		var lab: String = labels.get(k, k)
		if k.ends_with("_pct") or k in ["dodge", "crit_overflow_bonus"]:
			parts.append("%+d%% %s" % [int(round(v * 100.0)), lab])
		elif absf(v) < 10.0 and absf(v - roundf(v)) > 0.05:
			parts.append("%+.1f %s" % [v, lab])
		else:
			parts.append("%+d %s" % [int(roundf(v)), lab])
	return ", ".join(parts)
