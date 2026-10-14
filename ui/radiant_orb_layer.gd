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
	var family := _flight_family(projectile)
	return visible and family != null and RadiantOrbVfx.texture(family.FLIGHT_PATH) != null

func _flight_family(projectile: Dictionary) -> GDScript:
	if RadiantOrbVfx.supports_projectile(projectile, Game.reduced_impact()): return RadiantOrbVfx
	if ArcaneOrbVfx.supports_projectile(projectile, Game.reduced_impact()): return ArcaneOrbVfx
	if CuttingWaveVfx.supports_projectile(projectile, Game.reduced_impact()): return CuttingWaveVfx
	return null

func _impact_family(event: Dictionary) -> GDScript:
	if RadiantOrbVfx.supports_hit(event, Game.reduced_impact()): return RadiantOrbVfx
	if ArcaneOrbVfx.supports_hit(event, Game.reduced_impact()): return ArcaneOrbVfx
	if CuttingWaveVfx.supports_hit(event, Game.reduced_impact()): return CuttingWaveVfx
	return null

func spawn_impact(event: Dictionary) -> bool:
	var family := _impact_family(event)
	if family == null or RadiantOrbVfx.texture(family.IMPACT_PATH) == null or impacts.size() >= RadiantOrbVfx.MAX_IMPACTS:
		return false
	var theme: Dictionary = event.get("visual_theme", DivineVisuals.resolve(battle.hero.id, battle.visual_god, battle.visual_boon_selected))
	impacts.append({"pos": RadiantOrbVfx.screen_position(event.pos), "color": theme.impact_accent, "age": 0.0, "family": family})
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

func _draw_frame(texture: Texture2D, frame: int, pos: Vector2, angle: float, scale_value: float, color: Color, pivot := Vector2(128, 128)) -> void:
	draw_set_transform(pos, angle, Vector2.ONE * scale_value)
	draw_texture_rect_region(texture, Rect2(-pivot, Vector2(256, 256)), Rect2(frame * 256, 0, 256, 256), color)

func _draw() -> void:
	if battle == null or Game.reduced_impact():
		return
	for projectile in battle.projectiles:
		var family := _flight_family(projectile)
		if family == null or not visible: continue
		var flight := RadiantOrbVfx.texture(family.FLIGHT_PATH)
		if flight == null: continue
		var theme: Dictionary = projectile.get("visual_theme", DivineVisuals.resolve(battle.hero.id, battle.visual_god, battle.visual_boon_selected))
		var pivot: Vector2 = family.FLIGHT_PIVOT if family != RadiantOrbVfx else Vector2(128, 128)
		_draw_frame(flight, RadiantOrbVfx.flight_frame(clock), RadiantOrbVfx.screen_position(projectile.pos), RadiantOrbVfx.flight_angle(projectile.dir), family.FLIGHT_SCALE, theme.primary, pivot)
	for impact in impacts:
		var family: GDScript = impact.family
		var impact_texture := RadiantOrbVfx.texture(family.IMPACT_PATH)
		if impact_texture == null: continue
		var pivot: Vector2 = family.IMPACT_PIVOT if family != RadiantOrbVfx else Vector2(128, 128)
		_draw_frame(impact_texture, RadiantOrbVfx.impact_frame(impact.age), impact.pos, 0.0, family.IMPACT_SCALE, impact.color, pivot)
	draw_set_transform(Vector2.ZERO)
