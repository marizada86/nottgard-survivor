extends SceneTree
## SPEC-154: confere se alguma tira tem pixel visível (alfa > 8) encostado na borda do quadro (corte) ou a 1 px dela.
##   godot --headless --path . -s tools/audit_strip_edges.gd -- <pasta-res://> <largura-da-celula> <altura-da-celula>
## Saída "BORDA;arquivo;quadro;lados;pixels_na_borda;pixels_a_1px" só para quadros com algo; "RESUMO;..." no fim.

const ALPHA_VISIBLE := 8

func _init() -> void:
	var a := OS.get_cmdline_user_args()
	var dir := String(a[0])
	var cw := int(a[1])
	var ch := int(a[2])
	var files: Array = []
	for f in DirAccess.get_files_at(dir):
		if String(f).ends_with(".png"):
			files.append(String(f))
	files.sort()
	var touching := 0
	var near := 0
	var frames_total := 0
	var per_file := {}
	for f in files:
		var image := Image.load_from_file(ProjectSettings.globalize_path("%s/%s" % [dir, f]))
		image.convert(Image.FORMAT_RGBA8)
		for k in image.get_width() / cw:
			frames_total += 1
			var sides := ""
			var on_edge := 0
			var one_in := 0
			var min_d := 9999
			for y in ch:
				for x in cw:
					if int(round(image.get_pixel(k * cw + x, y).a * 255.0)) <= ALPHA_VISIBLE:
						continue
					var d := mini(mini(x, y), mini(cw - 1 - x, ch - 1 - y))
					min_d = mini(min_d, d)
					if d == 0:
						on_edge += 1
						if x == 0 and not sides.contains("E"):
							sides += "E"
						if x == cw - 1 and not sides.contains("D"):
							sides += "D"
						if y == 0 and not sides.contains("C"):
							sides += "C"
						if y == ch - 1 and not sides.contains("B"):
							sides += "B"
					elif d == 1:
						one_in += 1
			per_file[f] = mini(int(per_file.get(f, 9999)), min_d)
			if on_edge > 0:
				touching += 1
			if on_edge > 0 or one_in > 0:
				near += 1
				print("BORDA;%s;%d;%s;%d;%d" % [f, k, sides, on_edge, one_in])
	for f in per_file:
		print("MARGEM;%s;menor_distancia_px=%d" % [f, per_file[f]])
	print("RESUMO;%s;quadros=%d;encostados=%d;com_algo_na_borda_ou_a_1px=%d" % [dir.get_file(), frames_total, touching, near])
	quit()
