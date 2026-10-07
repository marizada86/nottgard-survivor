extends RefCounted
const PATH := "user://playtest_queue.json"
const MAX_BYTES := 16 * 1024 * 1024
var entries: Array = []
var status := "Salvo localmente"
var path := PATH

func _init(storage_path := PATH) -> void:
	path = storage_path
	if FileAccess.file_exists(path):
		var parsed = JSON.parse_string(FileAccess.get_file_as_string(path))
		if parsed is Array:
			for entry in parsed:
				if entry is Dictionary and entry.get("id", "") is String and entry.get("payload") is Dictionary and entry.get("endpoint", "") in ["/api/playtest/runs", "/api/playtest/evidence"]:
					entry.revision = JSON.stringify(entry.payload).sha256_text()
					entry.attempts = int(entry.get("attempts", 0))
					entry.next_at = float(entry.get("next_at", 0))
					entries.append(entry)
	if not entries.is_empty():
		status = "Pendente de envio (%d)" % entries.size()

func enqueue(id: String, endpoint: String, payload: Dictionary) -> bool:
	var next := entries.duplicate(true)
	next = next.filter(func(e): return e.id != id)
	next.append({"id": id, "endpoint": endpoint, "payload": payload, "revision": JSON.stringify(payload).sha256_text(), "attempts": 0, "next_at": 0.0})
	var text := JSON.stringify(next)
	if text.to_utf8_buffer().size() > MAX_BYTES:
		status = "Fila cheia: baixe as evidencias antes de continuar"
		return false
	if not save_text(text):
		return false
	entries = next
	status = "Pendente de envio (%d)" % entries.size()
	return true

func save_text(text: String) -> bool:
	var f := FileAccess.open(path + ".tmp", FileAccess.WRITE)
	if f == null:
		status = "Falha ao guardar; dados ainda nao confirmados"
		return false
	f.store_string(text)
	f.flush()
	var err := f.get_error()
	f.close()
	if err != OK:
		return false
	return DirAccess.rename_absolute(path + ".tmp", path) == OK

func acknowledge(id: String, revision: String) -> bool:
	var next := entries.filter(func(e): return e.id != id or e.revision != revision)
	if not save_text(JSON.stringify(next)):
		return false
	entries = next
	status = "Recebido" if entries.is_empty() else "Pendente de envio (%d)" % entries.size()
	return true

func pending() -> Dictionary:
	for entry in entries:
		if float(entry.get("next_at", 0)) <= Time.get_unix_time_from_system():
			return entry
	return {}

func retry_now() -> void:
	for entry in entries:
		entry.next_at = 0.0
	save_text(JSON.stringify(entries))

func fail(id: String, revision: String, code := 0) -> void:
	for entry in entries:
		if entry.id == id and entry.revision == revision:
			entry.attempts = int(entry.attempts) + 1
			entry.next_at = Time.get_unix_time_from_system() + (300.0 if code in [400, 401, 403, 409, 413, 422, 503] else minf(300.0, pow(2.0, minf(8, entry.attempts))))
	status = "Identifique-se como tester aprovado para enviar" if code in [401, 403] else "Envio pendente; tentando novamente"
	save_text(JSON.stringify(entries))
