extends Node
## Gera as cenas editáveis (ui/*.tscn, ui/stages/*.tscn) e o tema. Uso (precisa ser cena, para os autoloads existirem):
##   godot --headless --path . res://tools/build_scenes.tscn
## ATENÇÃO: rodar de novo SOBRESCREVE edições manuais feitas nas cenas. Depois do 1º build, edite no editor.
## Pedaços: `-- stages` só as fases · `-- ui` só hud/menu/run · `-- theme` só o tema.

var only := ""

func _ready() -> void:
	var a := OS.get_cmdline_user_args()
	only = a[0] if a.size() > 0 else ""
	DirAccess.make_dir_recursive_absolute("res://ui/stages")
	if only in ["", "theme"]:
		_build_theme()
	if only in ["", "stages"]:
		_build_parts()
		for id in Data.table("stages"):
			_build_stage(id)
	if only in ["", "ui"]:
		_build_hud()
		_build_run()
		_build_menu()
	get_tree().quit()

# ------------------------------------------------------------------ helpers

func _save(root: Node, path: String) -> void:
	var p := PackedScene.new()
	p.pack(root)
	var err := ResourceSaver.save(p, path)
	print("%s -> %s" % [path, error_string(err)])
	root.free()

func _add(parent: Node, n: Node, node_name: String, owner_node: Node, unique: bool = false) -> Node:
	n.name = node_name
	parent.add_child(n)
	n.owner = owner_node
	if unique:
		n.unique_name_in_owner = true
	return n

func _inst(path: String, node_name: String, pos: Vector2, owner_node: Node, parent: Node) -> Node:
	var n: Node = load(path).instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	n.name = node_name
	if n is Node2D or n is Control:
		n.position = pos
	parent.add_child(n)
	n.owner = owner_node
	return n

func _label(text: String, size: int = 0, color: Color = Color(-1, 0, 0)) -> Label:
	var l := Label.new()
	l.text = text
	if size > 0:
		l.add_theme_font_size_override("font_size", size)
	if color.r >= 0.0:
		l.add_theme_color_override("font_color", color)
	return l

func _center(c: Control) -> void:
	c.set_anchors_preset(Control.PRESET_CENTER)
	c.grow_horizontal = Control.GROW_DIRECTION_BOTH
	c.grow_vertical = Control.GROW_DIRECTION_BOTH

func _simple(script_path: String, node_name: String, path: String) -> void:
	var n := Node2D.new()
	n.name = node_name
	n.set_script(load(script_path))
	_save(n, path)

func _rgb(a: Array) -> Color:
	return Color(float(a[0]) / 255.0, float(a[1]) / 255.0, float(a[2]) / 255.0)

# ------------------------------------------------------------------ tema

func _build_theme() -> void:
	var th := Theme.new()
	var f: Font = load("res://assets/fonts/AlegreyaSans-Regular.ttf")
	if f != null:
		th.default_font = f
	th.default_font_size = 20
	var gold := Color(0.85, 0.72, 0.4)
	var panel := StyleBoxFlat.new()
	panel.bg_color = Color(0.09, 0.08, 0.11, 0.96)
	panel.border_color = Color(0.45, 0.36, 0.22)
	panel.set_border_width_all(2)
	panel.set_corner_radius_all(4)
	panel.set_content_margin_all(14)
	th.set_stylebox("panel", "PanelContainer", panel)
	th.set_stylebox("panel", "Panel", panel)
	var mk := func(bg: Color, border: Color) -> StyleBoxFlat:
		var s := StyleBoxFlat.new()
		s.bg_color = bg
		s.border_color = border
		s.set_border_width_all(1)
		s.set_corner_radius_all(3)
		s.set_content_margin_all(8)
		return s
	th.set_stylebox("normal", "Button", mk.call(Color(0.16, 0.13, 0.12), Color(0.4, 0.32, 0.2)))
	th.set_stylebox("hover", "Button", mk.call(Color(0.26, 0.2, 0.14), gold))
	th.set_stylebox("pressed", "Button", mk.call(Color(0.34, 0.24, 0.12), gold))
	th.set_stylebox("disabled", "Button", mk.call(Color(0.1, 0.1, 0.1), Color(0.25, 0.25, 0.25)))
	th.set_stylebox("focus", "Button", mk.call(Color(0, 0, 0, 0), gold))
	th.set_color("font_color", "Button", Color(0.92, 0.88, 0.78))
	th.set_color("font_disabled_color", "Button", Color(0.45, 0.45, 0.45))
	th.set_color("font_hover_color", "Button", Color(1, 0.95, 0.8))
	th.set_color("font_color", "Label", Color(0.9, 0.87, 0.8))
	th.set_stylebox("fill", "ProgressBar", mk.call(Color(0.7, 0.15, 0.15), Color(0.7, 0.15, 0.15)))
	th.set_stylebox("background", "ProgressBar", mk.call(Color(0.1, 0.05, 0.05), Color(0.3, 0.2, 0.2)))
	ResourceSaver.save(th, "res://ui/theme.tres")
	print("res://ui/theme.tres -> OK")

# ------------------------------------------------------------------ partes reutilizáveis + fases

func _build_parts() -> void:
	_simple("res://ui/hero_view.gd", "Hero", "res://ui/hero_view.tscn")
	_simple("res://ui/prop.gd", "Prop", "res://ui/prop.tscn")
	_simple("res://ui/spawn_point.gd", "SpawnPoint", "res://ui/spawn_point.tscn")

func _build_stage(id: String) -> void:
	var d: Dictionary = Data.table("stages")[id]
	var w := Node2D.new()
	w.name = "Stage"
	var ground := Node2D.new()
	ground.set_script(load("res://ui/ground.gd"))
	ground.z_index = -100
	_add(w, ground, "Ground", w)
	ground.color_a = _rgb(d.ground[0])
	ground.color_b = _rgb(d.ground[1])
	var sorted := Node2D.new()
	sorted.y_sort_enabled = true
	_add(w, sorted, "Sorted", w)
	_inst("res://ui/hero_view.tscn", "Hero", Iso.to_screen(Vector2(20, 20)), w, sorted)
	var rng := RandomNumberGenerator.new()
	rng.seed = hash(id)
	var pcfg: Dictionary = d.prop
	var placed: Array = [Vector2(20, 20)]
	var idx := 1
	var tries := 0
	while idx <= int(pcfg.n) and tries < 800:
		tries += 1
		var p := Vector2(rng.randi_range(2, 37), rng.randi_range(2, 37))
		var ok := true
		for q in placed:
			if p.distance_to(q) < (4.5 if q == Vector2(20, 20) else 2.6):
				ok = false
				break
		if not ok:
			continue
		placed.append(p)
		var n := _inst("res://ui/prop.tscn", "Prop%d" % idx, Iso.to_screen(p), w, sorted)
		n.kind = String(pcfg.kind)
		n.color = _rgb(pcfg.color) if rng.randf() < 0.5 else _rgb(pcfg.color).lightened(0.12)
		n.height = float(pcfg.height) * rng.randf_range(0.8, 1.25)
		n.half_width = 22.0
		if pcfg.kind == "torii":
			n.half_width = 30.0
		elif pcfg.kind in ["cogumelo", "bolha"]:
			n.half_width = rng.randf_range(16.0, 26.0)
		idx += 1
	var spawns := Node2D.new()
	_add(w, spawns, "SpawnPoints", w)
	var waves: Array = d.waves
	var spots := [Vector2(29, 20), Vector2(11, 26), Vector2(20, 9), Vector2(27, 29)]
	for i in 4:
		var wv: Dictionary = waves[i % waves.size()]
		var sp := _inst("res://ui/spawn_point.tscn", "Spawn%d" % (i + 1), Iso.to_screen(spots[i]), w, spawns)
		sp.enemy_id = String(wv.id)
		sp.count = 2 if i < 2 else 1
	_save(w, "res://ui/stages/%s.tscn" % id)

# ------------------------------------------------------------------ HUD

func _build_hud() -> void:
	var h := CanvasLayer.new()
	h.set_script(load("res://ui/hud.gd"))
	h.name = "Hud"
	var stat := VBoxContainer.new()
	stat.position = Vector2(14, 10)
	_add(h, stat, "StatBox", h)
	_add(stat, _label("", 22), "NameLabel", h, true)
	var hp := ProgressBar.new()
	hp.custom_minimum_size = Vector2(320, 24)
	hp.show_percentage = false
	_add(stat, hp, "HpBar", h, true)
	var hpl := _label("", 16)
	hpl.set_anchors_preset(Control.PRESET_FULL_RECT)
	hpl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hpl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_add(hp, hpl, "HpLabel", h, true)
	var xp := ProgressBar.new()
	xp.custom_minimum_size = Vector2(320, 10)
	xp.show_percentage = false
	xp.add_theme_stylebox_override("fill", _flat(Color(0.25, 0.6, 0.9)))
	_add(stat, xp, "XpBar", h, true)
	_add(stat, _label("", 16), "InfoLabel", h, true)

	var tl := _label("00:00", 34)
	tl.set_anchors_preset(Control.PRESET_CENTER_TOP)
	tl.offset_left = -90
	tl.offset_right = 90
	tl.offset_top = 6
	tl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_add(h, tl, "TimerLabel", h, true)
	var sl := _label("", 16, Color(0.75, 0.7, 0.6))
	sl.set_anchors_preset(Control.PRESET_CENTER_TOP)
	sl.offset_left = -300
	sl.offset_right = 300
	sl.offset_top = 48
	sl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_add(h, sl, "StageLabel", h, true)

	var bp := VBoxContainer.new()
	bp.set_anchors_preset(Control.PRESET_CENTER_TOP)
	bp.offset_left = -290
	bp.offset_right = 290
	bp.offset_top = 74
	_add(h, bp, "BossPanel", h, true)
	var bn := _label("", 20, Color(1, 0.6, 0.5))
	bn.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_add(bp, bn, "BossName", h, true)
	var bb := ProgressBar.new()
	bb.custom_minimum_size = Vector2(580, 16)
	bb.show_percentage = false
	bb.add_theme_stylebox_override("fill", _flat(Color(0.75, 0.1, 0.1)))
	_add(bp, bb, "BossBar", h, true)

	var wl := _label("", 15, Color(0.85, 0.85, 0.8))
	wl.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	wl.offset_left = 14
	wl.offset_top = -230
	wl.offset_right = 460
	wl.offset_bottom = -10
	wl.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	wl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_add(h, wl, "WeaponsLabel", h, true)

	var tb := VBoxContainer.new()
	tb.set_anchors_preset(Control.PRESET_CENTER_TOP)
	tb.offset_left = -320
	tb.offset_right = 320
	tb.offset_top = 130
	tb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_add(h, tb, "ToastBox", h, true)

	var pr := _label("", 22, Color(1, 0.88, 0.45))
	pr.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	pr.offset_left = -320
	pr.offset_right = 320
	pr.offset_top = -80
	pr.offset_bottom = -40
	pr.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_add(h, pr, "PromptLabel", h, true)

	var lp := PanelContainer.new()
	_center(lp)
	_add(h, lp, "LevelUpPanel", h, true)
	var lv := VBoxContainer.new()
	_add(lp, lv, "VBox", h)
	_add(lv, _label("Nível", 26, Color(1, 0.9, 0.5)), "LvTitle", h, true)
	_add(lv, VBoxContainer.new(), "OfferBox", h, true)
	_add(lv, Button.new(), "RerollBtn", h, true)

	var pp := PanelContainer.new()
	_center(pp)
	_add(h, pp, "PausePanel", h, true)
	var pv := VBoxContainer.new()
	pv.custom_minimum_size = Vector2(380, 0)
	_add(pp, pv, "VBox", h)
	_add(pv, _label("Pausa", 30), "PauseTitle", h)
	var rb := Button.new()
	rb.text = "Continuar (Esc)"
	_add(pv, rb, "ResumeBtn", h, true)
	_add(pv, Button.new(), "AimBtn", h, true)
	var vr := HBoxContainer.new()
	_add(pv, vr, "VolRow", h)
	_add(vr, _label("Volume"), "VolText", h)
	var sl2 := HSlider.new()
	sl2.max_value = 1.0
	sl2.step = 0.05
	sl2.custom_minimum_size = Vector2(220, 0)
	sl2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_add(vr, sl2, "VolSlider", h, true)
	var qb := Button.new()
	qb.text = "Abandonar run"
	_add(pv, qb, "QuitBtn", h, true)

	var rp := PanelContainer.new()
	_center(rp)
	_add(h, rp, "ResultPanel", h, true)
	var rv := VBoxContainer.new()
	rv.custom_minimum_size = Vector2(520, 0)
	_add(rp, rv, "VBox", h)
	_add(rv, _label("", 34, Color(1, 0.9, 0.5)), "ResultTitle", h, true)
	_add(rv, _label(""), "ResultText", h, true)
	var rr := HBoxContainer.new()
	_add(rv, rr, "Row", h)
	var ab := Button.new()
	ab.text = "Jogar de novo"
	_add(rr, ab, "AgainBtn", h, true)
	var mb := Button.new()
	mb.text = "Voltar ao Quartel"
	_add(rr, mb, "MenuBtn", h, true)
	_save(h, "res://ui/hud.tscn")

func _flat(c: Color) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = c
	s.set_corner_radius_all(2)
	return s

# ------------------------------------------------------------------ run

func _build_run() -> void:
	var r := Node2D.new()
	r.set_script(load("res://ui/run.gd"))
	r.name = "Run"
	_add(r, Node2D.new(), "StageSlot", r)
	var under := Node2D.new()
	under.set_script(load("res://ui/overlay.gd"))
	under.z_index = -50
	under.mode = "under"
	_add(r, under, "Under", r)
	var over := Node2D.new()
	over.set_script(load("res://ui/overlay.gd"))
	over.z_index = 60
	over.mode = "over"
	_add(r, over, "Over", r)
	var fx := Node2D.new()
	fx.z_index = 100
	_add(r, fx, "Fx", r)
	_add(r, Camera2D.new(), "Camera", r)
	_inst("res://ui/hud.tscn", "Hud", Vector2.ZERO, r, r)
	_save(r, "res://ui/run.tscn")

# ------------------------------------------------------------------ menu

func _tab(tabs: TabContainer, node: Node, tname: String, owner_node: Node) -> Node:
	return _add(tabs, node, tname, owner_node)

func _fill(c: Control) -> Control:
	c.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	c.size_flags_vertical = Control.SIZE_EXPAND_FILL
	return c

func _rich(min_h: int) -> RichTextLabel:
	var t := RichTextLabel.new()
	t.bbcode_enabled = true
	t.custom_minimum_size = Vector2(0, min_h)
	t.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return t

func _build_menu() -> void:
	var m := Control.new()
	m.set_script(load("res://ui/menu.gd"))
	m.name = "Menu"
	m.set_anchors_preset(Control.PRESET_FULL_RECT)
	var bg := ColorRect.new()
	bg.color = Color(0.06, 0.05, 0.08)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	_add(m, bg, "Bg", m)
	var title := _label("NOTTGARD SURVIVORS", 44, Color(0.9, 0.75, 0.42))
	var cz: Font = load("res://assets/fonts/CinzelDecorative-Bold.ttf")
	if cz != null:
		title.add_theme_font_override("font", cz)
	title.position = Vector2(28, 10)
	_add(m, title, "Title", m)
	var sub := _label("O Abismo desce. Sobreviva, evolua, derrube o que vier.", 18, Color(0.65, 0.6, 0.55))
	sub.position = Vector2(32, 68)
	_add(m, sub, "Subtitle", m)
	var coins := _label("Moedas: 0", 26, Color(1, 0.85, 0.3))
	coins.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	coins.offset_left = -300
	coins.offset_right = -28
	coins.offset_top = 22
	coins.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_add(m, coins, "CoinsLabel", m, true)
	var ver := _label("", 14, Color(0.5, 0.5, 0.5))
	ver.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	ver.offset_left = 28
	ver.offset_top = -30
	ver.offset_bottom = -6
	_add(m, ver, "VersionLabel", m, true)

	var tabs := TabContainer.new()
	tabs.set_anchors_preset(Control.PRESET_FULL_RECT)
	tabs.offset_left = 24
	tabs.offset_top = 104
	tabs.offset_right = -24
	tabs.offset_bottom = -34
	_add(m, tabs, "Tabs", m, true)

	# Jogar
	var play := HBoxContainer.new()
	play.add_theme_constant_override("separation", 22)
	_tab(tabs, play, "Jogar", m)
	var left := VBoxContainer.new()
	left.custom_minimum_size = Vector2(290, 0)
	_add(play, left, "Left", m)
	_add(left, _label("Herói", 22, Color(0.9, 0.75, 0.42)), "HeroTitle", m)
	_add(left, _fill(ItemList.new()), "HeroList", m, true)
	var mid := VBoxContainer.new()
	mid.custom_minimum_size = Vector2(500, 0)
	_add(play, mid, "Mid", m)
	var por := TextureRect.new()
	por.custom_minimum_size = Vector2(500, 240)
	por.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	por.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_add(mid, por, "Portrait", m, true)
	_add(mid, _fill(_rich(200)), "HeroInfo", m, true)
	var right := VBoxContainer.new()
	right.custom_minimum_size = Vector2(340, 0)
	_add(play, right, "Right", m)
	_add(right, _label("Fase (camada do Abismo)", 22, Color(0.9, 0.75, 0.42)), "StageTitle", m)
	var sli := ItemList.new()
	sli.custom_minimum_size = Vector2(0, 230)
	_add(right, sli, "StageList", m, true)
	_add(right, _fill(_rich(150)), "StageInfo", m, true)
	var pb := Button.new()
	pb.text = "JOGAR"
	pb.custom_minimum_size = Vector2(0, 58)
	pb.add_theme_font_size_override("font_size", 28)
	_add(right, pb, "PlayBtn", m, true)

	# Melhorias
	var sc1 := ScrollContainer.new()
	_tab(tabs, sc1, "Melhorias", m)
	_add(sc1, _fill(VBoxContainer.new()), "UpgradeBox", m, true)
	# Conquistas
	var sc2 := ScrollContainer.new()
	_tab(tabs, sc2, "Conquistas", m)
	var ab := VBoxContainer.new()
	ab.add_theme_constant_override("separation", 8)
	_add(sc2, _fill(ab), "AchBox", m, true)
	# Códex
	var cx := HBoxContainer.new()
	cx.add_theme_constant_override("separation", 18)
	_tab(tabs, cx, "Códex", m)
	var cl := VBoxContainer.new()
	cl.custom_minimum_size = Vector2(340, 0)
	_add(cx, cl, "Left", m)
	_add(cl, OptionButton.new(), "CodexCat", m, true)
	_add(cl, _fill(ItemList.new()), "CodexList", m, true)
	_add(cx, _fill(_rich(300)), "CodexText", m, true)
	# Opções
	var op := VBoxContainer.new()
	op.add_theme_constant_override("separation", 10)
	_tab(tabs, op, "Opções", m)
	_add(op, _label("Modo de mira (também: Tab durante a run)"), "AimLabel", m)
	_add(op, OptionButton.new(), "AimOpt", m, true)
	_add(op, _label("Volume"), "VolLabel", m)
	var vs := HSlider.new()
	vs.max_value = 1.0
	vs.step = 0.05
	vs.custom_minimum_size = Vector2(340, 24)
	_add(op, vs, "VolOpt", m, true)
	var fo := CheckBox.new()
	fo.text = "Tela cheia (F11)"
	_add(op, fo, "FullOpt", m, true)
	_add(op, _label("Maldição (dificuldade)"), "DiffLabel", m)
	_add(op, OptionButton.new(), "DiffOpt", m, true)
	var gb := Button.new()
	gb.text = "Guia do playtester (F1)"
	_add(op, gb, "GuideBtn", m, true)
	var rb := Button.new()
	rb.text = "Apagar progresso"
	_add(op, rb, "ResetBtn", m, true)
	_save(m, "res://ui/menu.tscn")
