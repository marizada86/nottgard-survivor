extends SceneTree
## SPEC-176 (M1): normaliza uma tira devolvida pelo gerador para a grade do jogo, sem repintar nada.
## godot --headless --path . -s tools/m1_normalize_strip.gd -- <entrada.png> <saida.png> <quadros> [altura_alvo=231] [base_y=376] [celula_w=256] [celula_h=384]
##
## Separa os quadros por componentes conexos (alfa), aplica UMA escala para todos (média das alturas dos quadros com o pé no chão),
## ancora a base do pé de apoio em `base_y` (quadros no ar sobem na mesma proporção) e centra pela cabeça (centroide do topo).
## Imprime por quadro: altura, base, largura, margens e abertura dos pés (12% inferiores). Não altera a entrada.

const ALPHA := 0.15
const MIN_AREA := 2000

func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() < 3:
		printerr("uso: -- <entrada.png> <saida.png> <quadros> [altura_alvo] [base_y] [celula_w] [celula_h]")
		quit(2)
		return
	var frames_expected := int(args[2])
	var target_h := float(args[3]) if args.size() > 3 else 231.0
	var base_y := int(args[4]) if args.size() > 4 else 376
	var cell := Vector2i(int(args[5]) if args.size() > 5 else 256, int(args[6]) if args.size() > 6 else 384)
	var img := Image.new()
	if img.load(args[0]) != OK:
		printerr("não abriu ", args[0])
		quit(1)
		return
	img.convert(Image.FORMAT_RGBA8)
	var comps := _components(img)
	if comps.size() != frames_expected:
		printerr("quadros encontrados: %d, esperado %d" % [comps.size(), frames_expected])
		quit(1)
		return
	var max_base := 0
	for c in comps:
		max_base = maxi(max_base, c.y1)
	var ground: Array = comps.filter(func(c): return c.y1 >= max_base - 4)
	var mean_h := 0.0
	for c in ground:
		mean_h += float(c.y1 - c.y0 + 1)
	mean_h /= float(ground.size())
	var scale := target_h / mean_h
	print("escala=%.4f (altura média no chão %.1f -> %.0f); quadros no chão: %d de %d" % [scale, mean_h, target_h, ground.size(), comps.size()])
	var out := Image.create(cell.x * comps.size(), cell.y, false, Image.FORMAT_RGBA8)
	out.fill(Color(0, 0, 0, 0))
	print("quadro,altura,base,largura,margem_esq,margem_dir,margem_topo,margem_base,pes_abertura")
	for i in comps.size():
		var c: Dictionary = comps[i]
		var cw: int = c.x1 - c.x0 + 1
		var ch: int = c.y1 - c.y0 + 1
		var crop := Image.create(cw, ch, false, Image.FORMAT_RGBA8)
		crop.fill(Color(0, 0, 0, 0))
		for y in ch:
			for x in cw:
				if c.label[(c.y0 + y) * img.get_width() + c.x0 + x] == c.id:
					crop.set_pixel(x, y, img.get_pixel(c.x0 + x, c.y0 + y))
		var nw := maxi(1, roundi(cw * scale))
		var nh := maxi(1, roundi(ch * scale))
		crop.resize(nw, nh, Image.INTERPOLATE_LANCZOS)
		# âncora horizontal: centroide do topo (cabeça), estável no ciclo de corrida
		var top_rows := maxi(1, int(ch * 0.2))
		var sum_x := 0.0
		var cnt := 0
		for y in top_rows:
			for x in cw:
				if c.label[(c.y0 + y) * img.get_width() + c.x0 + x] == c.id:
					sum_x += x
					cnt += 1
		var head_x := (sum_x / maxf(cnt, 1.0)) * scale
		var left := roundi(cell.x * 0.5 - head_x)
		var top := roundi(base_y + 1 - (float(max_base - c.y0 + 1)) * scale)
		out.blit_rect(crop, Rect2i(0, 0, nw, nh), Vector2i(i * cell.x + left, top))
		# métricas no quadro final
		var spread := _foot_spread(crop, nh)
		print("%d,%d,%d,%d,%d,%d,%d,%d,%d" % [i + 1, nh, top + nh - 1, nw, left, cell.x - (left + nw), top, cell.y - (top + nh), spread])
	if out.save_png(args[1]) != OK:
		printerr("não gravou ", args[1])
		quit(1)
		return
	print("gravado: ", args[1])
	quit(0)

func _foot_spread(crop: Image, h: int) -> int:
	var y0 := int(h * 0.88)
	var min_x := 99999
	var max_x := -1
	for y in range(y0, h):
		for x in crop.get_width():
			if crop.get_pixel(x, y).a > 0.3:
				min_x = mini(min_x, x)
				max_x = maxi(max_x, x)
	return max_x - min_x + 1 if max_x >= 0 else 0

func _components(img: Image) -> Array:
	var w := img.get_width()
	var h := img.get_height()
	var label := PackedInt32Array()
	label.resize(w * h)
	var comps: Array = []
	var stack: Array[int] = []
	var id := 0
	for y in h:
		for x in w:
			var i := y * w + x
			if label[i] != 0 or img.get_pixel(x, y).a <= ALPHA:
				continue
			id += 1
			var x0 := x
			var x1 := x
			var y0 := y
			var y1 := y
			var area := 0
			label[i] = id
			stack.append(i)
			while not stack.is_empty():
				var p: int = stack.pop_back()
				var px := p % w
				var py := p / w
				area += 1
				x0 = mini(x0, px)
				x1 = maxi(x1, px)
				y0 = mini(y0, py)
				y1 = maxi(y1, py)
				for d in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
					var nx: int = px + d.x
					var ny: int = py + d.y
					if nx < 0 or ny < 0 or nx >= w or ny >= h:
						continue
					var ni := ny * w + nx
					if label[ni] == 0 and img.get_pixel(nx, ny).a > ALPHA:
						label[ni] = id
						stack.append(ni)
			if area >= MIN_AREA:
				comps.append({"id": id, "x0": x0, "x1": x1, "y0": y0, "y1": y1, "area": area, "label": label})
	comps.sort_custom(func(a, b): return a.x0 < b.x0)
	return comps
