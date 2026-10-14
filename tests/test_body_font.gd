extends RefCounted
## Fonte do corpo do jogo (decisão do dono, 2026-10-14): EB Garamond no tema, com a Alegreya Sans de fallback de glifo.

const SAMPLE := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzÀÁÂÃÇÉÊÍÓÔÕÚàáâãçéêíóôõú0123456789.,:;!?…—–-'\"“”()[]/+%·"

func run() -> Array:
	var out: Array = []
	var theme := load("res://ui/theme.tres") as Theme
	if theme == null:
		return ["ui/theme.tres não carrega"]
	var font := theme.default_font
	if not (font is FontVariation):
		return ["o corpo deveria ser uma FontVariation com fallback, veio %s" % str(font)]
	var variation := font as FontVariation
	var base := variation.base_font
	if base == null or base.resource_path != "res://assets/fonts/EBGaramond-Variable.ttf":
		out.append("o corpo deveria ser a EB Garamond: %s" % (base.resource_path if base != null else "nulo"))
	var fallback_ok := false
	for f in variation.fallbacks:
		if f is Font and (f as Font).resource_path == "res://assets/fonts/AlegreyaSans-Regular.ttf":
			fallback_ok = true
	if not fallback_ok:
		out.append("a Alegreya Sans deveria ser o fallback do corpo")
	if base != null:
		var miss := ""
		for i in SAMPLE.length():
			if not base.has_char(SAMPLE.unicode_at(i)):
				miss += SAMPLE[i]
		if miss != "":
			out.append("a EB Garamond não cobre: %s" % miss)
	if theme.default_font_size < 20 or theme.default_font_size > 24:
		out.append("tamanho padrão do corpo fora da faixa conferida: %d" % theme.default_font_size)
	var project := String(ProjectSettings.get_setting("gui/theme/custom", ""))
	if project != "res://ui/theme.tres":
		out.append("o tema do projeto não é ui/theme.tres: %s" % project)
	return out
