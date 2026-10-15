extends SceneTree
## Sonda do relato T05 (EVID-250 IN-095): com 5 espaços de passiva e 14 passivas, quantas runs conseguem evoluir a arma inicial?
## Só sobe de nível e escolhe ofertas; sem combate. Política "aleatória" (escolhe qualquer oferta) e "atenta" (prioriza evolução, a passiva exigida e o nível da arma).
##   godot --headless --path . -s tools/probe_evolution_odds.gd -- <heroi> <seeds> <niveis>
func _init() -> void:
	var a := OS.get_cmdline_user_args()
	var hero_id: String = a[0] if a.size() > 0 else "durvall"
	var seeds := int(a[1]) if a.size() > 1 else 200
	var levels := int(a[2]) if a.size() > 2 else 25
	var first := Battle.new(1, hero_id, "dagruve", {})
	var base_id: String = String(first.hero.weapons[0].id)
	var evo_into: String = String(Data.table("weapons")[base_id].get("evolve", {}).get("into", ""))
	var need_passive: String = String(Data.table("weapons")[base_id].get("evolve", {}).get("passive", ""))
	for policy in ["aleatoria", "atenta"]:
		var evolved_at := {}
		var never := 0
		var blocked := 0
		for s in seeds:
			var b := Battle.new(s + 1, hero_id, "dagruve", {})
			var done_level := -1
			var rng := RandomNumberGenerator.new()
			rng.seed = s * 31 + 5
			var guard := 0
			while b.hero.level < levels and guard < 400:
				guard += 1
				if b.state == "levelup":
					var idx := 0
					if policy == "aleatoria":
						idx = rng.randi() % b.offer.size()
					else:
						var best := -1.0
						for i in b.offer.size():
							var o: Dictionary = b.offer[i]
							var sc := rng.randf()
							if String(o.t) == "evolve" and String(o.id) == base_id: sc += 100.0
							elif String(o.t) == "passive" and String(o.id) == need_passive: sc += 50.0
							elif String(o.t) == "weapon_up" and String(o.id) == base_id: sc += 20.0
							elif String(o.t) in ["weapon_up", "passive"]: sc += 5.0
							if sc > best:
								best = sc
								idx = i
					b.choose(idx)
					if done_level < 0 and b.hero.weapons.any(func(w): return String(w.id) == evo_into):
						done_level = b.hero.level
					continue
				if b.state == "altar" or b.state == "item_offer":
					b.choose(0)
					continue
				b._add_xp(float(b.xp_need_for(b.hero.level)))
				b.step(Vector2.ZERO, 0.05)
				b.events.clear()
			if done_level < 0:
				never += 1
				if b.hero.passives.size() >= 5 and int(b.hero.passives.get(need_passive, 0)) == 0:
					blocked += 1
			else:
				evolved_at[done_level] = int(evolved_at.get(done_level, 0)) + 1
		var cum := 0
		var parts: Array = []
		for lv in range(1, levels + 1):
			cum += int(evolved_at.get(lv, 0))
			if lv in [8, 10, 12, 15, 20, 25]:
				parts.append("nv%d: %d%%" % [lv, int(round(100.0 * cum / seeds))])
		print("%s | %s (%s precisa de %s) | política %s | evoluiu até: %s | nunca evoluiu até nv%d: %d%% (%d%% com os 5 espaços cheios sem a passiva)" % [hero_id, base_id, evo_into, need_passive, policy, ", ".join(parts), levels, int(round(100.0 * never / seeds)), int(round(100.0 * blocked / seeds))])
	quit()
