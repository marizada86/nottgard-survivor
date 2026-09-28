@tool
extends Node2D
## Visual reutilizável de inimigo, com preview editável e fallback para a arte estática.

const H_BASE := 62.0
const ANIMATED := {
	"zumbi": {"cell": Vector2i(256, 384), "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}},
	"sacerdote_mente_derretida": {"cell": Vector2i(320, 480), "states": {"idle": 6, "move": 8, "attack": 6, "special_a": 8, "special_b": 8, "phase": 8, "death": 10}},
}
static var _tex_cache := {}

@export var preview_enemy_id := "zumbi": set = _set_preview_enemy_id
var enemy: Enemy
var tex: Texture2D
var _has_animation := false
var _action_locked := false
var _dying := false
var _last_screen_position := Vector2.ZERO
var _cell := Vector2i(256, 384)

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if not sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.connect(_on_animation_finished)
	if Engine.is_editor_hint():
		_apply_id(preview_enemy_id)
	_last_screen_position = position

func _set_preview_enemy_id(value: String) -> void:
	preview_enemy_id = value
	if is_node_ready() and Engine.is_editor_hint():
		_apply_id(value)

func setup(value: Enemy) -> void:
	enemy = value
	preview_enemy_id = value.id
	position = Iso.to_screen(value.pos)
	_apply_id(value.id)
	_last_screen_position = position

func _apply_id(enemy_id: String) -> void:
	var path := "res://assets/enemies/%s.png" % enemy_id
	if not _tex_cache.has(path):
		_tex_cache[path] = load(path) if ResourceLoader.exists(path) else null
	tex = _tex_cache[path]
	_build_animations(enemy_id)
	queue_redraw()

func _build_animations(enemy_id: String) -> void:
	var frames := SpriteStripFrames.empty()
	_has_animation = false
	if ANIMATED.has(enemy_id):
		var spec: Dictionary = ANIMATED[enemy_id]
		_cell = spec.cell
		for state in spec.states:
			var looped: bool = state in ["idle", "move"]
			var fps := 9.0 if state == "death" else (10.0 if looped else 12.0)
			_has_animation = SpriteStripFrames.add_strip(frames, state, "res://assets/animations/enemies/%s/%s.png" % [enemy_id, state], _cell, int(spec.states[state]), fps, looped) or _has_animation
	sprite.sprite_frames = frames
	sprite.visible = _has_animation
	sprite.offset = Vector2(0, -_cell.y * 0.5)
	_update_sprite_scale()
	if _has_animation and frames.has_animation(&"idle"):
		sprite.play(&"idle")

func _update_sprite_scale() -> void:
	var actor_scale := enemy.scale if enemy != null else 1.0
	sprite.scale = Vector2.ONE * (H_BASE * actor_scale / _cell.y)

func sync_visual(screen_position: Vector2) -> void:
	if _dying:
		return
	var moving := screen_position.distance_squared_to(_last_screen_position) > 0.04
	position = screen_position
	_last_screen_position = screen_position
	_update_sprite_scale()
	if _has_animation and not _action_locked:
		var desired: StringName = &"move" if moving else &"idle"
		if sprite.animation != desired:
			sprite.play(desired)
	_update_modulate()
	queue_redraw()

func play_action(action: StringName = &"attack") -> void:
	if not _has_animation or _dying:
		return
	if not sprite.sprite_frames.has_animation(action):
		action = &"attack"
	if sprite.sprite_frames.has_animation(action):
		_action_locked = true
		sprite.play(action)

func play_death() -> void:
	if _dying:
		return
	_dying = true
	if _has_animation and sprite.sprite_frames.has_animation(&"death"):
		_action_locked = true
		sprite.play(&"death")
	else:
		var tween := create_tween()
		tween.tween_property(self, "modulate:a", 0.0, 0.25)
		tween.tween_callback(queue_free)

func _on_animation_finished() -> void:
	if sprite.animation == &"death":
		queue_free()
		return
	_action_locked = false

func _update_modulate() -> void:
	if enemy == null:
		sprite.modulate = Color.WHITE
		return
	var alpha := 0.45 if enemy.has_flag("ghost") or enemy.has_flag("illusory") else 1.0
	if enemy.hit_flash > 0.0:
		sprite.modulate = Color(2.2, 2.2, 2.2, alpha)
	elif enemy.stun_t > 0.0:
		sprite.modulate = Color(0.6, 0.7, 1.4, alpha)
	elif enemy.slow_t > 0.0:
		sprite.modulate = Color(0.75, 0.9, 1.2, alpha)
	else:
		sprite.modulate = Color(1, 1, 1, alpha)

func _draw() -> void:
	if enemy == null and not Engine.is_editor_hint():
		return
	var actor_scale := enemy.scale if enemy != null else 1.0
	var alpha := 0.45 if enemy != null and (enemy.has_flag("ghost") or enemy.has_flag("illusory")) else 1.0
	draw_colored_polygon(PackedVector2Array([Vector2(0, -7 * actor_scale), Vector2(14 * actor_scale, 0), Vector2(0, 7 * actor_scale), Vector2(-14 * actor_scale, 0)]), Color(0, 0, 0, 0.5 * alpha))
	if enemy != null and enemy.affix != "":
		draw_arc(Vector2.ZERO, 16 * actor_scale, 0, TAU, 20, Color(1.0, 0.85, 0.3, 0.9), 2.0)
	if enemy != null and enemy.is_boss():
		draw_arc(Vector2.ZERO, 22 * actor_scale, 0, TAU, 24, Color(0.9, 0.2, 0.2, 0.9), 3.0)
	if tex != null and not _has_animation:
		var height := H_BASE * actor_scale
		var width := height * float(tex.get_width()) / float(tex.get_height())
		draw_texture_rect(tex, Rect2(-width * 0.5, -height, width, height), false)
	elif tex == null and not _has_animation:
		draw_rect(Rect2(-8 * actor_scale, -34 * actor_scale, 16 * actor_scale, 34 * actor_scale), Color(0.55, 0.15, 0.15))
	if enemy != null and (enemy.hp < enemy.max_hp or enemy.affix != "" or enemy.is_boss()):
		var top := -H_BASE * actor_scale - 6.0
		var fraction := clampf(enemy.hp / enemy.max_hp, 0.0, 1.0)
		var bar_width := 26.0 * maxf(1.0, actor_scale * 0.8)
		draw_rect(Rect2(-bar_width * 0.5, top, bar_width, 3), Color(0.12, 0, 0, 0.9))
		draw_rect(Rect2(-bar_width * 0.5, top, bar_width * fraction, 3), Color(0.8, 0.15, 0.15))
	if enemy != null and enemy.stun_t > 0.0:
		draw_string(ThemeDB.fallback_font, Vector2(-6, -H_BASE * actor_scale - 12), "✦", HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color(1, 1, 0.5))
