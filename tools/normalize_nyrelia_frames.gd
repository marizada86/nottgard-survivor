extends SceneTree
## Gera candidatos de Nyrelia com a base estrutural alinhada por célula.

const CELL := Vector2i(256, 384)
## Inclui os contornos visíveis do corpo sem reagir a pixels quase transparentes.
const STRUCTURAL_ALPHA := 0.10
## Deixa 16 px de folga inferior e preserva os contornos da arte em todos os
## quadros analisados; o renderer alinha esta linha ao contato lógico.
const STRUCTURAL_BASELINE_Y := 368
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
	var root := "res://.atena/generated/animation-candidates/heroes/nyrelia/v01"
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(root))
	for sequence in SEQUENCES:
		_normalize(sequence, SEQUENCES[sequence], root)
	quit()

func _normalize(sequence: String, frame_count: int, output_root: String) -> void:
	var source_path := "res://assets/animations/heroes/nyrelia/%s.png" % sequence
	var source := Image.new()
	if source.load(ProjectSettings.globalize_path(source_path)) != OK:
		push_error("Nyrelia: não foi possível abrir %s" % source_path)
		return
	var result := Image.create(source.get_width(), source.get_height(), false, Image.FORMAT_RGBA8)
	result.fill(Color(0, 0, 0, 0))
	for frame in frame_count:
		var source_rect := Rect2i(frame * CELL.x, 0, CELL.x, CELL.y)
		var structural := _bounds(source, source_rect)
		if structural.size == Vector2i.ZERO:
			push_error("Nyrelia: célula vazia em %s[%d]" % [sequence, frame])
			return
		var delta_y := STRUCTURAL_BASELINE_Y - structural.end.y
		var destination := source_rect.position + Vector2i(0, delta_y)
		var faint := _bounds(source, source_rect, 0.04)
		if faint.position.y + delta_y < 0 or faint.end.y + delta_y > CELL.y:
			push_error("Nyrelia: normalização recortaria %s[%d]" % [sequence, frame])
			return
		var cell := source.get_region(source_rect)
		result.blit_rect(cell, Rect2i(Vector2i.ZERO, CELL), destination)
		print("%s[%d] shift_y=%d" % [sequence, frame, delta_y])
	var output := "%s/%s.png" % [output_root, sequence]
	if result.save_png(ProjectSettings.globalize_path(output)) != OK:
		push_error("Nyrelia: não foi possível salvar %s" % output)

func _bounds(image: Image, rect: Rect2i, alpha_threshold: float = STRUCTURAL_ALPHA) -> Rect2i:
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

