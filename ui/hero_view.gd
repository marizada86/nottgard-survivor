@tool
extends Node2D
## Visual do herói. A posição inicial do nó no editor é o ponto de partida da run.

const CELL := Vector2i(256, 384)
const DISPLAY_HEIGHT := 72.0
## A âncora é o pixel mais baixo da arte (ponta do pé da frente); erguer a sombra põe o corpo no meio dela.
const SHADOW_LIFT := 0.4
## Raio da sombra (px) por px de altura visível do personagem: grande tem sombra grande, pequeno, pequena.
const SHADOW_RADIUS_PER_HEIGHT := 0.2
## Linha (px na célula 256x384) em que ficam os pés no idle; o sprite é ancorado aí para tocar a sombra.
const HERO_FEET_Y := {
	&"korrak": 350.0, &"kayron": 376.0, &"sylas": 376.0, &"maelor": 364.0, &"nyrelia": 368.0,
	&"durvall": 376.0, &"zynara": 376.0, &"bromnor": 364.0, &"leoric": 368.0, &"brook": 368.0,
	&"arlindo": 376.0, &"erik": 376.0,   # SPEC-160: iguais aos de Sylas e Durvall (arte provisória por art_like)
}
## SPEC-154 (BUG-029): tiras pré-reduzidas para o tamanho de tela, por herói. `dir` = pasta das tiras reduzidas e `factor` = redução
## sobre a célula 256x384 (altura em tela / altura da arte, ou o dobro). Sem entrada vale o conjunto original. Reverter = apagar a entrada.
const HERO_STRIP_SET := {}   # vazio por decisão do dono (2026-10-09): a variante C do piloto do Kayron não agradou; o jogo usa as tiras originais
## Capturas e testes: sobrepõe a tabela sem mexer no código (herói -> {"dir", "factor", "pad"}).
static var strip_override := {}

static func strip_set(hero: String) -> Dictionary:
	var key := StringName(hero)
	if strip_override.has(key):
		return strip_override[key]
	return HERO_STRIP_SET.get(key, {})

static func strip_factor(hero: String) -> float:
	return float(strip_set(hero).get("factor", 1.0))

## Margem transparente (px) em volta de cada quadro reduzido, para nada ser cortado na borda da célula (`pad` da tabela).
static func strip_pad(hero: String) -> int:
	return int(strip_set(hero).get("pad", 0))

## Célula das tiras do herói: 256x384 no conjunto original; reduzida (arredondada para cima) mais a margem no conjunto reduzido.
## SPEC-160: sem arte própria (idle.png), o herói usa a animação de `art_like` (provisório, como o `icon_like` dos itens).
static func art_id(hero: String) -> String:
	if ResourceLoader.exists("res://assets/animations/heroes/%s/idle.png" % hero):
		return hero
	return String(Data.table("heroes").get(hero, {}).get("art_like", hero))

static func cell_of(hero: String) -> Vector2i:
	var f := strip_factor(hero)
	if f == 1.0:
		return CELL
	var pad := strip_pad(hero)
	return Vector2i(ceili(float(CELL.x) * f) + 2 * pad, ceili(float(CELL.y) * f) + 2 * pad)

## Altura do herói em tela (px), pela raça (humano 1,75 m = 64 px; piso de 40 px para os pequenos).
## Korrak 2,32 m e Leoric ~1 m vêm do Vault; as demais são médias de D&D.
const HERO_DISPLAY_HEIGHT := {
	&"korrak": 76.0, &"kayron": 66.0, &"sylas": 64.0, &"maelor": 64.0, &"nyrelia": 62.0,
	&"durvall": 60.0, &"zynara": 60.0, &"bromnor": 48.0, &"leoric": 40.0, &"brook": 40.0,
	&"arlindo": 62.0, &"erik": 64.0,   # SPEC-160: humanos (1,75 m = 64 px; Arlindo um pouco curvado)
}
## Altura visível (alfa) do idle de cada herói na célula 256x384; ver tools/audit_hero_motion.gd.
## Se a arte for regenerada, atualizar aqui (tests/test_animation_assets.gd confere).
const HERO_IDLE_ART_HEIGHT := {
	&"korrak": 267.0, &"kayron": 316.0, &"sylas": 304.0, &"maelor": 299.0, &"nyrelia": 352.0,
	&"durvall": 231.0, &"zynara": 368.0, &"bromnor": 241.0, &"leoric": 224.0, &"brook": 259.0,
	&"arlindo": 304.0, &"erik": 231.0,   # SPEC-160: altura do idle emprestado (Sylas, Durvall); trocar quando houver arte própria (alvos 290 e 300)
}
## Heróis cujas tiras de caminhada têm o machado cortado na borda da célula e proporção diferente do idle.
## Eles andam com o próprio idle (sem espelhar, para a arma ficar sempre do mesmo lado) e um balanço procedural.
## Vazio por decisão do dono (03/10): o Korrak voltou a andar só com as tiras, como antes do balanço procedural.
const PROCEDURAL_WALK_HEROES := []
## Heróis com suavização opcional (histerese de direção e tolerância de parada); vazio = comportamento original.
const WALK_SMOOTHING_HEROES := []
## Direções já regeneradas e aprovadas pela auditoria técnica (FILA-024).
## As direções oeste/sudoeste/noroeste usam as tiras validadas espelhadas e o norte usa a própria tira: andar com o idle
## deslizava sem pernas. O balanço procedural fica só para direções fora desta lista.
const VALIDATED_WALK_DIRECTIONS := {&"korrak": [&"move_e", &"move_se", &"move_s", &"move_ne", &"move_n", &"move_w", &"move_sw", &"move_nw"]}
## Sem quique vertical: o passo de quem anda com o idle é só uma inclinação suave (o quique parecia saltitar).
const WALK_BOB_PX := 0.0
## Histerese da direção: só troca de setor quando o movimento passa bem da fronteira (evita alternar tira/idle).
const WALK_SECTOR_HYSTERESIS := 0.75
## Ticks parados antes de voltar ao idle: bloqueios curtos (props, colisão) não alternam idle/caminhada a cada tick.
const WALK_STOP_GRACE_TICKS := 8
const WALK_SWAY_RAD := 0.045
const WALK_STEP_HZ := 3.2
const WALK_SETTLE_SPEED := 14.0
const WALK_DIRECTIONS := [&"e", &"se", &"s", &"sw", &"w", &"nw", &"n", &"ne"]
const WALK_SOURCE_DIRECTIONS := [&"e", &"se", &"s", &"n", &"ne"]
const MIRRORED_WALK_ANIMATIONS := {
	&"move_w": &"move_e",
	&"move_nw": &"move_ne",
	&"move_sw": &"move_se",
}

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
var _walking := false
var _procedural_walking := false
var _walk_phase := 0.0
var _walk_sector := -1
var _still_ticks := 0

## Diagnóstico opt-in do BUG-028 (SPEC-144); tudo isto fica nulo/falso sem --walk-debug.
var _trace: WalkTrace = null
var _dbg_ready := false
var _dbg_smooth := false
var _dbg_force := Vector2.ZERO

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
	var strips := strip_set(_active_hero_id)
	var root := String(strips.get("dir", "res://assets/animations/heroes/%s" % art_id(_active_hero_id)))
	var cell := cell_of(_active_hero_id)
	_has_animation = false
	_has_animation = SpriteStripFrames.add_strip(frames, &"idle", "%s/idle.png" % root, cell, 4, 8.0, true) or _has_animation
	_has_animation = SpriteStripFrames.add_strip(frames, &"move", "%s/move.png" % root, cell, 6, 10.0, true) or _has_animation
	for direction in WALK_SOURCE_DIRECTIONS:
		var animation: StringName = StringName("move_%s" % direction)
		_has_animation = SpriteStripFrames.add_strip(frames, animation, "%s/%s.png" % [root, animation], cell, 6, 10.0, true) or _has_animation
	_has_animation = SpriteStripFrames.add_strip(frames, &"attack", "%s/attack.png" % root, cell, 4, 12.0, false) or _has_animation
	_has_animation = SpriteStripFrames.add_strip(frames, &"active", "%s/active.png" % root, cell, 6, 12.0, false) or _has_animation
	_has_animation = SpriteStripFrames.add_strip(frames, &"death", "%s/death.png" % root, cell, 6, 9.0, false) or _has_animation
	# Uma folha isolada nao deve ocultar o retrato estatico do heroi.
	_has_animation = frames.has_animation(&"idle")
	sprite.sprite_frames = frames
	sprite.visible = _has_animation
	# Ancora os pés (e não a borda da célula) na origem, onde fica a sombra.
	var baseline_y: float = HERO_FEET_Y.get(StringName(_active_hero_id), float(CELL.y)) * strip_factor(_active_hero_id) + float(strip_pad(_active_hero_id))
	sprite.offset = Vector2(0, cell.y * 0.5 - baseline_y)
	sprite.scale = Vector2.ONE * display_scale(_active_hero_id)
	sprite.position = Vector2.ZERO
	sprite.rotation = 0.0
	sprite.flip_h = false
	_walking = false
	if _has_animation and frames.has_animation(&"idle"):
		sprite.play(&"idle")

## Escala única do herói: altura-alvo em tela dividida pela altura do idle na célula.
static func display_scale(hero: String) -> float:
	var key := StringName(hero)
	if not HERO_DISPLAY_HEIGHT.has(key) or not HERO_IDLE_ART_HEIGHT.has(key):
		return DISPLAY_HEIGHT / CELL.y
	return float(HERO_DISPLAY_HEIGHT[key]) / (float(HERO_IDLE_ART_HEIGHT[key]) * strip_factor(hero))

func sync_visual(screen_position: Vector2, is_dead: bool, is_flash: bool) -> void:
	if not _dbg_ready:
		_walk_debug_setup()
	var trace_before := {}
	if _trace != null and _has_animation:
		trace_before = {"anim": sprite.animation, "frame": sprite.frame}
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
			var desired: StringName = &"idle"
			var smoothing := _dbg_smooth or WALK_SMOOTHING_HEROES.has(StringName(_active_hero_id))
			_still_ticks = 0 if moving else _still_ticks + 1
			var walking := moving or (smoothing and _walk_sector >= 0 and _still_ticks < WALK_STOP_GRACE_TICKS)
			if not walking:
				_walk_sector = -1
			_walking = walking
			var movement_delta := Vector2.ZERO
			if moving:
				movement_delta = _stable_direction(screen_position - _last_screen_position) if smoothing else screen_position - _last_screen_position
			elif walking:
				movement_delta = Vector2.RIGHT.rotated(_walk_sector * TAU / 8.0)
			if _dbg_force != Vector2.ZERO and walking:
				movement_delta = _dbg_force
			_procedural_walking = walking and uses_procedural_walk_for_direction(_active_hero_id, movement_delta)
			if uses_procedural_walk(_active_hero_id) and (not walking or _procedural_walking):
				sprite.flip_h = false
			elif walking:
				desired = _walk_animation(movement_delta)
				sprite.flip_h = walk_flips_horizontally(movement_delta)
				if uses_procedural_walk(_active_hero_id):
					sprite.position = Vector2.ZERO
					sprite.rotation = 0.0
			if sprite.animation != desired:
				sprite.play(desired)
	if _trace != null and _has_animation:
		_walk_debug_tick(screen_position, moving, trace_before)
	_last_screen_position = screen_position
	queue_redraw()

## Liga o diagnóstico uma vez (SPEC-144). Só o herói da run ("Hero") grava; cópias e visuais de menu ficam de fora.
func _walk_debug_setup() -> void:
	_dbg_ready = true
	if Engine.is_editor_hint() or not WalkTrace.enabled():
		return
	_dbg_smooth = WalkTrace.option("walk-smooth") != ""
	_dbg_force = WalkTrace.forced_direction()
	var fps := WalkTrace.option("walk-fps")
	if fps != "" and sprite != null and sprite.sprite_frames != null:
		for animation in sprite.sprite_frames.get_animation_names():
			if String(animation).begins_with("move"):
				sprite.sprite_frames.set_animation_speed(animation, float(fps))
	if name != &"Hero":
		return
	_trace = WalkTrace.open(_active_hero_id, get_instance_id())
	if _trace != null:
		if sprite != null:
			sprite.frame_changed.connect(_on_walk_debug_frame)
		if WalkTrace.option("walk-controls") != "":
			WalkDebugControls.install(get_tree())

func _walk_debug_tick(screen_position: Vector2, moving: bool, before: Dictionary) -> void:
	if _trace.owner_id != get_instance_id():
		return
	var delta := screen_position - _last_screen_position
	var sector := int(posmod(roundi(delta.angle() / (TAU / 8.0)), 8)) if moving else -1
	var frames := sprite.sprite_frames.get_frame_count(sprite.animation) if sprite.sprite_frames.has_animation(sprite.animation) else 0
	var events := _trace.record_tick(screen_position, delta, moving, _still_ticks, sector, before, sprite.animation, sprite.frame, sprite.flip_h, sprite.speed_scale, WalkTrace.input_pressed(), frames)
	if not events.is_empty() and _trace.should_break(events):
		breakpoint  # SPEC-144: parou porque a condição de --walk-break foi atendida; veja `events` e `before`

func _on_walk_debug_frame() -> void:
	if _trace != null and _trace.owner_id == get_instance_id():
		_trace.record_frame(sprite.animation, sprite.frame)

func _exit_tree() -> void:
	if _trace != null and _trace.owner_id == get_instance_id():
		print("WalkTrace: ", _trace.summary())
		_trace.close()
		_trace = null

## Devolve o vetor unitário do setor de caminhada, mantendo o setor anterior perto da fronteira.
func _stable_direction(delta: Vector2) -> Vector2:
	if delta.length_squared() <= 0.04:
		return delta
	var step := TAU / 8.0
	var angle := delta.angle()
	var sector := int(posmod(roundi(angle / step), 8))
	if _walk_sector >= 0 and sector != _walk_sector and absf(wrapf(angle - _walk_sector * step, -PI, PI)) < step * WALK_SECTOR_HYSTERESIS:
		sector = _walk_sector
	_walk_sector = sector
	return Vector2.RIGHT.rotated(sector * step)

static func uses_procedural_walk(hero: String) -> bool:
	return PROCEDURAL_WALK_HEROES.has(StringName(hero))

static func uses_procedural_walk_for_direction(hero: String, direction: Vector2) -> bool:
	var validated: Array = VALIDATED_WALK_DIRECTIONS.get(StringName(hero), [])
	return uses_procedural_walk(hero) and not validated.has(directional_walk_animation(direction))

## Balanço do passo (quique e inclinação a partir dos pés) para quem anda com o idle.
func _process(delta: float) -> void:
	if sprite == null or not _has_animation or not uses_procedural_walk(_active_hero_id):
		return
	if _procedural_walking and not dead and not _action_locked:
		_walk_phase = fposmod(_walk_phase + delta * WALK_STEP_HZ * PI, TAU * 4.0)
		sprite.position.y = -absf(sin(_walk_phase)) * WALK_BOB_PX
		sprite.rotation = sin(_walk_phase * 0.5) * WALK_SWAY_RAD
	else:
		var k := clampf(delta * WALK_SETTLE_SPEED, 0.0, 1.0)
		sprite.position = sprite.position.lerp(Vector2.ZERO, k)
		sprite.rotation = lerpf(sprite.rotation, 0.0, k)

func play_action(action: StringName) -> void:
	if not _has_animation or dead or not sprite.sprite_frames.has_animation(action):
		return
	_action_locked = true
	sprite.play(action)

func _on_animation_finished() -> void:
	if sprite.animation == &"death":
		return
	_action_locked = false

func _walk_animation(delta: Vector2) -> StringName:
	var animation := walk_animation_for_direction(delta)
	return animation if sprite.sprite_frames.has_animation(animation) else &"move"

static func walk_animation_for_direction(delta: Vector2) -> StringName:
	var animation := directional_walk_animation(delta)
	return MIRRORED_WALK_ANIMATIONS.get(animation, animation)

static func walk_flips_horizontally(delta: Vector2) -> bool:
	return MIRRORED_WALK_ANIMATIONS.has(directional_walk_animation(delta))

static func directional_walk_animation(delta: Vector2) -> StringName:
	if delta.length_squared() <= 0.04:
		return &"move"
	var sector := int(posmod(roundi(delta.angle() / (TAU / 8.0)), 8))
	return StringName("move_%s" % WALK_DIRECTIONS[sector])

func _draw() -> void:
	var shadow_radius := float(HERO_DISPLAY_HEIGHT.get(StringName(_active_hero_id), DISPLAY_HEIGHT)) * SHADOW_RADIUS_PER_HEIGHT
	var ground := Vector2(0, -shadow_radius * Iso.TILE_H / Iso.TILE_W * SHADOW_LIFT)
	draw_colored_polygon(Iso.ground_circle(ground, shadow_radius), Color(0, 0, 0, 0.5))
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
