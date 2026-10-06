extends CanvasLayer
## HUD da run. Os nós vêm de hud.tscn (nomes únicos %); este script só os atualiza.

signal offer_chosen(index: int)
signal reroll_pressed
signal resume_pressed
signal quit_pressed
signal again_pressed
signal menu_pressed
signal aim_pressed
signal help_pressed
signal speed_pressed
signal revive_pressed
signal decline_revive_pressed
signal items_closed

@onready var info_label: Label = %InfoLabel  # só as linhas do Estige; o resto do herói está no HeroPanel
@onready var stage_rule_icon: TextureRect = %StageRuleIcon
@onready var timer_label: Label = %TimerLabel
@onready var stage_label: Label = %StageLabel
@onready var boss_panel: Control = %BossPanel
@onready var boss_name: Label = %BossName
@onready var boss_bar: ProgressBar = %BossBar
@onready var weapons_label: Label = %WeaponsLabel
@onready var toast_box: VBoxContainer = %ToastBox
@onready var prompt_label: Label = %PromptLabel
@onready var levelup_panel: PanelContainer = %LevelUpPanel
@onready var lv_title: Label = %LvTitle
@onready var offer_box: VBoxContainer = %OfferBox
@onready var reroll_btn: Button = %RerollBtn
@onready var pause_panel: PanelContainer = %PausePanel
@onready var aim_btn: Button = %AimBtn
@onready var vol_slider: HSlider = %VolSlider
@onready var result_panel: PanelContainer = %ResultPanel
@onready var result_title: Label = %ResultTitle
@onready var result_text: Label = %ResultText
@onready var result_background: TextureRect = %ResultBackground
@onready var revive_panel: PanelContainer = %RevivePanel
@onready var revive_text: Label = %ReviveText
var items_panel: CharacterSheet  # SPEC-130: ficha C em abas (ui/character_sheet.gd)
var hero_panel: HeroPanel  # SPEC-131 (ui/hero_panel.gd)
var _active_icon_id := ""
var _ability_slot: AbilitySlot
var _stage_icon_id := ""
var objective_label: Label  # SPEC-118: objetivos dos acontecimentos da fase

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	reroll_btn.pressed.connect(func(): reroll_pressed.emit())
	%ResumeBtn.pressed.connect(func(): resume_pressed.emit())
	%QuitBtn.pressed.connect(func(): quit_pressed.emit())
	%AgainBtn.pressed.connect(func(): again_pressed.emit())
	%MenuBtn.pressed.connect(func(): menu_pressed.emit())
	%HelpBtn.pressed.connect(func(): help_pressed.emit())
	%SpeedBtn.pressed.connect(func(): speed_pressed.emit())
	%PauseHelpBtn.pressed.connect(func(): help_pressed.emit())
	%ReviveBtn.pressed.connect(func(): revive_pressed.emit())
	%DeclineReviveBtn.pressed.connect(func(): decline_revive_pressed.emit())
	aim_btn.pressed.connect(func(): aim_pressed.emit())
	vol_slider.value_changed.connect(func(v: float):
		Game.profile.data.settings.volume = v
		Game.apply_settings())
	# SPEC-131: painel do herói no padrão da ficha C, acima das linhas do Estige
	hero_panel = HeroPanel.new()
	hero_panel.name = "HeroPanel"
	$StatBox.add_child(hero_panel)
	$StatBox.move_child(hero_panel, 0)
	# SPEC-127: o slot com ícone e recarga fica no centro inferior
	_ability_slot = AbilitySlot.new()
	_ability_slot.name = "AbilitySlot"
	_ability_slot.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	_ability_slot.offset_left = -AbilitySlot.SIZE.x * 0.5
	_ability_slot.offset_right = AbilitySlot.SIZE.x * 0.5
	_ability_slot.offset_top = -138.0
	_ability_slot.offset_bottom = -138.0 + AbilitySlot.SIZE.y
	_ability_slot.grow_horizontal = Control.GROW_DIRECTION_BOTH
	add_child(_ability_slot)
	boss_panel.visible = false
	levelup_panel.visible = false
	pause_panel.visible = false
	result_panel.visible = false
	revive_panel.visible = false
	items_panel = CharacterSheet.new()
	items_panel.name = "ItemsPanel"
	items_panel.closed.connect(func(): items_closed.emit())
	add_child(items_panel)
	prompt_label.text = ""
	objective_label = Label.new()
	objective_label.name = "ObjectiveLabel"
	objective_label.set_anchors_preset(Control.PRESET_CENTER_TOP)
	objective_label.offset_left = -360.0
	objective_label.offset_right = 360.0
	objective_label.offset_top = 74.0
	objective_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	objective_label.add_theme_font_size_override("font_size", 16)
	objective_label.add_theme_color_override("font_color", Color(0.98, 0.86, 0.55))
	objective_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85))
	objective_label.add_theme_constant_override("outline_size", 5)
	objective_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(objective_label)

func _unhandled_input(ev: InputEvent) -> void:
	if not ev.is_pressed() or (ev is InputEventKey and ev.echo):
		return
	if (ev.is_action_pressed(Game.ACTION_RUN_PAUSE) or ev.is_action_pressed(&"ui_cancel")) and pause_panel.visible:
		resume_pressed.emit()
		get_viewport().set_input_as_handled()
	elif (ev.is_action_pressed(Game.ACTION_RUN_ITEMS) or ev.is_action_pressed(&"ui_cancel")) and items_panel.visible:
		items_closed.emit()
		get_viewport().set_input_as_handled()

## MEC-027: segurar Shift abre o detalhe de todas as opções, para quem joga sem mouse.
var _detail_nodes: Array = []
var _detail_on := false

func _process(_delta: float) -> void:
	if _ability_slot != null:
		_ability_slot.visible = not (items_panel.visible or levelup_panel.visible or pause_panel.visible or result_panel.visible or revive_panel.visible)
	if not levelup_panel.visible or _detail_nodes.is_empty():
		return
	var on := Input.is_action_pressed(Game.ACTION_OFFER_DETAILS)
	if on != _detail_on:
		_detail_on = on
		for n in _detail_nodes:
			n.visible = on

func update_stats(b: Battle) -> void:
	var h := b.hero
	hero_panel.update(b)
	if b.has_styx_contract() and b.styx_exposure > 0.0:
		info_label.text = "Estige %.1f s · INT efetiva %d" % [b.styx_exposure, h.styx_intelligence()]
	elif h.styx_forget_t > 0.0:
		info_label.text = "Esquecimento do Estige %.1f s" % h.styx_forget_t
	else:
		info_label.text = ""
	info_label.visible = info_label.text != ""
	var ability: Dictionary = Data.table("abilities").get(h.id, {})
	var ability_id := String(ability.get("id", ""))
	if ability_id != _active_icon_id:
		_active_icon_id = ability_id
		var ability_path := "res://assets/icons/abilities/%s.png" % ability_id
		_ability_slot.set_ability(String(ability.get("name", "")), String(ability.get("desc", "")),
			load(ability_path) if ResourceLoader.exists(ability_path) else null, "Q/RMB")
	_ability_slot.set_state(b.active_cd, b.active_cd_max, b.active_guard > 0, get_process_delta_time())
	var stage_icons := {
		"dagruve": "dagruve_rituals", "shedaklah": "shedaklah_puddles", "molor": "molor_bubbles",
		"durao": "", "feng_tu": "feng_tu_strikes", "shendilavri": "shendilavri_illusions",
		"goranthis": "goranthis_sanctuary", "pilares": "pilares_rotation"
	}
	var stage_icon_id := String(stage_icons.get(b.stage_id, ""))
	if stage_icon_id != _stage_icon_id:
		_stage_icon_id = stage_icon_id
		var stage_icon_path := "res://assets/icons/stages/%s.png" % stage_icon_id
		stage_rule_icon.texture = load(stage_icon_path) if ResourceLoader.exists(stage_icon_path) else null
	var t := int(b.time)
	var dur := int(b.stage.duration)
	if b.boss_spawned and not b.boss_dead:
		timer_label.text = "CHEFE"
	else:
		timer_label.text = "%02d:%02d" % [t / 60, t % 60]
	stage_label.text = "%s%s%s" % [b.stage.name, "  (Mira: %s)" % ("AUTO" if b.aim == Battle.Aim.AUTO else "MOUSE"), "  [%s]" % b.speed_label() if b.speed_scale() > 1.0 else ""]
	%SpeedBtn.visible = b.can_speed_2x()
	%SpeedBtn.set_pressed_no_signal(b.speed_scale() > 1.0)
	%SpeedBtn.text = b.speed_label() if b.can_speed_2x() else "1x"
	if b.boss != null and not b.boss.dead and b.boss_spawned:
		boss_panel.visible = true
		boss_name.text = b.boss.name
		boss_bar.max_value = b.boss.max_hp
		boss_bar.value = maxf(0.0, b.boss.hp)
	else:
		boss_panel.visible = false
	var lines: Array = []
	for w in h.weapons:
		lines.append("⚔ %s%s" % [w.display_name(), " (item)" if w.granted else ""])
	var pl: Array = []
	for pid in h.passives:
		pl.append("%s %d" % [Data.table("passives")[pid].name, h.passives[pid]])
	if not pl.is_empty():
		lines.append("✦ " + ", ".join(pl))
	for slot in h.items:
		var it: Dictionary = h.items[slot]
		lines.append("◆ %s" % it.name)
	for bn in h.boons:
		lines.append("☼ %s" % bn.name)
	weapons_label.text = "\n".join(lines)
	var pr := ""
	for it in b.interactions:
		if not it.used and it.kind in ["altar", "ritual", "portal", "loja", "ferreiro", "curandeiro", "ampulheta", "doacao", "aposta", "event_pact"] and it.pos.distance_to(h.pos) <= 1.6:
			pr = "[E/oeste] " + {"altar": "rezar no altar", "ritual": "iniciar o ritual", "portal": "descer pelo portal",
				"loja": "negociar na loja", "ferreiro": "forjar no ferreiro", "curandeiro": "buscar cura", "ampulheta": "girar a ampulheta (+60 s, inimigos acumulados)", "doacao": "doar um item por uma bênção", "aposta": "arriscar moedas na mesa",
				"event_pact": "%s" % String(it.get("label", "pacto")).replace(" [E/oeste]", "")}[it.kind]
	if pr == "" and (b.stage_cleared or b.final_victory):
		pr = "[X/norte] Extrair ×%.2f" % b.reward_multiplier()
		if b.stage.get("next", "") != "":
			pr += "   [E/oeste] Descer ×%.2f" % b.next_reward_multiplier()
	prompt_label.text = pr
	objective_label.text = "
".join(b.happenings.hud_lines(b) + b.kinds.hud_lines(b))

func show_offer(b: Battle) -> void:
	for c in offer_box.get_children():
		c.queue_free()
	_detail_nodes.clear()
	_detail_on = false
	var shop_titles := {"shop_loja": "Loja — compre ou saia", "shop_ferreiro": "Ferreiro — forje uma arma", "shop_curandeiro": "Curandeiro — cure suas feridas", "shop_doacao": "Altar da Doação — troque um item por uma bênção", "shop_aposta": "Mesa de Aposta — arrisque suas moedas"}
	if b.offer_kind == "levelup":
		lv_title.text = "Nível %d — escolha (1-%d)" % [b.hero.level, b.offer.size()]
	elif b.offer_kind == "item":
		lv_title.text = "Item encontrado — equipar ou manter?"
	elif b.offer_kind == "pact":
		lv_title.text = "%s — escolha ou recuse" % b.pact_title
	elif shop_titles.has(b.offer_kind):
		lv_title.text = String(shop_titles[b.offer_kind])
	else:
		lv_title.text = "Altar — escolha uma bênção (e sua maldição) ou recuse"
	for i in b.offer.size():
		var o: Dictionary = b.offer[i]
		var is_card := o.has("brief")
		var btn: Button = OfferCard.new() if is_card else Button.new()
		var role_names := {"synergy": "SINERGIA", "defense": "DEFESA", "direction": "NOVA DIREÇÃO"}
		var role := String(role_names.get(o.get("role", ""), ""))
		if not is_card:
			btn.text = "%d.  %s%s\n      %s" % [i + 1, "[%s] " % role if role != "" else "", o.name, o.desc]
			btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
			btn.custom_minimum_size = Vector2(620, 62)
		var icon_path := ""
		match String(o.t):
			"item_swap": icon_path = "res://assets/icons/items/%s.png" % String(o.keep.get("base", o.keep.get("id", "")))
			"weapon_new", "weapon_up": icon_path = "res://assets/icons/weapons/%s.png" % String(o.id)
			"evolve": icon_path = "res://assets/icons/weapons/%s.png" % String(o.into)
			"passive": icon_path = "res://assets/icons/passives/%s.png" % String(o.id)
			"boon": icon_path = "res://assets/icons/boons/%s.png" % String(o.id)
			"heal": icon_path = "res://assets/pickups/health_potion.png"
			"gold": icon_path = "res://assets/pickups/gold_coin.png"
			"shop_item": icon_path = "res://assets/icons/items/%s.png" % String(o.item.get("base", o.item.get("id", "")))
			"shop_weapon_up": icon_path = "res://assets/icons/weapons/%s.png" % String(o.weapon_id)
			"shop_heal": icon_path = "res://assets/pickups/health_potion.png"
			"shop_item_up": icon_path = "res://assets/icons/items/%s.png" % String(o.base)
		var icon_tex: Texture2D = load(icon_path) if ResourceLoader.exists(icon_path) else null
		if icon_tex != null and not is_card:
			btn.icon = icon_tex
			btn.expand_icon = true
			btn.icon_alignment = HORIZONTAL_ALIGNMENT_LEFT
		match String(o.t):
			"evolve": btn.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))
			"weapon_new": btn.add_theme_color_override("font_color", Color(0.6, 1.0, 0.6))
			"boon": btn.add_theme_color_override("font_color", Color(0.85, 0.6, 1.0))
			"item_swap":
				# ART-016: a cor é a raridade do item da opção, não "o novo está verde" (empurrava trocar raro por comum)
				btn.add_theme_color_override("font_color", Items.rarity_color(String(o.keep.get("rarity", "comum"))))
			"shop_item": btn.add_theme_color_override("font_color", Items.rarity_color(String(o.item.get("rarity", "comum"))))
			"shop_item_up": btn.add_theme_color_override("font_color", Items.rarity_color(String(o.get("rarity", "comum"))))
			"shop_weapon_up", "shop_heal": btn.add_theme_color_override("font_color", Color(1.0, 0.9, 0.5))
			"shop_leave", "boon_skip": btn.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
		if is_card:
			(btn as OfferCard).setup(i, o, btn.get_theme_color("font_color"), icon_tex)
		else:
			var tip := String(o.get("tooltip", ""))
			if tip != "":
				btn.tooltip_text = tip
		if bool(o.get("locked", false)):
			# MEC-023: sem moedas (ou linha informativa): visível, esmaecida e sem efeito
			btn.disabled = true
			btn.modulate = Color(1, 1, 1, 0.9)
		btn.pressed.connect(func(): offer_chosen.emit(i))
		offer_box.add_child(btn)
		if i == 0:
			btn.call_deferred("grab_focus")
		if is_card:
			var detail := (btn as OfferCard).build_detail(true)
			if detail != null:
				var wrap := MarginContainer.new()
				wrap.add_theme_constant_override("margin_left", 56)
				wrap.add_theme_constant_override("margin_bottom", 6)
				wrap.add_child(detail)
				wrap.visible = false
				offer_box.add_child(wrap)
				_detail_nodes.append(wrap)
	if b.offer.any(func(o): return o.has("brief")):
		var hint := Label.new()
		hint.text = "passe o mouse, segure Shift ou pressione o analógico direito para ver detalhes e comparação"
		hint.add_theme_font_size_override("font_size", 14)
		hint.add_theme_color_override("font_color", Color(0.72, 0.72, 0.72))
		hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		offer_box.add_child(hint)
	reroll_btn.visible = b.offer_kind == "levelup"
	reroll_btn.text = "Rerrolar (R/LB) — %d restantes" % b.rerolls
	reroll_btn.disabled = b.rerolls <= 0
	levelup_panel.visible = true

func hide_offer() -> void:
	levelup_panel.visible = false

# ------------------------------------------------------------------ MEC-009: mini-cinemática de evolução

var _evo_root: Control = null
var _evo_key := ""

func show_evolution(b: Battle) -> void:
	var cine: Dictionary = b.evolve_cine
	if cine.is_empty():
		hide_evolution()
		return
	var key := "%s>%s" % [String(cine.from), String(cine.into)]
	if _evo_root != null and _evo_key == key:
		return
	hide_evolution()
	_evo_key = key
	var wdata: Dictionary = Data.table("weapons")
	var from_w: Dictionary = wdata.get(String(cine.from), {})
	var into_w: Dictionary = wdata.get(String(cine.into), {})
	var passive_name := String(Data.table("passives").get(String(cine.passive), {}).get("name", String(cine.passive)))
	var root := ColorRect.new()
	root.color = Color(0, 0, 0, 0.74)
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(root)
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_child(center)
	var col := VBoxContainer.new()
	col.alignment = BoxContainer.ALIGNMENT_CENTER
	col.add_theme_constant_override("separation", 14)
	col.z_index = 2
	var panel_path := "res://assets/ui/evolucao_painel_moldura.png"
	if ResourceLoader.exists(panel_path):
		var panel := PanelContainer.new()
		panel.custom_minimum_size = Vector2(800, 520)
		var style := StyleBoxTexture.new()
		style.texture = load(panel_path)
		for edge in [SIDE_LEFT, SIDE_RIGHT, SIDE_TOP, SIDE_BOTTOM]:
			style.set_texture_margin(edge, 70)
			style.set_content_margin(edge, 90 if edge == SIDE_BOTTOM else 70)
		panel.add_theme_stylebox_override("panel", style)
		center.add_child(panel)
		panel.add_child(col)
	else:
		center.add_child(col)
	var flare_path := "res://assets/vfx/vfx_evolucao_flare.png"
	if ResourceLoader.exists(flare_path) and not Game.reduced_impact():
		var flare := TextureRect.new()
		var atlas := AtlasTexture.new()
		atlas.atlas = load(flare_path)
		atlas.region = Rect2(0, 0, 256, 256)
		flare.texture = atlas
		flare.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		flare.set_anchors_preset(Control.PRESET_CENTER)
		flare.offset_left = -240
		flare.offset_right = 240
		flare.offset_top = -240
		flare.offset_bottom = 240
		flare.mouse_filter = Control.MOUSE_FILTER_IGNORE
		flare.modulate.a = 0.5
		flare.z_index = 1
		root.add_child(flare)
		var flash := root.create_tween()
		for frame in 4:
			flash.tween_callback(func(): atlas.region = Rect2((frame % 2) * 256, (frame / 2) * 256, 256, 256))
			flash.tween_interval(0.12)
		flash.tween_callback(flare.queue_free)
	var title := Label.new()
	title.text = "★  EVOLUÇÃO  ★"
	title.add_theme_font_size_override("font_size", 38)
	title.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	col.add_child(title)
	var icons := HBoxContainer.new()
	icons.alignment = BoxContainer.ALIGNMENT_CENTER
	icons.add_theme_constant_override("separation", 26)
	col.add_child(icons)
	for pair in [[String(cine.from), 96.0], ["", 0.0], [String(cine.into), 132.0]]:
		if String(pair[0]) == "":
			var arrow := Label.new()
			arrow.text = "→"
			arrow.add_theme_font_size_override("font_size", 54)
			arrow.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))
			icons.add_child(arrow)
			continue
		var icon := TextureRect.new()
		var path := "res://assets/icons/weapons/%s.png" % String(pair[0])
		icon.texture = load(path) if ResourceLoader.exists(path) else null
		icon.custom_minimum_size = Vector2(float(pair[1]), float(pair[1]))
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icons.add_child(icon)
	var names := Label.new()
	names.text = "%s  →  %s" % [String(from_w.get("name", cine.from)), String(into_w.get("name", cine.into))]
	names.add_theme_font_size_override("font_size", 24)
	names.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	col.add_child(names)
	var cond := Label.new()
	cond.text = "Condições cumpridas: nível %d (máximo) + passiva %s" % [int(cine.level), passive_name]
	cond.add_theme_color_override("font_color", Color(0.62, 0.71, 0.85))
	cond.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	col.add_child(cond)
	var desc := Label.new()
	desc.text = String(into_w.get("desc", ""))
	desc.custom_minimum_size = Vector2(560, 0)
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	col.add_child(desc)
	var hint := Label.new()
	hint.text = "clique ou tecle para continuar"
	hint.add_theme_color_override("font_color", Color(0.55, 0.55, 0.55))
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	col.add_child(hint)
	_evo_root = root
	root.modulate.a = 0.0
	col.pivot_offset = col.size * 0.5
	col.scale = Vector2(0.85, 0.85)
	var tw := root.create_tween().set_parallel(true)
	tw.tween_property(root, "modulate:a", 1.0, 0.35)
	tw.tween_property(col, "scale", Vector2.ONE, 0.45).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func hide_evolution() -> void:
	if _evo_root != null:
		_evo_root.queue_free()
		_evo_root = null
	_evo_key = ""

func toast(text: String, color: Color = Color(1, 1, 1)) -> void:
	if toast_box.get_child_count() >= 4:
		toast_box.get_child(0).queue_free()
	var l := Label.new()
	l.text = text
	l.modulate = color
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	if text.length() > 60:
		# epígrafes de fase (SPEC-117) são longas: quebram em até 640 px e ficam mais tempo na tela
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		l.custom_minimum_size.x = 640.0
	l.add_theme_color_override("font_outline_color", Color(0, 0, 0))
	l.add_theme_constant_override("outline_size", 5)
	toast_box.add_child(l)
	var tw := create_tween()
	tw.tween_interval(3.0 + maxf(0.0, float(text.length() - 60)) * 0.04)
	tw.tween_property(l, "modulate:a", 0.0, 0.6)
	tw.tween_callback(l.queue_free)

func show_items_panel(b: Battle) -> void:
	hero_panel.note_sheet_opened()
	items_panel.show_sheet(b)

func hide_items_panel() -> void:
	items_panel.hide_sheet()

func show_pause(v: bool) -> void:
	pause_panel.visible = v
	if v:
		aim_btn.text = "Mira: %s (Tab / norte)" % ("AUTO" if Game.aim_mode() == Battle.Aim.AUTO else "MANUAL")
		vol_slider.value = float(Game.profile.data.settings.volume)
		%ResumeBtn.call_deferred("grab_focus")

func show_revive_offer(b: Battle) -> void:
	hide_offer()
	pause_panel.visible = false
	result_panel.visible = false
	var preview := b.result()
	preview.reward_rate = 0.3
	var pending := Game.profile.preview_earned(preview)
	revive_text.text = "Seu herói caiu. Deseja reviver com 50%% de PV?\n\nSe encerrar agora, receberá +%d moedas (30%% da tentativa)." % pending
	revive_panel.visible = true
	%ReviveBtn.grab_focus()

func hide_revive_offer() -> void:
	revive_panel.visible = false

func show_result(res: Dictionary, summary: Dictionary) -> void:
	hide_offer()
	pause_panel.visible = false
	hide_revive_offer()
	result_title.text = "Vitória!" if res.won else "Você caiu..."
	var background_path := "res://assets/ui/backgrounds/victory_background.png" if res.won else "res://assets/ui/backgrounds/defeat_background.png"
	result_background.texture = load(background_path) if ResourceLoader.exists(background_path) else null
	var t := int(res.time)
	var txt := "%s · %s\nTempo %02d:%02d · Nível %d · Abates %d · Chefes %d\nModo: %s · Profundidade %d · Multiplicador ×%.2f\n\n+%d moedas%s (total %d)" % [
		Data.table("heroes")[res.hero].name, Data.table("stages")[res.stage].name, t / 60, t % 60, res.level, res.kills, res.bosses,
		"extraído" if res.extracted else ("derrota" if res.dead else "final"), int(res.get("descent_depth", 0)), float(res.get("reward_mult", 1.0)),
		summary.earned, (" (%d%% da tentativa)" % int(round(float(summary.reward_rate) * 100.0))) if float(summary.reward_rate) < 1.0 else "", summary.coins]
	var names: Array = []
	for id in summary.achievements:
		for a in Data.table("achievements").achievements:
			if a.id == id:
				names.append("★ %s — %s" % [a.name, a.reward.get("text", "")])
	if not names.is_empty():
		txt += "\n\nConquistas:\n" + "\n".join(names)
	result_text.text = txt
	result_panel.visible = true
	%AgainBtn.call_deferred("grab_focus")

## SPEC-116 D3: a barra de XP pisca ao receber moeda ou XP.
var _xp_pulse: Tween

func pulse_xp() -> void:
	if _xp_pulse != null and _xp_pulse.is_valid():
		_xp_pulse.kill()
	hero_panel.xp_bar.modulate = Color(1.6, 1.5, 1.2)
	_xp_pulse = create_tween()
	_xp_pulse.tween_property(hero_panel.xp_bar, "modulate", Color.WHITE, 0.18)
