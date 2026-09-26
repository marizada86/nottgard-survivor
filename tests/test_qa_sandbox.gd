extends RefCounted

const GameScript := preload("res://core/game.gd")

func run() -> Array:
	var failures: Array = []
	var session_id := "test-session"
	var virtual_dir := GameScript.qa_sandbox_directory(session_id)
	if virtual_dir != "user://qa-sandbox/test-session":
		failures.append("diretorio virtual do sandbox QA incorreto: %s" % virtual_dir)
	var global_dir := GameScript.qa_sandbox_global_directory(session_id)
	if not global_dir.is_absolute_path() or global_dir.begins_with("user://"):
		failures.append("sandbox QA precisa criar pasta com caminho absoluto: %s" % global_dir)
	return failures
