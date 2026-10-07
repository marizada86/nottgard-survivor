class_name MobileControls
extends Control
## SPEC-134: cada dedo possui seu comando; o joystick produz somente movimento.

signal command(action: StringName)

const RADIUS := 72.0
const DEADZONE := 0.15
const MOUSE_FINGER := -2
var movement := Vector2.ZERO
var movement_finger := -1
var origin := Vector2.ZERO
var knob := Vector2.ZERO
var combat_enabled := false
var regions: Dictionary = {}
var labels: Dictionary = {}
var _fingers: Dictionary = {}
var ability_slot: AbilitySlot
var ability_ready := true

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	ability_slot = AbilitySlot.new()
	ability_slot.set_ability("", "", null, "Habilidade")
	ability_slot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(ability_slot)
	layout_controls(Game.touch_safe_rect())

func layout_controls(safe: Rect2) -> void:
	regions.clear()
	labels.clear()
	var unit := maxf(88, Game.touch_target_size())
	regions[&"hero_active"] = Rect2(safe.end - Vector2(unit + 16, unit + 16), Vector2(unit, unit))
	var interact_width := maxf(108, unit)
	regions[Game.ACTION_RUN_INTERACT] = Rect2(safe.end - Vector2(unit + 32 + interact_width, unit + 16), Vector2(interact_width, unit))
	regions[Game.ACTION_RUN_EXTRACT] = Rect2(safe.end - Vector2(unit + 16, 2 * unit + 32), Vector2(unit, unit))
	var top_actions := [Game.ACTION_RUN_PAUSE, Game.ACTION_RUN_ITEMS, &"touch_help", Game.ACTION_RUN_SPEED]
	for i in top_actions.size():
		regions[top_actions[i]] = Rect2(Vector2(safe.end.x - unit - i * (unit + 12), safe.position.y), Vector2(unit, maxf(64, Game.touch_target_size())))
	labels = {&"hero_active": "", Game.ACTION_RUN_PAUSE: "Pausa", Game.ACTION_RUN_ITEMS: "Ficha",
		&"touch_help": "Ajuda", Game.ACTION_RUN_SPEED: "1x"}
	if ability_slot != null:
		ability_slot.position = regions[&"hero_active"].position + (Vector2(unit, unit) - AbilitySlot.SIZE) * 0.5
	queue_redraw()

func set_combat_enabled(enabled: bool) -> void:
	if not enabled:
		clear_input()
	combat_enabled = enabled
	visible = enabled
	queue_redraw()

func clear_input() -> void:
	movement_finger = -1
	movement = Vector2.ZERO
	_fingers.clear()
	queue_redraw()

func configure(b: Battle) -> void:
	ability_ready = b.active_cd <= 0.0 and not b.hero.dead
	labels[Game.ACTION_RUN_SPEED] = b.speed_label() if b.can_speed_2x() else ""
	labels[Game.ACTION_RUN_INTERACT] = interaction_label(b)
	labels[Game.ACTION_RUN_EXTRACT] = "Extrair" if b.stage_cleared or b.final_victory else ""
	queue_redraw()

static func interaction_label(b: Battle) -> String:
	var nearest := 1.6
	var kind := ""
	for it in b.interactions:
		if not it.used and b.time - float(it.get("born_at", 0.0)) >= 0.65 and it.kind in ["altar", "ritual", "portal", "loja", "ferreiro", "curandeiro", "ampulheta", "doacao", "aposta", "event_pact"]:
			var distance: float = it.pos.distance_to(b.hero.pos)
			if distance <= nearest:
				nearest = distance
				kind = String(it.kind)
	return {"altar": "Rezar", "ritual": "Ativar", "portal": "Descer", "loja": "Comprar", "ferreiro": "Forjar",
		"curandeiro": "Curar", "ampulheta": "Girar", "doacao": "Doar", "aposta": "Apostar", "event_pact": "Conversar"}.get(kind, "")

func press(finger: int, point: Vector2, allow_movement: bool) -> bool:
	if not combat_enabled or _fingers.has(finger):
		return false
	for action in regions:
		if String(labels.get(action, "")) == "" and action != &"hero_active":
			continue
		if regions[action].has_point(point):
			_fingers[finger] = action
			if action != &"hero_active" or ability_ready:
				command.emit(action)
			return true
	var safe := Game.touch_safe_rect()
	if allow_movement and movement_finger == -1 and point.y > safe.position.y + safe.size.y * 0.35 and safe.has_point(point):
		movement_finger = finger
		origin = point
		knob = point
		_fingers[finger] = &"move"
		queue_redraw()
		return true
	return false

func drag(finger: int, point: Vector2) -> bool:
	if finger != movement_finger or movement_finger == -1:
		return _fingers.has(finger)
	var delta := (point - origin).limit_length(RADIUS)
	knob = origin + delta
	movement = delta.normalized() * inverse_lerp(DEADZONE, 1.0, delta.length() / RADIUS) if delta.length() > RADIUS * DEADZONE else Vector2.ZERO
	queue_redraw()
	return true

func release(finger: int) -> bool:
	var handled := _fingers.has(finger)
	_fingers.erase(finger)
	if movement_finger == finger:
		movement_finger = -1
		movement = Vector2.ZERO
		queue_redraw()
	return handled

func _input(event: InputEvent) -> void:
	if not combat_enabled:
		return
	var handled := false
	if event is InputEventScreenTouch:
		handled = press(event.index, event.position, false) if event.pressed and not event.canceled else release(event.index)
	elif event is InputEventScreenDrag:
		handled = drag(event.index, event.position)
	elif event is InputEventMouseButton and event.device != InputEvent.DEVICE_ID_EMULATION and event.button_index == MOUSE_BUTTON_LEFT:
		handled = press(MOUSE_FINGER, event.position, false) if event.pressed else release(MOUSE_FINGER)
	elif event is InputEventMouseMotion and event.device != InputEvent.DEVICE_ID_EMULATION:
		handled = drag(MOUSE_FINGER, event.position)
	if handled:
		get_viewport().set_input_as_handled()

func _unhandled_input(event: InputEvent) -> void:
	# Apenas depois da interface: um toque sobre um painel nunca inicia movimento.
	var handled := false
	if event is InputEventScreenTouch and event.pressed and not event.canceled:
		handled = press(event.index, event.position, true)
	elif event is InputEventMouseButton and event.device != InputEvent.DEVICE_ID_EMULATION and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		handled = press(MOUSE_FINGER, event.position, true)
	if handled:
		get_viewport().set_input_as_handled()

func _notification(what: int) -> void:
	if what in [NOTIFICATION_APPLICATION_FOCUS_OUT, NOTIFICATION_APPLICATION_PAUSED, NOTIFICATION_EXIT_TREE]:
		clear_input()

func _draw() -> void:
	if not combat_enabled:
		return
	var gold := Color(0.86, 0.72, 0.43, 0.8)
	for action in regions:
		if String(labels.get(action, "")) == "" and action != &"hero_active":
			continue
		var rect: Rect2 = regions[action]
		draw_style_box(_button_style(gold), rect)
		var text := String(labels.get(action, ""))
		if text != "":
			draw_string(ThemeDB.fallback_font, rect.position + Vector2(0, rect.size.y * 0.5 + 7), text, HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, 20, gold)
	if movement_finger != -1:
		draw_circle(origin, RADIUS, Color(0.04, 0.04, 0.08, 0.45))
		draw_arc(origin, RADIUS, 0, TAU, 48, gold, 2.0, true)
		draw_circle(knob, 26, Color(0.86, 0.72, 0.43, 0.5))

func _button_style(border: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.06, 0.05, 0.09, 0.72)
	style.border_color = border
	style.set_border_width_all(1)
	style.set_corner_radius_all(16)
	return style
