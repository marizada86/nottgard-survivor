class_name VisualFilter
extends CanvasLayer
## SPEC-173 (MEC-065): filtro de tela do mundo, escolhido em Opções → TELA.
## Fica numa camada entre o mundo (camada 0) e a HUD (HUD_LAYER): a HUD, as janelas, a camada de encontros e o texto do mundo
## (TEXT_LAYER, que segue a câmera) não são filtrados.
## Desligado, o ColorRect some e o material sai de cena: nenhuma passada extra de tela.

const MODES: Array[String] = ["off", "paleta", "gravura"]
const LABELS: Array[String] = ["Desligado", "Paleta e dither", "Gravura"]
const FILTER_LAYER := 1
const TEXT_LAYER := 2   # texto do mundo (números de dano, falas, rótulos): acima do filtro, abaixo da HUD
const HUD_LAYER := 3
const SHADER := preload("res://ui/visual_filter.gdshader")

var mode := "off"
var _rect: ColorRect
var _material: ShaderMaterial

static func normalize(value: Variant) -> String:
	var s := str(value)
	return s if s in MODES else "off"

## O modo gravado no perfil (valor desconhecido ou ausente vira "off").
static func mode_of(settings: Dictionary) -> String:
	return normalize(settings.get("visual_filter", "off"))

func _init() -> void:
	layer = FILTER_LAYER
	name = "VisualFilter"
	_rect = ColorRect.new()
	_rect.name = "Screen"
	_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_rect.visible = false
	add_child(_rect)

## Aplica o modo e os ajustes do perfil. `reduced_impact` tira o grão da gravura (sem cintilação).
func apply(settings: Dictionary) -> void:
	mode = mode_of(settings)
	if mode == "off":
		_rect.visible = false
		_rect.material = null
		_material = null
		return
	if _material == null:
		_material = ShaderMaterial.new()
		_material.shader = SHADER
	_material.set_shader_parameter("mode", MODES.find(mode))
	_material.set_shader_parameter("grain", 0.0 if bool(settings.get("reduced_impact", false)) else 0.035)
	_rect.material = _material
	_rect.visible = true

func is_drawing() -> bool:
	return _rect.visible and _rect.material != null

func shader_material() -> ShaderMaterial:
	return _material
