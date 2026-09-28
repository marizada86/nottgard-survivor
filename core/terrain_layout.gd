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
const MATERIAL_FENG_TU_STONE := &"feng_tu_stone"
const MATERIAL_FENG_TU_ASH := &"feng_tu_ash"
const MATERIAL_FENG_TU_CRACK := &"feng_tu_crack"
const MATERIAL_FENG_TU_FOUNDATION := &"feng_tu_foundation"
const MATERIAL_SHENDILAVRI_MARBLE := &"shendilavri_marble"
const MATERIAL_SHENDILAVRI_VEIN := &"shendilavri_vein"
const MATERIAL_SHENDILAVRI_DUST := &"shendilavri_dust"
const MATERIAL_SHENDILAVRI_FOUNDATION := &"shendilavri_foundation"
const MATERIAL_SHENDILAVRI_BANK := &"shendilavri_bank"
const MATERIAL_SHENDILAVRI_STYX := &"shendilavri_styx"
const MATERIAL_GORANTHIS_TERRACE := &"goranthis_terrace"
const MATERIAL_GORANTHIS_PEARL := &"goranthis_pearl"
const MATERIAL_GORANTHIS_MOSS := &"goranthis_moss"
const MATERIAL_GORANTHIS_FOUNDATION := &"goranthis_foundation"
const MATERIAL_GORANTHIS_BANK := &"goranthis_bank"
const MATERIAL_GORANTHIS_STYXFALL := &"goranthis_styxfall"
const MATERIAL_PILLARS_OBSIDIAN := &"pillars_obsidian"
const MATERIAL_PILLARS_BASALT := &"pillars_basalt"
const MATERIAL_PILLARS_DUST := &"pillars_dust"
const MATERIAL_PILLARS_FOUNDATION := &"pillars_foundation"

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

static func shendilavri_styx_center_x(y: float) -> float:
	# Um único braço calmo na margem: compõe a cena sem cortar a arena central.
	return 3.6 + sin((y + 4.0) * 0.19) * 1.05 + sin(y * 0.06) * 0.45

static func shendilavri_styx_offset(p: Vector2) -> float:
	return absf(p.x - shendilavri_styx_center_x(p.y))

static func goranthis_styxfall_center_x(y: float) -> float:
	# Queda periférica e contínua: dá escala ao falso paraíso sem dividir a arena.
	return 36.3 + sin((y + 8.0) * 0.16) * 1.15 + sin(y * 0.05) * 0.35

static func goranthis_styxfall_offset(p: Vector2) -> float:
	return absf(p.x - goranthis_styxfall_center_x(p.y))

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
	if stage_id == "feng_tu":
		var edge_distance := minf(minf(p.x, p.y), minf(39.0 - p.x, 39.0 - p.y))
		if edge_distance <= 1.5:
			return MATERIAL_FENG_TU_FOUNDATION
		# Quadras grandes mantêm o pátio calmo sob torii e telegráfos de raio.
		var courtyard_patch := int(floor(p.x / 5.0) + floor(p.y / 5.0) * 7.0)
		if posmod(courtyard_patch, 11) == 3:
			return MATERIAL_FENG_TU_ASH
		return MATERIAL_FENG_TU_CRACK if posmod(courtyard_patch, 7) == 2 else MATERIAL_FENG_TU_STONE
	if stage_id == "shendilavri":
		var branch_offset := shendilavri_styx_offset(p)
		if branch_offset <= 1.15:
			return MATERIAL_SHENDILAVRI_STYX
		if branch_offset <= 2.15:
			return MATERIAL_SHENDILAVRI_BANK
		var edge_distance := minf(minf(p.x, p.y), minf(39.0 - p.x, 39.0 - p.y))
		if edge_distance <= 1.2:
			return MATERIAL_SHENDILAVRI_FOUNDATION
		# Áreas largas de mármore evitam que o chão pareça outra ilusão móvel.
		var marble_patch := int(floor(p.x / 6.0) + floor(p.y / 5.0) * 5.0)
		if posmod(marble_patch, 11) == 3:
			return MATERIAL_SHENDILAVRI_DUST
		return MATERIAL_SHENDILAVRI_VEIN if posmod(marble_patch, 7) == 2 else MATERIAL_SHENDILAVRI_MARBLE
	if stage_id == "goranthis":
		var fall_offset := goranthis_styxfall_offset(p)
		if fall_offset <= 1.35:
			return MATERIAL_GORANTHIS_STYXFALL
		if fall_offset <= 2.45:
			return MATERIAL_GORANTHIS_BANK
		var edge_distance := minf(minf(p.x, p.y), minf(39.0 - p.x, 39.0 - p.y))
		if edge_distance <= 1.2:
			return MATERIAL_GORANTHIS_FOUNDATION
		# Terraços amplos sustentam a promessa do paraíso sem ruído de grade.
		var terrace_patch := int(floor(p.x / 6.0) + floor(p.y / 6.0) * 5.0)
		if posmod(terrace_patch, 11) == 3:
			return MATERIAL_GORANTHIS_MOSS
		return MATERIAL_GORANTHIS_PEARL if posmod(terrace_patch, 7) == 2 else MATERIAL_GORANTHIS_TERRACE
	if stage_id == "pilares":
		var edge_distance := minf(minf(p.x, p.y), minf(39.0 - p.x, 39.0 - p.y))
		if edge_distance <= 1.3:
			return MATERIAL_PILLARS_FOUNDATION
		# Fragmentos largos, estáveis e neutros frente à regra ativa da rotação.
		var pillar_patch := int(floor(p.x / 6.0) + floor(p.y / 5.0) * 5.0)
		if posmod(pillar_patch, 11) == 3:
			return MATERIAL_PILLARS_DUST
		return MATERIAL_PILLARS_BASALT if posmod(pillar_patch, 7) == 2 else MATERIAL_PILLARS_OBSIDIAN
	return MATERIAL_PLATEAU

static func is_shedaklah_styx(stage_id: String, p: Vector2) -> bool:
	return stage_id == "shedaklah" and material_at(stage_id, p) == MATERIAL_SHEDAKLAH_STYX

static func is_shendilavri_styx(stage_id: String, p: Vector2) -> bool:
	return stage_id == "shendilavri" and material_at(stage_id, p) == MATERIAL_SHENDILAVRI_STYX

static func is_goranthis_styxfall(stage_id: String, p: Vector2) -> bool:
	return stage_id == "goranthis" and material_at(stage_id, p) == MATERIAL_GORANTHIS_STYXFALL

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
		MATERIAL_FENG_TU_STONE: return Color("29313a")
		MATERIAL_FENG_TU_ASH: return Color("3b4046")
		MATERIAL_FENG_TU_CRACK: return Color("202733")
		MATERIAL_FENG_TU_FOUNDATION: return Color("151b24")
		MATERIAL_SHENDILAVRI_MARBLE: return Color("34263e")
		MATERIAL_SHENDILAVRI_VEIN: return Color("4b2e50")
		MATERIAL_SHENDILAVRI_DUST: return Color("57405b")
		MATERIAL_SHENDILAVRI_FOUNDATION: return Color("21172b")
		MATERIAL_SHENDILAVRI_BANK: return Color("5c3d5b")
		MATERIAL_SHENDILAVRI_STYX: return Color("181627")
		MATERIAL_GORANTHIS_TERRACE: return Color("8d855f")
		MATERIAL_GORANTHIS_PEARL: return Color("b9ae83")
		MATERIAL_GORANTHIS_MOSS: return Color("7c8056")
		MATERIAL_GORANTHIS_FOUNDATION: return Color("554f3e")
		MATERIAL_GORANTHIS_BANK: return Color("a49a72")
		MATERIAL_GORANTHIS_STYXFALL: return Color("6c8a9b")
		MATERIAL_PILLARS_OBSIDIAN: return Color("201d31")
		MATERIAL_PILLARS_BASALT: return Color("302a42")
		MATERIAL_PILLARS_DUST: return Color("3c3650")
		MATERIAL_PILLARS_FOUNDATION: return Color("131222")
		_: return Color("493833")
