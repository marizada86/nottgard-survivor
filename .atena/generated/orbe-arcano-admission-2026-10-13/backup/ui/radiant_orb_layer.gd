extends Node2D
## One additive canvas for all supported flights and a bounded set of brief hits.

var battle: Battle
var clock := 0.0
var impacts: Array[Dictionary] = []

func _ready() -> void:
	var additive := CanvasItemMaterial.new()
	additive.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	material = additive

func can_draw_projectile(projectile: Dictionary) -> bool:
	return visible and RadiantOrbVfx.supports_projectile(projectile, Game.reduced_impact()) and RadiantOrbVfx.texture(RadiantOrbVfx.FLIGHT_PATH) != null

func spawn_impact(event: Dictionary) -> bool:
	if not RadiantOrbVfx.supports_hit(event, Game.reduced_impact()) or RadiantOrbVfx.texture(RadiantOrbVfx.IMPACT_PATH) == null or impacts.size() >= RadiantOrbVfx.MAX_IMPACTS:
		return false
	var theme: Dictionary = event.get("visual_theme", DivineVisuals.resolve(battle.hero.id, battle.visual_god, battle.visual_boon_selected))
	impacts.append({"pos": RadiantOrbVfx.screen_position(event.pos), "color": theme.impact_accent, "age": 0.0})
	queue_redraw()
	return true

func _process(dt: float) -> void:
	if battle == null:
		return
	if Game.reduced_impact() or battle.state in ["dead", "won"]:
		impacts.clear()
	if battle.state == "running" and not get_tree().paused:
		clock += dt
		var keep: Array[Dictionary] = []
		for impact in impacts:
			impact.age += dt
			if float(impact.age) < RadiantOrbVfx.IMPACT_DURATION:
				keep.append(impact)
		impacts = keep
	queue_redraw()

func _draw_frame(texture: Texture2D, frame: int, pos: Vector2, angle: float, scale_value: float, color: Color) -> void:
	draw_set_transform(pos, angle, Vector2.ONE * scale_value)
	draw_texture_rect_region(texture, Rect2(-128, -128, 256, 256), Rect2(frame * 256, 0, 256, 256), color)

func _draw() -> void:
	if battle == null or Game.reduced_impact():
		return
	var flight := RadiantOrbVfx.texture(RadiantOrbVfx.FLIGHT_PATH)
	if flight != null:
		for projectile in battle.projectiles:
			if not can_draw_projectile(projectile):
				continue
			var theme: Dictionary = projectile.get("visual_theme", DivineVisuals.resolve(battle.hero.id, battle.visual_god, battle.visual_boon_selected))
			_draw_frame(flight, RadiantOrbVfx.flight_frame(clock), RadiantOrbVfx.screen_position(projectile.pos), RadiantOrbVfx.flight_angle(projectile.dir), RadiantOrbVfx.FLIGHT_SCALE, theme.primary)
	var impact_texture := RadiantOrbVfx.texture(RadiantOrbVfx.IMPACT_PATH)
	if impact_texture != null:
		for impact in impacts:
			_draw_frame(impact_texture, RadiantOrbVfx.impact_frame(impact.age), impact.pos, 0.0, RadiantOrbVfx.IMPACT_SCALE, impact.color)
	draw_set_transform(Vector2.ZERO)
