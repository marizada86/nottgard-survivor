extends SceneTree
## Auditoria local de limites por célula das folhas de Nyrelia.

const CELL := Vector2i(256, 384)
const SEQUENCES := {
	"idle": 4,
	"move_n": 6,
	"move_ne": 6,
	"move_e": 6,
	"move_se": 6,
	"move_s": 6,
	"attack": 4,
	"active": 6,
	"death": 6,
}

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	var root := String(args[0]) if not args.is_empty() else "assets/animations/heroes/nyrelia"
	for sequence in SEQUENCES:
		_analyze(root, sequence, SEQUENCES[sequence])
	quit()

func _analyze(root: String, sequence: String, frame_count: int) -> void:
	var path := "res://%s/%s.png" % [root, sequence]
	var image := Image.new()
	if image.load(ProjectSettings.globalize_path(path)) != OK:
		push_error("Nyrelia: não foi possível abrir %s" % path)
		return
	for frame in frame_count:
		var rect := Rect2i(frame * CELL.x, 0, CELL.x, CELL.y)
		var faint := _bounds(image, rect, 0.04)
		var body := _bounds(image, rect, 0.10)
		var structural := _bounds(image, rect, 0.35)
		print("%s[%d] faint=%s body=%s structural=%s" % [sequence, frame, faint, body, structural])

func _bounds(image: Image, rect: Rect2i, alpha_threshold: float) -> Rect2i:
	var min_x := rect.end.x
	var min_y := rect.end.y
	var max_x := rect.position.x - 1
	var max_y := rect.position.y - 1
	for y in range(rect.position.y, rect.end.y):
		for x in range(rect.position.x, rect.end.x):
			if image.get_pixel(x, y).a < alpha_threshold:
				continue
			min_x = min(min_x, x)
			min_y = min(min_y, y)
			max_x = max(max_x, x)
			max_y = max(max_y, y)
	if max_x < min_x or max_y < min_y:
		return Rect2i()
	return Rect2i(min_x - rect.position.x, min_y - rect.position.y, max_x - min_x + 1, max_y - min_y + 1)
