extends RefCounted
## Integridade do manifesto e cobertura do catálogo de áudio.


func run() -> Array:
	var out: Array = []
	var path := "res://data/audio_manifest.json"
	if not FileAccess.file_exists(path):
		return ["manifesto de áudio ausente"]
	var file := FileAccess.open(path, FileAccess.READ)
	var manifest: Variant = JSON.parse_string(file.get_as_text()) if file != null else null
	if not manifest is Dictionary:
		return ["manifesto de áudio inválido"]
	var events: Dictionary = manifest.get("events", {})
	if events.size() < 200:
		out.append("catálogo incompleto: somente %d eventos" % events.size())
	for key in events:
		var definition: Dictionary = events[key]
		var files: Array = definition.get("files", [])
		if files.is_empty():
			out.append("evento %s sem variantes" % key)
		for audio_path in files:
			if not FileAccess.file_exists(String(audio_path)):
				out.append("evento %s referencia arquivo ausente: %s" % [key, audio_path])
	var music: Dictionary = manifest.get("music", {})
	var ambience: Dictionary = manifest.get("ambience", {})
	for stage_id in Data.table("stages"):
		if not music.has(stage_id):
			out.append("fase %s sem música" % stage_id)
		elif not FileAccess.file_exists(String(music[stage_id])):
			out.append("arquivo de música ausente para %s" % stage_id)
		if not ambience.has(stage_id):
			out.append("fase %s sem ambiência" % stage_id)
		elif not FileAccess.file_exists(String(ambience[stage_id])):
			out.append("arquivo de ambiência ausente para %s" % stage_id)
	for key in ["menu", "boss", "victory", "defeat"]:
		if not music.has(key) or not FileAccess.file_exists(String(music.get(key, ""))):
			out.append("música global ausente: %s" % key)
	for weapon_id in Data.table("weapons"):
		if not events.has("weapon.%s.fire" % weapon_id):
			out.append("arma %s sem assinatura sonora" % weapon_id)
	for hero_id in Data.table("heroes"):
		if not events.has("hero.%s.active" % hero_id):
			out.append("herói %s sem habilidade sonora" % hero_id)
	for enemy_id in Data.table("enemies"):
		if not events.has("enemy.%s.action" % enemy_id):
			out.append("inimigo %s sem ação sonora" % enemy_id)
		if not events.has("enemy.%s.death" % enemy_id):
			out.append("inimigo %s sem morte sonora" % enemy_id)
	var aliases: Dictionary = manifest.get("aliases", {})
	for alias in aliases:
		if not events.has(String(aliases[alias])):
			out.append("alias %s aponta para evento inexistente" % alias)
	return out
