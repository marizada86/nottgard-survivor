extends RefCounted
## SPEC-147: correções dos playtests v0.3.2 (Manzi) e v0.3.3 (Daniel).

func _key(code: Key) -> InputEventKey:
	var k := InputEventKey.new()
	k.physical_keycode = code
	k.keycode = code
	k.pressed = true
	return k

func run() -> Array:
	var out: Array = []
	out.append_array(_entrada())
	out.append_array(_topo())
	out.append_array(_avisos())
	out.append_array(_questlog())
	out.append_array(_estige())
	out.append_array(_armas())
	out.append_array(_primeiro_bau())
	out.append_array(_ficha())
	out.append_array(_bonus())
	out.append_array(_ranking())
	return out

## B-001: C fecha a ficha; a ficha abre nas ofertas; a nota (F5) prende a HUD.
func _entrada() -> Array:
	var out: Array = []
	var tree := Engine.get_main_loop() as SceneTree
	var b := Battle.new(3, "sylas", "dagruve")
	var hud: Node = load("res://ui/hud.tscn").instantiate()
	tree.root.add_child(hud)
	hud.update_stats(b)
	var closed := [0]
	var opened := [0]
	hud.items_closed.connect(func(): closed[0] += 1)
	hud.pause_items_pressed.connect(func(): opened[0] += 1)

	# S-001: com a ficha aberta, C pede o fechamento (BUG-003)
	hud.show_items_panel(b)
	hud._unhandled_input(_key(KEY_C))
	if closed[0] != 1:
		out.append("C não fechou a ficha (fechamentos: %d)" % closed[0])
	if opened[0] != 0:
		out.append("C com a ficha aberta não pode pedir para abrir a ficha de novo")
	hud.hide_items_panel()

	# S-002: numa oferta (level-up, altar, item, loja) C abre a ficha; com ela aberta, fecha
	closed[0] = 0
	opened[0] = 0
	hud.levelup_panel.visible = true
	hud._unhandled_input(_key(KEY_C))
	if opened[0] != 1:
		out.append("C numa oferta não pediu a ficha (pedidos: %d)" % opened[0])
	hud.show_items_panel(b)
	hud._unhandled_input(_key(KEY_C))
	if closed[0] != 1 or opened[0] != 1:
		out.append("C na ficha aberta sobre uma oferta deve só fechar (fechou %d, abriu %d)" % [closed[0], opened[0]])
	hud.hide_items_panel()
	hud.levelup_panel.visible = false

	# S-003: com a nota, o guia ou a Central abertos a HUD não reage e conta como modal
	var was_open: bool = Playtest._note_open
	Playtest._note_open = true
	Playtest._refresh_shade()
	closed[0] = 0
	opened[0] = 0
	hud.show_items_panel(b)
	hud._unhandled_input(_key(KEY_C))
	hud._unhandled_input(_key(KEY_ESCAPE))
	if closed[0] != 0:
		out.append("com o bloco de notas aberto, a HUD não pode fechar a ficha")
	hud.hide_items_panel()
	hud.levelup_panel.visible = true
	hud._unhandled_input(_key(KEY_C))
	hud.levelup_panel.visible = false
	if opened[0] != 0:
		out.append("com o bloco de notas aberto, C não pode abrir a ficha por trás")
	if not hud.has_modal():
		out.append("has_modal() deve valer com o bloco de notas aberto")
	var shade: ColorRect = Playtest._overlay_shade
	if shade == null or not shade.visible or shade.mouse_filter != Control.MOUSE_FILTER_STOP:
		out.append("o bloco de notas precisa de um fundo que absorva o mouse")
	Playtest._note_open = was_open
	Playtest._refresh_shade()
	if Playtest._overlay_shade.visible and not Playtest.is_overlay_open():
		out.append("o fundo do bloco de notas deve sumir quando nada está aberto")
	if hud.has_modal() and not Playtest.is_overlay_open():
		out.append("has_modal() não deve valer sem painel aberto")
	hud.free()
	return out

func _objective(i: int, kind := "collect") -> Dictionary:
	return {"id": "o%d" % i, "kind": kind, "title": "Objetivo %d" % i, "text": "Reúna os fragmentos do santuário e leve-os até o altar antes que o prazo termine", "ends_at": 120.0,
		"need": 3, "got": 1, "done": false, "failed": false}

## B-002 S-004: o topo central empilha chefe, quests, status e avisos sem interseção, em qualquer quantidade de linhas.
func _topo() -> Array:
	var out: Array = []
	var tree := Engine.get_main_loop() as SceneTree
	for count in [0, 1, 3, 6]:
		var b := Battle.new(3, "sylas", "dagruve")
		var hud: Node = load("res://ui/hud.tscn").instantiate()
		tree.root.add_child(hud)
		b.happenings.objectives.clear()
		for i in count:
			b.happenings.objectives.append(_objective(i))
		hud.update_stats(b)
		hud.boss_panel.visible = true
		hud.objective_label.text = "a\nb\nc\nd"
		hud.objective_label.visible = true
		for i in 4:
			hud.toast("Aviso %d com texto bem comprido para quebrar a linha na largura do bloco de avisos do topo da tela" % i)
		var stack: VBoxContainer = hud.top_stack
		stack.notification(Container.NOTIFICATION_SORT_CHILDREN)
		var rects: Array = []
		for c in stack.get_children():
			if (c as Control).visible:
				rects.append([c.name, (c as Control).get_rect()])
		for i in rects.size():
			for j in range(i + 1, rects.size()):
				if (rects[i][1] as Rect2).intersects(rects[j][1]):
					out.append("topo com %d objetivos: %s e %s se sobrepõem (%s / %s)" % [count, rects[i][0], rects[j][0], rects[i][1], rects[j][1]])
		if count > 0 and not hud.quest_panel.visible:
			out.append("com %d objetivos o painel de quests deve aparecer" % count)
		if count == 0 and hud.quest_panel.visible:
			out.append("sem objetivos o painel de quests não deve aparecer")
		if count == 6 and hud.quest_panel._rows.get_child_count() != QuestPanel.MAX_ROWS + 1:
			out.append("6 objetivos devem mostrar %d linhas e um '+N' (viu %d filhos)" % [QuestPanel.MAX_ROWS, hud.quest_panel._rows.get_child_count()])
		# o que não é aviso passageiro (chefe, quests, status) não pode passar de 60% da altura de 720 px com até 3 objetivos
		var fixed_bottom := stack.position.y
		for r in rects:
			if r[0] != "ToastBox":
				fixed_bottom = maxf(fixed_bottom, stack.position.y + (r[1] as Rect2).end.y)
		if count <= 3 and fixed_bottom > 720.0 * 0.6:
			out.append("chefe, quests e status ocupam demais a tela com %d objetivos (até y=%.0f)" % [count, fixed_bottom])
		hud.free()
	return out

## SPEC-168 (MEC-064): o questlog mora à direita, sem moldura, translúcido, e não toca nada do topo nem da ficha.
func _questlog() -> Array:
	var out: Array = []
	var tree := Engine.get_main_loop() as SceneTree
	var base_toast_y := -1.0
	for count in [0, 1, 3, 6]:
		var b := Battle.new(3, "sylas", "dagruve")
		var hud: Node = load("res://ui/hud.tscn").instantiate()
		tree.root.add_child(hud)
		b.happenings.objectives.clear()
		for i in count:
			var o := _objective(i)
			o["ends_at"] = b.time + 90.0 - float(i) * 30.0   # o último é o mais urgente
			b.happenings.objectives.append(o)
		hud.boss_panel.visible = true
		hud.update_stats(b)
		hud.toast("Aviso de teste")
		hud.top_stack.notification(Container.NOTIFICATION_SORT_CHILDREN)
		var log: QuestPanel = hud.quest_panel
		if log.get_parent() == hud.top_stack:
			out.append("o questlog não pode ficar dentro da pilha do topo")
		var toast_y: float = hud.toast_box.get_global_rect().position.y
		if base_toast_y < 0.0:
			base_toast_y = toast_y
		elif absf(toast_y - base_toast_y) > 0.5:
			out.append("com %d objetivos os avisos começam em y=%.0f (sem quests: %.0f)" % [count, toast_y, base_toast_y])
		if count == 0:
			if log.visible:
				out.append("sem objetivos o questlog deve estar escondido")
			hud.free()
			continue
		log.size = log.get_combined_minimum_size()
		var r := log.get_global_rect()
		var view := Rect2(Vector2.ZERO, Vector2(1280, 720))
		if not view.encloses(r):
			out.append("com %d objetivos o questlog %s sai da tela" % [count, r])
		for n in [hud.get_node("HelpBtn"), hud.get_node("SpeedBtn"), hud.boss_panel, hud.toast_box, hud.objective_label, hud.hero_panel, hud.timer_label, hud.stage_label]:
			if (n as Control).is_visible_in_tree() and (n as Control).get_global_rect().intersects(r):
				out.append("com %d objetivos o questlog %s toca %s %s" % [count, r, n.name, (n as Control).get_global_rect()])
		var style := log.get_theme_stylebox("panel")
		if not style is StyleBoxEmpty:
			out.append("o questlog não tem moldura nem fundo (viu %s)" % style.get_class())
		if log._pulse != null and log._pulse.is_valid():
			log._pulse.custom_step(1.0)   # o brilho do aviso termina e o questlog volta ao repouso
		if log.modulate.a >= 1.0 or log.modulate.a < 0.5:
			out.append("o questlog deve ser translúcido (alpha %.2f)" % log.modulate.a)
		var bars := 0
		for n in log.find_children("*", "ProgressBar", true, false):
			bars += 1
		if bars > 0:
			out.append("o questlog não tem barra de progresso (viu %d)" % bars)
		var rows: int = log._rows.get_child_count()
		if rows != mini(count, QuestPanel.MAX_ROWS) + (1 if count > QuestPanel.MAX_ROWS else 0):
			out.append("com %d objetivos o questlog tem %d linhas" % [count, rows])
		# descrição só no objetivo mais urgente: o último dos que cabem (prazo menor)
		var described := 0
		for row in log._rows.get_children():
			if row.get_child_count() > 1:
				described += 1
		if described != 1:
			out.append("com %d objetivos %d linhas têm descrição (deve ser 1, a do mais urgente)" % [count, described])
		hud.free()
	# o mais urgente é o de menor prazo; sem prazo, o primeiro
	if QuestPanel.urgent_index([{"left": 50.0}, {"left": 12.0}, {"left": 80.0}]) != 1:
		out.append("urgent_index deve escolher o menor prazo")
	if QuestPanel.urgent_index([{"left": -1.0}, {"left": -1.0}]) != 0:
		out.append("urgent_index sem prazos deve escolher o primeiro")
	return out

## SPEC-167 (BUG-042): avisos do topo. Limite real na rajada do mesmo quadro, teto de altura, um longo por vez e a ficha livre.
func _avisos() -> Array:
	var out: Array = []
	var tree := Engine.get_main_loop() as SceneTree
	var b := Battle.new(3, "sylas", "dagruve")
	var hud: Node = load("res://ui/hud.tscn").instantiate()
	tree.root.add_child(hud)
	hud.update_stats(b)
	if not (hud.toast_rect() as Rect2).size == Vector2.ZERO:
		out.append("sem avisos vivos o retângulo de avisos deve ser vazio")
	# rajada: seis avisos no mesmo quadro (conquista, Estige, névoa, Maré...); `queue_free` só age no fim do quadro
	for i in 6:
		hud.toast("Aviso curto número %d" % i)
	var live: Array = hud._live_toasts()
	if live.size() > hud.TOAST_MAX_COUNT:
		out.append("rajada de 6 avisos deixou %d vivos (limite %d)" % [live.size(), hud.TOAST_MAX_COUNT])
	if hud.toast_box.get_child_count() > hud.TOAST_MAX_COUNT:
		out.append("a rajada deixou %d filhos no bloco de avisos (o mais antigo sai na hora)" % hud.toast_box.get_child_count())
	if live.is_empty() or (live[live.size() - 1] as Label).text != "Aviso curto número 5":
		out.append("o aviso mais novo deve continuar na tela")
	_sort_top(hud)
	var span := _toast_span(hud)
	if span > hud.TOAST_MAX_HEIGHT + 1.0:
		out.append("avisos curtos ocupam %.0f px (teto %.0f)" % [span, hud.TOAST_MAX_HEIGHT])
	hud.free()
	# longos: epígrafe, rumor e um curto
	hud = load("res://ui/hud.tscn").instantiate()
	tree.root.add_child(hud)
	hud.update_stats(b)
	var epigraph := "Dagruve — O distrito que Nottgard esqueceu. A névoa entra por uma fratura no cemitério, e os cultistas esperam um messias: Adam."
	var rumor := "Dizem nas Docas que um homem de colar estranho comprou passagem para uma ilha que não consta em nenhuma carta."
	hud.toast(epigraph)
	hud.toast(rumor)
	hud.toast("Mira: AUTOMÁTICA")
	var longs := 0
	for c in hud._live_toasts():
		if (c as Label).text.length() > hud.TOAST_LONG_CHARS:
			longs += 1
	if longs != 1:
		out.append("epígrafe e rumor juntos: %d avisos longos vivos (deve ser 1, o outro espera)" % longs)
	if hud._long_toast_queue.size() != 1:
		out.append("o rumor deve esperar na fila (viu %d)" % hud._long_toast_queue.size())
	_sort_top(hud)
	var panel: Rect2 = hud.hero_panel.get_global_rect()
	var box: Rect2 = hud.toast_box.get_global_rect()
	if panel.size.x < 100.0:
		out.append("a ficha do herói não mediu no teste (largura %.0f)" % panel.size.x)
	elif box.intersects(panel):
		out.append("o bloco de avisos %s invade a ficha do herói %s" % [box, panel])
	if _toast_span(hud) > hud.TOAST_MAX_HEIGHT + 1.0:
		out.append("epígrafe e curto ocupam %.0f px (teto %.0f)" % [_toast_span(hud), hud.TOAST_MAX_HEIGHT])
	hud._drop_toast(hud._long_toast)   # a epígrafe termina: o rumor entra
	var texts: Array = []
	for c in hud._live_toasts():
		texts.append((c as Label).text)
	if not texts.has(rumor) or texts.has(epigraph) or not hud._long_toast_queue.is_empty():
		out.append("ao terminar a epígrafe o rumor deve entrar e a fila esvaziar (viu %s)" % [texts])
	hud.free()
	return out

func _sort_top(hud: Node) -> void:
	hud.top_stack.notification(Container.NOTIFICATION_SORT_CHILDREN)
	hud.toast_box.notification(Container.NOTIFICATION_SORT_CHILDREN)

## Altura entre o topo do primeiro aviso e a base do último, já com o layout resolvido.
func _toast_span(hud: Node) -> float:
	var top := INF
	var bottom := -INF
	for c in hud._live_toasts():
		var r := (c as Control).get_rect()
		top = minf(top, r.position.y)
		bottom = maxf(bottom, r.end.y)
	return 0.0 if top == INF else bottom - top

## B-002 S-007: o Estige vira um indicador de estado na HUD (IN-064).
func _estige() -> Array:
	var out: Array = []
	var tree := Engine.get_main_loop() as SceneTree
	var b := Battle.new(3, "sylas", "durao")
	var hud: Node = load("res://ui/hud.tscn").instantiate()
	tree.root.add_child(hud)
	hud.update_stats(b)
	if hud.status_chip.visible:
		out.append("fora da água e sem Esquecimento o indicador do Estige deve estar escondido")
	b.styx_exposure = 2.5
	hud.update_stats(b)
	if not hud.status_chip.visible or hud.status_chip.kind != "water" or hud.status_chip._text.text.find("2.5") < 0 or hud.status_chip.tooltip_text == "":
		out.append("na água o indicador deve mostrar o tempo (2.5 s), a INT efetiva e uma dica")
	b.styx_exposure = 0.0
	b.hero.styx_forget_t = 4.0
	hud.update_stats(b)
	if not hud.status_chip.visible or hud.status_chip.kind != "forget":
		out.append("com Esquecimento o indicador deve aparecer como 'forget'")
	b.hero.styx_forget_t = 0.0
	hud.update_stats(b)
	if hud.status_chip.visible:
		out.append("o indicador deve sumir quando o Esquecimento acaba")
	var plain := Battle.new(3, "sylas", "dagruve")
	plain.styx_exposure = 3.0
	if not hud.styx_status(plain).is_empty():
		out.append("fases sem o contrato do Estige não mostram o indicador")
	hud.free()
	return out

## B-003 S-008: depois de evoluir, a arma base não volta como "NOVA" nas ofertas (IN-063).
func _armas() -> Array:
	var out: Array = []
	var wdata: Dictionary = Data.table("weapons")
	var evolving: Array = []
	for wid in wdata:
		if wdata[wid].has("evolve"):
			evolving.append(String(wid))
	if evolving.size() != 10:
		out.append("esperava 10 armas que evoluem, achei %d (atualize o teste se o conteúdo mudou)" % evolving.size())
	for base in evolving:
		var into := String(wdata[base].evolve.into)
		var b := Battle.new(3, "sylas", "dagruve")
		b.hero.weapons.clear()
		b.hero.weapons.append(Weapon.make(into))
		var base_seen := 0
		for i in 150:
			for o in b._build_offer():
				if String(o.get("t", "")) == "weapon_new" and String(o.id) == base:
					base_seen += 1
		if base_seen > 0:
			out.append("%s: a base voltou %d vez(es) como NOVA depois de evoluir para %s" % [base, base_seen, into])
		# controle: sem a evolução a base continua aparecendo
		b.hero.weapons.clear()
		var control := 0
		for i in 400:
			for o in b._build_offer():
				if String(o.get("t", "")) == "weapon_new" and String(o.id) == base:
					control += 1
		if control == 0:
			out.append("%s: controle falhou, a base nunca foi oferecida sem a evolução" % base)
	return out

## B-003 S-009: o primeiro interativo da fase só surge depois de 45 s e é baú (IN-065).
func _primeiro_bau() -> Array:
	var out: Array = []
	if Battle.FIRST_INTERACTION_SECONDS < 40.0:
		out.append("o primeiro interativo deve demorar pelo menos 40 s (hoje %.0f)" % Battle.FIRST_INTERACTION_SECONDS)
	var b := Battle.new(3, "sylas", "dagruve")
	b.stage.waves = []
	b.stage.elites = []
	b.stage.duration = 99999
	b._breakable_t = 99999.0
	if not is_equal_approx(b._inter_t, Battle.FIRST_INTERACTION_SECONDS):
		out.append("load_stage deve armar o primeiro interativo para %.0f s (achei %.1f)" % [Battle.FIRST_INTERACTION_SECONDS, b._inter_t])
	var floating := func(): return b.interactions.filter(func(i): return not i.used and not bool(i.get("fixed", false)) and i.kind != "portal")
	var before: int = floating.call().size()
	for i in int((Battle.FIRST_INTERACTION_SECONDS - 2.0) / 0.1):
		b.step(Vector2.ZERO, 0.1)
	if floating.call().size() != before:
		out.append("surgiu um interativo antes de %.0f s" % Battle.FIRST_INTERACTION_SECONDS)
	for i in 40:
		b.step(Vector2.ZERO, 0.1)
	var spawned: Array = floating.call()
	if spawned.size() != before + 1 or String(spawned.back().kind) != "chest":
		out.append("depois de %.0f s o primeiro interativo deve ser um baú (achei %s)" % [Battle.FIRST_INTERACTION_SECONDS, spawned.map(func(i): return i.kind)])
	return out

## MEC-053: a ficha mostra o próximo nível e a evolução de armas, passivas e itens base (IN-059).
func _ficha() -> Array:
	var out: Array = []
	var tree := Engine.get_main_loop() as SceneTree
	var b := Battle.new(3, "sylas", "dagruve")
	var sheet := CharacterSheet.new()
	tree.root.add_child(sheet)
	sheet.show_sheet(b)
	# arma que evolui: próximo nível + evolução; no nível máximo, sem "próximo nível"
	var w := Weapon.make("espada_sombria")
	var d: String = sheet._weapon_entry(w).detail
	if d.find("Próximo nível (Nv 2)") < 0 or d.find("Evolução:") < 0 or d.find("Espada do Receptáculo") < 0:
		out.append("arma Nv1 que evolui: faltou 'Próximo nível (Nv 2)' ou a evolução na ficha")
	w.level = w.max_level()
	d = sheet._weapon_entry(w).detail
	if d.find("Próximo nível") >= 0 or d.find("Nível máximo") < 0 or d.find("Evolução:") < 0:
		out.append("arma no nível máximo: deve dizer 'Nível máximo' e manter a evolução")
	# arma que não evolui: sem bloco de evolução
	var plain := Weapon.make("golpe_esmagador")
	d = sheet._weapon_entry(plain).detail
	if d.find("Evolução:") >= 0 or d.find("Próximo nível (Nv 2)") < 0:
		out.append("arma sem evolução: só o próximo nível, sem bloco de evolução")
	# passiva: valor agora e do próximo nível; no nível 5, máximo
	d = sheet._passive_entry("forca", 2).detail
	if d.find("Próximo nível (Nv 3)") < 0 or d.find("+3") < 0 or d.find("+2") < 0:
		out.append("passiva Nv2: faltou o efeito de agora (+2) e do próximo nível (+3): %s" % d)
	if sheet._passive_entry("forca", CharacterSheet.PASSIVE_MAX_LEVEL).detail.find("Nível máximo") < 0:
		out.append("passiva no nível 5 deve dizer 'Nível máximo'")
	# item com base: próximo nível enquanto não é o máximo
	var rng := RandomNumberGenerator.new()
	rng.seed = 11
	var found := false
	for i in 60:
		var it := Items.roll(rng, 2, 0.0)
		if String(it.get("base", "")) == "":
			continue
		found = true
		it["level"] = 1
		if sheet._item_entry(it).detail.find("Próximo nível (Nv 2)") < 0:
			out.append("item base Nv1 sem 'Próximo nível' na ficha")
		it["level"] = Items.MAX_LEVEL
		if sheet._item_entry(it).detail.find("Próximo nível") >= 0:
			out.append("item no nível máximo não deve oferecer 'Próximo nível'")
		break
	if not found:
		out.append("nenhum item com base nos 60 sorteios (teste sem cobertura)")
	sheet.free()
	return out

## MEC-054: a linha de bônus mostra o nome antes do valor (IN-061).
func _bonus() -> Array:
	var out: Array = []
	var tree := Engine.get_main_loop() as SceneTree
	var b := Battle.new(3, "sylas", "dagruve")
	var sheet := CharacterSheet.new()
	tree.root.add_child(sheet)
	sheet.show_sheet(b)
	b.hero.mods["dmg_pct"] = 0.28
	var row: HBoxContainer = sheet._bonus_row({"key": "dmg_pct", "label": "Dano", "value": "+28%"})
	var texts: Array = []
	for c in row.get_children():
		if c is Label and (c as Label).text != "◆":
			texts.append((c as Label).text)
	if texts != ["Dano", "+28%"]:
		out.append("linha de bônus deve ser nome e depois valor, achei %s" % [texts])
	sheet.free()
	return out

## MEC-057: o ranking carrega ao abrir a aba, no máximo uma vez a cada 5 s (IN-068).
func _ranking() -> Array:
	var out: Array = []
	var board := load("res://ui/leaderboard.gd")
	if not board.auto_refresh_due(-1, 1000) or board.auto_refresh_due(1000, 3000) or not board.auto_refresh_due(1000, 6001):
		out.append("auto_refresh_due: -1 dispara, <5 s não, >=5 s dispara")
	return out
