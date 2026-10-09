extends SceneTree

func _init() -> void:
	call_deferred("_check")

func _check() -> void:
	var battle := Battle.new(17, "durvall", "pilares")
	var actor := Enemy.make("sintese_abissal", battle.hero.pos + Vector2(2, 0))
	var view: Node2D = load("res://ui/enemy_view.tscn").instantiate()
	root.add_child(view)
	view.setup(actor)
	var run = load("res://ui/run.gd").new()
	run.battle = battle
	run.enemy_nodes[actor] = view
	for ability_name in ["aoe", "summon", "ring"]:
		battle.events.clear()
		var ability: Dictionary = {}
		for candidate in actor.abilities:
			if candidate.t == ability_name: ability = candidate
		assert(not ability.is_empty())
		assert(battle._use_ability(actor, 0, ability, 2.0, battle.hero.pos - actor.pos))
		var emitted := false
		for event in battle.events:
			if ability_name == "aoe":
				emitted = emitted or (event.type == "telegraph" and event.enemy_id == actor.id)
			else:
				emitted = emitted or (event.type == "enemy_action" and event.enemy_id == actor.id and event.ability == ability_name)
		assert(emitted)
		# Fixture exercises animation routing; summon text needs unrelated HUD/Fx nodes.
		battle.events = battle.events.filter(func(event): return event.type in ["telegraph", "enemy_action"])
		run._consume_events()
		assert(battle.events.is_empty())
		assert(view.sprite.animation == &"special" and view._action_locked)
		await create_timer(0.65).timeout
		assert(not view._action_locked)
	battle.events.clear()
	var normal_ability: Dictionary = {}
	for candidate in actor.abilities:
		if candidate.t == "puddle": normal_ability = candidate
	assert(not normal_ability.is_empty())
	assert(battle._use_ability(actor, 0, normal_ability, 2.0, battle.hero.pos - actor.pos))
	battle.events = battle.events.filter(func(event): return event.type in ["telegraph", "enemy_action"])
	run._consume_events()
	assert(view.sprite.animation == &"attack")
	view.queue_free()
	run.battle = null
	run.free()
	print("Sintese Abissal trigger: actual aoe telegraph/summon/ring -> special, unlock and puddle -> attack OK")
	quit()
