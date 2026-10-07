extends RefCounted
## SPEC-116: coleta com ritmo (D3) e opção de efeitos reduzidos.

func run() -> Array:
	var out: Array = []
	if Sfx.chain_pitch(0) != 1.0:
		out.append("sem encadeamento o tom deve ser o normal")
	var last := 1.0
	for i in range(1, Sfx.CHAIN_MAX_STEPS + 1):
		var p := Sfx.chain_pitch(i)
		if not (p > last):
			out.append("o tom deveria subir a cada coleta encadeada (passo %d)" % i)
		last = p
	if Sfx.chain_pitch(99) != Sfx.chain_pitch(Sfx.CHAIN_MAX_STEPS):
		out.append("o tom encadeado deve ter teto")
	if Sfx.chain_pitch(-3) != 1.0:
		out.append("encadeamento negativo não pode baixar o tom")
	if Sfx.chain_pitch(Sfx.CHAIN_MAX_STEPS) > 1.5:
		out.append("teto do tom encadeado alto demais (soaria estridente)")
	var profile := Profile.new()
	if bool(profile.data.settings.get("reduced_impact", false)):
		out.append("efeitos de impacto devem começar no padrão (não reduzidos)")
	return out
