extends SceneTree
## S-003 do SPEC-121/vfx-projectiles-and-hero-abilities/v01: monta os atlas de runtime a partir das fontes
## nativas aceitas. Fontes intactas (hash conferido). Reducao Lanczos direta 1254 -> 256, RGB branco,
## alfa = luminancia Rec.709 com piso <= 2/255 igual a zero, pivo no centro da celula (128, 128).

const W := "res://.atena/generated/vfx-projectiles-hero-abilities-2026-10-13/"
const CELL := 256
const FLOOR := 2.0 / 255.0
const BBOX_THRESHOLD := 12.0 / 255.0

const OUT_NAMES := {
	"orbe_radiante": "orbe_radiante", "orbe_arcano": "orbe_arcano", "onda_cortante": "onda_cortante",
	"durvall_ruptura_sombria": "habilidade_durvall", "brook_guarda_de_lliira": "habilidade_brook",
	"maelor_comunhao": "habilidade_maelor", "sylas_passo_pelas_sombras": "habilidade_sylas",
	"kayron_sobrecarga_mistica": "habilidade_kayron", "korrak_impacto_de_xargath": "habilidade_korrak",
	"leoric_constelacao": "habilidade_leoric", "nyrelia_dominacao": "habilidade_nyrelia",
	"zynara_suspensao_temporal": "habilidade_zynara", "bromnor_concordia": "habilidade_bromnor",
}

func _initialize() -> void:
	var manifest: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(W + "manifest.json"))
	var out_atlas := ProjectSettings.globalize_path("res://assets/vfx/")
	var out_prev := ProjectSettings.globalize_path(W + "atlases/")
	DirAccess.make_dir_recursive_absolute(out_prev)
	var packing := {"revision": "vfx-projectiles-and-hero-abilities/v01", "content_state": "DRAFT", "cell": [CELL, CELL], "pivot": [128, 128],
		"resampling": "Godot Lanczos, 1254 direto para 256 (sem intermediario)", "rgb": "branco", "alpha": "luminancia Rec.709; <=2/255 vira 0",
		"effects": []}
	for group in ["A", "B"]:
		for effect in manifest.groups[group]:
			var n: int = effect.frames.size()
			var atlas := Image.create(n * CELL, CELL, false, Image.FORMAT_RGBA8)
			atlas.fill(Color(1, 1, 1, 0))
			var rows: Array = []
			for i in n:
				var fr: Dictionary = effect.frames[i]
				var path := W + String(fr.file)
				if FileAccess.get_sha256(path) != String(fr.sha256):
					push_error("hash divergente em " + path)
					quit(2)
					return
				var img := Image.load_from_file(ProjectSettings.globalize_path(path))
				img.convert(Image.FORMAT_RGBA8)
				img.resize(CELL, CELL, Image.INTERPOLATE_LANCZOS)
				var minx := CELL
				var miny := CELL
				var maxx := -1
				var maxy := -1
				var residual := 0
				for y in CELL:
					for x in CELL:
						var p := img.get_pixel(x, y)
						var light := p.r * 0.2126 + p.g * 0.7152 + p.b * 0.0722
						var a := 0.0 if light <= FLOOR else light
						atlas.set_pixel(i * CELL + x, y, Color(1, 1, 1, a))
						if a > BBOX_THRESHOLD:
							minx = mini(minx, x)
							maxx = maxi(maxx, x)
							miny = mini(miny, y)
							maxy = maxi(maxy, y)
							residual += 1
				rows.append({"code": fr.code, "version": fr.version, "source": fr.file, "source_sha256": fr.sha256,
					"offset": [i * CELL, 0], "bbox": [minx, miny, maxx + 1, maxy + 1], "pixels_alpha_gt12": residual})
			var name: String = OUT_NAMES[effect.id]
			assert(atlas.save_png(out_atlas + name + ".png") == OK)
			assert(atlas.save_png(out_prev + name + ".png") == OK)
			var prev := Image.create(n * CELL, CELL, false, Image.FORMAT_RGB8)
			for y in CELL:
				for x in n * CELL:
					var l := atlas.get_pixel(x, y).a
					prev.set_pixel(x, y, Color(l, l, l))
			prev.save_png(out_prev + name + "_preto.png")
			packing.effects.append({"group": group, "id": effect.id, "atlas": "assets/vfx/" + name + ".png", "frames": n, "records": rows})
			print("atlas ", name, " ", n, " celulas")
	var f := FileAccess.open(ProjectSettings.globalize_path(W + "packing.json"), FileAccess.WRITE)
	f.store_string(JSON.stringify(packing, "\t") + "\n")
	f.close()
	print("admit PASS")
	quit(0)
