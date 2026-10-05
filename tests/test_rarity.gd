extends RefCounted
## SPEC-122 B-005: raridade Incomum, chances por tier e hierarquia de poder (Único > Raro > Incomum > Mágico > Comum).

func _power(mods: Dictionary) -> float:
	var s := 0.0
	for k in mods:
		var unit := 1.0
		if String(k).ends_with("_pct") or k in ["dodge", "crit_overflow_bonus"]: unit = 0.05
		elif k == "hp": unit = 5.0
		elif k == "regen": unit = 0.25
		elif k == "pickup": unit = 0.3
		s += float(mods[k]) / unit
	return s

func run() -> Array:
	var f: Array = []
	if not (Items.RANK.comum < Items.RANK.magico and Items.RANK.magico < Items.RANK.incomum and Items.RANK.incomum < Items.RANK.raro and Items.RANK.raro < Items.RANK.unico):
		f.append("RANK fora de ordem: %s" % Items.RANK)
	var c0 := Items.rarity_chances(0)
	if float(c0.raro) + float(c0.unico) > 0.12:
		f.append("tier 0 não deveria soltar mais de 12%% de Raro+Único (veio %.1f%%)" % ((float(c0.raro) + float(c0.unico)) * 100.0))
	var rng := RandomNumberGenerator.new()
	rng.seed = 777
	var cnt := {}
	var pw := {}
	for tier in [0, 2, 4]:
		cnt.clear()
		pw.clear()
		for i in 3000:
			var it := Items.roll(rng, tier, 0.0)
			var r := String(it.rarity)
			cnt[r] = int(cnt.get(r, 0)) + 1
			pw[r] = float(pw.get(r, 0.0)) + _power(it.mods)
		if int(cnt.get("incomum", 0)) == 0:
			f.append("tier %d: nenhum Incomum em 3000 sorteios" % tier)
		var last := -1.0
		for r in ["magico", "incomum", "raro", "unico"]:
			if int(cnt.get(r, 0)) < 20:
				continue
			var avg: float = float(pw[r]) / float(cnt[r])
			if avg <= last:
				f.append("tier %d: poder médio de %s (%.2f) não supera a raridade inferior (%.2f)" % [tier, r, avg, last])
			last = avg
	# Único sorteado só do próprio tier para baixo; mods fixos continuam presentes
	var rng2 := RandomNumberGenerator.new()
	rng2.seed = 5
	var db: Dictionary = Data.table("items")
	for i in 400:
		var it2 := Items.roll(rng2, 0, 0.0)
		if String(it2.rarity) == "unico":
			var def: Dictionary = db.uniques.filter(func(u): return u.id == it2.id)[0]
			if int(def.tier) > 0:
				f.append("Único de tier %d saiu no tier 0 (%s)" % [def.tier, it2.id])
			for k in def.mods:
				if not it2.mods.has(k):
					f.append("Único %s perdeu o mod fixo %s" % [it2.id, k])
	# Baú do chefe: piso de Raro mesmo com chances baixas
	var rng3 := RandomNumberGenerator.new()
	rng3.seed = 9
	for i in 300:
		var it3 := Items.roll(rng3, 1, 0.0, "raro")
		if int(Items.RANK[it3.rarity]) < int(Items.RANK["raro"]):
			f.append("piso de raridade ignorado: %s" % it3.rarity)
			break
	# Cor definida para todas as raridades
	for r in Items.RANK:
		if r != "comum" and Items.rarity_color(String(r)) == Items.rarity_color("comum"):
			f.append("raridade %s sem cor própria" % r)
	# Rótulos legíveis e tabela de preço por raridade (SPEC-122 E5 e E6)
	for r in Items.RANK:
		var lab := Items.rarity_label(String(r))
		if lab == String(r) or lab != lab.capitalize() and not (String(r) in ["magico", "unico"]):
			f.append("rótulo de %s não legível: %s" % [r, lab])
	if Items.rarity_label("magico") != "Mágico" or Items.rarity_label("unico") != "Único":
		f.append("rótulos devem ter acento: %s, %s" % [Items.rarity_label("magico"), Items.rarity_label("unico")])
	for kind in ["shop", "sell"]:
		var last_p := -1.0
		for r in ["comum", "magico", "incomum", "raro", "unico"]:
			var p := Items.price(kind, r)
			if p <= last_p:
				f.append("preço %s de %s (%s) não supera a raridade inferior (%s)" % [kind, r, p, last_p])
			last_p = p
	return f
