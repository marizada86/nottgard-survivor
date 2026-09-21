class_name Dice
extends RefCounted

static func roll(rng: RandomNumberGenerator, expr: String) -> int:
	if expr == "":
		return 0
	var p := expr.split("d")
	var total := 0
	for i in int(p[0]):
		total += rng.randi_range(1, int(p[1]))
	return total

static func d20(rng: RandomNumberGenerator) -> int:
	return rng.randi_range(1, 20)

static func mod(score: int) -> int:
	return int(floor((score - 10) / 2.0))

## Média de uma expressão de dado (para tooltips e balanceamento).
static func avg(expr: String) -> float:
	if expr == "":
		return 0.0
	var p := expr.split("d")
	return float(int(p[0])) * (float(int(p[1])) + 1.0) / 2.0
