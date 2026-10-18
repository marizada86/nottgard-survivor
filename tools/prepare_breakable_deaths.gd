extends SceneTree
## SPEC-185 (PLAN-110, B-002): tiras de morte dos 12 quebráveis (LOT04 e LOT05) a partir das grades 3x2 de 512x512 (5 quadros; o sexto é excluído).
## godot --headless --path . --script tools/prepare_breakable_deaths.gd
## Cada quadro é reduzido pelo MESMO fator, tirado do primeiro quadro contra a arte estática (altura visível), e posto numa célula de 512x512
## na escala da arte estática (1 px da célula = 1 px da textura estática): o primeiro quadro cobre a arte estática, a base fica na linha 432
## e nenhum quadro é recentralizado sozinho (os estilhaços caem onde a fonte os pôs).
## Só limpa o ruído de alfa < 16/255 e torna opaco o sólido (alfa >= 0,9); não mexe em cor, silhueta nem luz.

const SRC := "res://.atena/generated/chatgpt-integration-2026-10-17/b002/breakables/"
const REPORT := "res://.atena/generated/chatgpt-integration-2026-10-17/b002/breakables-preparacao.json"
const IDS := ["candelabro_quebravel", "caixote_quebravel", "arbusto_quebravel", "saco_de_esporos_quebravel", "casulo_viscoso_quebravel", "urna_funeraria_quebravel",
	"carroca_quebravel", "pilha_carga_quebravel", "lanterna_de_papel_quebravel", "espelho_ilusorio_quebravel", "estatua_rachada_quebravel", "relicario_instavel_quebravel"]
const GRID_CELL := 512
const FRAMES := 5
const CELL := 512
const BASELINE := 432
const BASE_MIN_COVERAGE := 0.1   # mesma regra de EnemyView._static_art_rect

## Retângulo visível (alfa > 0,5) e linha da base (última linha com 10% da largura opaca), como o EnemyView faz com a arte estática.
static func visible_box(img: Image) -> Dictionary:
	var used := img.get_used_rect()
	var x0 := img.get_width()
	var y0 := img.get_height()
	var x1 := -1
	var y1 := -1
	for y in range(used.position.y, used.end.y):
		for x in range(used.position.x, used.end.x):
			if img.get_pixel(x, y).a > 0.5:
				x0 = mini(x0, x)
				y0 = mini(y0, y)
				x1 = maxi(x1, x)
				y1 = maxi(y1, y)
	if x1 < 0:
		return {}
	var min_px := int(ceil((x1 - x0 + 1) * BASE_MIN_COVERAGE))
	var base := y1 + 1
	for y in range(y1, y0 - 1, -1):
		var opaque := 0
		for x in range(x0, x1 + 1):
			if img.get_pixel(x, y).a > 0.5:
				opaque += 1
		if opaque >= min_px:
			base = y + 1
			break
	return {"x0": x0, "y0": y0, "x1": x1 + 1, "y1": y1 + 1, "base": base, "cx": (x0 + x1 + 1) * 0.5, "h": base - y0}

func _init() -> void:
	var report: Dictionary = {}
	for id in IDS:
		var src := Image.load_from_file(ProjectSettings.globalize_path(SRC + id + ".png"))
		var stat := Image.load_from_file(ProjectSettings.globalize_path("res://assets/enemies/%s.png" % id))
		if src == null or stat == null:
			report[id] = {"erro": "arquivo ausente"}
			continue
		src.convert(Image.FORMAT_RGBA8)
		stat.convert(Image.FORMAT_RGBA8)
		var cleared := 0
		var solidified := 0
		for y in src.get_height():
			for x in src.get_width():
				var c := src.get_pixel(x, y)
				if c.a > 0.0 and c.a < 16.0 / 255.0:
					src.set_pixel(x, y, Color(0, 0, 0, 0))
					cleared += 1
				elif c.a >= 0.9 and c.a < 1.0:
					src.set_pixel(x, y, Color(c.r, c.g, c.b, 1.0))
					solidified += 1
		var sb := visible_box(stat)
		var cells: Array = []
		for i in FRAMES:
			var cell := Image.create(GRID_CELL, GRID_CELL, false, Image.FORMAT_RGBA8)
			cell.blit_rect(src, Rect2i((i % 3) * GRID_CELL, (i / 3) * GRID_CELL, GRID_CELL, GRID_CELL), Vector2i.ZERO)
			cells.append(cell)
		var b0 := visible_box(cells[0])
		if sb.is_empty() or b0.is_empty():
			report[id] = {"erro": "caixa visível vazia"}
			continue
		var f: float = float(sb.h) / float(b0.h)
		var static_cx: float = float(sb.cx) - stat.get_width() * 0.5   # deslocamento horizontal da arte estática em relação ao centro da textura
		var dest_x := int(round(CELL * 0.5 + static_cx - float(b0.cx) * f))
		var dest_y := int(round(BASELINE - float(b0.base) * f))
		var scaled_size := int(round(GRID_CELL * f))
		var strip := Image.create(CELL * FRAMES, CELL, false, Image.FORMAT_RGBA8)
		var overflow := 0
		var overflow_frames: Array = []
		for i in FRAMES:
			var s: Image = cells[i].duplicate()
			s.resize(scaled_size, scaled_size, Image.INTERPOLATE_LANCZOS)
			var frame := Image.create(CELL, CELL, false, Image.FORMAT_RGBA8)
			frame.blend_rect(s, Rect2i(Vector2i.ZERO, s.get_size()), Vector2i(dest_x, dest_y))
			# pixels do quadro original que cairiam fora da célula
			var used := s.get_used_rect()
			var out_px := 0
			if dest_x + used.position.x < 0 or dest_y + used.position.y < 0 or dest_x + used.end.x > CELL or dest_y + used.end.y > CELL:
				for y in range(used.position.y, used.end.y):
					for x in range(used.position.x, used.end.x):
						var px := x + dest_x
						var py := y + dest_y
						if (px < 0 or py < 0 or px >= CELL or py >= CELL) and s.get_pixel(x, y).a >= 16.0 / 255.0:
							out_px += 1
			overflow += out_px
			if out_px > 0:
				overflow_frames.append(i)
			strip.blit_rect(frame, Rect2i(0, 0, CELL, CELL), Vector2i(i * CELL, 0))
		var out_path := "res://assets/animations/enemies/%s/death.png" % id
		DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(out_path.get_base_dir()))
		strip.save_png(out_path)
		report[id] = {"scale": snapped(f, 0.0001), "static_box": [sb.x0, sb.y0, sb.x1, sb.y1, sb.base], "frame0_box": [b0.x0, b0.y0, b0.x1, b0.y1, b0.base],
			"dest": [dest_x, dest_y], "scaled_cell": scaled_size, "alpha_cleared": cleared, "solidified": solidified, "overflow_px": overflow, "overflow_frames": overflow_frames}
		print("%s: f=%.3f dest=(%d,%d) overflow=%d" % [id, f, dest_x, dest_y, overflow])
	var out := FileAccess.open(REPORT, FileAccess.WRITE)
	out.store_string(JSON.stringify(report, "\t"))
	quit()
