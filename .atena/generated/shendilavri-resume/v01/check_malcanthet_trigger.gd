extends SceneTree

func _init() -> void:
	call_deferred("_check")

func _check() -> void:
	var battle := Battle.new(17, "durvall", "shendilavri")
	var actor := Enemy.make("malcanthet", battle.hero.pos + Vector2(2, 0))
	var view: Node2D = load("res://ui/enemy_view.tscn").instantiate()
	root.add_child(view)
	view.setup(actor)
	var run = load("res://ui/run.gd").new()
	run.battle = battle
	run.enemy_nodes[actor] = view
	battle.events.clear()
	var ability: Dictionary = {}
	for candidate in actor.abilities:
		if candidate.t == "aoe": ability = candidate
	assert(not ability.is_empty())
	assert(battle._use_ability(actor, 0, ability, 2.0, battle.hero.pos - actor.pos))
	assert(battle.zones.size() == 1)
	assert(battle.events.size() == 1 and battle.events[0].type == "telegraph")
	run._consume_events()
	assert(battle.events.is_empty())
	assert(view.sprite.animation == &"special" and view._action_locked)
	await create_timer(0.65).timeout
	assert(not view._action_locked)
	battle.events.append({"type": "enemy_action", "enemy_id": actor.id, "pos": actor.pos, "ability": "shoot"})
	run._consume_events()
	assert(view.sprite.animation == &"attack")
	view.queue_free()
	run.battle = null
	run.free()
	print("Malcanthet trigger: actual aoe telegraph -> special, unlock and shoot -> attack OK")
	quit()
