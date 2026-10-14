extends Node2D
## One bounded visual tied to a successful active; never writes to Battle.

var battle: Battle
var hero_id := ""
var radius := 0.0
var sprite: AnimatedSprite2D
var age := 0.0

func _ready() -> void:
	_process(0.0)

func _process(dt: float) -> void:
	if battle == null or battle.hero.id != hero_id or Game.reduced_impact() or battle.state in ["dead","won"]:
		queue_free()
		return
	if hero_id == "brook" and (battle.active_guard <= 0 or battle.active_guard_t <= 0.0):
		queue_free()
		return
	position = Iso.to_screen(battle.hero.pos)
	if battle.state == "running" and not get_tree().paused:
		age += dt*battle.speed_scale()
	if hero_id == "maelor" and age >= HeroActiveVfx.MAELOR_DURATION:
		queue_free()
		return
	var fps: float = HeroActiveVfx.CONFIG[hero_id].fps
	sprite.frame = int(floor(age*fps))%6
