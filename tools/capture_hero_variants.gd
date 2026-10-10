extends Node
## SPEC-154 (BUG-029): o herói com o conjunto original e com as variantes A, B e C lado a lado, em jogo. Uso:
##   godot --path . --resolution 1280x720 res://tools/capture_hero_variants.tscn -- <heroi> <zoom> <rotulo>
## Cada célula é um recorte de 80x100 px em volta do herói, ampliado 5x sem suavizar (para ver cada pixel);
## linha de cima = idle, linha de baixo = andando para leste. Saída em .atena/generated/bug-029-reducao/capturas/.

const HeroViewScript := preload("res://ui/hero_view.gd")
## "original" = tiras 256x384; "tabela" = o que o jogo usa (HERO_STRIP_SET); "a", "b" e "c" = variantes de heroes_screen_preview/ (se existirem)
const VARIANTS := ["original", "tabela"]
const CROP := Vector2i(130, 150)
const SCALE := 4

func _ready() -> void:
	Playtest.visible = false
	Game.qa_sandbox = true
	Game.qa_launch = {"seed": 4242}
	var a := OS.get_cmdline_user_args()
	var hero: String = a[0] if a.size() > 0 else "kayron"
	var zoom := float(a[1]) if a.size() > 1 else 1.0
	var tag: String = a[2] if a.size() > 2 else "z%.1f" % zoom
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://.atena/generated/bug-029-reducao/capturas"))
	Game.run_stage = "dagruve"
	Game.run_hero = hero
	var run: Node = load("res://ui/run.tscn").instantiate()
	add_child(run)
	await get_tree().create_timer(0.6).timeout
	run.set_process(false)
	run.set_physics_process(false)
	run.camera.zoom = Vector2(zoom, zoom)
	var key := StringName(hero)
	var base := float(HeroViewScript.HERO_DISPLAY_HEIGHT[key]) / float(HeroViewScript.HERO_IDLE_ART_HEIGHT[key])
	var sheet := Image.create(VARIANTS.size() * CROP.x * SCALE, 2 * CROP.y * SCALE, false, Image.FORMAT_RGBA8)
	for col in VARIANTS.size():
		var variant: String = VARIANTS[col]
		HeroViewScript.strip_override = {key: {}} if variant == "original" else {}  # {} = conjunto original, mesmo com HERO_STRIP_SET preenchido
		if variant in ["a", "b", "c"]:
			HeroViewScript.strip_override[key] = {"dir": "res://assets/animations/heroes_screen_preview/%s/%s" % [variant, hero], "factor": base * (2.0 if variant == "c" else 1.0), "pad": 2}
		run.hero_node.call("_build_animations")
		for row in 2:
			var sprite: AnimatedSprite2D = run.hero_node.sprite
			if row == 0:
				sprite.play(&"idle")
				sprite.frame = 1
			else:
				sprite.play(&"move_e")
				sprite.frame = 2
			sprite.pause()
			run.camera.position = run.hero_node.position + Vector2(0, -float(HeroViewScript.HERO_DISPLAY_HEIGHT[key]) * 0.5)
			await get_tree().create_timer(0.2).timeout
			await RenderingServer.frame_post_draw
			var shot := get_viewport().get_texture().get_image()
			var center := Vector2i(shot.get_width() / 2, shot.get_height() / 2)
			var piece := shot.get_region(Rect2i(center - CROP / 2, CROP))
			piece.resize(CROP.x * SCALE, CROP.y * SCALE, Image.INTERPOLATE_NEAREST)
			sheet.blit_rect(piece, Rect2i(Vector2i.ZERO, piece.get_size()), Vector2i(col * CROP.x * SCALE, row * CROP.y * SCALE))
	sheet.save_png(ProjectSettings.globalize_path("res://.atena/generated/bug-029-reducao/capturas/%s_%s.png" % [hero, tag]))
	print("capture_hero_variants: %s zoom=%.1f" % [hero, zoom])
	get_tree().quit()
