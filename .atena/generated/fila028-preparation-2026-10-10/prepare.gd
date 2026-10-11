extends SceneTree

# Package-only deterministic derivatives. Native sources are read-only.
var project_root: String
var package: String
var reports: Array = []
var reviewed_holes: Dictionary = {
	"SE05": [[64,98,73,107],[201,111,214,142],[51,128,56,147],[139,194,144,198]],
	"SE06": [[106,94,131,151],[148,99,153,105],[169,103,177,113]],
	"SE07": [[90,76,122,128],[134,88,171,132]],
	"SE08": [[126,71,140,92],[143,88,157,116],[165,111,170,117],[185,125,190,132],[195,126,198,135]],
	"SE10": [[101,64,133,143],[147,79,164,150],[172,131,194,139],[179,155,185,165]],
	"SE11": [[87,59,101,105],[139,84,149,119],[164,89,186,131]],
	"EV05": [[69,87,73,98],[25,128,80,178]]
}

func _init() -> void:
	project_root = OS.get_cmdline_user_args()[0].replace("\\", "/")
	package = project_root.path_join(".atena/generated/fila028-preparation-2026-10-10")
	var manifest: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(package.path_join("manifest.json")))
	for folder in ["normalized", "masks", "frames"]:
		DirAccess.make_dir_recursive_absolute(package.path_join(folder))
	for entry in manifest.entries:
		var source := Image.new()
		assert(source.load(project_root.path_join(String(entry.path).replace("\\", "/"))) == OK)
		source.convert(Image.FORMAT_RGBA8)
		var stem: String = entry.code + "_" + entry.version
		if entry.code == "AL01":
			var strip := Image.create(1152, 192, false, Image.FORMAT_RGBA8)
			strip.fill(Color.TRANSPARENT)
			for i in 6:
				var cell: Image = source.get_region(Rect2i((i % 3) * 512, (i / 3) * 512, 512, 512))
				var mask: Image = key_background(cell, "magenta")
				assert(mask.save_png(package.path_join("masks/" + stem + "_f%d.png" % i)) == OK)
				cell.resize(192, 192, Image.INTERPOLATE_NEAREST)
				assert(cell.save_png(package.path_join("frames/" + stem + "_f%d.png" % i)) == OK)
				strip.blit_rect(cell, Rect2i(0, 0, 192, 192), Vector2i(i * 192, 0))
			assert(strip.save_png(package.path_join("normalized/" + stem + ".png")) == OK)
			reports.append({"code": entry.code, "method": "six_grid_cells_nearest", "frame_size": 192, "anchor": "native_cell_origin", "body_invariance": "requires_audit"})
		else:
			var method: String = entry.operation
			if method == "chroma_key_resize":
				# Select only the source background hue, never both hues.
				var corner: Color = source.get_pixel(0, 0)
				var hue: String = "cyan" if corner.g > corner.r else "magenta"
				var mask: Image = key_background(source, hue, reviewed_holes.get(entry.code, []))
				assert(mask.save_png(package.path_join("masks/" + stem + ".png")) == OK)
			var target: int = int(entry.target_size[0])
			var box: Rect2i = source.get_used_rect()
			if entry.code in ["SE02", "SE03"]:
				# Same silhouette height/base, proportional scaling; no camera repaint.
				var chamber: Image = source.get_region(box)
				var chamber_width: int = roundi(box.size.x * 154.0 / box.size.y)
				chamber.resize(chamber_width, 154, Image.INTERPOLATE_NEAREST)
				var paired := Image.create(256, 256, false, Image.FORMAT_RGBA8)
				paired.fill(Color.TRANSPARENT)
				paired.blit_rect(chamber, Rect2i(0, 0, chamber_width, 154), Vector2i((256 - chamber_width) / 2, 56))
				assert(paired.save_png(package.path_join("normalized/" + stem + ".png")) == OK)
				reports.append({"code": entry.code, "method": "chroma_key_foreground_crop_pair", "source_foreground_rect": [box.position.x, box.position.y, box.size.x, box.size.y], "resize": [chamber_width, 154], "offset": [(256 - chamber_width) / 2, 56], "filter": "nearest", "pair_reference": "SE02 silhouette height 154 and base 210; camera/detail identity remains human review"})
				print("prepared ", stem)
				continue
			var margin: int = ceili(target * (0.18 if entry.code in ["I01", "I02"] else 0.15)) if method == "preserve_alpha_resize" else 0
			var factor: float = minf(float(target) / source.get_width(), float(target) / source.get_height())
			if margin > 0:
				factor = minf(factor, float(target - 2 * margin) / maxi(box.size.x, box.size.y))
			var scaled_size := Vector2i(maxi(1, roundi(source.get_width() * factor)), maxi(1, roundi(source.get_height() * factor)))
			source.resize(scaled_size.x, scaled_size.y, Image.INTERPOLATE_NEAREST)
			var output := Image.create(target, target, false, Image.FORMAT_RGBA8)
			output.fill(Color.TRANSPARENT)
			var offset := Vector2i((target - scaled_size.x) / 2, (target - scaled_size.y) / 2)
			output.blit_rect(source, Rect2i(Vector2i.ZERO, scaled_size), offset)
			assert(output.save_png(package.path_join("normalized/" + stem + ".png")) == OK)
			reports.append({"code": entry.code, "method": method, "source_foreground_rect": [box.position.x, box.position.y, box.size.x, box.size.y], "resize": [scaled_size.x, scaled_size.y], "offset": [offset.x, offset.y], "filter": "nearest", "minimum_margin_px": margin})
		print("prepared ", stem)
	var file := FileAccess.open(package.path_join("parameters.json"), FileAccess.WRITE)
	file.store_string(JSON.stringify({"tool": "Godot 4.7.2 Image", "background": "edge_connected_selected_hue_only", "chroma_min": 0.45, "opposite_channel_ratio_max": 0.55, "interior_holes": "visually confirmed arch/window/cloth/rim voids only", "reviewed_hole_seed_rects_on_256_canvas": reviewed_holes, "source_canvas": "preserved except paired chamber foreground crops", "reports": reports}, "  "))
	quit()

func key_background(im: Image, hue: String, hole_rects: Array = []) -> Image:
	var w: int = im.get_width()
	var h: int = im.get_height()
	var mask := PackedByteArray()
	mask.resize(w * h)
	for y in h:
		for x in w:
			var p: Color = im.get_pixel(x, y)
			var low: float = minf(p.g, p.b) if hue == "cyan" else minf(p.r, p.b)
			var opposite: float = p.r if hue == "cyan" else p.g
			if low >= 0.45 and opposite <= low * 0.55:
				mask[y * w + x] = 1
	var queue := PackedInt32Array()
	for x in w:
		enqueue(mask, queue, x)
		enqueue(mask, queue, (h - 1) * w + x)
	for y in h:
		enqueue(mask, queue, y * w)
		enqueue(mask, queue, y * w + w - 1)
	# Rectangles are manually reviewed seed regions, not replacement shapes.
	# Only chroma candidates in these regions enter the same connected mask.
	for rect in hole_rects:
		for y in range(int(rect[1] * h / 256.0), int(rect[3] * h / 256.0)):
			for x in range(int(rect[0] * w / 256.0), int(rect[2] * w / 256.0)):
				enqueue(mask, queue, y * w + x)
	var cursor: int = 0
	while cursor < queue.size():
		var index: int = queue[cursor]
		cursor += 1
		var x: int = index % w
		var y: int = index / w
		if x > 0: enqueue(mask, queue, index - 1)
		if x < w - 1: enqueue(mask, queue, index + 1)
		if y > 0: enqueue(mask, queue, index - w)
		if y < h - 1: enqueue(mask, queue, index + w)
	var removed := Image.create(w, h, false, Image.FORMAT_L8)
	removed.fill(Color.BLACK)
	for index in queue:
		im.set_pixel(index % w, index / w, Color.TRANSPARENT)
		removed.set_pixel(index % w, index / w, Color.WHITE)
	return removed

func enqueue(mask: PackedByteArray, queue: PackedInt32Array, index: int) -> void:
	if mask[index] == 1:
		mask[index] = 2
		queue.append(index)
