extends SceneTree
## Converte uma prancha transparente 2x2 em atlas 128x64 de quatro tiles 64x32.
## Uso: godot --headless --path . -s tools/normalize_terrain_atlas.gd -- <origem.png> <destino.png> [cor-base]

const TILE_SIZE := Vector2i(64, 32)
const GRID_SIZE := Vector2i(2, 2)

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() < 2 or args.size() > 3:
		push_error("Uso: normalize_terrain_atlas.gd <origem.png> <destino.png> [cor-base]")
		quit(1)
		return
	var backdrop := Color.html(String(args[2])) if args.size() == 3 else Color(0.1, 0.1, 0.1)
	var source := Image.load_from_file(args[0])
	if source == null or source.is_empty():
		push_error("Não foi possível abrir atlas fonte: %s" % args[0])
		quit(1)
		return
	var atlas := Image.create(TILE_SIZE.x * GRID_SIZE.x, TILE_SIZE.y * GRID_SIZE.y, false, Image.FORMAT_RGBA8)
	atlas.fill(Color(0, 0, 0, 0))
	var source_cell := Vector2i(source.get_width() / GRID_SIZE.x, source.get_height() / GRID_SIZE.y)
	for y in GRID_SIZE.y:
		for x in GRID_SIZE.x:
			var quadrant := source.get_region(Rect2i(Vector2i(x * source_cell.x, y * source_cell.y), source_cell))
			var content := quadrant.get_used_rect()
			if content.size.x <= 0 or content.size.y <= 0:
				push_error("Quadrante sem conteúdo em %s,%s" % [x, y])
				quit(1)
				return
			var tile := quadrant.get_region(content)
			tile.resize(TILE_SIZE.x, TILE_SIZE.y, Image.INTERPOLATE_LANCZOS)
			_flatten_transparency(tile, backdrop)
			atlas.blit_rect(tile, Rect2i(Vector2i.ZERO, TILE_SIZE), Vector2i(x * TILE_SIZE.x, y * TILE_SIZE.y))
	var status := atlas.save_png(args[1])
	if status != OK:
		push_error("Não foi possível gravar atlas: %s" % args[1])
	quit(0 if status == OK else 1)

func _flatten_transparency(tile: Image, backdrop: Color) -> void:
	for y in tile.get_height():
		for x in tile.get_width():
			var pixel := tile.get_pixel(x, y)
			var alpha := pixel.a
			tile.set_pixel(x, y, Color(
				pixel.r * alpha + backdrop.r * (1.0 - alpha),
				pixel.g * alpha + backdrop.g * (1.0 - alpha),
				pixel.b * alpha + backdrop.b * (1.0 - alpha),
				1.0
			))
