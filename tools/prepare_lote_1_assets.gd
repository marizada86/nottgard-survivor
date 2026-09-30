extends SceneTree
## Normaliza os candidatos aprovados do Lote 1 sem tocar nas fontes brutas.

const SOURCE_DIR := "res://.atena/generated/art-candidates/lote-1"
const OUTPUT_DIR := "res://.atena/generated/art-candidates/lote-1/approved"

func _init() -> void:
	if "texture" in OS.get_cmdline_user_args():
		_prepare_pending_texture()
		quit()
		return
	var jobs := [
		{"source": "nevoa_borda_01_v01.png", "output": "nevoa_borda_01.png", "size": Vector2i(1280, 360), "luminance_alpha": true},
		{"source": "bau_chefe_fechado_v01.png", "output": "bau_chefe_fechado.png", "size": Vector2i(192, 192), "luminance_alpha": false},
		{"source": "bau_chefe_aberto_v01.png", "output": "bau_chefe_aberto.png", "size": Vector2i(192, 192), "luminance_alpha": false},
		{"source": "ima_xp_v01.png", "output": "magnet.png", "size": Vector2i(64, 64), "luminance_alpha": false},
		{"source": "npc_loja_v01.png", "output": "loja.png", "size": Vector2i(256, 256), "luminance_alpha": false},
		{"source": "npc_ferreiro_v01.png", "output": "ferreiro.png", "size": Vector2i(256, 256), "luminance_alpha": false},
		{"source": "npc_curandeiro_v01.png", "output": "curandeiro.png", "size": Vector2i(256, 256), "luminance_alpha": false},
	]
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUTPUT_DIR))
	for job: Dictionary in jobs:
		var source_path := "%s/%s" % [SOURCE_DIR, job.source]
		var output_path := "%s/%s" % [OUTPUT_DIR, job.output]
		var image := Image.new()
		if image.load(source_path) != OK:
			printerr("failed to load: %s" % source_path)
			quit(1)
			return
		if bool(job.luminance_alpha):
			_luminance_to_alpha(image)
		image.resize(job.size.x, job.size.y, Image.INTERPOLATE_LANCZOS)
		if image.save_png(output_path) != OK:
			printerr("failed to save: %s" % output_path)
			quit(1)
			return
		print("prepared=%s size=%s alpha=%s" % [output_path, image.get_size(), image.detect_alpha()])
	quit()

func _prepare_pending_texture() -> void:
	var source_path := "%s/nevoa_textura_01_v03.png" % SOURCE_DIR
	var output_path := "%s/nevoa_textura_01_v03_seamless.png" % SOURCE_DIR
	var preview_path := "%s/nevoa_textura_01_v03-tile-preview.png" % SOURCE_DIR
	var source := Image.new()
	if source.load(source_path) != OK:
		printerr("failed to load: %s" % source_path)
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
	if blended.save_png(output_path) != OK:
		printerr("failed to save: %s" % output_path)
		return
	var thumbnail := blended.duplicate()
	thumbnail.resize(256, 256, Image.INTERPOLATE_LANCZOS)
	var preview := Image.create(768, 768, false, Image.FORMAT_RGBA8)
	for y in 3:
		for x in 3:
			preview.blit_rect(thumbnail, Rect2i(Vector2i.ZERO, thumbnail.get_size()), Vector2i(x * 256, y * 256))
	preview.save_png(preview_path)
	print("prepared_texture=%s edge_delta=%s" % [output_path, _edge_delta(blended)])

func _edge_delta(image: Image) -> Vector2:
	var horizontal := 0.0
	var vertical := 0.0
	for y in image.get_height():
		var left := image.get_pixel(0, y)
		var right := image.get_pixel(image.get_width() - 1, y)
		horizontal += absf(left.r - right.r) + absf(left.g - right.g) + absf(left.b - right.b)
	for x in image.get_width():
		var top := image.get_pixel(x, 0)
		var bottom := image.get_pixel(x, image.get_height() - 1)
		vertical += absf(top.r - bottom.r) + absf(top.g - bottom.g) + absf(top.b - bottom.b)
	return Vector2(horizontal / image.get_height(), vertical / image.get_width())

func _luminance_to_alpha(image: Image) -> void:
	image.convert(Image.FORMAT_RGBA8)
	for y in image.get_height():
		for x in image.get_width():
			var pixel := image.get_pixel(x, y)
			var alpha := 0.2126 * pixel.r + 0.7152 * pixel.g + 0.0722 * pixel.b
			image.set_pixel(x, y, Color(0.88, 0.91, 0.94, alpha))
