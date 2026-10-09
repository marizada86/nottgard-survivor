extends Node
## Screenshot: godot --path . res://tools/shot.tscn -- <saida.png> <segundos> <menu|run> [fase] [heroi] [tab]
func _ready() -> void:
	var a := OS.get_cmdline_user_args()
	var out: String = a[0] if a.size() > 0 else "shot.png"
	var secs := float(a[1]) if a.size() > 1 else 1.0
	var mode: String = a[2] if a.size() > 2 else "menu"
	Game.profile.data.name = "Teste"
	Game.profile.data.welcome_seen = true
	Playtest.visible = false
	if mode == "title":
		add_child(load("res://ui/title.tscn").instantiate())
	elif mode == "run":
		Game.run_stage = a[3] if a.size() > 3 else "dagruve"
		Game.run_hero = a[4] if a.size() > 4 else "durvall"
		var run: Node = load("res://ui/run.tscn").instantiate()
		add_child(run)
		var flags: String = a[5] if a.size() > 5 else ""
		if "god" in flags:
			run.battle.hero.max_hp = 9999.0
			run.battle.hero.hp = 9999.0
		for flag in flags.split(","):
			if flag.begins_with("boon="):  # SPEC-129: dá a bênção ao herói (ex.: boon=lliira_juramento)
				for bn in Data.table("boons").boons:
					if String(bn.id) == flag.trim_prefix("boon="):
						run.battle.hero.boons.append(bn)
				run.battle.hero.recalc()
			if flag.begins_with("god="):
				var god := flag.trim_prefix("god=")
				if DivineVisuals.is_divine_affinity(god):
					run.battle.visual_god = god
					run.battle.visual_boon_selected = true
		if "market" in flags:
			var bt: Battle = run.battle
			for i in 3:
				bt.interactions.append({"kind": ["loja", "ferreiro", "curandeiro"][i], "pos": bt.hero.pos + Vector2(-4.0 + 3.5 * i, 3.0), "used": false, "born_at": -5.0})
			bt.interactions.append({"kind": "boss_chest", "pos": bt.hero.pos + Vector2(-6.0, -3.0), "used": false, "born_at": -5.0})
			bt.pickups.append({"kind": "magnet", "pos": bt.hero.pos + Vector2(7.0, 5.0), "value": 0.0, "magnet": false})
			bt.pickups.append({"kind": "xp", "pos": bt.hero.pos + Vector2(8.5, 5.0), "value": 1.0, "magnet": false})
		if "shop" in flags:
			run.battle.hero.gold = 30
			for i in 3:
				run.battle.give_item(Items.roll(run.battle.rng, 4, 3.0))
			run.battle.state = "running"
			run.battle.offer.clear()
			run.battle._open_shop_event("loja")
		if "forge" in flags:
			run.battle.hero.gold = 60
			for i in 3:
				run.battle.give_item(Items.roll(run.battle.rng, 4, 3.0))
			run.battle.state = "running"
			run.battle.offer.clear()
			run.battle._open_shop_event("ferreiro")
		if "altar" in flags:
			run.battle._open_altar()
		if "donate" in flags:
			for i in 3:
				run.battle.give_item(Items.roll(run.battle.rng, 4, 3.0))
			run.battle.state = "running"
			run.battle.offer.clear()
			run.battle._open_risk_event("doacao")
		if "bet" in flags:
			run.battle.hero.gold = 50
			run.battle._open_risk_event("aposta")
		if "shift" in flags:
			var shift_ev := InputEventKey.new()
			shift_ev.keycode = KEY_SHIFT
			shift_ev.physical_keycode = KEY_SHIFT
			shift_ev.pressed = true
			Input.parse_input_event(shift_ev)
		if "evolve" in flags:
			run.battle.evolve_cine = {"from": "espada_sombria", "into": "espada_do_receptaculo", "passive": "cota_de_malha", "level": 5}
			run.battle.evolve_cine_t = 30.0
			run.battle.state = "evolve_cine"
		# SPEC-118: happening=<id> dispara um acontecimento da fase (vários separados por vírgula)
		for flag in flags.split(","):
			if flag.begins_with("happening="):
				var hid := flag.trim_prefix("happening=")
				for d in Data.table("stage_events").get(Game.run_stage, []):
					if String(d.id) == hid:
						run.battle.happenings.fire(run.battle, d.duplicate(true))
						for it in run.battle.interactions:
							it.born_at = -5.0
		if "wide" in flags:
			run.camera.zoom = Vector2(0.34, 0.34)
		if "levelup" in flags:
			run.battle._add_xp(400.0)
		if "boss" in flags:
			run.battle.time = float(run.battle.stage.duration) - 0.2
		if "postboss" in flags:
			run.battle.qa_prepare("portal")
		if "items" in flags:
			for i in 5:
				run.battle.give_item(Items.roll(run.battle.rng, 4, 3.0))
			run.battle.give_item(Items.unique(Data.table("items").uniques[0]))
		if "fullhud" in flags:
			# Lista do canto inferior esquerdo no limite: armas, passivas, equipamentos e bênçãos.
			for wid in Data.table("weapons").keys().slice(0, 6):
				if not run.battle.hero.weapons.any(func(w): return w.id == wid):
					run.battle.hero.weapons.append(Weapon.make(String(wid)))
			for pid in Data.table("passives").keys().slice(0, 5):
				run.battle.hero.passives[pid] = 2
			for i in 5:
				run.battle.give_item(Items.roll(run.battle.rng, 4, 3.0))
			run.battle.give_item(Items.unique(Data.table("items").uniques[0]))
			run.battle.hero.boons.append(Data.table("boons").boons[0])
		if "vfx" in flags:
			_seed_vfx_areas(run)
		if "styx" in flags:
			run.battle.hero.pos = TerrainLayout.styx_sample(Game.run_stage)
			run.battle._stage_rule_step(0.1)
		# SPEC-158: edge=<distancia> leva o herói a essa distância (tiles) da borda oeste; edge_exp=<s> simula a exposição
		for flag in flags.split(","):
			if flag.begins_with("edge="):
				run.battle.hero.pos = Vector2(float(flag.trim_prefix("edge=")), run.battle.map_size.y * 0.5)
			if flag.begins_with("edge_exp="):
				run.battle.edge_exposure = float(flag.trim_prefix("edge_exp="))
	else:
		var m: Node = load("res://ui/menu.tscn").instantiate()
		add_child(m)
		if a.size() > 5:
			await get_tree().process_frame
			m.get_node("%Tabs").current_tab = int(a[5])
	await get_tree().create_timer(secs).timeout
	get_viewport().get_texture().get_image().save_png(out)
	get_tree().quit()

func _seed_vfx_areas(run: Node) -> void:
	# Cena de evidência determinística: não é acessível pela partida normal.
	run.battle.time = 60.0 # Pilares: a rotação entra em current.
	var c: Vector2 = run.battle.hero.pos
	run.battle.zones.append({"owner": "enemy", "kind": "puddle", "pos": c + Vector2(-4.5, -2.1), "radius": 1.55, "life": 9.0, "acc": 0.0})
	run.battle.zones.append({"owner": "stage", "kind": "rule_ritual", "pos": c + Vector2(-1.1, -2.2), "radius": 1.7, "delay": 4.0, "total": 7.0, "interrupt": 1.5, "progress": 0.72, "life": 99.0})
	run.battle.zones.append({"owner": "stage", "kind": "telegraph", "pos": c + Vector2(2.6, -2.0), "radius": 1.5, "delay": 0.55, "total": 1.3, "life": 99.0, "dice": "2d6", "bonus": 4})
	run.battle.zones.append({"owner": "stage", "kind": "bubble", "pos": c + Vector2(-4.0, 2.7), "radius": 2.0, "delay": 0.8, "total": 2.2, "life": 99.0, "dice": "2d6", "bonus": 3})
	run.battle.zones.append({"owner": "stage", "kind": "sanctuary", "pos": c + Vector2(0.2, 3.0), "radius": 2.2, "life": 7.0, "acc": 0.0, "fake": true})
	run.battle.zones.append({"owner": "hero", "kind": "zone", "pos": c + Vector2(4.0, 2.6), "radius": 1.6, "life": 3.0, "tick": 0.5, "acc": 0.0, "p": {"id": "cera_fervente", "dtype": "fogo"}})
	run.battle.zones.append({"owner": "hero", "kind": "zone", "pos": c, "radius": 2.4, "life": 4.0, "tick": 0.6, "acc": 0.0, "p": {"id": "colar_dos_tentaculos", "dtype": "magico"}})
