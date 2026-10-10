extends Node
## Fumaça: abre o menu e cada fase (run.tscn) por alguns quadros. Uso: godot --headless --path . res://tools/smoke.tscn

func _ready() -> void:
	Playtest.visible = false
	# Perfil e save descartaveis: abrir cada fase marca a fase como alcancada e salva; sem isto o save real do jogador e alterado
	Game._save_path = "user://smoke-profile.json"
	Game.profile = Profile.new({"name": "Fumaca", "welcome_seen": true})
	var menu: Node = load("res://ui/menu.tscn").instantiate()
	add_child(menu)
	await get_tree().create_timer(0.3).timeout
	menu.queue_free()
	for sid in Data.table("stages"):
		Game.run_stage = sid
		Game.run_hero = "durvall"
		var run: Node = load("res://ui/run.tscn").instantiate()
		add_child(run)
		for i in 90:
			await get_tree().physics_frame
		run.battle.hero.hp = run.battle.hero.max_hp
		print("smoke %s: inimigos=%d estado=%s" % [sid, run.battle.enemies.size(), run.battle.state])
		run.queue_free()
		await get_tree().process_frame
	print("smoke: ok")
	get_tree().quit()
