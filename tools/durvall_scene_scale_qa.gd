extends Node2D
## Compara a escala atual e o piloto no cenário real de Dagruve.

const STAGE := preload("res://ui/stages/dagruve.tscn")
const ENEMY_VIEW := preload("res://ui/enemy_view.tscn")
const PANEL_SIZE := Vector2i(640, 720)
const STAGE_ZOOM := Vector2(1.15, 1.15)
const BASE_SCALE := 72.0 / 384.0
const REJECTED_EAST_FACTOR := 1.296
const ENEMY_OFFSETS := [Vector2(-118, -20), Vector2(122, 14), Vector2(-14, -132), Vector2(25, 139)]
const BG := Color("17151d")
const TEXT := Color("eee7dc")
const MUTED := Color("bdb4c7")

func _ready() -> void:
	Playtest.visible = false
	for side in 2:
		_add_gameplay_panel(side)
	_add_header(18.0, "ATUAL — escala uniforme", "Dagruve · inimigos e props · zoom 1,15×")
	_add_header(658.0, "PILOTO — escala por direção", "Mesmo quadro e posicionamento")
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().create_timer(0.2).timeout
	var args := OS.get_cmdline_user_args()
	var output_path := String(args[0]) if not args.is_empty() else ".atena/evidence/EVID-132-durvall-cena-contexto-qa.png"
	var image := get_viewport().get_texture().get_image()
	if image == null:
		push_error("QA contextual Durvall: viewport sem imagem")
		get_tree().quit(1)
		return
	var status := image.save_png(output_path)
	if status != OK:
		push_error("QA contextual Durvall: não foi possível salvar %s" % output_path)
	get_tree().quit(0 if status == OK else 1)

func _add_gameplay_panel(side: int) -> void:
	var container := SubViewportContainer.new()
	container.position = Vector2(float(side) * PANEL_SIZE.x, 0.0)
	container.size = Vector2(PANEL_SIZE)
	container.stretch = true
	container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(container)

	var viewport := SubViewport.new()
	viewport.size = PANEL_SIZE
	viewport.transparent_bg = false
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	container.add_child(viewport)

	var stage := STAGE.instantiate()
	viewport.add_child(stage)
	var sorted: Node2D = stage.get_node("Sorted")
	var hero := sorted.get_node("Hero")
	hero.apply_hero("durvall")
	var hero_sprite: AnimatedSprite2D = hero.get_node("AnimatedSprite2D")
	hero_sprite.animation = &"move_e"
	hero_sprite.frame = 2
	hero_sprite.pause()
	hero_sprite.scale = Vector2.ONE * BASE_SCALE * (1.0 if side == 0 else REJECTED_EAST_FACTOR)

	for offset in ENEMY_OFFSETS:
		var model := Enemy.make("cultista_adaga", Iso.to_ground(hero.position + offset))
		var enemy_view := ENEMY_VIEW.instantiate()
		sorted.add_child(enemy_view)
		enemy_view.setup(model)
		var enemy_sprite: AnimatedSprite2D = enemy_view.get_node("AnimatedSprite2D")
		enemy_sprite.frame = 1
		enemy_sprite.pause()

	var camera := Camera2D.new()
	camera.position = hero.position
	camera.zoom = STAGE_ZOOM
	viewport.add_child(camera)
	camera.make_current()

func _add_header(x: float, title: String, subtitle: String) -> void:
	var backing := ColorRect.new()
	backing.position = Vector2(x - 8.0, 10.0)
	backing.size = Vector2(620.0, 48.0)
	backing.color = Color(BG, 0.88)
	backing.mouse_filter = Control.MOUSE_FILTER_IGNORE
	backing.z_index = 10
	add_child(backing)
	var heading := Label.new()
	heading.position = Vector2(x, 10.0)
	heading.text = title
	heading.add_theme_color_override("font_color", TEXT)
	heading.add_theme_font_size_override("font_size", 17)
	heading.mouse_filter = Control.MOUSE_FILTER_IGNORE
	heading.z_index = 11
	add_child(heading)
	var caption := Label.new()
	caption.position = Vector2(x, 34.0)
	caption.text = subtitle
	caption.add_theme_color_override("font_color", MUTED)
	caption.add_theme_font_size_override("font_size", 12)
	caption.mouse_filter = Control.MOUSE_FILTER_IGNORE
	caption.z_index = 11
	add_child(caption)
