extends SceneTree

class ReviewCanvas extends Node2D:
	var jobs: Array = []
	var textures: Array[Texture2D] = []
	var font: Font = ThemeDB.fallback_font

	func _draw() -> void:
		draw_string(font, Vector2(24, 30), "ART-032 / v01 - DRAFT - fontes nativas e leitura", HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color(0.85, 0.75, 0.5))
		draw_string(font, Vector2(24, 52), "Previa de leitura: recorte em memoria, sem alterar os PNGs originais. Aceite visual pendente.", HORIZONTAL_ALIGNMENT_LEFT, -1, 15)
		for i in range(jobs.size()):
			var x := 24.0 + i * 245.0
			var job: Dictionary = jobs[i]
			var box: Array = job.audit.bbox_alpha_above8
			var region := Rect2(float(box[0]), float(box[1]), float(box[2] - box[0]), float(box[3] - box[1]))
			draw_string(font, Vector2(x, 86), "%s %s" % [job.code, job.revision], HORIZONTAL_ALIGNMENT_LEFT, -1, 18)
			draw_rect(Rect2(x, 100, 220, 270), Color(0.15, 0.16, 0.21))
			draw_texture_rect(textures[i], Rect2(x, 100, 220, 220), false)
			draw_string(font, Vector2(x, 348), "Native: 1254 x 1254 RGBA", HORIZONTAL_ALIGNMENT_LEFT, -1, 13)
			var offset := 0.0
			for height in job.preview_heights:
				var width := region.size.x / region.size.y * float(height)
				draw_texture_rect_region(textures[i], Rect2(x + offset, 394, width, height), region)
				draw_string(font, Vector2(x + offset, 498), "%d px" % height, HORIZONTAL_ALIGNMENT_LEFT, -1, 14)
				offset += width + 28.0
		draw_string(font, Vector2(24, 540), "NP01 Joao Barbosa | NP02 Desertor | NP03 Vitima | PT01 Estrela do Norte", HORIZONTAL_ALIGNMENT_LEFT, -1, 16)

func _initialize() -> void:
	var package: String = ProjectSettings.globalize_path(get_script().resource_path).get_base_dir().get_base_dir()
	var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(package.path_join("jobs.json")))
	var canvas := ReviewCanvas.new()
	canvas.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	canvas.jobs = data.jobs
	for job in data.jobs:
		var image := Image.load_from_file(package.path_join("sources").path_join(str(job.destination).get_file()))
		if image == null:
			push_error("Source load failed: " + str(job.destination))
			quit(1)
			return
		canvas.textures.append(ImageTexture.create_from_image(image))
	get_root().add_child(canvas)
	_capture.call_deferred(package)

func _capture(package: String) -> void:
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	var output := package.path_join("review-reading.png")
	var error := get_root().get_texture().get_image().save_png(output)
	if error != OK:
		push_error("Preview save failed: " + str(error))
		quit(1)
		return
	print("Rendered five reading previews in Godot; native image pixels unchanged: " + output)
	quit(0)
