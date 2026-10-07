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
	if AbyssMarks.total_level(n) != 6 or AbyssMarks.max_total() != 15:
		out.append("soma 6 e máximo 15 esperados, veio %d e %d" % [AbyssMarks.total_level(n), AbyssMarks.max_total()])
	if AbyssMarks.unlocked({"dagruve": true}, "docas") or not AbyssMarks.unlocked({"dagruve": true}, "dagruve"):
		out.append("a liberação deve depender da vitória na fase")
	if AbyssMarks.ids().size() != 5:
		out.append("a entrega 1 tem 5 marcas")

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
	if p.abyss_best_level() != 0 or p.abyss_unlocked("dagruve"):
		out.append("perfil novo: sem recorde e Marcas bloqueadas")
	# derrota ou sem vitória na fase inicial: nada de recorde
	p.apply_run(_result(4, {"horda": 3, "fome": 1}, "dagruve", []))
	if p.abyss_best_for("durvall", "dagruve") != 0:
		out.append("sem vencer a fase inicial não deveria gravar recorde")
	p.apply_run(_result(4, {"horda": 3, "fome": 1}, "dagruve", ["dagruve"]))
	if p.abyss_best_for("durvall", "dagruve") != 4 or not p.abyss_unlocked("dagruve"):
		out.append("vitória na fase inicial deveria gravar recorde 4 e liberar as Marcas")
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
	Game.profile.data.settings["abyss_marks"] = {"horda": 2, "fome": 9, "lixo": 1}
	Game.run_stage = "dagruve"
	if Game.battle_ctx().abyss_marks != {}:
		out.append("fase não vencida: battle_ctx deveria ignorar as marcas")
	Game.profile.data.cleared["dagruve"] = true
	if Game.battle_ctx().abyss_marks != {"horda": 2, "fome": 3}:
		out.append("fase vencida: battle_ctx deveria entregar as marcas normalizadas, veio %s" % str(Game.battle_ctx().abyss_marks))
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
		if not row.minus.disabled or not row.plus.disabled:
			out.append("fase não vencida: os botões de %s deveriam estar desativados" % id)
	if not panel._lock.visible or not panel._reset.disabled:
		out.append("fase não vencida: aviso de bloqueio visível e botão zerar desativado")
	panel._step("horda", 1)
	if Game.abyss_marks() != {}:
		out.append("fase bloqueada não pode gravar marcas")
	Game.profile.data.cleared["dagruve"] = true
	panel.refresh()
	for i in 5:
		panel._rows.horda.plus.pressed.emit()
	panel._rows.fome.plus.pressed.emit()
	if Game.abyss_marks() != {"horda": 3, "fome": 1}:
		out.append("o + deveria parar em 3: %s" % str(Game.abyss_marks()))
	if not panel._rows.horda.plus.disabled or panel._rows.horda.minus.disabled:
		out.append("no nível máximo só o − fica ativo")
	if panel._total.text.find("4 / 15") < 0 or panel._total.text.find("+40%") < 0:
		out.append("total deveria mostrar 4 / 15 e +40%%, mostrou: %s" % panel._total.text)
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
	Game.profile.data.cleared["dagruve"] = true
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
