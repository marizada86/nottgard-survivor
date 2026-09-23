extends Control
## Quartel: jogar, melhorias, conquistas, códex e opções. A estrutura vem de menu.tscn (nós únicos %).

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
@onready var full_opt: CheckBox = %FullOpt
@onready var diff_opt: OptionButton = %DiffOpt
@onready var guide_btn: Button = %GuideBtn
@onready var reset_btn: Button = %ResetBtn
@onready var version_label: Label = %VersionLabel

var heroes: Array = []
var stages: Array = []
var codex_ids: Array = []
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
	version_label.text = "%s v%s%s" % [Version.GAME_NAME, Version.VERSION, "  ·  build de %s" % Version.profile_slug() if Version.evidence_enabled() else ""]
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
	full_opt.toggled.connect(func(_on): Game.toggle_fullscreen())
	for i in 4:
		diff_opt.add_item("Maldição %d  (inimigos +%d%%, moedas +%d%%)" % [i, i * 25, i * 25])
	diff_opt.item_selected.connect(func(i):
		Game.profile.data.settings.difficulty = i
		Game.save())
	guide_btn.pressed.connect(func(): Playtest.open_guide(false))
	reset_btn.pressed.connect(_on_reset)
	_refresh_all()

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
	aim_opt.select(1 if Game.aim_mode() == Battle.Aim.MOUSE else 0)
	vol_opt.value = float(p.data.settings.volume)
	music_vol_opt.value = float(p.data.settings.music_volume)
	sfx_vol_opt.value = float(p.data.settings.sfx_volume)
	ambience_vol_opt.value = float(p.data.settings.ambience_volume)
	full_opt.set_pressed_no_signal(bool(p.data.settings.fullscreen))
	diff_opt.select(int(p.data.settings.difficulty))


func _save_audio_setting(key: String, value: float) -> void:
	Game.profile.data.settings[key] = value
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
	var txt := "[b]%s[/b] — %s\nFOR %d · INT %d · CON %d · CAR %d   |   PV %d · CA %d · CAM %d\n\n[b]Arma inicial:[/b] %s — %s\n[b]Passiva:[/b] %s — %s" % [
		d.name, d.title, a.forca, a.inteligencia, a.constituicao, a.carisma, d.base_hp, 10 + int(d.armor.ca), 10 + int(d.armor.cam), w.name, w.desc, d.passive.name, d.passive.desc]
	if not Game.profile.hero_unlocked(id):
		txt += "\n\n[color=#e0a040]Bloqueado. Conquista: %s[/color]" % _ach_name(String(d.unlock).substr(4))
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
	var names := {"puddles": "poças de slime que retardam e ferem", "current": "corrente de almas que arrasta você", "strikes": "raios telegrafados caem do céu", "illusions": "alguns inimigos são ilusões (1 golpe)"}
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
		btn.text = "Comprar (%d)" % cost if cost >= 0 else "Máximo"
		btn.disabled = cost < 0 or cost > p.coins()
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
		codex_text.text = "[b]%s[/b]\nPV %d · CA %d · CAM %d · dano %s · velocidade %.1f\n\n%s\nResistências: %s" % [d.name, d.hp, d.ca, d.cam, d.atk, float(d.speed), d.get("note", ""), str(d.get("resist", "nenhuma"))]
	elif cat == "weapons":
		var d: Dictionary = Data.table("weapons")[id]
		codex_text.text = "[b]%s[/b]\nOrigem: %s\nTipo: %s · dano %s (%s, atributo %s) · recarga %.1fs\n\n%s" % [d.name, d.src, d.kind, d.dice if d.dice != "" else "—", d.dtype, d.attr, float(d.cd), d.desc]
	else:
		for u in Data.table("items").uniques:
			if u.id == id:
				codex_text.text = "[b]%s[/b] [color=#ff8c26](único · %s)[/color]\n%s\n\n%s" % [u.name, u.slot, Items.mods_text(u.mods), u.get("note", "")]

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
