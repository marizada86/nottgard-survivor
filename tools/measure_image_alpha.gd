extends SceneTree
## Mede a cobertura alfa amostrada de um PNG para validação de assets.

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 1:
		printerr("uso: measure_image_alpha.gd <imagem.png>")
		quit(2)
		return
	var image := Image.new()
	if image.load(args[0]) != OK:
		printerr("nao foi possivel abrir: %s" % args[0])
		quit(1)
		return
	var visible := 0
	var sampled := 0
	for y in range(0, image.get_height(), 8):
		for x in range(0, image.get_width(), 8):
			sampled += 1
			if image.get_pixel(x, y).a > 0.04:
				visible += 1
	print("coverage=%.5f alpha=%s size=%s" % [float(visible) / float(sampled), image.detect_alpha(), image.get_size()])
	quit()
