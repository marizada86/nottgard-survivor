extends SceneTree
## SPEC-154 (BUG-029): reduz as tiras de um herói (células 256x384) para o tamanho de tela, quadro a quadro.
##   godot --headless --path . -s tools/reduce_hero_strips.gd -- <heroi> <modo> <pasta-saida>
##   modo: a = média por área, fator = altura em tela / altura da arte (1:1 em tela)
##         b = Lanczos 3, mesmo fator (1:1, contorno mais marcado)
##         c = média por área, o dobro do fator (2:1 em tela, granulado fino)
##   pasta-saida: res://assets/animations/heroes_screen_preview/<modo>/<heroi> (ou outra dentro do projeto)
## Reduz cada quadro sozinho (nunca lê o quadro vizinho), com alfa pré-multiplicado, e é determinístico.
## Saída "REDUZIDO;..." (resumo) e "MEDIDA;..." (altura, pés, corte e solidez do idle contra o original).

const HeroViewScript := preload("res://ui/hero_view.gd")
const CELL := Vector2i(256, 384)
const ALPHA_VISIBLE := 8
## Margem transparente (px já reduzidos) em volta de cada quadro: nada que a redução gere (halo, suavização) pode ser cortado na borda da célula.
const PAD := 2

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() < 3:
		push_error("Uso: reduce_hero_strips.gd <heroi> <a|b|c> <pasta-saida>")
		quit(1)
		return
	var hero := String(args[0])
	var mode := String(args[1])
	var out_dir := String(args[2])
	var key := StringName(hero)
	if not HeroViewScript.HERO_DISPLAY_HEIGHT.has(key) or not HeroViewScript.HERO_IDLE_ART_HEIGHT.has(key) or not ["a", "b", "c"].has(mode):
		push_error("herói ou modo inválido: %s %s" % [hero, mode])
		quit(1)
		return
	var base := float(HeroViewScript.HERO_DISPLAY_HEIGHT[key]) / float(HeroViewScript.HERO_IDLE_ART_HEIGHT[key])
	var factor := base * (2.0 if mode == "c" else 1.0)
	var cell := Vector2i(ceili(CELL.x * factor) + 2 * PAD, ceili(CELL.y * factor) + 2 * PAD)
	var src_dir := "res://assets/animations/heroes/%s" % hero
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(out_dir))
	var files: Array = []
	for f in DirAccess.get_files_at(src_dir):
		if String(f).ends_with(".png"):
			files.append(String(f))
	files.sort()
	for f in files:
		var image := Image.load_from_file(ProjectSettings.globalize_path("%s/%s" % [src_dir, f]))
		image.convert(Image.FORMAT_RGBA8)
		var frames := image.get_width() / CELL.x
		var out := Image.create(frames * cell.x, cell.y, false, Image.FORMAT_RGBA8)
		for k in frames:
			var inner := Vector2i(cell.x - 2 * PAD, cell.y - 2 * PAD)
			var frame := _reduce_frame(image.get_region(Rect2i(k * CELL.x, 0, CELL.x, CELL.y)), factor, inner, mode == "b")
			out.blit_rect(frame, Rect2i(0, 0, inner.x, inner.y), Vector2i(k * cell.x + PAD, PAD))
		out.save_png(ProjectSettings.globalize_path("%s/%s" % [out_dir, f]))
		if f == "idle.png":
			_measure(hero, image, out, cell, factor)
	print("REDUZIDO;%s;%s;fator=%.5f;margem=%d;celula=%dx%d;arquivos=%d" % [hero, mode, factor, PAD, cell.x, cell.y, files.size()])
	quit()

## Pesos de reamostragem: para cada pixel de saída, a lista de pixels de origem (índice, peso), só dentro de [0, limit).
func _weights(out_n: int, limit: int, factor: float, lanczos: bool) -> Array:
	var all: Array = []
	for i in out_n:
		var center := (float(i) + 0.5) / factor
		var idx := PackedInt32Array()
		var w := PackedFloat32Array()
		if lanczos:
			var radius := 3.0 / factor
			for j in range(int(floor(center - radius)), int(ceil(center + radius)) + 1):
				if j < 0 or j >= limit:
					continue
				var d := (float(j) + 0.5 - center) * factor
				var weight := _lanczos(d)
				if weight != 0.0:
					idx.append(j)
					w.append(weight)
		else:
			var lo := float(i) / factor
			var hi := float(i + 1) / factor
			for j in range(int(floor(lo)), int(ceil(hi))):
				if j < 0 or j >= limit:
					continue
				var overlap := minf(float(j + 1), hi) - maxf(float(j), lo)
				if overlap > 0.0:
					idx.append(j)
					w.append(overlap)
		var total := 0.0
		for x in w:
			total += x
		if total != 0.0:
			for n in w.size():
				w[n] /= total
		all.append([idx, w])
	return all

static func _lanczos(x: float) -> float:
	var ax := absf(x)
	if ax < 1e-6:
		return 1.0
	if ax >= 3.0:
		return 0.0
	var px := PI * x
	return 3.0 * sin(px) * sin(px / 3.0) / (px * px)

func _reduce_frame(src: Image, factor: float, cell: Vector2i, lanczos: bool) -> Image:
	var sw := src.get_width()
	var sh := src.get_height()
	var data := src.get_data()
	# alfa pré-multiplicado em ponto flutuante: [r, g, b, a] por pixel
	var pre := PackedFloat32Array()
	pre.resize(sw * sh * 4)
	for p in sw * sh:
		var a := float(data[p * 4 + 3]) / 255.0
		pre[p * 4] = float(data[p * 4]) / 255.0 * a
		pre[p * 4 + 1] = float(data[p * 4 + 1]) / 255.0 * a
		pre[p * 4 + 2] = float(data[p * 4 + 2]) / 255.0 * a
		pre[p * 4 + 3] = a
	var wx := _weights(cell.x, sw, factor, lanczos)
	var wy := _weights(cell.y, sh, factor, lanczos)
	# passada horizontal: sh linhas x cell.x colunas
	var mid := PackedFloat32Array()
	mid.resize(sh * cell.x * 4)
	for y in sh:
		for x in cell.x:
			var idx: PackedInt32Array = wx[x][0]
			var w: PackedFloat32Array = wx[x][1]
			var r := 0.0
			var g := 0.0
			var b := 0.0
			var a := 0.0
			for n in idx.size():
				var o := (y * sw + idx[n]) * 4
				var weight := w[n]
				r += pre[o] * weight
				g += pre[o + 1] * weight
				b += pre[o + 2] * weight
				a += pre[o + 3] * weight
			var m := (y * cell.x + x) * 4
			mid[m] = r
			mid[m + 1] = g
			mid[m + 2] = b
			mid[m + 3] = a
	# passada vertical
	var out := PackedByteArray()
	out.resize(cell.x * cell.y * 4)
	for y in cell.y:
		var idy: PackedInt32Array = wy[y][0]
		var wv: PackedFloat32Array = wy[y][1]
		for x in cell.x:
			var r := 0.0
			var g := 0.0
			var b := 0.0
			var a := 0.0
			for n in idy.size():
				var o := (idy[n] * cell.x + x) * 4
				var weight := wv[n]
				r += mid[o] * weight
				g += mid[o + 1] * weight
				b += mid[o + 2] * weight
				a += mid[o + 3] * weight
			a = clampf(a, 0.0, 1.0)
			var q := (y * cell.x + x) * 4
			if a < 0.002:
				out[q] = 0
				out[q + 1] = 0
				out[q + 2] = 0
				out[q + 3] = 0
			else:
				out[q] = int(round(clampf(r / a, 0.0, 1.0) * 255.0))
				out[q + 1] = int(round(clampf(g / a, 0.0, 1.0) * 255.0))
				out[q + 2] = int(round(clampf(b / a, 0.0, 1.0) * 255.0))
				out[q + 3] = int(round(a * 255.0))
	return Image.create_from_data(cell.x, cell.y, false, Image.FORMAT_RGBA8, out)

## Altura, pés, corte nas bordas e solidez do primeiro quadro do idle, contra o original.
func _measure(hero: String, original: Image, reduced: Image, cell: Vector2i, factor: float) -> void:
	var o := _frame_stats(original.get_region(Rect2i(0, 0, CELL.x, CELL.y)))
	var r := _frame_stats(reduced.get_region(Rect2i(0, 0, cell.x, cell.y)))
	print("MEDIDA;%s;altura_orig=%d;altura_nova=%d;esperada=%.1f;pes_orig=%d;pes_novo=%d;pes_esperado=%.1f (com a margem);borda_orig=%d;borda_nova=%d;solidez_orig=%.3f;solidez_nova=%.3f" % [
		hero, o.height, r.height, float(o.height) * factor, o.feet, r.feet, float(o.feet) * factor + PAD, o.edge, r.edge, o.solidity, r.solidity])

func _frame_stats(frame: Image) -> Dictionary:
	var w := frame.get_width()
	var h := frame.get_height()
	var top := h
	var bottom := -1
	var edge := 0
	var visible := 0
	var solid := 0.0
	var core := 0
	for y in h:
		for x in w:
			var a := int(round(frame.get_pixel(x, y).a * 255.0))
			if a > ALPHA_VISIBLE:
				top = mini(top, y)
				bottom = maxi(bottom, y)
				visible += 1
				if a > 128:  # solidez do miolo: a borda suavizada da redução baixa a média de propósito
					core += 1
					solid += float(a) / 255.0
				if x == 0 or y == 0 or x == w - 1 or y == h - 1:
					edge += 1
	return {"height": (bottom - top + 1) if bottom >= 0 else 0, "feet": bottom + 1, "edge": edge, "solidity": (solid / float(core)) if core > 0 else 0.0}
