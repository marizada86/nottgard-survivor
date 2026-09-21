extends RefCounted
## Integridade cruzada dos dados: ids referenciados existem.

func run() -> Array:
	var out: Array = []
	var enemies: Dictionary = Data.table("enemies")
	var weapons: Dictionary = Data.table("weapons")
	var passives: Dictionary = Data.table("passives")
	var heroes: Dictionary = Data.table("heroes")
	var stages: Dictionary = Data.table("stages")
	for sid in stages:
		var s: Dictionary = stages[sid]
		if not enemies.has(s.boss):
			out.append("fase %s: chefe %s inexistente" % [sid, s.boss])
		elif not enemies[s.boss].get("flags", []).has("boss"):
			out.append("fase %s: %s não tem flag boss" % [sid, s.boss])
		for w in s.waves:
			if not enemies.has(w.id):
				out.append("fase %s: onda com inimigo %s inexistente" % [sid, w.id])
		for e in s.elites:
			if not enemies.has(e.id):
				out.append("fase %s: elite %s inexistente" % [sid, e.id])
		if s.next != "" and not stages.has(s.next):
			out.append("fase %s: next %s inexistente" % [sid, s.next])
		if s.unlock != "start" and not stages.has(s.unlock):
			out.append("fase %s: unlock %s inexistente" % [sid, s.unlock])
		if not ResourceLoader.exists("res://ui/stages/%s.tscn" % sid):
			out.append("fase %s: cena ui/stages/%s.tscn ausente" % [sid, sid])
	for eid in enemies:
		var e: Dictionary = enemies[eid]
		for a in e.get("abilities", []):
			if a.t == "summon" and not enemies.has(a.id):
				out.append("inimigo %s invoca %s inexistente" % [eid, a.id])
		if e.has("split") and not enemies.has(e.split):
			out.append("inimigo %s divide em %s inexistente" % [eid, e.split])
	for wid in weapons:
		var w: Dictionary = weapons[wid]
		if w.has("evolve"):
			if not passives.has(w.evolve.passive):
				out.append("arma %s evolui com passiva %s inexistente" % [wid, w.evolve.passive])
			if not weapons.has(w.evolve.into):
				out.append("arma %s evolui para %s inexistente" % [wid, w.evolve.into])
		if not ["melee", "bolt", "nova", "zone"].has(w.kind):
			out.append("arma %s: kind %s inválido" % [wid, w.kind])
	for hid in heroes:
		if not weapons.has(heroes[hid].weapon):
			out.append("herói %s: arma %s inexistente" % [hid, heroes[hid].weapon])
		var req: String = heroes[hid].unlock
		if req != "start":
			var found := false
			for a in Data.table("achievements").achievements:
				if "ach:%s" % a.id == req:
					found = true
			if not found:
				out.append("herói %s: conquista %s inexistente" % [hid, req])
	for u in Data.table("items").uniques:
		if u.get("weapon", "") != "" and not weapons.has(u.weapon):
			out.append("item %s: arma %s inexistente" % [u.id, u.weapon])
	for a in Data.table("achievements").achievements:
		if a.reward.has("unlock_hero") and not heroes.has(a.reward.unlock_hero):
			out.append("conquista %s: herói %s inexistente" % [a.id, a.reward.unlock_hero])
		if a.reward.has("unlock_stage") and not stages.has(a.reward.unlock_stage):
			out.append("conquista %s: fase %s inexistente" % [a.id, a.reward.unlock_stage])
	return out
