class_name WalkDebugControls
extends Node
## Controles do diagnóstico de caminhada (SPEC-144), só com `--walk-debug --walk-controls`.
## F9 congela/descongela a run; F10 avança exatamente um tick de física com a run congelada.
## Usa get_tree().paused: se a run já estiver pausada por um menu, F9 a descongela também.

var _stepping := false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_process_unhandled_key_input(true)

func _unhandled_key_input(event: InputEvent) -> void:
	var key := event as InputEventKey
	if key == null or not key.pressed or key.echo or _stepping:
		return
	var tree := get_tree()
	if key.keycode == KEY_F9:
		tree.paused = not tree.paused
		print("WalkTrace: run ", "congelada" if tree.paused else "livre")
	elif key.keycode == KEY_F10 and tree.paused:
		_step(tree)

func _step(tree: SceneTree) -> void:
	_stepping = true
	tree.paused = false
	await tree.physics_frame
	await tree.physics_frame
	tree.paused = true
	_stepping = false
	print("WalkTrace: avançou um tick")

## Instala os controles uma vez por árvore.
static func install(tree: SceneTree) -> void:
	if tree.root.get_node_or_null("WalkDebugControls") != null:
		return
	var controls: Node = load("res://ui/walk_debug_controls.gd").new()
	controls.name = "WalkDebugControls"
	tree.root.add_child.call_deferred(controls)
