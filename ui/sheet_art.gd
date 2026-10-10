class_name SheetArt
extends RefCounted
## FILA-025: recursos aprovados; normalizacao e admissao em SPEC-139.
const ROOT := "res://assets/ui/ficha/"
const PANEL = preload(ROOT + "ficha_moldura_painel.png")
const DETAIL = preload(ROOT + "ficha_moldura_detalhe.png")
const SLOT = preload(ROOT + "ficha_slot_moldura.png")
const EMPTY_SLOT = preload(ROOT + "ficha_slot_vazio.png")
const TAB = preload(ROOT + "ficha_aba_moldura.png")
const BACKGROUND = preload(ROOT + "ficha_fundo_textura.png")
const TAB_ICONS := [preload(ROOT + "ficha_aba_armas.png"), preload(ROOT + "ficha_aba_equipamento.png"),
	preload(ROOT + "ficha_aba_passivas.png"), preload(ROOT + "ficha_aba_sinergias.png")]

static func frame(texture: Texture2D, slices: float, padding: float, tint: Color = Color.WHITE) -> StyleBoxTexture:
	var style := StyleBoxTexture.new()
	style.texture = texture
	style.modulate_color = tint
	for side in [SIDE_LEFT, SIDE_TOP, SIDE_RIGHT, SIDE_BOTTOM]:
		style.set_texture_margin(side, slices)
	style.set_content_margin_all(padding)
	return style

## Moldura de detalhe (512x128): 10 px transparentes, faixa de 10 a 21 px e estrelas nos cantos até ~34 px.
## O recorte tem de cobrir as estrelas, senão a faixa e os cantos são esticados; a margem de texto fica além da borda visível (22 px).
const DETAIL_SLICE := 34.0
const DETAIL_PADDING := 26.0

static func detail(padding: float = DETAIL_PADDING, tint: Color = Color.WHITE) -> StyleBoxTexture:
	return frame(DETAIL, DETAIL_SLICE, padding, tint)

static func background() -> StyleBoxTexture:
	var style := StyleBoxTexture.new()
	style.texture = BACKGROUND
	style.axis_stretch_horizontal = StyleBoxTexture.AXIS_STRETCH_MODE_TILE
	style.axis_stretch_vertical = StyleBoxTexture.AXIS_STRETCH_MODE_TILE
	style.set_content_margin_all(0)
	return style
