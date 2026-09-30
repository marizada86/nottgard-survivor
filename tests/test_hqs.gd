extends RefCounted

const HQCatalog := preload("res://core/hq_catalog.gd")
const EXPECTED := {
	"hqn_11": "cacador_de_chefes",
	"hqn_12": "aluris",
	"hqn_13": "mestre_de_camadas",
	"hqn_14": "pilares_ativos"
}

func run() -> Array:
	var out: Array[String] = []
	var hqs: Dictionary = Data.table("hqs")
	if hqs.size() != EXPECTED.size():
		out.append("catálogo deveria conter exatamente as quatro HQs aprovadas")
	for hq_id in EXPECTED:
		if not hqs.has(hq_id):
			out.append("catálogo sem %s" % hq_id)
			continue
		var hq: Dictionary = hqs[hq_id]
		if String(hq.get("achievement", "")) != String(EXPECTED[hq_id]):
			out.append("gatilho incorreto para %s" % hq_id)
		var panels: Array = hq.get("panels", [])
		if panels.size() != 4:
			out.append("%s deveria ter quatro quadros" % hq_id)
		for panel in panels:
			var path := String(panel.get("image", ""))
			if not ResourceLoader.exists(path):
				out.append("imagem ausente em %s: %s" % [hq_id, path])
			elif ResourceLoader.load(path) == null:
				out.append("image failed to import: %s" % path)
			if String(panel.get("text", "")).is_empty():
				out.append("legenda vazia em %s" % hq_id)

	var no_unlocks := HQCatalog.unlocked_ids({})
	if not no_unlocks.is_empty():
		out.append("perfil sem conquistas não deveria liberar HQs")
	var legacy_unlocks := HQCatalog.unlocked_ids({"aluris": true, "pilares_ativos": true})
	if legacy_unlocks != ["hqn_12", "hqn_14"]:
		out.append("conquistas existentes deveriam liberar HQs no Diário: %s" % str(legacy_unlocks))
	var new_unlocks := HQCatalog.newly_earned_ids(["pilares_ativos"])
	if new_unlocks != ["hqn_14"]:
		out.append("conquista nova deveria apresentar somente HQN-14: %s" % str(new_unlocks))

	var scene := load("res://ui/hq_screen.tscn") as PackedScene
	if scene == null:
		out.append("cena do leitor de HQ não carrega")
		return out
	var tree := Engine.get_main_loop() as SceneTree
	var screen = scene.instantiate()
	screen.process_mode = Node.PROCESS_MODE_ALWAYS
	tree.root.add_child(screen)
	screen.call("start_hq", hqs["hqn_11"])
	var panel_image: TextureRect = screen.get_node("%PanelImage")
	if panel_image.texture == null:
		out.append("reader did not load first panel texture")
	if panel_image.stretch_mode != TextureRect.STRETCH_KEEP_ASPECT_CENTERED:
		out.append("reader must preserve panel aspect ratio")
	if String(screen.get_node("%PanelCounter").text) != "Quadro 1 de 4":
		out.append("leitor não iniciou no primeiro quadro")
	screen.call("advance")
	if int(screen.get("panel_index")) != 1:
		out.append("leitor não avançou ao próximo quadro")
	screen.call("advance")
	screen.call("advance")
	if String(screen.get_node("%PanelCounter").text) != "Quadro 4 de 4":
		out.append("leitor não chegou ao quarto quadro")
	screen.call("advance")
	if not bool(screen.get("is_closed")):
		out.append("leitor não encerrou após o quarto quadro")
	screen.free()

	var skip_screen = scene.instantiate()
	skip_screen.process_mode = Node.PROCESS_MODE_ALWAYS
	tree.root.add_child(skip_screen)
	skip_screen.call("start_hq", hqs["hqn_14"])
	var esc := InputEventKey.new()
	esc.pressed = true
	esc.keycode = KEY_ESCAPE
	skip_screen.call("_input", esc)
	if not bool(skip_screen.get("is_closed")):
		out.append("Esc deveria pular a HQ")
	skip_screen.free()
	return out
