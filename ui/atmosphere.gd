class_name Atmosphere
extends Node
## SPEC-177 R5-C/D (DRAFT): atmosfera por fase, escolhida em Opções → TELA ("Atmosfera": Desligada ou Leve).
## C = partículas ambientais discretas (camada do texto, acima do mundo e abaixo da HUD); D = gradação de cor leve
## (camada do filtro). Os dois andam juntos: não existe só um. Desligada, nada é desenhado nem processado.
## Impacto reduzido tira as partículas (movimento) e mantém a gradação (estática). Em toque fica desligada.

const MODES: Array[String] = ["off", "leve"]
const LABELS: Array[String] = ["Desligada", "Leve"]
const SHADER := preload("res://ui/atmosphere.gdshader")

var mode := "off"
var stage_id := ""
var _grade_layer: CanvasLayer
var _grade_rect: ColorRect
var _material: ShaderMaterial
var _particle_layer: CanvasLayer
var _emitter: CPUParticles2D

static func normalize(value: Variant) -> String:
	var s := str(value)
	return s if s in MODES else "leve"

static func mode_of(settings: Dictionary) -> String:
	return normalize(settings.get("atmosphere", "leve"))

## Perfil da fase (vazio se a fase não tem): {"name", "particles": {...}, "grade": {...}}.
static func profile_for(stage: String) -> Dictionary:
	var table: Dictionary = Data.table("atmosphere")
	var entry: Variant = table.get(stage, {})
	return entry if entry is Dictionary else {}

func _init() -> void:
	name = "Atmosphere"
	_grade_layer = CanvasLayer.new()
	_grade_layer.layer = VisualFilter.FILTER_LAYER
	_grade_rect = ColorRect.new()
	_grade_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_grade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_grade_rect.visible = false
	_grade_layer.add_child(_grade_rect)
	add_child(_grade_layer)
	_particle_layer = CanvasLayer.new()
	_particle_layer.layer = VisualFilter.TEXT_LAYER
	_particle_layer.visible = false
	add_child(_particle_layer)

func setup(stage: String, settings: Dictionary) -> void:
	stage_id = stage
	apply(settings)

## `on_touch`: aparelho de toque mantém desligada (mesma regra do filtro de tela).
func apply(settings: Dictionary, on_touch: bool = false) -> void:
	mode = "off" if on_touch else mode_of(settings)
	var profile := profile_for(stage_id)
	if mode == "off" or profile.is_empty():
		_hide()
		return
	var grade: Dictionary = profile.get("grade", {})
	if grade.is_empty():
		_grade_rect.visible = false
	else:
		if _material == null:
			_material = ShaderMaterial.new()
			_material.shader = SHADER
		var tint: Array = grade.get("tint", [1.0, 1.0, 1.0])
		_material.set_shader_parameter("tint", Vector3(float(tint[0]), float(tint[1]), float(tint[2])))
		_material.set_shader_parameter("sat", float(grade.get("sat", 1.0)))
		_material.set_shader_parameter("vig", float(grade.get("vig", 0.0)))
		_grade_rect.material = _material
		_grade_rect.visible = true
	var particles: Dictionary = profile.get("particles", {})
	var show_particles := not particles.is_empty() and not bool(settings.get("reduced_impact", false))
	_particle_layer.visible = show_particles
	if show_particles:
		_build_emitter(particles)
	elif _emitter != null:
		_emitter.emitting = false

func _hide() -> void:
	_grade_rect.visible = false
	_grade_rect.material = null
	_material = null
	_particle_layer.visible = false
	if _emitter != null:
		_emitter.emitting = false

func _build_emitter(p: Dictionary) -> void:
	if _emitter == null:
		_emitter = CPUParticles2D.new()
		_emitter.name = "Ambient"
		_emitter.position = Vector2(640, 360)
		_emitter.lifetime = 8.0
		_emitter.preprocess = 8.0
		_emitter.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
		_emitter.emission_rect_extents = Vector2(660, 380)
		_emitter.spread = 25.0
		_emitter.gravity = Vector2.ZERO
		_particle_layer.add_child(_emitter)
	var velocity := Vector2(float(p.get("vx", 0.0)), float(p.get("vy", 0.0)))
	var size := float(p.get("size", 2.4))
	var c: Array = p.get("color", [1.0, 1.0, 1.0, 0.5])
	_emitter.amount = clampi(int(p.get("amount", 36)), 1, 80)
	_emitter.direction = velocity.normalized() if velocity.length() > 0.01 else Vector2.UP
	_emitter.initial_velocity_min = velocity.length() * 0.6
	_emitter.initial_velocity_max = velocity.length() * 1.2
	_emitter.scale_amount_min = size * 0.7
	_emitter.scale_amount_max = size * 1.4
	_emitter.color = Color(float(c[0]), float(c[1]), float(c[2]), float(c[3]))
	_emitter.emitting = true

func is_grading() -> bool:
	return _grade_rect.visible and _grade_rect.material != null

func is_emitting() -> bool:
	return _particle_layer.visible and _emitter != null and _emitter.emitting
