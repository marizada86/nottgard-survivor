extends Node
## Cena de QA local: a fase Dagruve com o heroi e as armas pedidas (so para o playtest destes efeitos).
## Uso: playtest.tscn -- <heroi> [arma ...] [--reduced]

func _ready() -> void:
	var args := OS.get_cmdline_user_args()
	var hero := "leoric"
	var weapons: Array = []
	for a in args:
		if a == "--reduced":
			continue
		if hero == "leoric" and weapons.is_empty() and Data.table("heroes").has(String(a)):
			hero = String(a)
		elif Data.table("weapons").has(String(a)):
			weapons.append(String(a))
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 4242}
	Game._save_path = "user://vfx-playtest-profile.json"
	Game.profile = Profile.new({"name": "VFX playtest QA", "welcome_seen": true})
	for id in Data.table("hqs"):
		Game.profile.data["hqs_seen"][id] = true
	Game.profile.data.settings["reduced_impact"] = "--reduced" in args
	Game.run_hero = hero
	Game.run_stage = "dagruve"
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	if not weapons.is_empty():
		run.battle.hero.weapons = weapons.map(func(w): return Weapon.make(w))
		run.battle.hero.recalc()
		run.hud.update_stats(run.battle)
	print("QA VFX playtest: heroi=", hero, " armas=", weapons, " reduced=", Game.reduced_impact())
