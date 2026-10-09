extends RefCounted
const Queue := preload("res://core/evidence_queue.gd")

func run() -> Array:
	var directory := "res://.atena/generated/test-state"
	DirAccess.make_dir_recursive_absolute(directory)
	var path := directory + "/queue-test.json"
	DirAccess.remove_absolute(path)
	var queue = Queue.new(path)
	var failures: Array = []
	if not queue.enqueue("run", "/api/playtest/runs", {"run": {"outcome": "incomplete"}}):
		return ["fila de teste nao conseguiu gravar arquivo local"]
	var revision: String = queue.entries[0].revision
	queue.enqueue("run", "/api/playtest/runs", {"run": {"outcome": "won"}})
	queue.acknowledge("run", revision)
	if queue.entries.size() != 1 or queue.entries[0].payload.run.outcome != "won":
		failures.append("recibo antigo apagou resultado mais recente")
	queue.fail("run", queue.entries[0].revision, 401)
	queue.enqueue("note", "/api/playtest/evidence", {"kind": "note"})
	if queue.pending().id != "note":
		failures.append("fila bloqueada impediu outras evidencias")
	var restored = Queue.new(path)
	if restored.entries.size() != 2:
		failures.append("fila nao sobreviveu a reabertura")
	restored.acknowledge("note", restored.entries[1].revision)
	if restored.entries.size() != 1:
		failures.append("recibo confirmado nao removeu evidencia")
	DirAccess.remove_absolute(path)
	return failures
