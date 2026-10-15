extends RefCounted
## SPEC-177 R5-C/D: atmosfera por fase (partículas e gradação), opção Desligada/Leve.

func run() -> Array:
	var out: Array = []
	for sid in Data.table("stages"):
		var p: Dictionary = Atmosphere.profile_for(String(sid))
		if p.is_empty():
			out.append("fase %s sem perfil de atmosfera" % sid)
			continue
		var particles: Dictionary = p.get("particles", {})
		var grade: Dictionary = p.get("grade", {})
		if int(particles.get("amount", 0)) < 1 or int(particles.get("amount", 0)) > 80:
			out.append("%s: quantidade de partículas fora de 1 a 80" % sid)
		if (particles.get("color", []) as Array).size() != 4:
			out.append("%s: cor das partículas precisa de 4 componentes" % sid)
		if (grade.get("tint", []) as Array).size() != 3:
			out.append("%s: tint precisa de 3 componentes" % sid)
		for v in grade.get("tint", []):
			if float(v) < 0.8 or float(v) > 1.2:
				out.append("%s: tint fora do leve (0,8 a 1,2)" % sid)
		if float(grade.get("sat", 1.0)) < 0.8 or float(grade.get("sat", 1.0)) > 1.2:
			out.append("%s: saturação fora do leve" % sid)
		if float(grade.get("vig", 0.0)) > 0.35:
			out.append("%s: vinheta forte demais para 'leve'" % sid)
	if Atmosphere.mode_of({}) != "leve":
		out.append("o padrão deveria ser Leve")
	if Atmosphere.normalize("sepia") != "leve":
		out.append("valor desconhecido deveria voltar para Leve")
	if String(Profile.fresh().settings.get("atmosphere", "?")) != "leve":
		out.append("perfil novo deveria nascer com atmosphere = leve")
	var bad := Profile.new({"settings": {"atmosphere": "forte"}})
	if String(bad.data.settings.atmosphere) != "leve":
		out.append("migração deveria corrigir valor inválido")
	var a := Atmosphere.new()
	a.setup("molor", {"atmosphere": "leve"})
	if not a.is_grading() or not a.is_emitting():
		out.append("Leve deveria desenhar gradação e emitir partículas")
	a.apply({"atmosphere": "leve", "reduced_impact": true})
	if not a.is_grading() or a.is_emitting():
		out.append("impacto reduzido deveria manter a gradação e tirar as partículas")
	a.apply({"atmosphere": "leve"}, true)
	if a.is_grading() or a.is_emitting():
		out.append("aparelho de toque deveria ficar desligado")
	a.apply({"atmosphere": "off"})
	if a.is_grading() or a.is_emitting():
		out.append("Desligada não pode desenhar nada")
	a.setup("fase_inexistente", {"atmosphere": "leve"})
	if a.is_grading() or a.is_emitting():
		out.append("fase sem perfil não deve desenhar")
	a.free()
	return out
