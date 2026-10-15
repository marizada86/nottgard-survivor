class_name DangerVignette
extends Control
## M2 R5 (opção A, SPEC-177): vinheta vermelha nas bordas. Pulsa devagar com vida baixa e dá um flash curto ao receber golpe.
## Camada entre o mundo e o texto (os números continuam legíveis). Invisível e sem custo com a vida boa.

var _rect: TextureRect
var _low := false
var _low_shown := 0.0
var _flash_peak := 0.0
var _flash_elapsed := 99.0
var _time := 0.0

func _init() -> void:
	name = "DangerVignette"
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_rect = TextureRect.new()
	_rect.texture = _make_texture()
	_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_rect.stretch_mode = TextureRect.STRETCH_SCALE
	_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	_rect.modulate.a = 0.0
	add_child(_rect)
	visible = false

static func _make_texture() -> GradientTexture2D:
	var g := Gradient.new()
	g.offsets = PackedFloat32Array([0.0, 0.68, 1.0])
	g.colors = PackedColorArray([Color(0.7, 0.03, 0.03, 0.0), Color(0.7, 0.03, 0.03, 0.0), Color(0.8, 0.04, 0.04, 1.0)])
	var t := GradientTexture2D.new()
	t.gradient = g
	t.fill = GradientTexture2D.FILL_RADIAL
	t.fill_from = Vector2(0.5, 0.5)
	t.fill_to = Vector2(1.0, 0.5)
	t.width = 128
	t.height = 128
	return t

## `fraction`: PV atual / PV máximo. `active`: a partida está rodando (fora dela a vinheta some).
func tick(dt: float, fraction: float, active: bool, reduced: bool) -> void:
	_time += dt
	_flash_elapsed += dt
	_low = active and DangerFeedback.is_low(fraction, _low)
	var target := DangerFeedback.low_alpha(_low, fraction, _time, reduced)
	_low_shown = move_toward(_low_shown, target, DangerFeedback.FADE_PER_SECOND * dt)
	var flash := DangerFeedback.flash_alpha(_flash_peak, _flash_elapsed) if active else 0.0
	var a := DangerFeedback.combine(_low_shown, flash)
	_rect.modulate.a = a
	visible = a > 0.003

func on_hurt(amount: float, max_hp: float, continuous: bool, reduced: bool) -> void:
	var peak := DangerFeedback.flash_peak(amount, max_hp, continuous, reduced)
	if peak > 0.0:
		_flash_peak = peak
		_flash_elapsed = 0.0

func alpha() -> float:
	return _rect.modulate.a

func is_low() -> bool:
	return _low
