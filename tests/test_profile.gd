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
	# derrota: metade
	var q := Profile.new()
	var d := q.apply_run(_result({"won": false, "dead": true, "gold": 100, "cleared_ids": [], "bosses": 0, "boss_ids": []}))
	if d.earned != 50:
		out.append("derrota deveria render metade (50), veio %d" % d.earned)
	# melhorias
	var m := Profile.new({"coins": 1000})
	if not m.buy_upgrade("forca_bruta") or m.coins() != 900:
		out.append("compra de melhoria falhou")
	if float(m.meta_mods().get("dmg_pct", 0.0)) < 0.039:
		out.append("melhoria não virou modificador")
	var poor := Profile.new({"coins": 5})
	if poor.buy_upgrade("forca_bruta"):
		out.append("comprou sem moedas")
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
	# bônus de conquistas entram no herói
	var b := Battle.new(1, "durvall", "dagruve", {"meta_mods": p.meta_mods(), "bonus_mods": p.bonus_mods()})
	if b.hero.m("dmg_pct") <= 0.0 and p.data.achievements.has("massacre"):
		out.append("bônus de conquista não chegou ao herói")
	return out
