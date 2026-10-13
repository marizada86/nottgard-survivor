extends RefCounted

func run() -> Array[String]:
	var failures: Array[String] = []
	var event := {"type": "nova", "weapon": "sentenca_de_lliira", "dtype": "radiante", "pos": Vector2(10, 8), "radius": 2.6}
	for weapon in RadiantPulseVfx.WEAPONS:
		event.weapon = weapon
		if not RadiantPulseVfx.supports(event): failures.append("arma radiante sem roteamento: " + weapon)
		var data: Dictionary = Data.table("weapons")[weapon]
		if data.kind != "nova" or data.dtype != "radiante": failures.append("allowlist não corresponde a uma nova radiante: " + weapon)
	if RadiantPulseVfx.supports(event, true): failures.append("impacto reduzido usa flash do pulso")
	for field in ["type", "weapon", "dtype"]:
		var other := event.duplicate()
		other[field] = "unsupported"
		if RadiantPulseVfx.supports(other): failures.append("roteamento aceita " + field + " indevido")
	if RadiantPulseVfx.frames_from_texture(null) != null: failures.append("textura ausente não retorna fallback")
	var invalid := ImageTexture.create_from_image(Image.create(32, 32, false, Image.FORMAT_RGBA8))
	if RadiantPulseVfx.frames_from_texture(invalid) != null: failures.append("atlas malformado não retorna fallback")
	var texture := load(RadiantPulseVfx.TEXTURE_PATH) as Texture2D
	var frames := RadiantPulseVfx.frames_from_texture(texture)
	if frames == null:
		failures.append("atlas do pulso inválido")
		return failures
	if frames.get_frame_count(&"default") != 6 or frames.get_animation_loop(&"default") or not is_equal_approx(6.0 / frames.get_animation_speed(&"default"), 0.35): failures.append("contagem/cadência/one-shot inválidos")
	var image := Image.load_from_file(RadiantPulseVfx.TEXTURE_PATH)
	var visible := 0
	for y in 256:
		for x in 256:
			if image.get_pixel(5 * 256 + x, y).a > 12.0 / 255.0: visible += 1
	if visible == 0: failures.append("última fase perdeu todos os resíduos")
	for index in 6:
		var region: AtlasTexture = frames.get_frame_texture(&"default", index)
		if region.region != Rect2(index * 256, 0, 256, 256): failures.append("região de atlas incorreta")
		for edge in 256:
			if image.get_pixel(index * 256 + edge, 0).a != 0 or image.get_pixel(index * 256, edge).a != 0 or image.get_pixel(index * 256 + 255, edge).a != 0 or image.get_pixel(index * 256 + edge, 255).a != 0: failures.append("retângulo de fundo/corte na borda")
	for radius in [2.0, 2.6, 5.0]:
		var scale := RadiantPulseVfx.scale_for_radius(radius)
		var expected := Iso.to_screen(Vector2(radius / sqrt(2.0), -radius / sqrt(2.0)))
		if not is_equal_approx(scale.x * RadiantPulseVfx.PEAK_RING_RADIUS, expected.x) or not is_equal_approx(scale.y / scale.x, 0.5): failures.append("raio/projeção diferentes do círculo lógico")
	var before := event.duplicate(true)
	var effect := RadiantPulseVfx.create_effect(event, Color.ORANGE)
	if effect == null: failures.append("nova suportada sem efeito")
	else:
		var sprite := effect.get_child(0) as AnimatedSprite2D
		if effect.position != Iso.to_screen(event.pos) or sprite.modulate != Color.ORANGE or sprite.material.blend_mode != CanvasItemMaterial.BLEND_MODE_ADD: failures.append("pivô/tinta/material inválidos")
		effect.free()
	if event != before: failures.append("helper modificou evento de gameplay")
	return failures
