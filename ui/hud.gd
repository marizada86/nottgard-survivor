extends CanvasLayer
## HUD da run. Os nós vêm de hud.tscn (nomes únicos %); este script só os atualiza.

signal offer_chosen(index: int)
signal reroll_pressed
signal resume_pressed
signal quit_pressed
signal again_pressed
signal menu_pressed
signal aim_pressed

@onready var name_label: Label = %NameLabel
@onready var hp_bar: ProgressBar = %HpBar
@onready var hp_label: Label = %HpLabel
@onready var xp_bar: ProgressBar = %XpBar
@onready var info_label: Label = %InfoLabel
@onready var active_label: Label = %ActiveLabel
@onready var active_icon: TextureRect = %ActiveIcon
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
var _active_icon_id := ""
var _stage_icon_id := ""

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	reroll_btn.pressed.connect(func(): reroll_pressed.emit())
	%ResumeBtn.pressed.connect(func(): resume_pressed.emit())
	%QuitBtn.pressed.connect(func(): quit_pressed.emit())
	%AgainBtn.pressed.connect(func(): again_pressed.emit())
	%MenuBtn.pressed.connect(func(): menu_pressed.emit())
	aim_btn.pressed.connect(func(): aim_pressed.emit())
	vol_slider.value_changed.connect(func(v: float):
		Game.profile.data.settings.volume = v
		Game.apply_settings())
	boss_panel.visible = false
	levelup_panel.visible = false
	pause_panel.visible = false
	result_panel.visible = false
	prompt_label.text = ""

func _unhandled_input(ev: InputEvent) -> void:
	if pause_panel.visible and ev is InputEventKey and ev.pressed and not ev.echo and ev.physical_keycode == KEY_ESCAPE:
		resume_pressed.emit()
		get_viewport().set_input_as_handled()

func update_stats(b: Battle) -> void:
	var h := b.hero
	name_label.text = "%s  ·  Nv %d" % [h.name, h.level]
	hp_bar.max_value = h.max_hp
	hp_bar.value = h.hp
	hp_label.text = "%d / %d%s" % [int(ceil(h.hp)), int(h.max_hp), "  +%d barreira" % int(ceil(b.barrier)) if b.barrier > 0.0 else ""]
	xp_bar.max_value = h.xp_need
	xp_bar.value = h.xp
	info_label.text = "Moedas %d   Abates %d   CA %d  CAM %d" % [int(h.gold), b.stats.kills, h.ca(), h.cam()]
	active_label.text = b.active_status()
	active_label.modulate = Color(1.0, 0.9, 0.5) if b.active_cd <= 0.0 else Color(0.65, 0.65, 0.65)
	var ability: Dictionary = Data.table("abilities").get(h.id, {})
	var ability_id := String(ability.get("id", ""))
	if ability_id != _active_icon_id:
		_active_icon_id = ability_id
		var ability_path := "res://assets/icons/abilities/%s.png" % ability_id
		active_icon.texture = load(ability_path) if ResourceLoader.exists(ability_path) else null
	var stage_icons := {
		"dagruve": "dagruve_rituals", "shedaklah": "shedaklah_puddles", "molor": "molor_bubbles",
		"durao": "durao_current", "feng_tu": "feng_tu_strikes", "shendilavri": "shendilavri_illusions",
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
	stage_label.text = "%s%s" % [b.stage.name, "  (Mira: %s)" % ("AUTO" if b.aim == Battle.Aim.AUTO else "MOUSE")]
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
		if not it.used and it.kind in ["altar", "ritual", "portal"] and it.pos.distance_to(h.pos) <= 1.6:
			pr = "[E] " + {"altar": "rezar no altar", "ritual": "iniciar o ritual", "portal": "descer pelo portal"}[it.kind]
	if pr == "" and (b.stage_cleared or b.final_victory):
		pr = "[X] Extrair ×%.2f" % b.reward_multiplier()
		if b.stage.get("next", "") != "":
			pr += "   [E] Descer ×%.2f" % b.next_reward_multiplier()
	prompt_label.text = pr

func show_offer(b: Battle) -> void:
	for c in offer_box.get_children():
		c.queue_free()
	lv_title.text = ("Nível %d — escolha (1-%d)" % [b.hero.level, b.offer.size()]) if b.offer_kind == "levelup" else "Altar — escolha uma bênção (e sua maldição)"
	for i in b.offer.size():
		var o: Dictionary = b.offer[i]
		var btn := Button.new()
		var role_names := {"synergy": "SINERGIA", "defense": "DEFESA", "direction": "NOVA DIREÇÃO"}
		var role := String(role_names.get(o.get("role", ""), ""))
		btn.text = "%d.  %s%s\n      %s" % [i + 1, "[%s] " % role if role != "" else "", o.name, o.desc]
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.custom_minimum_size = Vector2(620, 62)
		var icon_path := ""
		match String(o.t):
			"weapon_new", "weapon_up": icon_path = "res://assets/icons/weapons/%s.png" % String(o.id)
			"evolve": icon_path = "res://assets/icons/weapons/%s.png" % String(o.into)
			"passive": icon_path = "res://assets/icons/passives/%s.png" % String(o.id)
			"boon": icon_path = "res://assets/icons/boons/%s.png" % String(o.id)
			"heal": icon_path = "res://assets/pickups/health_potion.png"
			"gold": icon_path = "res://assets/pickups/gold_coin.png"
		if ResourceLoader.exists(icon_path):
			btn.icon = load(icon_path)
			btn.expand_icon = true
			btn.icon_alignment = HORIZONTAL_ALIGNMENT_LEFT
		match String(o.t):
			"evolve": btn.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))
			"weapon_new": btn.add_theme_color_override("font_color", Color(0.6, 1.0, 0.6))
			"boon": btn.add_theme_color_override("font_color", Color(0.85, 0.6, 1.0))
		btn.pressed.connect(func(): offer_chosen.emit(i))
		offer_box.add_child(btn)
	reroll_btn.visible = b.offer_kind == "levelup"
	reroll_btn.text = "Rerrolar (R) — %d restantes" % b.rerolls
	reroll_btn.disabled = b.rerolls <= 0
	levelup_panel.visible = true

func hide_offer() -> void:
	levelup_panel.visible = false

func toast(text: String, color: Color = Color(1, 1, 1)) -> void:
	if toast_box.get_child_count() >= 4:
		toast_box.get_child(0).queue_free()
	var l := Label.new()
	l.text = text
	l.modulate = color
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.add_theme_color_override("font_outline_color", Color(0, 0, 0))
	l.add_theme_constant_override("outline_size", 5)
	toast_box.add_child(l)
	var tw := create_tween()
	tw.tween_interval(3.0)
	tw.tween_property(l, "modulate:a", 0.0, 0.6)
	tw.tween_callback(l.queue_free)

func show_pause(v: bool) -> void:
	pause_panel.visible = v
	if v:
		aim_btn.text = "Mira: %s (Tab)" % ("AUTO" if Game.aim_mode() == Battle.Aim.AUTO else "MOUSE")
		vol_slider.value = float(Game.profile.data.settings.volume)

func show_result(res: Dictionary, summary: Dictionary) -> void:
	hide_offer()
	pause_panel.visible = false
	result_title.text = "Vitória!" if res.won else "Você caiu..."
	var background_path := "res://assets/ui/backgrounds/victory_background.png" if res.won else "res://assets/ui/backgrounds/defeat_background.png"
	result_background.texture = load(background_path) if ResourceLoader.exists(background_path) else null
	var t := int(res.time)
	var txt := "%s · %s\nTempo %02d:%02d · Nível %d · Abates %d · Chefes %d\nModo: %s · Profundidade %d · Multiplicador ×%.2f\n\n+%d moedas%s (total %d)" % [
		Data.table("heroes")[res.hero].name, Data.table("stages")[res.stage].name, t / 60, t % 60, res.level, res.kills, res.bosses,
		"extraído" if res.extracted else ("derrota" if res.dead else "final"), int(res.get("descent_depth", 0)), float(res.get("reward_mult", 1.0)),
		summary.earned, " (metade: derrota)" if summary.half else "", summary.coins]
	var names: Array = []
	for id in summary.achievements:
		for a in Data.table("achievements").achievements:
			if a.id == id:
				names.append("★ %s — %s" % [a.name, a.reward.get("text", "")])
	if not names.is_empty():
		txt += "\n\nConquistas:\n" + "\n".join(names)
	result_text.text = txt
	result_panel.visible = true
