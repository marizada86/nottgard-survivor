@tool
extends Node2D
## Visual reutilizável de inimigo, com preview editável e fallback para a arte estática.

const H_BASE := 62.0
## A âncora é o pixel mais baixo da arte (ponta do pé da frente); erguer a sombra põe o corpo no meio dela.
const SHADOW_LIFT := 0.4
## Raio da sombra (px) por px de altura visível do inimigo: grande tem sombra grande, pequeno, pequena.
const SHADOW_RADIUS_PER_HEIGHT := 0.2
const ANIMATED := {
	"sintese_abissal": {"cell": Vector2i(256, 384), "body_height": 218.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6, "special": 6}, "flip_h_for_move": true},
	"socothbenoth": {"cell": Vector2i(256, 384), "body_height": 188.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6, "special": 6}, "flip_h_for_move": true},
	"death_tyrant": {"cell": Vector2i(256, 384), "body_height": 176.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"ilusao_de_socothbenoth": {"source_id": "cultista_de_socothbenoth", "cell": Vector2i(256, 384), "body_height": 139.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"cultista_de_socothbenoth": {"cell": Vector2i(256, 384), "body_height": 139.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"guardiao_de_goranthis": {"cell": Vector2i(256, 384), "body_height": 150.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"malcanthet": {"cell": Vector2i(256, 384), "body_height": 161.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6, "special": 6}, "flip_h_for_move": true},
	"master_of_cruelties": {"cell": Vector2i(256, 384), "body_height": 129.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"guarda_do_castelo": {"cell": Vector2i(256, 384), "body_height": 128.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"ilusao_de_sucubo": {"source_id": "sucubo", "cell": Vector2i(256, 384), "body_height": 177.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"sucubo": {"cell": Vector2i(256, 384), "body_height": 177.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"escravo_de_rivenheart": {"cell": Vector2i(256, 384), "body_height": 153.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"lu_yueh": {"cell": Vector2i(256, 384), "body_height": 145.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6, "special": 6}, "flip_h_for_move": true},
	"discipulo_pestilento": {"cell": Vector2i(256, 384), "body_height": 171.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"cultista_ghaunadaur": {"cell": Vector2i(256, 384), "body_height": 153.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"estatua_do_templo": {"cell": Vector2i(256, 384), "body_height": 152.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"cultista_de_feng_tu": {"cell": Vector2i(256, 384), "body_height": 119.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"larva_de_lu_yueh": {"cell": Vector2i(256, 384), "body_height": 150.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"molydeus_menor": {"source_id": "molydeus_chefe", "cell": Vector2i(256, 384), "body_height": 101.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6, "special": 6}, "flip_h_for_move": true},
	"molydeus_chefe": {"cell": Vector2i(256, 384), "body_height": 101.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6, "special": 6}, "flip_h_for_move": true},
	"ezro": {"cell": Vector2i(256, 384), "body_height": 115.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"aberracao_shu": {"cell": Vector2i(256, 384), "body_height": 220.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"carcereiro_de_pedra": {"cell": Vector2i(256, 384), "body_height": 143.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"demonio_de_gehenna": {"cell": Vector2i(256, 384), "body_height": 144.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"alma_penada": {"cell": Vector2i(256, 384), "body_height": 258.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"zuggtmoy": {"cell": Vector2i(256, 384), "body_height": 185.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6, "special": 6}, "flip_h_for_move": true},
	"receptaculo_de_juiblex": {"cell": Vector2i(256, 384), "body_height": 143.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"gargula": {"cell": Vector2i(256, 384), "body_height": 118.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"pudim_negro": {"cell": Vector2i(256, 384), "body_height": 109.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"slime_de_juiblex": {"cell": Vector2i(256, 384), "body_height": 105.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"esporo_voador": {"cell": Vector2i(256, 384), "body_height": 190.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"cogumelo_fungico": {"cell": Vector2i(256, 384), "body_height": 188.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"servo_de_zuggtmoy": {"cell": Vector2i(256, 384), "body_height": 110.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"blogbog": {"cell": Vector2i(256, 384), "body_height": 248.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6, "special": 6}, "flip_h_for_move": true},
	"bolha_de_slime": {"cell": Vector2i(256, 384), "body_height": 180.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"cultista_thullgrime": {"cell": Vector2i(256, 384), "body_height": 302.0, "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"zumbi": {"cell": Vector2i(256, 384), "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}},
	"cultista_adaga": {"cell": Vector2i(256, 384), "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"sacerdote_mente_derretida": {"cell": Vector2i(320, 480), "states": {"idle": 6, "move": 8, "attack": 6, "special_a": 8, "special_b": 8, "phase": 8, "death": 10}},
	"slime_corrosivo": {"cell": Vector2i(256, 384), "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"cultista_arqueiro": {"cell": Vector2i(256, 384), "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"cultista_cajado": {"cell": Vector2i(256, 384), "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"notivago": {"cell": Vector2i(256, 384), "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"criatura_corrompida": {"cell": Vector2i(256, 384), "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"arch_hag": {"cell": Vector2i(256, 384), "states": {"idle": 4, "move": 6, "attack": 4, "death": 6}, "flip_h_for_move": true},
	"tentaculo_kraken": {"cell": Vector2i(256, 384), "states": {"idle": 4, "attack": 4, "death": 6}},
	"guardiao_verdadeiro": {"cell": Vector2i(320, 480), "states": {"idle": 4, "move": 6, "attack": 4, "special": 6, "death": 6}, "flip_h_for_move": true},
	"guardiao_copia": {"cell": Vector2i(320, 480), "states": {"idle": 4, "move": 6, "attack": 4, "special": 6, "death": 6}, "flip_h_for_move": true},
}
## Linha dos pés no idle (px na célula); ancora o sprite na sombra em vez da borda da célula.
const FEET_Y := {
	"sintese_abissal": 356.0,
	"socothbenoth": 356.0,
	"death_tyrant": 356.0,
	"ilusao_de_socothbenoth": 356.0,
	"cultista_de_socothbenoth": 356.0,
	"guardiao_de_goranthis": 356.0,
	"malcanthet": 356.0,
	"master_of_cruelties": 356.0,
	"guarda_do_castelo": 356.0,
	"ilusao_de_sucubo": 356.0,
	"sucubo": 356.0,
	"escravo_de_rivenheart": 356.0,
	"lu_yueh": 356.0,
	"discipulo_pestilento": 356.0,
	"cultista_ghaunadaur": 356.0,
	"estatua_do_templo": 356.0,
	"cultista_de_feng_tu": 356.0,
	"larva_de_lu_yueh": 356.0,
	"molydeus_menor": 356.0,
	"molydeus_chefe": 356.0,
	"ezro": 356.0,
	"aberracao_shu": 356.0,
	"carcereiro_de_pedra": 356.0,
	"demonio_de_gehenna": 356.0,
	"alma_penada": 356.0,
	"zuggtmoy": 356.0,
	"receptaculo_de_juiblex": 356.0,
	"gargula": 356.0,
	"pudim_negro": 356.0,
	"slime_de_juiblex": 356.0,
	"esporo_voador": 356.0,
	"cogumelo_fungico": 356.0,
	"servo_de_zuggtmoy": 356.0,
	"blogbog": 356.0,
	"bolha_de_slime": 356.0,
	"cultista_thullgrime": 356.0,
	"arch_hag": 380.0, "criatura_corrompida": 376.0, "cultista_adaga": 376.0, "cultista_arqueiro": 370.0,
	"cultista_cajado": 363.0, "guardiao_copia": 458.0, "guardiao_verdadeiro": 469.0, "notivago": 367.0,
	"sacerdote_mente_derretida": 472.0, "slime_corrosivo": 372.0, "tentaculo_kraken": 372.0, "zumbi": 376.0,
}
static var _tex_cache := {}
## Altura visível (alfa) do primeiro quadro do idle, em px da célula, por inimigo.
static var _art_height_cache := {}
## Área visível (alfa) da arte estática, em fração da textura; apoia a base real na sombra.
static var _static_art_cache := {}
## Raio mínimo da sombra (px) por px de largura visível da arte estática: carroça larga não fica com sombra de caixote.
const STATIC_SHADOW_RADIUS_PER_WIDTH := 0.3
## Fração da largura visível que uma linha precisa ter opaca para valer como base da arte estática.
const STATIC_BASE_MIN_COVERAGE := 0.1

@export var preview_enemy_id := "zumbi": set = _set_preview_enemy_id
var enemy: Enemy
var tex: Texture2D
var _has_animation := false
var _flip_h_for_move := false
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
	_flip_h_for_move = false
	if ANIMATED.has(enemy_id):
		var spec: Dictionary = ANIMATED[enemy_id]
		var source_id := String(spec.get("source_id", enemy_id))
		_cell = spec.cell
		_flip_h_for_move = bool(spec.get("flip_h_for_move", false))
		for state in spec.states:
			var looped: bool = state in ["idle", "move"]
			var fps := 9.0 if state == "death" else (10.0 if looped else 12.0)
			_has_animation = SpriteStripFrames.add_strip(frames, state, "res://assets/animations/enemies/%s/%s.png" % [source_id, state], _cell, int(spec.states[state]), fps, looped) or _has_animation
	sprite.sprite_frames = frames
	_cache_art_height(enemy_id, frames)
	sprite.visible = _has_animation
	sprite.flip_h = false
	sprite.offset = Vector2(0, _cell.y * 0.5 - float(FEET_Y.get(enemy_id, _cell.y)))
	_update_sprite_scale()
	if _has_animation and frames.has_animation(&"idle"):
		sprite.play(&"idle")

static func _cache_art_height(enemy_id: String, frames: SpriteFrames) -> void:
	if _art_height_cache.has(enemy_id) or not frames.has_animation(&"idle") or frames.get_frame_count(&"idle") == 0:
		return
	var image := frames.get_frame_texture(&"idle", 0).get_image()
	if image != null:
		_art_height_cache[enemy_id] = float(image.get_used_rect().size.y)

## Retângulo visível da textura estática normalizado (0..1); a base (end.y) é a última linha com massa
## de verdade, ignorando entulho solto e a margem transparente, que não contam como chão.
func _static_art_rect() -> Rect2:
	if not _static_art_cache.has(preview_enemy_id):
		var rect := Rect2(0, 0, 1, 1)
		var image := tex.get_image() if tex != null else null
		if image != null and image.get_width() > 0 and image.get_height() > 0:
			var used := image.get_used_rect()
			if used.size.x > 0 and used.size.y > 0:
				var min_pixels := int(ceil(used.size.x * STATIC_BASE_MIN_COVERAGE))
				var base := used.end.y
				for y in range(used.end.y - 1, used.position.y - 1, -1):
					var opaque := 0
					for x in range(used.position.x, used.end.x):
						if image.get_pixel(x, y).a > 0.5:
							opaque += 1
					if opaque >= min_pixels:
						base = y + 1
						break
				rect = Rect2(Vector2(used.position) / Vector2(image.get_size()), Vector2(used.size.x, base - used.position.y) / Vector2(image.get_size()))
		_static_art_cache[preview_enemy_id] = rect
	return _static_art_cache[preview_enemy_id]

## Altura do inimigo em tela (px); sem tira animada, a arte estática ocupa H_BASE.
func _visible_height(actor_scale: float) -> float:
	if _has_animation and _art_height_cache.has(preview_enemy_id):
		return float(_art_height_cache[preview_enemy_id]) * sprite.scale.y
	return H_BASE * actor_scale

func _update_sprite_scale() -> void:
	var actor_scale := enemy.scale if enemy != null else 1.0
	var spec: Dictionary = ANIMATED.get(preview_enemy_id, {})
	var body_height := float(spec.get("body_height", _cell.y))
	sprite.scale = Vector2.ONE * (H_BASE * actor_scale / body_height)

func sync_visual(screen_position: Vector2) -> void:
	if _dying:
		return
	var movement_delta := screen_position - _last_screen_position
	var moving := movement_delta.length_squared() > 0.04
	position = screen_position
	_last_screen_position = screen_position
	_update_sprite_scale()
	if _flip_h_for_move:
		if moving and absf(movement_delta.x) > 0.01:
			sprite.flip_h = movement_delta.x < 0.0
		elif not moving:
			sprite.flip_h = false
	if _has_animation and not _action_locked:
		var desired: StringName = &"move" if moving else &"idle"
		if sprite.animation != desired:
			sprite.play(desired)
	_update_modulate()
	queue_redraw()

func play_action(action: StringName = &"attack") -> void:
	if not _has_animation or _dying:
		return
	if _flip_h_for_move:
		sprite.flip_h = false
	if not sprite.sprite_frames.has_animation(action):
		action = &"attack"
	if sprite.sprite_frames.has_animation(action):
		_action_locked = true
		sprite.play(action)

func play_death() -> void:
	if _dying:
		return
	_dying = true
	if _flip_h_for_move:
		sprite.flip_h = false
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
	var shadow_radius := _visible_height(actor_scale) * SHADOW_RADIUS_PER_HEIGHT
	if tex != null and not _has_animation:
		var static_width := H_BASE * actor_scale * float(tex.get_width()) / float(tex.get_height()) * _static_art_rect().size.x
		shadow_radius = maxf(shadow_radius, static_width * STATIC_SHADOW_RADIUS_PER_WIDTH)
	var ground := Vector2(0, -shadow_radius * Iso.TILE_H / Iso.TILE_W * SHADOW_LIFT)
	draw_colored_polygon(Iso.ground_circle(ground, shadow_radius), Color(0, 0, 0, 0.5 * alpha))
	if enemy != null and (enemy.affix != "" or not enemy.affixes.is_empty()):
		var aura := Color(1.0, 0.85, 0.3, 0.9)
		for i in enemy.affixes.size():
			var tint: Color = Battle.AFFIX_COLORS.get(enemy.affixes[i], aura)
			draw_arc(ground, (16.0 + 3.0 * i) * actor_scale, 0, TAU, 20, Color(tint.r, tint.g, tint.b, 0.9), 2.0)
		if enemy.affixes.is_empty():
			draw_arc(ground, 16 * actor_scale, 0, TAU, 20, aura, 2.0)
		if enemy.has_affix("escudeiro"):
			var halo := Iso.ground_circle(ground, Battle.AFFIX_SHIELD_RADIUS * Iso.TILE_W * 0.7071, 32)
			halo.append(halo[0])
			draw_polyline(halo, Color(0.3, 0.8, 0.5, 0.25), 1.5)
	if enemy != null and enemy.is_boss():
		draw_arc(ground, 22 * actor_scale, 0, TAU, 24, Color(0.9, 0.2, 0.2, 0.9), 3.0)
	if tex != null and not _has_animation:
		var height := H_BASE * actor_scale
		var width := height * float(tex.get_width()) / float(tex.get_height())
		# A base visível (não a borda do arquivo) assenta no centro da sombra.
		var art := _static_art_rect()
		draw_texture_rect(tex, Rect2(-width * 0.5, ground.y - height * (art.position.y + art.size.y), width, height), false)
	elif tex == null and not _has_animation:
		draw_rect(Rect2(-8 * actor_scale, -34 * actor_scale, 16 * actor_scale, 34 * actor_scale), Color(0.55, 0.15, 0.15))
	if enemy != null and (enemy.hp < enemy.max_hp or enemy.affix != "" or not enemy.affixes.is_empty() or enemy.is_boss()):
		var top := -H_BASE * actor_scale - 6.0
		var fraction := clampf(enemy.hp / enemy.max_hp, 0.0, 1.0)
		var bar_width := 26.0 * maxf(1.0, actor_scale * 0.8)
		draw_rect(Rect2(-bar_width * 0.5, top, bar_width, 3), Color(0.12, 0, 0, 0.9))
		draw_rect(Rect2(-bar_width * 0.5, top, bar_width * fraction, 3), Color(0.8, 0.15, 0.15))
	if enemy != null and enemy.stun_t > 0.0:
		draw_string(ThemeDB.fallback_font, Vector2(-6, -H_BASE * actor_scale - 12), "✦", HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color(1, 1, 0.5))
