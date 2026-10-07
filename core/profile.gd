class_name Profile
extends RefCounted
## Progressão permanente (moedas, melhorias, conquistas, códex). Sem I/O: Game salva/carrega `data`.

var data := {}

static func fresh() -> Dictionary:
	return {"name": "", "coins": 0, "upgrades": {}, "achievements": {}, "cleared": {}, "hqs_seen": {}, "welcome_seen": false,
		"stats": {"kills_total": 0, "gold_total": 0, "chests_total": 0, "bosses_total": 0, "elites_total": 0, "boss_kills": {}, "heroes_played": {}, "reached": {}, "runs": 0, "deaths": 0, "best_time": {}},
		"codex": {"enemies": {}, "items": {}, "weapons": {}},
		"settings": {"aim": "auto", "volume": 0.7, "music_volume": 0.8, "sfx_volume": 0.9, "ambience_volume": 0.75,
			"music_muted": false, "sfx_muted": false, "ambience_muted": false,
			"window_mode": "windowed", "resolution": "1280x720", "fullscreen": false, "difficulty": 0, "abyss_marks": {}}}

func _init(d: Dictionary = {}) -> void:
	data = fresh()
	_merge(data, d)
	_migrate_settings(d.get("settings", {}))
	_migrate_stage_split()

static func _merge(into: Dictionary, src: Dictionary) -> void:
	for k in src:
		if into.has(k) and into[k] is Dictionary and src[k] is Dictionary:
			_merge(into[k], src[k])
		else:
			into[k] = src[k]

func _migrate_stage_split() -> void:
	# Perfis que já concluíram a antiga Dagruve/Docas não perdem acesso à nova Docas.
	if data.cleared.has("dagruve"):
		data.cleared["docas"] = true

func mark_stage_reached(stage_id: String) -> bool:
	if data.stats.reached.has(stage_id):
		return false
	data.stats.reached[stage_id] = true
	return true

func mark_stage_cleared(stage_id: String) -> bool:
	if data.cleared.has(stage_id):
		return false
	data.cleared[stage_id] = true
	return true

func mark_hq_seen(hq_id: String) -> Array:
	if hq_id == "" or not Data.table("hqs").has(hq_id) or data.hqs_seen.has(hq_id):
		return []
	data.hqs_seen[hq_id] = true
	var out: Array = []
	for a in Data.table("achievements").achievements:
		if String(a.get("stat", "")) != "hqs_seen" or data.achievements.has(a.id):
			continue
		if float(data.hqs_seen.size()) >= float(a.get("value", 0)):
			data.achievements[a.id] = true
			out.append(a.id)
			if a.reward.has("coins"):
				data.coins = coins() + int(a.reward.coins)
	return out


func _migrate_settings(source: Dictionary) -> void:
	# `fullscreen` era a única preferência de vídeo até a SPEC-077.
	if not source.has("window_mode"):
		data.settings.window_mode = "fullscreen" if bool(source.get("fullscreen", false)) else "windowed"
	if not (String(data.settings.window_mode) in ["windowed", "borderless", "fullscreen"]):
		data.settings.window_mode = "windowed"
	data.settings.fullscreen = String(data.settings.window_mode) == "fullscreen"

func coins() -> int:
	return int(data.coins)

# ------------------------------------------------------------------ melhorias

func upgrade_defs() -> Array:
	return Data.table("upgrades").upgrades

func upgrade_level(id: String) -> int:
	return int(data.upgrades.get(id, 0))

## MEC-016: aprimoramentos podem exigir uma conquista (campo requires). Quem já comprou continua com o que tem.
func upgrade_locked_by(id: String) -> String:
	for u in upgrade_defs():
		if u.id == id:
			var req := String(u.get("requires", ""))
			if req != "" and not data.achievements.has(req) and upgrade_level(id) == 0:
				return req
	return ""

func upgrade_cost(id: String) -> int:
	for u in upgrade_defs():
		if u.id == id:
			var lv := upgrade_level(id)
			return int(u.costs[lv]) if lv < u.costs.size() else -1
	return -1

func buy_upgrade(id: String) -> bool:
	var c := upgrade_cost(id)
	if upgrade_locked_by(id) != "":
		return false
	if c < 0 or c > coins():
		return false
	data.coins = coins() - c
	data.upgrades[id] = upgrade_level(id) + 1
	return true

func meta_mods() -> Dictionary:
	var m := {}
	for u in upgrade_defs():
		var lv := upgrade_level(u.id)
		if lv > 0:
			Hero.add_mods(m, u.mods, float(lv))
	return m

func bonus_mods() -> Dictionary:
	var m := {}
	for a in Data.table("achievements").achievements:
		if data.achievements.has(a.id):
			var r: Dictionary = a.reward
			if r.has("bonus"):
				Hero.add_mods(m, r.bonus)
			if r.has("rerolls"):
				Hero.add_mods(m, {"rerolls": r.rerolls})
	return m

func run_mods() -> Dictionary:
	var m := meta_mods()
	Hero.add_mods(m, bonus_mods())
	return m

# ------------------------------------------------------------------ desbloqueios

## Biografia (vault de Nottgard) liberada ao vencer uma fase com o herói.
func hero_bio_unlocked(id: String) -> bool:
	return data.achievements.has("bio_" + id)

func hero_unlocked(id: String) -> bool:
	var req: String = Data.table("heroes")[id].unlock
	if req == "start":
		return true
	if req.begins_with("ach:"):
		return data.achievements.has(req.substr(4))
	return false

func stage_unlocked(id: String) -> bool:
	var req: String = Data.table("stages")[id].unlock
	return req == "start" or data.cleared.has(req)

func heroes_sorted() -> Array:
	return Data.table("heroes").keys()

func stages_sorted() -> Array:
	var ids: Array = Data.table("stages").keys()
	ids.sort_custom(func(a, b): return int(Data.table("stages")[a].order) < int(Data.table("stages")[b].order))
	return ids

# ------------------------------------------------------------------ fim de run

## `result`: Battle.result(). Retorna {coins, earned, achievements: [ids novos], deaths}.
func reward_rate_for(result: Dictionary) -> float:
	return clampf(float(result.get("reward_rate", 0.5 if bool(result.dead) else 1.0)), 0.0, 1.0)

func preview_earned(result: Dictionary) -> int:
	var boss_bonus := 0
	for sid in result.cleared_ids:
		boss_bonus += 60 * (1 + int(Data.table("stages")[sid].tier))
	return int(round((float(result.gold) + boss_bonus) * reward_rate_for(result)))

func apply_run(result: Dictionary) -> Dictionary:
	var st: Dictionary = data.stats
	st.runs = int(st.runs) + 1
	var reward_rate := reward_rate_for(result)
	var earned := preview_earned(result)
	data.coins = coins() + earned
	st.kills_total = int(st.kills_total) + int(result.kills)
	st.gold_total = int(st.gold_total) + earned
	st.chests_total = int(st.chests_total) + int(result.chests)
	st.bosses_total = int(st.bosses_total) + int(result.bosses)
	st.elites_total = int(st.elites_total) + int(result.elites)
	if bool(result.dead):
		st.deaths = int(st.deaths) + 1
		if not st.has("hero_deaths"):
			st["hero_deaths"] = {}
		st.hero_deaths[result.hero] = int(st.hero_deaths.get(result.hero, 0)) + 1
	for bid in result.boss_ids:
		st.boss_kills[bid] = int(st.boss_kills.get(bid, 0)) + 1
	st.heroes_played[result.hero] = true
	st["rituals_total"] = int(st.get("rituals_total", 0)) + int(result.get("rituals", 0))
	st["bets_won_total"] = int(st.get("bets_won_total", 0)) + int(result.get("bets_won", 0))
	st["loyalty_total"] = int(st.get("loyalty_total", 0)) + int(result.get("loyalty", 0))
	if not result.cleared_ids.is_empty():
		if not st.has("heroes_cleared"):
			st["heroes_cleared"] = {}
		st.heroes_cleared[result.hero] = true
	for sid in result.stage_ids:
		st.reached[sid] = true
	for sid in result.cleared_ids:
		data.cleared[sid] = true
	var new_abyss_record := record_abyss(result)
	var bt: float = float(st.best_time.get(result.stage, 0.0))
	if bool(result.won) and (bt <= 0.0 or float(result.time) < bt):
		st.best_time[result.stage] = float(result.time)
	var codex: Dictionary = result.codex
	for cat in ["enemies", "items", "weapons"]:
		for k in codex[cat]:
			data.codex[cat][k] = true
	var new_ach := check_achievements(result)
	return {"earned": earned, "coins": coins(), "achievements": new_ach, "reward_rate": reward_rate, "abyss_record": new_abyss_record}

func stat_value(stat: String, run: Dictionary) -> float:
	var st: Dictionary = data.stats
	match stat:
		"kills_total": return float(st.kills_total)
		"gold_total": return float(st.gold_total)
		"chests_total": return float(st.chests_total)
		"bosses_total": return float(st.bosses_total)
		"elites_total": return float(st.elites_total)
		"run_level": return float(run.get("level", 0))
		"run_time": return float(run.get("time", 0.0))
		"run_crits": return float(run.get("crits", 0))
		"run_ones": return float(run.get("ones", 0))
		"run_still": return float(run.get("still", 0.0))
		"run_clean_streak": return float(run.get("clean_streak", 0))
		"stages_cleared": return float(data.cleared.size())
		"heroes_played": return float(st.heroes_played.size())
		"codex_items": return float(data.codex.items.size())
		"hqs_seen": return float(data.hqs_seen.size())
		"run_bosses": return float(run.get("bosses", 0))
		"rituals_total": return float(st.get("rituals_total", 0))
		"bets_won_total": return float(st.get("bets_won_total", 0))
		"loyalty_total": return float(st.get("loyalty_total", 0))
		"abyss_best_level": return float(abyss_best_level())
	if stat.begins_with("hero_deaths_"):
		return float(st.get("hero_deaths", {}).get(stat.substr(12), 0))
	if stat.begins_with("hero_cleared_"):
		return 1.0 if st.get("heroes_cleared", {}).has(stat.substr(13)) else 0.0
	if stat.begins_with("reached_"):
		return 1.0 if st.reached.has(stat.substr(8)) else 0.0
	if stat.begins_with("boss_"):
		var x := stat.substr(5)
		var stages: Dictionary = Data.table("stages")
		var bid: String = stages[x].boss if stages.has(x) else x
		return float(st.boss_kills.get(bid, 0))
	return 0.0

func check_achievements(run: Dictionary) -> Array:
	var out: Array = []
	for a in Data.table("achievements").achievements:
		if data.achievements.has(a.id):
			continue
		if stat_value(a.stat, run) >= float(a.value):
			data.achievements[a.id] = true
			out.append(a.id)
			if a.reward.has("coins"):
				data.coins = coins() + int(a.reward.coins)
	return out

func achievement_progress(a: Dictionary) -> String:
	if data.achievements.has(a.id):
		return "✔"
	var v := stat_value(a.stat, {})
	return "%d/%d" % [int(minf(v, float(a.value))), int(a.value)]

# ------------------------------------------------------------------ Marcas do Abismo (SPEC-141)

## Recorde por herói e fase inicial: o maior nível com que o chefe da fase inicial caiu. Só conta vitória nela.
func record_abyss(result: Dictionary) -> bool:
	var level := int(result.get("abyss_level", 0))
	var start := String(result.get("abyss_start_stage", ""))
	if level <= 0 or start == "" or not result.get("cleared_ids", []).has(start):
		return false
	var st: Dictionary = data.stats
	if not st.has("abyss_best"):
		st["abyss_best"] = {}
	var hero_id := String(result.get("hero", ""))
	if not st.abyss_best.has(hero_id):
		st.abyss_best[hero_id] = {}
	if int(st.abyss_best[hero_id].get(start, 0)) >= level:
		return false
	st.abyss_best[hero_id][start] = level
	return true

func abyss_best_for(hero_id: String, stage_id: String) -> int:
	return int(data.stats.get("abyss_best", {}).get(hero_id, {}).get(stage_id, 0))

## Maior nível entre todos os recordes (base das conquistas de 5, 10 e 15 pontos).
func abyss_best_level() -> int:
	var best := 0
	for hero_id in data.stats.get("abyss_best", {}):
		for stage_id in data.stats.abyss_best[hero_id]:
			best = maxi(best, int(data.stats.abyss_best[hero_id][stage_id]))
	return best

func abyss_unlocked(stage_id: String) -> bool:
	return AbyssMarks.unlocked(data.cleared, stage_id)
