class_name ProjectileVfx
extends RefCounted
## Visual-only flight and impact sprites for hero bolts. Position, speed, damage and collision stay in Battle.
## Atlas layout: eight 256x256 cells, flight 0-3 (loops) and impact 4-7 (one shot), pivot at the cell centre.

const CELL := 256
const FLIGHT_FRAMES := 4
const IMPACT_FRAMES := 4
const FLIGHT_FPS := 12.0
const IMPACT_DURATION := 0.30
## The same ground-contact lift the old circle used, so the sprite sits where the circle did.
const LIFT := Vector2(0, -16)
## `scale` is DRAFT calibration (screen px per art px); `pivot_x` is the light centroid measured on the flight frames.
const FAMILIES := {
	&"orbe_radiante": {"path": "res://assets/vfx/orbe_radiante.png", "dtype": "radiante", "scale": 0.45, "pivot_x": 124.0,
		"weapons": ["raio_de_luz", "luz_mais_pura", "marca_da_retidao", "constelacao"]},
	&"orbe_arcano": {"path": "res://assets/vfx/orbe_arcano.png", "dtype": "magico", "scale": 0.45, "pivot_x": 124.0,
		"weapons": ["raio_enfraquecedor", "dominar_pessoa", "cajado_dos_desejos", "raio_da_ruina", "dominio_coletivo"]},
	&"onda_cortante": {"path": "res://assets/vfx/onda_cortante.png", "dtype": "magico", "scale": 0.5, "pivot_x": 147.0,
		"weapons": ["lamina_trovejante", "tempestade"]},
}
static var _frames: Dictionary = {}

static func weapon_id(projectile: Dictionary) -> String:
	var p: Dictionary = projectile.get("p", {})
	return String(p.get("_audio_id", p.get("id", "")))

static func family_for(projectile: Dictionary) -> StringName:
	if String(projectile.get("owner", "")) != "hero":
		return &""
	var id := weapon_id(projectile)
	var dtype := String(projectile.get("p", {}).get("dtype", ""))
	for family in FAMILIES:
		var spec: Dictionary = FAMILIES[family]
		if spec.dtype == dtype and (spec.weapons as Array).has(id):
			return family
	return &""

static func handles(projectile: Dictionary, reduced_impact: bool = false) -> bool:
	if reduced_impact:
		return false
	var family := family_for(projectile)
	return family != &"" and not frames_for(family).is_empty()

## {"flight": SpriteFrames, "impact": SpriteFrames}, or {} when the atlas is missing or has the wrong size.
static func frames_for(family: StringName) -> Dictionary:
	if _frames.has(family):
		return _frames[family]
	var spec: Dictionary = FAMILIES.get(family, {})
	var built := {}
	if not spec.is_empty() and ResourceLoader.exists(spec.path):
		built = frames_from_texture(load(spec.path) as Texture2D)
	if not built.is_empty():
		_frames[family] = built
	return built

static func frames_from_texture(texture: Texture2D) -> Dictionary:
	if texture == null or texture.get_size() != Vector2(CELL * (FLIGHT_FRAMES + IMPACT_FRAMES), CELL):
		return {}
	var flight := SpriteFrames.new()
	flight.set_animation_loop(&"default", true)
	flight.set_animation_speed(&"default", FLIGHT_FPS)
	var impact := SpriteFrames.new()
	impact.set_animation_loop(&"default", false)
	impact.set_animation_speed(&"default", IMPACT_FRAMES / IMPACT_DURATION)
	for index in FLIGHT_FRAMES + IMPACT_FRAMES:
		var region := AtlasTexture.new()
		region.atlas = texture
		region.region = Rect2(index * CELL, 0, CELL, CELL)
		(flight if index < FLIGHT_FRAMES else impact).add_frame(&"default", region)
	return {"flight": flight, "impact": impact}

static func _additive() -> CanvasItemMaterial:
	var material := CanvasItemMaterial.new()
	material.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	return material

## Rotation of the flat sprite so its head follows the on-screen heading of a ground direction.
static func rotation_for(dir: Vector2) -> float:
	return Iso.to_screen(dir).angle()

static func screen_position(ground: Vector2) -> Vector2:
	return Iso.to_screen(ground) + LIFT

static func create_flight(projectile: Dictionary, color: Color) -> AnimatedSprite2D:
	var family := family_for(projectile)
	var frames := frames_for(family)
	if family == &"" or frames.is_empty():
		return null
	var spec: Dictionary = FAMILIES[family]
	var sprite := AnimatedSprite2D.new()
	sprite.sprite_frames = frames.flight
	sprite.scale = Vector2.ONE * float(spec.scale)
	sprite.offset = Vector2(CELL * 0.5 - float(spec.pivot_x), 0.0)
	sprite.modulate = color
	sprite.material = _additive()
	sprite.position = screen_position(projectile.pos)
	sprite.rotation = rotation_for(projectile.dir)
	sprite.play(&"default")
	return sprite

static func create_impact(family: StringName, ground: Vector2, color: Color) -> Node2D:
	var frames := frames_for(family)
	if frames.is_empty():
		return null
	var root := Node2D.new()
	root.position = screen_position(ground)
	var sprite := AnimatedSprite2D.new()
	sprite.sprite_frames = frames.impact
	sprite.scale = Vector2.ONE * float(FAMILIES[family].scale)
	sprite.modulate = color
	sprite.material = _additive()
	root.add_child(sprite)
	sprite.animation_finished.connect(root.queue_free)
	sprite.play(&"default")
	return root
