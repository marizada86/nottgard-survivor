class_name RunRecord
extends RefCounted
## Contrato v1 de estatisticas. Nao usa RNG da simulacao nem altera gameplay.

const SCHEMA_VERSION := 1
const SCORE_VERSION := "points-v1"
const MAX_HISTORY := 2000
const MAX_RECORD_BYTES := 3 * 1024 * 1024
var run_id := ""
var started_at := ""
var start_stage := ""
var source := "windows"
var history: Array = []
var reasons: Array = []
var damage: Dictionary = {}
var kills := {"common": 0, "elite": 0, "boss": 0, "objects": 0}
var context: Dictionary = {}
var history_truncated := false
var healing := 0.0
var damage_received := 0.0
var revives := 0
var _created_ticks := 0

func begin(b: Object, ctx: Dictionary = {}, origin := "windows", qa := false) -> void:
	run_id = Crypto.new().generate_random_bytes(16).hex_encode()
	started_at = Time.get_datetime_string_from_system(true) + "Z"
	_created_ticks = Time.get_ticks_msec()
	start_stage = b.stage_id
	source = origin
	context = clean(ctx)
	if qa:
		mark("qa")
	if Version.qa_enabled():
		mark("internal_profile")
	if Version.build_id() == "dev":
		mark("development_build")
	checkpoint(b, "start")

func mark(reason: String) -> void:
	if not reasons.has(reason):
		reasons.append(reason)

static func clean(value: Variant) -> Variant:
	if value is Dictionary:
		var out := {}
		for key in value:
			if String(key).to_lower() in ["email", "token", "password", "secret", "username"]:
				continue
			out[String(key)] = clean(value[key])
		return out
	if value is Array:
		return value.map(func(v): return clean(v))
	if value is Vector2:
		return [value.x, value.y]
	if value is Color:
		return value.to_html()
	if value is Object:
		return null
	return value

static func build(b: Object) -> Dictionary:
	var h = b.hero
	var weapons: Array = []
	for w in h.weapons:
		weapons.append({"id": w.id, "level": w.level, "granted": w.granted})
	return clean({"level": h.level, "weapons": weapons, "items": h.items, "passives": h.passives,
		"boons": h.boons, "synergies": h.synergies, "mods": h.mods, "hp": h.hp, "max_hp": h.max_hp})

func checkpoint(b: Object, kind: String, details: Dictionary = {}) -> void:
	if run_id == "":
		return
	if history.size() >= MAX_HISTORY:
		history_truncated = true
		return
	history.append({"kind": kind, "time": b.run_time, "stage": b.stage_id,
		"details": clean(details), "build": build(b)})

func hit(source_id: String, amount: float, hp_before: float) -> void:
	if run_id == "":
		return
	var effective := minf(maxf(0.0, amount), maxf(0.0, hp_before))
	var entry: Dictionary = damage.get(source_id, {"effective": 0.0, "overkill": 0.0, "hits": 0})
	entry.effective += effective
	entry.overkill += maxf(0.0, amount - effective)
	entry.hits += 1
	damage[source_id] = entry

func killed(kind: String) -> void:
	kills[kind] = int(kills.get(kind, 0)) + 1

static func score(counters: Dictionary, cleared: Array) -> Dictionary:
	var unique := {}
	for id in cleared:
		unique[String(id)] = true
	var parts := {"common": int(counters.get("common", 0)), "elite": int(counters.get("elite", 0)) * 10,
		"boss": int(counters.get("boss", 0)) * 100, "stages": unique.size() * 500}
	return {"version": SCORE_VERSION, "total": parts.common + parts.elite + parts.boss + parts.stages, "parts": parts}

func snapshot(b: Object, outcome := "incomplete") -> Dictionary:
	var result: Dictionary = b.result()
	var balance := {}
	for table in ["heroes", "weapons", "enemies", "difficulty", "stages", "items", "boons", "passives", "abilities", "upgrades", "item_effects", "boon_effects", "boss_phases", "stage_rules", "stage_events", "scenery", "stage_structures", "level_design"]:
		balance[table] = Data.table(table)
	balance.rules = {"build": Version.build_id(), "score": SCORE_VERSION}
	var record: Dictionary = {"schema_version": SCHEMA_VERSION, "game_id": "nottgard-survivors", "run_id": run_id,
		"started_at": started_at, "build_id": Version.build_id(), "game_version": Version.VERSION,
		"balance_version": JSON.stringify(balance).sha256_text().substr(0, 16), "source": source,
		"hero_id": b.hero.id, "seed": b._seed, "start_stage": start_stage, "stage": b.stage_id,
		"difficulty": b.difficulty, "context": context, "active_seconds": b.run_time,
		"wall_seconds": maxf(0.0, float(Time.get_ticks_msec() - _created_ticks) / 1000.0),
		"outcome": outcome, "result": clean(result), "counters": kills.duplicate(),
		"score": score(kills, result.get("cleared_ids", [])), "eligibility_reasons": reasons.duplicate(),
		"build": build(b), "history": history.duplicate(true), "history_truncated": history_truncated,
		"damage_by_source": damage.duplicate(true), "healing": healing, "revives": revives, "damage_received": damage_received}
	while record.history.size() > 2 and JSON.stringify(record).to_utf8_buffer().size() > MAX_RECORD_BYTES:
		record.history = [record.history[0]] + record.history.slice(1 + int((record.history.size() - 1) / 2))
		record.history_truncated = true
	return record
