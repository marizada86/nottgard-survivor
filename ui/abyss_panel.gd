extends ScrollContainer
## SPEC-141 (MEC-040): aba "Marcas" do Quartel. Cinco marcas de 0 a 3 níveis; a escolha fica no perfil e
## só vale se a fase inicial já foi vencida. Mouse, controle (foco) e toque usam os mesmos botões.

signal changed

var _box: VBoxContainer
var _summary: Label
var _lock: Label
var _total: Label
var _record: Label
var _rows: Dictionary = {}   # id -> {"level": Label, "minus": Button, "plus": Button}
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
	intro.text = "Dificuldade opcional. Cada marca endurece a run inteira e rende mais moedas (+10% por nível somado). Liberada depois de vencer a fase inicial."
	intro.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_box.add_child(intro)
	_summary = Label.new()
	_summary.add_theme_color_override("font_color", Color(0.75, 0.7, 0.8))
	_box.add_child(_summary)
	_lock = Label.new()
	_lock.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_lock.add_theme_color_override("font_color", Color(0.88, 0.63, 0.25))
	_box.add_child(_lock)
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

func _add_row(id: String) -> void:
	var def: Dictionary = AbyssMarks.cfg().marks[id]
	var row := VBoxContainer.new()
	row.add_theme_constant_override("separation", 2)
	_box.add_child(row)
	var line := HBoxContainer.new()
	line.add_theme_constant_override("separation", 10)
	row.add_child(line)
	var label := Label.new()
	label.text = String(def.name)
	label.custom_minimum_size.x = 150
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
	_rows[id] = {"level": level, "minus": minus, "plus": plus}

func is_unlocked() -> bool:
	return Game.profile.abyss_unlocked(Game.run_stage)

func _step(id: String, delta: int) -> void:
	if not is_unlocked():
		return
	var marks := Game.abyss_marks()
	marks[id] = clampi(AbyssMarks.level_of(marks, id) + delta, 0, AbyssMarks.max_level())
	Sfx.play("click")
	Game.set_abyss_marks(marks)
	refresh()
	changed.emit()

func _clear() -> void:
	if not is_unlocked() or Game.abyss_marks().is_empty():
		return
	Sfx.play("click")
	Game.set_abyss_marks({})
	refresh()
	changed.emit()

func refresh() -> void:
	if _rows.is_empty():
		return
	var unlocked := is_unlocked()
	var stage: Dictionary = Data.table("stages").get(Game.run_stage, {})
	var hero: Dictionary = Data.table("heroes").get(Game.run_hero, {})
	_summary.text = "Fase inicial: %s · Herói: %s" % [stage.get("name", "?"), hero.get("name", "?")]
	_lock.visible = not unlocked
	_lock.text = "Bloqueada: vença %s uma vez para usar as marcas nesta fase." % stage.get("name", "a fase")
	var marks := Game.abyss_marks() if unlocked else {}
	for id in AbyssMarks.ids():
		var row: Dictionary = _rows[id]
		var lv := AbyssMarks.level_of(marks, String(id))
		row.level.text = "Nv %d/%d" % [lv, AbyssMarks.max_level()]
		row.minus.disabled = not unlocked or lv <= 0
		row.plus.disabled = not unlocked or lv >= AbyssMarks.max_level()
	_reset.disabled = not unlocked or marks.is_empty()
	_total.text = "Nível das Marcas: %d / %d  ·  moedas +%d%%" % [AbyssMarks.total_level(marks), AbyssMarks.max_total(), int(round(AbyssMarks.reward_bonus(marks) * 100.0))]
	var best := Game.profile.abyss_best_for(Game.run_hero, Game.run_stage)
	_record.text = "Recorde com este herói nesta fase: %s" % (("nível %d" % best) if best > 0 else "nenhum ainda")
	if Game.touch_controls_enabled():
		TouchUI.adapt_sizes(self)

## Linha curta para a aba Jogar.
static func summary_line(stage_id: String) -> String:
	if not Game.profile.abyss_unlocked(stage_id):
		return "Marcas do Abismo: vença esta fase para liberar."
	var marks := Game.abyss_marks()
	var lv := AbyssMarks.total_level(marks)
	if lv <= 0:
		return "Marcas do Abismo: desligadas (aba Marcas)."
	return "Marcas do Abismo: nível %d, moedas +%d%% (aba Marcas)." % [lv, int(round(AbyssMarks.reward_bonus(marks) * 100.0))]
