extends RefCounted

func run() -> Array[String]:
	var failures: Array[String] = []
	var event := {"type": "nova", "weapon": "ampulheta", "dtype": "magico", "pos": Vector2(10, 8), "radius": 4.0}
	if not HourglassVfx.supports(event) or HourglassVfx.supports(event, true): failures.append("arma/impacto reduzido com roteamento incorreto")
	for field in ["type", "weapon", "dtype"]:
		var other := event.duplicate()
		other[field] = "unsupported"
		if HourglassVfx.supports(other): failures.append("ampulheta aceita " + field + " indevido")
	var weapon: Dictionary = Data.table("weapons")["ampulheta"]
	if weapon.kind != "nova" or weapon.dtype != "magico" or weapon.radius != 4.0 or weapon.stun != 1.5 or weapon.cd != 5.0: failures.append("mecânica da arma ampulheta foi alterada")
	var radiant := event.duplicate()
	radiant.weapon = "sentenca_de_lliira"
	radiant.dtype = "radiante"
	if HourglassVfx.supports(radiant) or not RadiantPulseVfx.supports(radiant) or RadiantPulseVfx.supports(event): failures.append("famílias VFX interferem uma na outra")
	var before := event.duplicate(true)
	var effect := HourglassVfx.create_effect(event, Color.VIOLET)
	if effect == null:
		failures.append("ampulheta suportada sem efeito")
		return failures
	var sprite := effect.get_child(0) as AnimatedSprite2D
	var frames := sprite.sprite_frames
	if effect.position != Iso.to_screen(event.pos) or sprite.modulate != Color.VIOLET or sprite.material.blend_mode != CanvasItemMaterial.BLEND_MODE_ADD: failures.append("pivô/tinta/material inválidos")
	if frames.get_frame_count(&"default") != 6 or frames.get_animation_loop(&"default") or not is_equal_approx(6.0 / frames.get_animation_speed(&"default"), 0.35): failures.append("cadência/contagem/one-shot inválidos")
	for index in 6:
		var region: AtlasTexture = frames.get_frame_texture(&"default", index)
		if region.region != Rect2(index * 256, 0, 256, 256) or region.atlas.resource_path != HourglassVfx.TEXTURE_PATH: failures.append("atlas/região incorreta")
	var texture := load(HourglassVfx.TEXTURE_PATH) as Texture2D
	var image := texture.get_image()
	if image.is_compressed(): image.decompress()
	var residual_pixels := 0
	for y in 256:
		for x in 256:
			if image.get_pixel(5 * 256 + x, y).a > 12.0 / 255.0: residual_pixels += 1
	if residual_pixels == 0: failures.append("última fase perdeu todos os resíduos")
	for index in 6:
		for edge in 256:
			if image.get_pixel(index * 256 + edge, 0).a != 0 or image.get_pixel(index * 256, edge).a != 0 or image.get_pixel(index * 256 + 255, edge).a != 0 or image.get_pixel(index * 256 + edge, 255).a != 0: failures.append("borda/fundo do atlas inválidos")
	var scale := HourglassVfx.scale_for_radius(4.0)
	var expected := Iso.to_screen(Vector2(4.0 / sqrt(2.0), -4.0 / sqrt(2.0)))
	if not is_equal_approx(scale.x * HourglassVfx.PEAK_RING_RADIUS, expected.x) or not is_equal_approx(scale.y / scale.x, 0.5): failures.append("raio/projeção diferentes do alcance lógico")
	effect.free()
	if event != before: failures.append("helper modificou evento de gameplay")
	return failures
