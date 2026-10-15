class_name OnboardingHints
extends RefCounted
## SPEC-179 R2: dicas de primeira vez (uma por perfil). Só a regra de quando mostrar; a exibição é o aviso do HUD.
## Teto: 1 dica a cada INTERVAL s de jogo e no máximo MAX_TOTAL no perfil; nunca em luta de chefe nem com vida baixa.

const INTERVAL := 90.0
const MAX_TOTAL := 7
const MIN_HP_FRACTION := 0.3
const MIN_START := 12.0   # deixa passar a epígrafe da fase antes da primeira dica
const MAX_CHARS := 90

var enabled := true
var seen: Dictionary = {}   # id -> true; é o mesmo dicionário do perfil (settings.hints_seen)
var last_time := -1.0e9

static func table() -> Array:
	return Data.table("onboarding_hints").get("hints", [])

static func text_of(id: String) -> String:
	for h in table():
		if String(h.id) == id:
			return String(h.text)
	return ""

## Troca os marcadores: {interact}, {pause}, {extract}, {detail} (tecla ou botão em uso) e {next} (multiplicador ao descer).
static func render(text: String, vars: Dictionary) -> String:
	var out := text
	for key in vars:
		out = out.replace("{%s}" % key, String(vars[key]))
	return out

func can_show(id: String, game_time: float, boss_active: bool, hp_fraction: float) -> bool:
	if not enabled or seen.has(id) or text_of(id) == "":
		return false
	if seen.size() >= MAX_TOTAL or boss_active or hp_fraction < MIN_HP_FRACTION:
		return false
	if game_time < MIN_START:
		return false
	return game_time < last_time or game_time - last_time >= INTERVAL

func mark(id: String, game_time: float) -> void:
	seen[id] = true
	last_time = game_time
