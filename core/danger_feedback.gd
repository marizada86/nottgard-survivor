class_name DangerFeedback
extends RefCounted
## M2 R5 (opção A, SPEC-177): aviso de vida baixa e de golpe recebido. Funções puras, sem cena: a `DangerVignette` só aplica os números.
## Vida baixa tem histerese (entra abaixo de 30%, sai acima de 36%) para a vinheta não piscar na borda.
## "Impacto reduzido" deixa a vinheta estática (sem pulso) e tira o flash de golpe.

const LOW_ENTER := 0.30
const LOW_EXIT := 0.36
const PULSE_PERIOD := 1.6        # s
const FLASH_SECONDS := 0.35
const FADE_PER_SECOND := 2.0     # velocidade com que a vinheta de vida baixa entra e sai
const MAX_ALPHA := 0.55

static func is_low(fraction: float, was_low: bool) -> bool:
	return fraction < (LOW_EXIT if was_low else LOW_ENTER)

## Opacidade-alvo da vinheta de vida baixa (0 quando não está baixa).
static func low_alpha(low: bool, fraction: float, time: float, reduced: bool) -> float:
	if not low:
		return 0.0
	var depth := clampf(1.0 - fraction / LOW_ENTER, 0.0, 1.0)
	var base := 0.14 + 0.28 * depth
	if reduced:
		return base * 0.7
	return base + 0.06 * sin(time * TAU / PULSE_PERIOD)

## Pico do flash de golpe: cresce com a fração de PV perdida. Dano contínuo (névoa) e impacto reduzido não flasham.
static func flash_peak(amount: float, max_hp: float, continuous: bool, reduced: bool) -> float:
	if continuous or reduced or amount <= 0.0 or max_hp <= 0.0:
		return 0.0
	return clampf(0.16 + 1.0 * amount / max_hp, 0.16, 0.45)

static func flash_alpha(peak: float, elapsed: float) -> float:
	if peak <= 0.0 or elapsed >= FLASH_SECONDS:
		return 0.0
	var k := 1.0 - elapsed / FLASH_SECONDS
	return peak * k * k

static func combine(low: float, flash: float) -> float:
	return minf(MAX_ALPHA, maxf(low, flash))
