class_name CharacterSheet
extends Control
## SPEC-130 (MEC-045): ficha do herói (tecla C). Coluna fixa do herói à esquerda; à direita 4 abas com grade de ícones
## e, embaixo, o detalhe do item em foco. Q/E ou LB/RB trocam de aba; setas/direcional movem o foco; o mouse também foca.
## Arte FILA-025 (ART-035); dados e navegacao preservados.

signal closed

const TAB_NAMES := ["Armas e feitiços", "Equipamento", "Passivas e bênçãos", "Sinergias e bônus"]
const TAB_LABELS := ["Armas", "Equipamento", "Passivas", "Sinergias"]
const PANEL_SIZE := UiKit.WINDOW_SIZE
const GOLD := UiKit.GOLD   # SPEC-165: o padrão visual mora no UiKit
const GOLD_DIM := UiKit.GOLD_DIM
const IRON := UiKit.IRON
const BOON_BORDER := Color(0.72, 0.5, 0.92)
const GRANTED_BORDER := Color(0.45, 0.8, 0.5)
const MUTED := UiKit.MUTED
const ATTR_COLORS := {"forca": Color(0.92, 0.42, 0.38), "inteligencia": Color(0.96, 0.86, 0.42), "constituicao": Color(0.45, 0.66, 0.96), "carisma": Color(0.78, 0.56, 0.96)}
const SLOT_NAMES := {"arma": "Arma", "armadura": "Armadura", "amuleto": "Amuleto", "anel": "Anel"}
const BONUS_GROUPS := [
	{"title": "Ofensivo", "keys": ["dmg_pct", "dmg_flat", "crit_overflow_bonus", "crit_overflow_step", "cd_pct", "area_pct", "hit", "low_hp_dmg", "forca", "inteligencia"]},
	{"title": "Defensivo", "keys": ["hp", "regen", "ca", "cam", "dr", "dodge", "lifesteal", "constituicao", "puddle_immune"]},
	{"title": "Utilidade", "keys": []},  # tudo que sobrar
]
const EXTRA_LABELS := {"weapon_slots": "espaços de arma", "rerolls": "rerrolagens", "choices": "opções extras", "revive": "revives", "low_hp_dmg": "dano com PV baixo"}
const PASSIVE_MAX_LEVEL := 5   # igual ao limite das ofertas de level-up (Battle._build_offer)
const DETAIL_HEIGHT := 265.0   # SPEC-147: cabe o próximo nível e a evolução sem rolar tanto
const DETAIL_HEIGHT_BONUS := 110.0   # a aba de bônus precisa da grade, não do detalhe
const STAT_ICONS := {"ca": "ca", "cam": "cam", "hp": "health", "xp_pct": "xp", "gold_pct": "coin"}

var _b: Battle
var _tab := 0
var _panel: PanelContainer
var _portrait: TextureRect
var _hero_label: Label
var _level_label: Label
var _attr_labels := {}
var _hp_label: Label
var _hp_bar: ProgressBar
var _ca_btn: Button
var _cam_btn: Button
var _ability_icon: TextureRect
var _ability_name: Label
var _ability_desc: Label
var _ability_cd: Label
var _tab_buttons: Array = []
var _scroll: ScrollContainer
var _content: VBoxContainer
var _detail: RichTextLabel
var _detail_frame: PanelContainer
var _close_btn: Button
var _stat_tips := {}
var _previous_hint: Button
var _next_hint: Button
var _ability_hint: Label

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	visible = false
	add_child(UiKit.dim())
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(center)
	_panel = UiKit.window(PANEL_SIZE)
	center.add_child(_panel)
	var margin := UiKit.margin(40)
	_panel.add_child(margin)
	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 10)
	margin.add_child(root)
	root.add_child(_build_header())
	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 16)
	root.add_child(body)
	body.add_child(_build_hero_column())
	body.add_child(_build_tabs_column())
	Game.controls.changed.connect(_update_controller_hints)
	_update_controller_hints()
	if Game.touch_controls_enabled():
		_close_btn.text = "Fechar"
		_close_btn.custom_minimum_size = Vector2(88, 56)
		_panel.custom_minimum_size = Vector2(1088, 650)
		TouchUI.adapt_sizes(self)

func _box(bg: Color, border: Color, width: int, radius: int) -> StyleBoxFlat:
	return UiKit.box(bg, border, width, radius)

func _label(text: String, size: int, color: Color = UiKit.TEXT) -> Label:
	return UiKit.label(text, size, color)

func _build_header() -> Control:
	var row := HBoxContainer.new()
	row.add_child(_label("FICHA DO HERÓI", 24, GOLD))
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(spacer)
	_close_btn = Button.new()
	_close_btn.text = "Fechar (C)"
	_close_btn.pressed.connect(func(): closed.emit())
	row.add_child(_close_btn)
	return row

func _build_hero_column() -> Control:
	var col := VBoxContainer.new()
	col.custom_minimum_size = Vector2(270, 0)
	col.add_theme_constant_override("separation", 4 if Game.touch_controls_enabled() else 6)
	var frame := PanelContainer.new()
	frame.add_theme_stylebox_override("panel", SheetArt.frame(SheetArt.DETAIL, 16, 20))
	_portrait = TextureRect.new()
	_portrait.custom_minimum_size = Vector2(250, 70 if Game.touch_controls_enabled() else 90)
	_portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	frame.add_child(_portrait)
	col.add_child(frame)
	_hero_label = _label("", 22, GOLD)
	col.add_child(_hero_label)
	_level_label = _label("", 14, MUTED)
	col.add_child(_level_label)
	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 18)
	for a in ["forca", "inteligencia", "constituicao", "carisma"]:
		var l := _label("", 17, ATTR_COLORS[a])
		_attr_labels[a] = l
		grid.add_child(l)
	col.add_child(grid)
	_hp_label = _label("", 15)
	col.add_child(_hp_label)
	_hp_bar = ProgressBar.new()
	_hp_bar.show_percentage = false
	_hp_bar.custom_minimum_size = Vector2(0, 12)
	_hp_bar.add_theme_stylebox_override("fill", _box(Color(0.75, 0.2, 0.2), Color(0, 0, 0, 0), 0, 2))
	_hp_bar.add_theme_stylebox_override("background", _box(Color(0.12, 0.05, 0.05), Color(0.4, 0.2, 0.2), 1, 2))
	col.add_child(_hp_bar)
	_ca_btn = _stat_button("ca")
	_cam_btn = _stat_button("cam")
	col.add_child(_ca_btn)
	col.add_child(_cam_btn)
	col.add_child(_build_ability_card())
	return col

func _stat_button(kind: String) -> Button:
	var b := Button.new()
	b.flat = true
	b.alignment = HORIZONTAL_ALIGNMENT_LEFT
	b.expand_icon = true
	b.add_theme_constant_override("icon_max_width", 24)
	b.add_theme_font_size_override("font_size", 16)
	var empty := StyleBoxEmpty.new()
	var focus := _box(Color(0.2, 0.17, 0.1, 0.5), GOLD, 2, 2)
	for s in ["normal", "hover", "pressed"]:
		b.add_theme_stylebox_override(s, empty)
	b.add_theme_stylebox_override("focus", focus)
	var path := "res://assets/icons/ui/%s.png" % kind
	if ResourceLoader.exists(path):
		b.icon = load(path)
	b.focus_entered.connect(func(): _show_stat_tip(kind))
	b.mouse_entered.connect(func():
		if not b.has_focus():
			b.grab_focus())
	return b

func _build_ability_card() -> Control:
	var card := PanelContainer.new()
	card.add_theme_stylebox_override("panel", SheetArt.frame(SheetArt.DETAIL, 16, 26))
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 3)
	card.add_child(v)
	_ability_hint = _label("HABILIDADE", 12, GOLD_DIM)
	v.add_child(_ability_hint)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	v.add_child(row)
	_ability_icon = TextureRect.new()
	_ability_icon.custom_minimum_size = Vector2(48, 48)
	_ability_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_ability_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	row.add_child(_ability_icon)
	var text := VBoxContainer.new()
	text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(text)
	_ability_name = _label("", 16, GOLD)
	text.add_child(_ability_name)
	_ability_cd = _label("", 13, Color(0.9, 0.78, 0.43))
	text.add_child(_ability_cd)
	_ability_desc = _label("", 13, Color(0.82, 0.82, 0.86))
	_ability_desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_ability_desc.custom_minimum_size = Vector2(240, 0)
	v.add_child(_ability_desc)
	return card

func _build_tabs_column() -> Control:
	var col := VBoxContainer.new()
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_theme_constant_override("separation", 8)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	if not Game.touch_controls_enabled():
		_previous_hint = UiKit.hint_button()
		_previous_hint.pressed.connect(cycle_tab.bind(-1))
		row.add_child(_previous_hint)
	var group := ButtonGroup.new()
	for i in TAB_NAMES.size():
		var tb := UiKit.tab_button(TAB_LABELS[i], TAB_NAMES[i], SheetArt.TAB_ICONS[i], group)
		tb.pressed.connect(set_tab.bind(i))
		_tab_buttons.append(tb)
		row.add_child(tb)
	if not Game.touch_controls_enabled():
		_next_hint = UiKit.hint_button()
		_next_hint.pressed.connect(cycle_tab.bind(1))
		row.add_child(_next_hint)
	col.add_child(row)
	_scroll = ScrollContainer.new()
	_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_scroll.custom_minimum_size = Vector2(0, 150)
	_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_scroll.follow_focus = true
	col.add_child(_scroll)
	_content = VBoxContainer.new()
	_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_content.add_theme_constant_override("separation", 6)
	_scroll.add_child(_content)
	_detail_frame = PanelContainer.new()
	var detail_frame := _detail_frame
	detail_frame.custom_minimum_size = Vector2(0, DETAIL_HEIGHT)
	detail_frame.add_theme_stylebox_override("panel", SheetArt.frame(SheetArt.DETAIL, 16, 28))
	_detail = RichTextLabel.new()
	_detail.bbcode_enabled = true
	_detail.scroll_active = true
	_detail.focus_mode = Control.FOCUS_NONE
	_detail.add_theme_font_size_override("normal_font_size", 16)
	_detail.add_theme_font_size_override("bold_font_size", 16)
	detail_frame.add_child(_detail)
	col.add_child(detail_frame)
	return col

# ---------------------------------------------------------------- abertura e estado

func show_sheet(b: Battle) -> void:
	Game.controls.transition()
	_b = b
	_refresh_hero()
	visible = true
	set_tab(0)

func hide_sheet() -> void:
	Game.controls.transition()
	visible = false

func _update_controller_hints() -> void:
	UiKit.update_tab_hints(_previous_hint, _next_hint)
	_close_btn.text = "Fechar" if Game.touch_controls_enabled() else "Fechar (%s)" % Game.controls.prompt("ui_cancel", "C")
	_ability_hint.text = "HABILIDADE" if Game.touch_controls_enabled() else "HABILIDADE [%s]" % Game.controls.prompt("hero_active", "Q/RMB")

func current_tab() -> int:
	return _tab

func cycle_tab(d: int) -> void:
	set_tab(posmod(_tab + d, TAB_NAMES.size()))

func set_tab(i: int) -> void:
	_tab = clampi(i, 0, TAB_NAMES.size() - 1)
	for k in _tab_buttons.size():
		(_tab_buttons[k] as Button).set_pressed_no_signal(k == _tab)
	if _b == null:
		return
	for c in _content.get_children():
		_content.remove_child(c)
		c.queue_free()
	for s in tab_sections(_tab):
		_add_section(s)
	if _tab == 3:
		_add_bonus_block()
	_detail_frame.custom_minimum_size.y = DETAIL_HEIGHT_BONUS if _tab == 3 else DETAIL_HEIGHT
	_detail.text = "[color=#9a9aa6]Escolha um item na grade para ver o detalhe.[/color]"
	_scroll.scroll_vertical = 0
	call_deferred("_focus_first")

func _focus_first() -> void:
	if not visible:
		return
	var first := _first_slot(_content)
	if first != null:
		first.grab_focus()
	else:
		_close_btn.grab_focus()

func _first_slot(n: Node) -> SheetSlot:
	for c in n.get_children():
		if c is SheetSlot:
			return c
		var r := _first_slot(c)
		if r != null:
			return r
	return null

func _input(ev: InputEvent) -> void:
	if not visible or Playtest.is_overlay_open() or not Game.controls.accepts(ev):
		# Com o bloco de notas (F5) aberto, Q/E são letras do texto e Esc fecha a nota, não a ficha.
		return
	if ev.is_action_pressed("ui_cancel"):
		closed.emit()
		Game.controls.transition()
		get_viewport().set_input_as_handled()
		return
	var d := UiKit.tab_step(ev)
	if d != 0:
		cycle_tab(d)
		get_viewport().set_input_as_handled()

# ---------------------------------------------------------------- coluna do herói

func _refresh_hero() -> void:
	var h := _b.hero
	var portrait_path := "res://assets/portraits/%s.png" % h.id
	_portrait.texture = load(portrait_path) if ResourceLoader.exists(portrait_path) else null
	_hero_label.text = h.name
	_level_label.text = "Nível %d" % h.level
	var names := {"forca": "FOR", "inteligencia": "INT", "constituicao": "CON", "carisma": "CAR"}
	for a in _attr_labels:
		(_attr_labels[a] as Label).text = "%s  %d" % [names[a], h.attr(a)]
	_hp_label.text = "PV  %d / %d" % [int(ceil(h.hp)), int(h.max_hp)]
	_hp_bar.max_value = h.max_hp
	_hp_bar.value = h.hp
	_ca_btn.text = " CA %d  ·  %d%% esquiva" % [h.ca(), int(h.typed_evasion("fisico") * 100.0)]
	_cam_btn.text = " CAM %d  ·  %d%% esquiva" % [h.cam(), int(h.typed_evasion("magico") * 100.0)]
	_stat_tips = {"ca": defense_tip("ca", h.ca(), h.typed_evasion("fisico"), h.m("dodge")), "cam": defense_tip("cam", h.cam(), h.typed_evasion("magico"), h.m("dodge"))}
	_ca_btn.tooltip_text = plain_text(_stat_tips.ca)
	_cam_btn.tooltip_text = plain_text(_stat_tips.cam)
	var a: Dictionary = _b.active_def
	if a.is_empty():
		_ability_name.text = ""
		_ability_desc.text = ""
		_ability_cd.text = ""
		_ability_icon.texture = null
		return
	var icon_path := "res://assets/icons/abilities/%s.png" % String(a.get("id", ""))
	_ability_icon.texture = load(icon_path) if ResourceLoader.exists(icon_path) else null
	_ability_name.text = String(a.get("name", ""))
	_ability_desc.text = String(a.get("desc", ""))
	_ability_cd.text = ability_cooldown_text(_b.active_cooldown_effective(), float(a.get("cooldown", 0.0)))

static func ability_cooldown_text(effective: float, base: float) -> String:
	var t := "Recarga %.1f s" % effective
	if not is_equal_approx(effective, base):
		t += " (base %.0f s)" % base
	return t

## Texto de ajuda de CA/CAM (pedido do Manzi, IN-058). `evasion` é a esquiva tipada já calculada (0 a 0,30).
static func defense_tip(kind: String, value: int, evasion: float, dodge := 0.0) -> String:
	var full := "Classe de Armadura (CA)" if kind == "ca" else "Classe de Armadura Mágica (CAM)"
	var vs := "ataques físicos" if kind == "ca" else "feitiços e efeitos mágicos"
	var t := "[font_size=22][b]%s[/b][/font_size]\nQuanto maior, menos %s acertam o herói. Cada ponto acima de 10 dá 3%% de esquiva contra eles, no máximo 30%%. A precisão do atacante reduz essa esquiva.\n[color=#e6c76e]Agora: %s %d → %d%% de esquiva.[/color]" % [full, vs, kind.to_upper(), value, int(round(evasion * 100.0))]
	if dodge > 0.0:
		t += "\nA esquiva geral (%d%%) é somada a esta, por fora." % int(round(dodge * 100.0))
	return t

## Tira o BBCode para tooltips nativos (também usado pelo HeroPanel, SPEC-131).
static func plain_text(bb: String) -> String:
	var r := RegEx.new()
	r.compile("\\[/?[a-z_]+[^\\]]*\\]")
	return r.sub(bb, "", true)

func _show_stat_tip(kind: String) -> void:
	_detail.text = String(_stat_tips.get(kind, ""))

# ---------------------------------------------------------------- conteúdo das abas

## Seções da aba: [{title, entries, empty_text}]. Cada entrada: {icon, border, badge, badge_max, evolve, empty, caption, detail}.
func tab_sections(i: int) -> Array:
	match i:
		0: return _weapon_sections()
		1: return _equipment_sections()
		2: return _passive_sections()
		3: return _synergy_sections()
	return []

func _weapon_sections() -> Array:
	var h := _b.hero
	var owned: Array = []
	var granted: Array = []
	for w in h.weapons:
		(granted if w.granted else owned).append(_weapon_entry(w))
	var total := h.weapon_slots()
	var n_owned := owned.size()
	for k in maxi(0, total - n_owned):
		owned.append(_empty_entry("Vazio", "Espaço livre para um feitiço ou arma. Novas armas aparecem nas ofertas de level-up."))
	var out := [{"title": "Armas e feitiços  %d/%d" % [n_owned, total], "entries": owned, "empty_text": ""}]
	if not granted.is_empty():
		out.append({"title": "Concedidas por itens", "entries": granted, "empty_text": ""})
	return out

func _equipment_sections() -> Array:
	var h := _b.hero
	var entries: Array = []
	for slot in Items.SLOTS:
		if h.items.has(slot):
			entries.append(_item_entry(h.items[slot]))
		else:
			entries.append(_empty_entry(String(SLOT_NAMES.get(slot, slot)), "Slot de %s vazio. Itens vêm de baús, chefes e da loja." % String(SLOT_NAMES.get(slot, slot)).to_lower()))
	return [{"title": "Equipamento  %d/%d" % [h.items.size(), Items.SLOTS.size()], "entries": entries, "empty_text": ""}]

func _passive_sections() -> Array:
	var h := _b.hero
	var passives: Array = []
	for pid in h.passives:
		passives.append(_passive_entry(String(pid), int(h.passives[pid])))
	var boons: Array = []
	for bn in h.boons:
		boons.append(_boon_entry(bn))
	return [
		{"title": "Passivas  %d" % passives.size(), "entries": passives, "empty_text": "Nenhuma passiva ainda."},
		{"title": "Bênçãos  %d" % boons.size(), "entries": boons, "empty_text": "Nenhuma bênção ainda."},
	]

func _synergy_sections() -> Array:
	var h := _b.hero
	var wdata: Dictionary = Data.table("weapons")
	var entries: Array = []
	var mult := maxi(1, _b.descent_depth)
	for wid in h.synergies:
		var syn: Dictionary = wdata.get(wid, {}).get("synergy", {})
		if syn.is_empty():
			continue
		entries.append({"icon": Items.weapon_icon(String(wid)), "letter": String(syn.name).substr(0, 1), "border": GOLD,
			"badge": "×%d" % mult, "badge_max": false, "evolve": false, "empty": false,
			"detail": "[font_size=22][b]♾ Sinergia: %s[/b][/font_size]\n%s por camada descida (agora ×%d)." % [String(syn.name), Items.mods_text(syn.bonus_per_depth), mult]})
	return [{"title": "Sinergias  %d" % entries.size(), "entries": entries, "empty_text": "Nenhuma sinergia ainda."}]

func _empty_entry(caption: String, detail: String) -> Dictionary:
	return {"empty": true, "caption": caption, "detail": "[font_size=20][b]Vazio[/b][/font_size]\n[color=#9a9aa6]%s[/color]" % detail}

func _weapon_entry(w: Weapon) -> Dictionary:
	var tag := "  [color=#99cc99](concedida por item)[/color]" if w.granted else ""
	var status := "  [color=#ffd966]▲ pronta para evoluir[/color]" if w.can_evolve() else ""
	var dmg_line := _b.weapon_damage_text(w.params())
	var hint := _b.evolve_hint(w)
	var detail := "[font_size=22][b]%s[/b][/font_size]%s%s\n%s%s%s" % [w.display_name(), tag, status, String(w.def.get("desc", "")),
		("\n[color=#e6c76e]%s[/color]" % dmg_line) if dmg_line != "" else "", ("\n[color=#9fb4d8]%s[/color]" % hint) if hint != "" else ""]
	# SPEC-147 (IN-059): o que o próximo nível muda e no que a arma evolui
	var next_text := _b.next_level_text(w)
	if next_text != "":
		detail += "\n\n[b][color=#99cc99]Próximo nível (Nv %d):[/color][/b]\n%s" % [w.level + 1, next_text]
	elif w.max_level() > 1:
		detail += "\n\n[color=#ffd966]Nível máximo.[/color]"
	var evo_text := _b.evolution_text(w)
	if evo_text != "":
		detail += "\n\n[b][color=#ffb36b]Evolução:[/color][/b] %s" % evo_text
	var multi := w.max_level() > 1
	return {"icon": Items.weapon_icon(String(w.id)), "letter": String(w.def.name).substr(0, 1),
		"border": GRANTED_BORDER if w.granted else IRON, "badge": ("Nv%d" % w.level) if multi else "★",
		"badge_max": (w.level >= w.max_level()) if multi else true, "evolve": w.can_evolve(), "empty": false, "detail": detail}

func _item_entry(it: Dictionary) -> Dictionary:
	var rarity := String(it.get("rarity", "comum"))
	var color := Items.rarity_color(rarity)
	var lvl := int(it.get("level", 1))
	var has_base := String(it.get("base", "")) != ""
	var detail := "[font_size=22][b][color=#%s]%s[/color][/b][/font_size]\n[color=#%s]%s[/color] · %s" % [
		color.to_html(false), String(it.name), color.to_html(false), Items.rarity_label(rarity), String(SLOT_NAMES.get(String(it.get("slot", "")), ""))]
	if has_base:
		detail += " · [color=#ffd966]Nv %d/%d%s[/color]" % [lvl, Items.MAX_LEVEL, " (máximo)" if lvl >= Items.MAX_LEVEL else ""]
	var mods := Items.scaled_mods(it, lvl)
	for k in mods:
		detail += "\n• %s %s" % [Items.mod_value_text(k, float(mods[k])), Items.mod_label(k)]
	if has_base and lvl < Items.MAX_LEVEL:
		detail += "\n[color=#99cc99]Próximo nível (Nv %d): %s[/color]" % [lvl + 1, Items.mods_text(Items.scaled_mods(it, lvl + 1))]
	if lvl >= Items.MAX_LEVEL:
		var sup := Items.super_mods(it)
		if not sup.is_empty():
			detail += "\n[color=#ffd966]Bônus de nível máximo: %s[/color]" % Items.mods_text(sup)
	if String(it.get("note", "")) != "":
		detail += "\n[i]%s[/i]" % String(it.note)
	var icon_id := String(it.get("base", it.get("id", "")))
	return {"icon": Items.item_icon(icon_id), "letter": String(it.name).substr(0, 1), "border": color,
		"badge": ("Nv%d" % lvl) if has_base else "", "badge_max": lvl >= Items.MAX_LEVEL, "evolve": false, "empty": false, "detail": detail}

func _passive_entry(pid: String, level: int) -> Dictionary:
	var p: Dictionary = Data.table("passives")[pid]
	var src := String(p.get("src", ""))
	var detail := "[font_size=22][b]✦ %s  Nv %d[/b][/font_size]%s\n%s" % [String(p.name), level, ("\n[color=#9a9aa6]%s[/color]" % src) if src != "" else "", String(p.get("desc", ""))]
	detail += "\n[color=#e6c76e]Agora: %s[/color]" % Items.mods_text(passive_mods_at(pid, level))
	if level < PASSIVE_MAX_LEVEL:
		detail += "\n\n[b][color=#99cc99]Próximo nível (Nv %d):[/color][/b] %s" % [level + 1, Items.mods_text(passive_mods_at(pid, level + 1))]
	else:
		detail += "\n\n[color=#ffd966]Nível máximo.[/color]"
	return {"icon": "res://assets/icons/passives/%s.png" % pid, "letter": String(p.name).substr(0, 1), "border": IRON,
		"badge": "Nv%d" % level, "badge_max": level >= PASSIVE_MAX_LEVEL, "evolve": false, "empty": false, "detail": detail}

## SPEC-147: bônus total de uma passiva no nível dado (os mods da tabela valem por nível).
static func passive_mods_at(pid: String, level: int) -> Dictionary:
	var out := {}
	var mods: Dictionary = Data.table("passives").get(pid, {}).get("mods", {})
	for k in mods:
		out[k] = float(mods[k]) * float(level)
	return out

func _boon_entry(bn: Dictionary) -> Dictionary:
	var god := String(bn.get("god", ""))
	return {"icon": BoonKinds.icon_path(bn), "letter": String(bn.get("name", "?")).substr(0, 1), "border": BOON_BORDER,
		"badge": "", "badge_max": false, "evolve": false, "empty": false,
		"detail": "[font_size=22][b]☼ %s[/b][/font_size]%s\n%s" % [String(bn.get("name", "")), ("\n[color=#c9a8ee]Bênção de %s[/color]" % god) if god != "" else "", String(bn.get("desc", ""))]}

func _add_section(s: Dictionary) -> void:
	_content.add_child(_label(String(s.title), 15, GOLD))
	var entries: Array = s.entries
	if entries.is_empty():
		_content.add_child(_label(String(s.get("empty_text", "")), 14, MUTED))
		return
	var grid := HFlowContainer.new()
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_theme_constant_override("h_separation", 14)
	grid.add_theme_constant_override("v_separation", 10)
	for e in entries:
		var slot := SheetSlot.new()
		slot.setup(e)
		slot.chosen.connect(_on_slot_chosen)
		grid.add_child(slot)
	_content.add_child(grid)

func _on_slot_chosen(slot: SheetSlot) -> void:
	_detail.text = String(slot.entry.get("detail", ""))

# ---------------------------------------------------------------- bônus totais

## Bônus somados do herói, agrupados: [{title, rows: [{key, label, value}]}]. Chaves sem peso na tabela entram em "Utilidade".
func bonus_groups() -> Array:
	var mods: Dictionary = _b.hero.mods
	var used := {}
	var out: Array = []
	for g in BONUS_GROUPS:
		var rows: Array = []
		var keys: Array = (g["keys"] as Array).duplicate()
		if keys.is_empty():
			for k in mods:
				if not used.has(k):
					keys.append(k)
		for k in keys:
			used[k] = true
			if not mods.has(k):
				continue
			var v := float(mods[k])
			if absf(v) < Items.mod_epsilon(k):
				continue
			rows.append({"key": k, "label": String(EXTRA_LABELS.get(k, Items.mod_label(k))), "value": Items.mod_value_text(k, v)})
		out.append({"title": g.title, "rows": rows})
	return out

func _add_bonus_block() -> void:
	_content.add_child(_label("Bônus totais  (itens, passivas, bênçãos, herói e melhorias somados)", 15, GOLD))
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 18)
	for g in bonus_groups():
		var col := VBoxContainer.new()
		col.custom_minimum_size = Vector2(210, 0)
		col.add_theme_constant_override("separation", 3)
		col.add_child(_label(String(g.title), 14, Color(0.78, 0.74, 0.62)))
		if g.rows.is_empty():
			col.add_child(_label("—", 14, MUTED))
		for r in g.rows:
			col.add_child(_bonus_row(r))
		row.add_child(col)
	_content.add_child(row)

func _bonus_row(r: Dictionary) -> Control:
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 6)
	var icon_path := "res://assets/icons/ui/%s.png" % String(STAT_ICONS.get(String(r.key), ""))
	if STAT_ICONS.has(String(r.key)) and ResourceLoader.exists(icon_path):
		var t := TextureRect.new()
		t.texture = load(icon_path)
		t.custom_minimum_size = Vector2(18, 18)
		t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		h.add_child(t)
	else:
		var dot := _label("◆", 12, GOLD_DIM)
		dot.custom_minimum_size = Vector2(18, 0)
		dot.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		h.add_child(dot)
	# SPEC-147 (IN-061): nome antes do valor ("Dano 28%"), como o Manzi pediu
	h.add_child(_label(String(r.label), 15))
	h.add_child(_label(String(r.value), 15, Color(0.6, 0.9, 0.6) if not String(r.value).begins_with("-") else Color(0.95, 0.5, 0.45)))
	return h

func _padded(sb: StyleBoxFlat, margin: float) -> StyleBoxFlat:
	sb.set_content_margin_all(margin)
	return sb
