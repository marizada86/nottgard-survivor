extends RefCounted
## PLAN-081 B-003 S-008 (ART-038 provisório): bênção sem ícone próprio usa o de outra da mesma divindade.

func run() -> Array:
	var out: Array = []
	var boons: Array = Data.table("boons").get("boons", [])
	var by_god_has_icon := {}
	for bn in boons:
		if ResourceLoader.exists("res://assets/icons/boons/%s.png" % String(bn.id)):
			by_god_has_icon[String(bn.god)] = true
	for bn in boons:
		var own := "res://assets/icons/boons/%s.png" % String(bn.id)
		var got := BoonKinds.icon_path(bn)
		if ResourceLoader.exists(own):
			if got != own:
				out.append("%s tem ícone próprio e deveria usá-lo (veio %s)" % [bn.id, got])
		elif by_god_has_icon.has(String(bn.god)):
			if not ResourceLoader.exists(got):
				out.append("%s deveria cair no ícone de outra bênção de %s (veio %s)" % [bn.id, bn.god, got])
			if got == own:
				out.append("%s não usou o ícone da divindade %s" % [bn.id, bn.god])
		elif got != own:
			out.append("%s (%s, sem nenhum ícone) deveria manter o caminho próprio para a UI cair na letra" % [bn.id, bn.god])
		if BoonKinds.icon_path_for_id(String(bn.id)) != got:
			out.append("icon_path_for_id diverge de icon_path em %s" % bn.id)
	for id in ["lliira_juramento", "tou_um_caminho"]:
		if not ResourceLoader.exists(BoonKinds.icon_path_for_id(id)):
			out.append("%s (SPEC-129 B-002) deveria ter ícone provisório da divindade" % id)
	if BoonKinds.icon_path_for_id("nao_existe") != "res://assets/icons/boons/nao_existe.png":
		out.append("id desconhecido deveria devolver o caminho próprio")
	return out
