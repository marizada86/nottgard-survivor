extends Node2D
## Folha determinística de frames runtime para o piloto de Nyrelia.

const HERO_VIEW := preload("res://ui/hero_view.tscn")
const ROWS := [
	{"sequence": &"idle", "count": 4},
	{"sequence": &"move_se", "count": 6},
	{"sequence": &"attack", "count": 4},
]
const BACKGROUND := Color("52515d")
const PANEL := Color("676674")
const GUIDE := Color("f0bf4d")
const TEXT := Color("191721")

func _ready() -> void:
	Playtest.visible = false
	for row_index in ROWS.size():
		var row: Dictionary = ROWS[row_index]
		for frame in int(row.count):
			_add_frame(StringName(row.sequence), frame, row_index)
	queue_redraw()
	await get_tree().process_frame
	await get_tree().process_frame
	var args := OS.get_cmdline_user_args()
	var output_path := String(args[0]) if not args.is_empty() else ".atena/evidence/SPEC-045-nyrelia-pilot-frames.png"
	var image := get_viewport().get_texture().get_image()
	if image == null:
		push_error("Nyrelia QA frames: viewport sem imagem de captura")
		get_tree().quit(1)
		return
	var status := image.save_png(output_path)
	if status != OK:
		push_error("Nyrelia QA frames: não foi possível salvar %s" % output_path)
	get_tree().quit(0 if status == OK else 1)

func _add_frame(sequence: StringName, frame_index: int, row_index: int) -> void:
	var x := 155.0 + frame_index * 190.0
	var y := 215.0 + row_index * 220.0
	var view := HERO_VIEW.instantiate() as Node2D
	add_child(view)
	view.apply_hero("nyrelia")
	view.position = Vector2(x, y)
	view.scale = Vector2.ONE * 1.75
	var sprite := view.get_node("AnimatedSprite2D") as AnimatedSprite2D
	sprite.play(sequence)
	sprite.pause()
	sprite.frame = frame_index

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, Vector2(1280.0, 720.0)), BACKGROUND)
	var font := ThemeDB.fallback_font
	draw_string(font, Vector2(38.0, 48.0), "NYRELIA QA — todos os frames do piloto no runtime", HORIZONTAL_ALIGNMENT_LEFT, -1, 27, TEXT)
	draw_string(font, Vector2(38.0, 76.0), "Ampliação 1.75x em fundo neutro; guia dourado = ponto lógico de chão.", HORIZONTAL_ALIGNMENT_LEFT, -1, 17, TEXT)
	for row_index in ROWS.size():
		var row: Dictionary = ROWS[row_index]
		var top := 102.0 + row_index * 220.0
		draw_string(font, Vector2(42.0, top + 28.0), String(row.sequence).to_upper(), HORIZONTAL_ALIGNMENT_LEFT, -1, 20, TEXT)
		for frame in int(row.count):
			var x := 155.0 + frame * 190.0
			var y := 215.0 + row_index * 220.0
			draw_rect(Rect2(x - 80.0, top, 160.0, 188.0), PANEL)
			draw_string(font, Vector2(x - 38.0, top + 56.0), "frame %d" % frame, HORIZONTAL_ALIGNMENT_LEFT, -1, 15, TEXT)
			_draw_ground_guide(Vector2(x, y))

func _draw_ground_guide(center: Vector2) -> void:
	var diamond := PackedVector2Array([
		center + Vector2(0.0, -9.0), center + Vector2(20.0, 0.0),
		center + Vector2(0.0, 9.0), center + Vector2(-20.0, 0.0),
	])
	draw_polyline(diamond + PackedVector2Array([diamond[0]]), GUIDE, 2.0, true)
	draw_line(center + Vector2(-28.0, 0.0), center + Vector2(28.0, 0.0), GUIDE, 1.0, true)
