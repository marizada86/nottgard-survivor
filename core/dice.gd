class_name Dice
extends RefCounted

static func roll(rng: RandomNumberGenerator, expr: String) -> int:
	var p := expr.split("d")
	var total := 0
	for i in int(p[0]):
		total += rng.randi_range(1, int(p[1]))
	return total

static func d20(rng: RandomNumberGenerator) -> int:
	return rng.randi_range(1, 20)

static func mod(score: int) -> int:
	return int(floor((score - 10) / 2.0))
