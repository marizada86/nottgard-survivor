extends RefCounted
## Resolve acesso e apresentação inicial às HQs via conquistas existentes.

const ORDER := ["hqn_11", "hqn_12", "hqn_13", "hqn_14"]

static func unlocked_ids(achievements: Dictionary) -> Array[String]:
	var out: Array[String] = []
	var hqs: Dictionary = Data.table("hqs")
	for hq_id in ORDER:
		var hq: Dictionary = hqs.get(hq_id, {})
		if not hq.is_empty() and achievements.has(String(hq.get("achievement", ""))):
			out.append(hq_id)
	return out

static func newly_earned_ids(achievement_ids: Array) -> Array[String]:
	var out: Array[String] = []
	var hqs: Dictionary = Data.table("hqs")
	for hq_id in ORDER:
		var hq: Dictionary = hqs.get(hq_id, {})
		if not hq.is_empty() and achievement_ids.has(String(hq.get("achievement", ""))):
			out.append(hq_id)
	return out
