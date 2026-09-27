extends Node2D
## Prancha de QA dos strips reprocessados sem alterar os assets oficiais.

const CELL := Vector2i(256, 384)
const BASELINE_Y := 368.0
const DISPLAY_SCALE := 72.0 / CELL.y
const ROWS := [
	{"sequence": "idle", "count": 4},
	{"sequence": "move_se", "count": 6},
	{"sequence": "attack", "count": 4},
]
const BACKGROUND := Color("52515d")
const PANEL := Color("676674")
const GUIDE := Color("f0bf4d")
const TEXT := Color("191721")
var _hero_label := "NYRELIA"

func _ready() -> void:
	Playtest.visible = false
	var args := OS.get_cmdline_user_args()
	var candidate_root := String(args[1]) if args.size() > 1 else ".atena/generated/nyrelia-reprocess/v01/strips"
	_hero_label = String(args[2]).to_upper() if args.size() > 2 else _hero_label
	for row_index in ROWS.size():
		var row: Dictionary = ROWS[row_index]
		var image := Image.new()
		var source := "%s/%s.png" % [candidate_root, row.sequence]
		if image.load(ProjectSettings.globalize_path("res://%s" % source)) != OK:
			push_error("Nyrelia reprocess QA: não foi possível abrir %s" % source)
			get_tree().quit(1)
			return
		var texture := ImageTexture.create_from_image(image)
		for frame in int(row.count):
			_add_frame(texture, frame, row_index)
	queue_redraw()
	await get_tree().process_frame
	await get_tree().process_frame
	var output_path := String(args[0]) if not args.is_empty() else ".atena/evidence/SPEC-047-nyrelia-reprocess-pilot.png"
	var screenshot := get_viewport().get_texture().get_image()
	var status := screenshot.save_png(output_path)
	if status != OK:
		push_error("Nyrelia reprocess QA: não foi possível salvar %s" % output_path)
	get_tree().quit(0 if status == OK else 1)

func _add_frame(texture: Texture2D, frame: int, row_index: int) -> void:
	var sprite := Sprite2D.new()
	sprite.texture = texture
	sprite.region_enabled = true
	sprite.region_rect = Rect2(frame * CELL.x, 0, CELL.x, CELL.y)
	sprite.position = Vector2(155.0 + frame * 190.0, 215.0 + row_index * 220.0)
	sprite.offset = Vector2(0.0, CELL.y * 0.5 - BASELINE_Y)
	sprite.scale = Vector2.ONE * (DISPLAY_SCALE * 1.75)
	add_child(sprite)

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, Vector2(1280.0, 720.0)), BACKGROUND)
	var font := ThemeDB.fallback_font
	draw_string(font, Vector2(38.0, 48.0), "%s — candidatos reprocessados, escala real" % _hero_label, HORIZONTAL_ALIGNMENT_LEFT, -1, 27, TEXT)
	draw_string(font, Vector2(38.0, 76.0), "Ampliação 1.75x em fundo neutro; guia dourado = ponto lógico de chão.", HORIZONTAL_ALIGNMENT_LEFT, -1, 17, TEXT)
	for row_index in ROWS.size():
		var row: Dictionary = ROWS[row_index]
		var top := 102.0 + row_index * 220.0
		draw_string(font, Vector2(42.0, top + 28.0), String(row.sequence).to_upper(), HORIZONTAL_ALIGNMENT_LEFT, -1, 20, TEXT)
		for frame in int(row.count):
			var center := Vector2(155.0 + frame * 190.0, 215.0 + row_index * 220.0)
			draw_rect(Rect2(center.x - 80.0, top, 160.0, 188.0), PANEL)
			draw_string(font, Vector2(center.x - 38.0, top + 56.0), "frame %d" % frame, HORIZONTAL_ALIGNMENT_LEFT, -1, 15, TEXT)
			_draw_ground_guide(center)

func _draw_ground_guide(center: Vector2) -> void:
	var diamond := PackedVector2Array([
		center + Vector2(0.0, -9.0), center + Vector2(20.0, 0.0),
		center + Vector2(0.0, 9.0), center + Vector2(-20.0, 0.0),
	])
	draw_polyline(diamond + PackedVector2Array([diamond[0]]), GUIDE, 2.0, true)
	draw_line(center + Vector2(-28.0, 0.0), center + Vector2(28.0, 0.0), GUIDE, 1.0, true)
