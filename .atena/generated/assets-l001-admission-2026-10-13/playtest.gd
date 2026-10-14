extends Node
func _ready() -> void:
	var args:=OS.get_cmdline_user_args()
	var hero:=String(args[0]) if not args.is_empty() else "durvall"
	if not hero in ["durvall","brook","maelor"]:hero="durvall"
	var weapon:=String(args[1]) if args.size()>1 else ""
	Playtest.visible=false
	Game.qa_sandbox=true
	Game.qa_launch={"seed":4242}
	Game._save_path="user://l001-playtest-profile.json"
	Game.profile=Profile.new({"name":"L001 QA","welcome_seen":true})
	for id in Data.table("hqs"):Game.profile.data.hqs_seen[id]=true
	Game.profile.data.settings.reduced_impact="--reduced" in args
	Game.run_hero=hero
	Game.run_stage="dagruve"
	var run: Node=load("res://ui/run.tscn").instantiate()
	add_child(run)
	if weapon in ["golpe_do_juizo","martelo_da_gloria","machado_de_xargath"]:
		run.battle.hero.weapons=[Weapon.make(weapon)]
		run.battle.hero.recalc()
	if "--tou-um" in args:
		run.battle.visual_god="Tou Um"
		run.battle.visual_boon_selected=true
	run.hud.update_stats(run.battle)
	print("QA L001 launcher: ",hero," weapon=",weapon," reduced=",Game.reduced_impact()," god=",run.battle.visual_god)
