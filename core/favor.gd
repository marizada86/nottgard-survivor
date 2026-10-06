class_name Favor
extends RefCounted
## SPEC-129 B-004: Favor divino e rivalidade (dados em data/favor.json).
## Cada bênção aceita soma 1 ao deus. Favor líquido = bênçãos do deus - bênçãos do rival (mín. 0).
## O rival nunca bloqueia a oferta: só troca o Favor. Os bônus de nível somam e valem enquanto durar a run.

static func _cfg() -> Dictionary:
	return Data.table("favor")

static func count(boons: Array, god: String) -> int:
	var n := 0
	for b in boons:
		if String(b.get("god", "")) == god:
			n += 1
	return n

static func rival_of(god: String) -> String:
	return String(_cfg().gods.get(god, {}).get("rival", ""))

## Favor líquido de um deus.
static func net(boons: Array, god: String) -> int:
	var own := count(boons, god)
	var rival := rival_of(god)
	if rival != "":
		own -= count(boons, rival)
	return maxi(0, own)

## Nível liberado (0, 1, 2...) para um Favor líquido.
static func tier(net_favor: int) -> int:
	var t := 0
	for th in _cfg().thresholds:
		if net_favor >= int(th):
			t += 1
	return t

## Bônus somados de todos os deuses.
static func mods(boons: Array) -> Dictionary:
	var out := {}
	var gods: Dictionary = _cfg().gods
	for god in gods:
		var t := tier(net(boons, String(god)))
		var tiers: Array = gods[god].tiers
		for i in mini(t, tiers.size()):
			Hero.add_mods(out, tiers[i])
	return out

## Linhas do HUD: deuses com ao menos uma bênção, com o Favor líquido e o que o rival tirou.
static func hud_lines(boons: Array) -> Array:
	var out: Array = []
	var seen := {}
	for b in boons:
		var god := String(b.get("god", ""))
		if god == "" or seen.has(god) or not _cfg().gods.has(god):
			continue
		seen[god] = true
		var own := count(boons, god)
		var line := "✦ Favor de %s %d" % [god, net(boons, god)]
		var t := tier(net(boons, god))
		var next_th := -1
		for th in _cfg().thresholds:
			if int(th) > net(boons, god):
				next_th = int(th)
				break
		if t > 0:
			line += " (nível %d: %s)" % [t, Items.mods_text(_tier_mods(god, t))]
		elif next_th > 0:
			line += " (faltam %d para o nível 1)" % (next_th - net(boons, god))
		var rival := rival_of(god)
		if rival != "" and count(boons, rival) > 0:
			line += " · rival %s tira %d" % [rival, mini(own, count(boons, rival))]
		out.append(line)
	return out

static func _tier_mods(god: String, t: int) -> Dictionary:
	var out := {}
	var tiers: Array = _cfg().gods[god].tiers
	for i in mini(t, tiers.size()):
		Hero.add_mods(out, tiers[i])
	return out

## Dica do cartão do altar: o que esta bênção faz com o Favor.
static func offer_hint(boons: Array, boon: Dictionary) -> String:
	var god := String(boon.get("god", ""))
	if not _cfg().gods.has(god):
		return ""
	var before := net(boons, god)
	var after := net(boons + [boon], god)
	var parts: Array = []
	if after > before:
		parts.append("Favor de %s %d → %d" % [god, before, after])
		if tier(after) > tier(before):
			parts.append("libera o nível %d: %s" % [tier(after), Items.mods_text(_tier_mods(god, tier(after)))])
	var rival := rival_of(god)
	if rival != "":
		var rival_before := net(boons, rival)
		var rival_after := net(boons + [boon], rival)
		if rival_after < rival_before:
			parts.append("tira Favor de %s (%d → %d)" % [rival, rival_before, rival_after])
	if parts.is_empty():
		var r2 := rival_of(god)
		if r2 != "" and count(boons, r2) > 0:
			parts.append("rival de %s: o Favor só sobe depois de superá-lo" % r2)
		else:
			return ""
	return " · ".join(parts)
