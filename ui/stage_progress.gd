class_name StageProgress
extends Control
## SPEC-163 (MEC-002): barra fina de progresso da fase, colada à base do relógio da HUD.
## O estado (modo e fração) é uma conta estática e testada; o desenho só o aplica. Sem arte: tudo por código.

const MODE_NONE := "none"
const MODE_STAGE := "stage"   # até o chefe: enche de 0 a 1
const MODE_BOSS := "boss"     # chefe vivo: cheia, pulsando
const MODE_FOG := "fog"       # depois do chefe, com a Maré de Névoa: esvazia até a frente cobrir o mapa
const WARN_FROM := 0.8        # a barra esquenta nos últimos 20% até o chefe

const GOLD := Color(0.95, 0.8, 0.4)
const HOT := Color(0.95, 0.5, 0.2)
const BOSS_RED := Color(0.95, 0.25, 0.2)
const FOG_BLUE := Color(0.45, 0.85, 0.95)

var battle: Battle

## {mode, fraction}. `fraction` vai de 0 a 1 e sempre cresce na fase e esvazia na Maré.
static func state(b: Battle) -> Dictionary:
	if b == null or b.stage.is_empty():
		return {"mode": MODE_NONE, "fraction": 0.0}
	if b.boss_dead:
		if b.fog_state == "inactive":
			return {"mode": MODE_NONE, "fraction": 0.0}
		var total := fog_total_seconds(b.fog_config)
		return {"mode": MODE_FOG, "fraction": clampf(1.0 - b.fog_elapsed / total, 0.0, 1.0)}
	if b.boss_spawned:
		return {"mode": MODE_BOSS, "fraction": 1.0}
	var duration := maxf(1.0, float(b.stage.duration))
	return {"mode": MODE_STAGE, "fraction": clampf(b.time / duration, 0.0, 1.0)}

## Tempo entre o chefe cair e a frente da névoa cobrir o mapa: carência + aviso + avanço.
static func fog_total_seconds(config: Dictionary) -> float:
	return maxf(1.0, float(config.get("grace_seconds", 8.0)) + float(config.get("warning_seconds", 2.0)) + float(config.get("advance_seconds", 28.0)))

static func fill_color(s: Dictionary, ticks_ms: int) -> Color:
	match String(s.mode):
		MODE_FOG:
			return FOG_BLUE
		MODE_BOSS:
			return BOSS_RED.lerp(Color(1.0, 0.6, 0.5), 0.5 + 0.5 * sin(float(ticks_ms) / 1000.0 * TAU * 1.2))
		_:
			return GOLD.lerp(HOT, clampf((float(s.fraction) - WARN_FROM) / (1.0 - WARN_FROM), 0.0, 1.0))

func _init() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _process(_delta: float) -> void:
	if visible:
		queue_redraw()

func _draw() -> void:
	var s := state(battle)
	if String(s.mode) == MODE_NONE:
		return
	var r := Rect2(Vector2.ZERO, size)
	draw_rect(r, Color(0.06, 0.05, 0.08, 0.72))
	var fill := Rect2(r.position, Vector2(r.size.x * float(s.fraction), r.size.y))
	draw_rect(fill, fill_color(s, Time.get_ticks_msec()))
	draw_rect(r, Color(0.0, 0.0, 0.0, 0.85), false, 1.0)
	if String(s.mode) == MODE_STAGE or String(s.mode) == MODE_BOSS:
		# marcador do chefe na ponta direita: losango pequeno que sobe acima da barra
		var c := Vector2(r.end.x, r.position.y + r.size.y * 0.5)
		var col := BOSS_RED if String(s.mode) == MODE_BOSS else Color(0.85, 0.75, 0.6)
		draw_colored_polygon(PackedVector2Array([c + Vector2(0, -5), c + Vector2(5, 0), c + Vector2(0, 5), c + Vector2(-5, 0)]), col)
