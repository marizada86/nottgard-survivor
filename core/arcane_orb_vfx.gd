class_name ArcaneOrbVfx
extends RefCounted
## Accepted arcane family; common projection/cache/timing stays in RadiantOrbVfx.

const FLIGHT_PATH := "res://assets/vfx/orbe_arcano_voo.png"
const IMPACT_PATH := "res://assets/vfx/orbe_arcano_impacto.png"
const FLIGHT_PIVOT := Vector2(135, 128)
const IMPACT_PIVOT := Vector2(128.5, 124)
const FLIGHT_SCALE := 5.0 / 21.5
const IMPACT_SCALE := 12.0 / 41.0
const WEAPONS := ["raio_enfraquecedor", "dominar_pessoa", "cajado_dos_desejos"]

static func supports_params(params: Dictionary) -> bool:
	return params.get("kind", "") == "bolt" and params.get("dtype", "") == "magico" and WEAPONS.has(String(params.get("_audio_id", params.get("id", ""))))

static func supports_projectile(projectile: Dictionary, reduced: bool = false) -> bool:
	return not reduced and projectile.get("owner", "") == "hero" and supports_params(projectile.get("p", {}))

static func supports_hit(event: Dictionary, reduced: bool = false) -> bool:
	return not reduced and event.get("type", "") == "hit" and event.get("kind", "") == "bolt" and event.get("dtype", "") == "magico" and WEAPONS.has(String(event.get("weapon", ""))) and event.get("pos") is Vector2
