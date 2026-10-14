extends Battle

func use_active(dir: Vector2 = Vector2.ZERO) -> bool:
	if state != "running" or active_cd > 0.0 or hero.dead:
		return false
	var p := active_def
	var used := true
	var radius := float(p.get("radius", p.get("range", 2.0)))
	match String(p.kind):
		"cleave":
			var hit := p.duplicate(true)
			hit.kind = "melee"
			used = _fire_melee(hit, 1.0 + hero.m("area_pct"))
		"guard":
			active_guard = int(p.get("charges", 1))
			active_guard_t = float(p.get("duration", 4.0))
		"healing_aura":
			_heal_hero(float(p.heal))
			for e in enemies:
				if not e.dead and e.pos.distance_to(hero.pos) <= radius + e.radius:
					_hero_hit(e, p, false)
		"dash_weaken":
			var move_dir := dir.normalized() if dir.length() > 0.01 else Vector2(1, 0)
			var target_pos := hero.pos + move_dir * float(p.distance)
			if float(p.get("decoy_life", 0.0)) > 0.0:
				_spawn_decoy(p)
			for i in range(10, 0, -1):
				var candidate := hero.pos.lerp(target_pos, float(i) / 10.0)
				if hero.is_free(candidate):
					hero.pos = candidate
					break
			for e in enemies:
				if not e.dead and e.pos.distance_to(hero.pos) <= radius + e.radius:
					_apply_effects(e, {"weaken": p.weaken})
		"overdrive":
			active_buff_t = float(p.duration)
		"slam":
			used = _fire_nova(p, 1.0 + hero.m("area_pct"))
		"star_burst":
			var n := int(p.count)
			for k in n:
				var ang := TAU * float(k) / float(n)
				projectiles.append({"owner": "hero", "pos": hero.pos, "dir": Vector2(cos(ang), sin(ang)), "speed": float(p.speed),
				"life": float(p.range) / float(p.speed), "pierce": 1, "radius": 0.4, "p": p, "hit": {}, "visual_theme": DivineVisuals.resolve(hero.id, visual_god, visual_boon_selected)})
		"charm":
			var charm_target := nearest(hero.pos, float(p.range))
			if charm_target == null or charm_target.is_boss():
				used = false
			else:
				charm_target.charmed_t = float(p.duration)
				events.append({"type": "text", "pos": charm_target.pos, "text": "dominado"})
		"time_stop":
			time_slow_t = float(p.duration)
		"forget_nova":   # SPEC-160: Modify Memory (Arlindo): inimigos próximos esquecem o herói e perdem os ataques
			for e in enemies:
				if e.dead or e.has_flag("quebravel") or e.pos.distance_to(hero.pos) > radius + e.radius:
					continue
				var forget := float(p.get("duration", 2.0))
				e.stun_t = maxf(e.stun_t, minf(forget * 0.3, 0.6) if e.is_boss() else forget)
			events.append({"type": "nova", "pos": hero.pos, "radius": radius, "dtype": "magico", "weapon": String(p.get("id", ""))})
		"fire_zone":   # SPEC-160: Navios em Chamas (Erik): faixa de fogo à frente do herói
			var fwd := dir.normalized() if dir.length() > 0.01 else Vector2(1, 1).normalized()
			var zone_at := (hero.pos + fwd * float(p.get("reach", 2.5))).clamp(Vector2(1, 1), map_size - Vector2(1, 1))
			var zone_area := 1.0 + hero.m("area_pct")
			var zone_theme := DivineVisuals.resolve(hero.id, visual_god, visual_boon_selected)
			zones.append({"owner": "hero", "kind": "zone", "pos": zone_at, "radius": float(p.radius) * zone_area, "life": float(p.get("duration", 8.0)), "tick": float(p.get("tick", 0.5)), "acc": 0.0, "p": p, "visual_theme": zone_theme})
			events.append({"type": "zone", "pos": zone_at, "radius": float(p.radius) * zone_area, "dtype": "fogo", "weapon": String(p.get("id", "")), "visual_theme": zone_theme})
		"guard_nova":
			active_guard = int(p.get("charges", 1))
			active_guard_t = 5.0
			used = _fire_nova(p, 1.0 + hero.m("area_pct")) or active_guard > 0
		_:
			used = false
	if not used:
		return false
	active_cd = active_cooldown_effective()
	active_cd_max = active_cd
	if _has_item_effect("projectile_slow_on_active"):
		projectile_slow_t = 4.0
	events.append({"type": "active", "pos": hero.pos, "radius": radius, "dtype": p.get("dtype", "radiante"), "name": p.name, "hero_id": hero.id, "ability_id": p.id})
	events.append({"type": "toast", "text": p.name})
	return true
