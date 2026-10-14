class_name RadiantOrbVfx
extends RefCounted
## Presentation only. No projectile state or simulation changes.

const FLIGHT_PATH := "res://assets/vfx/orbe_radiante_voo.png"
const IMPACT_PATH := "res://assets/vfx/orbe_radiante_impacto.png"
const CELL := 256
const FRAME_COUNT := 4
const FLIGHT_FPS := 12.0
const IMPACT_DURATION := 0.24
const FLIGHT_SCALE := 5.0 / 27.0
const IMPACT_SCALE := 12.0 / 46.0
const HEIGHT := Vector2(0, -16)
const MAX_IMPACTS := 32
const WEAPONS := ["raio_de_luz", "luz_mais_pura", "marca_da_retidao"]
static var _textures: Dictionary = {}

static func supports_params(params: Dictionary) -> bool:
	return params.get("kind", "") == "bolt" and params.get("dtype", "") == "radiante" and WEAPONS.has(String(params.get("_audio_id", params.get("id", ""))))

static func supports_projectile(projectile: Dictionary, reduced: bool = false) -> bool:
	return not reduced and projectile.get("owner", "") == "hero" and supports_params(projectile.get("p", {}))

static func supports_hit(event: Dictionary, reduced: bool = false) -> bool:
	return not reduced and event.get("type", "") == "hit" and event.get("kind", "") == "bolt" and event.get("dtype", "") == "radiante" and WEAPONS.has(String(event.get("weapon", ""))) and event.get("pos") is Vector2

static func valid_texture(texture: Texture2D) -> bool:
	return texture != null and texture.get_size() == Vector2(CELL * FRAME_COUNT, CELL)

static func texture(path: String) -> Texture2D:
	if not _textures.has(path):
		# Invalid/missing textures stay null until a new run/cache reset; no per-frame load retries.
		var loaded := load(path) as Texture2D if ResourceLoader.exists(path) else null
		_textures[path] = loaded if valid_texture(loaded) else null
	return _textures[path] as Texture2D

static func flight_frame(seconds: float) -> int:
	return int(maxf(0.0, seconds) * FLIGHT_FPS) % FRAME_COUNT

static func impact_frame(seconds: float) -> int:
	return mini(FRAME_COUNT - 1, int(maxf(0.0, seconds) * FRAME_COUNT / IMPACT_DURATION))

static func screen_position(pos: Vector2) -> Vector2:
	return Iso.to_screen(pos) + HEIGHT

static func flight_angle(direction: Vector2) -> float:
	return Iso.to_screen(direction).angle()
