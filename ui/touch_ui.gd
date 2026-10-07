class_name TouchUI
extends Node
## Toque confirma na soltura. Arrastar uma lista cancela a seleção do botão.

var ui_root: Node
var _gestures: Dictionary = {}
var _block_emulated_mouse := false

static func prepare(root: Node) -> void:
	if not Game.touch_controls_enabled():
		return
	adapt_sizes(root)
	if root.has_node("TouchUI"):
		return
	var router := TouchUI.new()
	router.name = "TouchUI"
	router.ui_root = root
	router.process_mode = Node.PROCESS_MODE_ALWAYS
	root.add_child(router)

static func adapt_sizes(node: Node) -> void:
	if node is BaseButton:
		node.custom_minimum_size.y = maxf(node.custom_minimum_size.y, Game.touch_target_size())
	if node is ItemList:
		node.fixed_icon_size.y = maxi(node.fixed_icon_size.y, 48)
		var font_height: float = node.get_theme_font("font").get_height(node.get_theme_font_size("font_size"))
		node.add_theme_constant_override("v_separation", maxi(12, int(Game.touch_target_size() - font_height)))
	if node is ScrollContainer:
		node.scroll_deadzone = 12
	for child in node.get_children():
		adapt_sizes(child)

func _pick(node: Node, point: Vector2) -> Control:
	if node is Control and not node.is_visible_in_tree():
		return null
	if node is Window:
		return null
	if node is ScrollContainer and not node.get_global_rect().has_point(point):
		return null
	var children := node.get_children()
	children.reverse()
	for child in children:
		var hit := _pick(child, point)
		if hit != null:
			return hit
	if node is Control and node.get_global_rect().has_point(point):
		if node is OptionButton or node is Slider or node is TabBar:
			return node
		if node is Button or node is ItemList or node is RichTextLabel or node is ScrollContainer:
			return node
	return null

func begin_touch(index: int, point: Vector2) -> bool:
	if _gestures.is_empty():
		_block_emulated_mouse = false
	var target := _pick(ui_root, point)
	if target == null or target is Slider or target is TabBar:
		return false
	var scroll: Range
	var ancestor: Node = target
	while ancestor != null and ancestor != ui_root:
		if ancestor is ScrollContainer:
			scroll = ancestor.get_v_scroll_bar()
			break
		ancestor = ancestor.get_parent()
	if target is ItemList or target is RichTextLabel:
		scroll = target.get_v_scroll_bar()
	_gestures[index] = {"target": target, "scroll": scroll, "start": point, "last": point, "dragged": false}
	_block_emulated_mouse = true
	return true

func move_touch(index: int, point: Vector2) -> bool:
	if not _gestures.has(index):
		return false
	var gesture: Dictionary = _gestures[index]
	if point.distance_to(gesture.start) > 12:
		gesture.dragged = true
	if gesture.dragged and is_instance_valid(gesture.scroll):
		gesture.scroll.value += float(gesture.last.y - point.y)
	gesture.last = point
	return true

func end_touch(index: int, point: Vector2, canceled: bool = false) -> bool:
	if not _gestures.has(index):
		return false
	var gesture: Dictionary = _gestures[index]
	_gestures.erase(index)
	var target: Control = gesture.target if is_instance_valid(gesture.target) else null
	if canceled or gesture.dragged or target == null or not target.is_visible_in_tree() or not target.get_global_rect().has_point(point):
		return true
	if target is OptionButton and not target.disabled:
		target.grab_focus()
		# Abrir após a sequência do toque evita que o mouse emulado atinja o popup.
		target.show_popup.call_deferred()
		target.pressed.emit()
	elif target is Button and not target.disabled:
		if target.toggle_mode:
			target.button_pressed = not target.button_pressed
		if target.focus_mode != Control.FOCUS_NONE:
			target.grab_focus()
		target.pressed.emit()
	elif target is ItemList:
		var item: int = target.get_item_at_position(point - target.global_position, true)
		if item >= 0 and not target.is_item_disabled(item):
			target.select(item)
			target.item_selected.emit(item)
	return true

func _input(event: InputEvent) -> void:
	if not Game.touch_controls_enabled():
		return
	# Um callback de botão pode trocar a cena e remover este router imediatamente.
	var viewport := get_viewport()
	# Os modais globais pertencem a outro CanvasLayer e recebem o toque primeiro.
	if ui_root != Playtest and (Playtest._guide_open or Playtest._note_open or Playtest._qa_open):
		_gestures.clear()
		_block_emulated_mouse = false
		return
	var handled := false
	if event is InputEventScreenTouch:
		if event.pressed and not event.canceled:
			handled = begin_touch(event.index, event.position)
		else:
			handled = end_touch(event.index, event.position, event.canceled)
	elif event is InputEventScreenDrag:
		handled = move_touch(event.index, event.position)
	elif event is InputEventMouse and event.device == InputEvent.DEVICE_ID_EMULATION and _block_emulated_mouse:
		handled = true
		if event is InputEventMouseButton and not event.pressed:
			_block_emulated_mouse = not _gestures.is_empty()
	if handled and is_instance_valid(viewport):
		viewport.set_input_as_handled()

func _notification(what: int) -> void:
	if what in [NOTIFICATION_APPLICATION_FOCUS_OUT, NOTIFICATION_APPLICATION_PAUSED, NOTIFICATION_EXIT_TREE]:
		_gestures.clear()
		_block_emulated_mouse = false
