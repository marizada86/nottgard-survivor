class_name OfferCard
extends Button
## MEC-027: cartão de oferta resumido. Mostra nome, 1 linha de destaque, selo de veredito e preço;
## o detalhe (tabela novo × atual × diferença, rodapé) vem no tooltip customizado ao passar o mouse.

const COLOR_UP := Color(0.55, 0.9, 0.55)
const COLOR_DOWN := Color(1.0, 0.5, 0.45)
const COLOR_NEUTRAL := Color(0.7, 0.7, 0.7)
const COLOR_PRICE := Color(1.0, 0.9, 0.5)

var offer: Dictionary = {}

func setup(index: int, o: Dictionary, name_color: Color, icon_tex: Texture2D) -> void:
	offer = o
	custom_minimum_size = Vector2(640, 60)
	alignment = HORIZONTAL_ALIGNMENT_LEFT
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for side in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 8 if side in ["left", "right"] else 4)
	add_child(margin)
	var row := HBoxContainer.new()
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_theme_constant_override("separation", 10)
	margin.add_child(row)
	if icon_tex != null:
		var icon := TextureRect.new()
		icon.texture = icon_tex
		icon.custom_minimum_size = Vector2(40, 40)
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_child(icon)
	var left := VBoxContainer.new()
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.alignment = BoxContainer.ALIGNMENT_CENTER
	left.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(left)
	var role_names := {"synergy": "SINERGIA", "defense": "DEFESA", "direction": "NOVA DIREÇÃO"}
	var role := String(role_names.get(o.get("role", ""), ""))
	var title := String(o.name)
	if String(o.get("price_text", "")) != "" and title.find(" — ") >= 0:
		title = title.substr(0, title.rfind(" — "))
	left.add_child(_label("%d.  %s%s" % [index + 1, "[%s] " % role if role != "" else "", title], 17, name_color))
	var brief := _label(String(o.get("brief", "")), 15, Color(0.88, 0.88, 0.88))
	brief.clip_text = true
	left.add_child(brief)
	var right := VBoxContainer.new()
	right.alignment = BoxContainer.ALIGNMENT_CENTER
	right.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(right)
	var badge_row := _badge(o.get("badge", null))
	if badge_row != null:
		right.add_child(badge_row)
	var price := String(o.get("price_text", ""))
	if price != "":
		var pl := _label(price, 15, COLOR_PRICE)
		pl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		right.add_child(pl)
	if _has_detail(o) or String(o.get("tooltip", "")) != "":
		tooltip_text = " "

static func _has_detail(o: Dictionary) -> bool:
	var d: Dictionary = o.get("detail", {})
	return not d.is_empty() and (not d.get("rows", []).is_empty() or not d.get("footer", []).is_empty())

func _label(text: String, size: int, color: Color) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return l

func _badge(b: Variant) -> Control:
	if not (b is Dictionary):
		return null
	var box := HBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_END
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_theme_constant_override("separation", 8)
	if b.has("text"):
		box.add_child(_label(String(b.text), 17, COLOR_PRICE))
		return box
	var up := int(b.get("up", 0))
	var down := int(b.get("down", 0))
	if up == 0 and down == 0:
		box.add_child(_label("=", 18, COLOR_NEUTRAL))
		return box
	if up > 0:
		box.add_child(_label("▲ %d" % up, 18, COLOR_UP))
	if down > 0:
		box.add_child(_label("▼ %d" % down, 18, COLOR_DOWN))
	return box

## Tooltip com a tabela de comparação (ou o texto antigo, quando a oferta não tem detalhe).
func _make_custom_tooltip(_for_text: String) -> Object:
	return build_detail()

## Tabela de detalhe da oferta; inline_only=true devolve null quando não há detalhe (modo Shift do HUD).
func build_detail(inline_only := false) -> Control:
	if inline_only and not _has_detail(offer):
		return null
	var margin := MarginContainer.new()
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	margin.add_child(box)
	var d: Dictionary = offer.get("detail", {})
	var rows: Array = d.get("rows", [])
	if not rows.is_empty():
		var cols: Array = d.get("columns", [])
		var grid := GridContainer.new()
		grid.columns = 4
		grid.add_theme_constant_override("h_separation", 18)
		grid.add_theme_constant_override("v_separation", 2)
		box.add_child(grid)
		grid.add_child(_label("", 14, COLOR_NEUTRAL))
		for c in cols:
			grid.add_child(_label(String(c), 14, Color(0.95, 0.85, 0.55)))
		for r in rows:
			var sign := int(r.sign)
			grid.add_child(_label(String(r.label), 15, Color(0.9, 0.9, 0.9)))
			for v in r.cols:
				grid.add_child(_label(String(v), 15, Color(0.95, 0.95, 0.95)))
			grid.add_child(_label(String(r.delta), 15, COLOR_UP if sign > 0 else (COLOR_DOWN if sign < 0 else COLOR_NEUTRAL)))
	var footer: Array = d.get("footer", [])
	if rows.is_empty() and footer.is_empty():
		footer = [String(offer.get("tooltip", ""))]
	for line in footer:
		var fl := _label(String(line), 14, Color(0.8, 0.8, 0.7))
		fl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		fl.custom_minimum_size = Vector2(380, 0)
		box.add_child(fl)
	return margin
