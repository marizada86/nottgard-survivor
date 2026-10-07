extends RefCounted
## SPEC-117 (MEC-032): texto de história por fase vem do Vault, curto e com fonte registrada.

const MAX_EPIGRAPH := 140
const MAX_BOSS_CONTEXT := 120

func run() -> Array:
	var out: Array = []
	var story: Dictionary = Data.table("stage_story")
	var stages: Dictionary = Data.table("stages")
	var presentations: Dictionary = Data.table("boss_presentations")
	for stage_id in stages:
		if not story.has(stage_id):
			out.append("fase %s sem texto de história" % stage_id)
			continue
		var s: Dictionary = story[stage_id]
		for key in ["epigrafe", "fonte_vault", "chefe", "fonte_chefe"]:
			if String(s.get(key, "")).strip_edges() == "":
				out.append("%s: campo %s vazio" % [stage_id, key])
		if String(s.get("epigrafe", "")).length() > MAX_EPIGRAPH:
			out.append("%s: epígrafe passa de %d caracteres" % [stage_id, MAX_EPIGRAPH])
		if String(s.get("chefe", "")).length() > MAX_BOSS_CONTEXT:
			out.append("%s: contexto do chefe passa de %d caracteres" % [stage_id, MAX_BOSS_CONTEXT])
		if not presentations.has(String(stages[stage_id].boss)) and stage_id in ["dagruve", "docas"]:
			out.append("%s: chefe sem apresentação" % stage_id)
	# o segredo sobre Durvall e a Síntese não pode vazar para o texto do jogo (decisão do dono, 2026-10-01)
	for stage_id in story:
		if stage_id.begins_with("_"):
			continue
		for key in ["epigrafe", "chefe"]:
			var text := String(story[stage_id].get(key, "")).to_lower()
			if "durvall" in text or "astherion" in text and stage_id == "pilares":
				out.append("%s: %s não pode citar a fusão de Durvall (segredo)" % [stage_id, key])
	# eventos temáticos do piloto (H5)
	for pilot in ["dagruve", "docas"]:
		if String(story[pilot].get("aparece", "")) == "" or not "%d" in String(story[pilot].get("fonte_uso", "")):
			out.append("%s: textos de evento (aparece, fonte_uso com %%d) ausentes" % pilot)
	# Adam é o fio de Dagruve e dos Pilares
	if not "Adam" in String(story.dagruve.epigrafe) or not "Adam" in String(story.pilares.chefe):
		out.append("o fio de Adam deveria aparecer em Dagruve e nos Pilares")
	return out
