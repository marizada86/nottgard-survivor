class_name CursorSkin
extends RefCounted
## SPEC-132 (MEC-049): cursor temático do mouse, mapeado por forma do Godot.
## Sem a arte em assets/ui/cursor/ (ART-037) o cursor do sistema continua como está.
## O cursor é do sistema operacional: não escala com a janela e não aparece em capturas do viewport.

const DIR := "res://assets/ui/cursor/"
const MAX_SIZE := 64
const SLOTS := {
	"cursor_ponteiro": Input.CURSOR_ARROW,
	"cursor_mao": Input.CURSOR_POINTING_HAND,
	"cursor_mira": Input.CURSOR_CROSS,
}

static var _applied: Dictionary = {}
static var _default_shape: int = Input.CURSOR_ARROW

static func path_of(slot: String) -> String:
	return "%s%s.png" % [DIR, slot]

static func hotspot_of(slot: String) -> Vector2:
	var entry: Dictionary = Data.table("cursor").get(slot, {})
	var h: Array = entry.get("hotspot", [0, 0])
	return Vector2(float(h[0]), float(h[1]))

## Registra no motor os cursores cuja arte existe e cabe em MAX_SIZE. Devolve quantos foram aplicados.
static func apply() -> int:
	_applied.clear()
	for slot in SLOTS:
		var path := path_of(slot)
		if not ResourceLoader.exists(path):
			continue
		var tex := load(path) as Texture2D
		if tex == null or maxi(tex.get_width(), tex.get_height()) > MAX_SIZE:
			continue
		var hot := hotspot_of(slot).clamp(Vector2.ZERO, Vector2(tex.get_width() - 1, tex.get_height() - 1))
		Input.set_custom_mouse_cursor(tex, SLOTS[slot], hot)
		_applied[SLOTS[slot]] = true
	return _applied.size()

static func has_shape(shape: int) -> bool:
	return _applied.has(shape)

## Forma padrão (mouse fora de qualquer Control) na run: mira só com mira por mouse e sem modal aberto.
static func run_shape(aim_mouse: bool, modal_open: bool) -> int:
	if aim_mouse and not modal_open and has_shape(Input.CURSOR_CROSS):
		return Input.CURSOR_CROSS
	return Input.CURSOR_ARROW

static func sync_run(aim_mouse: bool, modal_open: bool) -> void:
	var shape := run_shape(aim_mouse, modal_open)
	if shape != _default_shape:
		_default_shape = shape
		Input.set_default_cursor_shape(shape as Input.CursorShape)

static func reset() -> void:
	sync_run(false, true)

## Aplica os cursores e põe a mão em todo botão que entrar na árvore (Control usa ARROW por padrão).
static func install(tree: SceneTree) -> void:
	apply()
	if not tree.node_added.is_connected(_on_node_added):
		tree.node_added.connect(_on_node_added)

static func _on_node_added(node: Node) -> void:
	if node is BaseButton and has_shape(Input.CURSOR_POINTING_HAND) and (node as BaseButton).mouse_default_cursor_shape == Control.CURSOR_ARROW:
		(node as BaseButton).mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
