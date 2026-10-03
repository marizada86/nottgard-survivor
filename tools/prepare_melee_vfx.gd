extends SceneTree
## Empacotamento técnico: mantém o pivô e converte luminância em alfa.

func _init() -> void:
	for shape in ["corte_medio", "arco_largo", "estocada_longa", "chicote"]:
		var strip := Image.create(1536, 256, false, Image.FORMAT_RGBA8)
		for frame in 6:
			var version := "02" if shape == "corte_medio" and frame == 2 else "01"
			var path := "res://.atena/generated/art-candidates/vfx-pilot/melee_fisico_%s_%02d_v%s.png" % [shape, frame + 1, version]
			if shape == "estocada_longa":
				var state: String = ["start", "sweep", "peak", "hold", "fade", "dissipate"][frame]
				version = "02" if frame == 2 else "01"
				path = "res://.atena/generated/art-candidates/vfx/estocada_longa/estocada_longa_%s_v%s.png" % [state, version]
			if shape == "chicote":
				var state: String = ["start", "sweep", "peak", "hold", "fade", "dissipate"][frame]
				version = "02" if frame < 2 else "01"
				path = "res://.atena/generated/art-candidates/vfx/chicote/chicote_%s_v%s.png" % [state, version]
			var source := Image.load_from_file(path)
			if source == null:
				push_error("Missing candidate: " + path)
				quit(1)
				return
			source.resize(256, 256, Image.INTERPOLATE_LANCZOS)
			for y in 256:
				for x in 256:
					# Todas as matrizes C compartilham origem x=116/256. Ajuste técnico
					# único: origem no centro e ponta dentro do raio de 45%.
					var sample_x := int(round((x - 128.0) / 0.9 + 116.0)) if shape == "estocada_longa" else x
					var sample_y := y
					if shape == "chicote":
						# Transformação constante: origem (104,122) e raio de 45%.
						sample_x = int(round((x - 128.0) / 0.79 + 104.0))
						sample_y = int(round((y - 128.0) / 0.79 + 122.0))
					var pixel := source.get_pixel(sample_x, sample_y) if sample_x >= 0 and sample_x < 256 and sample_y >= 0 and sample_y < 256 else Color.BLACK
					var luminance := pixel.r * 0.2126 + pixel.g * 0.7152 + pixel.b * 0.0722
					strip.set_pixel(frame * 256 + x, y, Color(1, 1, 1, luminance))
		var output := "res://assets/vfx/melee_fisico_%s.png" % shape
		if shape == "estocada_longa":
			output = "res://assets/vfx/melee_estocada_longa.png"
		if shape == "chicote":
			output = "res://assets/vfx/melee_chicote.png"
		var result := strip.save_png(output)
		print(output, " result=", result)
		if result != OK:
			quit(1)
			return
	quit()
