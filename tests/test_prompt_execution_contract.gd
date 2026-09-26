extends RefCounted

const TEMPLATE_PATH := "res://.atena/generated/PROMPT-EXECUTION-RECORD-TEMPLATE-001.json"

func run() -> Array[String]:
	var failures: Array[String] = []
	var file := FileAccess.open(TEMPLATE_PATH, FileAccess.READ)
	var template: Variant = JSON.parse_string(file.get_as_text()) if file != null else null
	if not template is Dictionary:
		return ["modelo de registro de prompt ausente ou inválido"]
	if String(template.get("state", "")) != "queued":
		failures.append("modelo deve iniciar em queued")
	if String(template.get("general_instructions", {}).get("document", "")) != "ART-PROMPTS-001-direcao-e-piloto.md":
		failures.append("modelo não exige ART-PROMPTS-001")
	if String(template.get("specific_prompt", {}).get("document", "")) != "ART-PROMPTS-016-animacoes-dos-herois.md":
		failures.append("modelo não exige ART-PROMPTS-016")
	if String(template.get("manifest", {}).get("document", "")) != "HERO-ANIMATION-PROMPT-MANIFEST-001.json":
		failures.append("modelo não exige manifesto")
	var audit_script: Script = load("res://tools/audit_prompt_execution.gd")
	if audit_script == null:
		failures.append("auditoria de execução ausente")
	else:
		var invalid: Dictionary = template.duplicate(true)
		invalid.state = "generated"
		if audit_script._validate(invalid, "template.json").is_empty():
			failures.append("auditoria não bloqueia geração sem leituras registradas")
	return failures
