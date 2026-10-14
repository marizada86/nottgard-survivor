extends Battle

func _hero_hit(e: Enemy, p: Dictionary, roll: bool, visual_theme: Dictionary = {}) -> bool:
	var resolved_theme: Dictionary = visual_theme if not visual_theme.is_empty() else DivineVisuals.resolve(hero.id, visual_god, visual_boon_selected)
	if e.dead:
		return false
	var attr := String(p.get("attr", "forca"))
	var dtype := String(p.get("dtype", "fisico"))
	var r := 0
	var crit := false
	if roll:
		r = Dice.d20(rng)
		var acc := hero.prof + hero.attr_mod(attr) + int(hero.m("hit")) + int(p.get("acc", 0))
		if r == 1:
			stats.ones += 1
		if r == 1 or (r != 20 and rng.randf() >= _hit_chance(acc, e.typed_evasion(dtype, int(p.get("ignore_def", 0))))):
			events.append({"type": "miss", "pos": e.pos})
			return false
		crit = r == 20 or rng.randf() < hero.crit_chance(r + acc)
	var dmg := 0.0
	var dice := String(p.get("dice", ""))
	if dice != "":
		dmg = float(Dice.roll(rng, dice) + hero.attr_mod(attr) + int(p.get("dmg", 0)) + int(hero.m("dmg_flat")))
		var pct := 1.0 + hero.m("dmg_pct")
		if _has_boon_effect("dark_power") and hero.pos.distance_to(map_size * 0.5) > 8.0:
			pct += 0.18
		if _has_item_effect("control_damage") and (e.stun_t > 0.0 or e.slow_t > 0.0 or e.charmed_t > 0.0):
			pct += 0.25
		if shadow_charge:
			pct += 0.5
			shadow_charge = false
		if hero.hp < hero.max_hp * 0.5:
			pct += hero.m("low_hp_dmg")
		if dtype == "fogo":   # SPEC-160: Incendiário Procurado (Erik)
			pct += hero.m("fire_pct")
		if AREA_KINDS.has(String(p.get("kind", ""))):
			pct += hero.m("area_dmg_pct")
		dmg *= maxf(0.2, pct) * (1.0 + e.mark) * float(e.resist.get(dtype, 1.0)) * _shield_factor(e)
		if crit:
			dmg *= 2.0
			stats.crits += 1
			if _has_item_effect("crit_magnet"):
				for pickup in pickups:
					pickup.magnet = true
		dmg = maxf(1.0, round(dmg))
		run_record.hit(String(p.get("_audio_id", p.get("id", "unattributed"))), dmg, e.hp)
		e.hp -= dmg
		e.hit_flash = 0.12
		events.append({"type": "hit", "pos": e.pos, "amount": int(dmg), "crit": crit, "dtype": dtype, "tid": e.get_instance_id(), "visual_theme": resolved_theme})
		if crit and _has_boon_effect("critical_wave"):
			for other in enemies:
				if other != e and not other.dead and other.pos.distance_to(e.pos) <= 2.0:
					var splash := maxf(1.0, round(dmg * 0.25))
					run_record.hit("boon:critical_wave", splash, other.hp)
					other.hp -= splash
					events.append({"type": "hit", "pos": other.pos, "amount": int(splash), "crit": false, "dtype": dtype, "tid": other.get_instance_id(), "visual_theme": resolved_theme})
					if other.hp <= 0.0:
						_kill(other)
		var ls := float(p.get("lifesteal", 0.0)) + hero.m("lifesteal")
		if ls > 0.0:
			_add_hp(dmg * ls)
	_apply_effects(e, p)
	if float(p.get("gold_hit", 0.0)) > 0.0:
		_pay_gold_hit(float(p.gold_hit))
	if e.hp <= 0.0 and not e.dead:
		_kill(e)
	return true
