@tool
extends Node2D
## Visual do herói. A posição inicial do nó no editor é o ponto de partida da run.

const CELL := Vector2i(256, 384)
const DISPLAY_HEIGHT := 72.0

@export var hero_id := "durvall": set = _set_hero_id
@export var body_color := Color(0.55, 0.15, 0.15): set = _set_body
@export var skin_color := Color(0.85, 0.75, 0.65)
@export var hair_color := Color(0.9, 0.9, 0.95)
var dead := false
var flash := false
var facing := Vector2(1, 1)
var hero_texture: Texture2D
var _action_locked := false
var _last_screen_position := Vector2.ZERO
var _has_animation := false
var _active_hero_id := "durvall"

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if not sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.connect(_on_animation_finished)
	apply_hero(hero_id)
	_last_screen_position = position

func _set_hero_id(value: String) -> void:
	hero_id = value
	if is_node_ready():
		apply_hero(hero_id)

func _set_body(value: Color) -> void:
	body_color = value
	queue_redraw()

func apply_hero(value: String) -> void:
	_active_hero_id = value
	if not Engine.is_editor_hint():
		var definition: Dictionary = Data.table("heroes")[value]
		body_color = Color(float(definition.color[0]) / 255.0, float(definition.color[1]) / 255.0, float(definition.color[2]) / 255.0)
		hair_color = Color(float(definition.hair[0]) / 255.0, float(definition.hair[1]) / 255.0, float(definition.hair[2]) / 255.0)
	var path := "res://assets/heroes/%s.png" % value
	hero_texture = load(path) if ResourceLoader.exists(path) else null
	_build_animations()
	queue_redraw()

func _build_animations() -> void:
	if not is_node_ready():
		return
	var frames := SpriteStripFrames.empty()
	var root := "res://assets/animations/heroes/%s" % _active_hero_id
	_has_animation = false
	_has_animation = SpriteStripFrames.add_strip(frames, &"idle", "%s/idle.png" % root, CELL, 4, 8.0, true) or _has_animation
	_has_animation = SpriteStripFrames.add_strip(frames, &"move", "%s/move.png" % root, CELL, 6, 10.0, true) or _has_animation
	_has_animation = SpriteStripFrames.add_strip(frames, &"attack", "%s/attack.png" % root, CELL, 4, 12.0, false) or _has_animation
	_has_animation = SpriteStripFrames.add_strip(frames, &"active", "%s/active.png" % root, CELL, 6, 12.0, false) or _has_animation
	_has_animation = SpriteStripFrames.add_strip(frames, &"death", "%s/death.png" % root, CELL, 6, 9.0, false) or _has_animation
	sprite.sprite_frames = frames
	sprite.visible = _has_animation
	sprite.offset = Vector2(0, -CELL.y * 0.5)
	sprite.scale = Vector2.ONE * (DISPLAY_HEIGHT / CELL.y)
	if _has_animation and frames.has_animation(&"idle"):
		sprite.play(&"idle")

func sync_visual(screen_position: Vector2, is_dead: bool, is_flash: bool) -> void:
	var moving := screen_position.distance_squared_to(_last_screen_position) > 0.04
	position = screen_position
	dead = is_dead
	flash = is_flash
	if _has_animation:
		sprite.modulate = Color(0.35, 0.35, 0.4, 0.65) if dead else (Color(1.5, 0.75, 0.75) if flash else Color.WHITE)
		if dead and sprite.animation != &"death":
			_action_locked = true
			sprite.play(&"death")
		elif not dead and not _action_locked:
			var desired: StringName = &"move" if moving else &"idle"
			if sprite.animation != desired:
				sprite.play(desired)
	_last_screen_position = screen_position
	queue_redraw()

func play_action(action: StringName) -> void:
	if not _has_animation or dead or not sprite.sprite_frames.has_animation(action):
		return
	_action_locked = true
	sprite.play(action)

func _on_animation_finished() -> void:
	if sprite.animation == &"death":
		return
	_action_locked = false

func _draw() -> void:
	draw_colored_polygon(PackedVector2Array([Vector2(0, -8), Vector2(16, 0), Vector2(0, 8), Vector2(-16, 0)]), Color(0, 0, 0, 0.5))
	var body := body_color
	if dead:
		body = body.darkened(0.6)
	elif flash:
		body = Color(1, 0.6, 0.6)
	if hero_texture != null and not _has_animation:
		var tint := Color(0.35, 0.35, 0.4, 0.65) if dead else (Color(1.5, 0.75, 0.75) if flash else Color.WHITE)
		var height := 72.0
		var width := height * float(hero_texture.get_width()) / float(hero_texture.get_height())
		draw_texture_rect(hero_texture, Rect2(-width * 0.5, -height, width, height), false, tint)
		return
	if not _has_animation:
		draw_rect(Rect2(-9, -40, 18, 40), body)
		draw_rect(Rect2(-9, -22, 18, 4), body.darkened(0.4))
		draw_circle(Vector2(0, -47), 8, skin_color)
		draw_arc(Vector2(0, -47), 8.5, PI, TAU, 12, hair_color, 4.0)
