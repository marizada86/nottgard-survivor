extends RefCounted

func run() -> Array[String]:
	var failures: Array[String] = []
	# Um vetor de alcance no VFX precisa apontar para o mesmo tile da simulação.
	for index in 8:
		var direction := Vector2.RIGHT.rotated(index * PI / 4.0)
		var actual := MeleeVfx.projection(direction) * Vector2(Iso.TILE_W * 0.5 * sqrt(2.0), 0)
		if not actual.is_equal_approx(Iso.to_screen(direction)):
			failures.append("direção isométrica incorreta: %d" % index)
	if MeleeVfx.shape_for("estocada_mistica", "magico") != "estocada_longa":
		failures.append("estocada mágica não usa seu efeito longo")
	if not MeleeVfx.shape_for("estocada_mistica", "fisico").is_empty():
		failures.append("estocada mágica admitiu tipo de dano incorreto")
	if MeleeVfx.shape_for("chicote_avarento", "fisico") != "chicote":
		failures.append("chicote não usa sua curva própria")
	if not MeleeVfx.shape_for("chicote_avarento", "magico").is_empty():
		failures.append("chicote admitiu tipo de dano incorreto")
	for shape in MeleeVfx.SHAPE_PATHS:
		var texture := load(MeleeVfx.SHAPE_PATHS[shape]) as Texture2D
		var image := texture.get_image() if texture != null else null
		if image == null or image.get_size() != Vector2i(1536, 256):
			failures.append("atlas ausente ou geometria inválida: " + shape)
			continue
		if image.get_pixel(0, 0).a > 0.01:
			failures.append("fundo preto não convertido em alfa: " + shape)
	return failures
