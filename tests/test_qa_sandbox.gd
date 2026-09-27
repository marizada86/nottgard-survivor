extends RefCounted

const GameScript := preload("res://core/game.gd")
const ProfileScript := preload("res://core/profile.gd")

func run() -> Array:
	var failures: Array = []
	var session_id := "test-session"
	var virtual_dir := GameScript.qa_sandbox_directory(session_id)
	if virtual_dir != "user://qa-sandbox/test-session":
		failures.append("diretorio virtual do sandbox QA incorreto: %s" % virtual_dir)
	var global_dir := GameScript.qa_sandbox_global_directory(session_id)
	if not global_dir.is_absolute_path() or global_dir.begins_with("user://"):
		failures.append("sandbox QA precisa criar pasta com caminho absoluto: %s" % global_dir)
	var migrated := ProfileScript.new({"cleared": {"dagruve": true}})
	if not migrated.stage_unlocked("docas"):
		failures.append("save que concluiu Dagruve deveria liberar Docas")
	var qa_battle := Battle.new(101, "durvall", "docas")
	qa_battle.qa_prepare({"event_id": "pulso_da_fenda", "prelude_seconds": 5.0, "level": 6, "weapons": ["raio_de_luz"], "passive_id": "alcance"})
	if int(qa_battle.hero.level) != 6 or not qa_battle.hero.weapons.any(func(w): return w.id == "raio_de_luz") or int(qa_battle.hero.passives.get("alcance", 0)) != 1:
		failures.append("Navegador QA não aplicou a build escolhida")
	if absf(qa_battle.time - 245.0) > 0.001:
		failures.append("cenário QA não iniciou cinco segundos antes do evento")
	qa_battle.step(Vector2.ZERO, 0.1)
	if not qa_battle.events.any(func(ev): return String(ev.get("type", "")) == "stage_event_warning"):
		failures.append("cenário QA não emitiu o aviso pré-evento")
	for target in ["styx_margin", "styx_current", "styx_rare", "styx_cliff", "styx_telegraph", "styx_item", "styx_portal", "styx_boss", "styx_entry", "styx_forget", "styx_call", "styx_defeat"]:
		if not Playtest.qa_run_destinations().any(func(entry): return entry[1] == target):
			failures.append("Navegador QA deveria expor cenário do Estige: %s" % target)
	if not Playtest.qa_run_destinations().any(func(entry): return entry[1] == "prop_grounding"):
		failures.append("Navegador QA deveria expor cenário de contato visual de props")
	return failures
