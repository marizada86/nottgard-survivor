extends Control
## Tela de título: fundo do portal abissal, logo (animado se houver sequência) e "Clique para jogar".
## Arte esperada em assets/ui/title/: title_background.png, logo.png ou logo_00.png, logo_01.png...
## Sem arte, a cena cai num fundo procedural e num logo em texto.

const ART_DIR := "res://assets/ui/title/"
const LOGO_FPS := 12.0
const PULSE_SECONDS := 1.6
const FADE_SECONDS := 0.5

var _prompt: Label
var _logo_frames: Array[Texture2D] = []
var _logo_rect: TextureRect
var _logo_time := 0.0
var _pulse_time := 0.0
var _leaving := false
var _fade: ColorRect

func _ready() -> void:
	Game.screen_name = "titulo"
	get_tree().paused = false
	RenderingServer.set_default_clear_color(Color(0.04, 0.03, 0.07))
	Sfx.stop_ambience()
	Sfx.start_music("menu")
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_build_background()
	_build_logo()
	_build_prompt()
	_fade = ColorRect.new()
	_fade.color = Color(0, 0, 0, 1)
	_fade.set_anchors_preset(Control.PRESET_FULL_RECT)
	_fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_fade)
	create_tween().tween_property(_fade, "color:a", 0.0, FADE_SECONDS)

func _build_background() -> void:
	var tex: Texture2D = load(ART_DIR + "title_background.png") if ResourceLoader.exists(ART_DIR + "title_background.png") else null
	if tex != null:
		var bg := TextureRect.new()
		bg.texture = tex
		bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		bg.set_anchors_preset(Control.PRESET_FULL_RECT)
		bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(bg)
		return
	var glow := GradientTexture2D.new()
	glow.fill = GradientTexture2D.FILL_RADIAL
	glow.fill_from = Vector2(0.5, 0.45)
	glow.fill_to = Vector2(0.5, 1.0)
	glow.gradient = Gradient.new()
	glow.gradient.colors = PackedColorArray([Color(0.42, 0.14, 0.62), Color(0.16, 0.06, 0.28), Color(0.04, 0.03, 0.07)])
	glow.gradient.offsets = PackedFloat32Array([0.0, 0.4, 1.0])
	var bg := TextureRect.new()
	bg.texture = glow
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_SCALE
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

func _build_logo() -> void:
	var i := 0
	while ResourceLoader.exists(ART_DIR + "logo_%02d.png" % i):
		_logo_frames.append(load(ART_DIR + "logo_%02d.png" % i))
		i += 1
	if _logo_frames.is_empty() and ResourceLoader.exists(ART_DIR + "logo.png"):
		_logo_frames.append(load(ART_DIR + "logo.png"))
	if _logo_frames.is_empty():
		var lab := Label.new()
		lab.text = Version.GAME_NAME
		lab.add_theme_font_override("font", load("res://assets/fonts/CinzelDecorative-Bold.ttf"))
		lab.add_theme_font_size_override("font_size", 72)
		lab.add_theme_color_override("font_color", Color(0.88, 0.8, 0.98))
		lab.add_theme_color_override("font_outline_color", Color(0.12, 0.03, 0.2))
		lab.add_theme_constant_override("outline_size", 10)
		lab.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lab.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		lab.set_anchors_preset(Control.PRESET_TOP_WIDE)
		lab.offset_top = 40
		lab.offset_bottom = 190
		lab.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(lab)
		return
	_logo_rect = TextureRect.new()
	_logo_rect.texture = _logo_frames[0]
	_logo_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_logo_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_logo_rect.set_anchors_preset(Control.PRESET_TOP_WIDE)
	_logo_rect.offset_top = 24
	_logo_rect.offset_bottom = 200
	_logo_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_logo_rect)

func _build_prompt() -> void:
	_prompt = Label.new()
	_prompt.text = "Clique para jogar"
	_prompt.add_theme_font_override("font", load("res://assets/fonts/CinzelDecorative-Bold.ttf"))
	_prompt.add_theme_font_size_override("font_size", 30)
	_prompt.add_theme_color_override("font_color", Color(0.92, 0.88, 0.98))
	_prompt.add_theme_color_override("font_outline_color", Color(0.1, 0.03, 0.18))
	_prompt.add_theme_constant_override("outline_size", 8)
	_prompt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_prompt.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	_prompt.offset_top = -110
	_prompt.offset_bottom = -50
	_prompt.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_prompt)

func _process(delta: float) -> void:
	_pulse_time += delta
	_prompt.modulate.a = 0.55 + 0.45 * (0.5 + 0.5 * sin(_pulse_time * TAU / PULSE_SECONDS))
	if _logo_frames.size() > 1:
		_logo_time += delta
		_logo_rect.texture = _logo_frames[int(_logo_time * LOGO_FPS) % _logo_frames.size()]

func _input(event: InputEvent) -> void:
	if _leaving:
		return
	var pressed: bool = (event is InputEventMouseButton and event.pressed) \
		or (event is InputEventKey and event.pressed and not event.echo) \
		or (event is InputEventJoypadButton and event.pressed) \
		or (event is InputEventScreenTouch and event.pressed)
	if pressed:
		_start()

func _start() -> void:
	_leaving = true
	Sfx.play("ui.click")
	var tw := create_tween()
	tw.tween_property(_fade, "color:a", 1.0, FADE_SECONDS)
	tw.tween_callback(Game.goto_menu)
