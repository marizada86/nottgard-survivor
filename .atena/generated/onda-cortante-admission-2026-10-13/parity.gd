extends SceneTree

const OUT := "res://.atena/generated/onda-cortante-admission-2026-10-13/"
var counts := {"hit":0,"miss":0,"crit":0,"scenarios":0,"steps":0,"piercing_contacts":0}

func _init() -> void:
	call_deferred("check")

func normalized(value: Variant, enemies: Array) -> Variant:
	if value is Dictionary:
		var result := {}
		for key in value:
			if String(key) in ["tid", "weapon", "kind"] and value.get("type", "") == "hit": continue
			result[key] = normalized(value[key], enemies)
		return result
	if value is Array:
		var result: Array = []
		for item in value: result.append(normalized(item,enemies))
		return result
	if value is Enemy: return enemies.find(value)
	return value

func snapshot(b: Variant) -> Dictionary:
	var projectiles: Array = []
	for pr in b.projectiles:
		var hits: Array = []
		for enemy in pr.hit: hits.append(b.enemies.find(enemy))
		projectiles.append({"pos":pr.pos,"dir":pr.dir,"life":pr.life,"speed":pr.speed,"pierce":pr.pierce,"radius":pr.radius,"p":pr.p,"hit":hits})
	var enemies: Array = []
	for e in b.enemies: enemies.append({"hp":e.hp,"pos":e.pos,"dead":e.dead,"ca":e.ca,"cam":e.cam,"mark":e.mark,"mark_t":e.mark_t,"stun":e.stun_t,"slow":e.slow_t,"burn":e.burn_t,"burn_dps":e.burn_dps})
	return {"rng":b.rng.state,"hp":b.hero.hp,"stats":b.stats,"damage":b.run_record.damage,"projectiles":projectiles,"enemies":enemies,"events":normalized(b.events,b.enemies)}

func setup(b: Variant) -> void:
	b.hero.pos = Vector2(20,20)
	b.aim = 1
	b.aim_dir = Vector2.RIGHT
	for id in Data.table("boon_effects"):
		if Data.table("boon_effects")[id].get("effect", "") == "critical_wave":
			b.hero.boons.append({"id":id})
	for x in [20.6,21.5,22.4,23.3,24.2,25.1]:
		b.spawn_for_test("zumbi",Vector2(x,20))
		b.enemies[-1].hp = 10000
		b.enemies[-1].max_hp = 10000
	b.events.clear()

func check() -> void:
	var baseline = load("res://.atena/generated/orbe-radiante-admission-2026-10-13/baseline_battle.gd")
	assert(baseline != null and baseline.can_instantiate())
	for weapon in ["lamina_trovejante","tempestade"]:
		for seed_value in range(1,17):
			var old = baseline.new(seed_value,"maelor","dagruve")
			var current := Battle.new(seed_value,"maelor","dagruve")
			setup(old)
			setup(current)
			var w := Weapon.make(weapon)
			assert(old._fire(w,w.params()) == current._fire(w,w.params()))
			for step in 90:
				old._update_projectiles(1.0/60.0)
				current._update_projectiles(1.0/60.0)
				assert(snapshot(old) == snapshot(current), "simulation mismatch " + weapon + " seed=" + str(seed_value) + " step=" + str(step))
				for event in current.events:
					if event.type == "hit":
						counts.hit += 1
						if event.crit: counts.crit += 1
					if event.type == "miss": counts.miss += 1
				for pr in current.projectiles:
					if pr.hit.size() > 1: counts.piercing_contacts += 1
				old.events.clear()
				current.events.clear()
				counts.steps += 1
			assert(old.projectiles.is_empty() and current.projectiles.is_empty())
			counts.scenarios += 1
	assert(counts.hit > 0 and counts.crit > 0 and counts.miss > 0 and counts.piercing_contacts > 0)
	var report := {"status":"PASS","comparison":"Pre-admission Battle vs current, identical RNG/damage/hp/status/projectile trajectory/pierce/events except primary hit weapon/kind. Instance IDs canonicalized.","counts":counts}
	FileAccess.open(OUT+"parity.json",FileAccess.WRITE).store_string(JSON.stringify(report,"\t")+"\n")
	print("simulation parity PASS ",counts)
	quit()
