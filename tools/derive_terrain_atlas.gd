extends SceneTree
## Deriva um atlas 2x2 opaco de uma textura plana existente, preservando leitura.
## Uso: godot --headless --path . -s tools/derive_terrain_atlas.gd -- <origem.png> <destino.png> <dagruve|docas|shedaklah|molor|feng_tu|shendilavri|goranthis|pilares>

const TILE_SIZE := Vector2i(64, 32)
const GRID_SIZE := Vector2i(2, 2)

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 3:
		push_error("Uso: derive_terrain_atlas.gd <origem.png> <destino.png> <dagruve|docas>")
		quit(1)
		return
	var source := Image.load_from_file(args[0])
	var biome := String(args[2])
	if source == null or source.is_empty() or not ["dagruve", "docas", "shedaklah", "molor", "feng_tu", "shendilavri", "goranthis", "pilares"].has(biome):
		push_error("Fonte ou bioma inválido")
		quit(1)
		return
	source.convert(Image.FORMAT_RGBA8)
	var atlas := Image.create(TILE_SIZE.x * GRID_SIZE.x, TILE_SIZE.y * GRID_SIZE.y, false, Image.FORMAT_RGBA8)
	for tile_y in GRID_SIZE.y:
		for tile_x in GRID_SIZE.x:
			var variant := tile_y * GRID_SIZE.x + tile_x
			_write_variant(atlas, source, Vector2i(tile_x * TILE_SIZE.x, tile_y * TILE_SIZE.y), variant, biome)
	var status := atlas.save_png(args[1])
	if status != OK:
		push_error("Não foi possível gravar atlas: %s" % args[1])
	quit(0 if status == OK else 1)

func _write_variant(atlas: Image, source: Image, destination: Vector2i, variant: int, biome: String) -> void:
	var shifts: Array[Vector2i] = [Vector2i(0, 0), Vector2i(29, 11), Vector2i(61, 23), Vector2i(89, 37)]
	var shift: Vector2i = shifts[variant]
	var tint := Color(0.26, 0.13, 0.23) if biome == "dagruve" else (Color(0.20, 0.16, 0.23) if biome == "shedaklah" else (Color(0.12, 0.19, 0.14) if biome == "molor" else (Color(0.13, 0.18, 0.24) if biome == "feng_tu" else (Color(0.22, 0.09, 0.22) if biome == "shendilavri" else (Color(0.34, 0.29, 0.16) if biome == "goranthis" else (Color(0.16, 0.11, 0.24) if biome == "pilares" else Color(0.06, 0.24, 0.27)))))))
	var tint_strength := 0.18 if biome == "dagruve" else (0.12 if biome == "shedaklah" else (0.16 if biome == "molor" else (0.14 if biome == "feng_tu" else (0.14 if biome == "shendilavri" else (0.12 if biome == "goranthis" else (0.16 if biome == "pilares" else 0.34))))))
	var brightness_values: Array[float] = [-0.025, 0.0, 0.018, -0.01]
	var brightness: float = brightness_values[variant]
	for y in TILE_SIZE.y:
		for x in TILE_SIZE.x:
			var sample := source.get_pixelv(Vector2i(posmod(x + shift.x, source.get_width()), posmod(y + shift.y, source.get_height())))
			var color := sample.lerp(tint, tint_strength)
			var wobble := 0.018 if posmod(x * 17 + y * 11 + variant * 19, 53) < 3 else 0.0
			color = Color(color.r + brightness + wobble, color.g + brightness + wobble, color.b + brightness + wobble, 1.0)
			atlas.set_pixelv(destination + Vector2i(x, y), color.clamp())
