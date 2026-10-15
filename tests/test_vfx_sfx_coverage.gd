extends RefCounted
## SPEC-177 F-6/F-7: evoluções usam a arte das famílias existentes; armas que dividem arquivo de som têm tom próprio.

func run() -> Array:
	var out: Array = []
	var weapons: Dictionary = Data.table("weapons")
	for id in ["romper_armadura", "maca_demolidora", "esmagar_defesas"]:
		if MeleeVfx.shape_for(id, "fisico") == "":
			out.append("%s deveria usar um corte do kit físico" % id)
	if MeleeVfx.shape_for("romper_armadura", "radiante") != "":
		out.append("o kit físico não pode cobrir dano radiante")
	for id in ["raio_da_ruina", "dominio_coletivo"]:   # só evoluções; as três armas avulsas ficam fora (contrato ART-PROMPTS-053)
		var p := {"owner": "hero", "p": {"id": id, "dtype": String(weapons[id].dtype)}}
		if ProjectileVfx.family_for(p) == &"":
			out.append("%s deveria ter família de projétil" % id)
	var pulse := {"type": "nova", "dtype": "radiante", "weapon": "constelacao_de_silva", "radius": 2.0}
	if not RadiantPulseVfx.supports(pulse):
		out.append("constelacao_de_silva deveria usar o pulso radiante")
	var path := "res://data/audio_manifest.json"
	var manifest: Variant = JSON.parse_string(FileAccess.open(path, FileAccess.READ).get_as_text())
	var events: Dictionary = manifest.events
	var by_file := {}
	for key in events:
		if not String(key).begins_with("weapon."):
			continue
		for f in events[key].files:
			by_file[f] = by_file.get(f, []) + [key]
	for id in ["bola_de_fogo", "tormenta_de_fogo", "tocha_do_incendiario", "lamina_de_sombra", "romper_armadura", "esmagar_defesas", "dominio_da_vontade", "memoria_alterada"]:
		var d: Dictionary = events.get("weapon.%s.fire" % id, {})
		var pitch := float(d.get("pitch", 1.0))
		if is_equal_approx(pitch, 1.0) or pitch < 0.7 or pitch > 1.3:
			out.append("weapon.%s.fire deveria ter tom próprio entre 0,7 e 1,3 (%.2f)" % [id, pitch])
	return out
