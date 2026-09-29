extends SceneTree
## Converte uma grade fonte em tira horizontal, enquadrando cada quadro na célula.

const TARGET_CELL := Vector2i(256, 384)
const MAX_CONTENT := Vector2i(232, 360)
const BASELINE_Y := 368
const ALPHA_THRESHOLD := 0.10

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 4:
		printerr("uso: normalize_animation_grid_fit.gd <fonte.png> <destino.png> <colunas> <linhas>")
		quit(2)
		return
	var columns := int(args[2])
	var rows := int(args[3])
	if columns < 1 or rows < 1:
		printerr("grade invalida: %dx%d" % [columns, rows])
		quit(2)
		return
	var source := Image.new()
	if source.load(args[0]) != OK:
		printerr("nao foi possivel abrir: %s" % args[0])
		quit(1)
		return
	if source.get_width() % columns != 0 or source.get_height() % rows != 0:
		printerr("tamanho %s nao e divisivel por %dx%d" % [source.get_size(), columns, rows])
		quit(1)
		return
	var source_cell := Vector2i(source.get_width() / columns, source.get_height() / rows)
	var frame_count := columns * rows
	var strip := Image.create(TARGET_CELL.x * frame_count, TARGET_CELL.y, false, Image.FORMAT_RGBA8)
	strip.fill(Color(0, 0, 0, 0))
	for frame in frame_count:
		var origin := Vector2i((frame % columns) * source_cell.x, (frame / columns) * source_cell.y)
		var source_rect := Rect2i(origin, source_cell)
		var bounds := _bounds(source, source_rect)
		if bounds.size == Vector2i.ZERO:
			printerr("quadro vazio: %d" % frame)
			quit(1)
			return
		var content := source.get_region(Rect2i(origin + bounds.position, bounds.size))
		var scale: float = minf(float(MAX_CONTENT.x) / float(content.get_width()), float(MAX_CONTENT.y) / float(content.get_height()))
		var fitted: Vector2i = Vector2i(maxi(1, roundi(content.get_width() * scale)), maxi(1, roundi(content.get_height() * scale)))
		content.resize(fitted.x, fitted.y, Image.INTERPOLATE_LANCZOS)
		var destination: Vector2i = Vector2i(frame * TARGET_CELL.x + (TARGET_CELL.x - fitted.x) / 2, BASELINE_Y - fitted.y)
		strip.blit_rect(content, Rect2i(Vector2i.ZERO, fitted), destination)
	if strip.save_png(args[1]) != OK:
		printerr("nao foi possivel salvar: %s" % args[1])
		quit(1)
		return
	print("normalizado e enquadrado: %s" % args[1])
	quit()

func _bounds(image: Image, rect: Rect2i) -> Rect2i:
	var min_x := rect.end.x
	var min_y := rect.end.y
	var max_x := rect.position.x - 1
	var max_y := rect.position.y - 1
	for y in range(rect.position.y, rect.end.y):
		for x in range(rect.position.x, rect.end.x):
			if image.get_pixel(x, y).a < ALPHA_THRESHOLD:
				continue
			min_x = min(min_x, x)
			min_y = min(min_y, y)
			max_x = max(max_x, x)
			max_y = max(max_y, y)
	if max_x < min_x or max_y < min_y:
		return Rect2i()
	return Rect2i(min_x - rect.position.x, min_y - rect.position.y, max_x - min_x + 1, max_y - min_y + 1)
