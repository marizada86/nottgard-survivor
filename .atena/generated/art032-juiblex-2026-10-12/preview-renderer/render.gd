extends SceneTree

var output_viewport: SubViewport

class ReviewCanvas extends Node2D:
	var cards: Array = []
	var textures: Array[Texture2D] = []
	var font: Font = ThemeDB.fallback_font

	func _draw() -> void:
		draw_string(font, Vector2(24, 30), "ART-032 / JUIBLEX / v01 - MJ01 v03 DRAFT", HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color(0.85, 0.75, 0.5))
		draw_string(font, Vector2(24, 53), "Comparação pela mesma altura visível, sem escala runtime. Aceite visual pendente.", HORIZONTAL_ALIGNMENT_LEFT, -1, 15)
		for i in range(cards.size()):
			var x := 24.0 + i * 325.0
			var y := 83.0
			var card: Dictionary = cards[i]
			var box: Array = card.bbox_alpha_above8
			var region := Rect2(float(box[0]), float(box[1]), float(box[2] - box[0]), float(box[3] - box[1]))
			draw_string(font, Vector2(x, y), card.title, HORIZONTAL_ALIGNMENT_LEFT, 305, 16)
			draw_rect(Rect2(x, y + 12, 305, 262), Color(0.15, 0.16, 0.21))
			var native_size: Vector2 = textures[i].get_size()
			var fit := minf(250.0 / native_size.x, 250.0 / native_size.y)
			var display_size := native_size * fit
			draw_texture_rect(textures[i], Rect2(Vector2(x + (305.0 - display_size.x) / 2.0, y + 18 + (250.0 - display_size.y) / 2.0), display_size), false)
			draw_string(font, Vector2(x, y + 295), "Fonte %d×%d RGBA" % [card.size[0], card.size[1]], HORIZONTAL_ALIGNMENT_LEFT, -1, 13)
			for k in range(card.preview_heights.size()):
				var height: float = float(card.preview_heights[k])
				var width := region.size.x / region.size.y * height
				var bottom := y + 420.0 + k * 170.0
				draw_texture_rect_region(textures[i], Rect2(x + (305.0 - width) / 2.0, bottom - height, width, height), region)
				draw_string(font, Vector2(x + 117, bottom + 20), "%d px" % height, HORIZONTAL_ALIGNMENT_LEFT, -1, 14)
		draw_string(font, Vector2(24, 758), "Candidata ativa DRAFT | Receptáculo runtime intacto | Massa dormente DRAFT já aceita", HORIZONTAL_ALIGNMENT_LEFT, -1, 15)
		draw_string(font, Vector2(24, 785), "Fontes intactas, recorte em memória; sem CANON, admissão ou integração.", HORIZONTAL_ALIGNMENT_LEFT, -1, 14)

func _initialize() -> void:
	var package: String = ProjectSettings.globalize_path(get_script().resource_path).get_base_dir().get_base_dir()
	var root: String = package.get_base_dir().get_base_dir().get_base_dir()
	var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(package.path_join("jobs.json")))
	var canvas := ReviewCanvas.new()
	canvas.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	canvas.cards = data.comparison_cards
	for card in canvas.cards:
		var image := Image.load_from_file(root.path_join(str(card.path)))
		if image == null:
			push_error("Comparison source load failed: " + str(card.path))
			quit(1)
			return
		canvas.textures.append(ImageTexture.create_from_image(image))
	output_viewport = SubViewport.new()
	output_viewport.size = Vector2i(1000, 810)
	output_viewport.disable_3d = true
	output_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	get_root().add_child(output_viewport)
	output_viewport.add_child(canvas)
	_capture.call_deferred(package)

func _capture(package: String) -> void:
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	var output := package.path_join("review-reading.png")
	var error := output_viewport.get_texture().get_image().save_png(output)
	if error != OK:
		push_error("Preview save failed: " + str(error))
		quit(1)
		return
	print("Rendered six comparative previews in Godot; native image pixels unchanged: " + output)
	quit(0)
