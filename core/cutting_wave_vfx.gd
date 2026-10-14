class_name CuttingWaveVfx
extends RefCounted
## Accepted cutting-wave family; common projection/cache/timing stays in RadiantOrbVfx.

const FLIGHT_PATH := "res://assets/vfx/onda_cortante_voo.png"
const IMPACT_PATH := "res://assets/vfx/onda_cortante_impacto.png"
const FLIGHT_PIVOT := Vector2(137.5, 127)
const IMPACT_PIVOT := Vector2(128, 128)
const FLIGHT_SCALE := 18.0 / 112.0
const IMPACT_SCALE := 12.0 / 40.0
const WEAPONS := ["lamina_trovejante", "tempestade"]

static func supports_params(params: Dictionary) -> bool:
	return params.get("kind", "") == "bolt" and params.get("dtype", "") == "magico" and WEAPONS.has(String(params.get("_audio_id", params.get("id", ""))))

static func supports_projectile(projectile: Dictionary, reduced: bool = false) -> bool:
	return not reduced and projectile.get("owner", "") == "hero" and supports_params(projectile.get("p", {}))

static func supports_hit(event: Dictionary, reduced: bool = false) -> bool:
	return not reduced and event.get("type", "") == "hit" and event.get("kind", "") == "bolt" and event.get("dtype", "") == "magico" and WEAPONS.has(String(event.get("weapon", ""))) and event.get("pos") is Vector2
