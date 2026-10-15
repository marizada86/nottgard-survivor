extends SceneTree
## Sonda do relato T05 (EVID-250 IN-091/IN-093): herói PARADO ao lado de cada chefe, com nível e armas dados.
## Mede quanto o chefe leva para cair e quanta vida o herói perde. Não usa Marcas nem meta do Quartel.
##   godot --headless --path . -s tools/probe_boss_ttk.gd -- <heroi> <nivel> <nivel_das_armas> [seed]
func _init() -> void:
	var a := OS.get_cmdline_user_args()
	var hero_id: String = a[0] if a.size() > 0 else "durvall"
	var level := int(a[1]) if a.size() > 1 else 10
	var wlevel := int(a[2]) if a.size() > 2 else 3
	var seed_v := int(a[3]) if a.size() > 3 else 1
	var tier := int(a[4]) if a.size() > 4 else 0
	if a.size() > 5:
		Data.table("difficulty")["l2"]["enabled"] = (a[5] != "0")
	var metas := [{}, {"dmg_pct": 1.0, "hp": 60, "ca": 4}, {"dmg_pct": 2.0, "hp": 100, "ca": 6, "speed_pct": 0.1}]
	var weapon_pool := ["espada_sombria", "romper_armadura", "lamina_de_sombra", "bola_de_fogo", "martelo_da_luz"]
	for stage_id in Data.table("stages"):
		if bool(Data.table("stages")[stage_id].get("endless", false)):
			continue
		var b := Battle.new(seed_v, hero_id, stage_id, {"meta_mods": metas[clampi(tier, 0, 2)]})
		b.qa_prepare({"target_state": "boss", "prelude_seconds": 0.5, "level": level, "weapons": weapon_pool.slice(0, 3)})
		for w in b.hero.weapons:
			w.level = clampi(wlevel, 1, 5)
		b.hero.recalc()
		b.hero.hp = b.hero.max_hp
		var t_boss := -1.0
		var min_hp := 1.0
		var steps := 0
		var cause := "tempo"
		while steps < 20000:
			steps += 1
			if b.state == "levelup" or b.state == "altar":
				b.choose(0)
				continue
			if b.state == "item_offer":
				b.choose(0)
				continue
			if b.state == "dead" or b.state == "revive_offer":
				cause = "herói morreu"
				break
			b.step(Vector2.ZERO, 0.05)
			if b.boss != null and t_boss < 0.0:
				t_boss = b.time
			min_hp = minf(min_hp, b.hero.hp / maxf(1.0, b.hero.max_hp))
			if b.boss_dead:
				cause = "chefe caiu"
				break
			b.events.clear()
		var dur := (b.time - t_boss) if t_boss >= 0.0 else -1.0
		var boss_hp := int(b.boss.max_hp) if b.boss != null else 0
		print("%-12s nv%d armas nv%d | chefe %-26s PV %4d | %s em %5.1fs | PV mín do herói %3d%% (PV máx %d)" % [stage_id, level, wlevel, (b.boss.name if b.boss != null else "-"), boss_hp, cause, dur, int(min_hp * 100.0), int(b.hero.max_hp)])
	quit()
