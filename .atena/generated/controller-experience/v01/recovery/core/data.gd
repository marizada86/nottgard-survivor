class_name Data
extends RefCounted
## Carrega JSON de res://data uma vez.

static var _cache := {}

static func table(name: String) -> Dictionary:
	if not _cache.has(name):
		var f := FileAccess.open("res://data/%s.json" % name, FileAccess.READ)
		_cache[name] = JSON.parse_string(f.get_as_text())
	return _cache[name]
