extends RefCounted
## SPEC-117 H3: falas dos heróis (data/barks.json).

func run() -> Array:
	var out: Array = []
	var barks: Dictionary = Data.table("barks")
	for id in Data.table("heroes"):
		if not barks.has(id):
			out.append("herói sem falas: %s" % id)
			continue
		for trigger in ["entrada", "chefe", "vida"]:
			var lines: Array = barks[id].get(trigger, [])
			if lines.is_empty() or lines.size() > 2:
				out.append("%s/%s deveria ter 1 ou 2 variações (tem %d)" % [id, trigger, lines.size()])
			for line in lines:
				if String(line).length() > 80:
					out.append("fala longa demais para o balão (%s/%s): %s" % [id, trigger, line])
	for id in barks:
		if not String(id).begins_with("_") and not Data.table("heroes").has(id):
			out.append("falas para herói inexistente: %s" % id)
	return out
