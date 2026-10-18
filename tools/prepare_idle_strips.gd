extends SceneTree
## SPEC-185 (PLAN-110, B-002): tiras de animação (idles e aberturas de baú) a partir das folhas do ChatGPT (LOT03, LOT06, LOT07, LOT09, LOT10, LOT11).
## godot --headless --path . --script tools/prepare_idle_strips.gd -- <grupo>      (grupos: chests | interactions | npcs | points | events | ruins | all)
##
## Cada quadro é reduzido pelo MESMO fator, tirado do primeiro quadro contra a arte estática (altura visível), e posto numa célula na ESCALA DA ARTE
## ESTÁTICA (1 px da célula = 1 px da textura estática) com PAD px de folga em volta: o primeiro quadro cobre a arte estática e o jogo desenha a tira
## no mesmo retângulo, só um pouco maior. O registro de cada quadro seguinte é corrigido só por translação (base e centro da parte baixa, como no quadro 0):
## nenhum pixel é redesenhado. Só limpa o ruído de alfa < 16/255 e torna opaco o sólido (alfa >= 0,9).
## Saída: assets/animations/interactions/<arte>_idle.png (ou chest_open/boss_chest_open), data/interaction_anims.json e um relatório.

const SRC := "res://.atena/generated/chatgpt-integration-2026-10-17/b002/idles/"
const REPORT := "res://.atena/generated/chatgpt-integration-2026-10-17/b002/idles-preparacao.json"
const TABLE := "res://data/interaction_anims.json"
const PAD := 48
const CHEST_PAD := 32
const BASE_MIN_COVERAGE := 0.1
const CORE_FRACTION := 0.3   # parte baixa do corpo usada para o centro horizontal

## [código, arquivo da fonte, layout, quadros, arte estática, tipo, grupo]
## layout: "row" (N colunas, partição inteira floor(i*W/N)) ou "grid:C,R" (leitura em ordem, linha a linha)
const JOBS := [
	["IA01", "IA01_v01", "grid:3,2", 6, "chest_closed", "chest", "chests"],
	["IA02", "IA02_v01", "grid:3,2", 6, "bau_chefe_fechado", "boss_chest", "chests"],
	["IA03", "IA03_v01", "grid:2,2", 4, "loja", "idle", "interactions"],
	["IA04", "IA04_v01", "grid:2,2", 4, "ferreiro", "idle", "interactions"],
	["IA05", "IA05_v01", "grid:2,2", 4, "curandeiro", "idle", "interactions"],
	["IE01", "IE01_v02", "grid:2,2", 4, "doacao", "idle", "interactions"],
	["IE02", "IE02_v01", "grid:2,2", 4, "aposta", "idle", "interactions"],
	["IE03", "IE03_v01", "grid:2,2", 4, "ampulheta", "idle", "interactions"],
	["IE04", "IE04_v02", "grid:2,2", 4, "arcanista", "idle", "interactions"],
	["IE05", "IE05_v01", "grid:2,2", 4, "peregrino", "idle", "interactions"],
	["IE06", "IE06_v01", "grid:2,2", 4, "contador", "idle", "interactions"],
	["NE01", "NE01_v01", "row", 4, "npc_joao_barbosa", "idle", "npcs"],
	["NE02", "NE02_v02", "row", 4, "npc_desertor_durao", "idle", "npcs"],
	["NE03", "NE03_v02", "row", 4, "npc_vitima_enfeiticada", "idle", "npcs"],
	["NE04", "NE04_v01", "row", 4, "npc_nyxara", "idle", "npcs"],
	["NE05", "NE05_v02", "row", 4, "npc_vaelis", "idle", "npcs"],
	["NE07", "NE07_v02", "row", 4, "npc_reaper_barqueiro", "idle", "npcs"],
	["NE08", "NE08_v01", "row", 4, "npc_vhaerith_aetherion", "idle", "npcs"],
	["NE09", "NE09_v01", "row", 4, "npc_mercador_rivenheart", "idle", "npcs"],
	["EP01", "EP01_v03", "row", 4, "trono_zuggtmoy", "idle", "points"],
	["EP02", "EP02_v02", "row", 4, "arco_pedra", "idle", "points"],
	["EP03", "EP03_v01", "row", 4, "massa_thullgrime", "idle", "points"],
	["EP04", "EP04_v01", "row", 4, "estrela_do_norte", "idle", "points"],
	["EP05", "EP05_v01", "row", 4, "coracao_limo", "idle", "points"],
	["EP06", "EP06_v01", "row", 4, "esporo_zuggtmoy", "idle", "points"],
	["EP07", "EP07_v01", "row", 4, "limo_juiblex", "idle", "points"],
	["ES01", "ES01_v02", "row", 4, "pacto_sangue", "idle", "events"],
	["ES02", "ES02_v01", "row", 4, "relicario", "idle", "events"],
	["ES03", "ES03_v01", "row", 4, "carroca", "idle", "events"],
	["ES04", "ES04_v03", "row", 4, "eclipse_pedra", "idle", "events"],
	["ES05", "ES05_v02", "row", 4, "eco", "idle", "events"],
	["ES06", "ES06_v01", "row", 4, "camara_selada", "idle", "events"],
	["ES07", "ES07_v03", "row", 4, "camara_aberta", "idle", "events"],
	["RU01", "RU01_v01", "row", 4, "ruina_dagruve", "idle", "ruins"],
	["RU02", "RU02_v01", "row", 4, "ruina_docas", "idle", "ruins"],
	["RU03", "RU03_v01", "row", 4, "ruina_shedaklah", "idle", "ruins"],
	["RU04", "RU04_v01", "row", 4, "ruina_molor", "idle", "ruins"],
	["RU06", "RU06_v02", "row", 4, "ruina_feng_tu", "idle", "ruins"],
]

## Retângulo visível (alfa > 0,5), linha da base (última linha com 10% da largura opaca) e centro horizontal da parte baixa.
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
	return {"x0": x0, "y0": y0, "x1": x1 + 1, "y1": y1 + 1, "base": base, "cx": (x0 + x1 + 1) * 0.5, "h": base - y0, "w": x1 + 1 - x0, "core_cx": (sum_x / n + 0.5) if n > 0 else (x0 + x1 + 1) * 0.5}

static func cell_rect(layout: String, count: int, index: int, w: int, h: int) -> Rect2i:
	if layout == "row":
		var x0 := int(floor(float(index) * w / count))
		var x1 := int(floor(float(index + 1) * w / count))
		return Rect2i(x0, 0, x1 - x0, h)
	var parts := layout.trim_prefix("grid:").split(",")
	var cols := int(parts[0])
	var rows := int(parts[1])
	var cw := w / cols
	var ch := h / rows
	return Rect2i((index % cols) * cw, (index / cols) * ch, cw, ch)

func _init() -> void:
	var group := "all"
	for a in OS.get_cmdline_user_args():
		group = a
	var report: Dictionary = {}
	var rf := FileAccess.open(REPORT, FileAccess.READ)
	if rf != null:
		var parsed = JSON.parse_string(rf.get_as_text())
		if parsed is Dictionary:
			report = parsed
	var table: Dictionary = {}
	var tf := FileAccess.open(TABLE, FileAccess.READ)
	if tf != null:
		var parsed_table = JSON.parse_string(tf.get_as_text())
		if parsed_table is Dictionary:
			table = parsed_table
	if not table.has("anims"):
		table = {"_nota": "SPEC-185 (PLAN-110, B-002): tiras de animação de interações, NPCs, pontos de evento, eventos, segredos e ruínas. Gerado por tools/prepare_idle_strips.gd; cada tira está na escala da arte estática, com `pad` px de folga em volta (célula = textura estática + 2 x pad). `mode`: loop.", "anims": {}}
	for job in JOBS:
		if group != "all" and group != String(job[6]):
			continue
		var code := String(job[0])
		var static_name := String(job[4])
		var kind := String(job[5])
		var src := Image.load_from_file(ProjectSettings.globalize_path(SRC + String(job[1]) + ".png"))
		var stat := Image.load_from_file(ProjectSettings.globalize_path("res://assets/interactions/%s.png" % static_name))
		if src == null or stat == null:
			report[code] = {"erro": "arquivo ausente (fonte ou arte estática)"}
			print(code, ": ERRO arquivo ausente")
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
		var count := int(job[3])
		var layout := String(job[2])
		var pad := CHEST_PAD if kind != "idle" else PAD
		var sb := visible_box(stat)
		var cells: Array = []
		var boxes: Array = []
		for i in count:
			var r := cell_rect(layout, count, i, src.get_width(), src.get_height())
			var cell := Image.create(r.size.x, r.size.y, false, Image.FORMAT_RGBA8)
			cell.blit_rect(src, r, Vector2i.ZERO)
			cells.append(cell)
			boxes.append(visible_box(cell))
		if sb.is_empty() or boxes[0].is_empty():
			report[code] = {"erro": "caixa visível vazia"}
			print(code, ": ERRO caixa vazia")
			continue
		var b0: Dictionary = boxes[0]
		var f: float = float(sb.h) / float(b0.h)
		var cw := stat.get_width() + 2 * pad
		var ch := stat.get_height() + 2 * pad
		var dest_x0: float = pad + float(sb.cx) - float(b0.cx) * f
		var dest_y0: float = pad + float(sb.base) - float(b0.base) * f
		var strip := Image.create(cw * count, ch, false, Image.FORMAT_RGBA8)
		var shifts: Array = []
		var overflow := 0
		for i in count:
			var bi: Dictionary = boxes[i]
			if bi.is_empty():
				shifts.append("vazio")
				continue
			var sx: float = (float(b0.core_cx) - float(bi.core_cx)) * f if i > 0 else 0.0
			var sy: float = (float(b0.base) - float(bi.base)) * f if i > 0 else 0.0
			shifts.append([snapped(sx, 0.1), snapped(sy, 0.1)])
			var s: Image = cells[i].duplicate()
			var nw := maxi(1, int(round(s.get_width() * f)))
			var nh := maxi(1, int(round(s.get_height() * f)))
			s.resize(nw, nh, Image.INTERPOLATE_LANCZOS)
			var px := int(round(dest_x0 + sx))
			var py := int(round(dest_y0 + sy))
			var frame := Image.create(cw, ch, false, Image.FORMAT_RGBA8)
			frame.blend_rect(s, Rect2i(Vector2i.ZERO, s.get_size()), Vector2i(px, py))
			var used := s.get_used_rect()
			if px + used.position.x < 0 or py + used.position.y < 0 or px + used.end.x > cw or py + used.end.y > ch:
				for y in range(used.position.y, used.end.y):
					for x in range(used.position.x, used.end.x):
						var qx := x + px
						var qy := y + py
						if (qx < 0 or qy < 0 or qx >= cw or qy >= ch) and s.get_pixel(x, y).a >= 16.0 / 255.0:
							overflow += 1
			strip.blit_rect(frame, Rect2i(0, 0, cw, ch), Vector2i(i * cw, 0))
		var out_name := ""
		match kind:
			"chest": out_name = "chest_open"
			"boss_chest": out_name = "boss_chest_open"
			_: out_name = "%s_idle" % static_name
		var out_path := "res://assets/animations/interactions/%s.png" % out_name
		if kind != "idle":
			var backup := "res://.atena/generated/chatgpt-integration-2026-10-17/b002/backup/%s_antes.png" % out_name
			if FileAccess.file_exists(out_path) and not FileAccess.file_exists(backup):
				DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(backup.get_base_dir()))
				DirAccess.copy_absolute(ProjectSettings.globalize_path(out_path), ProjectSettings.globalize_path(backup))
		strip.save_png(out_path)
		if kind == "idle":
			table["anims"][static_name] = {"strip": out_path, "frames": count, "cell": [cw, ch], "pad": pad, "fps": 5.0, "mode": "loop", "source": "%s %s" % [code, String(job[1])]}
		var width_ratio: float = float(b0.w) * f / float(sb.w)
		report[code] = {"fonte": job[1], "arte": static_name, "scale": snapped(f, 0.0001), "width_ratio_vs_static": snapped(width_ratio, 0.01), "cell": [cw, ch], "frames": count, "shifts": shifts,
			"alpha_cleared": cleared, "solidified": solidified, "overflow_px": overflow, "saida": out_name}
		print("%s -> %s: f=%.3f larg=%.2f overflow=%d shifts=%s" % [code, out_name, f, width_ratio, overflow, str(shifts)])
	var out := FileAccess.open(REPORT, FileAccess.WRITE)
	out.store_string(JSON.stringify(report, "\t"))
	var tout := FileAccess.open(TABLE, FileAccess.WRITE)
	tout.store_string(JSON.stringify(table, "\t"))
	quit()
