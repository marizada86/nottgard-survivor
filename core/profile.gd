class_name Profile
extends RefCounted
## Progressão permanente (moedas, melhorias, conquistas, códex). Sem I/O: Game salva/carrega `data`.

var data := {}

static func fresh() -> Dictionary:
	return {"name": "", "coins": 0, "upgrades": {}, "achievements": {}, "cleared": {}, "welcome_seen": false,
		"stats": {"kills_total": 0, "gold_total": 0, "chests_total": 0, "bosses_total": 0, "elites_total": 0, "boss_kills": {}, "heroes_played": {}, "reached": {}, "runs": 0, "deaths": 0, "best_time": {}},
		"codex": {"enemies": {}, "items": {}, "weapons": {}},
		"settings": {"aim": "auto", "volume": 0.7, "music_volume": 0.8, "sfx_volume": 0.9, "ambience_volume": 0.75, "fullscreen": false, "difficulty": 0}}

func _init(d: Dictionary = {}) -> void:
	data = fresh()
	_merge(data, d)

static func _merge(into: Dictionary, src: Dictionary) -> void:
	for k in src:
		if into.has(k) and into[k] is Dictionary and src[k] is Dictionary:
			_merge(into[k], src[k])
		else:
			into[k] = src[k]

func coins() -> int:
	return int(data.coins)

# ------------------------------------------------------------------ melhorias

func upgrade_defs() -> Array:
	return Data.table("upgrades").upgrades

func upgrade_level(id: String) -> int:
	return int(data.upgrades.get(id, 0))

func upgrade_cost(id: String) -> int:
	for u in upgrade_defs():
		if u.id == id:
			var lv := upgrade_level(id)
			return int(u.costs[lv]) if lv < u.costs.size() else -1
	return -1

func buy_upgrade(id: String) -> bool:
	var c := upgrade_cost(id)
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
func apply_run(result: Dictionary) -> Dictionary:
	var st: Dictionary = data.stats
	st.runs = int(st.runs) + 1
	var mult := 0.5 if bool(result.dead) else 1.0
	var boss_bonus := 0
	for sid in result.cleared_ids:
		boss_bonus += 60 * (1 + int(Data.table("stages")[sid].tier))
	var earned := int(round((float(result.gold) + boss_bonus) * mult))
	data.coins = coins() + earned
	st.kills_total = int(st.kills_total) + int(result.kills)
	st.gold_total = int(st.gold_total) + earned
	st.chests_total = int(st.chests_total) + int(result.chests)
	st.bosses_total = int(st.bosses_total) + int(result.bosses)
	st.elites_total = int(st.elites_total) + int(result.elites)
	if bool(result.dead):
		st.deaths = int(st.deaths) + 1
	for bid in result.boss_ids:
		st.boss_kills[bid] = int(st.boss_kills.get(bid, 0)) + 1
	st.heroes_played[result.hero] = true
	for sid in result.stage_ids:
		st.reached[sid] = true
	for sid in result.cleared_ids:
		data.cleared[sid] = true
	var bt: float = float(st.best_time.get(result.stage, 0.0))
	if bool(result.won) and (bt <= 0.0 or float(result.time) < bt):
		st.best_time[result.stage] = float(result.time)
	var codex: Dictionary = result.codex
	for cat in ["enemies", "items", "weapons"]:
		for k in codex[cat]:
			data.codex[cat][k] = true
	var new_ach := check_achievements(result)
	return {"earned": earned, "coins": coins(), "achievements": new_ach, "half": bool(result.dead)}

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
		"stages_cleared": return float(data.cleared.size())
		"heroes_played": return float(st.heroes_played.size())
		"codex_items": return float(data.codex.items.size())
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
