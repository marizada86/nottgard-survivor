extends SceneTree
## SPEC-176 (M1): junta quadros individuais (um PNG por quadro, mesmo tamanho, alfa real) numa grade, sem alterar pixels, para `m1_normalize_strip.gd --grid=CxR`.
## godot --headless --path . -s tools/m1_compose_grid.gd -- <saida.png> <colunas> <quadro1.png> <quadro2.png> ...
## Os quadros entram em ordem de leitura (esquerda para a direita, linha por linha).

func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() < 3:
		printerr("uso: -- <saida.png> <colunas> <quadro1.png> ...")
		quit(2)
		return
	var cols := int(args[1])
	var frames: Array[Image] = []
	for i in range(2, args.size()):
		var img := Image.load_from_file(args[i])
		if img == null or img.is_empty():
			printerr("não abriu ", args[i])
			quit(1)
			return
		img.convert(Image.FORMAT_RGBA8)
		frames.append(img)
	var w := frames[0].get_width()
	var h := frames[0].get_height()
	var rows := int(ceil(float(frames.size()) / cols))
	var out := Image.create(w * cols, h * rows, false, Image.FORMAT_RGBA8)
	for i in frames.size():
		out.blit_rect(frames[i], Rect2i(0, 0, w, h), Vector2i((i % cols) * w, (i / cols) * h))
	out.save_png(args[0])
	print("grade %dx%d de quadros %dx%d gravada em %s" % [cols, rows, w, h, args[0]])
	quit(0)
