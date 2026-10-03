extends SceneTree
## Limpeza técnica autorizada pelo dono em 2026-10-02. Não altera RGB nem a pose.

func _init() -> void:
	var review := Image.create(768, 384, false, Image.FORMAT_RGBA8)
	review.fill(Color("24242e"))
	var column := 0
	for id in ["bolha_de_slime", "cultista_thullgrime", "blogbog"]:
		var version := "03" if id == "bolha_de_slime" else "02"
		var base := "res://.atena/generated/art-candidates/enemies-molor/%s/%s_idle_00" % [id, id]
		var image := Image.load_from_file(base + "_v%s.png" % version)
		if image == null:
			quit(1)
			return
		image.convert(Image.FORMAT_RGBA8)
		# Interior e contorno concentram alfa 251–254; o halo forma a cauda abaixo.
		for y in image.get_height():
			for x in image.get_width():
				var color := image.get_pixel(x, y)
				color = Color(color, 1.0) if color.a >= 250.5 / 255.0 else Color.TRANSPARENT
				image.set_pixel(x, y, color)
		var result := image.save_png(base + "_alpha_clean.png")
		print(id, " alpha clean result=", result, " rect=", image.get_used_rect())
		if result != OK:
			quit(1)
			return
		var region := image.get_region(image.get_used_rect())
		var fit := minf(232.0 / region.get_width(), 360.0 / region.get_height())
		region.resize(int(round(region.get_width() * fit)), int(round(region.get_height() * fit)), Image.INTERPOLATE_NEAREST)
		_remove_islands(region)
		var frame := Image.create(256, 384, false, Image.FORMAT_RGBA8)
		frame.blit_rect(region, Rect2i(Vector2i.ZERO, region.get_size()), Vector2i((256 - region.get_width()) / 2, 372 - region.get_height()))
		frame.save_png(base + "_review.png")
		review.blend_rect(frame, Rect2i(Vector2i.ZERO, frame.get_size()), Vector2i(column * 256, 0))
		column += 1
	review.save_png("res://.atena/generated/priority-review/molor_identities_clean.png")
	quit()

func _remove_islands(image: Image) -> void:
	var width := image.get_width()
	var height := image.get_height()
	var visited := PackedByteArray()
	visited.resize(width * height)
	for y in height:
		for x in width:
			var start := y * width + x
			if visited[start] != 0 or image.get_pixel(x, y).a == 0:
				continue
			var component := PackedInt32Array([start])
			visited[start] = 1
			var index := 0
			while index < component.size():
				var pixel := component[index]
				index += 1
				var at := Vector2i(pixel % width, pixel / width)
				for offset in [Vector2i(-1, 0), Vector2i(1, 0), Vector2i(0, -1), Vector2i(0, 1)]:
					var next: Vector2i = at + offset
					if next.x < 0 or next.x >= width or next.y < 0 or next.y >= height:
						continue
					var next_id: int = next.y * width + next.x
					if visited[next_id] == 0 and image.get_pixelv(next).a > 0:
						visited[next_id] = 1
						component.append(next_id)
			if component.size() <= 3:
				for pixel in component:
					image.set_pixel(pixel % width, pixel / width, Color.TRANSPARENT)
