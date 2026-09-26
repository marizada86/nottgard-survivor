extends SceneTree
## Gate local: nenhum registro pode avançar sem leitura das instruções gerais.

const RECORD_ROOT := "res://.atena/generated/prompt-execution"
const REQUIRED_QA := ["identity", "direction", "frames", "baseline", "alpha", "camera", "lighting", "artifacts"]
const ADVANCED_STATES := ["compiled", "generated", "qa_failed", "accepted"]
const CANDIDATE_STATES := ["generated", "qa_failed", "accepted"]

func _init() -> void:
	var failures := audit()
	for failure in failures:
		printerr("FALHA ", failure)
	print("audit-prompt-execution: %d falha(s)" % failures.size())
	quit(1 if not failures.is_empty() else 0)

static func audit() -> Array[String]:
	var failures: Array[String] = []
	var dir := DirAccess.open(RECORD_ROOT)
	if dir == null:
		return ["diretório de registros ausente"]
	for file_name in dir.get_files():
		if not file_name.ends_with(".json"):
			continue
		var path := "%s/%s" % [RECORD_ROOT, file_name]
		var file := FileAccess.open(path, FileAccess.READ)
		var record: Variant = JSON.parse_string(file.get_as_text()) if file != null else null
		if not record is Dictionary:
			failures.append("registro inválido: %s" % file_name)
			continue
		failures.append_array(_validate(record, file_name))
	return failures

static func _validate(record: Dictionary, file_name: String) -> Array[String]:
	var failures: Array[String] = []
	var state := String(record.get("state", ""))
	var label := "%s (%s)" % [file_name, state]
	if String(record.get("id", "")).is_empty() or String(record.get("batch_id", "")).is_empty():
		failures.append("%s sem id ou batch_id" % label)
	if not ADVANCED_STATES.has(state):
		return failures
	var general: Dictionary = record.get("general_instructions", {})
	if String(general.get("document", "")) != "ART-PROMPTS-001-direcao-e-piloto.md" or general.get("read_at") == null:
		failures.append("%s avançou sem leitura geral registrada" % label)
	var specific: Dictionary = record.get("specific_prompt", {})
	if String(specific.get("document", "")) != "ART-PROMPTS-016-animacoes-dos-herois.md" or specific.get("read_at") == null:
		failures.append("%s avançou sem leitura do prompt específico" % label)
	var manifest: Dictionary = record.get("manifest", {})
	if String(manifest.get("document", "")) != "HERO-ANIMATION-PROMPT-MANIFEST-001.json" or manifest.get("checked_at") == null:
		failures.append("%s avançou sem manifesto conferido" % label)
	if record.get("sources_checked", []).is_empty():
		failures.append("%s avançou sem fontes conferidas" % label)
	if CANDIDATE_STATES.has(state):
		var candidate: Dictionary = record.get("candidate", {})
		var candidate_path: Variant = candidate.get("path")
		if not candidate_path is String or candidate_path.is_empty() or candidate.get("version") == null or candidate.get("generated_at") == null:
			failures.append("%s sem candidata rastreável" % label)
		if record.get("remote_transfer_approval") == null:
			failures.append("%s sem aprovação de envio remoto registrada" % label)
	if state == "accepted":
		var qa: Dictionary = record.get("qa", {})
		for field in REQUIRED_QA:
			if qa.get(field) != true:
				failures.append("%s sem QA aprovado para %s" % [label, field])
		if String(record.get("decision", "")) != "accepted" or String(record.get("reason", "")).is_empty():
			failures.append("%s sem decisão de aceite fundamentada" % label)
	return failures
