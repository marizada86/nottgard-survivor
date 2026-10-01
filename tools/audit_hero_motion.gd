extends SceneTree
## Audita proporções e linhas de base das animações dos heróis, sem modificar PNGs.

const CELL := Vector2i(256, 384)
const DIRECTIONS := ["n", "ne", "e", "se", "s"]
const ALPHA_THRESHOLD := 0.10

func _initialize() -> void:
	var directory := DirAccess.open("res://assets/animations/heroes")
	if directory == null:
		push_error("Não foi possível abrir a pasta de animações de heróis")
		quit(1)
		return
	print("hero,sequence,frames,median_width,median_height,min_height,max_height,height_spread,median_bottom,edge_frames,contract")
	for hero_id in directory.get_directories():
		var root := "res://assets/animations/heroes/%s" % hero_id
		for sequence in ["idle"] + DIRECTIONS.map(func(direction: String) -> String: return "move_%s" % direction):
			var path := "%s/%s.png" % [root, sequence]
			if not FileAccess.file_exists(path):
				print("%s,%s,MISSING,,,,,,,," % [hero_id, sequence])
				continue
			var image := Image.new()
			if image.load(ProjectSettings.globalize_path(path)) != OK:
				print("%s,%s,INVALID,,,,,,,," % [hero_id, sequence])
				continue
			var expected_frames := 4 if sequence == "idle" else 6
			var contract_ok := image.get_size() == Vector2i(expected_frames * CELL.x, CELL.y)
			if not contract_ok:
				push_error("%s/%s: esperado %dx%d; recebido %s" % [hero_id, sequence, expected_frames * CELL.x, CELL.y, image.get_size()])
			var widths: Array[int] = []
			var heights: Array[int] = []
			var bottoms: Array[int] = []
			var edge_frames := 0
			for frame_index in image.get_width() / CELL.x:
				var bounds := _bounds(image, frame_index)
				if bounds.size == Vector2i.ZERO:
					continue
				widths.append(bounds.size.x)
				heights.append(bounds.size.y)
				bottoms.append(bounds.end.y)
				if bounds.position.x <= 1 or bounds.position.y <= 1 or bounds.end.x >= CELL.x - 1 or bounds.end.y >= CELL.y - 1:
					edge_frames += 1
			var sorted_heights := heights.duplicate()
			sorted_heights.sort()
			var median_width := _median(widths)
			var median_height := _median(heights)
			var median_bottom := _median(bottoms)
			var spread: int = sorted_heights[-1] - sorted_heights[0] if not sorted_heights.is_empty() else 0
			print("%s,%s,%d,%d,%d,%d,%d,%d,%d,%d,%s" % [hero_id, sequence, heights.size(), median_width, median_height, sorted_heights[0] if not sorted_heights.is_empty() else 0, sorted_heights[-1] if not sorted_heights.is_empty() else 0, spread, median_bottom, edge_frames, "ok" if contract_ok else "mismatch"])
	quit()

func _bounds(image: Image, frame_index: int) -> Rect2i:
	var left := CELL.x
	var top := CELL.y
	var right := -1
	var bottom := -1
	for y in CELL.y:
		for x in CELL.x:
			if image.get_pixel(frame_index * CELL.x + x, y).a < ALPHA_THRESHOLD:
				continue
			left = mini(left, x)
			top = mini(top, y)
			right = maxi(right, x)
			bottom = maxi(bottom, y)
	if right < left or bottom < top:
		return Rect2i()
	return Rect2i(left, top, right - left + 1, bottom - top + 1)

func _median(values: Array[int]) -> int:
	if values.is_empty():
		return 0
	var sorted := values.duplicate()
	sorted.sort()
	return sorted[sorted.size() / 2]
