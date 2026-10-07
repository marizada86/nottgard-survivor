extends SceneTree
## Normalizacao tecnica: recorte e escala, sem alterar a arte ou os originais.
const SOURCE := "res://.atena/generated/art-candidates/ficha-c/"
const OUTPUT := "res://.atena/generated/ficha-c-integration/v01/assets/"
const ENTRIES := [
	["ficha_moldura_painel", "v02", 1280, 720, Rect2i(29, 26, 1614, 885)],
	["ficha_moldura_detalhe", "v01", 512, 128, Rect2i(33, 129, 2105, 463)],
	["ficha_slot_moldura", "v01", 76, 76, Rect2i()],
	["ficha_slot_vazio", "v01", 76, 76, Rect2i()],
	["ficha_aba_moldura", "v01", 192, 40, Rect2i(77, 215, 2018, 295)],
	["ficha_aba_armas", "v01", 96, 96, Rect2i()],
	["ficha_aba_equipamento", "v01", 96, 96, Rect2i()],
	["ficha_aba_passivas", "v01", 96, 96, Rect2i()],
	["ficha_aba_sinergias", "v01", 96, 96, Rect2i()],
	["ficha_fundo_textura", "v03", 256, 256, Rect2i()],
]

func _init() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUTPUT))
	var records: Array = []
	for entry in ENTRIES:
		var source: String = SOURCE + entry[0] + "_" + entry[1] + ".png"
		var target: String = OUTPUT + entry[0] + ".png"
		var image := Image.load_from_file(source)
		if image == null:
			quit(1)
			return
		var original_size := image.get_size()
		var crop: Rect2i = entry[4]
		if crop.has_area():
			image = image.get_region(crop)
		image.resize(entry[2], entry[3], Image.INTERPOLATE_NEAREST)
		image.convert(Image.FORMAT_RGB8 if entry[0] == "ficha_fundo_textura" else Image.FORMAT_RGBA8)
		if image.save_png(target) != OK:
			quit(1)
			return
		records.append({"source": source, "output": target, "original_size": [original_size.x, original_size.y],
			"crop": [crop.position.x, crop.position.y, crop.size.x, crop.size.y],
			"size": [entry[2], entry[3]], "interpolation": "nearest", "creative_pixel_edit": false})
	var file := FileAccess.open(OUTPUT.get_base_dir() + "/normalization.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(records, "\t"))
	print("Normalizacao: ", records.size(), " arquivos")
	quit()
