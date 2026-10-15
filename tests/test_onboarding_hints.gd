extends RefCounted
## SPEC-179 R2: dicas de primeira vez (teto, guardas, persistência, texto).

func run() -> Array:
	var out: Array = []
	var hints: Array = OnboardingHints.table()
	if hints.size() != 7:
		out.append("deveriam existir 7 dicas (%d)" % hints.size())
	var ids := {}
	for h in hints:
		if ids.has(String(h.id)):
			out.append("id repetido: %s" % h.id)
		ids[String(h.id)] = true
		var rendered := OnboardingHints.render(String(h.text), {"interact": "Start", "pause": "Esc", "extract": "Select", "detail": "Shift", "next": "×1,55"})
		if rendered.contains("{"):
			out.append("%s: marcador sem resolver" % h.id)
		if rendered.length() > OnboardingHints.MAX_CHARS:
			out.append("%s: %d caracteres (máximo %d)" % [h.id, rendered.length(), OnboardingHints.MAX_CHARS])
	var hs := OnboardingHints.new()
	var first: String = String(hints[0].id)
	if hs.can_show(first, 5.0, false, 1.0):
		out.append("não deveria mostrar nos primeiros %d s" % int(OnboardingHints.MIN_START))
	if not hs.can_show(first, 20.0, false, 1.0):
		out.append("deveria mostrar a primeira dica depois da abertura")
	if hs.can_show(first, 20.0, true, 1.0):
		out.append("não pode mostrar em luta de chefe")
	if hs.can_show(first, 20.0, false, 0.29):
		out.append("não pode mostrar com vida abaixo de 30%")
	hs.mark(first, 20.0)
	if hs.can_show(first, 200.0, false, 1.0):
		out.append("a mesma dica não pode repetir")
	var second: String = String(hints[1].id)
	if hs.can_show(second, 60.0, false, 1.0):
		out.append("uma dica a cada 90 s: 40 s depois ainda não pode")
	if not hs.can_show(second, 110.0, false, 1.0):
		out.append("90 s depois deveria poder")
	# nova run: o relógio de jogo recomeça e o intervalo não pode travar para sempre
	if not hs.can_show(second, 15.0, false, 1.0):
		out.append("run nova (tempo menor que o da última dica) deveria liberar")
	# teto total
	var full := OnboardingHints.new()
	for h in hints:
		full.seen[String(h.id)] = true
	if full.can_show("inexistente", 500.0, false, 1.0):
		out.append("id desconhecido não pode mostrar")
	var off := OnboardingHints.new()
	off.enabled = false
	if off.can_show(first, 200.0, false, 1.0):
		out.append("desligadas não mostram")
	# perfil: padrão e migração
	if String(Profile.fresh().settings.get("hints", "?")) != "on":
		out.append("perfil novo deveria nascer com dicas ligadas")
	var bad := Profile.new({"settings": {"hints": "quase", "hints_seen": 5}})
	if String(bad.data.settings.hints) != "on" or not (bad.data.settings.hints_seen is Dictionary):
		out.append("migração deveria corrigir valores inválidos")
	var kept := Profile.new({"settings": {"hints": "off", "hints_seen": {"ritual": true}}})
	if String(kept.data.settings.hints) != "off" or not kept.data.settings.hints_seen.has("ritual"):
		out.append("migração não pode apagar as dicas já vistas")
	return out
