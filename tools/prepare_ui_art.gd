extends SceneTree
## SPEC-185 (PLAN-110, B-001): preparação técnica das fontes de UI do ChatGPT (fundo magenta -> alfa, recorte e escala).
## godot --headless --path . --script tools/prepare_ui_art.gd -- <job>
## Jobs: button | markers | slots | pillar-audit | pillar
## Não muda direção, silhueta nem paleta: só remove o fundo (com erosão de 1 px), recorta pelo contorno e reduz.

const SRC := "res://.atena/generated/chatgpt-integration-2026-10-17/b001/fontes/"
const REPORT := "res://.atena/generated/chatgpt-integration-2026-10-17/b001/preparacao.json"

static func _magentaness(c: Color) -> float:
	return minf(c.r, c.b) - c.g

## Fundo magenta -> alfa 0; depois erosão de 1 px nas bordas e limpeza do halo rosado.
static func key_magenta(img: Image) -> Dictionary:
	img.convert(Image.FORMAT_RGBA8)
	var w := img.get_width()
	var h := img.get_height()
	var removed := 0
	for y in h:
		for x in w:
			var c := img.get_pixel(x, y)
			if _magentaness(c) > 0.40 and c.r > 0.55 and c.b > 0.55 and c.g < 0.45:
				img.set_pixel(x, y, Color(0, 0, 0, 0))
				removed += 1
	# erosão de 1 px (vizinhança de 4) e descarte do halo: pixel de borda ainda rosado perde o alfa
	var kill: Array = []
	for y in range(1, h - 1):
		for x in range(1, w - 1):
			if img.get_pixel(x, y).a == 0.0:
				continue
			var edge := img.get_pixel(x - 1, y).a == 0.0 or img.get_pixel(x + 1, y).a == 0.0 or img.get_pixel(x, y - 1).a == 0.0 or img.get_pixel(x, y + 1).a == 0.0
			if edge:
				kill.append(Vector2i(x, y))
	for p in kill:
		img.set_pixelv(p, Color(0, 0, 0, 0))
	# halo residual (contagem para o relatório)
	var halo := 0
	for y in range(1, h - 1):
		for x in range(1, w - 1):
			var c := img.get_pixel(x, y)
			if c.a > 0.0 and _magentaness(c) > 0.22 and c.r > 0.45 and c.b > 0.45:
				var near_clear := img.get_pixel(x - 1, y).a == 0.0 or img.get_pixel(x + 1, y).a == 0.0 or img.get_pixel(x, y - 1).a == 0.0 or img.get_pixel(x, y + 1).a == 0.0
				if near_clear:
					halo += 1
	return {"magenta_removed": removed, "eroded_edge_px": kill.size(), "halo_edge_px": halo}

static func bbox(img: Image, alpha_min: float = 0.05) -> Rect2i:
	var w := img.get_width()
	var h := img.get_height()
	var x0 := w
	var y0 := h
	var x1 := -1
	var y1 := -1
	for y in h:
		for x in w:
			if img.get_pixel(x, y).a > alpha_min:
				x0 = mini(x0, x)
				y0 = mini(y0, y)
				x1 = maxi(x1, x)
				y1 = maxi(y1, y)
	return Rect2i(x0, y0, x1 - x0 + 1, y1 - y0 + 1) if x1 >= 0 else Rect2i()

static func cropped(img: Image, r: Rect2i) -> Image:
	var out := Image.create(r.size.x, r.size.y, false, Image.FORMAT_RGBA8)
	out.blit_rect(img, r, Vector2i.ZERO)
	return out

## Reduz para caber em max_w x max_h sem distorcer; `canvas` (se maior que zero) centraliza em uma tela transparente.
static func fit(img: Image, max_w: int, max_h: int, canvas: Vector2i = Vector2i.ZERO) -> Image:
	var s := minf(float(max_w) / img.get_width(), float(max_h) / img.get_height())
	var nw := maxi(1, int(round(img.get_width() * s)))
	var nh := maxi(1, int(round(img.get_height() * s)))
	var out := img.duplicate()
	out.resize(nw, nh, Image.INTERPOLATE_LANCZOS)
	if canvas == Vector2i.ZERO:
		return out
	var tela := Image.create(canvas.x, canvas.y, false, Image.FORMAT_RGBA8)
	tela.blend_rect(out, Rect2i(Vector2i.ZERO, out.get_size()), Vector2i((canvas.x - nw) / 2, canvas.y - nh if canvas.y > nh else 0))
	return tela

func _save(img: Image, path: String) -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(path.get_base_dir()))
	img.save_png(path)

func _load(name: String) -> Image:
	return Image.load_from_file(ProjectSettings.globalize_path(SRC + name))

func _init() -> void:
	var job := ""
	for a in OS.get_cmdline_user_args():
		job = a
	var report: Dictionary = {}
	var f := FileAccess.open(REPORT, FileAccess.READ)
	if f != null:
		var parsed = JSON.parse_string(f.get_as_text())
		if parsed is Dictionary:
			report = parsed
	match job:
		"button":
			var img := _load("B01_v03.png")
			var stats := key_magenta(img)
			var box := bbox(img)
			var crop := cropped(img, box)
			var out := fit(crop, 378, 64)
			_save(out, "res://assets/ui/ficha/botao_acao_moldura.png")
			report["button"] = {"source": "B01_v03.png", "bbox": [box.position.x, box.position.y, box.size.x, box.size.y], "out": [out.get_width(), out.get_height()], "stats": stats}
		"markers":
			var img := _load("UI02_v01.png")
			img.convert(Image.FORMAT_RGBA8)
			var w := img.get_width()
			var left := cropped(img, Rect2i(0, 0, 887, img.get_height()))
			var right := cropped(img, Rect2i(887, 0, w - 887, img.get_height()))
			var info: Dictionary = {}
			for pair in [["marcador_jogador", left], ["marcador_chefe", right]]:
				var part: Image = pair[1]
				var stats := key_magenta(part)
				var box := bbox(part)
				var out := fit(cropped(part, box), 64, 64, Vector2i(64, 64))
				_save(out, "res://assets/ui/progresso/%s.png" % pair[0])
				info[pair[0]] = {"bbox": [box.position.x, box.position.y, box.size.x, box.size.y], "stats": stats}
			report["markers"] = info
		"slots":
			var info: Dictionary = {}
			for pair in [["UI03_v01.png", "casela_bloqueada"], ["UI04_v01.png", "casela_aberta"]]:
				var img := _load(pair[0])
				var stats := key_magenta(img)
				var box := bbox(img)
				var out := fit(cropped(img, box), 128, 128, Vector2i(128, 128))
				_save(out, "res://assets/ui/catalogo/%s.png" % pair[1])
				info[pair[1]] = {"bbox": [box.position.x, box.position.y, box.size.x, box.size.y], "stats": stats}
			report["slots"] = info
		"pillar":
			# SPEC-185 (LOT02 PR01): limpa só o ruído de alfa baixo fora do corpo, torna opaco o material sólido (alfa >= 0,9) e iguala altura, base e centro ao pilar_02 (256x256)
			var img := _load("PR01_v01.png")
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
			var ref := Image.load_from_file(ProjectSettings.globalize_path("res://assets/props/pilar_02.png"))
			ref.convert(Image.FORMAT_RGBA8)
			var rb := bbox(ref, 16.0 / 255.0)
			var box := bbox(img, 16.0 / 255.0)
			var part := cropped(img, box)
			var scaled := fit(part, 256, rb.size.y)
			var tela := Image.create(256, 256, false, Image.FORMAT_RGBA8)
			var dest := Vector2i(rb.position.x + rb.size.x / 2 - scaled.get_width() / 2, rb.end.y - scaled.get_height())
			tela.blend_rect(scaled, Rect2i(Vector2i.ZERO, scaled.get_size()), dest)
			_save(tela, "res://assets/props/pilar_01.png")
			report["pillar"] = {"ref_bbox": [rb.position.x, rb.position.y, rb.size.x, rb.size.y], "source_bbox": [box.position.x, box.position.y, box.size.x, box.size.y], "scaled": [scaled.get_width(), scaled.get_height()], "dest": [dest.x, dest.y], "low_alpha_cleared": cleared, "solidified": solidified}
		"pillar-audit":
			var img := _load("PR01_v01.png")
			img.convert(Image.FORMAT_RGBA8)
			var solid := bbox(img, 16.0 / 255.0)
			var any := bbox(img, 0.0)
			var low := 0
			var partial := 0
			var opaque := 0
			for y in img.get_height():
				for x in img.get_width():
					var a := img.get_pixel(x, y).a
					if a > 0.0 and a < 16.0 / 255.0:
						low += 1
					elif a >= 16.0 / 255.0 and a < 250.0 / 255.0:
						partial += 1
					elif a >= 250.0 / 255.0:
						opaque += 1
			report["pillar_audit"] = {"size": [img.get_width(), img.get_height()], "solid_bbox": [solid.position.x, solid.position.y, solid.size.x, solid.size.y],
				"any_alpha_bbox": [any.position.x, any.position.y, any.size.x, any.size.y], "low_alpha_px": low, "partial_alpha_px": partial, "opaque_px": opaque}
		_:
			print("job desconhecido: ", job)
	var out_file := FileAccess.open(REPORT, FileAccess.WRITE)
	out_file.store_string(JSON.stringify(report, "\t"))
	print(JSON.stringify(report.get(job if job != "pillar-audit" else "pillar_audit", {}), "  "))
	quit()
