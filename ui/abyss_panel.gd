extends ScrollContainer
## SPEC-141 e SPEC-143 (MEC-040): aba "Marcas" do Quartel. Nove marcas, cada uma liberada pela sua conquista; a escolha
## fica no perfil e só vale para as marcas liberadas. Mouse, controle (foco) e toque usam os mesmos botões.

signal changed

var _box: VBoxContainer
var _summary: Label
var _total: Label
var _record: Label
var _rows: Dictionary = {}   # id -> {"level": Label, "minus": Button, "plus": Button, "lock": Label}
var _reset: Button

func _ready() -> void:
	name = "Marcas"
	_box = VBoxContainer.new()
	_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_box.add_theme_constant_override("separation", 10)
	add_child(_box)
	var title := Label.new()
	title.text = "Marcas do Abismo"
	title.add_theme_font_size_override("font_size", 24)
	title.add_theme_color_override("font_color", Color(0.9, 0.75, 0.42))
	_box.add_child(title)
	var intro := Label.new()
	intro.text = "Dificuldade opcional. Cada marca endurece a run inteira e rende mais moedas (+10% por nível somado). Cada marca é liberada por uma conquista."
	intro.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_box.add_child(intro)
	_summary = Label.new()
	_summary.add_theme_color_override("font_color", Color(0.75, 0.7, 0.8))
	_box.add_child(_summary)
	for id in AbyssMarks.ids():
		_add_row(String(id))
	_total = Label.new()
	_total.add_theme_font_size_override("font_size", 20)
	_box.add_child(_total)
	_record = Label.new()
	_record.add_theme_color_override("font_color", Color(0.75, 0.7, 0.8))
	_box.add_child(_record)
	_reset = Button.new()
	_reset.text = "Zerar marcas"
	_reset.custom_minimum_size = Vector2(220, 44)
	_reset.pressed.connect(_clear)
	_box.add_child(_reset)
	refresh()
	follow_focus = true
	visibility_changed.connect(_on_shown)

func _add_row(id: String) -> void:
	var def: Dictionary = AbyssMarks.def(id)
	var row := VBoxContainer.new()
	row.add_theme_constant_override("separation", 2)
	_box.add_child(row)
	var line := HBoxContainer.new()
	line.add_theme_constant_override("separation", 10)
	row.add_child(line)
	var label := Label.new()
	label.text = String(def.name)
	label.custom_minimum_size.x = 190
	label.add_theme_font_size_override("font_size", 20)
	line.add_child(label)
	var minus := Button.new()
	minus.text = "−"
	minus.custom_minimum_size = Vector2(56, 44)
	minus.tooltip_text = "Diminuir %s" % def.name
	minus.pressed.connect(func(): _step(id, -1))
	line.add_child(minus)
	var level := Label.new()
	level.custom_minimum_size.x = 72
	level.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	level.add_theme_font_size_override("font_size", 20)
	line.add_child(level)
	var plus := Button.new()
	plus.text = "+"
	plus.custom_minimum_size = Vector2(56, 44)
	plus.tooltip_text = "Aumentar %s" % def.name
	plus.pressed.connect(func(): _step(id, 1))
	line.add_child(plus)
	var desc := Label.new()
	desc.text = String(def.desc)
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc.add_theme_font_size_override("font_size", 14)
	desc.add_theme_color_override("font_color", Color(0.7, 0.68, 0.72))
	row.add_child(desc)
	var lock := Label.new()
	lock.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	lock.add_theme_font_size_override("font_size", 14)
	lock.add_theme_color_override("font_color", Color(0.88, 0.63, 0.25))
	row.add_child(lock)
	_rows[id] = {"level": level, "minus": minus, "plus": plus, "lock": lock}

static func achievement_def(id: String) -> Dictionary:
	for a in Data.table("achievements").achievements:
		if String(a.id) == id:
			return a
	return {}

func is_unlocked(id: String) -> bool:
	return Game.profile.abyss_mark_unlocked(id)

func _step(id: String, delta: int) -> void:
	if not is_unlocked(id):
		return
	var marks := Game.abyss_marks()
	marks[id] = clampi(AbyssMarks.level_of(marks, id) + delta, 0, AbyssMarks.max_level(id))
	Sfx.play("click")
	Game.set_abyss_marks(marks)
	refresh()
	changed.emit()

func _clear() -> void:
	if Game.abyss_marks().is_empty():
		return
	Sfx.play("click")
	Game.set_abyss_marks({})
	refresh()
	changed.emit()

func refresh() -> void:
	if _rows.is_empty():
		return
	var marks := Game.run_abyss_marks()
	var open := Game.profile.abyss_unlocked_ids().size()
	var stage: Dictionary = Data.table("stages").get(Game.run_stage, {})
	var hero: Dictionary = Data.table("heroes").get(Game.run_hero, {})
	_summary.text = "Marcas liberadas: %d de %d · Fase inicial: %s · Herói: %s" % [open, AbyssMarks.ids().size(), stage.get("name", "?"), hero.get("name", "?")]
	for id in AbyssMarks.ids():
		var row: Dictionary = _rows[id]
		var unlocked := is_unlocked(String(id))
		var lv := AbyssMarks.level_of(marks, String(id))
		var top := AbyssMarks.max_level(String(id))
		row.level.text = "Nv %d/%d" % [lv, top]
		row.minus.disabled = not unlocked or lv <= 0
		row.plus.disabled = not unlocked or lv >= top
		row.lock.visible = not unlocked
		if not unlocked:
			var ach := achievement_def(AbyssMarks.requires(String(id)))
			row.lock.text = "Bloqueada. Conquista: %s. %s" % [ach.get("name", "?"), ach.get("desc", "")]
	_reset.disabled = Game.abyss_marks().is_empty()
	_total.text = "Nível das Marcas: %d / %d  ·  moedas +%d%%" % [AbyssMarks.total_level(marks), AbyssMarks.max_total(), int(round(AbyssMarks.reward_bonus(marks) * 100.0))]
	var best := Game.profile.abyss_best_for(Game.run_hero, Game.run_stage)
	_record.text = "Recorde com este herói nesta fase: %s" % (("nível %d" % best) if best > 0 else "nenhum ainda")
	if Game.touch_controls_enabled():
		TouchUI.adapt_sizes(self)

## Linha curta para a aba Jogar.
static func summary_line(_stage_id: String = "") -> String:
	var open := Game.profile.abyss_unlocked_ids().size()
	if open <= 0:
		return "Marcas do Abismo: nenhuma liberada ainda (conquistas, aba Marcas)."
	var marks := Game.run_abyss_marks()
	var lv := AbyssMarks.total_level(marks)
	if lv <= 0:
		return "Marcas do Abismo: %d liberadas, desligadas (aba Marcas)." % open
	return "Marcas do Abismo: nível %d, moedas +%d%% (aba Marcas)." % [lv, int(round(AbyssMarks.reward_bonus(marks) * 100.0))]

## Ao abrir a aba o layout ainda não assentou e o foco automático rola para o fim; depois de dois quadros a aba volta ao topo; a rolagem seguinte acompanha o foco.
func _on_shown() -> void:
	if not is_visible_in_tree():
		return
	scroll_vertical = 0
	await get_tree().process_frame
	await get_tree().process_frame
	if not is_inside_tree() or not is_visible_in_tree():
		return
	scroll_vertical = 0
