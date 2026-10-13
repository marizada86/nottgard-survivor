extends Node

func _ready() -> void:
	var args := OS.get_cmdline_user_args()
	var weapon := String(args[0]) if not args.is_empty() else "sentenca_de_lliira"
	if not RadiantPulseVfx.WEAPONS.has(weapon): weapon = "sentenca_de_lliira"
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 4242}
	Game._save_path = "user://pulso-playtest-profile.json"
	Game.profile = Profile.new({"name": "Pulso playtest QA", "welcome_seen": true})
	for id in Data.table("hqs"): Game.profile.data["hqs_seen"][id] = true
	Game.profile.data.settings["reduced_impact"] = "--reduced" in args
	Game.run_hero = "maelor"
	Game.run_stage = "dagruve"
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	run.battle.hero.weapons = [Weapon.make(weapon)]
	run.battle.hero.recalc()
	run.hud.update_stats(run.battle)
	print("QA pulse playtest: ", weapon, "; reduced=", Game.reduced_impact())
