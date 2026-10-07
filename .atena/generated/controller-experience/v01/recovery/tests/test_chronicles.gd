extends RefCounted
## SPEC-117 H4 e H6: crônicas por fase e rumor de Adam.

const MAX_CHRONICLE := 420
const MAX_RUMOR := 140

func run() -> Array:
	var out: Array = []
	var chronicles: Dictionary = Data.table("chronicles")
	var stories: Dictionary = Data.table("stage_story")
	for stage_id in Data.table("stages"):
		if not chronicles.has(stage_id):
			out.append("fase %s sem crônica" % stage_id)
			continue
		var c: Dictionary = chronicles[stage_id]
		for key in ["titulo", "texto", "fonte_vault"]:
			if String(c.get(key, "")).strip_edges() == "":
				out.append("%s: campo %s da crônica vazio" % [stage_id, key])
		if String(c.get("texto", "")).length() > MAX_CHRONICLE:
			out.append("%s: crônica passa de %d caracteres" % [stage_id, MAX_CHRONICLE])
	# segredo do mestre: o colar/amuleto e a fusão de Durvall não podem aparecer nas crônicas nem nos rumores
	var forbidden := ["amuleto", "durvall", "se torna adam", "vira adam"]
	for source in [chronicles, stories]:
		for stage_id in source:
			if String(stage_id).begins_with("_"):
				continue
			for key in source[stage_id]:
				if key.begins_with("fonte"):
					continue
				var text := String(source[stage_id][key]).to_lower()
				for word in forbidden:
					if word in text:
						out.append("%s/%s cita '%s' (segredo do mestre)" % [stage_id, key, word])
	# rumor de Adam: Docas e Shedaklah, curto e com fonte
	for stage_id in ["docas", "shedaklah"]:
		var s: Dictionary = stories[stage_id]
		if not "Adam" in String(s.get("rumor", "")) or String(s.get("fonte_rumor", "")) == "":
			out.append("%s: rumor de Adam ou sua fonte ausente" % stage_id)
		if String(s.get("rumor", "")).length() > MAX_RUMOR:
			out.append("%s: rumor passa de %d caracteres" % [stage_id, MAX_RUMOR])
	# aviso de nova crônica só na primeira vitória
	var b := Battle.new(3, "durvall", "dagruve")
	b.cleared_stages = []
	var dummy := Enemy.make("zumbi", Vector2.ZERO)
	b.events.clear()
	b._on_boss_dead(dummy)
	var warned := b.events.any(func(ev): return ev.type == "toast" and "Nova crônica" in String(ev.text))
	if not warned:
		out.append("a primeira vitória deveria avisar da nova crônica")
	var b2 := Battle.new(3, "durvall", "dagruve")
	b2.cleared_stages = ["dagruve"]
	b2.events.clear()
	b2._on_boss_dead(Enemy.make("zumbi", Vector2.ZERO))
	if b2.events.any(func(ev): return ev.type == "toast" and "Nova crônica" in String(ev.text)):
		out.append("vitória repetida não deveria avisar de crônica")
	return out
