@tool
class_name SpriteStripFrames
extends RefCounted
## Constrói SpriteFrames a partir das tiras horizontais normalizadas em assets/animations/.

static func add_strip(frames: SpriteFrames, animation: StringName, path: String, frame_size: Vector2i, frame_count: int, fps: float, looped: bool) -> bool:
	if not ResourceLoader.exists(path):
		return false
	if frames.has_animation(animation):
		frames.remove_animation(animation)
	frames.add_animation(animation)
	frames.set_animation_speed(animation, fps)
	frames.set_animation_loop(animation, looped)
	var texture: Texture2D = load(path)
	for index in frame_count:
		var atlas := AtlasTexture.new()
		atlas.atlas = texture
		atlas.region = Rect2(index * frame_size.x, 0, frame_size.x, frame_size.y)
		frames.add_frame(animation, atlas)
	return true

static func empty() -> SpriteFrames:
	var frames := SpriteFrames.new()
	if frames.has_animation(&"default"):
		frames.remove_animation(&"default")
	return frames
