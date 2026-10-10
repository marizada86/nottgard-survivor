extends Control
## Quartel: jogar, melhorias, conquistas, códex e opções. A estrutura vem de menu.tscn (nós únicos %).

const HQ_SCREEN := preload("res://ui/hq_screen.tscn")
const HQCatalog := preload("res://core/hq_catalog.gd")
const AbyssPanel := preload("res://ui/abyss_panel.gd")

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
## SPEC-166 (MEC-003 lote 2): as opções vêm do OptionsPanel (mesmo componente da pausa); estes nomes são apelidos dos controles dele,
## para as verificações e o foco por controle seguirem valendo.
var options_panel: OptionsPanel
var aim_opt: OptionButton
var vol_opt: HSlider
var music_vol_opt: HSlider
var sfx_vol_opt: HSlider
var ambience_vol_opt: HSlider
var music_mute_opt: CheckBox
var sfx_mute_opt: CheckBox
var ambience_mute_opt: CheckBox
var reduced_impact_opt: CheckBox
var barks_opt: CheckBox
var display_mode_opt: OptionButton
var resolution_opt: OptionButton
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
var abyss_panel: ScrollContainer
var _reset_armed := false
var _hq_open := false

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
	if Version.evidence_enabled():
		var ranking := VBoxContainer.new()
		ranking.set_script(preload("res://ui/leaderboard.gd"))
		ranking.name = "Ranking"
		%Tabs.add_child(ranking)
	heroes = p.heroes_sorted()
	stages = p.stages_sorted()
	version_label.text = "%s v%s%s" % [Version.GAME_NAME, Version.VERSION, "  ·  build de %s (%s)" % [Version.profile_slug(), Version.build_id()] if Version.evidence_enabled() else ""]
	hero_list.item_selected.connect(func(_i): _refresh_hero())
	stage_list.item_selected.connect(func(_i): _refresh_stage())
	play_btn.pressed.connect(_play)
	options_panel = OptionsPanel.new()   # SPEC-166: no lugar dos controles que o menu montava um a um
	$Tabs/Opções/Content.add_child(options_panel)
	$Tabs/Opções/Content.move_child(options_panel, 0)
	aim_opt = options_panel.aim
	vol_opt = options_panel.master_vol
	music_vol_opt = options_panel.music_vol
	sfx_vol_opt = options_panel.sfx_vol
	ambience_vol_opt = options_panel.ambience_vol
	music_mute_opt = options_panel.music_mute
	sfx_mute_opt = options_panel.sfx_mute
	ambience_mute_opt = options_panel.ambience_mute
	reduced_impact_opt = options_panel.reduced_impact
	barks_opt = options_panel.barks
	display_mode_opt = options_panel.display_mode
	resolution_opt = options_panel.resolution
	codex_cat.item_selected.connect(func(_i): _fill_codex())
	codex_list.item_selected.connect(_show_codex)
	for cat in Catalog.CATEGORIES:
		codex_cat.add_item(String(Catalog.LABELS[cat]))   # SPEC-166: os mesmos nomes do catalogo da pausa
	for i in 4:
		diff_opt.add_item("Maldição %d  (inimigos +%d%%, moedas +%d%%)" % [i, i * 25, i * 25])
	diff_opt.item_selected.connect(func(i):
		Game.profile.data.settings.difficulty = i
		Game.save())
	guide_btn.pressed.connect(func(): Playtest.open_guide(false))
	reset_btn.pressed.connect(_on_reset)
	hq_list.item_selected.connect(_refresh_hq_selection)
	hq_play_btn.pressed.connect(_open_selected_hq)
	abyss_panel = AbyssPanel.new()
	abyss_panel.name = "Marcas"
	%Tabs.add_child(abyss_panel)
	%Tabs.move_child(abyss_panel, 1)
	abyss_panel.changed.connect(_refresh_stage)
	# SPEC-166: moldura e abas no padrão da ficha C (só estilo; estrutura e nomes inalterados)
	UiKit.style_tab_container(%Tabs)
	for list in [hero_list, stage_list, codex_list, hq_list]:
		UiKit.style_list(list)
	for text in [hero_info, stage_info, codex_text, hq_info]:
		UiKit.style_text(text)
	_refresh_all()
	var controller_options := preload("res://ui/controller_options.gd").new()
	$Tabs/Opções/Content.add_child(controller_options)
	$Tabs/Opções/Content.move_child(controller_options, $Tabs/Opções/Content.get_node("ActionsTitle").get_index())
	%Tabs.tab_changed.connect(func(_i):
		Game.controls.transition()
		_layout_play_action()
		_focus_tab.call_deferred())
	Game.controls.changed.connect(_update_play)
	get_viewport().size_changed.connect(_layout_play_action)
	_layout_play_action()
	for scroll in find_children("*", "ScrollContainer", true, false):
		scroll.follow_focus = true
	%Tabs.get_node("Conquistas").focus_mode = Control.FOCUS_ALL
	codex_text.focus_mode = Control.FOCUS_ALL
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

func _focus_tab() -> void:
	var current: Control = %Tabs.get_current_tab_control()
	var target := _first_focus(current)
	if target != null:
		target.grab_focus()

func _first_focus(node: Node) -> Control:
	if node is Control and node.is_visible_in_tree() and node.focus_mode != Control.FOCUS_NONE and not (node is BaseButton and node.disabled):
		return node
	for child in node.get_children():
		var target := _first_focus(child)
		if target != null:
			return target
	return null

func _layout_play_action() -> void:
	var playing_tab: bool = %Tabs.current_tab == 0
	play_btn.visible = playing_tab
	var safe: Rect2 = Game.touch_safe_rect() if Game.touch_controls_enabled() else get_viewport_rect().grow(-24)
	play_btn.offset_right = safe.end.x - get_viewport_rect().size.x
	play_btn.offset_left = play_btn.offset_right - 320
	play_btn.offset_bottom = safe.end.y - get_viewport_rect().size.y - 18
	play_btn.offset_top = play_btn.offset_bottom - 58
	%Tabs.offset_bottom = play_btn.offset_top - 34 if playing_tab else safe.end.y - get_viewport_rect().size.y - (24 if Game.touch_controls_enabled() else 10)

func _unhandled_input(event: InputEvent) -> void:
	if not Game.controls.accepts(event) or Game.controls.capture_action != "" or Playtest._guide_open or Playtest._note_open or _hq_open:
		return
	if event is InputEventJoypadButton and event.pressed and event.button_index in [JOY_BUTTON_LEFT_SHOULDER, JOY_BUTTON_RIGHT_SHOULDER]:
		%Tabs.current_tab = posmod(%Tabs.current_tab + (-1 if event.button_index == JOY_BUTTON_LEFT_SHOULDER else 1), %Tabs.get_tab_count())
		get_viewport().set_input_as_handled()

func _input(event: InputEvent) -> void:
	if not event is InputEventJoypadButton and not event is InputEventJoypadMotion:
		return
	if not event.is_pressed() or not Game.controls.accepts(event) or Playtest._guide_open or _hq_open or Game.controls.capture_action != "":
		return
	var owner := get_viewport().gui_get_focus_owner()
	if owner == stage_list and event.is_action_pressed("ui_accept"):
		Game.controls.transition()
		if not play_btn.disabled:
			play_btn.grab_focus()
		get_viewport().set_input_as_handled()
		return
	var right := event.is_action_pressed("ui_right")
	var left := event.is_action_pressed("ui_left")
	var target: Control
	if right or left:
		if owner == hero_list and right:
			target = stage_list
		elif owner == stage_list:
			target = play_btn if right else hero_list
		elif owner == play_btn and left:
			target = stage_list
		elif owner == codex_list:
			target = codex_text if right else codex_cat
		elif owner == codex_text and left:
			target = codex_list
		elif owner == codex_cat and right:
			target = codex_list
		elif owner == hq_list and right:
			target = hq_play_btn
		elif owner == hq_play_btn and left:
			target = hq_list
	if target != null and not (target is BaseButton and target.disabled):
		target.grab_focus()
		get_viewport().set_input_as_handled()
	elif owner is RichTextLabel or owner == %Tabs.get_node("Conquistas"):
		if event.is_action_pressed("ui_down") or event.is_action_pressed("ui_up"):
			var bar: VScrollBar = owner.get_v_scroll_bar()
			bar.value += 64 if event.is_action_pressed("ui_down") else -64
			get_viewport().set_input_as_handled()

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
	_layout_play_action()

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
	options_panel.refresh()   # SPEC-166: aim, volumes, mudos, falas, impacto, modo de tela e resolucao
	diff_opt.select(int(p.data.settings.difficulty))
	if Game.touch_controls_enabled():
		TouchUI.adapt_sizes(self)


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
	if abyss_panel != null:
		abyss_panel.refresh()
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
	txt += "\n\n" + AbyssPanel.summary_line(id)
	stage_info.text = txt
	Game.run_stage = id
	if abyss_panel != null:
		abyss_panel.refresh()
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
	play_btn.icon = Game.controls.glyph("ui_accept")
	play_btn.tooltip_text = "%s para iniciar a tentativa" % Game.controls.prompt("ui_accept", "Enter ou clique")

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

## SPEC-166: o códex do Quartel usa o mesmo Catalog do menu de pausa (entradas, bloqueados e detalhe).
func _fill_codex() -> void:
	codex_list.clear()
	codex_ids.clear()
	codex_text.text = ""
	var cat: String = Catalog.CATEGORIES[clampi(codex_cat.selected, 0, Catalog.CATEGORIES.size() - 1)]
	for e in Catalog.entries(cat, Game.profile.data.codex):
		codex_ids.append(e.id)
		var icon: Texture2D = load(String(e.icon)) if bool(e.known) and ResourceLoader.exists(String(e.icon)) else null
		codex_list.add_item(String(e.name), icon)
	_codex_cat_cache = cat

var _codex_cat_cache := "enemies"

func _show_codex(i: int) -> void:
	var id: String = codex_ids[i]
	var cat := _codex_cat_cache
	codex_text.text = Catalog.detail(cat, id, Game.profile.data.codex[cat].has(id))

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
	# SPEC-152: Ecos de Nottgard por fase da fatia piloto (3/4 achados, relíquia pega)
	var secrets: Dictionary = Data.table("secrets")
	for stage_id in stage_ids:
		if not secrets.has(stage_id):
			continue
		hq_ids.append("eco:%s" % stage_id)
		hq_list.add_item("✦ Ecos: %s  (%d/%d%s)" % [Data.table("stages")[stage_id].name, Game.profile.ecos_found(stage_id), Array(secrets[stage_id].ecos).size(), " · Relíquia ✓" if Game.profile.data.relics.has(stage_id) else ""])
	if hq_ids.is_empty():
		hq_info.text = "Nenhuma HQ desbloqueada."
		hq_play_btn.disabled = true
		return
	hq_list.select(0)
	_refresh_hq_selection(0)

## SPEC-152: texto da entrada "Ecos" de uma fase no Diário: achados com texto e fonte, os demais escondidos.
static func eco_diary_text(stage_id: String) -> String:
	var spec: Dictionary = Data.table("secrets").get(stage_id, {})
	var stage_name := String(Data.table("stages").get(stage_id, {}).get("name", stage_id))
	var lines: Array = ["[b]Ecos de Nottgard — %s[/b]" % stage_name]
	var found: Dictionary = Dictionary(Game.profile.data.ecos.get(stage_id, {}))
	var total := Array(spec.get("ecos", [])).size()
	lines.append("%d de %d Ecos achados · Relíquia: %s
" % [found.size(), total, "pega" if Game.profile.data.relics.has(stage_id) else "ainda trancada ou não pega"])
	for eco in spec.get("ecos", []):
		if found.has(String(eco.id)):
			lines.append("✦ %s
[color=#9a90b0]Fonte: %s[/color]
" % [String(eco.texto), String(eco.get("fonte_vault", ""))])
		else:
			lines.append("[color=#777777]🔒 Eco escondido[/color]
")
	return "
".join(lines)

func _refresh_hq_selection(index: int) -> void:
	if index < 0 or index >= hq_ids.size():
		hq_info.text = ""
		hq_play_btn.disabled = true
		return
	if String(hq_ids[index]).begins_with("eco:"):
		hq_info.text = eco_diary_text(String(hq_ids[index]).substr(4))
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
	if hq_id.begins_with("chr:") or hq_id.begins_with("eco:"):
		return
	var hq: Dictionary = Data.table("hqs").get(hq_id, {})
	if hq.is_empty():
		return
	var screen = HQ_SCREEN.instantiate()
	_hq_open = true
	screen.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(screen)
	screen.call_deferred("start_hq", hq)
	while not bool(screen.get("is_closed")):
		await get_tree().process_frame
	var completed := bool(screen.get("completed"))
	_hq_open = false
	hq_play_btn.call_deferred("grab_focus")
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
