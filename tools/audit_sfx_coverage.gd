extends Node
## Cobertura de SFX e VFX por conteúdo (SPEC-177 R3): o que toca som próprio e o que cai no genérico.
## godot --headless --path . res://tools/audit_sfx_coverage.tscn

func _ready() -> void:
	var lines: Array = []
	var heroes: Dictionary = Data.table("heroes")
	var weapons: Dictionary = Data.table("weapons")
	var enemies: Dictionary = Data.table("enemies")
	lines.append("# Cobertura de SFX (gerado por tools/audit_sfx_coverage.gd)")
	lines.append("")
	var gaps := {"hero.active": [], "weapon.fire": [], "enemy.action": [], "enemy.death": [], "boss.arrival": [], "boss.defeat": [], "boss.phase": [], "world": []}
	for id in heroes:
		if not Sfx.has_event("hero.%s.active" % id):
			gaps["hero.active"].append(id)
	for id in weapons:
		if not Sfx.has_event("weapon.%s.fire" % id):
			gaps["weapon.fire"].append(id)
	for id in enemies:
		var e: Dictionary = enemies[id]
		var is_boss := bool(e.get("boss", false)) or String(e.get("kind", "")) == "boss"
		if is_boss:
			for cue in ["arrival", "defeat", "phase"]:
				if not Sfx.has_event("boss.%s.%s" % [id, cue]):
					gaps["boss.%s" % cue].append(id)
		else:
			for cue in ["action", "death"]:
				if not Sfx.has_event("enemy.%s.%s" % [id, cue]):
					gaps["enemy.%s" % cue].append(id)
	for kind in ["chest", "boss_chest", "portal", "altar", "fountain", "ritual", "arcanista", "ferreiro", "curandeiro", "loja", "aposta", "doacao", "ampulheta", "camara", "descent", "warning", "elite"]:
		if not Sfx.has_event("world.%s" % kind):
			gaps["world"].append(kind)
		elif String(Sfx._aliases.get("world.%s" % kind, "")) != "":
			gaps["world"].append("%s (alias de %s)" % [kind, Sfx._aliases["world.%s" % kind]])
	for group in gaps:
		lines.append("## %s: %d sem som próprio" % [group, gaps[group].size()])
		lines.append(", ".join(PackedStringArray(gaps[group])) if not gaps[group].is_empty() else "(nenhum)")
		lines.append("")
	# VFX: o que tem arte própria e o que cai no desenho procedural (cone, círculo ou anel)
	lines.append("# Cobertura de VFX")
	lines.append("")
	var vfx_gaps := {"melee": [], "bolt": [], "nova": [], "zone": []}
	var vfx_ok := {"melee": 0, "bolt": 0, "nova": 0, "zone": 0}
	var projectile_weapons: Array = []
	for family in ProjectileVfx.FAMILIES:
		projectile_weapons.append_array(ProjectileVfx.FAMILIES[family].weapons)
	for id in weapons:
		var w: Dictionary = weapons[id]
		var kind := String(w.get("kind", ""))
		var covered := false
		match kind:
			"melee":
				covered = MeleeVfx.shape_for(String(id), String(w.get("dtype", ""))) != ""
			"bolt":
				covered = projectile_weapons.has(String(id))
			"nova":
				covered = RadiantPulseVfx.WEAPONS.has(String(id)) or String(id) == "ampulheta"
			"zone":
				covered = false
		if not vfx_ok.has(kind):
			continue
		if covered:
			vfx_ok[kind] += 1
		else:
			vfx_gaps[kind].append(String(id))
	for kind in vfx_gaps:
		lines.append("## armas %s: %d com arte própria, %d no procedural" % [kind, vfx_ok[kind], vfx_gaps[kind].size()])
		lines.append(", ".join(PackedStringArray(vfx_gaps[kind])) if not vfx_gaps[kind].is_empty() else "(nenhuma)")
		lines.append("")
	var abilities: Dictionary = Data.table("abilities")
	var no_ability_vfx: Array = []
	for hero_id in abilities:
		var ability_id := String(abilities[hero_id].get("id", ""))
		if not HeroAbilityVfx.supports(ability_id) or HeroAbilityVfx.frames_for(ability_id) == null:
			no_ability_vfx.append("%s (%s)" % [hero_id, ability_id])
	lines.append("## habilidades de herói sem arte própria: %d" % no_ability_vfx.size())
	lines.append(", ".join(PackedStringArray(no_ability_vfx)) if not no_ability_vfx.is_empty() else "(nenhuma)")
	lines.append("")
	lines.append("Totais: %d heróis, %d armas, %d inimigos no catálogo." % [heroes.size(), weapons.size(), enemies.size()])
	var path := "res://.atena/generated/m2-game-feel/sfx-vfx-cobertura.md"
	var file := FileAccess.open(path, FileAccess.WRITE)
	file.store_string("\n".join(PackedStringArray(lines)))
	file.close()
	print("\n".join(PackedStringArray(lines)))
	get_tree().quit()
