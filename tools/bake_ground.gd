extends SceneTree
## Assa o chão de um bioma em uma única imagem isométrica contínua (PLAN-054, F2).
## O desenho é feito em coordenadas de mundo (tiles), então lajes, terra e musgo não têm costura entre células.
## Uso: godot --headless --path . -s tools/bake_ground.gd -- <dagruve|docas|shedaklah|molor|durao|feng_tu|shendilavri|goranthis|pilares> <saida.png>

const SIZE := 60
const HALF_W := 32  # TILE_W / 2
const HALF_H := 16  # TILE_H / 2

var _warp := FastNoiseLite.new()
var _large := FastNoiseLite.new()
var _mid := FastNoiseLite.new()
var _fine := FastNoiseLite.new()
var _speck := FastNoiseLite.new()
var _slab_id := FastNoiseLite.new()
var _slab_edge := FastNoiseLite.new()
var _crack := FastNoiseLite.new()
var _cob_id := FastNoiseLite.new()
var _cob_edge := FastNoiseLite.new()
var _grain := FastNoiseLite.new()

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 2 or not (["dagruve", "docas"] + LAYOUT_STAGES).has(args[0]):
		push_error("Uso: bake_ground.gd <dagruve> <saida.png>")
		quit(1)
		return
	_setup_noise()
	var biome := String(args[0])
	if LAYOUT_STAGES.has(biome):
		_setup_layout(biome)
	var width := SIZE * 2 * HALF_W
	var height := SIZE * 2 * HALF_H
	var data := PackedByteArray()
	data.resize(width * height * 4)
	for py in height:
		for px in width:
			var sx := float(px) + 0.5 - width * 0.5
			var sy := float(py) + 0.5
			var gx := sx / 64.0 + sy / 32.0
			var gy := sy / 32.0 - sx / 64.0
			var o := (py * width + px) * 4
			if gx < 0.0 or gy < 0.0 or gx >= SIZE or gy >= SIZE:
				continue  # fora do losango: alfa 0
			var c := _dagruve(gx, gy) if biome == "dagruve" else (_docas(gx, gy) if biome == "docas" else _layout_color(gx, gy))
			data[o] = int(clampf(c.r, 0.0, 1.0) * 255.0)
			data[o + 1] = int(clampf(c.g, 0.0, 1.0) * 255.0)
			data[o + 2] = int(clampf(c.b, 0.0, 1.0) * 255.0)
			data[o + 3] = 255
	var image := Image.create_from_data(width, height, false, Image.FORMAT_RGBA8, data)
	var status := image.save_png(args[1])
	print("bake ", args[1], " ", width, "x", height, " status=", status)
	quit(0 if status == OK else 1)

func _setup_noise() -> void:
	_cfg(_warp, FastNoiseLite.TYPE_SIMPLEX_SMOOTH, 0.09, 11, 2)
	_cfg(_large, FastNoiseLite.TYPE_SIMPLEX_SMOOTH, 0.045, 23, 3)
	_cfg(_mid, FastNoiseLite.TYPE_SIMPLEX_SMOOTH, 0.22, 37, 3)
	_cfg(_fine, FastNoiseLite.TYPE_SIMPLEX_SMOOTH, 3.2, 41, 2)
	_cfg(_speck, FastNoiseLite.TYPE_VALUE, 11.0, 53, 1)
	_cfg(_slab_id, FastNoiseLite.TYPE_CELLULAR, 0.85, 67, 1)
	_slab_id.cellular_return_type = FastNoiseLite.RETURN_CELL_VALUE
	_slab_id.cellular_jitter = 0.85
	_cfg(_slab_edge, FastNoiseLite.TYPE_CELLULAR, 0.85, 67, 1)
	_slab_edge.cellular_return_type = FastNoiseLite.RETURN_DISTANCE2_SUB
	_slab_edge.cellular_jitter = 0.85
	_cfg(_grain, FastNoiseLite.TYPE_SIMPLEX_SMOOTH, 1.3, 97, 2)
	_cfg(_cob_id, FastNoiseLite.TYPE_CELLULAR, 1.5, 71, 1)
	_cob_id.cellular_return_type = FastNoiseLite.RETURN_CELL_VALUE
	_cob_id.cellular_jitter = 0.9
	_cfg(_cob_edge, FastNoiseLite.TYPE_CELLULAR, 1.5, 71, 1)
	_cob_edge.cellular_return_type = FastNoiseLite.RETURN_DISTANCE2_SUB
	_cob_edge.cellular_jitter = 0.9
	_cfg(_crack, FastNoiseLite.TYPE_CELLULAR, 0.21, 79, 1)
	_crack.cellular_return_type = FastNoiseLite.RETURN_DISTANCE2_SUB

func _cfg(n: FastNoiseLite, kind: int, freq: float, seed_value: int, octaves: int) -> void:
	n.noise_type = kind
	n.frequency = freq
	n.seed = seed_value
	if octaves > 1:
		n.fractal_type = FastNoiseLite.FRACTAL_FBM
		n.fractal_octaves = octaves
	else:
		n.fractal_type = FastNoiseLite.FRACTAL_NONE

static func _smooth(a: float, b: float, x: float) -> float:
	var t := clampf((x - a) / (b - a), 0.0, 1.0)
	return t * t * (3.0 - 2.0 * t)

## Distância de (gx,gy) a um segmento do mapa (ruas declaradas em data/scenery.json -> estradas).
static func _seg(gx: float, gy: float, ax: float, ay: float, bx: float, by: float) -> float:
	var abx := bx - ax
	var aby := by - ay
	var t := clampf(((gx - ax) * abx + (gy - ay) * aby) / (abx * abx + aby * aby), 0.0, 1.0)
	return Vector2(gx, gy).distance_to(Vector2(ax + abx * t, ay + aby * t))

func _dagruve(gx: float, gy: float) -> Color:
	# Domínio levemente deformado: bordas de laje e de mancha deixam de ser retas.
	var wx := gx + _warp.get_noise_2d(gx, gy) * 1.6
	var wy := gy + _warp.get_noise_2d(gy + 91.0, gx - 37.0) * 1.6
	var large := _large.get_noise_2d(gx, gy)
	var mid := _mid.get_noise_2d(gx, gy)
	var fine := _fine.get_noise_2d(gx, gy)
	var speck := _speck.get_noise_2d(gx, gy)
	var grain := _grain.get_noise_2d(gx, gy)

	# Estradas declaradas: rua leste-oeste (y=26) e rua do selo (x=42).
	var road := minf(_seg(gx, gy, 4.0, 26.0, 56.0, 26.0), _seg(gx, gy, 42.0, 26.0, 42.0, 56.0))
	var shoulder := 1.0 - _smooth(2.6, 5.6, road + mid * 1.4)

	# Pavimento antigo: praça do selo, entorno do poço, ruínas ao norte e remendos de rua no resto do distrito.
	var plaza := 1.0 - _smooth(7.0, 10.5, Vector2(gx, gy).distance_to(Vector2(42.0, 38.0)) + large * 3.0)
	var well := 1.0 - _smooth(2.5, 4.5, Vector2(gx, gy).distance_to(Vector2(36.0, 41.0)) + mid * 1.2)
	var ruins := 1.0 - _smooth(4.0, 7.5, Vector2(gx, gy).distance_to(Vector2(30.0, 8.0)) + large * 3.0)
	var patches := _smooth(0.18, 0.42, large + mid * 0.35) * 0.9
	var paving := maxf(maxf(plaza, well), maxf(ruins * 0.85, patches))
	paving *= 1.0 - shoulder * 0.7
	# Lajes quebradas: a terra aparece por entre as pedras.
	paving *= 1.0 - _smooth(0.42, 0.62, _crack.get_noise_2d(gx, gy) * 0.5 + mid * 0.6 + 0.2)

	# Terra batida escura, com manchas largas.
	var earth := Color(0.205, 0.180, 0.205).lerp(Color(0.275, 0.235, 0.250), _smooth(-0.5, 0.6, large))
	earth = earth.lerp(Color(0.160, 0.140, 0.165), _smooth(0.1, 0.5, mid * 0.7 - large * 0.4))
	earth += Color.WHITE * (fine * 0.03 + speck * 0.02 + grain * 0.05)
	# Seixos claros espalhados.
	if speck > 0.80 and fine > -0.2:
		earth = earth.lerp(Color(0.34, 0.31, 0.32), 0.65)

	# Capim morto e musgo azedo nas áreas largas e abertas.
	var moss_amount := _smooth(0.05, 0.38, large - mid * 0.25) * (1.0 - shoulder) * (1.0 - paving)
	var moss := Color(0.170, 0.225, 0.185).lerp(Color(0.260, 0.285, 0.190), _smooth(-0.3, 0.5, mid))
	moss += Color.WHITE * (fine * 0.03)
	if fine > 0.42 and speck > 0.1:
		moss = moss.lerp(Color(0.27, 0.30, 0.19), 0.7)  # tufos mais claros
	var ground := earth.lerp(moss, moss_amount)

	# Ombro de estrada: terra pisada, mais clara e seca, com sulcos.
	var rut := _smooth(0.55, 0.9, absf(fine) * 1.0 + 0.0) * 0.02
	var packed := Color(0.310, 0.270, 0.260) + Color.WHITE * (fine * 0.02 - rut)
	ground = ground.lerp(packed, shoulder * 0.85)

	# Lajes: cada laje tem tom próprio, argamassa escura e brilho suave no miolo.
	if paving > 0.02:
		var id := _slab_id.get_noise_2d(wx, wy)
		var edge := _slab_edge.get_noise_2d(wx, wy) + 1.0  # ~0 junto à junta, cresce para dentro da laje
		var slab := Color(0.255, 0.240, 0.265).lerp(Color(0.335, 0.310, 0.335), id * 0.5 + 0.5)
		if id > 0.55:
			slab = slab.lerp(Color(0.24, 0.27, 0.27), 0.55)  # laje esverdeada
		slab += Color.WHITE * (fine * 0.035 + grain * 0.045 + mid * 0.03)
		slab = slab.lerp(slab * 1.18, _smooth(0.15, 0.55, edge))
		var joint := 1.0 - _smooth(0.02, 0.085, edge)
		slab = slab.lerp(Color(0.095, 0.080, 0.105), joint * 0.85)
		# Musgo na junta.
		if joint > 0.2 and moss_amount > 0.05:
			slab = slab.lerp(moss, 0.4)
		var cover := _smooth(0.0, 0.2, paving)
		ground = ground.lerp(slab, cover)

	# Selo ritual: estampa violeta sob a praça (a armadilha desenha o glifo por cima).
	var seal_d := Vector2(gx, gy).distance_to(Vector2(42.0, 38.0))
	var seal := 1.0 - _smooth(2.4, 3.6, seal_d + fine * 0.15)
	ground = ground.lerp(Color(0.16, 0.085, 0.20), seal * 0.7)
	var ring := 1.0 - _smooth(0.0, 0.14, absf(seal_d - 3.9))
	ground = ground.lerp(Color(0.34, 0.15, 0.40), ring * 0.45)

	# Neblina: borda do mapa escurece e esfria; o centro fica mais legível.
	var edge_d := minf(minf(gx, gy), minf(SIZE - gx, SIZE - gy))
	ground = ground.lerp(Color(0.07, 0.065, 0.10), 1.0 - _smooth(0.0, 9.0, edge_d + large * 3.0))
	return ground

static func _hash(ix: int, iy: int) -> float:
	var h := (ix * 73856093) ^ (iy * 19349663)
	h = (h ^ (h >> 13)) * 1274126177
	return float(h & 0xffff) / 65535.0

## Docas: cais de tábuas na borda oeste (x≈3), água além dele, calçada molhada, pátio do armazém, píer leste, porão ritual e poças.
func _docas(gx: float, gy: float) -> Color:
	var wx := gx + _warp.get_noise_2d(gx, gy) * 1.2
	var wy := gy + _warp.get_noise_2d(gy + 91.0, gx - 37.0) * 1.2
	var large := _large.get_noise_2d(gx, gy)
	var mid := _mid.get_noise_2d(gx, gy)
	var fine := _fine.get_noise_2d(gx, gy)
	var speck := _speck.get_noise_2d(gx, gy)
	var grain := _grain.get_noise_2d(gx, gy)
	var p := Vector2(gx, gy)

	# Cascalho e lama molhada, tom de maré.
	var ground := Color(0.130, 0.175, 0.195).lerp(Color(0.185, 0.235, 0.250), _smooth(-0.5, 0.6, large))
	ground = ground.lerp(Color(0.095, 0.135, 0.155), _smooth(0.1, 0.5, mid * 0.7 - large * 0.4))
	ground += Color.WHITE * (fine * 0.03 + speck * 0.02 + grain * 0.045)
	if speck > 0.80 and fine > -0.2:
		ground = ground.lerp(Color(0.40, 0.45, 0.45), 0.6)  # cascalho e conchas

	# Calçada molhada: faixa junto ao cais, pátio sul e remendos.
	var along_quay := 1.0 - _smooth(5.0, 11.0, gx + large * 3.0)
	var south := 1.0 - _smooth(7.0, 11.0, p.distance_to(Vector2(21.0, 43.0)) + large * 3.0)
	var warehouse_yard := 1.0 - _smooth(5.5, 8.5, p.distance_to(Vector2(26.0, 14.0)) + large * 2.5)
	var patches := _smooth(0.22, 0.46, large + mid * 0.35) * 0.85
	var cobble_mask := maxf(maxf(along_quay * 0.9, south), maxf(patches, warehouse_yard * 0.6))
	cobble_mask *= 1.0 - _smooth(0.45, 0.65, _crack.get_noise_2d(gx, gy) * 0.5 + mid * 0.6 + 0.2)
	if cobble_mask > 0.02:
		var id := _cob_id.get_noise_2d(wx, wy)
		var edge := _cob_edge.get_noise_2d(wx, wy) + 1.0
		var stone := Color(0.215, 0.265, 0.285).lerp(Color(0.300, 0.350, 0.365), id * 0.5 + 0.5)
		stone += Color.WHITE * (fine * 0.03 + grain * 0.04)
		stone = stone.lerp(stone * 1.15, _smooth(0.15, 0.55, edge))
		var joint := 1.0 - _smooth(0.02, 0.09, edge)
		stone = stone.lerp(Color(0.075, 0.100, 0.115), joint * 0.8)
		ground = ground.lerp(stone, _smooth(0.0, 0.2, cobble_mask))

	# Tábuas: cais (x≈3.2), pátio de carga do armazém e píer leste. Tábuas correm ao longo de y no cais e de x nos píeres.
	var quay := 1.0 - _smooth(3.0, 3.4, absf(gx - 3.6) + mid * 0.5)
	var yard := 1.0 - _smooth(4.5, 4.9, p.distance_to(Vector2(26.0, 14.0)) * 0.8 + mid * 0.8)
	var pier := (1.0 - _smooth(2.9, 3.2, absf(gy - 18.0) + mid * 0.4)) * _smooth(36.0, 38.0, gx) * (1.0 - _smooth(54.0, 56.0, gx))
	var planks := maxf(quay, maxf(yard * 0.9, pier))
	if planks > 0.02:
		var along_y := quay >= maxf(yard, pier) or yard >= pier
		var u := gx * 1.55 if along_y else gy * 1.55
		var v := gy if along_y else gx
		var plank_i := int(floor(u))
		var fu := u - float(plank_i)
		var seg := int(floor(v / 3.2 + _hash(plank_i, 7) * 3.0))  # emendas escalonadas
		var tone := _hash(plank_i, seg)
		var wood := Color(0.255, 0.205, 0.165).lerp(Color(0.345, 0.285, 0.225), tone)
		wood = wood.lerp(Color(0.19, 0.20, 0.19), _smooth(0.55, 1.0, _hash(seg, plank_i + 3)) * 0.6)  # tábua apodrecida
		wood += Color.WHITE * (grain * 0.035 + fine * 0.03 + _speck.get_noise_2d(gx * 0.2, gy * 3.0) * 0.015)
		var gap := 1.0 - _smooth(0.0, 0.09, minf(fu, 1.0 - fu))
		wood = wood.lerp(Color(0.045, 0.060, 0.070), gap * 0.9)
		var seam := 1.0 - _smooth(0.0, 0.03, absf(fposmod(v / 3.2 + _hash(plank_i, 7) * 3.0, 1.0) - 0.0) * 3.2 / 3.2)
		wood = wood.lerp(Color(0.05, 0.06, 0.07), seam * 0.6)
		ground = ground.lerp(wood, _smooth(0.0, 0.25, planks))

	# Água: além do cais, com ondas e espuma na margem.
	var shore := gx + _warp.get_noise_2d(gx * 0.7, gy * 0.7) * 1.0
	var water := 1.0 - _smooth(0.9, 1.5, shore)
	if water > 0.0 or shore < 2.2:
		var ripple := sin((gy * 2.2 + _mid.get_noise_2d(gx * 2.0, gy * 2.0) * 3.0 + gx * 1.3)) * 0.5 + 0.5
		var sea := Color(0.040, 0.105, 0.140).lerp(Color(0.075, 0.185, 0.225), ripple * 0.5 + fine * 0.2)
		if ripple > 0.9 and speck > 0.1:
			sea = sea.lerp(Color(0.30, 0.50, 0.55), 0.35)
		ground = ground.lerp(sea, water)
		var foam := (1.0 - _smooth(0.0, 0.25, absf(shore - 1.4))) * _smooth(-0.3, 0.3, fine + mid)
		ground = ground.lerp(Color(0.45, 0.58, 0.58), foam * 0.45)

	# Poças: espelhos escuros com brilho, só em chão aberto.
	var puddle := _smooth(0.34, 0.46, mid - large * 0.3 + fine * 0.05) * (1.0 - planks) * (1.0 - water)
	if puddle > 0.0:
		var sheen := Color(0.060, 0.115, 0.140).lerp(Color(0.14, 0.25, 0.29), _smooth(0.0, 0.8, grain + 0.3))
		ground = ground.lerp(sheen, puddle * 0.85)

	# Porão ritual: laje escura com mancha vinho ao redor do poço da fenda (40,28).
	var ritual_d := p.distance_to(Vector2(40.0, 28.0))
	var ritual := 1.0 - _smooth(4.5, 6.5, ritual_d + large * 1.5)
	if ritual > 0.0:
		var id2 := _cob_id.get_noise_2d(wx * 0.6, wy * 0.6)
		var edge2 := _cob_edge.get_noise_2d(wx * 0.6, wy * 0.6) + 1.0
		var slab := Color(0.14, 0.12, 0.17).lerp(Color(0.21, 0.17, 0.22), id2 * 0.5 + 0.5)
		slab = slab.lerp(Color(0.04, 0.03, 0.05), (1.0 - _smooth(0.03, 0.10, edge2)) * 0.9)
		slab = slab.lerp(Color(0.30, 0.08, 0.12), _smooth(0.2, 0.7, mid + 0.2) * 0.35 * (1.0 - _smooth(0.0, 4.0, ritual_d)))
		ground = ground.lerp(slab, ritual)

	# Neblina de maré nas bordas (exceto o lado da água, já escuro).
	var edge_d := minf(minf(gy, SIZE - gx), SIZE - gy)
	ground = ground.lerp(Color(0.045, 0.080, 0.100), 1.0 - _smooth(0.0, 8.0, edge_d + large * 3.0))
	return ground

# ---------------------------------------------------------------------------
# Biomas com macroterreno (TerrainLayout): o chão assado respeita os materiais do layout,
# então água do Estige, margens, paredes e montanhas coincidem com a jogabilidade.
# ---------------------------------------------------------------------------
const GRID_RES := 5  # células por tile na tabela de materiais
const LAYOUT_STAGES := ["shedaklah", "molor", "durao", "feng_tu", "shendilavri", "goranthis", "pilares"]
const FOG := {
	"shedaklah": Color(0.07, 0.05, 0.09), "molor": Color(0.04, 0.07, 0.05), "durao": Color(0.08, 0.05, 0.05),
	"feng_tu": Color(0.05, 0.06, 0.09), "shendilavri": Color(0.07, 0.04, 0.09), "goranthis": Color(0.22, 0.20, 0.14),
	"pilares": Color(0.04, 0.04, 0.08),
}

const WATER := ["shedaklah_styx", "shallow", "current", "shendilavri_styx", "goranthis_styxfall", "shedaklah_bank", "shendilavri_bank", "goranthis_bank", "bank"]

var _stage := ""
var _grid: Array = []
var _specs: Dictionary = {}
# Ruídos da posição corrente, preenchidos por _layout_color antes de cada _shade.
var _large_v := 0.0
var _mid_v := 0.0
var _fine_v := 0.0
var _speck_v := 0.0
var _grain_v := 0.0

static func _sp(style: String, c1: Color, c2: Color, c3: Color) -> Dictionary:
	return {"style": style, "c1": c1, "c2": c2, "c3": c3}

func _setup_layout(stage: String) -> void:
	_stage = stage
	TerrainLayout.scale = float(SIZE) / 40.0
	var cells := SIZE * GRID_RES
	_grid.resize(cells * cells)
	for j in cells:
		for i in cells:
			_grid[j * cells + i] = TerrainLayout.material_at(stage, Vector2((i + 0.5) / GRID_RES, (j + 0.5) / GRID_RES))
	_apply_zones(stage)
	var s := _specs
	# Shedaklah
	s["fungal_soil"] = _sp("soil", Color(0.17, 0.14, 0.20), Color(0.24, 0.19, 0.26), Color(0.11, 0.09, 0.14))
	s["mycelium"] = _sp("web", Color(0.27, 0.19, 0.27), Color(0.37, 0.27, 0.36), Color(0.20, 0.13, 0.20))
	s["ooze_crust"] = _sp("ooze", Color(0.21, 0.25, 0.16), Color(0.29, 0.33, 0.20), Color(0.42, 0.48, 0.28))
	s["shedaklah_bank"] = _sp("bank", Color(0.25, 0.21, 0.25), Color(0.34, 0.29, 0.33), Color(0.15, 0.12, 0.16))
	s["shedaklah_styx"] = _sp("water", Color(0.045, 0.070, 0.110), Color(0.105, 0.150, 0.220), Color(0.20, 0.30, 0.40))
	s["shedaklah_path"] = _sp("web", Color(0.42, 0.34, 0.38), Color(0.52, 0.43, 0.46), Color(0.30, 0.22, 0.28))
	s["shedaklah_plaza"] = _sp("crack", Color(0.27, 0.22, 0.28), Color(0.36, 0.30, 0.36), Color(0.08, 0.06, 0.10))
	s["shedaklah_grove"] = _sp("moss", Color(0.12, 0.17, 0.15), Color(0.18, 0.24, 0.20), Color(0.08, 0.11, 0.10))
	s["shedaklah_pool"] = _sp("ooze", Color(0.20, 0.28, 0.12), Color(0.30, 0.40, 0.16), Color(0.50, 0.62, 0.26))
	s["shedaklah_spore"] = _sp("web", Color(0.30, 0.20, 0.30), Color(0.42, 0.28, 0.40), Color(0.20, 0.12, 0.20))
	# Molor
	s["molor_rock"] = _sp("rock", Color(0.13, 0.19, 0.15), Color(0.20, 0.27, 0.21), Color(0.07, 0.11, 0.08))
	s["molor_detritus"] = _sp("soil", Color(0.20, 0.23, 0.15), Color(0.29, 0.31, 0.19), Color(0.12, 0.14, 0.09))
	s["molor_ooze"] = _sp("ooze", Color(0.21, 0.31, 0.13), Color(0.32, 0.44, 0.18), Color(0.55, 0.68, 0.30))
	s["molor_causeway"] = _sp("crack", Color(0.31, 0.34, 0.25), Color(0.41, 0.44, 0.32), Color(0.07, 0.09, 0.05))
	s["molor_plaza"] = _sp("slab", Color(0.19, 0.23, 0.19), Color(0.27, 0.31, 0.25), Color(0.05, 0.07, 0.05))
	s["molor_junk"] = _sp("soil", Color(0.19, 0.17, 0.12), Color(0.28, 0.25, 0.17), Color(0.11, 0.10, 0.07))
	s["molor_roof"] = _sp("rock", Color(0.08, 0.13, 0.10), Color(0.14, 0.21, 0.16), Color(0.04, 0.07, 0.05))
	s["molor_nest"] = _sp("web", Color(0.26, 0.18, 0.20), Color(0.36, 0.25, 0.27), Color(0.18, 0.11, 0.13))
	s["durao_road"] = _sp("crack", Color(0.31, 0.25, 0.22), Color(0.40, 0.33, 0.29), Color(0.09, 0.07, 0.07))
	s["durao_plaza"] = _sp("slab", Color(0.20, 0.16, 0.15), Color(0.29, 0.23, 0.21), Color(0.05, 0.04, 0.04))
	s["durao_deck"] = _sp("slab", Color(0.22, 0.15, 0.12), Color(0.31, 0.22, 0.17), Color(0.06, 0.04, 0.03))
	s["durao_ossuario"] = _sp("soil", Color(0.33, 0.29, 0.26), Color(0.43, 0.38, 0.33), Color(0.22, 0.19, 0.17))
	s["durao_scree"] = _sp("rock", Color(0.19, 0.15, 0.15), Color(0.28, 0.22, 0.21), Color(0.08, 0.06, 0.06))
	s["molor_wall"] = _sp("rock", Color(0.07, 0.12, 0.09), Color(0.13, 0.19, 0.14), Color(0.03, 0.06, 0.04))
	# Durao
	s["plateau"] = _sp("soil", Color(0.23, 0.17, 0.14), Color(0.32, 0.24, 0.19), Color(0.15, 0.11, 0.10))
	s["ash"] = _sp("ash", Color(0.29, 0.25, 0.24), Color(0.38, 0.33, 0.31), Color(0.20, 0.17, 0.17))
	s["slope"] = _sp("rock", Color(0.13, 0.11, 0.12), Color(0.23, 0.19, 0.19), Color(0.06, 0.05, 0.06))
	s["bank"] = _sp("bank", Color(0.30, 0.22, 0.19), Color(0.40, 0.30, 0.25), Color(0.18, 0.13, 0.12))
	s["shallow"] = _sp("water", Color(0.08, 0.22, 0.29), Color(0.17, 0.38, 0.46), Color(0.45, 0.65, 0.70))
	s["current"] = _sp("water", Color(0.03, 0.10, 0.17), Color(0.07, 0.18, 0.28), Color(0.25, 0.40, 0.50))
	# Feng-tu
	s["feng_tu_stone"] = _sp("slab", Color(0.20, 0.24, 0.29), Color(0.29, 0.33, 0.38), Color(0.06, 0.08, 0.11))
	s["feng_tu_ash"] = _sp("ash", Color(0.27, 0.28, 0.30), Color(0.36, 0.37, 0.39), Color(0.18, 0.19, 0.21))
	s["feng_tu_crack"] = _sp("crack", Color(0.15, 0.18, 0.23), Color(0.22, 0.26, 0.31), Color(0.04, 0.05, 0.08))
	s["feng_tu_road"] = _sp("slab", Color(0.42, 0.39, 0.35), Color(0.54, 0.50, 0.44), Color(0.12, 0.11, 0.11))
	s["feng_tu_plaza"] = _sp("slab", Color(0.30, 0.20, 0.20), Color(0.40, 0.27, 0.26), Color(0.09, 0.06, 0.07))
	s["feng_tu_moss"] = _sp("moss", Color(0.15, 0.22, 0.20), Color(0.22, 0.31, 0.27), Color(0.09, 0.14, 0.13))
	s["feng_tu_foundation"] = _sp("rock", Color(0.08, 0.10, 0.14), Color(0.14, 0.17, 0.22), Color(0.03, 0.04, 0.06))
	# Shendilavri
	s["shendilavri_marble"] = _sp("slab", Color(0.23, 0.17, 0.27), Color(0.34, 0.26, 0.37), Color(0.07, 0.05, 0.09))
	s["shendilavri_vein"] = _sp("vein", Color(0.29, 0.19, 0.29), Color(0.40, 0.27, 0.38), Color(0.08, 0.05, 0.09))
	s["shendilavri_dust"] = _sp("ash", Color(0.33, 0.26, 0.36), Color(0.43, 0.34, 0.46), Color(0.22, 0.17, 0.25))
	s["shendilavri_road"] = _sp("slab", Color(0.42, 0.34, 0.44), Color(0.54, 0.45, 0.56), Color(0.12, 0.08, 0.13))
	s["shendilavri_plaza"] = _sp("slab", Color(0.36, 0.22, 0.34), Color(0.47, 0.30, 0.45), Color(0.10, 0.06, 0.10))
	s["shendilavri_crystal"] = _sp("vein", Color(0.20, 0.12, 0.24), Color(0.30, 0.18, 0.34), Color(0.06, 0.03, 0.08))
	s["shendilavri_foundation"] = _sp("rock", Color(0.10, 0.07, 0.14), Color(0.17, 0.12, 0.22), Color(0.04, 0.03, 0.06))
	s["shendilavri_bank"] = _sp("bank", Color(0.36, 0.25, 0.35), Color(0.45, 0.32, 0.43), Color(0.22, 0.15, 0.22))
	s["shendilavri_styx"] = _sp("water", Color(0.07, 0.06, 0.13), Color(0.14, 0.12, 0.24), Color(0.30, 0.25, 0.45))
	# Goranthis
	s["goranthis_terrace"] = _sp("slab", Color(0.45, 0.42, 0.30), Color(0.56, 0.53, 0.38), Color(0.20, 0.18, 0.12))
	s["goranthis_pearl"] = _sp("slab", Color(0.62, 0.58, 0.45), Color(0.74, 0.70, 0.55), Color(0.30, 0.28, 0.20))
	s["goranthis_moss"] = _sp("moss", Color(0.38, 0.42, 0.25), Color(0.50, 0.54, 0.32), Color(0.24, 0.27, 0.15))
	s["goranthis_road"] = _sp("slab", Color(0.80, 0.78, 0.66), Color(0.90, 0.88, 0.76), Color(0.40, 0.36, 0.26))
	s["goranthis_gold"] = _sp("slab", Color(0.58, 0.50, 0.30), Color(0.70, 0.62, 0.38), Color(0.25, 0.20, 0.10))
	s["goranthis_withered"] = _sp("moss", Color(0.33, 0.30, 0.20), Color(0.42, 0.38, 0.26), Color(0.20, 0.18, 0.12))
	s["goranthis_foundation"] = _sp("rock", Color(0.24, 0.21, 0.16), Color(0.34, 0.30, 0.22), Color(0.12, 0.10, 0.08))
	s["goranthis_bank"] = _sp("bank", Color(0.55, 0.50, 0.38), Color(0.66, 0.60, 0.46), Color(0.36, 0.32, 0.24))
	s["goranthis_styxfall"] = _sp("fall", Color(0.42, 0.60, 0.68), Color(0.72, 0.84, 0.88), Color(0.90, 0.96, 0.96))
	# Pilares
	s["pillars_obsidian"] = _sp("slab", Color(0.11, 0.10, 0.18), Color(0.18, 0.16, 0.28), Color(0.03, 0.03, 0.06))
	s["pillars_basalt"] = _sp("slab", Color(0.17, 0.15, 0.25), Color(0.25, 0.22, 0.35), Color(0.04, 0.04, 0.08))
	s["pillars_dust"] = _sp("ash", Color(0.24, 0.21, 0.32), Color(0.33, 0.29, 0.42), Color(0.16, 0.14, 0.22))
	s["pillars_road"] = _sp("slab", Color(0.30, 0.27, 0.42), Color(0.40, 0.36, 0.54), Color(0.08, 0.07, 0.14))
	s["pillars_plaza"] = _sp("vein", Color(0.20, 0.15, 0.30), Color(0.30, 0.22, 0.42), Color(0.04, 0.03, 0.07))
	s["pillars_crystal"] = _sp("vein", Color(0.17, 0.12, 0.30), Color(0.26, 0.18, 0.44), Color(0.04, 0.03, 0.09))
	s["pillars_foundation"] = _sp("rock", Color(0.06, 0.06, 0.11), Color(0.11, 0.10, 0.18), Color(0.02, 0.02, 0.05))

## Level design (data/level_design.json -> "chao"): sobrepõe materiais visuais ao layout, sem tocar em água e margem.
func _apply_zones(stage: String) -> void:
	var file := FileAccess.open("res://data/level_design.json", FileAccess.READ)
	if file == null:
		return
	var design: Dictionary = JSON.parse_string(file.get_as_text()).get(stage, {})
	var chao: Dictionary = design.get("chao", {})
	if chao.is_empty():
		return
	var cells := SIZE * GRID_RES
	for j in cells:
		for i in cells:
			var idx := j * cells + i
			var base := String(_grid[idx])
			if WATER.has(base) or base.ends_with("wall") or base.ends_with("foundation") or base == "slope":
				continue
			var p := Vector2((i + 0.5) / GRID_RES, (j + 0.5) / GRID_RES)
			var m := base
			for dom in chao.get("dominancia", []):
				var v: float = p.x if String(dom.axis) == "x" else p.y
				var inside: bool = (dom.has("below") and v < float(dom.below)) or (dom.has("above") and v > float(dom.above))
				if inside and dom.replace.has(m) and _large.get_noise_2d(p.x * 1.7, p.y * 1.7) >= float(dom.get("noise_min", -1.0)):
					m = String(dom.replace[m])
			for region in chao.get("regioes", []):
				var c: Array = region.center
				if p.distance_to(Vector2(float(c[0]), float(c[1]))) <= float(region.radius):
					m = String(region.material)
			if chao.has("clareira"):
				var cc: Array = chao.clareira.center
				if p.distance_to(Vector2(float(cc[0]), float(cc[1]))) <= float(chao.clareira.radius):
					m = String(chao.clareira.material)
			for lane in chao.get("trilhas", []):
				var at := float(lane.at)
				var along: float = p.x if String(lane.axis) == "x" else p.y
				var across: float = absf((p.y if String(lane.axis) == "x" else p.x) - at)
				if along >= float(lane.from) and along <= float(lane.to) and across <= float(lane.half_width):
					m = String(lane.material)
			for plaza in chao.get("pracas", []):
				var pc: Array = plaza.center
				if p.distance_to(Vector2(float(pc[0]), float(pc[1]))) <= float(plaza.radius):
					m = String(plaza.material)
			_grid[idx] = m

func _mat_at(x: float, y: float) -> String:
	var cells := SIZE * GRID_RES
	var i := clampi(int(x * GRID_RES), 0, cells - 1)
	var j := clampi(int(y * GRID_RES), 0, cells - 1)
	return String(_grid[j * cells + i])

func _layout_color(gx: float, gy: float) -> Color:
	_large_v = _large.get_noise_2d(gx, gy)
	_mid_v = _mid.get_noise_2d(gx, gy)
	_fine_v = _fine.get_noise_2d(gx, gy)
	_speck_v = _speck.get_noise_2d(gx, gy)
	_grain_v = _grain.get_noise_2d(gx, gy)
	# Bordas de material orgânicas: a consulta ao layout é deslocada por ruído (até ~0,5 tile).
	# Perto de água e margem o deslocamento é pequeno: a jogabilidade usa o layout sem deformação.
	var amp := 1.0
	for probe in [Vector2(1.0, 0.0), Vector2(-1.0, 0.0), Vector2(0.0, 1.0), Vector2(0.0, -1.0)]:
		if WATER.has(_mat_at(gx + probe.x, gy + probe.y)):
			amp = 0.3
	var lx := gx + (_warp.get_noise_2d(gx * 1.3, gy * 1.3) * 1.3 + _mid_v * 0.5 + _fine_v * 0.12) * amp
	var ly := gy + (_warp.get_noise_2d(gy * 1.3 + 40.0, gx * 1.3) * 1.3 + _mid.get_noise_2d(gy + 50.0, gx - 20.0) * 0.5 + _grain_v * 0.15) * amp
	var m0 := _mat_at(lx, ly)
	var color := _shade(m0, gx, gy)
	for off in [Vector2(0.45, 0.0), Vector2(-0.45, 0.0), Vector2(0.0, 0.45), Vector2(0.0, -0.45)]:
		var mk := _mat_at(lx + off.x, ly + off.y)
		if mk != m0:
			color = color.lerp(_shade(mk, gx, gy), 0.28)
	var edge_d := minf(minf(gx, gy), minf(SIZE - gx, SIZE - gy))
	return color.lerp(FOG[_stage], 1.0 - _smooth(0.0, 7.0, edge_d + _large_v * 3.0))

func _shade(material: String, gx: float, gy: float) -> Color:
	var sp: Dictionary = _specs.get(material, {})
	if sp.is_empty():
		return Color(0.2, 0.2, 0.2)
	var c1: Color = sp.c1
	var c2: Color = sp.c2
	var c3: Color = sp.c3
	var white := Color.WHITE
	var wx := gx + _warp.get_noise_2d(gx, gy) * 1.2
	var wy := gy + _warp.get_noise_2d(gy + 91.0, gx - 37.0) * 1.2
	match String(sp.style):
		"soil", "bank", "moss", "web":
			var c := c1.lerp(c2, _smooth(-0.5, 0.6, _large_v))
			c = c.lerp(c3, _smooth(0.1, 0.5, _mid_v * 0.7 - _large_v * 0.4))
			c += white * (_fine_v * 0.03 + _speck_v * 0.02 + _grain_v * 0.05)
			var pebble := 0.70 if sp.style == "bank" else 0.80
			if _speck_v > pebble and _fine_v > -0.2:
				c = c.lerp(c2 * 1.35, 0.55)
			if sp.style == "moss" and _fine_v > 0.40 and _speck_v > 0.1:
				c = c.lerp(c2 * 1.25, 0.6)
			if sp.style == "web":
				var e := _cob_edge.get_noise_2d(wx, wy) + 1.0
				c = c.lerp(c2 * 1.45, (1.0 - _smooth(0.02, 0.09, e)) * 0.5)
			return c
		"ash":
			var c := c1.lerp(c2, _smooth(-0.6, 0.6, _large_v * 0.7 + _grain_v * 0.4))
			c = c.lerp(c3, _smooth(0.2, 0.6, _mid_v) * 0.5)
			c += white * (_fine_v * 0.025 + _speck_v * 0.02)
			if _speck_v > 0.86:
				c = c.lerp(c2 * 1.3, 0.5)
			return c
		"slab", "crack", "vein":
			var id := _slab_id.get_noise_2d(wx, wy)
			var edge := _slab_edge.get_noise_2d(wx, wy) + 1.0
			var c := c1.lerp(c2, id * 0.5 + 0.5)
			c += white * (_fine_v * 0.035 + _grain_v * 0.045 + _mid_v * 0.03)
			c = c.lerp(c * 1.18, _smooth(0.15, 0.55, edge))
			var joint := 1.0 - _smooth(0.02, 0.085, edge)
			c = c.lerp(c3, joint * 0.88)
			if sp.style == "crack":
				var k := _crack.get_noise_2d(wx, wy) + 1.0
				c = c.lerp(c3, (1.0 - _smooth(0.03, 0.10, k)) * 0.85)
			elif sp.style == "vein":
				var k2 := _crack.get_noise_2d(wx, wy) + 1.0
				c = c.lerp(c2 * 1.7, (1.0 - _smooth(0.02, 0.07, k2)) * 0.55)
			return c
		"water":
			var ripple := sin(gy * 2.2 + _mid.get_noise_2d(gx * 2.0, gy * 2.0) * 3.0 + gx * 1.3) * 0.5 + 0.5
			var c := c1.lerp(c2, ripple * 0.5 + _fine_v * 0.2)
			if ripple > 0.9 and _speck_v > 0.1:
				c = c.lerp(c3, 0.35)
			return c
		"fall":
			var streak := _fine.get_noise_2d((gx - gy) * 2.2, (gx + gy) * 0.12) * 0.5 + 0.5
			var c := c1.lerp(c2, streak)
			if streak > 0.8:
				c = c.lerp(c3, 0.5)
			return c
		"ooze":
			var c := c1.lerp(c2, _smooth(-0.4, 0.6, _mid_v))
			var e2 := _cob_edge.get_noise_2d(wx, wy) + 1.0
			c = c.lerp(c1 * 0.6, (1.0 - _smooth(0.02, 0.12, e2)) * 0.5)
			c = c.lerp(c3, _smooth(0.55, 0.78, e2) * 0.45)
			c += white * (_fine_v * 0.025 + _grain_v * 0.03)
			return c
		"rock":
			var ridge := clampf(1.0 - absf(_mid.get_noise_2d(gx * 1.6, gy * 1.6)) * 2.2, 0.0, 1.0)
			var c := c1.lerp(c2, ridge * 0.8 + _large_v * 0.2)
			c += white * (_fine_v * 0.04 + _grain_v * 0.05)
			var k3 := _crack.get_noise_2d(wx, wy) + 1.0
			c = c.lerp(c3, (1.0 - _smooth(0.012, 0.04, k3)) * 0.6)
			return c
	return c1
