@tool
extends Node2D
## Chão isométrico texturizado. Cores continuam servindo de fallback no editor.

const TerrainLayout := preload("res://core/terrain_layout.gd")

@export var map_size := Vector2i(40, 40): set = _set_size
@export var color_a := Color(0.13, 0.12, 0.14): set = _set_a
@export var color_b := Color(0.17, 0.15, 0.16): set = _set_b
## Um atlas é uma malha compacta de losangos 64x32. Ele só é ativado por cena
## depois que a arte for aprovada; o piso legado continua aceito como textura única.
@export var use_modular_atlas := false: set = _set_modular_atlas
@export var atlas_tile_size := Vector2i(64, 32): set = _set_atlas_tile_size
@export var atlas_columns := 4: set = _set_atlas_columns
@export var atlas_variants := 4: set = _set_atlas_variants
@export var visual_seed := 0: set = _set_visual_seed
## Útil em cenas de avaliação que exibem mais de um bioma.
@export var stage_visual_id := "": set = _set_stage_visual_id
## Ativa composição de macroterreno sem depender de um atlas único.
@export var terrain_layout_id := "": set = _set_terrain_layout_id
@export var use_stage_texture := true: set = _set_use_stage_texture
## Permite promover uma versão do atlas sem sobrescrever o piso legado.
@export_file("*.png") var terrain_texture_path := "": set = _set_terrain_texture_path
var _texture: Texture2D
var _texture_path := ""

func _set_size(v: Vector2i) -> void:
	map_size = v
	queue_redraw()

func _set_a(v: Color) -> void:
	color_a = v
	queue_redraw()

func _set_b(v: Color) -> void:
	color_b = v
	queue_redraw()

func _set_modular_atlas(v: bool) -> void:
	use_modular_atlas = v
	queue_redraw()

func _set_atlas_tile_size(v: Vector2i) -> void:
	atlas_tile_size = Vector2i(maxi(1, v.x), maxi(1, v.y))
	queue_redraw()

func _set_atlas_columns(v: int) -> void:
	atlas_columns = maxi(1, v)
	queue_redraw()

func _set_atlas_variants(v: int) -> void:
	atlas_variants = maxi(1, v)
	queue_redraw()

func _set_visual_seed(v: int) -> void:
	visual_seed = v
	queue_redraw()

func _set_stage_visual_id(v: String) -> void:
	stage_visual_id = v
	queue_redraw()

func _set_terrain_layout_id(v: String) -> void:
	terrain_layout_id = v
	queue_redraw()

func _set_use_stage_texture(v: bool) -> void:
	use_stage_texture = v
	queue_redraw()

func _set_terrain_texture_path(v: String) -> void:
	terrain_texture_path = v
	_texture_path = ""
	_texture = null
	queue_redraw()

func _stage_id() -> String:
	if not stage_visual_id.is_empty():
		return stage_visual_id
	var cursor: Node = self
	while cursor != null:
		if cursor.scene_file_path != "":
			return cursor.scene_file_path.get_file().get_basename()
		cursor = cursor.get_parent()
	return ""

func _ground_texture() -> Texture2D:
	if not use_stage_texture:
		return null
	var stage_id := _stage_id()
	var path := terrain_texture_path if not terrain_texture_path.is_empty() else "res://assets/tiles/%s_ground.png" % stage_id
	if path != _texture_path:
		_texture_path = path
		_texture = load(path) if ResourceLoader.exists(path) else null
	return _texture

## Não toca no RNG da batalha: a mesma célula sempre recebe a mesma variação.
static func deterministic_variant(stage_id: String, x: int, y: int, seed: int, variants: int) -> int:
	if variants <= 1:
		return 0
	var hash_value := 2166136261
	for byte in stage_id.to_utf8_buffer():
		hash_value = int((hash_value ^ byte) * 16777619) & 0x7fffffff
	hash_value = int((hash_value ^ (x * 73856093)) * 16777619) & 0x7fffffff
	hash_value = int((hash_value ^ (y * 19349663)) * 16777619) & 0x7fffffff
	hash_value = int((hash_value ^ seed) * 16777619) & 0x7fffffff
	return posmod(hash_value, variants)

func _available_atlas_variants(texture: Texture2D) -> int:
	if not use_modular_atlas:
		return 1
	var available_columns := _effective_atlas_columns(texture)
	var rows := texture.get_height() / atlas_tile_size.y
	var available := available_columns * rows
	return maxi(1, mini(atlas_variants, available))

func _effective_atlas_columns(texture: Texture2D) -> int:
	return maxi(1, mini(atlas_columns, texture.get_width() / atlas_tile_size.x))

func _atlas_uvs(texture: Texture2D, variant: int) -> PackedVector2Array:
	if not use_modular_atlas:
		return PackedVector2Array([
			Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1)
		])
	var columns := _effective_atlas_columns(texture)
	var column := variant % columns
	var row := variant / columns
	var texture_size := Vector2(texture.get_width(), texture.get_height())
	var origin := Vector2(column * atlas_tile_size.x, row * atlas_tile_size.y) / texture_size
	var size := Vector2(atlas_tile_size) / texture_size
	return PackedVector2Array([
		origin, origin + Vector2(size.x, 0), origin + size, origin + Vector2(0, size.y)
	])

func _draw() -> void:
	TerrainLayout.scale = float(map_size.x) / 40.0
	var hw := Iso.TILE_W * 0.5
	var hh := Iso.TILE_H * 0.5
	var texture := _ground_texture()
	var available_variants := _available_atlas_variants(texture) if texture != null else 0
	var stage_id := _stage_id()
	for x in map_size.x:
		for y in map_size.y:
			var c := Iso.to_screen(Vector2(x + 0.5, y + 0.5))
			var points := PackedVector2Array([c + Vector2(0, -hh), c + Vector2(hw, 0), c + Vector2(0, hh), c + Vector2(-hw, 0)])
			if not terrain_layout_id.is_empty():
				_draw_layout_cell(c, points, x, y, texture, available_variants)
				continue
			if texture != null:
				var variant := deterministic_variant(stage_id, x, y, visual_seed, available_variants)
				var tint := Color.WHITE if use_modular_atlas else (Color.WHITE if (x + y) % 2 == 0 else Color(0.9, 0.9, 0.94))
				draw_polygon(points, PackedColorArray([tint, tint, tint, tint]), _atlas_uvs(texture, variant), texture)
			else:
				draw_colored_polygon(points, color_a if (x + y) % 2 == 0 else color_b)

func _draw_layout_cell(center: Vector2, points: PackedVector2Array, x: int, y: int, texture: Texture2D, available_variants: int) -> void:
	var material := TerrainLayout.material_at(terrain_layout_id, Vector2(x + 0.5, y + 0.5))
	var base := TerrainLayout.color_for(material)
	var variant := deterministic_variant(terrain_layout_id, x, y, visual_seed, 8)
	var accepts_ground_texture := material == TerrainLayout.MATERIAL_FUNGAL_SOIL or material == TerrainLayout.MATERIAL_MYCELIUM or material == TerrainLayout.MATERIAL_OOZE_CRUST or material == TerrainLayout.MATERIAL_MOLOR_ROCK or material == TerrainLayout.MATERIAL_MOLOR_DETRITUS or material == TerrainLayout.MATERIAL_MOLOR_OOZE or material == TerrainLayout.MATERIAL_FENG_TU_STONE or material == TerrainLayout.MATERIAL_FENG_TU_ASH or material == TerrainLayout.MATERIAL_FENG_TU_CRACK or material == TerrainLayout.MATERIAL_SHENDILAVRI_MARBLE or material == TerrainLayout.MATERIAL_SHENDILAVRI_VEIN or material == TerrainLayout.MATERIAL_SHENDILAVRI_DUST or material == TerrainLayout.MATERIAL_GORANTHIS_TERRACE or material == TerrainLayout.MATERIAL_GORANTHIS_PEARL or material == TerrainLayout.MATERIAL_GORANTHIS_MOSS or material == TerrainLayout.MATERIAL_PILLARS_OBSIDIAN or material == TerrainLayout.MATERIAL_PILLARS_BASALT or material == TerrainLayout.MATERIAL_PILLARS_DUST
	if accepts_ground_texture and texture != null:
		var atlas_variant := deterministic_variant(terrain_layout_id, x, y, visual_seed, available_variants)
		var tint := Color("a99bab")
		if material == TerrainLayout.MATERIAL_MYCELIUM:
			tint = Color("c4b3c0")
		elif material == TerrainLayout.MATERIAL_OOZE_CRUST:
			tint = Color("9ba276")
		elif material == TerrainLayout.MATERIAL_MOLOR_ROCK:
			tint = Color("8c9982")
		elif material == TerrainLayout.MATERIAL_MOLOR_DETRITUS:
			tint = Color("9a996d")
		elif material == TerrainLayout.MATERIAL_MOLOR_OOZE:
			tint = Color("829a4f")
		elif material == TerrainLayout.MATERIAL_FENG_TU_STONE:
			tint = Color("85909a")
		elif material == TerrainLayout.MATERIAL_FENG_TU_ASH:
			tint = Color("9b9290")
		elif material == TerrainLayout.MATERIAL_FENG_TU_CRACK:
			tint = Color("677080")
		elif material == TerrainLayout.MATERIAL_SHENDILAVRI_MARBLE:
			tint = Color("a380a8")
		elif material == TerrainLayout.MATERIAL_SHENDILAVRI_VEIN:
			tint = Color("b177a4")
		elif material == TerrainLayout.MATERIAL_SHENDILAVRI_DUST:
			tint = Color("c59ab9")
		elif material == TerrainLayout.MATERIAL_GORANTHIS_TERRACE:
			tint = Color("c9bd8d")
		elif material == TerrainLayout.MATERIAL_GORANTHIS_PEARL:
			tint = Color("e0d7ae")
		elif material == TerrainLayout.MATERIAL_GORANTHIS_MOSS:
			tint = Color("a9ae72")
		elif material == TerrainLayout.MATERIAL_PILLARS_OBSIDIAN:
			tint = Color("766a98")
		elif material == TerrainLayout.MATERIAL_PILLARS_BASALT:
			tint = Color("9285ae")
		elif material == TerrainLayout.MATERIAL_PILLARS_DUST:
			tint = Color("b0a0c4")
		draw_polygon(points, PackedColorArray([tint, tint, tint, tint]), _atlas_uvs(texture, atlas_variant), texture)
	else:
		draw_colored_polygon(points, base)
	if material == TerrainLayout.MATERIAL_CURRENT or material == TerrainLayout.MATERIAL_SHALLOW:
		# Águas lentas do Estige: bolhas e reflexos deixam a travessia legível.
		var gel := Color("4ba8b8") if material == TerrainLayout.MATERIAL_SHALLOW else Color("2c768d")
		if variant % 3 == 0:
			draw_circle(center + Vector2(variant - 4, -2), 1.8, Color(gel, 0.72))
		if variant == 1:
			draw_circle(center + Vector2(5, 3), 1.1, Color("91d7a2", 0.5))
	elif material == TerrainLayout.MATERIAL_SHEDAKLAH_STYX:
		# Braços calmos: a regra comum do Estige é aplicada pela batalha.
		if variant % 3 == 0:
			draw_line(center + Vector2(-9, 1), center + Vector2(8, -2), Color("475766", 0.52), 1.0, true)
	elif material == TerrainLayout.MATERIAL_SHEDAKLAH_BANK and variant % 2 == 0:
		draw_circle(center + Vector2(variant - 4, 1), 1.4, Color("8e7886", 0.42))
	elif material == TerrainLayout.MATERIAL_MYCELIUM and variant % 3 == 0:
		draw_line(center + Vector2(-8, 2), center + Vector2(6, -2), Color("9c8294", 0.42), 1.0, true)
	elif material == TerrainLayout.MATERIAL_OOZE_CRUST and variant % 2 == 0:
		draw_circle(center + Vector2(variant - 4, 0), 1.7, Color("788452", 0.42))
	elif material == TerrainLayout.MATERIAL_MOLOR_OOZE and variant % 2 == 0:
		draw_circle(center + Vector2(variant - 4, 0), 2.1, Color("94ad54", 0.42))
	elif material == TerrainLayout.MATERIAL_MOLOR_DETRITUS and variant % 3 == 0:
		draw_circle(center + Vector2(variant - 4, 1), 1.3, Color("6e7650", 0.45))
	elif material == TerrainLayout.MATERIAL_MOLOR_WALL and variant % 2 == 0:
		draw_line(center + Vector2(-9, 2), center + Vector2(8, -3), Color("31462f", 0.75), 1.4, true)
	elif material == TerrainLayout.MATERIAL_FENG_TU_CRACK and variant % 2 == 0:
		draw_line(center + Vector2(-8, 2), center + Vector2(6, -3), Color("151a24", 0.64), 1.0, true)
	elif material == TerrainLayout.MATERIAL_FENG_TU_ASH and variant % 3 == 0:
		draw_circle(center + Vector2(variant - 4, 1), 1.3, Color("b59e8f", 0.30))
	elif material == TerrainLayout.MATERIAL_FENG_TU_FOUNDATION and variant % 2 == 0:
		draw_line(center + Vector2(-10, 2), center + Vector2(8, -3), Color("0d1119", 0.75), 1.3, true)
	elif material == TerrainLayout.MATERIAL_SHENDILAVRI_STYX:
		# Água escura e parada; o risco mental vem da camada ambiental comum.
		if variant % 3 == 0:
			draw_line(center + Vector2(-9, 1), center + Vector2(8, -2), Color("6d5b82", 0.42), 1.0, true)
	elif material == TerrainLayout.MATERIAL_SHENDILAVRI_BANK and variant % 2 == 0:
		draw_circle(center + Vector2(variant - 4, 1), 1.4, Color("aa728f", 0.34))
	elif material == TerrainLayout.MATERIAL_SHENDILAVRI_VEIN and variant % 2 == 0:
		draw_line(center + Vector2(-8, 2), center + Vector2(7, -3), Color("8f597f", 0.42), 1.0, true)
	elif material == TerrainLayout.MATERIAL_SHENDILAVRI_DUST and variant % 3 == 0:
		draw_circle(center + Vector2(variant - 4, 1), 1.4, Color("d0a6c4", 0.30))
	elif material == TerrainLayout.MATERIAL_SHENDILAVRI_FOUNDATION and variant % 2 == 0:
		draw_line(center + Vector2(-10, 2), center + Vector2(8, -3), Color("1a1222", 0.78), 1.3, true)
	elif material == TerrainLayout.MATERIAL_GORANTHIS_STYXFALL:
		# A queda continua imóvel; sua base acessível usa o contrato comum do Estige.
		if variant % 2 == 0:
			draw_line(center + Vector2(-8, -5), center + Vector2(8, 5), Color("d6e5d1", 0.58), 1.4, true)
	elif material == TerrainLayout.MATERIAL_GORANTHIS_BANK and variant % 2 == 0:
		draw_circle(center + Vector2(variant - 4, 1), 1.4, Color("d9cc9a", 0.36))
	elif material == TerrainLayout.MATERIAL_GORANTHIS_PEARL and variant % 2 == 0:
		draw_line(center + Vector2(-8, 2), center + Vector2(7, -3), Color("eee2b8", 0.35), 1.0, true)
	elif material == TerrainLayout.MATERIAL_GORANTHIS_MOSS and variant % 3 == 0:
		draw_circle(center + Vector2(variant - 4, 1), 1.4, Color("c2c982", 0.36))
	elif material == TerrainLayout.MATERIAL_GORANTHIS_FOUNDATION and variant % 2 == 0:
		draw_line(center + Vector2(-10, 2), center + Vector2(8, -3), Color("4d4839", 0.75), 1.3, true)
	elif material == TerrainLayout.MATERIAL_PILLARS_BASALT and variant % 2 == 0:
		draw_line(center + Vector2(-8, 2), center + Vector2(7, -3), Color("514568", 0.52), 1.0, true)
	elif material == TerrainLayout.MATERIAL_PILLARS_DUST and variant % 3 == 0:
		draw_circle(center + Vector2(variant - 4, 1), 1.4, Color("c1b3d1", 0.30))
	elif material == TerrainLayout.MATERIAL_PILLARS_FOUNDATION and variant % 2 == 0:
		draw_line(center + Vector2(-10, 2), center + Vector2(8, -3), Color("0d0c18", 0.80), 1.3, true)
	elif material == TerrainLayout.MATERIAL_BANK and variant % 2 == 0:
		draw_line(center + Vector2(-10, 2), center + Vector2(8, -3), Color("8f6351"), 1.0, true)
	elif material == TerrainLayout.MATERIAL_ASH and variant % 3 == 0:
		draw_circle(center + Vector2(variant - 4, 0), 1.5, Color("2c2428"))
	elif material == TerrainLayout.MATERIAL_PLATEAU and variant % 4 == 0:
		draw_line(center + Vector2(-7, 3), center + Vector2(5, -3), Color("2b2227"), 1.0, true)
