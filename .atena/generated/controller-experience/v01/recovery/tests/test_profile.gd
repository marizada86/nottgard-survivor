extends RefCounted

func _result(over: Dictionary = {}) -> Dictionary:
	var r := {"won": true, "dead": false, "extracted": false, "time": 500.0, "kills": 150, "gold": 300, "level": 16, "stage": "dagruve", "hero": "durvall", "bosses": 1,
		"boss_ids": ["sacerdote_mente_derretida"], "elites": 3, "crits": 4, "ones": 1, "chests": 5, "stages_cleared": 1, "stage_ids": ["dagruve"], "cleared_ids": ["dagruve"],
		"final_victory": false, "weapons": [], "codex": {"enemies": {"zumbi": true}, "items": {"machado_de_xargath": true}, "weapons": {"espada_sombria": true}}}
	r.merge(over, true)
	return r

func run() -> Array:
	var out: Array = []
	var p := Profile.new()
	var s := p.apply_run(_result())
	if s.earned != 300 + 60:
		out.append("moedas esperadas 360, veio %d" % s.earned)
	if not p.data.cleared.has("dagruve") or not p.stage_unlocked("shedaklah"):
		out.append("vencer dagruve deveria liberar shedaklah")
	if not p.data.achievements.has("primeiro_sangue") or not p.data.achievements.has("fechadura_aberta") or not p.data.achievements.has("veterano"):
		out.append("conquistas de primeira run não concedidas: %s" % str(p.data.achievements.keys()))
	if not p.data.codex.enemies.has("zumbi"):
		out.append("códex não registrou o zumbi")
	# derrota comum: metade; recusar a primeira oferta de revive: 30%
	var q := Profile.new()
	var d := q.apply_run(_result({"won": false, "dead": true, "gold": 100, "cleared_ids": [], "bosses": 0, "boss_ids": []}))
	if d.earned != 50:
		out.append("derrota deveria render metade (50), veio %d" % d.earned)
	var declined := q.apply_run(_result({"won": false, "dead": true, "gold": 100, "cleared_ids": [], "bosses": 0, "boss_ids": [], "reward_rate": 0.3, "death_reason": "declined_revive"}))
	if declined.earned != 30 or declined.reward_rate != 0.3:
		out.append("recusar revive deveria render 30%% (30), veio %d" % declined.earned)
	# MEC-016: novas estatísticas e conquistas
	var cq := Profile.new()
	cq.apply_run(_result({"won": true, "dead": false, "gold": 10, "cleared_ids": ["dagruve"], "bosses": 3, "boss_ids": ["sacerdote_mente_derretida"], "hero": "brook", "rituals": 10, "bets_won": 5, "loyalty": 3, "level": 30}))
	for ach in ["nivel_30", "tres_chefes_na_run", "mestre_do_ritual", "jogador_de_risco", "fiel_ao_equipamento", "bio_brook"]:
		if not cq.data.achievements.has(ach):
			out.append("conquista deveria ter sido concedida: %s" % ach)
	if not cq.hero_bio_unlocked("brook") or cq.hero_bio_unlocked("durvall"):
		out.append("biografia deveria liberar só para o herói que venceu a fase")
	if cq.upgrade_locked_by("mao_cheia") != "" or cq.upgrade_locked_by("segunda_chance") == "":
		out.append("Mão Cheia deveria estar liberada e Segunda Chance ainda travada")
	# Leoric, o Infeliz: 3 mortes com o Leoric (total) liberam a Teimosia do Infeliz
	var az := Profile.new()
	var dead_leoric := {"won": false, "dead": true, "gold": 10, "cleared_ids": [], "bosses": 0, "boss_ids": [], "hero": "leoric"}
	az.apply_run(_result({"won": false, "dead": true, "gold": 10, "cleared_ids": [], "bosses": 0, "boss_ids": [], "hero": "durvall"}))
	az.apply_run(_result(dead_leoric))
	az.apply_run(_result(dead_leoric))
	if az.data.achievements.has("o_azarado"):
		out.append("Leoric, o Infeliz não pode sair com 2 mortes do Leoric (mortes de outros heróis não contam)")
	if az.upgrade_locked_by("teimosia_do_azarado") != "o_azarado":
		out.append("Teimosia do Infeliz deveria estar travada por Leoric, o Infeliz")
	az.apply_run(_result({"won": true, "dead": false, "hero": "leoric"}))
	if az.data.achievements.has("o_azarado"):
		out.append("vencer com o Leoric não conta como morte")
	az.apply_run(_result(dead_leoric))
	if not az.data.achievements.has("o_azarado"):
		out.append("3 mortes com o Leoric deveriam conceder Leoric, o Infeliz")
	if az.upgrade_locked_by("teimosia_do_azarado") != "" or az.achievement_progress({"id": "x", "stat": "hero_deaths_leoric", "value": 3}) != "3/3":
		out.append("Leoric, o Infeliz deveria liberar a Teimosia do Infeliz e mostrar 3/3")
	# Estátua Viva: 2 minutos seguidos parado numa run
	var still_p := Profile.new()
	still_p.apply_run(_result({"still": 119.0}))
	if still_p.data.achievements.has("estatua_viva"):
		out.append("119 s parado não deveriam conceder Estátua Viva")
	var coins_before := still_p.coins()
	still_p.apply_run(_result({"won": false, "dead": true, "gold": 0, "cleared_ids": [], "bosses": 0, "boss_ids": [], "still": 121.0}))
	if not still_p.data.achievements.has("estatua_viva") or still_p.coins() < coins_before + 150:
		out.append("121 s parado deveriam conceder Estátua Viva e 150 moedas")
	var bios: Dictionary = Data.table("hero_bios")
	for hid in Data.table("heroes"):
		if String(bios.get(hid, "")) == "":
			out.append("herói sem biografia do vault: %s" % hid)
	# melhorias
	var m := Profile.new({"coins": 1000})
	if not m.buy_upgrade("forca_bruta") or m.coins() != 900:
		out.append("compra de melhoria falhou")
	if float(m.meta_mods().get("dmg_pct", 0.0)) < 0.039:
		out.append("melhoria não virou modificador")
	var poor := Profile.new({"coins": 5})
	if poor.buy_upgrade("forca_bruta"):
		out.append("comprou sem moedas")
	# MEC-016: Segunda Chance só depois da conquista de Feng-tu
	m.data.coins = 99999
	if m.buy_upgrade("segunda_chance"):
		out.append("Segunda Chance não deveria ser comprável sem a conquista")
	m.data.achievements["feng_tu_vencida"] = true
	for i in 6:
		m.data.coins = 99999
		m.buy_upgrade("segunda_chance")
	if m.upgrade_level("segunda_chance") != 1:
		out.append("melhoria de nível único passou do máximo")
	# heróis bloqueados
	if p.hero_unlocked("korrak"):
		out.append("Korrak deveria estar bloqueado")
	var kill := p.apply_run(_result({"boss_ids": ["molydeus_chefe"], "bosses": 1}))
	if not p.hero_unlocked("korrak"):
		out.append("derrotar Molydeus deveria liberar Korrak")
	# perfil sobrevive a serialização
	var again := Profile.new(JSON.parse_string(JSON.stringify(p.data)))
	if again.coins() != p.coins() or not again.hero_unlocked("korrak"):
		out.append("perfil não sobreviveu ao JSON")
	# Preferências adicionadas após os saves antigos preservam a intenção de tela cheia.
	var legacy_fullscreen := Profile.new({"settings": {"fullscreen": true}})
	if legacy_fullscreen.data.settings.window_mode != "fullscreen" or not legacy_fullscreen.data.settings.fullscreen:
		out.append("perfil legado em tela cheia não migrou para window_mode")
	var legacy_windowed := Profile.new({"settings": {"fullscreen": false}})
	if legacy_windowed.data.settings.window_mode != "windowed" or legacy_windowed.data.settings.fullscreen:
		out.append("perfil legado em janela não migrou para window_mode")
	var fresh_settings: Dictionary = Profile.new().data.settings
	if fresh_settings.resolution != "1280x720" or not fresh_settings.has("music_muted") or not fresh_settings.has("ambience_muted"):
		out.append("perfil novo não contém as preferências de áudio e vídeo")
	var legacy_hq_profile := Profile.new({"stats": {"runs": 3}, "cleared": {"docas": true}})
	if not legacy_hq_profile.data.has("hqs_seen") or not legacy_hq_profile.data.hqs_seen.is_empty():
		out.append("save antigo deveria migrar para hqs_seen vazio sem perda")
	var hq_reader := Profile.new()
	for hq_id in ["hqn_01", "hqn_02", "hqn_03", "hqn_04"]:
		if not hq_reader.mark_hq_seen(hq_id).is_empty():
			out.append("Cronista não deveria liberar antes de cinco HQs")
	var cronista_unlocks := hq_reader.mark_hq_seen("hqn_05")
	if cronista_unlocks != ["cronista_de_nottgard"] or not hq_reader.data.achievements.has("cronista_de_nottgard") or hq_reader.coins() != 300:
		out.append("quinta HQ completa deveria liberar Cronista e 300 moedas")
	if not hq_reader.mark_hq_seen("hqn_05").is_empty() or hq_reader.coins() != 300:
		out.append("reler uma HQ não deveria repetir progresso ou recompensa")
	var saved_hq_reader := Profile.new(JSON.parse_string(JSON.stringify(hq_reader.data)))
	if saved_hq_reader.data.hqs_seen.size() != 5 or not saved_hq_reader.data.achievements.has("cronista_de_nottgard") or saved_hq_reader.coins() != 300:
		out.append("leituras e recompensa do Cronista deveriam sobreviver à serialização")
	var milestone_progress := Profile.new()
	if not milestone_progress.mark_stage_reached("shedaklah") or milestone_progress.mark_stage_reached("shedaklah"):
		out.append("registro de entrada em fase deveria ser idempotente")
	if not milestone_progress.mark_stage_cleared("docas") or milestone_progress.mark_stage_cleared("docas"):
		out.append("registro de vitória de fase deveria ser idempotente")
	# bônus de conquistas entram no herói
	var b := Battle.new(1, "durvall", "dagruve", {"meta_mods": p.meta_mods(), "bonus_mods": p.bonus_mods()})
	if b.hero.m("dmg_pct") <= 0.0 and p.data.achievements.has("massacre"):
		out.append("bônus de conquista não chegou ao herói")
	return out
