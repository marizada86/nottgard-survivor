extends Node2D
## Captura visual isolada de Nyrelia. Não participa da run normal.

const HERO_VIEW := preload("res://ui/hero_view.tscn")
const BACKGROUND := Color("17141f")
const PANEL := Color("242032")
const GUIDE := Color("d6ad4d")
const TEXT := Color("eee6d5")
const STATIONS := [
	{"label": "IDLE", "action": &"idle", "x": 250.0},
	{"label": "MOVE SE", "action": &"move_se", "x": 640.0},
	{"label": "ATTACK", "action": &"attack", "x": 1030.0},
]

func _ready() -> void:
	Playtest.visible = false
	for station in STATIONS:
		_add_station(StringName(station.action), float(station.x), 605.0, 1.0)
		_add_station(StringName(station.action), float(station.x), 340.0, 2.35)
	queue_redraw()
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().create_timer(0.12).timeout
	var args := OS.get_cmdline_user_args()
	var output_path := String(args[0]) if not args.is_empty() else ".atena/evidence/SPEC-045-nyrelia-qa.png"
	var image := get_viewport().get_texture().get_image()
	if image == null:
		push_error("Nyrelia QA: viewport sem imagem de captura")
		get_tree().quit(1)
		return
	var status := image.save_png(output_path)
	if status != OK:
		push_error("Nyrelia QA: não foi possível salvar %s" % output_path)
	get_tree().quit(0 if status == OK else 1)

func _add_station(action: StringName, x: float, y: float, zoom: float) -> void:
	var view := HERO_VIEW.instantiate() as Node2D
	add_child(view)
	view.apply_hero("nyrelia")
	view.scale = Vector2.ONE * zoom
	# A escala deve ampliar o sprite em torno do ponto de chão, sem deslocar
	# esse ponto de referência no painel QA.
	view.position = Vector2(x, y)
	if action == &"move_se":
		view.sync_visual(view.position - Vector2(12.0, 12.0), false, false)
		view.sync_visual(view.position, false, false)
	elif action == &"attack":
		view.play_action(&"attack")

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, Vector2(1280.0, 720.0)), BACKGROUND)
	var font := ThemeDB.fallback_font
	draw_string(font, Vector2(38.0, 52.0), "NYRELIA QA — runtime real e ampliado", HORIZONTAL_ALIGNMENT_LEFT, -1, 28, TEXT)
	draw_string(font, Vector2(38.0, 82.0), "Guia dourado = ponto lógico de chão. A faixa inferior usa a escala real de jogo (72 px).", HORIZONTAL_ALIGNMENT_LEFT, -1, 17, Color("b9b0c7"))
	for station in STATIONS:
		var x := float(station.x)
		draw_rect(Rect2(x - 155.0, 112.0, 310.0, 330.0), PANEL)
		draw_rect(Rect2(x - 155.0, 440.0, 310.0, 230.0), PANEL)
		draw_string(font, Vector2(x - 72.0, 142.0), "%s — 2.35x" % station.label, HORIZONTAL_ALIGNMENT_LEFT, -1, 18, TEXT)
		draw_string(font, Vector2(x - 54.0, 470.0), "%s — 1x" % station.label, HORIZONTAL_ALIGNMENT_LEFT, -1, 18, TEXT)
		_draw_ground_guide(Vector2(x, 340.0))
		_draw_ground_guide(Vector2(x, 605.0))

func _draw_ground_guide(center: Vector2) -> void:
	var diamond := PackedVector2Array([
		center + Vector2(0.0, -10.0), center + Vector2(22.0, 0.0),
		center + Vector2(0.0, 10.0), center + Vector2(-22.0, 0.0),
	])
	draw_polyline(diamond + PackedVector2Array([diamond[0]]), GUIDE, 2.0, true)
	draw_line(center + Vector2(-34.0, 0.0), center + Vector2(34.0, 0.0), GUIDE, 1.0, true)
