extends SceneTree

var output_viewport: SubViewport

class ReviewCanvas extends Node2D:
	var jobs: Array = []
	var textures: Array[Texture2D] = []
	var font: Font = ThemeDB.fallback_font

	func _draw() -> void:
		draw_string(font, Vector2(24, 30), "ART-032 / LOTE02 / v01 - seis candidatas DRAFT", HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color(0.85, 0.75, 0.5))
		draw_string(font, Vector2(24, 52), "Prévia de leitura: recorte em memória. Fontes originais intactas. Aceite visual pendente.", HORIZONTAL_ALIGNMENT_LEFT, -1, 15)
		for i in range(jobs.size()):
			var x := 24.0 + (i % 3) * 325.0
			var y := 83.0 + floori(i / 3.0) * 510.0
			var job: Dictionary = jobs[i]
			var box: Array = job.audit.bbox_alpha_above8
			var region := Rect2(float(box[0]), float(box[1]), float(box[2] - box[0]), float(box[3] - box[1]))
			draw_string(font, Vector2(x, y), "%s %s · %s" % [job.code, job.revision, job.title], HORIZONTAL_ALIGNMENT_LEFT, 305, 16)
			draw_rect(Rect2(x, y + 12, 305, 262), Color(0.15, 0.16, 0.21))
			draw_texture_rect(textures[i], Rect2(x + 27, y + 12, 250, 250), false)
			draw_string(font, Vector2(x, y + 295), "Nativo: 1254×1254 RGBA", HORIZONTAL_ALIGNMENT_LEFT, -1, 13)
			var offset := 12.0
			for height in job.preview_heights:
				var width := region.size.x / region.size.y * float(height)
				draw_texture_rect_region(textures[i], Rect2(x + offset, y + 432 - height, width, height), region)
				draw_string(font, Vector2(x + offset, y + 452), "%d px" % height, HORIZONTAL_ALIGNMENT_LEFT, -1, 14)
				offset += width + 32.0
		draw_string(font, Vector2(24, 1100), "Aparências/figurinos propostos DRAFT. Sem CANON, admissão ou integração no jogo.", HORIZONTAL_ALIGNMENT_LEFT, -1, 15)

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
	output_viewport = SubViewport.new()
	output_viewport.size = Vector2i(1000, 1120)
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
	print("Rendered seven reading previews in Godot; native image pixels unchanged: " + output)
	quit(0)
