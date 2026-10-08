extends RefCounted
## SPEC-132 (MEC-049): tabela de lettering e placas. Tolerante à arte ausente: só valida a arte que já existe.

func run() -> Array:
	var out: Array = []
	var table := Data.table("lettering")
	var count := 0
	for id in table:
		if String(id).begins_with("_"):
			continue
		count += 1
		var p: Dictionary = table[id]
		var kind := String(p.get("kind", ""))
		if kind != "banner" and kind != "plate":
			out.append("%s: kind '%s' inválido" % [id, kind])
		if not String(p.get("path", "")).begins_with("res://assets/ui/"):
			out.append("%s: path fora de assets/ui" % id)
		var size := Lettering.piece_size(id)
		if size.x <= 0 or size.y <= 0:
			out.append("%s: tamanho inválido" % id)
		if kind == "plate" and (not p.has("margins") or not Lettering.margins_fit(id)):
			out.append("%s: margens de nove fatias ausentes ou maiores que a placa" % id)
		if not Lettering.has_art(id):
			if Lettering.banner(id) != null or Lettering.plate(id) != null:
				out.append("%s: sem arte, o helper deveria devolver null" % id)
			continue
		var tex := Lettering.texture(id)
		if tex == null:
			out.append("%s: PNG não carrega" % id)
			continue
		var img := tex.get_image()
		if kind == "banner" and (tex.get_width() > int(size.x) or tex.get_height() > int(size.y)):
			out.append("%s: %dx%d passa do máximo %s" % [id, tex.get_width(), tex.get_height(), size])
		if kind == "plate" and Vector2(tex.get_size()) != size:
			out.append("%s: placa %s, esperado %s" % [id, tex.get_size(), size])
		for corner in [Vector2i(0, 0), Vector2i(img.get_width() - 1, 0), Vector2i(0, img.get_height() - 1), Vector2i(img.get_width() - 1, img.get_height() - 1)]:
			if img.get_pixelv(corner).a > 0.01:
				out.append("%s: canto %s não é transparente (chave mal removida?)" % [id, corner])
				break
	if count != 8:
		out.append("data/lettering.json deveria ter 8 peças, tem %d" % count)

	# Estilo de lettering em Label dinâmico (sem arte nenhuma).
	var label := Label.new()
	Lettering.style(label, 32)
	if label.material == null or not (label.material is ShaderMaterial):
		out.append("Lettering.style não aplicou o gradiente")
	if label.get_theme_font_size("font_size") != 32:
		out.append("Lettering.style não aplicou o tamanho")
	if label.get_theme_constant("outline_size") < 4:
		out.append("Lettering.style sem contorno")
	label.free()
	var flat := Label.new()
	Lettering.style(flat, 20, false)
	if flat.material != null:
		out.append("Lettering.style(gradient=false) não deveria ter material")
	flat.free()
	var fallback := Lettering.plate_label("placa_inexistente", "Teste", 24)
	if not (fallback is Label) or (fallback as Label).text != "Teste":
		out.append("plate_label sem arte deveria devolver o Label estilizado")
	fallback.free()
	return out
