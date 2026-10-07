const Overlay := preload("res://ui/overlay.gd")

func run() -> Array[String]:
	var out: Array[String] = []
	var overlay := Overlay.new()
	if overlay._zone_profile({"owner": "enemy", "kind": "puddle", "pos": Vector2.ZERO}) != "bubble":
		out.append("poça deveria selecionar o perfil bolha")
	if overlay._zone_profile({"owner": "stage", "kind": "rule_ritual", "pos": Vector2.ZERO}) != "mote":
		out.append("ritual deveria selecionar o perfil mote")
	if overlay._zone_profile({"owner": "hero", "kind": "zone", "pos": Vector2.ZERO, "p": {"id": "cera_fervente", "dtype": "fogo"}}) != "spark":
		out.append("cera deveria selecionar o perfil faísca")
	if overlay._zone_profile({"owner": "hero", "kind": "zone", "pos": Vector2.ZERO, "p": {"id": "colar_dos_tentaculos", "dtype": "magico"}}) != "tentacle":
		out.append("tentáculos deveriam usar emissão de surgimento")
	overlay._spawn_profile("bubble", Vector2.ZERO, "poça", 16)
	if overlay._particle_count("poça") != 8:
		out.append("poça excedeu o teto de oito partículas")
	overlay.spawn_impact(Vector2(2.0, 3.0), 20)
	if overlay._particles.size() != 20:
		out.append("impacto deveria respeitar o teto de doze partículas")
	overlay._advance_particles(2.0)
	if not overlay._particles.is_empty():
		out.append("partículas expiradas deveriam sair do pool")
	return out
