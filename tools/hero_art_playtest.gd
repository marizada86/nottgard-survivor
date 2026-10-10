extends Node

func _ready() -> void:
	var args := OS.get_cmdline_user_args()
	var hero: String = args[0] if args.size() > 0 else "erik"
	if hero not in ["arlindo", "erik"]: hero = "erik"
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 4242}
	Game._save_path = "user://hero-art-playtest-profile.json"
	Game.profile = Profile.new({"name": "Arte QA", "welcome_seen": true})
	Game.profile.data["hqs_seen"] = {}
	for id in Data.table("hqs"): Game.profile.data["hqs_seen"][id] = true
	Game.run_stage = "dagruve"
	Game.run_hero = hero
	add_child(load("res://ui/run.tscn").instantiate())
