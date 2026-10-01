extends RefCounted

const HQCatalog := preload("res://core/hq_catalog.gd")
const EXPECTED := {
	"hqn_01": {"type": "first_run"},
	"hqn_02": {"type": "stage_cleared", "stage": "docas"},
	"hqn_03": {"type": "stage_reached", "stage": "shedaklah"},
	"hqn_04": {"type": "stage_cleared", "stage": "shedaklah"},
	"hqn_05": {"type": "stage_cleared", "stage": "molor"},
	"hqn_06": {"type": "stage_cleared", "stage": "durao"},
	"hqn_07": {"type": "stage_cleared", "stage": "feng_tu"},
	"hqn_08": {"type": "stage_cleared", "stage": "shendilavri"},
	"hqn_09": {"type": "stage_cleared", "stage": "goranthis"},
	"hqn_10": {"type": "final_victory", "stage": "pilares"},
	"hqn_11": {"achievement": "cacador_de_chefes"},
	"hqn_12": {"achievement": "aluris"},
	"hqn_13": {"achievement": "mestre_de_camadas"},
	"hqn_14": {"achievement": "pilares_ativos"}
}

func run() -> Array:
	var out: Array[String] = []
	var hqs: Dictionary = Data.table("hqs")
	if hqs.size() != EXPECTED.size():
		out.append("catálogo deveria conter as 14 HQs aprovadas")
	for hq_id in EXPECTED:
		if not hqs.has(hq_id):
			out.append("catálogo sem %s" % hq_id)
			continue
		var hq: Dictionary = hqs[hq_id]
		var expected: Dictionary = EXPECTED[hq_id]
		if expected.has("achievement"):
			if String(hq.get("achievement", "")) != String(expected.achievement):
				out.append("conquista incorreta para %s" % hq_id)
		else:
			if hq.get("trigger", {}) != expected:
				out.append("gatilho incorreto para %s: %s" % [hq_id, str(hq.get("trigger", {}))])
		var panels: Array = hq.get("panels", [])
		if panels.size() != 4:
			out.append("%s deveria ter quatro quadros" % hq_id)
		for panel in panels:
			var path := String(panel.get("image", ""))
			if not ResourceLoader.exists(path):
				out.append("imagem ausente em %s: %s" % [hq_id, path])
			else:
				var texture := ResourceLoader.load(path) as Texture2D
				if texture == null:
					out.append("image failed to import: %s" % path)
				elif absf(float(texture.get_width()) / float(texture.get_height()) - 16.0 / 9.0) > 0.0021:
					out.append("imagem fora da proporção-fonte aproximada 16:9 em %s: %dx%d" % [path, texture.get_width(), texture.get_height()])
			if String(panel.get("text", "")).is_empty():
				out.append("legenda vazia em %s" % hq_id)

	var fresh := Profile.new()
	if not HQCatalog.unlocked_ids(fresh.data).is_empty():
		out.append("perfil novo não deveria liberar HQ antes dos marcos")
	if HQCatalog.newly_triggered_ids(fresh.data, "first_run") != ["hqn_01"]:
		out.append("primeira run deveria acionar HQN-01")
	var legacy := Profile.new({"stats": {"runs": 1, "reached": {"shedaklah": true}}, "cleared": {"docas": true}})
	if not HQCatalog.newly_triggered_ids(legacy.data, "first_run").is_empty():
		out.append("save existente não deveria reproduzir HQN-01 retroativamente")
	var legacy_early_save := Profile.new({"coins": 25})
	if not HQCatalog.newly_triggered_ids(legacy_early_save.data, "first_run").is_empty():
		out.append("save antigo com moedas mas sem estatísticas não deveria reproduzir HQN-01 retroativamente")
	if not HQCatalog.is_unlocked(legacy.data, "hqn_01") or not HQCatalog.is_unlocked(legacy.data, "hqn_02") or not HQCatalog.is_unlocked(legacy.data, "hqn_03"):
		out.append("progresso antigo deveria liberar HQs correspondentes no Diário")
	var milestone_cases := [
		["stage_cleared", "docas", "hqn_02"],
		["stage_reached", "shedaklah", "hqn_03"],
		["stage_cleared", "shedaklah", "hqn_04"],
		["stage_cleared", "molor", "hqn_05"],
		["stage_cleared", "durao", "hqn_06"],
		["stage_cleared", "feng_tu", "hqn_07"],
		["stage_cleared", "shendilavri", "hqn_08"],
		["stage_cleared", "goranthis", "hqn_09"],
		["final_victory", "pilares", "hqn_10"]
	]
	for milestone in milestone_cases:
		var triggered := HQCatalog.newly_triggered_ids(fresh.data, String(milestone[0]), String(milestone[1]))
		if triggered != [String(milestone[2])]:
			out.append("marco %s/%s deveria acionar %s, veio %s" % [milestone[0], milestone[1], milestone[2], str(triggered)])
	if HQCatalog.newly_earned_ids(["pilares_ativos"]) != ["hqn_14"]:
		out.append("conquista nova deveria apresentar somente HQN-14")
	var old_achievement_unlocks := Profile.new({"achievements": {"aluris": true, "pilares_ativos": true}})
	if HQCatalog.unlocked_ids(old_achievement_unlocks.data).filter(func(id): return id in ["hqn_12", "hqn_14"]) != ["hqn_12", "hqn_14"]:
		out.append("conquistas existentes deveriam continuar liberando HQN-12 e HQN-14")

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
	for viewport_size in [Vector2(1280, 720), Vector2(1920, 1080)]:
		var available: Vector2 = viewport_size - Vector2(16, 16)
		var scale_factor: float = minf(available.x / float(panel_image.texture.get_width()), available.y / float(panel_image.texture.get_height()))
		var drawn_size: Vector2 = Vector2(panel_image.texture.get_size()) * scale_factor
		if drawn_size.x > available.x + 0.01 or drawn_size.y > available.y + 0.01:
			out.append("imagem seria cortada em %dx%d" % [int(viewport_size.x), int(viewport_size.y)])
	if String(screen.get_node("%PanelCounter").text) != "Quadro 1 de 4":
		out.append("leitor não iniciou no primeiro quadro")
	screen.call("advance")
	screen.call("advance")
	screen.call("advance")
	if String(screen.get_node("%PanelCounter").text) != "Quadro 4 de 4":
		out.append("leitor não chegou ao quarto quadro")
	screen.call("advance")
	if not bool(screen.get("is_closed")) or not bool(screen.get("completed")):
		out.append("leitor deve registrar conclusão ao avançar do último quadro")
	screen.free()

	var skip_screen = scene.instantiate()
	skip_screen.process_mode = Node.PROCESS_MODE_ALWAYS
	tree.root.add_child(skip_screen)
	skip_screen.call("start_hq", hqs["hqn_14"])
	var esc := InputEventKey.new()
	esc.pressed = true
	esc.keycode = KEY_ESCAPE
	skip_screen.call("_input", esc)
	if not bool(skip_screen.get("is_closed")) or bool(skip_screen.get("completed")):
		out.append("Esc deveria pular a HQ sem contar leitura completa")
	skip_screen.free()
	return out
