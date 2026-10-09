class_name Items
extends RefCounted
## Itens estilo Diablo II: comum, mágico (1 afixo), incomum (2 afixos), raro (3 afixos) e único (do vault, mods fixos + afixos sorteados).
## Chances por tier em data/difficulty.json (bloco "rarity").

const RANK := {"comum": 0, "magico": 1, "incomum": 2, "raro": 3, "unico": 4}
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
		if absf(d) >= mod_epsilon(k):
			out[k] = d
	for k in old_mods:
		if not new_mods.has(k) and absf(float(old_mods[k])) >= mod_epsilon(k):
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

## Chances de raridade no tier (SPEC-122 B-005). Valores em data/difficulty.json, bloco "rarity".
static func rarity_chances(tier: int) -> Dictionary:
	var c: Dictionary = Data.table("difficulty").get("rarity", {})
	return {
		"unico": float(c.get("unico_base", 0.05)) + tier * float(c.get("unico_per_tier", 0.02)),
		"raro": float(c.get("raro_base", 0.22)) + tier * float(c.get("raro_per_tier", 0.03)),
		"incomum": float(c.get("incomum_base", 0.0)) + tier * float(c.get("incomum_per_tier", 0.0)),
		"magico": float(c.get("magico", 0.5)),
	}

## Soma `n` afixos sorteados em `mods`; devolve [prefixo, sufixo] para o nome.
static func _roll_affixes(rng: RandomNumberGenerator, db: Dictionary, tier: int, n: int, mods: Dictionary) -> Array:
	var used: Array = []
	var pre := ""
	var suf := ""
	for i in n:
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
	return [pre, suf]

## `min_rarity` ("" = sem piso): baú do chefe garante pelo menos essa raridade (não vira único à força).
static func roll(rng: RandomNumberGenerator, tier: int, luck: float, min_rarity := "") -> Dictionary:
	var db: Dictionary = Data.table("items")
	var ch := rarity_chances(tier)
	var r := rng.randf() - luck * 0.01
	if r < float(ch.unico):
		var pool: Array = db.uniques.filter(func(u): return int(u.tier) <= tier)
		if not pool.is_empty():
			return unique(pool[rng.randi() % pool.size()], rng, tier)
	var slot: String = SLOTS[rng.randi() % SLOTS.size()]
	var bases: Array = db.bases[slot]
	var base: Dictionary = bases[rng.randi() % bases.size()]
	var rarity := "comum"
	var rr := rng.randf() - luck * 0.01
	if rr < float(ch.raro):
		rarity = "raro"
	elif rr < float(ch.raro) + float(ch.incomum):
		rarity = "incomum"
	elif rr < float(ch.raro) + float(ch.incomum) + float(ch.magico):
		rarity = "magico"
	if min_rarity != "" and int(RANK[rarity]) < int(RANK[min_rarity]):
		rarity = min_rarity
	var mods := {}
	Hero.add_mods(mods, base.mods)
	var name_: String = base.name
	var n_aff := {"comum": 0, "magico": 1, "incomum": 2, "raro": 3}.get(rarity, 0) as int
	var ps := _roll_affixes(rng, db, tier, n_aff, mods)
	if ps[0] != "":
		name_ = "%s %s" % [name_, ps[0]]
	if ps[1] != "":
		name_ = "%s %s" % [name_, ps[1]]
	return {"id": "%s_%s" % [base.id, rarity], "base": base.id, "name": name_, "slot": slot, "rarity": rarity, "mods": mods, "level": 1}

static func hi_scale(k: String) -> float:
	return 1.0 if k in ["dmg_pct", "speed_pct", "cd_pct", "area_pct", "gold_pct", "xp_pct"] else 0.0

## Único: mods fixos do vault. Com `rng`, soma `unique_extra_affixes` afixos sorteados (poder acima do raro do mesmo tier).
static func unique(u: Dictionary, rng: RandomNumberGenerator = null, tier := 0) -> Dictionary:
	var mods: Dictionary = u.mods.duplicate()
	if rng != null:
		var extra := int(Data.table("difficulty").get("rarity", {}).get("unique_extra_affixes", 0))
		_roll_affixes(rng, Data.table("items"), tier, extra, mods)
	return {"id": u.id, "name": u.name, "slot": u.slot, "rarity": "unico", "mods": mods, "weapon": u.get("weapon", ""), "note": u.get("note", "")}

const RARITY_LABELS := {"comum": "Comum", "magico": "Mágico", "incomum": "Incomum", "raro": "Raro", "unico": "Único"}

## Nome de exibição da raridade (acento e maiúscula), SPEC-122 E6.
static func rarity_label(r: String) -> String:
	return String(RARITY_LABELS.get(r, r.capitalize()))

## Preço em moedas por raridade (SPEC-122 E5): `kind` = "shop" (loja, antes do coin_mult) ou "sell" (venda). Tabela em data/difficulty.json, bloco "prices".
static func price(kind: String, r: String) -> float:
	var table: Dictionary = Data.table("difficulty").get("prices", {}).get(kind, {})
	var fallback := (16.0 + 8.0 * float(RANK.get(r, 0))) if kind == "shop" else 8.0 * (float(RANK.get(r, 0)) + 1.0)
	return float(table.get(r, fallback))

static func rarity_color(r: String) -> Color:
	match r:
		"magico": return Color(0.45, 0.6, 1.0)
		"incomum": return Color(0.4, 0.85, 0.45)
		"raro": return Color(1.0, 0.9, 0.3)
		"unico": return Color(1.0, 0.55, 0.15)
	return Color(0.85, 0.85, 0.85)

const MOD_LABELS := {"dmg_pct": "dano", "speed_pct": "velocidade", "cd_pct": "recarga", "area_pct": "área", "gold_pct": "moedas", "xp_pct": "XP",
	"hp": "PV", "regen": "PV/s", "ca": "CA", "cam": "CAM", "hit": "precisão", "pickup": "coleta", "dr": "redução de dano", "forca": "FOR", "inteligencia": "INT",
	"constituicao": "CON", "carisma": "CAR", "crit_overflow_bonus": "crítico", "crit_overflow_step": "crítico/2 níveis", "dodge": "esquiva", "lifesteal": "roubo de vida", "dmg_flat": "dano por acerto", "puddle_immune": "imune a poças", "sorte": "sorte",
	"eco_pista_pct": "alcance dos Ecos", "eco_xp_pct": "XP por Eco", "fire_pct": "dano de fogo", "area_dmg_pct": "dano em área"}

## MEC-027: peso de relevância de cada atributo; escolhe os destaques do cartão (só apresentação, não altera o cálculo do herói).
const STAT_WEIGHT := {"dmg_pct": 10.0, "cd_pct": 9.0, "speed_pct": 8.0, "hp": 8.0, "ca": 7.0, "cam": 7.0, "dr": 7.0,
	"regen": 6.0, "forca": 6.0, "inteligencia": 6.0, "constituicao": 6.0, "dodge": 6.0, "carisma": 5.0, "area_pct": 5.0,
	"crit_overflow_bonus": 5.0, "crit_overflow_step": 5.0, "hit": 4.0, "xp_pct": 4.0, "gold_pct": 3.0, "pickup": 3.0, "sorte": 4.0}

## Ícone de arma ou item. Sem PNG próprio, usa o de `icon_like` do dado (provisório, ART-042); sem isso, devolve o caminho próprio
## (inexistente) e a UI cai na letra.
static func weapon_icon(id: String) -> String:
	var own := "res://assets/icons/weapons/%s.png" % id
	if ResourceLoader.exists(own):
		return own
	var like := String(Data.table("weapons").get(id, {}).get("icon_like", ""))
	var alt := "res://assets/icons/weapons/%s.png" % like
	return alt if like != "" and ResourceLoader.exists(alt) else own

static func item_icon(id: String) -> String:
	var own := "res://assets/icons/items/%s.png" % id
	if ResourceLoader.exists(own):
		return own
	for u in Data.table("items").get("uniques", []):
		if String(u.get("id", "")) == id:
			var like := String(u.get("icon_like", ""))
			var alt := "res://assets/icons/items/%s.png" % like
			return alt if like != "" and ResourceLoader.exists(alt) else own
	return own

static func mod_label(k: String) -> String:
	return String(MOD_LABELS.get(k, k))

## Valor de um atributo sem o rótulo ("+9%", "+0.4", "+1").
static func mod_value_text(k: String, v: float) -> String:
	if k.ends_with("_pct") or k in ["dodge", "crit_overflow_bonus"]:
		return "%+d%%" % int(round(v * 100.0))
	if absf(v) < 10.0 and absf(v - roundf(v)) > 0.05:
		return "%+.1f" % v
	return "%+d" % int(roundf(v))

static func mods_text(mods: Dictionary) -> String:
	var parts: Array = []
	for k in mods:
		parts.append("%s %s" % [mod_value_text(k, float(mods[k])), mod_label(k)])
	return ", ".join(parts)

## Chaves ordenadas por relevância (peso, depois maior valor absoluto).
static func ranked_keys(mods: Dictionary) -> Array:
	var keys: Array = mods.keys()
	keys.sort_custom(func(a, b):
		var wa := float(STAT_WEIGHT.get(a, 1.0))
		var wb := float(STAT_WEIGHT.get(b, 1.0))
		if wa != wb:
			return wa > wb
		return absf(float(mods[a])) > absf(float(mods[b])))
	return keys

## MEC-027: linha de destaque do cartão, até n atributos (o resto fica no hover).
static func brief_text(mods: Dictionary, n := 3) -> String:
	var top := {}
	for k in ranked_keys(mods).slice(0, n):
		top[k] = mods[k]
	return mods_text(top)

## MEC-027: quantos atributos sobem e descem do equipado para o novo.
static func verdict(new_mods: Dictionary, old_mods: Dictionary) -> Dictionary:
	var up := 0
	var down := 0
	var d := diff_mods(new_mods, old_mods)
	for k in d:
		if float(d[k]) > 0.0:
			up += 1
		else:
			down += 1
	return {"up": up, "down": down}

## MEC-027: tabela do hover (novo × atual × diferença), mais relevantes primeiro.
static func compare_table(new_mods: Dictionary, old_mods: Dictionary, new_label: String, old_label: String) -> Dictionary:
	var all := {}
	for k in new_mods:
		all[k] = 1.0
	for k in old_mods:
		all[k] = 1.0
	var rows: Array = []
	for k in ranked_keys(all):
		var nv := float(new_mods.get(k, 0.0))
		var ov := float(old_mods.get(k, 0.0))
		var d := nv - ov
		var sign := 0 if absf(d) < mod_epsilon(k) else (1 if d > 0.0 else -1)
		rows.append({"key": k, "label": mod_label(k),
			"cols": [mod_value_text(k, nv) if new_mods.has(k) else "—", mod_value_text(k, ov) if old_mods.has(k) else "—"],
			"delta": "=" if sign == 0 else ("▲ " if sign > 0 else "▼ ") + mod_value_text(k, d), "sign": sign})
	return {"columns": [new_label, old_label, "Diferença"], "rows": rows, "footer": []}

## Menor diferença que conta: percentuais são frações (0.04 = +4%), os demais são valores inteiros ou de 0.1 em 0.1.
static func mod_epsilon(k: String) -> float:
	return 0.005 if (k.ends_with("_pct") or k in ["dodge", "crit_overflow_bonus"]) else 0.05
