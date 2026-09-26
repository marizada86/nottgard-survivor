extends SceneTree
## Converte uma grade fonte em uma tira horizontal de celulas 256x384.

const TARGET_CELL := Vector2i(256, 384)

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 2 and args.size() != 4:
		printerr("uso: normalize_animation_grid.gd <fonte.png> <destino.png> [colunas linhas]")
		quit(2)
		return
	var columns := int(args[2]) if args.size() == 4 else 3
	var rows := int(args[3]) if args.size() == 4 else 2
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
	for frame in frame_count:
		var origin := Vector2i((frame % columns) * source_cell.x, (frame / columns) * source_cell.y)
		var cell := source.get_region(Rect2i(origin, source_cell))
		cell.resize(TARGET_CELL.x, TARGET_CELL.y, Image.INTERPOLATE_NEAREST)
		strip.blit_rect(cell, Rect2i(Vector2i.ZERO, TARGET_CELL), Vector2i(frame * TARGET_CELL.x, 0))
	if strip.save_png(args[1]) != OK:
		printerr("nao foi possivel salvar: %s" % args[1])
		quit(1)
		return
	print("normalizado: %s" % args[1])
	quit()
