extends SceneTree
## SPEC-185 (PLAN-110, B-003): tiras de estado de atores (Manifestação de Juiblex, Mímico, Turíbulo) a partir dos PNGs individuais de 1254x1254 (LOT13 e LOT14).
## godot --headless --path . --script tools/prepare_actor_strips.gd -- <ator|all>
## Cada estado vira assets/animations/enemies/<id>/<estado>.png (quadros lado a lado). Todos os quadros do ator são reduzidos pelo MESMO fator, tirado do
## primeiro quadro do idle (altura visível = HT); a base de cada quadro vai para a linha dos pés (célula - 28 px) e o centro da parte baixa para o meio da célula:
## só translação, nenhum pixel é redesenhado. Só limpa o ruído de alfa < 16/255 e torna opaco o sólido (alfa >= 0,9).
## Imprime a entrada de `ANIMATED` e de `FEET_Y` (body_height casa o tamanho em tela com o da arte estática).

const ROOT := "res://.atena/generated/chatgpt-integration-2026-10-17/b003/"
const REPORT := "res://.atena/generated/chatgpt-integration-2026-10-17/b003/atores-preparacao.json"
const BASE_MIN_COVERAGE := 0.1
const CORE_FRACTION := 0.3
const FEET_MARGIN := 28
const SIDE_MARGIN := 12

## id: pasta, arte estática, altura visível do idle no quadro e estados (prefixo dos arquivos, quadros)
const ACTORS := {
	"manifestacao_de_juiblex": {"dir": "juiblex", "ht": 250.0, "states": {"idle": ["JI", 4], "move": ["JM", 6], "attack": ["JA", 4], "death": ["JD", 6], "special": ["JS", 6]}},
	"mimico": {"dir": "mimico", "ht": 300.0, "states": {"idle": ["MI", 4], "move": ["MM", 6], "attack": ["MA", 4], "death": ["MD", 6]}},
	"totem_de_chefe": {"dir": "totem", "ht": 300.0, "states": {"idle": ["TI", 4]}},
}

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
	var core_top := base - int(ceil((base - y0) * CORE_FRACTION))
	var sum_x := 0.0
	var n := 0
	for y in range(core_top, base):
		for x in range(x0, x1 + 1):
			if img.get_pixel(x, y).a > 0.5:
				sum_x += x
				n += 1
	return {"x0": x0, "y0": y0, "x1": x1 + 1, "y1": y1 + 1, "base": base, "h": base - y0, "w": x1 + 1 - x0, "core_cx": (sum_x / n + 0.5) if n > 0 else (x0 + x1 + 1) * 0.5}

static func clean(img: Image) -> Dictionary:
	img.convert(Image.FORMAT_RGBA8)
	var cleared := 0
	var solidified := 0
	for y in img.get_height():
		for x in img.get_width():
			var c := img.get_pixel(x, y)
			if c.a > 0.0 and c.a < 16.0 / 255.0:
				img.set_pixel(x, y, Color(0, 0, 0, 0))
				cleared += 1
			elif c.a >= 0.9 and c.a < 1.0:
				img.set_pixel(x, y, Color(c.r, c.g, c.b, 1.0))
				solidified += 1
	return {"cleared": cleared, "solidified": solidified}

func _init() -> void:
	var which := "all"
	for a in OS.get_cmdline_user_args():
		which = a
	var report: Dictionary = {}
	var rf := FileAccess.open(REPORT, FileAccess.READ)
	if rf != null:
		var parsed = JSON.parse_string(rf.get_as_text())
		if parsed is Dictionary:
			report = parsed
	for id in ACTORS:
		if which != "all" and which != id:
			continue
		var spec: Dictionary = ACTORS[id]
		var frames: Dictionary = {}   # estado -> Array de {img, box}
		var stats := {"cleared": 0, "solidified": 0}
		for state in spec.states:
			var prefix := String(spec.states[state][0])
			var count := int(spec.states[state][1])
			var list: Array = []
			for i in count:
				var img := Image.load_from_file(ProjectSettings.globalize_path("%s%s/%s%02d.png" % [ROOT, spec.dir, prefix, i]))
				var s := clean(img)
				stats.cleared += s.cleared
				stats.solidified += s.solidified
				list.append({"img": img, "box": visible_box(img)})
			frames[state] = list
		var idle0: Dictionary = frames["idle"][0].box
		var f: float = float(spec.ht) / float(idle0.h)
		# célula: largura pelo maior alcance horizontal a partir do centro, altura pela maior altura mais as margens
		var max_half := 0.0
		var max_h := 0.0
		for state in frames:
			for fr in frames[state]:
				var b: Dictionary = fr.box
				max_half = maxf(max_half, maxf((float(b.core_cx) - float(b.x0)) * f, (float(b.x1) - float(b.core_cx)) * f))
				max_h = maxf(max_h, float(b.h) * f)
		var cell_w := int(ceil((max_half * 2.0 + 2.0 * SIDE_MARGIN) / 32.0)) * 32
		var cell_h := int(ceil((max_h + FEET_MARGIN + 12.0) / 32.0)) * 32
		var feet := cell_h - FEET_MARGIN
		var shifts: Dictionary = {}
		var overflow := 0
		DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://assets/animations/enemies/%s" % id))
		for state in frames:
			var list: Array = frames[state]
			var strip := Image.create(cell_w * list.size(), cell_h, false, Image.FORMAT_RGBA8)
			var st: Array = []
			for i in list.size():
				var b: Dictionary = list[i].box
				var s: Image = list[i].img.duplicate()
				var nw := maxi(1, int(round(s.get_width() * f)))
				var nh := maxi(1, int(round(s.get_height() * f)))
				s.resize(nw, nh, Image.INTERPOLATE_LANCZOS)
				var px := int(round(cell_w * 0.5 - float(b.core_cx) * f))
				var py := int(round(feet - float(b.base) * f))
				var frame := Image.create(cell_w, cell_h, false, Image.FORMAT_RGBA8)
				frame.blend_rect(s, Rect2i(Vector2i.ZERO, s.get_size()), Vector2i(px, py))
				var used := s.get_used_rect()
				if px + used.position.x < 0 or py + used.position.y < 0 or px + used.end.x > cell_w or py + used.end.y > cell_h:
					for y in range(used.position.y, used.end.y):
						for x in range(used.position.x, used.end.x):
							var qx := x + px
							var qy := y + py
							if (qx < 0 or qy < 0 or qx >= cell_w or qy >= cell_h) and s.get_pixel(x, y).a >= 16.0 / 255.0:
								overflow += 1
				strip.blit_rect(frame, Rect2i(0, 0, cell_w, cell_h), Vector2i(i * cell_w, 0))
				st.append([snapped((float(b.core_cx) - float(idle0.core_cx)) * f, 0.1), snapped((float(b.base) - float(idle0.base)) * f, 0.1), snapped(float(b.h) * f, 0.1)])
			shifts[state] = st
			strip.save_png("res://assets/animations/enemies/%s/%s.png" % [id, state])
		# tamanho em tela igual ao da arte estática: body_height = HT x (altura da textura estática / altura visível da estática)
		var stat := Image.load_from_file(ProjectSettings.globalize_path("res://assets/enemies/%s.png" % id))
		stat.convert(Image.FORMAT_RGBA8)
		var sb := visible_box(stat)
		var body_height: float = float(spec.ht) * float(stat.get_height()) / float(sb.h)
		var states_text := ", ".join(frames.keys().map(func(k): return "\"%s\": %d" % [k, frames[k].size()]))
		print("%s: f=%.4f cell=%dx%d feet=%d body_height=%.1f overflow=%d" % [id, f, cell_w, cell_h, feet, body_height, overflow])
		print("  ANIMATED: \"%s\": {\"cell\": Vector2i(%d, %d), \"body_height\": %.1f, \"states\": {%s}, \"flip_h_for_move\": true}," % [id, cell_w, cell_h, body_height, states_text])
		print("  FEET_Y: \"%s\": %d.0," % [id, feet])
		report[id] = {"scale": snapped(f, 0.0001), "cell": [cell_w, cell_h], "feet": feet, "body_height": snapped(body_height, 0.1), "overflow_px": overflow, "alpha": stats, "shifts_core_base_height": shifts}
	var out := FileAccess.open(REPORT, FileAccess.WRITE)
	out.store_string(JSON.stringify(report, "\t"))
	quit()
