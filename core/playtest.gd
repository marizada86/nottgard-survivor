extends CanvasLayer
## Autoload "Playtest": kit de evidência para playtesters (mesmo modelo do nottcard-ai).
##  F5 = bloco de notas (fechar guarda a nota + o print do instante em que abriu)
##  F6 = print da tela (não pausa)   F7 = gera UM .zip ao lado do executável   F1 = guia
## O rascunho é gravado a cada item em user://evidencias/rascunho e sobrevive a fechar o jogo.

const MAX_PRINTS := 20
const MAX_BYTES := 8 * 1024 * 1024
const NOTE_MAX := 1000
const DRAFT_DIR := "user://evidencias/rascunho"
const FALLBACK_DIR := "user://evidencias"
const GUIDE_MAX_SIZE := Vector2(820, 560)
const GUIDE_MARGIN := 24.0

var items: Array = []          # {kind, time, ctx, text, png}
var _note_open := false
var _guide_open := false
var _pending_png := PackedByteArray()
var _pending_ctx := {}
var _paused_before := false

var _toast: Label
var _pad: PanelContainer
var _edit: TextEdit
var _count: Label
var _summary: Label
var _guide_modal: Control
var _guide: PanelContainer
var _guide_content: VBoxContainer
var _name_edit: LineEdit
var _guide_start: Button
var _guide_error: Label
var _clear_armed := false
var _clear_btn: Button

func _ready() -> void:
	layer = 100
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_ui()
	get_viewport().size_changed.connect(_layout_guide)
	call_deferred("_layout_guide")
	_load_draft()
	if not Version.PLAYTEST_BUILD:
		return
	if items.size() > 0:
		toast("Você tem %d itens guardados (F7 gera o .zip)" % items.size())
	await get_tree().process_frame
	if Game.profile.data.name == "" or not bool(Game.profile.data.welcome_seen):
		open_guide(true)

# ------------------------------------------------------------------ UI

func _build_ui() -> void:
	_toast = Label.new()
	_toast.set_anchors_preset(Control.PRESET_CENTER_TOP)
	_toast.position = Vector2(0, 8)
	_toast.custom_minimum_size = Vector2(700, 0)
	_toast.position.x = -350
	_toast.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_toast.add_theme_color_override("font_color", Color(1, 0.95, 0.6))
	_toast.add_theme_color_override("font_outline_color", Color(0, 0, 0))
	_toast.add_theme_constant_override("outline_size", 6)
	_toast.modulate.a = 0.0
	add_child(_toast)

	_pad = PanelContainer.new()
	_pad.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	_pad.custom_minimum_size = Vector2(760, 470)
	_pad.visible = false
	add_child(_pad)
	var v := VBoxContainer.new()
	_pad.add_child(v)
	var t := Label.new()
	t.text = "Bloco de notas (F5) — o print do instante em que você abriu vai junto"
	v.add_child(t)
	_edit = TextEdit.new()
	_edit.custom_minimum_size = Vector2(720, 300)
	_edit.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	_edit.placeholder_text = "Escreva o que viu: o que estranhou, o que funcionou, o que falhou..."
	_edit.text_changed.connect(_on_note_changed)
	v.add_child(_edit)
	_count = Label.new()
	v.add_child(_count)
	_summary = Label.new()
	v.add_child(_summary)
	var h := HBoxContainer.new()
	v.add_child(h)
	var ok := Button.new()
	ok.text = "Guardar nota e fechar (F5)"
	ok.pressed.connect(close_note)
	h.add_child(ok)
	_clear_btn = Button.new()
	_clear_btn.text = "Limpar pacote"
	_clear_btn.pressed.connect(_on_clear)
	h.add_child(_clear_btn)
	var hint := Label.new()
	hint.text = "Ctrl+Z desfaz · Ctrl+A seleciona tudo · Esc fecha"
	hint.modulate = Color(1, 1, 1, 0.6)
	h.add_child(hint)

	_guide_modal = Control.new()
	_guide_modal.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_guide_modal.mouse_filter = Control.MOUSE_FILTER_STOP
	_guide_modal.visible = false
	add_child(_guide_modal)
	var shade := ColorRect.new()
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.color = Color(0.015, 0.01, 0.025, 0.82)
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	_guide_modal.add_child(shade)
	_guide = PanelContainer.new()
	_guide.mouse_filter = Control.MOUSE_FILTER_STOP
	_guide_modal.add_child(_guide)
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_guide.add_child(scroll)
	var g := VBoxContainer.new()
	g.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(g)
	_guide_content = g
	var title := Label.new()
	title.text = "Obrigado por ajudar a construir %s!" % Version.GAME_NAME
	title.add_theme_font_size_override("font_size", 26)
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	g.add_child(title)
	var body := RichTextLabel.new()
	body.bbcode_enabled = true
	body.fit_content = true
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.text = _guide_text()
	g.add_child(body)
	var nl := Label.new()
	nl.text = "Seu nome (vai no .zip da evidência): "
	nl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	g.add_child(nl)
	_name_edit = LineEdit.new()
	_name_edit.max_length = 24
	_name_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_name_edit.text_submitted.connect(func(_t): close_guide())
	_name_edit.text_changed.connect(func(_t): _guide_error.visible = false)
	g.add_child(_name_edit)
	_guide_error = Label.new()
	_guide_error.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_guide_error.add_theme_color_override("font_color", Color(1.0, 0.48, 0.42))
	_guide_error.visible = false
	g.add_child(_guide_error)
	_guide_start = Button.new()
	_guide_start.text = "Começar"
	_guide_start.custom_minimum_size = Vector2(0, 44)
	_guide_start.pressed.connect(close_guide)
	g.add_child(_guide_start)

func _layout_guide() -> void:
	if _guide == null:
		return
	var viewport_size := get_viewport().get_visible_rect().size
	var available := viewport_size - Vector2(GUIDE_MARGIN * 2.0, GUIDE_MARGIN * 2.0)
	var panel_size := Vector2(minf(GUIDE_MAX_SIZE.x, maxf(1.0, available.x)), minf(GUIDE_MAX_SIZE.y, maxf(1.0, available.y)))
	_guide.custom_minimum_size = panel_size
	_guide.size = panel_size
	_guide.position = (viewport_size - panel_size) * 0.5
	# ScrollContainer mede o filho pela largura mínima; mantemos o texto dentro
	# da largura visível para que apenas a rolagem vertical seja necessária.
	_guide_content.custom_minimum_size.x = maxf(1.0, panel_size.x - 32.0)

func _guide_text() -> String:
	return "Este jogo [b]ainda não foi lançado[/b]: você está testando uma versão em construção (v%s). O que você reportar muda o jogo de verdade.\n\n" % Version.VERSION \
		+ "[b]O que fazer[/b]\n" \
		+ "1. Jogue seguindo o que foi pedido a você (uma fase, um herói, um chefe...). Não precisa jogar tudo.\n" \
		+ "2. [b]F6[/b] tira um print na hora certa (não pausa).\n" \
		+ "3. [b]F5[/b] abre o bloco de notas: escreva o que estranhou ou gostou. Ao fechar, a nota e o print do instante são guardados.\n" \
		+ "4. [b]F7[/b] gera UM arquivo .zip ao lado do executável (prints, notas, log e estado). Envie esse .zip ao responsável (Discord).\n\n" \
		+ "[b]Controles do jogo[/b]\n" \
		+ "WASD/setas: mover · Tab: alterna mira (automática / mouse) · Q/botão direito: habilidade ativa · E: altar, ritual, portal · X: extrair após o chefe · 1-5: escolher no level-up · R: rerrolar · Esc: pausa\n" \
		+ "Todas as armas atacam sozinhas. Sobreviva, evolua, derrote o chefe da fase e desça pelo portal.\n\n" \
		+ "[b]Teclas de teste[/b]: F5 nota · F6 print · F7 gera o .zip · F11 tela cheia · F1 este guia\n" \
		+ "[color=#aaaaaa]Os prints mostram a tela do jogo. Notas e log têm o nome de usuário do Windows removido.[/color]"

func toast(text: String) -> void:
	_toast.text = text
	_toast.modulate.a = 1.0
	var tw := create_tween()
	tw.tween_interval(2.6)
	tw.tween_property(_toast, "modulate:a", 0.0, 0.6)

# ------------------------------------------------------------------ teclas

func _input(ev: InputEvent) -> void:
	if not (ev is InputEventKey) or not ev.pressed or ev.echo:
		return
	if ev.physical_keycode == KEY_F11:
		Game.toggle_fullscreen()
		get_viewport().set_input_as_handled()
		return
	if not Version.PLAYTEST_BUILD:
		return
	match ev.physical_keycode:
		KEY_F5:
			if _guide_open:
				return
			if _note_open:
				close_note()
			else:
				open_note()
			get_viewport().set_input_as_handled()
		KEY_F6:
			take_print()
			get_viewport().set_input_as_handled()
		KEY_F7:
			export_zip()
			get_viewport().set_input_as_handled()
		KEY_F1:
			if _guide_open:
				close_guide()
			elif not _note_open:
				open_guide(false)
			get_viewport().set_input_as_handled()
		KEY_ESCAPE:
			if _note_open:
				close_note()
				get_viewport().set_input_as_handled()
			elif _guide_open and Game.profile.data.name != "":
				close_guide()
				get_viewport().set_input_as_handled()

# ------------------------------------------------------------------ contexto

func context() -> Dictionary:
	var ctx := {"tela": Game.screen_name}
	var cs := get_tree().current_scene
	if cs != null and cs.has_method("playtest_context"):
		ctx.merge(cs.playtest_context())
	return ctx

static func scrub(text: String) -> String:
	var out := text
	var user := OS.get_environment("USERNAME")
	if user != "" and user.length() > 2:
		out = out.replace(user, "<usuario>")
	for p in [OS.get_user_data_dir(), OS.get_executable_path().get_base_dir()]:
		if String(p) != "":
			out = out.replace(String(p), "<pasta>").replace(String(p).replace("/", "\\"), "<pasta>")
	return out

# ------------------------------------------------------------------ captura

func _capture() -> PackedByteArray:
	visible = false
	await RenderingServer.frame_post_draw
	var img := get_viewport().get_texture().get_image()
	visible = true
	return img.save_png_to_buffer()

func _bytes() -> int:
	var n := 0
	for it in items:
		n += it.png.size() + String(it.text).length()
	return n

func _prints() -> int:
	var n := 0
	for it in items:
		if it.png.size() > 0:
			n += 1
	return n

func _room_for_png(png: PackedByteArray) -> bool:
	if _prints() >= MAX_PRINTS or _bytes() + png.size() > MAX_BYTES:
		toast("Pacote cheio: aperte F7 para gerar o .zip")
		return false
	return true

func take_print() -> void:
	if _note_open:
		toast("Feche o bloco de notas (F5) antes de tirar um print.")
		return
	if _guide_open:
		return
	var png: PackedByteArray = await _capture()
	if not _room_for_png(png):
		return
	_add({"kind": "print", "png": png, "text": ""})
	toast("Print %d guardado (F7 gera o .zip)" % _prints())
	if _bytes() > MAX_BYTES * 0.8:
		toast("Pacote quase cheio (80%). Aperte F7 para gerar o .zip.")

func open_note() -> void:
	_pending_ctx = context()
	_pending_png = await _capture()
	_note_open = true
	_paused_before = get_tree().paused
	get_tree().paused = true
	_pad.visible = true
	_edit.text = ""
	_on_note_changed()
	_refresh_summary()
	_edit.grab_focus()

func close_note() -> void:
	if not _note_open:
		return
	_note_open = false
	_pad.visible = false
	get_tree().paused = _paused_before
	var text := _edit.text.strip_edges().substr(0, NOTE_MAX)
	if text != "":
		var png := _pending_png if _room_for_png(_pending_png) else PackedByteArray()
		_add({"kind": "nota", "png": png, "text": text, "ctx": _pending_ctx})
		toast("Nota guardada (F7 gera o .zip)")
	_clear_armed = false
	_clear_btn.text = "Limpar pacote"

func _on_note_changed() -> void:
	if _edit.text.length() > NOTE_MAX:
		_edit.text = _edit.text.substr(0, NOTE_MAX)
		_edit.set_caret_column(NOTE_MAX)
	_count.text = "%d/%d caracteres" % [_edit.text.length(), NOTE_MAX]

func _refresh_summary() -> void:
	var notes := 0
	for it in items:
		if it.kind == "nota":
			notes += 1
	_summary.text = "Guardado: %d notas, %d prints" % [notes, _prints() - notes]

func _on_clear() -> void:
	if not _clear_armed:
		_clear_armed = true
		_clear_btn.text = "Certeza? clique de novo"
		return
	_clear_armed = false
	_clear_btn.text = "Limpar pacote"
	items.clear()
	_wipe_draft()
	_refresh_summary()
	toast("Pacote limpo")

func open_guide(first: bool) -> void:
	_guide_open = true
	_paused_before = get_tree().paused
	get_tree().paused = true
	_guide_error.visible = false
	_guide_modal.visible = true
	_layout_guide()
	_name_edit.text = Game.profile.data.name
	_guide_start.text = "Começar" if first else "Fechar"
	_name_edit.grab_focus()

func close_guide() -> void:
	var nm := _name_edit.text.strip_edges()
	if nm == "":
		if Game.profile.data.name == "":
			_guide_error.text = "Digite um nome para continuar."
			_guide_error.visible = true
			_name_edit.grab_focus()
			return
		nm = Game.profile.data.name
	Game.profile.data.name = nm
	Game.profile.data.welcome_seen = true
	Game.save()
	_guide_open = false
	_guide_modal.visible = false
	get_tree().paused = _paused_before
	call_deferred("_restore_menu_focus")

func _restore_menu_focus() -> void:
	var scene := get_tree().current_scene
	if scene == null:
		return
	var play_btn := scene.get_node_or_null("Tabs/Jogar/Right/PlayBtn") as Button
	if play_btn != null and not play_btn.disabled:
		play_btn.grab_focus()

# ------------------------------------------------------------------ pacote e disco

func _add(it: Dictionary) -> void:
	it.time = Time.get_datetime_string_from_system()
	if not it.has("ctx"):
		it.ctx = context()
	items.append(it)
	_save_item(items.size() - 1)

func _save_item(i: int) -> void:
	DirAccess.make_dir_recursive_absolute(DRAFT_DIR)
	var it: Dictionary = items[i]
	var f := FileAccess.open("%s/item_%03d.json" % [DRAFT_DIR, i], FileAccess.WRITE)
	if f != null:
		f.store_string(JSON.stringify({"kind": it.kind, "time": it.time, "ctx": it.ctx, "text": it.text}))
	if it.png.size() > 0:
		var p := FileAccess.open("%s/item_%03d.png" % [DRAFT_DIR, i], FileAccess.WRITE)
		if p != null:
			p.store_buffer(it.png)

func _load_draft() -> void:
	var dir := DirAccess.open(DRAFT_DIR)
	if dir == null:
		return
	var names := dir.get_files()
	names.sort()
	for n in names:
		if not n.ends_with(".json"):
			continue
		var f := FileAccess.open("%s/%s" % [DRAFT_DIR, n], FileAccess.READ)
		var d: Variant = JSON.parse_string(f.get_as_text()) if f != null else null
		if d is Dictionary:
			var png := PackedByteArray()
			var pp := "%s/%s.png" % [DRAFT_DIR, n.get_basename()]
			if FileAccess.file_exists(pp):
				png = FileAccess.get_file_as_bytes(pp)
			items.append({"kind": d.kind, "time": d.time, "ctx": d.ctx, "text": d.text, "png": png})

func _wipe_draft() -> void:
	var dir := DirAccess.open(DRAFT_DIR)
	if dir == null:
		return
	for n in dir.get_files():
		DirAccess.remove_absolute("%s/%s" % [DRAFT_DIR, n])

func out_dir() -> String:
	if OS.has_feature("editor"):
		return ProjectSettings.globalize_path("res://")
	return OS.get_executable_path().get_base_dir()

func build_info(now: Dictionary) -> Dictionary:
	var itl: Array = []
	for i in items.size():
		itl.append({"n": i + 1, "tipo": items[i].kind, "hora": items[i].time, "contexto": items[i].ctx})
	return {"jogador": Game.profile.data.name, "versao": Version.VERSION, "jogo": Version.GAME_NAME, "data": Time.get_datetime_string_from_system(),
		"so": OS.get_name(), "moedas": Game.profile.coins(), "notas": items.filter(func(x): return x.kind == "nota").size(), "prints": _prints(),
		"itens": itl, "save_em_disco": Game.persisted, "contexto_atual": context()}

func export_zip() -> void:
	if items.is_empty():
		toast("Não há evidência a ser enviada.")
		return
	if _note_open:
		close_note()
	var player := String(Game.profile.data.name)
	var safe := ""
	for ch in player:
		if ch.unicode_at(0) < 128 and (ch.to_lower() != ch.to_upper() or ch.is_valid_int()):
			safe += ch
	if safe == "":
		safe = "jogador"
	var dt := Time.get_datetime_dict_from_system()
	var fname := "EV-%s-%04d%02d%02d-%02d%02d%02d.zip" % [safe, dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second]
	var dir := out_dir()
	var path := "%s/%s" % [dir, fname]
	var zp := ZIPPacker.new()
	if zp.open(path) != OK:
		DirAccess.make_dir_recursive_absolute(FALLBACK_DIR)
		dir = ProjectSettings.globalize_path(FALLBACK_DIR)
		path = "%s/%s" % [dir, fname]
		if zp.open(path) != OK:
			toast("Não consegui gravar o .zip; o pacote foi mantido.")
			return
	_zip_text(zp, "info.json", JSON.stringify(build_info({}), "  "))
	var log_text := "\n".join(Game.log_lines.slice(maxi(0, Game.log_lines.size() - 200)))
	_zip_text(zp, "log.txt", scrub(log_text) + "\n")
	var md := "# Notas — %s (v%s)\n" % [Version.GAME_NAME, Version.VERSION]
	var has_notes := false
	var n := 0
	for i in items.size():
		var it: Dictionary = items[i]
		if it.kind == "nota":
			has_notes = true
			n += 1
			md += "\n## Nota %d — %s\nContexto: %s\n\n%s\n" % [n, it.time, JSON.stringify(it.ctx), scrub(String(it.text))]
	if has_notes:
		_zip_text(zp, "notas.md", md)
	for i in items.size():
		var it: Dictionary = items[i]
		if it.png.size() > 0:
			zp.start_file("prints/%02d-%s.png" % [i + 1, it.kind])
			zp.write_file(it.png)
			zp.close_file()
	zp.close()
	var summary := "%d notas, %d prints" % [items.filter(func(x): return x.kind == "nota").size(), _prints()]
	items.clear()
	_wipe_draft()
	Game.logline("Evidência exportada: %s" % fname)
	toast("Evidência salva: %s (%s)\n%s" % [fname, summary, dir])

func _zip_text(zp: ZIPPacker, name: String, text: String) -> void:
	zp.start_file(name)
	zp.write_file(text.to_utf8_buffer())
	zp.close_file()
