class_name Lettering
extends RefCounted
## SPEC-132 (MEC-049): lettering e placas de título (ART-036). Peça sem arte devolve null e o chamador
## mantém o visual atual; texto dinâmico recebe o estilo de lettering (fonte, contorno, sombra, gradiente de ouro).

const FONT_PATH := "res://assets/fonts/CinzelDecorative-Bold.ttf"
const SHADER_PATH := "res://ui/lettering_gradient.gdshader"
const OUTLINE_COLOR := Color(0.06, 0.03, 0.1)
const SHADOW_COLOR := Color(0, 0, 0, 0.6)

static func piece(id: String) -> Dictionary:
	return Data.table("lettering").get(id, {})

static func has_art(id: String) -> bool:
	var path := String(piece(id).get("path", ""))
	return path != "" and ResourceLoader.exists(path)

static func texture(id: String) -> Texture2D:
	return load(String(piece(id).path)) as Texture2D if has_art(id) else null

static func piece_size(id: String) -> Vector2:
	var s: Array = piece(id).get("size", [0, 0])
	return Vector2(float(s[0]), float(s[1]))

## Imagem de lettering (logo, banners) centrada e com proporção preservada; null sem arte.
static func banner(id: String) -> TextureRect:
	var tex := texture(id)
	if tex == null or String(piece(id).get("kind", "")) != "banner":
		return null
	var rect := TextureRect.new()
	rect.name = "Lettering_" + id
	rect.texture = tex
	rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	rect.custom_minimum_size = Vector2(tex.get_size()).min(piece_size(id))
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return rect

## Placa de nove fatias, sem texto; null sem arte.
static func plate(id: String, size: Vector2 = Vector2.ZERO) -> NinePatchRect:
	var tex := texture(id)
	if tex == null or String(piece(id).get("kind", "")) != "plate":
		return null
	var m: Array = piece(id).get("margins", [0, 0, 0, 0])
	var rect := NinePatchRect.new()
	rect.name = "Plate_" + id
	rect.texture = tex
	rect.patch_margin_left = int(m[0])
	rect.patch_margin_right = int(m[1])
	rect.patch_margin_top = int(m[2])
	rect.patch_margin_bottom = int(m[3])
	rect.custom_minimum_size = size if size != Vector2.ZERO else piece_size(id)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return rect

static func margins_fit(id: String) -> bool:
	var p := piece(id)
	if not p.has("margins"):
		return true
	var m: Array = p.margins
	var s := piece_size(id)
	return m[0] + m[1] < s.x and m[2] + m[3] < s.y

## Estilo de lettering para Label dinâmico: Cinzel Decorative, contorno escuro, sombra e gradiente de ouro.
static func style(label: Label, font_size: int, gradient := true) -> Label:
	label.add_theme_font_override("font", load(FONT_PATH))
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_outline_color", OUTLINE_COLOR)
	label.add_theme_constant_override("outline_size", maxi(4, font_size / 6))
	label.add_theme_color_override("font_shadow_color", SHADOW_COLOR)
	label.add_theme_constant_override("shadow_offset_x", 0)
	label.add_theme_constant_override("shadow_offset_y", maxi(2, font_size / 12))
	if gradient and ResourceLoader.exists(SHADER_PATH):
		label.add_theme_color_override("font_color", Color.WHITE)
		var mat := ShaderMaterial.new()
		mat.shader = load(SHADER_PATH)
		label.material = mat
		if not label.resized.is_connected(_fit_gradient.bind(label)):
			label.resized.connect(_fit_gradient.bind(label))
		_fit_gradient(label)
	else:
		label.add_theme_color_override("font_color", Color(0.88, 0.74, 0.42))
	return label

## Ajusta o gradiente à altura do texto (e à sua posição quando centrado na vertical).
static func _fit_gradient(label: Label) -> void:
	var mat := label.material as ShaderMaterial
	if mat == null:
		return
	var text_h := maxf(label.get_minimum_size().y, 1.0)
	var y0 := 0.0
	if label.vertical_alignment == VERTICAL_ALIGNMENT_CENTER:
		y0 = maxf((label.size.y - text_h) * 0.5, 0.0)
	elif label.vertical_alignment == VERTICAL_ALIGNMENT_BOTTOM:
		y0 = maxf(label.size.y - text_h, 0.0)
	mat.set_shader_parameter("y0", y0)
	mat.set_shader_parameter("span", text_h)

## Texto dinâmico sobre placa: com arte devolve a placa com o Label centrado dentro; sem arte devolve só o Label estilizado.
static func plate_label(plate_id: String, text: String, font_size: int, size: Vector2 = Vector2.ZERO) -> Control:
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	style(label, font_size)
	var plate_rect := plate(plate_id, size)
	if plate_rect == null:
		return label
	label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	label.offset_left = float(plate_rect.patch_margin_left)
	label.offset_right = -float(plate_rect.patch_margin_right)
	plate_rect.add_child(label)
	return plate_rect
