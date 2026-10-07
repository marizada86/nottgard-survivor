class_name AbyssMarks
extends RefCounted
## SPEC-141 e SPEC-143 (MEC-040): Marcas do Abismo, dificuldade opcional. Funções puras sobre `data/abyss_marks.json`;
## o estado fica no ctx da batalha (`abyss_marks`: {id: nível}) e no perfil.

static func cfg() -> Dictionary:
	return Data.table("abyss_marks")

static func ids() -> Array:
	return cfg().order

static func def(id: String) -> Dictionary:
	return cfg().marks[id]

## Nível máximo da marca: o próprio `max_level` ou o padrão global (3).
static func max_level(id: String = "") -> int:
	if id != "" and cfg().marks.has(id):
		return int(def(id).get("max_level", cfg().max_level))
	return int(cfg().max_level)

static func max_total() -> int:
	var total := 0
	for id in ids():
		total += max_level(String(id))
	return total

static func per_level(id: String) -> float:
	return float(def(id).per_level)

## Conquista que libera a marca ("" = sempre liberada).
static func requires(id: String) -> String:
	return String(def(id).get("requires", ""))

## Aceita qualquer dicionário (perfil, ctx, UI) e devolve só marcas conhecidas com nível 1..máximo da marca.
static func normalize(raw: Variant) -> Dictionary:
	var out := {}
	if not (raw is Dictionary):
		return out
	for id in ids():
		var lv := clampi(int(raw.get(id, 0)), 0, max_level(String(id)))
		if lv > 0:
			out[id] = lv
	return out

static func level_of(marks: Dictionary, id: String) -> int:
	return int(marks.get(id, 0))

static func total_level(marks: Dictionary) -> int:
	var total := 0
	for id in ids():
		total += level_of(marks, String(id))
	return total

## Multiplicador de aumento (Horda, Fúria, Carapaça, Pressa): 1 + valor por nível × nível.
static func up_mult(marks: Dictionary, id: String) -> float:
	var lv := level_of(marks, id)
	if lv <= 0:
		return 1.0
	return 1.0 + per_level(id) * float(lv)

## Fome: fração de cura que sobra (nunca negativa).
static func heal_mult(marks: Dictionary) -> float:
	var lv := level_of(marks, "fome")
	if lv <= 0:
		return 1.0
	return maxf(0.0, 1.0 - per_level("fome") * float(lv))

## Bônus de moeda: +10% por ponto de nível total.
static func reward_bonus(marks: Dictionary) -> float:
	return float(cfg().reward_per_point) * float(total_level(marks))

## Só as marcas liberadas ficam (`unlocked`: id -> bool, normalmente `Profile.abyss_mark_unlocked`).
static func keep_unlocked(marks: Dictionary, unlocked: Callable) -> Dictionary:
	var out := {}
	for id in marks:
		if bool(unlocked.call(String(id))):
			out[id] = marks[id]
	return out
