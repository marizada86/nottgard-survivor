extends Node2D
## Captura as seis poses de cada movimento-fonte de Durvall em escala atual e piloto.

const HERO_VIEW := preload("res://ui/hero_view.tscn")
const SEQUENCES := [&"idle", &"move_n", &"move_ne", &"move_e", &"move_se", &"move_s"]
const CELL := Vector2i(256, 384)
const BASE_SCALE := 72.0 / float(CELL.y)
const REJECTED_PROFILE := {&"move_n": 0.796, &"move_ne": 0.918, &"move_e": 1.296, &"move_se": 1.167, &"move_s": 0.951}
const BACKGROUND := Color("17151d")
const PANEL := Color("282530")
const GUIDE := Color("d9b65d")
const TEXT := Color("eee7dc")
const MUTED := Color("bdb4c7")
const CURRENT_X := 50.0
const CANDIDATE_X := 650.0
const HALF_WIDTH := 580.0
const ROW_TOP := 88.0
const ROW_HEIGHT := 105.0

func _ready() -> void:
	Playtest.visible = false
	var hero_view := HERO_VIEW.instantiate() as Node2D
	add_child(hero_view)
	hero_view.apply_hero("durvall")
	var original_sprite := hero_view.get_node("AnimatedSprite2D") as AnimatedSprite2D
	if original_sprite.sprite_frames == null:
		push_error("QA Durvall: SpriteFrames ausente")
		get_tree().quit(1)
		return
	hero_view.visible = false
	for row_index in SEQUENCES.size():
		var animation: StringName = SEQUENCES[row_index]
		var frame_count := original_sprite.sprite_frames.get_frame_count(animation)
		var row_y := ROW_TOP + float(row_index) * ROW_HEIGHT
		var base := BASE_SCALE
		var adjusted_scale := Vector2.ONE * BASE_SCALE * float(REJECTED_PROFILE.get(animation, 1.0))
		for frame_index in frame_count:
			var frame_x_left := CURRENT_X + 43.0 + float(frame_index) * 88.0
			var frame_x_right := CANDIDATE_X + 43.0 + float(frame_index) * 88.0
			_add_pose(original_sprite.sprite_frames, animation, frame_index, Vector2(frame_x_left, row_y + 100.0), Vector2.ONE * base, original_sprite.offset)
			_add_pose(original_sprite.sprite_frames, animation, frame_index, Vector2(frame_x_right, row_y + 100.0), adjusted_scale, original_sprite.offset)
	queue_redraw()
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().create_timer(0.2).timeout
	var args := OS.get_cmdline_user_args()
	var output_path := String(args[0]) if not args.is_empty() else ".atena/evidence/EVID-132-durvall-runtime-scale-qa.png"
	var image := get_viewport().get_texture().get_image()
	if image == null:
		push_error("QA Durvall: viewport sem imagem")
		get_tree().quit(1)
		return
	var status := image.save_png(output_path)
	if status != OK:
		push_error("QA Durvall: não foi possível salvar %s" % output_path)
		get_tree().quit(1)
		return
	var enlarged := image.duplicate()
	enlarged.resize(image.get_width() * 2, image.get_height() * 2, Image.INTERPOLATE_NEAREST)
	var enlarged_path := String(output_path).trim_suffix(".png") + "-ampliado-2x.png"
	status = enlarged.save_png(enlarged_path)
	if status != OK:
		push_error("QA Durvall: não foi possível salvar %s" % enlarged_path)
	get_tree().quit(0 if status == OK else 1)

func _add_pose(frames: SpriteFrames, animation: StringName, frame_index: int, at: Vector2, display_scale: Vector2, offset: Vector2) -> void:
	var preview := AnimatedSprite2D.new()
	preview.sprite_frames = frames
	preview.position = at
	preview.offset = offset
	preview.scale = display_scale
	preview.animation = animation
	preview.play(animation)
	preview.pause()
	preview.frame = frame_index
	add_child(preview)

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, Vector2(1280.0, 720.0)), BACKGROUND)
	var font := ThemeDB.fallback_font
	draw_string(font, Vector2(24.0, 30.0), "DURVALL — escala direcional no runtime", HORIZONTAL_ALIGNMENT_LEFT, -1, 23, TEXT)
	draw_string(font, Vector2(24.0, 55.0), "Seis poses por sequência, comparadas na escala de jogo (72 px). Guia dourado = ponto lógico.", HORIZONTAL_ALIGNMENT_LEFT, -1, 14, MUTED)
	draw_string(font, Vector2(CURRENT_X + 6.0, 79.0), "ATUAL — escala uniforme", HORIZONTAL_ALIGNMENT_LEFT, -1, 15, TEXT)
	draw_string(font, Vector2(CANDIDATE_X + 6.0, 79.0), "PILOTO — escala por direção", HORIZONTAL_ALIGNMENT_LEFT, -1, 15, TEXT)
	for row_index in SEQUENCES.size():
		var animation: StringName = SEQUENCES[row_index]
		var row_y := ROW_TOP + float(row_index) * ROW_HEIGHT
		var baseline := row_y + 100.0
		var label := "IDLE" if animation == &"idle" else String(animation).trim_prefix("move_").to_upper()
		draw_rect(Rect2(CURRENT_X, row_y + 1.0, HALF_WIDTH, ROW_HEIGHT - 3.0), PANEL)
		draw_rect(Rect2(CANDIDATE_X, row_y + 1.0, HALF_WIDTH, ROW_HEIGHT - 3.0), PANEL)
		draw_string(font, Vector2(12.0, baseline - 38.0), label, HORIZONTAL_ALIGNMENT_LEFT, -1, 13, TEXT)
		draw_string(font, Vector2(612.0, baseline - 38.0), label, HORIZONTAL_ALIGNMENT_LEFT, -1, 13, TEXT)
		draw_line(Vector2(CURRENT_X + 12.0, baseline), Vector2(CURRENT_X + HALF_WIDTH - 12.0, baseline), GUIDE, 1.0, true)
		draw_line(Vector2(CANDIDATE_X + 12.0, baseline), Vector2(CANDIDATE_X + HALF_WIDTH - 12.0, baseline), GUIDE, 1.0, true)
