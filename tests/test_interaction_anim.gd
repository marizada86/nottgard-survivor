extends RefCounted
## SPEC-185 (PLAN-110, B-002): a tabela de idles (data/interaction_anims.json) bate com as tiras e com as artes estáticas.

const EXPECTED := ["loja", "ferreiro", "curandeiro", "doacao", "aposta", "ampulheta", "arcanista", "peregrino", "contador",
	"npc_joao_barbosa", "npc_desertor_durao", "npc_vitima_enfeiticada", "npc_nyxara", "npc_vaelis", "npc_reaper_barqueiro", "npc_vhaerith_aetherion", "npc_mercador_rivenheart",
	"trono_zuggtmoy", "arco_pedra", "massa_thullgrime", "estrela_do_norte", "coracao_limo", "esporo_zuggtmoy", "limo_juiblex",
	"pacto_sangue", "relicario", "carroca", "eclipse_pedra", "eco", "camara_selada", "camara_aberta",
	"ruina_dagruve", "ruina_docas", "ruina_shedaklah", "ruina_molor", "ruina_feng_tu"]
## Retidos pelo pacote (nada disso pode entrar na tabela): NE06 Graz'zt, RU05 Durao, RU07 Shendilavri, RU08 Goranthis.
const RETAINED := ["npc_grazzt_aliado", "ruina_durao", "ruina_shendilavri", "ruina_goranthis"]

func run() -> Array:
	var out: Array = []
	var anims: Dictionary = Data.table("interaction_anims").get("anims", {})
	for name in EXPECTED:
		if not anims.has(name):
			out.append("falta a tira de %s" % name)
	for name in RETAINED:
		if anims.has(name):
			out.append("%s está retida pelo pacote e não pode entrar na tabela" % name)
	for name in anims:
		var sp: Dictionary = anims[name]
		var strip := String(sp.get("strip", ""))
		if not ResourceLoader.exists(strip):
			out.append("%s: tira ausente (%s)" % [name, strip])
			continue
		var tex: Texture2D = load(strip)
		var cell: Array = sp.get("cell", [0, 0])
		var frames := int(sp.get("frames", 0))
		if tex.get_width() != int(cell[0]) * frames or tex.get_height() != int(cell[1]):
			out.append("%s: tira com %dx%d, esperado %dx%d" % [name, tex.get_width(), tex.get_height(), int(cell[0]) * frames, int(cell[1])])
		var static_path := "res://assets/interactions/%s.png" % name
		if not ResourceLoader.exists(static_path):
			out.append("%s: arte estática ausente" % name)
			continue
		var stat: Texture2D = load(static_path)
		var pad := int(sp.get("pad", -1))
		if int(cell[0]) != stat.get_width() + 2 * pad or int(cell[1]) != stat.get_height() + 2 * pad:
			out.append("%s: célula %s não é a arte estática %dx%d + 2 x %d de folga" % [name, str(cell), stat.get_width(), stat.get_height(), pad])
		if frames < 2:
			out.append("%s: precisa de ao menos 2 quadros" % name)
		# o primeiro quadro cobre a arte estática: as alturas visíveis batem (tolerância de 12%)
		var first := tex.get_image().get_region(Rect2i(0, 0, int(cell[0]), int(cell[1]))).get_used_rect()
		var base := stat.get_image().get_used_rect()
		if base.size.y > 0 and absf(float(first.size.y) / float(base.size.y) - 1.0) > 0.12:
			out.append("%s: altura do primeiro quadro (%d) difere da arte estática (%d)" % [name, first.size.y, base.size.y])
	# contas puras
	var sp := {"frames": 4, "fps": 5.0}
	var seen := {}
	for t in range(0, 2000, 50):
		seen[InteractionAnim.frame_index(sp, t)] = true
	if seen.size() != 4:
		out.append("o loop deveria passar pelos 4 quadros, passou por %d" % seen.size())
	if InteractionAnim.frame_index(sp, 0) != 0 or InteractionAnim.frame_index(sp, 199) != 0 or InteractionAnim.frame_index(sp, 200) != 1:
		out.append("troca de quadro fora do ritmo de 5 fps")
	if InteractionAnim.frame_index(sp, 0, 400) != 2:
		out.append("a fase não desloca o quadro")
	var cell_rect := InteractionAnim.cell_dest({"pad": 48, "cell": [352, 352]}, Rect2(100, 200, 80, 80), Vector2(256, 256))
	if not cell_rect.is_equal_approx(Rect2(100 - 15, 200 - 15, 110, 110)):
		out.append("retângulo da célula errado: %s" % str(cell_rect))
	if InteractionAnim.has("nao_existe") or InteractionAnim.has(""):
		out.append("arte sem tira não pode ter animação")
	return out
