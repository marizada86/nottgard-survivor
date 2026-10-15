extends RefCounted
## SPEC-177 F-11: avisos legíveis sobre chão escuro.

func run() -> Array:
	var out: Array = []
	var hud_script = load("res://ui/hud.gd")
	var min_luma: float = hud_script.TOAST_MIN_LUMA
	for c in [Color(0.62, 0.55, 0.85), Color(0.3, 0.4, 1.0), Color(0.42, 0.78, 0.95), Color(0.1, 0.1, 0.1), Color(1.0, 0.55, 0.35)]:
		var r: Color = hud_script.legible_toast_color(c)
		var luma := 0.299 * r.r + 0.587 * r.g + 0.114 * r.b
		if luma < min_luma - 0.01:
			out.append("cor %s ficou escura demais (%.2f)" % [str(c), luma])
		if r.a != c.a:
			out.append("a transparência da cor não pode mudar")
	var bright := Color(0.95, 0.85, 0.6)
	if hud_script.legible_toast_color(bright) != bright:
		out.append("cor já clara não deve mudar")
	var blue: Color = hud_script.legible_toast_color(Color(0.3, 0.4, 1.0))
	if blue.b < blue.r or blue.b < blue.g:
		out.append("o azul deveria seguir azulado depois de clarear")
	return out
