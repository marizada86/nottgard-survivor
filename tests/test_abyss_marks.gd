extends RefCounted
## SPEC-141 (MEC-040): Marcas do Abismo, núcleo de combate (B-001).

func _bat(marks: Dictionary = {}, stage := "dagruve", seed_value := 7) -> Battle:
	var b := Battle.new(seed_value, "durvall", stage, {"abyss_marks": marks})
	b.hero.pos = Vector2(30, 30)
	b._inter_t = 99999.0
	b._breakable_t = 99999.0
	return b

func _near(a: float, b: float, eps := 0.0001) -> bool:
	return absf(a - b) <= eps

func run() -> Array:
	var out: Array = []
	var real_save_before: Dictionary = Game.real_save_signature()
	_data(out)
	_identity(out)
	_enemy_marks(out)
	_density(out)
	_hunger(out)
	_new_marks(out)
	_reward(out)
	_profile(out)
	_panel(out)
	_menu(out)
	if Game.real_save_signature() != real_save_before:
		out.append("o teste não pode alterar o save real do jogador")
	return out

func _data(out: Array) -> void:
	var n := AbyssMarks.normalize({"horda": 5, "desconhecida": 2, "furia": -1, "fome": "2", "pressa": 0, "carapaca": 1})
	if n != {"horda": 3, "fome": 2, "carapaca": 1}:
		out.append("normalize deveria limitar 0..3 e descartar o desconhecido, veio %s" % str(n))
	if AbyssMarks.normalize("lixo") != {} or AbyssMarks.normalize(null) != {}:
		out.append("normalize de valor que não é dicionário deveria dar vazio")
	if AbyssMarks.total_level(n) != 6 or AbyssMarks.max_total() != 25:
		out.append("soma 6 e máximo 25 esperados, veio %d e %d" % [AbyssMarks.total_level(n), AbyssMarks.max_total()])
	if AbyssMarks.ids().size() != 9:
		out.append("a entrega 2 tem 9 marcas")
	if AbyssMarks.max_level("tregua") != 1 or AbyssMarks.max_level("horda") != 3 or AbyssMarks.normalize({"tregua": 3, "vivo": 9}) != {"tregua": 1, "vivo": 3}:
		out.append("Sem trégua tem 1 nível e as demais 3")
	var order: Array = ["carapaca", "pressa", "horda", "elites", "furia", "vivo", "fome", "chefe", "tregua"]
	if AbyssMarks.ids() != order:
		out.append("a ordem das marcas deve seguir a progressão: %s" % str(AbyssMarks.ids()))
	_unlock_by_achievement(out)

## Sem marcas a run é a de antes: a RNG, os inimigos e o herói andam iguais com ctx vazio, marcas vazias e marcas zeradas.
func _identity(out: Array) -> void:
	var prints: Array = []
	for marks in [{}, {"horda": 0, "fome": 0}, {"desconhecida": 3}]:
		var b := _bat(marks)
		b.hero.max_hp = 99999.0
		b.hero.hp = 99999.0
		for i in 400:
			b.step(Vector2.ZERO, 0.1)
		prints.append([b.rng.state, b._spawn_serial, b.enemies.size(), snappedf(b.hero.hp, 0.001), b.abyss_level])
	for i in range(1, prints.size()):
		if prints[i] != prints[0]:
			out.append("marcas vazias ou zeradas deveriam dar a mesma run: %s x %s" % [str(prints[0]), str(prints[i])])
	if int(prints[0][4]) != 0:
		out.append("sem marcas o nível deve ser 0")

func _enemy_marks(out: Array) -> void:
	var base := _bat()
	var marked := _bat({"carapaca": 2, "pressa": 2, "furia": 2})
	var z0 := base.spawn_for_test("zumbi", Vector2(31, 31))
	var z2 := marked.spawn_for_test("zumbi", Vector2(31, 31))
	if absf(z2.max_hp / z0.max_hp - 1.4) > 0.06:
		out.append("Carapaça 2 deveria dar ~+40%% de PV, deu ×%.3f" % (z2.max_hp / z0.max_hp))
	if not _near(z2.speed / z0.speed, 1.2):
		out.append("Pressa 2 deveria dar +20%% de velocidade, deu ×%.3f" % (z2.speed / z0.speed))
	var crate0 := base.spawn_for_test("carroca_quebravel", Vector2(32, 31))
	var crate2 := marked.spawn_for_test("carroca_quebravel", Vector2(32, 31))
	if crate0.max_hp != crate2.max_hp:
		out.append("objeto quebrável não deveria ganhar PV com Carapaça")
	var boss_id := String(base.stage.boss)
	var boss0 := base.spawn_for_test(boss_id, Vector2(33, 31))
	var boss2 := marked.spawn_for_test(boss_id, Vector2(33, 31))
	if not _near(boss0.speed, boss2.speed):
		out.append("chefe não deveria ganhar velocidade com Pressa")
	if boss2.max_hp <= boss0.max_hp:
		out.append("Carapaça deveria valer também para o chefe")
	if not _near(marked._stage_dmg_mult("hit") / base._stage_dmg_mult("hit"), 1.3):
		out.append("Fúria 2 deveria dar +30%% de dano em golpe")
	if not _near(marked._stage_dmg_mult("aoe") / base._stage_dmg_mult("aoe"), 1.3):
		out.append("Fúria 2 deveria valer para área")
	if not _near(marked._stage_dmg_mult("puddle"), 1.0):
		out.append("poça, armadilha e névoa não escalam com Fúria")
	# as marcas valem na run inteira: sobrevivem à troca de fase
	marked.load_stage("docas")
	if marked.abyss_level != 6 or not _near(marked._mk_hp, 1.4):
		out.append("as marcas deveriam sobreviver ao load_stage")

## Horda: mais inimigos nascem e cabem ao mesmo tempo (herói imortal e sem armas, para contar só o nascimento).
func _density(out: Array) -> void:
	var counts: Array = []
	for marks in [{}, {"horda": 1}, {"horda": 3}]:
		var b := _bat(marks, "shedaklah")
		b.hero.weapons.clear()
		b.hero.max_hp = 999999.0
		b.hero.hp = 999999.0
		for i in 700:
			b.step(Vector2.ZERO, 0.1)
		counts.append(b._spawn_serial)
	if float(counts[1]) < float(counts[0]) * 1.1:
		out.append("Horda 1 deveria nascer ao menos +10%% (0:%d, 1:%d)" % [counts[0], counts[1]])
	if float(counts[2]) < float(counts[0]) * 1.3:
		out.append("Horda 3 deveria nascer ao menos +30%% (0:%d, 3:%d)" % [counts[0], counts[2]])

## Fome corta toda cura do herói e nenhum ponto de cura escapa do ajuste.
func _hunger(out: Array) -> void:
	for lv in [0, 1, 2, 3]:
		var b := _bat({"fome": lv} if lv > 0 else {})
		b.hero.hp = 1.0
		b._heal_hero(10.0)
		var want: float = 1.0 + 10.0 * (1.0 - 0.25 * lv)
		if not _near(b.hero.hp, want):
			out.append("Fome %d: _heal_hero(10) deveria dar PV %.2f, deu %.2f" % [lv, want, b.hero.hp])
		b.hero.hp = 1.0
		b._add_hp(10.0)
		if not _near(b.hero.hp, want):
			out.append("Fome %d: _add_hp(10) deveria dar PV %.2f, deu %.2f" % [lv, want, b.hero.hp])
	var f := FileAccess.open("res://core/battle.gd", FileAccess.READ)
	var src := f.get_as_text()
	var direct := src.count("hero.hp = minf(hero.max_hp, hero.hp +")
	if direct != 2:
		out.append("só `_heal_hero` e `_add_hp` podem somar PV direto; achei %d pontos (um ponto de cura novo precisa passar pela Fome)" % direct)

func _reward(out: Array) -> void:
	var b := _bat({"horda": 3, "fome": 2})
	if not _near(b.reward_multiplier(), 1.5):
		out.append("nível 5 deveria dar ×1,5 de moeda, deu ×%.3f" % b.reward_multiplier())
	b.descent_depth = 1
	if not _near(b.reward_multiplier(), 1.25 * 1.5):
		out.append("a profundidade deveria multiplicar o bônus das marcas, deu ×%.3f" % b.reward_multiplier())
	if not _near(_bat().reward_multiplier(), 1.0):
		out.append("sem marcas a moeda não muda")
	var res := b.result()
	if int(res.abyss_level) != 5 or res.abyss_marks != {"horda": 3, "fome": 2} or String(res.abyss_start_stage) != "dagruve":
		out.append("result() deveria trazer nível, marcas e fase inicial: %s" % str(res.get("abyss_marks")))

## B-002: recorde, conquistas e liberação por vitória (sem gravar o perfil real).
func _result(level: int, marks: Dictionary, start: String, cleared: Array, hero := "durvall") -> Dictionary:
	return {"won": true, "dead": false, "gold": 100, "kills": 10, "chests": 0, "bosses": 1, "elites": 0, "hero": hero, "stage": start,
		"time": 300.0, "level": 5, "crits": 0, "ones": 0, "still": 0.0, "clean_streak": 0, "boss_ids": [], "stage_ids": [start], "cleared_ids": cleared,
		"codex": {"enemies": {}, "items": {}, "weapons": {}}, "reward_rate": 1.0, "abyss_level": level, "abyss_marks": marks, "abyss_start_stage": start}

func _profile(out: Array) -> void:
	var p := Profile.new({})
	if p.abyss_best_level() != 0:
		out.append("perfil novo: sem recorde")
	# derrota ou sem vitória na fase inicial: nada de recorde
	p.apply_run(_result(4, {"horda": 3, "fome": 1}, "dagruve", []))
	if p.abyss_best_for("durvall", "dagruve") != 0:
		out.append("sem vencer a fase inicial não deveria gravar recorde")
	p.apply_run(_result(4, {"horda": 3, "fome": 1}, "dagruve", ["dagruve"]))
	if p.abyss_best_for("durvall", "dagruve") != 4:
		out.append("vitória na fase inicial deveria gravar recorde 4")
	p.apply_run(_result(2, {"horda": 2}, "dagruve", ["dagruve"]))
	if p.abyss_best_for("durvall", "dagruve") != 4:
		out.append("recorde menor não deveria substituir o maior")
	p.apply_run(_result(0, {}, "dagruve", ["dagruve"]))
	if p.abyss_best_for("durvall", "dagruve") != 4:
		out.append("run sem marcas não mexe no recorde")
	if p.abyss_best_for("kayron", "dagruve") != 0:
		out.append("recorde é por herói")
	if p.data.achievements.has("marcado_pelo_abismo"):
		out.append("nível 4 ainda não dá a conquista de 5 pontos")
	var coins_before := p.coins()
	var r := p.apply_run(_result(5, {"horda": 3, "fome": 2}, "dagruve", ["dagruve"], "kayron"))
	if not r.achievements.has("marcado_pelo_abismo") or p.data.achievements.has("selo_do_abismo"):
		out.append("nível 5 deveria dar só a conquista de 5 pontos: %s" % str(r.achievements))
	if p.coins() - coins_before < 200:
		out.append("a conquista de 5 pontos deveria somar ao menos 200 moedas")
	p.apply_run(_result(15, {"horda": 3, "furia": 3, "carapaca": 3, "pressa": 3, "fome": 3}, "docas", ["docas"], "kayron"))
	if p.abyss_best_level() != 15 or not p.data.achievements.has("selo_do_abismo") or not p.data.achievements.has("abismo_sem_fundo"):
		out.append("nível 15 deveria dar as conquistas de 10 e 15 pontos")
	if p.achievement_progress(Data.table("achievements").achievements.filter(func(a): return a.id == "abismo_sem_fundo")[0]) != "✔":
		out.append("progresso da conquista concluída deveria ser ✔")
	# liberação em Game.battle_ctx: bloqueada = marcas ignoradas
	var original: Profile = Game.profile
	var original_stage: String = Game.run_stage
	Game.profile = Profile.new({})
	Game.profile.data.settings["abyss_marks"] = {"horda": 2, "fome": 9, "tregua": 3, "lixo": 1}
	Game.run_stage = "dagruve"
	if Game.battle_ctx().abyss_marks != {}:
		out.append("sem conquistas: battle_ctx deveria ignorar todas as marcas")
	Game.profile.data.achievements["marca_horda"] = true
	if Game.battle_ctx().abyss_marks != {"horda": 2}:
		out.append("só a marca liberada vale: veio %s" % str(Game.battle_ctx().abyss_marks))
	Game.profile.data.achievements["marca_fome"] = true
	Game.profile.data.achievements["marca_tregua"] = true
	if Game.battle_ctx().abyss_marks != {"horda": 2, "fome": 3, "tregua": 1}:
		out.append("marcas liberadas entram normalizadas (Fome 3, Sem trégua 1): veio %s" % str(Game.battle_ctx().abyss_marks))
	Game.run_stage = "docas"
	if Game.battle_ctx().abyss_marks != {"horda": 2, "fome": 3, "tregua": 1}:
		out.append("a liberação não depende da fase")
	Game.profile = original
	Game.run_stage = original_stage

## B-003: aba "Marcas" do Quartel (grava só num arquivo de teste, nunca no save real).
func _isolate() -> Dictionary:
	var saved := {"profile": Game.profile, "stage": Game.run_stage, "hero": Game.run_hero, "path": Game._save_path}
	Game._save_path = "user://test_abyss_marks_profile.json"
	Game.profile = Profile.new({})
	Game.run_stage = "dagruve"
	Game.run_hero = "durvall"
	return saved

func _restore(saved: Dictionary) -> void:
	for p in [Game._save_path, Game.profile_backup_path(Game._save_path), Game.profile_temp_path(Game._save_path)]:
		if FileAccess.file_exists(p):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(p))
	Game.profile = saved.profile
	Game.run_stage = saved.stage
	Game.run_hero = saved.hero
	Game._save_path = saved.path

func _panel(out: Array) -> void:
	var saved := _isolate()
	var panel := preload("res://ui/abyss_panel.gd").new()
	Engine.get_main_loop().root.add_child(panel)
	for id in AbyssMarks.ids():
		var row: Dictionary = panel._rows[id]
		if not row.minus.disabled or not row.plus.disabled or not row.lock.visible:
			out.append("sem a conquista, %s deve estar desativada e mostrar a condição" % id)
	if panel._rows.horda.lock.text.find("Marca do Abismo: Horda") < 0 or panel._rows.horda.lock.text.find("1.000") < 0:
		out.append("a marca bloqueada deveria citar a conquista e a condição: %s" % panel._rows.horda.lock.text)
	if not panel._reset.disabled:
		out.append("sem marcas escolhidas o botão zerar fica desativado")
	panel._step("horda", 1)
	if Game.abyss_marks() != {}:
		out.append("marca bloqueada não pode gravar")
	Game.profile.data.achievements["marca_horda"] = true
	Game.profile.data.achievements["marca_fome"] = true
	Game.profile.data.achievements["marca_tregua"] = true
	panel.refresh()
	if panel._rows.horda.lock.visible or panel._rows.furia.lock.visible == false:
		out.append("só a marca liberada perde o aviso")
	for i in 5:
		panel._rows.horda.plus.pressed.emit()
	panel._rows.fome.plus.pressed.emit()
	if Game.abyss_marks() != {"horda": 3, "fome": 1}:
		out.append("o + deveria parar em 3: %s" % str(Game.abyss_marks()))
	if not panel._rows.horda.plus.disabled or panel._rows.horda.minus.disabled:
		out.append("no nível máximo só o − fica ativo")
	panel._rows.tregua.plus.pressed.emit()
	panel._rows.tregua.plus.pressed.emit()
	if int(Game.abyss_marks().get("tregua", 0)) != 1 or not panel._rows.tregua.plus.disabled:
		out.append("Sem trégua tem um nível só")
	panel._rows.tregua.minus.pressed.emit()
	if panel._total.text.find("4 / 25") < 0 or panel._total.text.find("+40%") < 0:
		out.append("total deveria mostrar 4 / 25 e +40%%, mostrou: %s" % panel._total.text)
	panel._rows.horda.minus.pressed.emit()
	if int(Game.abyss_marks().get("horda", 0)) != 2:
		out.append("o − deveria baixar para 2")
	if not FileAccess.file_exists(Game._save_path):
		out.append("a escolha deveria ser gravada no perfil (arquivo de teste)")
	if preload("res://ui/abyss_panel.gd").summary_line("dagruve").find("nível 3") < 0:
		out.append("resumo da aba Jogar deveria citar o nível 3")
	panel._reset.pressed.emit()
	if Game.abyss_marks() != {}:
		out.append("zerar deveria limpar as marcas")
	panel.free()
	_restore(saved)

func _menu(out: Array) -> void:
	var saved := _isolate()
	Game.profile.data.achievements["marca_carapaca"] = true
	var menu := (load("res://ui/menu.tscn") as PackedScene).instantiate()
	Engine.get_main_loop().root.add_child(menu)
	var tabs: TabContainer = menu.get_node("Tabs")
	if tabs.get_tab_title(0) != "Jogar" or tabs.get_tab_title(1) != "Marcas":
		out.append("a aba Marcas deveria ser a segunda, logo depois de Jogar: %s / %s" % [tabs.get_tab_title(0), tabs.get_tab_title(1)])
	if menu.stage_info.text.find("Marcas do Abismo") < 0:
		out.append("a aba Jogar deveria resumir as Marcas")
	if menu.play_btn.get_parent() != menu:
		out.append("o botão Jogar deve continuar fixo fora das colunas (BUG-033)")
	menu.free()
	_restore(saved)

## B-001 (SPEC-143): cada marca é liberada pela sua conquista, e a conquista não exige marcas.
func _unlock_by_achievement(out: Array) -> void:
	var p := Profile.new({})
	if not p.abyss_unlocked_ids().is_empty():
		out.append("perfil novo: nenhuma marca liberada")
	var seen := {}
	var achievements: Array = Data.table("achievements").achievements
	for id in AbyssMarks.ids():
		var req := AbyssMarks.requires(String(id))
		var ach: Dictionary = {}
		for a in achievements:
			if String(a.id) == req:
				ach = a
		if req == "" or ach.is_empty():
			out.append("a marca %s precisa de uma conquista que exista (requires=%s)" % [id, req])
			continue
		if seen.has(req):
			out.append("duas marcas usam a mesma conquista: %s" % req)
		seen[req] = true
		if String(ach.reward.get("unlock_mark", "")) != String(id):
			out.append("a conquista %s deveria liberar a marca %s" % [req, id])
		if String(ach.stat).begins_with("abyss"):
			out.append("a conquista %s não pode exigir marcas" % req)
		var q := Profile.new({})
		q.data.achievements[req] = true
		if q.abyss_unlocked_ids() != [id]:
			out.append("ganhar %s deveria liberar só %s, liberou %s" % [req, id, str(q.abyss_unlocked_ids())])
	# a pontuação cobre 5 a 25 pontos
	for want in [5, 10, 15, 20, 25]:
		if not achievements.any(func(a): return String(a.stat) == "abyss_best_level" and int(a.value) == want):
			out.append("falta a conquista de %d pontos" % want)

## B-002 (SPEC-143): Elites despertos, Chefe desperto, Abismo vivo e Sem trégua.
func _quiet(b: Battle) -> Battle:
	b.stage.waves = []
	b.hero.weapons.clear()
	b.hero.max_hp = 999999.0
	b.hero.hp = 999999.0
	return b

func _new_marks(out: Array) -> void:
	_awake_elites(out)
	_awake_boss(out)
	_alive(out)
	_truce(out)
	var all_max := {}
	for id in AbyssMarks.ids():
		all_max[id] = AbyssMarks.max_level(String(id))
	var b := _bat(all_max)
	var cap: float = float(b.gold_cfg().get("reward_cap", 99.0)) if b.has_method("gold_cfg") else 99.0   # teto de moeda da economia de ouro (PLAN-075), se existir
	if b.abyss_level != 25 or not _near(AbyssMarks.reward_bonus(b.abyss_marks), 2.5) or not _near(b.reward_multiplier(), minf(cap, 3.5)):
		out.append("as nove no máximo = 25 pontos e bônus +250%% (teto de moeda %.2f), veio %d e ×%.3f" % [cap, b.abyss_level, b.reward_multiplier()])

func _awake_elites(out: Array) -> void:
	for stage in ["dagruve", "shedaklah"]:
		var base := _bat({}, stage)
		var e0 := base._spawn_elite("zumbi" if stage == "dagruve" else "pudim_negro", Vector2(31, 31))
		for lv in [1, 2, 3]:
			var b := _bat({"elites": lv}, stage)
			var e := b._spawn_elite("zumbi" if stage == "dagruve" else "pudim_negro", Vector2(31, 31))
			var pool := 4 if stage == "dagruve" else 9
			var want: int = mini(e0.affixes.size() + lv, pool)
			if e.affixes.size() != want:
				out.append("%s: Elites despertos %d deveria dar %d afixos, deu %d" % [stage, lv, want, e.affixes.size()])
			if e.affixes.size() != e.affixes.duplicate().filter(func(a): return e.affixes.count(a) == 1).size():
				out.append("os afixos não podem repetir: %s" % str(e.affixes))
	# elite extra por minuto só no nível 3, só antes do chefe
	var counts: Array = []
	for lv in [0, 2, 3]:
		var b := _quiet(_bat({"elites": lv} if lv > 0 else {}, "docas"))
		for i in b.stage.elites.size():
			b._elites_done[i] = true
		for i in 1300:
			b.step(Vector2.ZERO, 0.1)
		counts.append(b.enemies.filter(func(e): return e.affix != "").size())
	if counts[0] != 0 or counts[1] != 0:
		out.append("sem o nível 3 nenhum elite extra deveria nascer: %s" % str(counts))
	if int(counts[2]) < 2:
		out.append("nível 3 deveria soltar 1 elite por minuto (2 em 130 s), veio %d" % int(counts[2]))

func _awake_boss(out: Array) -> void:
	var base := _quiet(_bat({}, "docas"))
	var marked := _quiet(_bat({"chefe": 2}, "docas"))
	for b in [base, marked]:
		b.time = float(b.stage.duration)
		b.step(Vector2.ZERO, 0.1)
	if base.boss == null or marked.boss == null:
		out.append("o chefe deveria nascer na hora")
		return
	if absf(marked.boss.max_hp / base.boss.max_hp - 1.6) > 0.03:
		out.append("Chefe desperto 2 deveria dar +60%% de PV, deu ×%.3f" % (marked.boss.max_hp / base.boss.max_hp))
	if marked.boss.phase_defs.size() != base.boss.phase_defs.size() + 1 or not _near(float(marked.boss.phase_defs[-1].at_hp), 0.15):
		out.append("o chefe desperto deveria ganhar uma fase extra a 15%%")
	if base.boss.phase_defs.size() != Data.table("boss_phases").get(base.boss.id, []).size():
		out.append("sem a marca o chefe mantém as fases dele")
	marked.boss.hp = marked.boss.max_hp * 0.14
	marked._check_boss_phase(marked.boss)
	if marked.boss.phase_index != marked.boss.phase_defs.size():
		out.append("a fase extra deveria disparar com todas as anteriores")
	if not marked.events.any(func(ev): return String(ev.get("text", "")) == "O Abismo desperta o chefe"):
		out.append("o anúncio da fase extra deveria aparecer")
	var again := marked.events.size()
	marked._check_boss_phase(marked.boss)
	if marked.events.size() != again:
		out.append("a fase extra dispara uma única vez")

func _alive(out: Array) -> void:
	var base := _bat({}, "docas")
	var vivo := _bat({"vivo": 3}, "docas")
	var ratio: float = float(vivo.stage_rule.interval) / float(base.stage_rule.interval)
	if absf(ratio - 0.5) > 0.002:
		out.append("Abismo vivo 3 deveria dobrar a frequência (intervalo ×0,5), deu ×%.4f" % ratio)
	var l1 := _bat({"vivo": 1}, "docas")
	if absf(float(l1.stage_rule.interval) / float(base.stage_rule.interval) - 1.0 / 1.3334) > 0.002:
		out.append("Abismo vivo 1 deveria dar +33%% de frequência")
	# run inteira: vale na fase seguinte
	vivo.load_stage("dagruve")
	if absf(float(vivo.stage_rule.interval) / 55.0 - 0.5) > 0.002:
		out.append("Abismo vivo deveria seguir na fase seguinte (rituais de Dagruve), intervalo %.2f" % float(vivo.stage_rule.interval))
	# ilusões ganham chance; o Estige não muda
	var ill_base := _bat({}, "shendilavri")
	var ill := _bat({"vivo": 3}, "shendilavri")
	if not (float(ill.stage_rule.chance) > float(ill_base.stage_rule.chance) * 1.9):
		out.append("ilusões deveriam ganhar chance com Abismo vivo")
	var styx_base := _bat({}, "durao")
	var styx := _bat({"vivo": 3}, "durao")
	if styx.stage_rule != styx_base.stage_rule:
		out.append("o Rio Estige não muda com Abismo vivo")
	if base.stage_rule.interval != Data.table("stage_rules")["docas"].interval:
		out.append("o dado da fase não pode ser alterado (a regra é copiada)")

func _truce(out: Array) -> void:
	var kinds := ["loja", "ferreiro", "arcanista", "curandeiro"]
	for marks in [{}, {"tregua": 1}]:
		var b := _bat(marks, "docas")
		b._first_inter = false
		var seen := {}
		for i in 400:
			b.interactions.clear()
			b._spawn_random_interaction()
			for it in b.interactions:
				seen[String(it.kind)] = true
		var has_shop: bool = kinds.any(func(k): return seen.has(k))
		if marks.is_empty() and not has_shop:
			out.append("sem a marca o sorteio deveria produzir loja, ferreiro ou curandeiro")
		if not marks.is_empty() and has_shop:
			out.append("Sem trégua: nenhuma loja, ferreiro ou curandeiro deveria nascer: %s" % str(seen.keys()))
		if not marks.is_empty() and not seen.has("chest"):
			out.append("o resto das interações continua (baús)")
		var fixed := _bat(marks, "docas")
		fixed.hero.pos = Vector2(5, 5)
		fixed.interactions.clear()
		fixed._place_fixed_interactions()
		var fixed_shop := fixed.interactions.any(func(it): return kinds.has(String(it.kind)))
		if marks.is_empty() and not fixed_shop:
			out.append("Docas tem o ferreiro fixo da Oficina do Cais")
		if not marks.is_empty() and fixed_shop:
			out.append("Sem trégua tira também o ferreiro fixo do cenário")
