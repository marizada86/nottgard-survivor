extends RefCounted
## ART-029 (projeteis) e ART-030 (habilidades dos herois): atlas, roteamento por arma/habilidade, projecao e isolamento.

const FAMILIES := {
	"orbe_radiante": {"dtype": "radiante", "weapons": ["raio_de_luz", "luz_mais_pura", "marca_da_retidao"]},
	"orbe_arcano": {"dtype": "magico", "weapons": ["raio_enfraquecedor", "dominar_pessoa", "cajado_dos_desejos", "raio_da_ruina", "dominio_coletivo"]},
	"onda_cortante": {"dtype": "magico", "weapons": ["lamina_trovejante", "tempestade"]},
}
const ABILITY_KINDS := {
	"durvall": ["ruptura_sombria", "cleave", "arc"], "brook": ["guarda_de_lliira", "guard", "follow"],
	"maelor": ["comunhao", "healing_aura", "pulse"], "sylas": ["passo_pelas_sombras", "dash_weaken", "trail"],
	"kayron": ["sobrecarga_mistica", "overdrive", "follow"], "korrak": ["impacto_de_xargath", "slam", "pulse"],
	"leoric": ["constelacao", "star_burst", "pulse"], "nyrelia": ["dominacao", "charm", "sigil"],
	"zynara": ["suspensao_temporal", "time_stop", "pulse"], "bromnor": ["concordia", "guard_nova", "pulse"],
}

func _bolt(weapon: String, dtype: String, owner: String = "hero") -> Dictionary:
	return {"owner": owner, "pos": Vector2(10, 8), "dir": Vector2(1, 0), "life": 1.0, "p": {"id": weapon, "dtype": dtype}}

func _alpha_image(path: String) -> Image:
	var image := (load(path) as Texture2D).get_image()
	if image.is_compressed():
		image.decompress()
	return image

func run() -> Array[String]:
	var failures: Array[String] = []
	failures.append_array(_projectiles())
	failures.append_array(_abilities())
	return failures

func _projectiles() -> Array[String]:
	var failures: Array[String] = []
	var weapons: Dictionary = Data.table("weapons")
	for family in FAMILIES:
		var spec: Dictionary = FAMILIES[family]
		var info: Dictionary = ProjectileVfx.FAMILIES[StringName(family)]
		if info.dtype != spec.dtype or (info.weapons as Array).filter(func(w): return w != "constelacao") != spec.weapons: failures.append(family + ": lista de armas ou dtype diferente do ART-PROMPTS-053")
		for weapon in spec.weapons:
			if not weapons.has(weapon) or weapons[weapon].kind != "bolt" or weapons[weapon].dtype != spec.dtype: failures.append(family + ": arma " + weapon + " nao e bolt do dtype esperado")
			if ProjectileVfx.family_for(_bolt(weapon, spec.dtype)) != StringName(family): failures.append("roteamento errado para " + weapon)
			if ProjectileVfx.family_for(_bolt(weapon, "fogo")) != &"" or ProjectileVfx.family_for(_bolt(weapon, spec.dtype, "enemy")) != &"": failures.append(weapon + " aceita dtype ou dono indevido")
			if ProjectileVfx.handles(_bolt(weapon, spec.dtype), true): failures.append(weapon + " ignora impacto reduzido")
	var star := _bolt("constelacao", "radiante")
	if ProjectileVfx.family_for(star) != &"orbe_radiante": failures.append("constelacao de Leoric deveria reaproveitar o orbe radiante")
	for other in ["lamina_de_sombra", "dominio_da_vontade", "memoria_alterada", "bola_de_fogo"]:
		if ProjectileVfx.family_for(_bolt(other, "magico")) != &"": failures.append(other + " fora da allowlist foi roteada")
	for family in ProjectileVfx.FAMILIES:
		var path: String = ProjectileVfx.FAMILIES[family].path
		var texture := load(path) as Texture2D
		if texture == null or texture.get_size() != Vector2(2048, 256):
			failures.append(String(family) + ": atlas ausente ou fora de 2048x256")
			continue
		var image := _alpha_image(path)
		for cell in 8:
			var lit := 0
			for y in range(0, 256, 2):
				for x in range(0, 256, 2):
					if image.get_pixel(cell * 256 + x, y).a > 12.0 / 255.0: lit += 1
			if lit == 0: failures.append("%s: celula %d vazia" % [family, cell])
			for edge in 256:
				if image.get_pixel(cell * 256 + edge, 0).a > 8.0 / 255.0 or image.get_pixel(cell * 256 + edge, 255).a > 8.0 / 255.0 or image.get_pixel(cell * 256, edge).a > 8.0 / 255.0 or image.get_pixel(cell * 256 + 255, edge).a > 8.0 / 255.0:
					failures.append("%s: borda da celula %d com luz" % [family, cell])
					break
	var pr := _bolt("raio_de_luz", "radiante")
	pr.dir = Vector2(0, 1)
	var before := pr.duplicate(true)
	var flight := ProjectileVfx.create_flight(pr, Color.GOLD)
	if flight == null:
		failures.append("voo sem sprite")
		return failures
	var frames: SpriteFrames = flight.sprite_frames
	if frames.get_frame_count(&"default") != 4 or not frames.get_animation_loop(&"default"): failures.append("voo: 4 quadros em ciclo")
	if not is_equal_approx(flight.rotation, Iso.to_screen(Vector2(0, 1)).angle()) or flight.position != ProjectileVfx.screen_position(pr.pos): failures.append("voo: pivo/rotacao nao seguem o projetil")
	if flight.modulate != Color.GOLD or flight.material.blend_mode != CanvasItemMaterial.BLEND_MODE_ADD: failures.append("voo: tinta/material")
	for index in 4:
		var region: AtlasTexture = frames.get_frame_texture(&"default", index)
		if region.region != Rect2(index * 256, 0, 256, 256): failures.append("voo: regiao %d" % index)
	flight.free()
	var impact := ProjectileVfx.create_impact(&"orbe_radiante", Vector2(3, 4), Color.GOLD)
	var sprite := impact.get_child(0) as AnimatedSprite2D
	var impact_frames: SpriteFrames = sprite.sprite_frames
	if impact_frames.get_frame_count(&"default") != 4 or impact_frames.get_animation_loop(&"default") or not is_equal_approx(4.0 / impact_frames.get_animation_speed(&"default"), 0.30): failures.append("impacto: 4 quadros one-shot em 0,30 s")
	for index in 4:
		var region: AtlasTexture = impact_frames.get_frame_texture(&"default", index)
		if region.region != Rect2((4 + index) * 256, 0, 256, 256): failures.append("impacto: regiao %d" % index)
	if impact.position != ProjectileVfx.screen_position(Vector2(3, 4)): failures.append("impacto fora do ponto de acerto")
	impact.free()
	if pr != before: failures.append("helper alterou o projetil de gameplay")
	return failures

func _abilities() -> Array[String]:
	var failures: Array[String] = []
	var abilities: Dictionary = Data.table("abilities")
	for hero in ABILITY_KINDS:
		var expected: Array = ABILITY_KINDS[hero]
		var id: String = expected[0]
		if not abilities.has(hero) or abilities[hero].id != id or abilities[hero].kind != expected[1]: failures.append(hero + ": habilidade mudou em data/abilities.json")
		if not HeroAbilityVfx.supports(id) or HeroAbilityVfx.kind(id) != expected[2]: failures.append(id + ": roteamento/tipo")
		var texture := load(HeroAbilityVfx.SPECS[id].path) as Texture2D
		if texture == null or texture.get_size() != Vector2(1536, 256):
			failures.append(id + ": atlas ausente ou fora de 1536x256")
			continue
		var image := _alpha_image(HeroAbilityVfx.SPECS[id].path)
		for cell in 6:
			var lit := 0
			for y in range(0, 256, 2):
				for x in range(0, 256, 2):
					if image.get_pixel(cell * 256 + x, y).a > 12.0 / 255.0: lit += 1
			if lit == 0: failures.append("%s: celula %d vazia" % [id, cell])
		var event := {"type": "active", "pos": Vector2(10, 8), "radius": float(abilities[hero].get("radius", abilities[hero].get("range", 2.0))), "ability_id": id}
		var before := event.duplicate(true)
		if HeroAbilityVfx.create_effect(id, event, Color.WHITE, Vector2.RIGHT, true) != null: failures.append(id + ": ignora impacto reduzido")
		var effect := HeroAbilityVfx.create_effect(id, event, Color.WHITE, Vector2(1, 0))
		if effect == null:
			failures.append(id + ": sem efeito")
			continue
		var sprite := effect.get_child(0) as AnimatedSprite2D
		if sprite.sprite_frames.get_frame_count(&"default") != 6 or sprite.material.blend_mode != CanvasItemMaterial.BLEND_MODE_ADD: failures.append(id + ": quadros/material")
		var looping: bool = sprite.sprite_frames.get_animation_loop(&"default")
		if looping != (expected[2] == "follow"): failures.append(id + ": ciclo deveria ser " + str(expected[2] == "follow"))
		if event != before: failures.append(id + ": helper alterou o evento")
		effect.free()
	# projecao: um pulso de raio r tem o semi-eixo horizontal do circulo no chao
	var pulse := HeroAbilityVfx.create_effect("impacto_de_xargath", {"pos": Vector2(5, 5), "radius": 3.0}, Color.WHITE)
	var expected_x := Iso.to_screen(Vector2(3.0 / sqrt(2.0), -3.0 / sqrt(2.0))).x
	if not is_equal_approx(pulse.scale.x * 126.0, expected_x) or not is_equal_approx(pulse.scale.y / pulse.scale.x, 0.5) or pulse.position != Iso.to_screen(Vector2(5, 5)): failures.append("pulso: raio/projecao diferentes do alcance logico")
	pulse.free()
	# arco direcional: a borda externa fica a `radius` tiles do heroi, na direcao pedida
	var arc := HeroAbilityVfx.create_effect("ruptura_sombria", {"pos": Vector2(5, 5), "radius": 3.2}, Color.WHITE, Vector2(0, 1))
	var edge: Vector2 = arc.transform * Vector2(103.0, 0.0)
	var wanted := Iso.to_screen(Vector2(5, 5) + Vector2(0, 3.2))
	if edge.distance_to(wanted) > 0.5: failures.append("arco: borda externa fora do alcance/direcao pedidos")
	arc.free()
	# rastro: a cabeca termina no ponto final do dash
	var trail := HeroAbilityVfx.create_effect("passo_pelas_sombras", {"pos": Vector2(8, 8), "distance": 3.5}, Color.WHITE, Vector2(1, 0))
	var head: Vector2 = trail.transform * Vector2(120.0, 0.0)
	if head.distance_to(Iso.to_screen(Vector2(8, 8))) > 0.5: failures.append("rastro: cabeca fora do ponto final")
	var tail: Vector2 = trail.transform * Vector2(120.0 - 206.0, 0.0)
	if tail.distance_to(Iso.to_screen(Vector2(8 - 3.5, 8))) > 0.5: failures.append("rastro: comprimento diferente da distancia do dash")
	trail.free()
	if not HeroAbilityVfx.covers_nova("impacto_de_xargath") or not HeroAbilityVfx.covers_nova("concordia") or HeroAbilityVfx.covers_nova("sentenca_de_lliira"): failures.append("anel das novas de Korrak/Bromnor mal roteado")
	return failures
