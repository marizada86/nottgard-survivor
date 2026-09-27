class_name TerrainLayout
extends RefCounted
## Layouts determinísticos de macroterreno. Não consomem a RNG da batalha.

const MATERIAL_PLATEAU := &"plateau"
const MATERIAL_ASH := &"ash"
const MATERIAL_SLOPE := &"slope"
const MATERIAL_BANK := &"bank"
const MATERIAL_SHALLOW := &"shallow"
const MATERIAL_CURRENT := &"current"
const MATERIAL_FUNGAL_SOIL := &"fungal_soil"
const MATERIAL_MYCELIUM := &"mycelium"
const MATERIAL_OOZE_CRUST := &"ooze_crust"
const MATERIAL_SHEDAKLAH_BANK := &"shedaklah_bank"
const MATERIAL_SHEDAKLAH_STYX := &"shedaklah_styx"
const MATERIAL_MOLOR_ROCK := &"molor_rock"
const MATERIAL_MOLOR_DETRITUS := &"molor_detritus"
const MATERIAL_MOLOR_OOZE := &"molor_ooze"
const MATERIAL_MOLOR_WALL := &"molor_wall"

static var STYX_FLOW := Vector2(0.72, 0.48).normalized()
const STYX_CENTER_X := 27.0
const STYX_CURRENT_HALF_WIDTH := 1.25
const STYX_SHALLOW_HALF_WIDTH := 2.35
const STYX_BANK_HALF_WIDTH := 3.35
const MOUNTAINS := [
	Vector3(7.0, 9.0, 2.2), Vector3(10.0, 30.0, 2.0),
	Vector3(34.0, 12.0, 2.3), Vector3(34.0, 31.0, 2.1),
]
const MOLOR_OOZE_POCKETS := [
	Vector3(7.0, 10.0, 3.7), Vector3(31.0, 11.0, 3.3),
	Vector3(11.0, 31.0, 3.1), Vector3(30.0, 29.0, 4.0),
]

static func styx_center_x(y: float) -> float:
	# Curva lenta e fixa: forma uma faixa contínua, sem padrões de tile.
	return STYX_CENTER_X + sin((y - 8.0) * 0.22) * 2.1 + sin(y * 0.07) * 0.8

static func styx_offset(p: Vector2) -> float:
	return absf(p.x - styx_center_x(p.y))

static func shedaklah_styx_center_x(y: float, left_branch: bool) -> float:
	# Dois braços lentos e contínuos nas bordas; a arena central fica fúngica.
	var edge := 3.4 if left_branch else 36.6
	var curve := sin((y + (3.0 if left_branch else 11.0)) * 0.18) * 1.15
	return edge + curve

static func shedaklah_styx_offset(p: Vector2) -> float:
	return minf(
		absf(p.x - shedaklah_styx_center_x(p.y, true)),
		absf(p.x - shedaklah_styx_center_x(p.y, false))
	)

static func material_at(stage_id: String, p: Vector2) -> StringName:
	if stage_id == "durao":
		var offset := styx_offset(p)
		if offset <= STYX_CURRENT_HALF_WIDTH:
			return MATERIAL_CURRENT
		if offset <= STYX_SHALLOW_HALF_WIDTH:
			return MATERIAL_SHALLOW
		if offset <= STYX_BANK_HALF_WIDTH:
			return MATERIAL_BANK
		if is_blocked(stage_id, p):
			return MATERIAL_SLOPE
		# Grandes manchas, em vez de variação independente por célula.
		var patch := int(floor(p.x / 7.0) + floor(p.y / 6.0) * 3.0)
		return MATERIAL_ASH if posmod(patch, 4) == 1 else MATERIAL_PLATEAU
	if stage_id == "shedaklah":
		var branch_offset := shedaklah_styx_offset(p)
		if branch_offset <= 1.2:
			return MATERIAL_SHEDAKLAH_STYX
		if branch_offset <= 2.25:
			return MATERIAL_SHEDAKLAH_BANK
		# Manchas grandes tornam a disputa fungo × ooze legível sem ruído de tile.
		var fungal_patch := int(floor(p.x / 6.0) + floor(p.y / 7.0) * 5.0)
		if posmod(fungal_patch, 7) == 2:
			return MATERIAL_OOZE_CRUST
		return MATERIAL_MYCELIUM if posmod(fungal_patch, 3) == 0 else MATERIAL_FUNGAL_SOIL
	if stage_id == "molor":
		var edge_distance := minf(minf(p.x, p.y), minf(39.0 - p.x, 39.0 - p.y))
		if edge_distance <= 2.0:
			return MATERIAL_MOLOR_WALL
		for pocket in MOLOR_OOZE_POCKETS:
			if p.distance_to(Vector2(pocket.x, pocket.y)) <= pocket.z:
				return MATERIAL_MOLOR_OOZE
		var debris_patch := int(floor(p.x / 7.0) + floor(p.y / 6.0) * 3.0)
		return MATERIAL_MOLOR_DETRITUS if posmod(debris_patch, 5) == 1 else MATERIAL_MOLOR_ROCK
	return MATERIAL_PLATEAU

static func is_shedaklah_styx(stage_id: String, p: Vector2) -> bool:
	return stage_id == "shedaklah" and material_at(stage_id, p) == MATERIAL_SHEDAKLAH_STYX

static func is_styx_water(stage_id: String, p: Vector2) -> bool:
	if stage_id != "durao":
		return false
	var material := material_at(stage_id, p)
	return material == MATERIAL_SHALLOW or material == MATERIAL_CURRENT

static func is_styx_current(stage_id: String, p: Vector2) -> bool:
	return stage_id == "durao" and styx_offset(p) <= STYX_CURRENT_HALF_WIDTH

static func distance_to_styx(stage_id: String, p: Vector2) -> float:
	if stage_id != "durao":
		return INF
	return maxf(0.0, styx_offset(p) - STYX_SHALLOW_HALF_WIDTH)

static func direction_to_styx(stage_id: String, p: Vector2) -> Vector2:
	if stage_id != "durao":
		return Vector2.ZERO
	return Vector2.RIGHT if p.x < styx_center_x(p.y) else Vector2.LEFT

static func flow_at(stage_id: String, p: Vector2) -> Vector2:
	return STYX_FLOW if is_styx_water(stage_id, p) else Vector2.ZERO

static func is_blocked(stage_id: String, p: Vector2) -> bool:
	if stage_id != "durao":
		return false
	for mountain in MOUNTAINS:
		if p.distance_to(Vector2(mountain.x, mountain.y)) < mountain.z:
			return true
	return false

static func mountain_anchors(stage_id: String) -> Array:
	return MOUNTAINS.duplicate() if stage_id == "durao" else []

static func styx_sample(stage_id: String, material: StringName = MATERIAL_CURRENT) -> Vector2:
	if stage_id != "durao":
		return Vector2(20.0, 20.0)
	var y := 20.0
	var offset := 0.0 if material == MATERIAL_CURRENT else (1.8 if material == MATERIAL_SHALLOW else 2.8)
	return Vector2(styx_center_x(y) + offset, y)

static func color_for(material: StringName) -> Color:
	match material:
		MATERIAL_ASH: return Color("5a4038")
		MATERIAL_SLOPE: return Color("342a2d")
		MATERIAL_BANK: return Color("62493e")
		MATERIAL_SHALLOW: return Color("173e50")
		MATERIAL_CURRENT: return Color("091c2b")
		MATERIAL_FUNGAL_SOIL: return Color("39303d")
		MATERIAL_MYCELIUM: return Color("514151")
		MATERIAL_OOZE_CRUST: return Color("48503a")
		MATERIAL_SHEDAKLAH_BANK: return Color("443b42")
		MATERIAL_SHEDAKLAH_STYX: return Color("101923")
		MATERIAL_MOLOR_ROCK: return Color("26352b")
		MATERIAL_MOLOR_DETRITUS: return Color("3a4430")
		MATERIAL_MOLOR_OOZE: return Color("43562e")
		MATERIAL_MOLOR_WALL: return Color("17251e")
		_: return Color("493833")
