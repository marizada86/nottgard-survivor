class_name HeroPanel
extends PanelContainer
## SPEC-131 (MEC-048): painel do herói no canto da HUD da run, no padrão visual da ficha C (SPEC-130).
## Retrato, nome e nível, PV com barreira, XP, atributos, chips de moeda/abates/CA/CAM e ícones das bênçãos ativas.
## Montado por código como a ficha; a moldura é a versão leve (translúcida) da moldura da ficha.

const WIDTH := 372.0
const GOLD := Color(0.93, 0.78, 0.4)
const GOLD_DIM := Color(0.62, 0.5, 0.28)
const IRON := Color(0.36, 0.35, 0.42)
const MUTED := Color(0.62, 0.62, 0.68)
const BOON_BORDER := Color(0.72, 0.5, 0.92)
const BARRIER_COLOR := Color(0.62, 0.86, 1.0)
const ATTR_NAMES := {"forca": "FOR", "inteligencia": "INT", "constituicao": "CON", "carisma": "CAR"}
const ATTR_FULL := {"forca": "Força", "inteligencia": "Inteligência", "constituicao": "Constituição", "carisma": "Carisma"}
const ATTR_COLORS := {"forca": Color(0.92, 0.42, 0.38), "inteligencia": Color(0.96, 0.86, 0.42), "constituicao": Color(0.45, 0.66, 0.96), "carisma": Color(0.78, 0.56, 0.96)}
const BOON_ICON := 28.0
const PANEL_ALPHA := 0.35  ## fundo bem translúcido: o jogador enxerga a arena por trás (pedido do dono)
const HINT_PULSE_UNTIL := 90.0  ## o selo da tecla C pulsa até a ficha ser aberta ou até esse tempo de run

var xp_bar: ProgressBar
var hp_bar: ProgressBar
var barrier_bar: ProgressBar
var hp_label: Label
var name_label: Label
var level_label: Label
var gold_label: Label
var kills_label: Label
var ca_label: Label
var cam_label: Label
var abyss_label: Label
var boon_row: HBoxContainer
var _portrait: TextureRect
var _attr_labels := {}
var _chips := {}
var _hero_id := ""
var _defense_key := ""
var _boon_key := ""
var _keycap: PanelContainer
var _key_label: Label
var _key_icon: TextureRect
var _sheet_seen := false

func _ready() -> void:
	custom_minimum_size = Vector2(WIDTH, 0)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_theme_stylebox_override("panel", _box(Color(0.045, 0.04, 0.06, PANEL_ALPHA), Color(GOLD_DIM, 0.55), 1, 3))
	draw.connect(_draw_corners)
	var margin := MarginContainer.new()
	for side in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 8)
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(margin)
	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 6)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_child(root)
	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 10)
	top.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(top)
	top.add_child(_build_portrait())
	top.add_child(_build_main_column())
	root.add_child(_build_chip_row())
	boon_row = HBoxContainer.new()
	boon_row.add_theme_constant_override("separation", 5)
	boon_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	boon_row.visible = false
	root.add_child(boon_row)
	Game.controls.changed.connect(_update_key_hint)
	_update_key_hint()

func _box(bg: Color, border: Color, width: int, radius: int) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = bg
	sb.border_color = border
	sb.set_border_width_all(width)
	sb.set_corner_radius_all(radius)
	return sb

func _label(text: String, size: int, color: Color = Color(0.92, 0.9, 0.86)) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return l

func _outlined(l: Label) -> Label:
	l.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85))
	l.add_theme_constant_override("outline_size", 4)
	return l

## Marcas de canto discretas, só nas bordas (mesmo vocabulário da ficha C, SPEC-130 D9).
func _draw_corners() -> void:
	var r := Rect2(Vector2.ZERO, size).grow(-2.0)
	var m := 9.0
	var c := Color(GOLD, 0.7)
	for corner in [r.position, Vector2(r.end.x, r.position.y), Vector2(r.position.x, r.end.y), r.end]:
		var sx := 1.0 if corner.x <= r.position.x else -1.0
		var sy := 1.0 if corner.y <= r.position.y else -1.0
		draw_line(corner, corner + Vector2(m * sx, 0), c, 2.0)
		draw_line(corner, corner + Vector2(0, m * sy), c, 2.0)

func _build_portrait() -> Control:
	var frame := PanelContainer.new()
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.add_theme_stylebox_override("panel", _box(Color(0.08, 0.07, 0.1, 0.5), Color(GOLD_DIM, 0.7), 1, 2))
	_portrait = TextureRect.new()
	_portrait.custom_minimum_size = Vector2(76, 76)
	_portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.add_child(_portrait)
	return frame

func _build_main_column() -> Control:
	var col := VBoxContainer.new()
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_theme_constant_override("separation", 4)
	col.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var name_row := HBoxContainer.new()
	name_row.add_theme_constant_override("separation", 8)
	name_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	name_label = _outlined(_label("", 20, GOLD))
	name_row.add_child(name_label)
	level_label = _label("", 14, MUTED)
	level_label.size_flags_vertical = Control.SIZE_SHRINK_END
	name_row.add_child(level_label)
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	name_row.add_child(spacer)
	name_row.add_child(_build_key_hint())
	col.add_child(name_row)
	hp_bar = ProgressBar.new()
	hp_bar.show_percentage = false
	hp_bar.custom_minimum_size = Vector2(0, 22)
	hp_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hp_bar.add_theme_stylebox_override("fill", _box(Color(0.75, 0.14, 0.14), Color(0, 0, 0, 0), 0, 2))
	hp_bar.add_theme_stylebox_override("background", _box(Color(0.12, 0.05, 0.05, 0.5), Color(0.4, 0.2, 0.2, 0.7), 1, 2))
	col.add_child(hp_bar)
	barrier_bar = ProgressBar.new()
	barrier_bar.show_percentage = false
	barrier_bar.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	barrier_bar.offset_top = -5.0
	barrier_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	barrier_bar.add_theme_stylebox_override("fill", _box(BARRIER_COLOR, Color(0, 0, 0, 0), 0, 1))
	barrier_bar.add_theme_stylebox_override("background", StyleBoxEmpty.new())
	barrier_bar.visible = false
	hp_bar.add_child(barrier_bar)
	var heart := _icon_rect("res://assets/icons/ui/health.png", 16.0)
	heart.set_anchors_and_offsets_preset(Control.PRESET_CENTER_LEFT)
	heart.offset_left = 4.0
	heart.offset_right = 20.0
	heart.offset_top = -8.0
	heart.offset_bottom = 8.0
	hp_bar.add_child(heart)
	hp_label = _outlined(_label("", 15))
	hp_label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	hp_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hp_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hp_bar.add_child(hp_label)
	xp_bar = ProgressBar.new()
	xp_bar.show_percentage = false
	xp_bar.custom_minimum_size = Vector2(0, 7)
	xp_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	xp_bar.add_theme_stylebox_override("fill", _box(Color(0.25, 0.6, 0.9), Color(0, 0, 0, 0), 0, 2))
	xp_bar.add_theme_stylebox_override("background", _box(Color(0.05, 0.08, 0.12, 0.5), Color(0.18, 0.28, 0.4, 0.7), 1, 2))
	col.add_child(xp_bar)
	var attrs := HBoxContainer.new()
	attrs.add_theme_constant_override("separation", 10)
	attrs.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for a in ATTR_NAMES:
		var l := _outlined(_label("", 14, ATTR_COLORS[a]))
		l.mouse_filter = Control.MOUSE_FILTER_PASS
		l.tooltip_text = String(ATTR_FULL[a])
		_attr_labels[a] = l
		attrs.add_child(l)
	col.add_child(attrs)
	return col

## Selo de tecla "C" + "Ficha": diz sem texto longo que a tecla abre mais informações do herói.
## Pulsa até o jogador abrir a ficha pela primeira vez na run (note_sheet_opened).
func _build_key_hint() -> Control:
	var box := HBoxContainer.new()
	box.add_theme_constant_override("separation", 5)
	box.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	box.mouse_filter = Control.MOUSE_FILTER_PASS
	box.tooltip_text = "Tecla C: abre a ficha do herói (armas, equipamento, passivas, bênçãos e bônus)."
	_keycap = PanelContainer.new()
	_keycap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sb := _box(Color(0.2, 0.16, 0.08, 0.55), GOLD, 2, 4)
	sb.content_margin_left = 7.0
	sb.content_margin_right = 7.0
	sb.content_margin_top = 1.0
	sb.content_margin_bottom = 1.0
	_keycap.add_theme_stylebox_override("panel", sb)
	var key_row := HBoxContainer.new()
	_keycap.add_child(key_row)
	_key_label = _outlined(_label("C", 15, GOLD))
	_key_icon = TextureRect.new()
	_key_icon.custom_minimum_size = Vector2(24, 16)
	_key_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_key_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	key_row.add_child(_key_icon)
	key_row.add_child(_key_label)
	_keycap.visible = not Game.touch_controls_enabled()
	box.add_child(_keycap)
	box.add_child(_outlined(_label("Ficha", 14, Color(0.85, 0.82, 0.72))))
	return box

func _update_key_hint() -> void:
	_key_icon.texture = Game.controls.glyph("run_items")
	_key_icon.visible = _key_icon.texture != null
	_key_label.text = Game.controls.prompt("run_items", "C")
	_key_label.visible = _key_icon.texture == null
	_keycap.get_parent().tooltip_text = "%s: abre a ficha do herói." % Game.controls.prompt("run_items", "C")

## O HUD chama quando a ficha C abre: o selo para de pulsar.
func note_sheet_opened() -> void:
	_sheet_seen = true
	_keycap.self_modulate = Color.WHITE

func _icon_rect(path: String, px: float) -> TextureRect:
	var t := TextureRect.new()
	t.custom_minimum_size = Vector2(px, px)
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if ResourceLoader.exists(path):
		t.texture = load(path)
	return t

func _build_chip_row() -> Control:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 14)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	gold_label = _chip(row, "coin", "Moedas")
	kills_label = _chip(row, "kill", "Abates")
	ca_label = _chip(row, "ca", "")
	cam_label = _chip(row, "cam", "")
	abyss_label = _outlined(_label("", 16, Color(0.78, 0.56, 0.96)))
	abyss_label.mouse_filter = Control.MOUSE_FILTER_PASS
	abyss_label.visible = false
	row.add_child(abyss_label)
	return row

## Chip de ícone e valor; o tooltip fica no próprio chip (PASS: não rouba cliques da arena).
func _chip(row: HBoxContainer, icon: String, tip: String) -> Label:
	var chip := HBoxContainer.new()
	chip.add_theme_constant_override("separation", 4)
	chip.mouse_filter = Control.MOUSE_FILTER_PASS
	chip.tooltip_text = tip
	chip.add_child(_icon_rect("res://assets/icons/ui/%s.png" % icon, 22.0))
	var l := _outlined(_label("", 16))
	chip.add_child(l)
	row.add_child(chip)
	_chips[icon] = chip
	return l

# ---------------------------------------------------------------- estado

func update(b: Battle) -> void:
	var h := b.hero
	if h.id != _hero_id:
		_hero_id = h.id
		var path := "res://assets/portraits/%s.png" % h.id
		_portrait.texture = load(path) if ResourceLoader.exists(path) else null
	name_label.text = h.name
	level_label.text = "Nv %d" % h.level
	hp_bar.max_value = h.max_hp
	hp_bar.value = h.hp
	hp_label.text = hp_text(h.hp, h.max_hp, b.barrier)
	barrier_bar.visible = b.barrier > 0.0
	barrier_bar.max_value = h.max_hp
	barrier_bar.value = minf(b.barrier, h.max_hp)
	xp_bar.max_value = h.xp_need
	xp_bar.value = h.xp
	for a in _attr_labels:
		(_attr_labels[a] as Label).text = "%s %d" % [ATTR_NAMES[a], h.attr(a)]
	gold_label.text = str(int(h.gold))
	kills_label.text = str(b.stats.kills)
	_update_abyss(b)
	var ev_ca := h.typed_evasion("fisico")
	var ev_cam := h.typed_evasion("magico")
	ca_label.text = defense_text(h.ca(), ev_ca)
	cam_label.text = defense_text(h.cam(), ev_cam)
	var key := "%d|%d|%d|%d|%f" % [h.ca(), h.cam(), int(ev_ca * 100.0), int(ev_cam * 100.0), h.m("dodge")]
	if key != _defense_key:
		_defense_key = key
		(_chips["ca"] as Control).tooltip_text = CharacterSheet.plain_text(CharacterSheet.defense_tip("ca", h.ca(), ev_ca, h.m("dodge")))
		(_chips["cam"] as Control).tooltip_text = CharacterSheet.plain_text(CharacterSheet.defense_tip("cam", h.cam(), ev_cam, h.m("dodge")))
	_update_boons(h.boons)
	if not _sheet_seen and b.time < HINT_PULSE_UNTIL:
		var k := 1.0 + 0.55 * (0.5 + 0.5 * sin(float(Time.get_ticks_msec()) * 0.005))
		_keycap.self_modulate = Color(k, k, k)
	else:
		_keycap.self_modulate = Color.WHITE

## SPEC-141: selo roxo "Marcas N" só quando a run tem Marcas do Abismo; o tooltip lista as marcas.
func _update_abyss(b: Battle) -> void:
	abyss_label.visible = b.abyss_level > 0
	if b.abyss_level <= 0:
		return
	abyss_label.text = "Marcas %d" % b.abyss_level
	var lines: Array = []
	for id in AbyssMarks.ids():
		var lv := AbyssMarks.level_of(b.abyss_marks, String(id))
		if lv > 0:
			lines.append("%s %d" % [AbyssMarks.cfg().marks[id].name, lv])
	abyss_label.tooltip_text = "Marcas do Abismo (moedas +%d%%): %s" % [int(round(AbyssMarks.reward_bonus(b.abyss_marks) * 100.0)), ", ".join(lines)]

static func hp_text(hp: float, max_hp: float, barrier: float) -> String:
	var t := "%d / %d" % [int(ceil(hp)), int(max_hp)]
	if barrier > 0.0:
		t += "  +%d" % int(ceil(barrier))
	return t

static func defense_text(value: int, evasion: float) -> String:
	return "%d (%d%%)" % [value, int(evasion * 100.0)]

func _update_boons(boons: Array) -> void:
	var ids: Array = []
	for bn in boons:
		ids.append(String(bn.get("id", "")))
	var key := ",".join(ids)
	if key == _boon_key:
		return
	_boon_key = key
	for c in boon_row.get_children():
		boon_row.remove_child(c)
		c.queue_free()
	boon_row.visible = not boons.is_empty()
	for bn in boons:
		boon_row.add_child(_boon_icon(bn))

func _boon_icon(bn: Dictionary) -> Control:
	var frame := PanelContainer.new()
	frame.mouse_filter = Control.MOUSE_FILTER_PASS
	frame.add_theme_stylebox_override("panel", _box(Color(0.1, 0.07, 0.14, 0.5), BOON_BORDER, 1, 2))
	var god := String(bn.get("god", ""))
	frame.tooltip_text = "%s%s\n%s" % [String(bn.get("name", "")), (" (bênção de %s)" % god) if god != "" else "", String(bn.get("desc", ""))]
	var path := BoonKinds.icon_path(bn)
	if ResourceLoader.exists(path):
		frame.add_child(_icon_rect(path, BOON_ICON))
	else:
		var letter := _label(String(bn.get("name", "?")).substr(0, 1), 18, Color(0.9, 0.88, 0.8))
		letter.custom_minimum_size = Vector2(BOON_ICON, BOON_ICON)
		letter.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		letter.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		frame.add_child(letter)
	return frame
