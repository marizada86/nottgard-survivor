extends SceneTree
## Produz uma candidata repetível e um preview 3×3 sem tocar em assets oficiais.

const SOURCE := "res://.atena/generated/art-candidates/lote-1/nevoa_textura_01_v03.png"
const OUTPUT := "res://.atena/generated/art-candidates/lote-1/nevoa_textura_01_v03_seamless.png"
const PREVIEW := "res://.atena/generated/art-candidates/lote-1/nevoa_textura_01_v03-tile-preview.png"
const APPROVED := "res://.atena/generated/art-candidates/lote-1/approved/nevoa_textura_01.png"

func _init() -> void:
	var source := Image.new()
	if source.load(SOURCE) != OK:
		printerr("failed to load fog source")
		quit(1)
		return
	source.convert(Image.FORMAT_RGBA8)
	var blended := source.duplicate()
	var band := 64
	for y in source.get_height():
		for offset in band:
			var weight: float = float(band - offset) / float(band * 2)
			var left_x: int = offset
			var right_x: int = source.get_width() - 1 - offset
			var left: Color = source.get_pixel(left_x, y)
			var right: Color = source.get_pixel(right_x, y)
			blended.set_pixel(left_x, y, left.lerp(right, weight))
			blended.set_pixel(right_x, y, right.lerp(left, weight))
	var horizontal := blended.duplicate()
	for x in horizontal.get_width():
		for offset in band:
			var weight: float = float(band - offset) / float(band * 2)
			var top_y: int = offset
			var bottom_y: int = horizontal.get_height() - 1 - offset
			var top: Color = horizontal.get_pixel(x, top_y)
			var bottom: Color = horizontal.get_pixel(x, bottom_y)
			blended.set_pixel(x, top_y, top.lerp(bottom, weight))
			blended.set_pixel(x, bottom_y, bottom.lerp(top, weight))
	if blended.save_png(OUTPUT) != OK:
		printerr("failed to save seamless fog")
		quit(1)
		return
	var alpha_texture := blended.duplicate()
	for y in alpha_texture.get_height():
		for x in alpha_texture.get_width():
			var pixel: Color = alpha_texture.get_pixel(x, y)
			var alpha: float = 0.2126 * pixel.r + 0.7152 * pixel.g + 0.0722 * pixel.b
			alpha_texture.set_pixel(x, y, Color(0.88, 0.91, 0.94, alpha))
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(APPROVED.get_base_dir()))
	if alpha_texture.save_png(APPROVED) != OK:
		printerr("failed to save approved fog")
		quit(1)
		return
	var thumbnail := blended.duplicate()
	thumbnail.resize(256, 256, Image.INTERPOLATE_LANCZOS)
	var preview := Image.create(768, 768, false, Image.FORMAT_RGBA8)
	for y in 3:
		for x in 3:
			preview.blit_rect(thumbnail, Rect2i(Vector2i.ZERO, thumbnail.get_size()), Vector2i(x * 256, y * 256))
	preview.save_png(PREVIEW)
	print("fog texture normalized")
	quit()
