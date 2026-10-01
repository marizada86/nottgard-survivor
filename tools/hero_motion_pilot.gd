extends SceneTree
## Gera uma prancha local do piloto sem modificar as imagens oficiais.

const HERO_ID := "durvall"
const CELL := Vector2i(256, 384)
const DIRECTIONS := ["idle", "move_n", "move_ne", "move_e", "move_se", "move_s"]
const BASE_SCALE := 72.0 / float(CELL.y)
const PREVIEW_ZOOM := 2.25
const ALPHA_THRESHOLD := 0.10
const OUTPUT_SIZE := Vector2i(1280, 720)

func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	var output_path := String(args[0]) if not args.is_empty() else ".atena/evidence/SPEC-101-durvall-motion-pilot.png"
	var canvas := Image.create(OUTPUT_SIZE.x, OUTPUT_SIZE.y, false, Image.FORMAT_RGBA8)
	canvas.fill(Color("1a1721"))
	for index in DIRECTIONS.size():
		var center_x := 143 + index * 198
		canvas.fill_rect(Rect2i(center_x - 82, 94, 164, 242), Color("292432"))
		canvas.fill_rect(Rect2i(center_x - 82, 390, 164, 258), Color("292432"))
		canvas.fill_rect(Rect2i(center_x - 29, 319, 58, 2), Color("d9b65d"))
		canvas.fill_rect(Rect2i(center_x - 29, 631, 58, 2), Color("d9b65d"))
		_render_preview(canvas, String(DIRECTIONS[index]), center_x, 319, false)
		_render_preview(canvas, String(DIRECTIONS[index]), center_x, 631, true)
	var status := canvas.save_png(output_path)
	if status != OK:
		push_error("Piloto de movimento: não foi possível salvar %s" % output_path)
	quit(0 if status == OK else 1)

func _render_preview(canvas: Image, sequence: String, center_x: int, baseline: int, adjusted: bool) -> void:
	var image := Image.new()
	var path := "res://assets/animations/heroes/%s/%s.png" % [HERO_ID, sequence]
	if image.load(ProjectSettings.globalize_path(path)) != OK:
		push_error("Piloto de movimento: imagem ausente %s" % path)
		return
	var stats := _sequence_stats(image)
	var bounds: Rect2i = stats.bounds
	var factor := 1.0
	if adjusted and sequence != "idle":
		var idle_image := Image.new()
		idle_image.load(ProjectSettings.globalize_path("res://assets/animations/heroes/%s/idle.png" % HERO_ID))
		var idle_stats := _sequence_stats(idle_image)
		factor = float(idle_stats.height) / float(maxi(1, int(stats.height)))
		print("pilot,%s,height=%d,idle_height=%d,scale_factor=%.3f,median_baseline=%d" % [sequence, stats.height, idle_stats.height, factor, stats.bottom])
	var source_rect := Rect2i(Vector2i(int(stats.frame) * CELL.x, 0) + bounds.position, bounds.size)
	var content := image.get_region(source_rect)
	var display_scale := BASE_SCALE * PREVIEW_ZOOM * factor
	var display_size := Vector2i(maxi(1, roundi(float(bounds.size.x) * display_scale)), maxi(1, roundi(float(bounds.size.y) * display_scale)))
	content.resize(display_size.x, display_size.y, Image.INTERPOLATE_LANCZOS)
	var target_baseline := baseline
	if not adjusted:
		target_baseline += roundi(float(int(stats.bottom) - CELL.y) * BASE_SCALE * PREVIEW_ZOOM)
	canvas.blend_rect(content, Rect2i(Vector2i.ZERO, content.get_size()), Vector2i(center_x - display_size.x / 2, target_baseline - display_size.y))

func _sequence_stats(image: Image) -> Dictionary:
	var records: Array[Dictionary] = []
	var bottoms: Array[int] = []
	for frame_index in image.get_width() / CELL.x:
		var bounds := _bounds(image, frame_index)
		if bounds.size == Vector2i.ZERO:
			continue
		records.append({"height": bounds.size.y, "bottom": bounds.end.y, "frame": frame_index, "bounds": bounds})
		bottoms.append(bounds.end.y)
	records.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return int(a.height) < int(b.height))
	bottoms.sort()
	var median: Dictionary = records[records.size() / 2] if not records.is_empty() else {"height": 1, "bottom": CELL.y, "frame": 0, "bounds": Rect2i()}
	return {"height": int(median.height), "bottom": int(bottoms[bottoms.size() / 2]) if not bottoms.is_empty() else CELL.y, "frame": int(median.frame), "bounds": median.bounds}

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
