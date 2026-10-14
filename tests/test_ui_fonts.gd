extends RefCounted
## SPEC-173 (MEC-066): fonte dos títulos: padrão IM Fell, fallback Cinzel, cobertura de glifos e id antigo.
## Não grava no save real (não chama Game.set_ui_font).

func run() -> Array:
	var out: Array = []
	var avail := UiFonts.available()
	var ids: Array = avail.map(func(o): return String(o.id))
	if ids.is_empty() or ids[0] != UiFonts.DEFAULT_ID or UiFonts.DEFAULT_ID != "fell":
		out.append("a IM Fell English deveria ser a primeira opção e o padrão: %s" % str(ids))
	if not (UiFonts.FALLBACK_ID in ids):
		out.append("a Cinzel (fallback) deveria estar sempre disponível")
	for bad in [null, "", "inexistente", 7]:
		if UiFonts.normalize(bad) != UiFonts.DEFAULT_ID:
			out.append("id %s deveria voltar para o padrão" % str(bad))
	if UiFonts.normalize("padrao") != UiFonts.DEFAULT_ID:
		out.append("o id antigo \"padrao\" deveria virar o padrão novo")
	if UiFonts.normalize("cinzel") != "cinzel":
		out.append("escolher a Cinzel deveria ser possível")
	var base := UiFonts.title_font(UiFonts.FALLBACK_ID)
	if base == null or not (base is Font):
		out.append("a Cinzel não carrega")
	elif base.resource_path != "res://assets/fonts/CinzelDecorative-Bold.ttf":
		out.append("o fallback deveria ser a Cinzel Decorative: %s" % base.resource_path)
	for o in avail:
		var id := String(o.id)
		var miss := UiFonts.missing_glyphs(id)
		if miss != "":
			out.append("%s não cobre os glifos: %s" % [id, miss])
		if id == UiFonts.FALLBACK_ID:
			continue
		var f := UiFonts.title_font(id)
		if f == null or not (f is FontFile or f is FontVariation):
			out.append("%s não carrega como fonte" % id)
			continue
		var file: FontFile = (f as FontVariation).base_font as FontFile if f is FontVariation else f as FontFile
		if file.fallbacks.is_empty():
			out.append("%s sem fallback para a Cinzel" % id)
	# o lettering usa a fonte do perfil (padrão sem perfil/valor) e a opção lista as disponíveis
	var label := Label.new()
	Lettering.style(label, 24)
	if label.get_theme_font("font") != UiFonts.title_font():
		out.append("Lettering.style não usa UiFonts.title_font()")
	label.free()
	var panel := OptionsPanel.new()
	if panel.title_font == null or panel.title_font.item_count != avail.size():
		out.append("OptionsPanel sem a opção de fonte com %d valores" % avail.size())
	panel.free()
	if String(Profile.fresh().settings.get("ui_font", "?")) != UiFonts.DEFAULT_ID:
		out.append("perfil novo deveria nascer com ui_font = fell")
	return out
