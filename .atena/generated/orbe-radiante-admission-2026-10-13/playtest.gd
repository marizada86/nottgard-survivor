extends Node

func _ready() -> void:
	var args := OS.get_cmdline_user_args()
	var weapon := String(args[0]) if not args.is_empty() else "raio_de_luz"
	if not RadiantOrbVfx.WEAPONS.has(weapon): weapon = "raio_de_luz"
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed":4242}
	Game._save_path = "user://orb-playtest-profile.json"
	Game.profile = Profile.new({"name":"Orbe Radiante QA","welcome_seen":true})
	for id in Data.table("hqs"): Game.profile.data.hqs_seen[id] = true
	Game.profile.data.settings.reduced_impact = "--reduced" in args
	Game.run_hero = "maelor"
	Game.run_stage = "dagruve"
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	run.battle.hero.weapons = [Weapon.make(weapon)]
	run.battle.hero.recalc()
	if "--tou-um" in args:
		run.battle.visual_god = "Tou Um"
		run.battle.visual_boon_selected = true
	run.hud.update_stats(run.battle)
	print("QA orb launcher: ",weapon," reduced=",Game.reduced_impact()," god=",run.battle.visual_god)
