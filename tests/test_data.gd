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
	var abilities: Dictionary = Data.table("abilities")
	var ability_kinds := ["cleave", "guard", "healing_aura", "dash_weaken", "overdrive", "slam", "star_burst", "charm", "time_stop", "guard_nova"]
	for hid in heroes:
		if not abilities.has(hid):
			out.append("herói %s sem habilidade ativa" % hid)
		elif not ability_kinds.has(String(abilities[hid].kind)):
			out.append("herói %s com habilidade de tipo inválido" % hid)
	var stage_rules: Dictionary = Data.table("stage_rules")
	for sid in stages:
		if not stage_rules.has(sid):
			out.append("fase %s sem regra principal" % sid)
	var boss_phases: Dictionary = Data.table("boss_phases")
	for bid in boss_phases:
		if not enemies.has(bid):
			out.append("fases configuradas para chefe inexistente %s" % bid)
		for phase in boss_phases[bid]:
			for action in phase.actions:
				if action.t == "summon" and not enemies.has(action.id):
					out.append("chefe %s invoca inimigo inexistente %s" % [bid, action.id])
	var unique_ids := {}
	for unique in Data.table("items").uniques:
		unique_ids[unique.id] = true
	for iid in Data.table("item_effects"):
		if not unique_ids.has(iid):
			out.append("efeito configurado para item inexistente %s" % iid)
	var boon_ids := {}
	for boon in Data.table("boons").boons:
		boon_ids[boon.id] = true
	for boon_id in Data.table("boon_effects"):
		if not boon_ids.has(boon_id):
			out.append("efeito configurado para bênção inexistente %s" % boon_id)
	return out
