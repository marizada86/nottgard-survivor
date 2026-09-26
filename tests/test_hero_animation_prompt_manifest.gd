extends RefCounted
## Garante a cobertura do pacote de prompts antes de qualquer geração de imagem.

const MANIFEST_PATH := "res://.atena/generated/HERO-ANIMATION-PROMPT-MANIFEST-001.json"
const PROMPTS_PATH := "res://.atena/generated/ART-PROMPTS-016-animacoes-dos-herois.md"
const SEQUENCES := ["idle", "move_n", "move_ne", "move_e", "move_se", "move_s", "move_sw", "move_w", "move_nw", "attack", "active", "death"]
const GENERATION_SEQUENCES := ["idle", "move_n", "move_ne", "move_e", "move_se", "move_s", "attack", "active", "death"]

func run() -> Array[String]:
	var failures: Array[String] = []
	var file := FileAccess.open(MANIFEST_PATH, FileAccess.READ)
	var manifest: Variant = JSON.parse_string(file.get_as_text()) if file != null else null
	if not manifest is Dictionary:
		return ["manifesto de prompts de animação ausente ou inválido"]
	var heroes: Dictionary = Data.table("heroes")
	var covered: Dictionary = manifest.get("heroes", {})
	if covered.size() != heroes.size():
		failures.append("manifesto cobre %d heróis; esperado %d" % [covered.size(), heroes.size()])
	for hero_id in heroes:
		if not covered.has(hero_id):
			failures.append("herói sem cobertura no manifesto: %s" % hero_id)
			continue
		var entry: Dictionary = covered[hero_id]
		if entry.get("sequences", []) != SEQUENCES:
			failures.append("sequências incompletas para %s" % hero_id)
	var generation_contract: Array = manifest.get("generation_sequence_contract", [])
	var generation_ids: Array[String] = []
	for sequence: Dictionary in generation_contract:
		generation_ids.append(sequence.get("id", ""))
	if generation_ids != GENERATION_SEQUENCES:
		failures.append("contrato de geracao reduzido invalido")
	var mirrors: Dictionary = manifest.get("directional_generation", {}).get("runtime_mirrors", {})
	if mirrors != {"move_nw": "move_ne", "move_w": "move_e", "move_sw": "move_se"}:
		failures.append("mapeamento de espelhamento invalido")
	if manifest.get("counts", {}).get("new_source_prompts", 0) != 81:
		failures.append("contagem de prompts-fonte novos deveria ser 81")
	var prompt_file := FileAccess.open(PROMPTS_PATH, FileAccess.READ)
	var prompt_text := prompt_file.get_as_text() if prompt_file != null else ""
	if prompt_text.count("`HERO-") < 81:
		failures.append("arquivo de prompts não contém as 81 chamadas-fonte")
	for hero_id in heroes:
		if hero_id == "durvall":
			continue
		for sequence in GENERATION_SEQUENCES:
			if not prompt_text.contains("`HERO-%s-%s`" % [hero_id, sequence]):
				failures.append("prompt ausente: HERO-%s-%s" % [hero_id, sequence])
	return failures
