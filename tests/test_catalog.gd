extends RefCounted
## SPEC-165 (MEC-003): catálogo do menu de pausa (conta pura em `Catalog`).

func run() -> Array:
	var out: Array = []

	# categorias e totais batem com os dados do jogo
	var totals := {"enemies": Data.table("enemies").size(), "weapons": Data.table("weapons").size(), "items": Data.table("items").uniques.size()}
	for cat in Catalog.CATEGORIES:
		var list := Catalog.entries(cat, {})
		if list.size() != int(totals[cat]):
			out.append("%s: %d entradas, esperava %d" % [cat, list.size(), int(totals[cat])])
		if not Catalog.LABELS.has(cat):
			out.append("%s: sem rótulo" % cat)

	# perfil vazio: tudo bloqueado, escuro e sem informação
	for cat in Catalog.CATEGORIES:
		var empty := Catalog.entries(cat, {})
		for e in empty:
			if bool(e.known) or String(e.name) != Catalog.UNKNOWN_NAME or String(e.icon) != "" or bool(e.seen_run):
				out.append("%s/%s: com perfil vazio deveria ser '???' sem ícone (veio %s)" % [cat, e.id, str(e)])
				break
		var c := Catalog.counts(cat, {})
		if int(c.known) != 0 or int(c.total) != empty.size():
			out.append("%s: contagem com perfil vazio deveria ser 0/%d (veio %s)" % [cat, empty.size(), str(c)])

	# perfil com uma entrada: só ela aparece, com nome verdadeiro e ícone
	var one_enemy: String = String(Data.table("enemies").keys()[0])
	var codex := {"enemies": {one_enemy: true}, "weapons": {"espada_sombria": true}, "items": {"machado_de_xargath": true}}
	for pair in [["enemies", one_enemy], ["weapons", "espada_sombria"], ["items", "machado_de_xargath"]]:
		var list := Catalog.entries(String(pair[0]), codex)
		var found := false
		var n_known := 0
		for e in list:
			if bool(e.known):
				n_known += 1
			if String(e.id) == String(pair[1]):
				found = true
				if not bool(e.known) or String(e.name) == Catalog.UNKNOWN_NAME or String(e.icon) == "":
					out.append("%s/%s: no perfil deveria aparecer com nome e ícone (veio %s)" % [pair[0], pair[1], str(e)])
				if String(e.name) != String(Catalog.source(String(pair[0]))[pair[1]].name):
					out.append("%s/%s: nome deveria ser o dos dados" % [pair[0], pair[1]])
		if not found:
			out.append("%s/%s: faltou na lista" % [pair[0], pair[1]])
		if n_known != 1:
			out.append("%s: só 1 entrada deveria estar desbloqueada (há %d)" % [pair[0], n_known])
		if int(Catalog.counts(String(pair[0]), codex).known) != 1:
			out.append("%s: contagem deveria ser 1" % pair[0])

	# o que apareceu nesta run conta como conhecido e é marcado; `false` (marcador do Battle) não conta
	var run_codex := {"enemies": {one_enemy: true, "cultista_adaga": false}}
	for e in Catalog.entries("enemies", {}, run_codex):
		if String(e.id) == one_enemy and (not bool(e.known) or not bool(e.seen_run)):
			out.append("inimigo visto na run deveria vir conhecido e marcado")
		if String(e.id) == "cultista_adaga" and (bool(e.known) or bool(e.seen_run)):
			out.append("marcador 'false' do Battle não pode virar descoberta")
	# e no perfil mas não nesta run: conhecido, sem a marca de 'visto agora'
	for e in Catalog.entries("enemies", {"enemies": {one_enemy: true}}, {}):
		if String(e.id) == one_enemy and (not bool(e.known) or bool(e.seen_run)):
			out.append("inimigo só do perfil: conhecido, sem marca de 'visto nesta run'")

	# detalhe: bloqueado não revela nada; conhecido traz o nome e os números
	var enemy_name := String(Data.table("enemies")[one_enemy].name)
	if Catalog.detail("enemies", one_enemy, false) != Catalog.UNKNOWN_DETAIL or Catalog.detail("enemies", one_enemy, false).find(enemy_name) >= 0:
		out.append("detalhe bloqueado não pode revelar o nome")
	for pair in [["enemies", one_enemy], ["weapons", "espada_sombria"], ["items", "machado_de_xargath"]]:
		var text := Catalog.detail(String(pair[0]), String(pair[1]), true)
		var name := String(Catalog.source(String(pair[0]))[pair[1]].name)
		if text.find(name) < 0 or text == Catalog.UNKNOWN_DETAIL:
			out.append("%s/%s: detalhe conhecido deveria trazer o nome" % [pair[0], pair[1]])
	if Catalog.detail("weapons", "inexistente", true) != Catalog.UNKNOWN_DETAIL:
		out.append("id que não existe nos dados cai no 'não descoberto'")

	# ícones: todo conhecido tem caminho no padrão do jogo
	if Catalog.icon_path("weapons", "espada_sombria") != "res://assets/icons/weapons/espada_sombria.png" or Catalog.icon_path("zzz", "x") != "":
		out.append("caminho de ícone fora do padrão")
	return out
