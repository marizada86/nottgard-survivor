class_name RadiantPulseVfx
extends RefCounted
## Visual-only pulse. Radius and timing come from the existing nova presentation.

const TEXTURE_PATH := "res://assets/vfx/pulso_radiante.png"
const CELL := 256
const FRAME_COUNT := 6
const DURATION := 0.35
## Dominant luminous annulus measured in the accepted peak after reduction.
const PEAK_RING_RADIUS := 88.0
const WEAPONS := ["sentenca_de_lliira", "julgamento_da_gloria", "descarga_estelar", "chuva_de_estrelas", "vela_sagrada", "sopro_de_estrela", "constelacao_de_silva"]
static var _frames: SpriteFrames

static func supports(event: Dictionary, reduced_impact: bool = false) -> bool:
	return not reduced_impact and event.get("type", "") == "nova" and event.get("dtype", "") == "radiante" and WEAPONS.has(String(event.get("weapon", ""))) and float(event.get("radius", 0.0)) > 0.0

static func scale_for_radius(radius: float) -> Vector2:
	# The extrema of Iso.to_screen's ground circle include sqrt(2).
	return Vector2(Iso.TILE_W, Iso.TILE_H) * (radius * sqrt(2.0) * 0.5 / PEAK_RING_RADIUS)

static func frames_from_texture(texture: Texture2D) -> SpriteFrames:
	if texture == null or texture.get_size() != Vector2(CELL * FRAME_COUNT, CELL):
		return null
	var frames := SpriteFrames.new()
	frames.set_animation_loop(&"default", false)
	frames.set_animation_speed(&"default", FRAME_COUNT / DURATION)
	for index in FRAME_COUNT:
		var region := AtlasTexture.new()
		region.atlas = texture
		region.region = Rect2(index * CELL, 0, CELL, CELL)
		frames.add_frame(&"default", region)
	return frames

static func create_effect(event: Dictionary, color: Color, reduced_impact: bool = false) -> Node2D:
	if not supports(event, reduced_impact):
		return null
	if _frames == null:
		if not ResourceLoader.exists(TEXTURE_PATH):
			return null
		_frames = frames_from_texture(load(TEXTURE_PATH) as Texture2D)
		if _frames == null:
			return null
	var root := Node2D.new()
	root.position = Iso.to_screen(event.pos)
	var sprite := AnimatedSprite2D.new()
	sprite.sprite_frames = _frames
	sprite.scale = scale_for_radius(float(event.radius))
	sprite.modulate = color
	var material := CanvasItemMaterial.new()
	material.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	sprite.material = material
	root.add_child(sprite)
	sprite.animation_finished.connect(root.queue_free)
	sprite.play(&"default")
	return root
