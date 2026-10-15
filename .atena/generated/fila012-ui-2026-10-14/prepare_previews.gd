extends SceneTree

var batch_root: String
var records: Array = []

func _initialize() -> void:
	batch_root = OS.get_cmdline_user_args()[0]
	DirAccess.make_dir_recursive_absolute(batch_root.path_join("previews"))
	var keyed: Dictionary = {}
	for code in ["U01", "U02", "U03", "U04"]:
		var image := Image.load_from_file(batch_root.path_join("native-sources/" + code + "_v01.png"))
		image.convert(Image.FORMAT_RGBA8)
		key_exterior(image)
		keyed[code] = image
		var bounds := image.get_used_rect()
		records.append({"code": code, "keyed_bounds": [bounds.position.x, bounds.position.y, bounds.size.x, bounds.size.y], "key_method": "magenta threshold flood from image border only", "runtime_admission": false})
		image.save_png(batch_root.path_join("previews/" + code + "-keyed.png"))
	var bar: Image = keyed["U01"].get_region(keyed["U01"].get_used_rect())
	for width in [180, 360, 720]:
		var copy := bar.duplicate() as Image
		copy.resize(width, maxi(1, roundi(float(bar.get_height()) * width / bar.get_width())), Image.INTERPOLATE_NEAREST)
		copy.save_png(batch_root.path_join("previews/U01-" + str(width) + "px.png"))
	var markers: Image = keyed["U02"]
	for side in range(2):
		var cell := markers.get_region(Rect2i(side * markers.get_width() / 2, 0, markers.get_width() / 2, markers.get_height()))
		var bounds := cell.get_used_rect()
		records.append({"code": "U02-marker-" + str(side), "bounds": [bounds.position.x, bounds.position.y, bounds.size.x, bounds.size.y]})
		var crop := cell.get_region(bounds)
		for size in [16, 24, 32, 48]:
			var scale := minf(float(size - 2) / crop.get_width(), float(size - 2) / crop.get_height())
			var resized := crop.duplicate() as Image
			resized.resize(maxi(1, roundi(crop.get_width() * scale)), maxi(1, roundi(crop.get_height() * scale)), Image.INTERPOLATE_NEAREST)
			var canvas := Image.create(size, size, false, Image.FORMAT_RGBA8)
			canvas.fill(Color.TRANSPARENT)
			canvas.blit_rect(resized, Rect2i(Vector2i.ZERO, resized.get_size()), (Vector2i(size, size) - resized.get_size()) / 2)
			canvas.save_png(batch_root.path_join("previews/U02-marker-" + str(side) + "-" + str(size) + "px.png"))
	var common: Rect2i = keyed["U03"].get_used_rect().merge(keyed["U04"].get_used_rect())
	for code in ["U03", "U04"]:
		for size in [64, 128]:
			var crop: Image = keyed[code].get_region(common)
			var scale := minf(float(size - 4) / crop.get_width(), float(size - 4) / crop.get_height())
			crop.resize(maxi(1, roundi(crop.get_width() * scale)), maxi(1, roundi(crop.get_height() * scale)), Image.INTERPOLATE_NEAREST)
			var canvas := Image.create(size, size, false, Image.FORMAT_RGBA8)
			canvas.fill(Color.TRANSPARENT)
			canvas.blit_rect(crop, Rect2i(Vector2i.ZERO, crop.get_size()), (Vector2i(size, size) - crop.get_size()) / 2)
			canvas.save_png(batch_root.path_join("previews/" + code + "-" + str(size) + "px.png"))
	var file := FileAccess.open(batch_root.path_join("previews/preparation.json"), FileAccess.WRITE)
	file.store_string(JSON.stringify(records, "  "))
	print("Prepared four UI candidates without native source changes")
	quit()

func is_magenta(color: Color) -> bool:
	return color.r > 0.72 and color.b > 0.72 and color.g < 0.30 and color.r - color.g > 0.40 and color.b - color.g > 0.40

func key_exterior(image: Image) -> void:
	var width := image.get_width()
	var height := image.get_height()
	var seen := PackedByteArray()
	seen.resize(width * height)
	var queue := PackedInt32Array()
	for x in width:
		queue.append(x)
		queue.append((height - 1) * width + x)
	for y in height:
		queue.append(y * width)
		queue.append(y * width + width - 1)
	var index := 0
	while index < queue.size():
		var point := queue[index]
		index += 1
		if seen[point] != 0:
			continue
		seen[point] = 1
		var x := point % width
		var y := point / width
		if not is_magenta(image.get_pixel(x, y)):
			continue
		image.set_pixel(x, y, Color.TRANSPARENT)
		if x > 0 and seen[point - 1] == 0: queue.append(point - 1)
		if x < width - 1 and seen[point + 1] == 0: queue.append(point + 1)
		if y > 0 and seen[point - width] == 0: queue.append(point - width)
		if y < height - 1 and seen[point + width] == 0: queue.append(point + width)
