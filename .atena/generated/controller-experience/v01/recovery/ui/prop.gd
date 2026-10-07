@tool
extends Node2D
## Objeto de cenário que bloqueia movimento (grupo "blockers"). A posição do nó é em pixels de tela;
## o chão é derivado por Iso.to_ground(position). Mova/duplique no editor à vontade.

@export_enum("docas_guindaste", "pilar", "cogumelo", "bolha", "rocha", "torii", "cristal", "cachoeira", "pilar_abissal", "braseiro", "caixote", "velas", "livros", "barril", "rede", "ossos", "doca", "carga", "margem", "esporo_01", "esporo_02", "lodo_01", "estalactite_01", "estalactite_02", "resina_01", "corrente_01", "corrente_02", "osso_01", "lanterna_01", "lanterna_02", "sino_01", "veu_01", "taca_01", "espelho_ornado_01", "coluna_01", "flor_01", "taca_dourada_01", "fragmento_01", "runa_01", "nucleo_01", "dagruve_estrutura_01", "docas_estrutura_01", "shedaklah_estrutura_01", "molor_estrutura_01", "durao_estrutura_01", "feng_tu_estrutura_01", "shendilavri_estrutura_01", "goranthis_estrutura_01", "pilares_estrutura_01") var kind := "pilar": set = _set_kind
@export var height := 60.0: set = _set_height
@export var half_width := 22.0: set = _set_hw
@export var block_radius := 0.4   ## raio de colisão em tiles
@export var color := Color(0.24, 0.22, 0.24): set = _set_color
## Pixels de tela após a âncora automática; positivo desce arte e sombra.
@export var visual_ground_offset := 0.0: set = _set_visual_ground_offset
## Exclusivo de QA: mostra âncora, área de sombra e origem lógica.
@export var show_grounding_guide := false: set = _set_grounding_guide
var _texture: Texture2D
var _texture_path := ""
static var _visible_bottom_cache := {}

func _ready() -> void:
	# Um prop oculto é removido do layout e nunca deixa uma colisão invisível.
	if visible and block_radius > 0.0:
		add_to_group("blockers")

func _set_kind(v: String) -> void:
	kind = v
	queue_redraw()

func _set_height(v: float) -> void:
	height = v
	queue_redraw()

func _set_hw(v: float) -> void:
	half_width = v
	queue_redraw()

func _set_color(v: Color) -> void:
	color = v
	queue_redraw()

func _set_visual_ground_offset(v: float) -> void:
	visual_ground_offset = v
	queue_redraw()

func _set_grounding_guide(v: bool) -> void:
	show_grounding_guide = v
	queue_redraw()

func _diamond(c: Vector2, hw: float, hh: float) -> PackedVector2Array:
	return PackedVector2Array([c + Vector2(0, -hh), c + Vector2(hw, 0), c + Vector2(0, hh), c + Vector2(-hw, 0)])

func _ellipse(c: Vector2, rx: float, ry: float, n: int = 20) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in n:
		var a := TAU * i / n
		pts.append(c + Vector2(cos(a) * rx, sin(a) * ry))
	return pts

func _prop_texture() -> Texture2D:
	var seed_value := absi(int(round(position.x / 32.0)) * 31 + int(round(position.y / 16.0)) * 17)
	var variant := seed_value % 3 + 1
	if kind == "docas_guindaste":
		variant = 1
	var path := "res://assets/props/%s.png" % kind if kind in ["esporo_01", "esporo_02", "lodo_01", "estalactite_01", "estalactite_02", "resina_01", "corrente_01", "corrente_02", "osso_01", "lanterna_01", "lanterna_02", "sino_01", "veu_01", "taca_01", "espelho_ornado_01", "coluna_01", "flor_01", "taca_dourada_01", "fragmento_01", "runa_01", "nucleo_01", "dagruve_estrutura_01", "docas_estrutura_01", "shedaklah_estrutura_01", "molor_estrutura_01", "durao_estrutura_01", "feng_tu_estrutura_01", "shendilavri_estrutura_01", "goranthis_estrutura_01", "pilares_estrutura_01"] else "res://assets/props/%s_%02d.png" % [kind, variant]
	if path != _texture_path:
		_texture_path = path
		_texture = load(path) if ResourceLoader.exists(path) else null
	return _texture

## A base deve ser a última linha de alfa visível, não a borda do arquivo.
func _visible_bottom_px(texture: Texture2D) -> float:
	if _visible_bottom_cache.has(_texture_path):
		return float(_visible_bottom_cache[_texture_path])
	var bottom := float(texture.get_height())
	var image := texture.get_image()
	if image != null:
		var used := image.get_used_rect()
		if used.size.y > 0:
			bottom = float(used.position.y + used.size.y)
	_visible_bottom_cache[_texture_path] = bottom
	return bottom

static func texture_draw_y(texture_height: float, visible_bottom: float, target_height: float, ground_offset: float = 0.0) -> float:
	if texture_height <= 0.0:
		return ground_offset
	return -visible_bottom * target_height / texture_height + ground_offset

## Posiciona o ponto artístico normalizado no contato lógico local.
static func texture_draw_origin(target_size: Vector2, contact_anchor: Vector2, ground_offset: float = 0.0) -> Vector2:
	return Vector2(-target_size.x * contact_anchor.x, -target_size.y * contact_anchor.y + ground_offset)

## A sombra de contato não pode terminar abaixo do ponto lógico de apoio.
static func contact_shadow_center_y(contact_y: float, requested_center_y: float, radius_y: float) -> float:
	return minf(requested_center_y, contact_y + 2.0 - radius_y)

func _visual_profile() -> Dictionary:
	var all_profiles: Dictionary = Data.table("prop_visuals")
	var assets: Dictionary = all_profiles.get("assets", {})
	return assets.get(_texture_path, {})

func _profile_vec2(profile: Dictionary, key: String, fallback: Vector2) -> Vector2:
	var raw: Variant = profile.get(key, [])
	if raw is Array and raw.size() >= 2:
		return Vector2(float(raw[0]), float(raw[1]))
	return fallback

func _draw_grounding_guide(contact: Vector2, shadow_center: Vector2, shadow_radius: Vector2, profile_found: bool) -> void:
	if not show_grounding_guide:
		return
	var guide_color := Color(0.2, 1.0, 0.78, 0.92) if profile_found else Color(1.0, 0.28, 0.28, 0.95)
	draw_line(contact + Vector2(-7, 0), contact + Vector2(7, 0), guide_color, 1.5)
	draw_line(contact + Vector2(0, -7), contact + Vector2(0, 7), guide_color, 1.5)
	draw_circle(contact, 2.4, guide_color)
	if shadow_radius.x > 0.0 and shadow_radius.y > 0.0:
		draw_polyline(_ellipse(shadow_center, shadow_radius.x, shadow_radius.y), Color(1.0, 0.86, 0.2, 0.9), 1.2)

func set_grounding_guide(enabled: bool) -> void:
	show_grounding_guide = enabled

func _draw() -> void:
	var w := half_width
	var contact := Vector2(0, visual_ground_offset)
	var texture := _prop_texture()
	if texture != null:
		var target_h := maxf(42.0, height + w * 0.8)
		var target_w := target_h * float(texture.get_width()) / float(texture.get_height())
		var target_size := Vector2(target_w, target_h)
		var profile := _visual_profile()
		var fallback_anchor := Vector2(0.5, _visible_bottom_px(texture) / float(texture.get_height()))
		var anchor := _profile_vec2(profile, "contact_anchor", fallback_anchor)
		var shadow_center := contact
		var shadow_radius := Vector2.ZERO
		if String(profile.get("shadow_mode", "dynamic")) == "dynamic":
			var shadow_offset := _profile_vec2(profile, "shadow_offset", Vector2.ZERO)
			var shadow_size := _profile_vec2(profile, "shadow_size", Vector2(w * 1.05 / target_w, w * 0.5 / target_h))
			shadow_center = contact + Vector2(shadow_offset.x * target_w, shadow_offset.y * target_h)
			shadow_radius = Vector2(maxf(2.0, shadow_size.x * target_w), maxf(1.5, shadow_size.y * target_h))
			shadow_center.y = contact_shadow_center_y(contact.y, shadow_center.y, shadow_radius.y)
			draw_colored_polygon(_ellipse(shadow_center, shadow_radius.x, shadow_radius.y), Color(0, 0, 0, float(profile.get("shadow_alpha", 0.28))))
		var origin := texture_draw_origin(target_size, anchor, visual_ground_offset)
		draw_texture_rect(texture, Rect2(origin, target_size), false)
		_draw_grounding_guide(contact, shadow_center, shadow_radius, not profile.is_empty())
		return
	draw_colored_polygon(_ellipse(contact, w * 1.05, w * 0.5), Color(0, 0, 0, 0.35))
	draw_set_transform(contact)
	match kind:
		"cogumelo":
			draw_rect(Rect2(-w * 0.3, -height, w * 0.6, height), color.darkened(0.35))
			draw_colored_polygon(_ellipse(Vector2(0, -height), w * 1.1, w * 0.6), color)
			draw_colored_polygon(_ellipse(Vector2(0, -height - 4), w * 0.8, w * 0.35), color.lightened(0.18))
		"bolha":
			draw_colored_polygon(_ellipse(Vector2(0, -height * 0.5), w * 0.9, height * 0.5), Color(color, 0.75))
			draw_colored_polygon(_ellipse(Vector2(-w * 0.25, -height * 0.7), w * 0.25, height * 0.15), color.lightened(0.4))
		"rocha":
			var pts := PackedVector2Array([Vector2(-w, 0), Vector2(-w * 0.8, -height * 0.7), Vector2(-w * 0.2, -height), Vector2(w * 0.5, -height * 0.8), Vector2(w, -height * 0.2), Vector2(w * 0.7, 0)])
			draw_colored_polygon(pts, color)
			draw_colored_polygon(PackedVector2Array([Vector2(-w * 0.2, -height), Vector2(w * 0.5, -height * 0.8), Vector2(0, -height * 0.5)]), color.lightened(0.15))
		"torii":
			var post := w * 0.28
			draw_rect(Rect2(-w, -height, post, height), color)
			draw_rect(Rect2(w - post, -height, post, height), color)
			draw_rect(Rect2(-w * 1.25, -height, w * 2.5, post * 1.1), color.darkened(0.15))
			draw_rect(Rect2(-w * 1.05, -height * 0.78, w * 2.1, post * 0.7), color)
		"cristal":
			draw_colored_polygon(PackedVector2Array([Vector2(-w * 0.6, 0), Vector2(0, -height), Vector2(w * 0.6, 0), Vector2(0, w * 0.25)]), color)
			draw_colored_polygon(PackedVector2Array([Vector2(0, -height), Vector2(w * 0.6, 0), Vector2(0, w * 0.25)]), color.lightened(0.22))
		"cachoeira":
			draw_rect(Rect2(-w * 0.55, -height, w * 1.1, height), Color(color, 0.55))
			draw_rect(Rect2(-w * 0.2, -height, w * 0.4, height), Color(color.lightened(0.5), 0.7))
			draw_colored_polygon(_ellipse(Vector2.ZERO, w * 0.9, w * 0.4), Color(color.lightened(0.3), 0.5))
		"pilar_abissal":
			draw_colored_polygon(_diamond(Vector2.ZERO, w, w * 0.5), color.darkened(0.3))
			draw_rect(Rect2(-w, -height, w * 2, height), color)
			draw_colored_polygon(_diamond(Vector2(0, -height), w, w * 0.5), color.lightened(0.15))
			draw_rect(Rect2(-2, -height, 4, height), Color(0.75, 0.5, 1.0, 0.55))
		_:
			draw_colored_polygon(_diamond(Vector2.ZERO, w, w * 0.5), color.darkened(0.1))
			draw_rect(Rect2(-w, -height, w * 2, height), color)
			draw_colored_polygon(_diamond(Vector2(0, -height), w, w * 0.5), color.lightened(0.15))
	draw_set_transform(Vector2.ZERO)
