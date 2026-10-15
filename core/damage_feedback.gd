class_name DamageFeedback
extends RefCounted
## L3 (relato do T05, EVID-250/EVID-252): o impacto de um acerto tem faixas. Funções puras, sem cena: a `Run` só aplica os números.
## Faixa 0 a 3 = quão grande foi o golpe para quem o recebeu. Comuns morrem em poucos golpes, então a fração do PV não diz nada
## sobre eles: só o crítico sobe a faixa. Elites e chefes absorvem muitos golpes, e é neles que a fração mostra a diferença.

const ELITE_BANDS := [0.03, 0.08, 0.15]   # fração do PV máximo do alvo: faixa 1, 2 e 3
const NUMBER_SIZES := [16, 19, 25, 31]   # M2 R5 (B): o comum passa de 14 para 16 px
const CRIT_EXTRA_SIZE := 2
const OUTLINES := [5, 5, 6, 7]
## M2 R5 (B): números que não são acerto também ficam legíveis sobre o chão claro.
const HURT_SIZE := 20      # dano que o herói recebe (era 16)
const HEAL_SIZE := 16      # cura (era 14)
const CUE_SIZE := 14       # "Guarda", "Esquiva", "Barreira" etc. (era 12)
const AUX_OUTLINE := 5
const MERGE_MS := {"": 350, "elite": 150, "boss": 150}

## `tier`: "" (comum), "elite" ou "boss".
static func band(frac: float, tier: String, crit: bool) -> int:
	var b := 0
	if tier != "":
		for limit in ELITE_BANDS:
			if frac >= float(limit):
				b += 1
	if crit:
		b = maxi(b + 1, 2)
	return clampi(b, 0, 3)

static func number_size(b: int, crit: bool) -> int:
	return int(NUMBER_SIZES[clampi(b, 0, 3)]) + (CRIT_EXTRA_SIZE if crit else 0)

static func outline_size(b: int) -> int:
	return int(OUTLINES[clampi(b, 0, 3)])

## Brilho do número: sobe com a faixa (0 = cor do tipo de dano).
static func lighten(b: int) -> float:
	return [0.0, 0.1, 0.2, 0.35][clampi(b, 0, 3)]

## Volume do som do acerto em dB (antes: -14 fixo). Acerto forte e crítico passam o comum por 2 a 6 dB.
static func sound_db(b: int, crit: bool, tier: String) -> float:
	var db := -14.0 + 2.0 * float(clampi(b, 0, 3))
	if crit:
		db += 1.0
	if tier == "boss":
		db += 1.0
	return minf(db, -7.0)

## Tom do som do acerto: quanto maior a faixa, mais grave (pitch menor). Comum fica em 1,0.
static func sound_pitch(b: int) -> float:
	return [1.0, 0.96, 0.9, 0.84][clampi(b, 0, 3)]

## Pausa de acerto (s). Comum não pára o jogo aqui (o crítico comum segue com os 0,04 s de antes).
static func hit_stop(b: int, crit: bool, tier: String) -> float:
	if tier == "":
		return 0.04 if crit else 0.0
	if crit:
		return 0.06 if b >= 3 else 0.05
	return 0.0 if b < 2 else (0.05 if b >= 3 else 0.03)
