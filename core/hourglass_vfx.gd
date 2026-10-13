class_name HourglassVfx
extends RefCounted
## Visual-only presentation of the ampulheta weapon's existing magical nova.

const TEXTURE_PATH := "res://assets/vfx/ampulheta_silencio.png"
const DURATION := RadiantPulseVfx.DURATION
const PEAK_RING_RADIUS := 88.0
static var _frames: SpriteFrames

static func supports(event: Dictionary, reduced_impact: bool = false) -> bool:
	return not reduced_impact and event.get("type", "") == "nova" and event.get("dtype", "") == "magico" and event.get("weapon", "") == "ampulheta" and float(event.get("radius", 0.0)) > 0.0

static func scale_for_radius(radius: float) -> Vector2:
	return Vector2(Iso.TILE_W, Iso.TILE_H) * (radius * sqrt(2.0) * 0.5 / PEAK_RING_RADIUS)

static func create_effect(event: Dictionary, color: Color, reduced_impact: bool = false) -> Node2D:
	if not supports(event, reduced_impact):
		return null
	if _frames == null:
		if not ResourceLoader.exists(TEXTURE_PATH):
			return null
		_frames = RadiantPulseVfx.frames_from_texture(load(TEXTURE_PATH) as Texture2D)
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
