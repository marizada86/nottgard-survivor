extends Control
## Quartel: jogar, melhorias, conquistas, códex e opções. A estrutura vem de menu.tscn (nós únicos %).

const HQ_SCREEN := preload("res://ui/hq_screen.tscn")
const HQCatalog := preload("res://core/hq_catalog.gd")

@onready var coins_label: Label = %CoinsLabel
@onready var hero_list: ItemList = %HeroList
@onready var portrait: TextureRect = %Portrait
@onready var hero_info: RichTextLabel = %HeroInfo
@onready var stage_list: ItemList = %StageList
@onready var stage_info: RichTextLabel = %StageInfo
@onready var play_btn: Button = %PlayBtn
@onready var upgrade_box: VBoxContainer = %UpgradeBox
@onready var ach_box: VBoxContainer = %AchBox
@onready var codex_cat: OptionButton = %CodexCat
@onready var codex_list: ItemList = %CodexList
@onready var codex_text: RichTextLabel = %CodexText
@onready var aim_opt: OptionButton = %AimOpt
@onready var vol_opt: HSlider = %VolOpt
@onready var music_vol_opt: HSlider = %MusicVolOpt
@onready var sfx_vol_opt: HSlider = %SfxVolOpt
@onready var ambience_vol_opt: HSlider = %AmbienceVolOpt
@onready var music_mute_opt: CheckBox = %MusicMuteOpt
@onready var sfx_mute_opt: CheckBox = %SfxMuteOpt
@onready var ambience_mute_opt: CheckBox = %AmbienceMuteOpt
@onready var reduced_impact_opt: CheckBox = %ReducedImpactOpt
@onready var barks_opt: CheckBox = %BarksOpt
@onready var display_mode_opt: OptionButton = %DisplayModeOpt
@onready var resolution_opt: OptionButton = %ResolutionOpt
@onready var diff_opt: OptionButton = %DiffOpt
@onready var guide_btn: Button = %GuideBtn
@onready var reset_btn: Button = %ResetBtn
@onready var version_label: Label = %VersionLabel
@onready var hq_list: ItemList = %HqList
@onready var hq_info: RichTextLabel = %HqInfo
@onready var hq_play_btn: Button = %HqPlayBtn

var heroes: Array = []
var stages: Array = []
var codex_ids: Array = []
var hq_ids: Array[String] = []
var _reset_armed := false

func _ready() -> void:
	Game.screen_name = "menu"
	if Game.qa_sandbox:
		%Tabs.current_tab = Game.qa_menu_tab
	stage_list.fixed_icon_size = Vector2i(96, 54)
	codex_list.fixed_icon_size = Vector2i(48, 48)
	Sfx.stop_ambience()
	Sfx.start_music("menu")
	RenderingServer.set_default_clear_color(Color(0.06, 0.05, 0.08))
	get_tree().paused = false
	var p: Profile = Game.profile
	heroes = p.heroes_sorted()
	stages = p.stages_sorted()
	version_label.text = "%s v%s%s" % [Version.GAME_NAME, Version.VERSION, "  ·  build de %s (%s)" % [Version.profile_slug(), Version.build_id()] if Version.evidence_enabled() else ""]
	hero_list.item_selected.connect(func(_i): _refresh_hero())
	stage_list.item_selected.connect(func(_i): _refresh_stage())
	play_btn.pressed.connect(_play)
	codex_cat.item_selected.connect(func(_i): _fill_codex())
	codex_list.item_selected.connect(_show_codex)
	for t in ["Inimigos", "Armas", "Itens"]:
		codex_cat.add_item(t)
	aim_opt.add_item("Automática (inimigo mais próximo)")
	aim_opt.add_item("Mouse (mira no cursor)")
	aim_opt.item_selected.connect(func(i):
		Game.set_aim(Battle.Aim.MOUSE if i == 1 else Battle.Aim.AUTO))
	vol_opt.value_changed.connect(func(v):
		Game.profile.data.settings.volume = v
		Game.apply_settings()
		Game.save())
	music_vol_opt.value_changed.connect(func(v): _save_audio_setting("music_volume", v))
	sfx_vol_opt.value_changed.connect(func(v): _save_audio_setting("sfx_volume", v))
	ambience_vol_opt.value_changed.connect(func(v): _save_audio_setting("ambience_volume", v))
	music_mute_opt.toggled.connect(func(muted): _save_audio_mute("music", muted))
	sfx_mute_opt.toggled.connect(func(muted): _save_audio_mute("sfx", muted))
	ambience_mute_opt.toggled.connect(func(muted): _save_audio_mute("ambience", muted))
	reduced_impact_opt.toggled.connect(func(on): _save_reduced_impact(on))
	barks_opt.toggled.connect(func(on): _save_barks(on))
	for label in ["Janela", "Sem borda", "Tela cheia (F11)"]:
		display_mode_opt.add_item(label)
	display_mode_opt.item_selected.connect(func(index):
		Game.set_window_mode(String(Game.WINDOW_MODES[index])))
	for resolution in Game.SUPPORTED_RESOLUTIONS:
		resolution_opt.add_item(resolution)
	resolution_opt.item_selected.connect(func(index):
		Game.set_resolution(resolution_opt.get_item_text(index)))
	for i in 4:
		diff_opt.add_item("Maldição %d  (inimigos +%d%%, moedas +%d%%)" % [i, i * 25, i * 25])
	diff_opt.item_selected.connect(func(i):
		Game.profile.data.settings.difficulty = i
		Game.save())
	guide_btn.pressed.connect(func(): Playtest.open_guide(false))
	reset_btn.pressed.connect(_on_reset)
	hq_list.item_selected.connect(_refresh_hq_selection)
	hq_play_btn.pressed.connect(_open_selected_hq)
	_refresh_all()
	if Game.touch_controls_enabled():
		aim_opt.select(0)
		aim_opt.disabled = true
		display_mode_opt.disabled = true
		resolution_opt.disabled = true
		TouchUI.prepare(self)
		_layout_touch_menu()
		get_viewport().size_changed.connect(_layout_touch_menu)
	hero_list.call_deferred("grab_focus")
	var notice := Game.consume_save_notice()
	if notice != "":
		Playtest.toast(notice)

func _layout_touch_menu() -> void:
	var safe := Game.touch_safe_rect()
	%Tabs.offset_left = safe.position.x
	%Tabs.offset_right = safe.end.x - get_viewport_rect().size.x
	%Tabs.offset_top = safe.position.y + 88
	%Tabs.offset_bottom = safe.end.y - get_viewport_rect().size.y - 24
	%Tabs.add_theme_font_size_override("font_size", 20)
	%Tabs.add_theme_constant_override("side_margin", 12)
	var bar: TabBar = %Tabs.get_tab_bar()
	bar.add_theme_font_size_override("font_size", 20)
	for style_name in ["tab_selected", "tab_unselected", "tab_hovered", "tab_disabled"]:
		var style: StyleBox = bar.get_theme_stylebox(style_name).duplicate()
		style.content_margin_top = 14
		style.content_margin_bottom = 14
		bar.add_theme_stylebox_override(style_name, style)
	$Title.position = safe.position
	$Title.add_theme_font_size_override("font_size", 32)
	$Subtitle.position = safe.position + Vector2(4, 48)
	$Tabs/Jogar/Left.custom_minimum_size.x = 240
	$Tabs/Jogar/Mid.custom_minimum_size.x = 420
	portrait.custom_minimum_size = Vector2(360, 180)

func _refresh_all() -> void:
	var p: Profile = Game.profile
	coins_label.text = "Moedas: %d" % p.coins()
	var sel_h := hero_list.get_selected_items()
	var sel_s := stage_list.get_selected_items()
	hero_list.clear()
	for id in heroes:
		var d: Dictionary = Data.table("heroes")[id]
		hero_list.add_item(("%s" if p.hero_unlocked(id) else "🔒 %s") % d.name)
	stage_list.clear()
	for id in stages:
		var d: Dictionary = Data.table("stages")[id]
		var thumb_path := "res://assets/stages/%s_thumb.png" % id
		var thumb: Texture2D = load(thumb_path) if ResourceLoader.exists(thumb_path) else null
		stage_list.add_item(("%d. %s" if p.stage_unlocked(id) else "🔒 %d. %s") % [int(d.order) + 1, d.name], thumb)
	hero_list.select(sel_h[0] if not sel_h.is_empty() else heroes.find(Game.run_hero))
	stage_list.select(sel_s[0] if not sel_s.is_empty() else stages.find(Game.run_stage))
	_refresh_hero()
	_refresh_stage()
	_fill_upgrades()
	_fill_achievements()
	_fill_codex()
	_fill_hqs()
	aim_opt.select(1 if Game.aim_mode() == Battle.Aim.MOUSE else 0)
	vol_opt.set_value_no_signal(float(p.data.settings.volume))
	music_vol_opt.set_value_no_signal(float(p.data.settings.music_volume))
	sfx_vol_opt.set_value_no_signal(float(p.data.settings.sfx_volume))
	ambience_vol_opt.set_value_no_signal(float(p.data.settings.ambience_volume))
	music_mute_opt.set_pressed_no_signal(bool(p.data.settings.get("music_muted", false)))
	sfx_mute_opt.set_pressed_no_signal(bool(p.data.settings.get("sfx_muted", false)))
	ambience_mute_opt.set_pressed_no_signal(bool(p.data.settings.get("ambience_muted", false)))
	reduced_impact_opt.set_pressed_no_signal(bool(p.data.settings.get("reduced_impact", false)))
	barks_opt.set_pressed_no_signal(bool(p.data.settings.get("barks", true)))
	display_mode_opt.select(Game.WINDOW_MODES.find(String(p.data.settings.get("window_mode", "windowed"))))
	resolution_opt.select(Game.SUPPORTED_RESOLUTIONS.find(String(p.data.settings.get("resolution", "1280x720"))))
	diff_opt.select(int(p.data.settings.difficulty))
	if Game.touch_controls_enabled():
		TouchUI.adapt_sizes(self)


func _save_audio_setting(key: String, value: float) -> void:
	Game.profile.data.settings[key] = value
	if value > 0.0001:
		var channel := key.trim_suffix("_volume")
		Game.profile.data.settings["%s_muted" % channel] = false
		match channel:
			"music": music_mute_opt.set_pressed_no_signal(false)
			"sfx": sfx_mute_opt.set_pressed_no_signal(false)
			"ambience": ambience_mute_opt.set_pressed_no_signal(false)
	Game.apply_settings()
	Game.save()


func _save_barks(on: bool) -> void:
	Game.profile.data.settings["barks"] = on
	Game.save()

func _save_reduced_impact(on: bool) -> void:
	Game.profile.data.settings["reduced_impact"] = on
	Game.save()

func _save_audio_mute(channel: String, muted: bool) -> void:
	Game.profile.data.settings["%s_muted" % channel] = muted
	Game.apply_settings()
	Game.save()

func _ach_name(id: String) -> String:
	for a in Data.table("achievements").achievements:
		if a.id == id:
			return "%s (%s)" % [a.name, a.desc]
	return id

func _refresh_hero() -> void:
	var sel := hero_list.get_selected_items()
	if sel.is_empty():
		return
	var id: String = heroes[sel[0]]
	var d: Dictionary = Data.table("heroes")[id]
	var pth := "res://assets/portraits/%s.png" % id
	portrait.texture = load(pth) if ResourceLoader.exists(pth) else null
	var w: Dictionary = Data.table("weapons")[d.weapon]
	var a: Dictionary = d.attrs
	var ca: int = 10 + int(d.armor.ca)
	var cam: int = 10 + int(d.armor.cam)
	var txt := "[b]%s[/b] — %s\nFOR %d · INT %d · CON %d · CAR %d   |   PV %d · CA %d (%d%%) · CAM %d (%d%%)\n\n[b]Arma inicial:[/b] %s — %s\n[b]Passiva:[/b] %s — %s" % [
		d.name, d.title, a.forca, a.inteligencia, a.constituicao, a.carisma, d.base_hp, ca, clampi((ca - 10) * 3, 0, 30), cam, clampi((cam - 10) * 3, 0, 30), w.name, w.desc, d.passive.name, d.passive.desc]
	if not Game.profile.hero_unlocked(id):
		txt += "\n\n[color=#e0a040]Bloqueado. Conquista: %s[/color]" % _ach_name(String(d.unlock).substr(4))
	else:
		var bio: String = String(Data.table("hero_bios").get(id, ""))
		if bio != "":
			if Game.profile.hero_bio_unlocked(id):
				txt += "\n\n[b]Biografia[/b]\n[i]%s[/i]" % bio
			else:
				txt += "\n\n[color=#888888]Biografia bloqueada: vença uma fase com este herói.[/color]"
	hero_info.text = txt
	Game.run_hero = id
	_update_play()

func _refresh_stage() -> void:
	var sel := stage_list.get_selected_items()
	if sel.is_empty():
		return
	var id: String = stages[sel[0]]
	var d: Dictionary = Data.table("stages")[id]
	var boss: Dictionary = Data.table("enemies")[d.boss]
	var bt: float = float(Game.profile.data.stats.best_time.get(id, 0.0))
	var txt := "[b]%s[/b]\n%s\n\nChefe: [b]%s[/b] em %d:%02d%s\nRegra do andar: %s\nMoedas x%.1f" % [
		d.name, d.sub, boss.name, int(d.duration) / 60, int(d.duration) % 60, " (infinito)" if d.get("endless", false) else "", _ambient_text(d.ambient), float(d.coin_mult)]
	if bt > 0.0:
		txt += "\nMelhor tempo: %d:%02d" % [int(bt) / 60, int(bt) % 60]
	if not Game.profile.stage_unlocked(id):
		txt += "\n\n[color=#e0a040]Bloqueada: derrote o chefe de %s.[/color]" % Data.table("stages")[d.unlock].name
	stage_info.text = txt
	Game.run_stage = id
	_update_play()

func _ambient_text(amb: Array) -> String:
	if amb.is_empty():
		return "nenhuma"
	var names := {"puddles": "poças de slime que retardam e ferem", "current": "corrente de almas que arrasta você", "styx_memory": "Rio Estige: risco de lucidez e Esquecimento", "strikes": "raios telegrafados caem do céu", "illusions": "alguns inimigos são ilusões (1 golpe)"}
	return ", ".join(amb.map(func(a): return names.get(a, a)))

func _update_play() -> void:
	var ok: bool = Game.profile.hero_unlocked(Game.run_hero) and Game.profile.stage_unlocked(Game.run_stage)
	play_btn.disabled = not ok
	play_btn.text = "JOGAR" if ok else "Bloqueado"

func _play() -> void:
	Sfx.play("click")
	Game.start_run(Game.run_hero, Game.run_stage)

# ------------------------------------------------------------------ melhorias

func _fill_upgrades() -> void:
	for c in upgrade_box.get_children():
		c.queue_free()
	var p: Profile = Game.profile
	for u in p.upgrade_defs():
		var row := HBoxContainer.new()
		var lab := Label.new()
		var lv := p.upgrade_level(u.id)
		lab.text = "%s   [%d/%d]\n%s" % [u.name, lv, u.costs.size(), u.desc]
		lab.custom_minimum_size = Vector2(620, 0)
		row.add_child(lab)
		var btn := Button.new()
		var cost := p.upgrade_cost(u.id)
		var locked_by := p.upgrade_locked_by(u.id)
		if locked_by != "":
			lab.text += "\nBloqueado. Conquista: %s" % _ach_name(locked_by)
			lab.modulate = Color(1, 1, 1, 0.7)
		btn.text = "Bloqueado" if locked_by != "" else ("Comprar (%d)" % cost if cost >= 0 else "Máximo")
		btn.disabled = locked_by != "" or cost < 0 or cost > p.coins()
		btn.custom_minimum_size = Vector2(160, 44)
		btn.pressed.connect(func():
			if p.buy_upgrade(u.id):
				Sfx.play("item")
				Game.save()
				_refresh_all())
		row.add_child(btn)
		upgrade_box.add_child(row)

func _fill_achievements() -> void:
	for c in ach_box.get_children():
		c.queue_free()
	var p: Profile = Game.profile
	for a in Data.table("achievements").achievements:
		var lab := Label.new()
		var done: bool = p.data.achievements.has(a.id)
		lab.text = "%s %s   [%s]\n     %s   →  %s" % ["★" if done else "☆", a.name, p.achievement_progress(a), a.desc, a.reward.get("text", "%d moedas" % int(a.reward.get("coins", 0)))]
		lab.modulate = Color(1, 0.9, 0.5) if done else Color(0.8, 0.8, 0.8)
		ach_box.add_child(lab)

# ------------------------------------------------------------------ códex

func _fill_codex() -> void:
	codex_list.clear()
	codex_ids.clear()
	codex_text.text = ""
	var cat: String = ["enemies", "weapons", "items"][codex_cat.selected if codex_cat.selected >= 0 else 0]
	var seen: Dictionary = Game.profile.data.codex[cat]
	var src: Dictionary
	if cat == "items":
		src = {}
		for u in Data.table("items").uniques:
			src[u.id] = u
	else:
		src = Data.table(cat)
	for id in src:
		codex_ids.append(id)
		var known: bool = seen.has(id)
		var icon_path := ""
		match cat:
			"enemies": icon_path = "res://assets/enemies/%s.png" % id
			"weapons": icon_path = "res://assets/icons/weapons/%s.png" % id
			"items": icon_path = "res://assets/icons/items/%s.png" % id
		var icon: Texture2D = load(icon_path) if known and ResourceLoader.exists(icon_path) else null
		codex_list.add_item(String(src[id].name) if known else "???", icon)
	_codex_cat_cache = cat

var _codex_cat_cache := "enemies"

func _show_codex(i: int) -> void:
	var id: String = codex_ids[i]
	var cat := _codex_cat_cache
	if not Game.profile.data.codex[cat].has(id):
		codex_text.text = "[color=#888888]Ainda não descoberto.[/color]"
		return
	if cat == "enemies":
		var d: Dictionary = Data.table("enemies")[id]
		codex_text.text = "[b]%s[/b]\nPV %d · CA %d (%d%%) · CAM %d (%d%%) · dano %s · velocidade %.1f\n\n%s\nResistências: %s" % [d.name, d.hp, d.ca, clampi((int(d.ca) - 10) * 3, 0, 30), d.cam, clampi((int(d.cam) - 10) * 3, 0, 30), d.atk, float(d.speed), d.get("note", ""), str(d.get("resist", "nenhuma"))]
	elif cat == "weapons":
		var d: Dictionary = Data.table("weapons")[id]
		codex_text.text = "[b]%s[/b]\nOrigem: %s\nTipo: %s · dano %s (%s, atributo %s) · recarga %.1fs\n\n%s" % [d.name, d.src, d.kind, d.dice if d.dice != "" else "—", d.dtype, d.attr, float(d.cd), d.desc]
	else:
		for u in Data.table("items").uniques:
			if u.id == id:
				codex_text.text = "[b]%s[/b] [color=#ff8c26](único · %s)[/color]\n%s\n\n%s" % [u.name, u.slot, Items.mods_text(u.mods), u.get("note", "")]

# ------------------------------------------------------------------ histórias

func _fill_hqs() -> void:
	hq_list.clear()
	hq_ids.clear()
	for hq_id in HQCatalog.unlocked_ids(Game.profile.data):
		var hq: Dictionary = Data.table("hqs")[hq_id]
		hq_ids.append(hq_id)
		hq_list.add_item(String(hq.get("title", hq_id)))
	# SPEC-117 H4: uma crônica por fase, liberada ao vencer a fase; as demais aparecem bloqueadas.
	var chronicles: Dictionary = Data.table("chronicles")
	var stage_ids: Array = Data.table("stages").keys()
	stage_ids.sort_custom(func(a, b): return int(Data.table("stages")[a].order) < int(Data.table("stages")[b].order))
	for stage_id in stage_ids:
		if not chronicles.has(stage_id):
			continue
		var unlocked: bool = Game.profile.data.cleared.has(stage_id)
		hq_ids.append("chr:%s" % stage_id)
		hq_list.add_item(("Crônica: %s" if unlocked else "🔒 Crônica: %s") % Data.table("stages")[stage_id].name)
	if hq_ids.is_empty():
		hq_info.text = "Nenhuma HQ desbloqueada."
		hq_play_btn.disabled = true
		return
	hq_list.select(0)
	_refresh_hq_selection(0)

func _refresh_hq_selection(index: int) -> void:
	if index < 0 or index >= hq_ids.size():
		hq_info.text = ""
		hq_play_btn.disabled = true
		return
	if String(hq_ids[index]).begins_with("chr:"):
		var stage_id := String(hq_ids[index]).substr(4)
		var entry: Dictionary = Data.table("chronicles")[stage_id]
		var stage_name: String = String(Data.table("stages")[stage_id].name)
		if Game.profile.data.cleared.has(stage_id):
			hq_info.text = "[b]%s — %s[/b]\n\n%s" % [stage_name, String(entry.titulo), String(entry.texto)]
		else:
			hq_info.text = "[b]Crônica: %s[/b]\n\nDerrote o chefe desta fase para ler." % stage_name
		hq_play_btn.disabled = true
		return
	var hq: Dictionary = Data.table("hqs")[hq_ids[index]]
	hq_info.text = "[b]%s[/b]\n4 quadros" % String(hq.get("title", ""))
	hq_play_btn.disabled = false

func _open_selected_hq() -> void:
	var selected := hq_list.get_selected_items()
	if selected.is_empty():
		return
	var hq_id: String = hq_ids[selected[0]]
	if hq_id.begins_with("chr:"):
		return
	var hq: Dictionary = Data.table("hqs").get(hq_id, {})
	if hq.is_empty():
		return
	var screen = HQ_SCREEN.instantiate()
	screen.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(screen)
	screen.call_deferred("start_hq", hq)
	while not bool(screen.get("is_closed")):
		await get_tree().process_frame
	var completed := bool(screen.get("completed"))
	screen.queue_free()
	if completed:
		var newly_earned: Array = Game.profile.mark_hq_seen(hq_id)
		Game.save()
		if not newly_earned.is_empty():
			_fill_achievements()

func _on_reset() -> void:
	if not _reset_armed:
		_reset_armed = true
		reset_btn.text = "Certeza? Clique de novo para apagar TUDO"
		return
	Game.profile = Profile.new({"name": Game.profile.data.name, "welcome_seen": true})
	Game.save()
	_reset_armed = false
	reset_btn.text = "Apagar progresso"
	_refresh_all()
