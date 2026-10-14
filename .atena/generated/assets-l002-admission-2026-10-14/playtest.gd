extends Node
func _ready() -> void:
	var args:=OS.get_cmdline_user_args()
	var hero:=String(args[0]) if not args.is_empty() else "sylas"
	if not hero in ["sylas","kayron","korrak","leoric","nyrelia","zynara","bromnor"]:hero="sylas"
	Playtest.visible=false;Game.qa_sandbox=true;Game.qa_launch={"seed":4242}
	Game._save_path="user://l002-playtest-profile.json"
	Game.profile=Profile.new({"name":"L002 QA","welcome_seen":true})
	for id in Data.table("hqs"):Game.profile.data.hqs_seen[id]=true
	Game.profile.data.settings.reduced_impact="--reduced" in args
	Game.run_hero=hero;Game.run_stage="dagruve"
	var run: Node=load("res://ui/run.tscn").instantiate()
	add_child(run)
	if "--tou-um" in args:
		run.battle.visual_god="Tou Um"
		run.battle.visual_boon_selected=true
	print("QA L002 launcher: ",hero," reduced=",Game.reduced_impact()," god=",run.battle.visual_god)
