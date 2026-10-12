class_name HappeningArt
extends RefCounted
## Source pixels are padded for safe imports; event geometry uses the visible body.

static var _rects: Dictionary = {}

static func source_rect(texture: Texture2D) -> Rect2:
	var key := texture.get_instance_id()
	if not _rects.has(key):
		var image := texture.get_image()
		var used := image.get_used_rect() if image != null else Rect2i(Vector2i.ZERO, Vector2i(texture.get_size()))
		_rects[key] = Rect2(used) if used.has_area() else Rect2(Vector2.ZERO, texture.get_size())
	return _rects[key]

static func destination_rect(texture: Texture2D, ground: Vector2, visible_height: float) -> Rect2:
	var source := source_rect(texture)
	var width := visible_height * source.size.x / maxf(1.0, source.size.y)
	return Rect2(ground - Vector2(width * 0.5, visible_height), Vector2(width, visible_height))
