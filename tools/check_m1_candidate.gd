extends Node
## SPEC-176 (M1): confere que o laboratório carrega a candidata completa do piloto (8 direções + ataque, sem espelho) e monta uma folha de revisão.
## godot --headless --path . res://tools/check_m1_candidate.tscn -- --walk-debug --walk-candidate=<pasta com <herói>/<tira>.png> [--hero=durvall] [--sheet=<saída.png>]

const ANIMS := [&"move_e", &"move_se", &"move_s", &"move_sw", &"move_w", &"move_nw", &"move_n", &"move_ne", &"attack"]
const EXPECTED := {&"move_e": 6, &"move_se": 6, &"move_s": 6, &"move_sw": 6, &"move_w": 6, &"move_nw": 6, &"move_n": 6, &"move_ne": 6, &"attack": 4}

func _ready() -> void:
	var hero_id := WalkTrace.option("hero") if WalkTrace.option("hero") != "" else "durvall"
	var sheet_path := WalkTrace.option("sheet")
	var view: Node2D = load("res://ui/hero_view.tscn").instantiate()
	add_child(view)
	await get_tree().process_frame
	view.apply_hero(hero_id)
	await get_tree().process_frame
	var frames: SpriteFrames = view.sprite.sprite_frames
	var failures: Array = []
	var cols := 6
	var cell := Vector2i(256, 256)
	var sheet := Image.create(cols * cell.x, ANIMS.size() * cell.y, false, Image.FORMAT_RGBA8)
	sheet.fill(Color(0.2, 0.19, 0.21, 1.0))
	for row in ANIMS.size():
		var anim: StringName = ANIMS[row]
		if not frames.has_animation(anim):
			failures.append("%s: sem a animação" % anim)
			continue
		var count := frames.get_frame_count(anim)
		if count != int(EXPECTED[anim]):
			failures.append("%s: %d quadros, esperado %d" % [anim, count, int(EXPECTED[anim])])
		var tex0: Texture2D = frames.get_frame_texture(anim, 0)
		var is_candidate := tex0 is AtlasTexture and (tex0 as AtlasTexture).atlas is ImageTexture
		if not is_candidate:
			failures.append("%s: veio da arte de assets/, não da candidata" % anim)
		for i in mini(count, cols):
			var img: Image = frames.get_frame_texture(anim, i).get_image()
			img.convert(Image.FORMAT_RGBA8)
			img.resize(img.get_width() / 2, img.get_height() / 2, Image.INTERPOLATE_LANCZOS)
			sheet.blend_rect(img, Rect2i(Vector2i.ZERO, img.get_size()), Vector2i(i * cell.x, row * cell.y))
	for lab in [&"move_w", &"move_sw", &"move_nw"]:
		if not view._lab_real.has(lab):
			failures.append("%s: deveria ser real (sem espelho)" % lab)
	if sheet_path != "":
		DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(sheet_path.get_base_dir()))
		sheet.save_png(sheet_path)
	print("candidata %s: %d falha(s)" % [hero_id, failures.size()])
	for f in failures:
		print("  FALHA ", f)
	get_tree().quit(1 if failures.size() > 0 else 0)
