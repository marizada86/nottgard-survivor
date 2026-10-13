class_name HeroAbilityVfx
extends RefCounted
## Visual-only presentation of the ten hero active abilities. Radius, reach, duration and every number come from
## the existing events and data/abilities.json; nothing here touches gameplay. Six 256x256 cells, pivot at the centre.
##
## kinds: "arc" (directional sweep, outer edge at `ref_px` to the right), "trail" (directional ribbon, head at
## +`head_px`, tail at -(length_px - head_px)), "pulse" (flat circle whose peak reaches `ref_px`), "follow" (looping
## ring that rides on the hero while the effect lasts), "sigil" (flat circle on the charmed target).

const CELL := 256
const FRAMES := 6
const SPECS := {
	"ruptura_sombria": {"path": "res://assets/vfx/habilidade_durvall.png", "kind": "arc", "ref_px": 103.0, "duration": 0.35},
	"guarda_de_lliira": {"path": "res://assets/vfx/habilidade_brook.png", "kind": "follow", "ref_px": 112.0, "radius": 1.3, "duration": 0.6},
	"comunhao": {"path": "res://assets/vfx/habilidade_maelor.png", "kind": "pulse", "ref_px": 101.0, "duration": 0.9},
	"passo_pelas_sombras": {"path": "res://assets/vfx/habilidade_sylas.png", "kind": "trail", "length_px": 206.0, "head_px": 120.0, "duration": 0.35},
	"sobrecarga_mistica": {"path": "res://assets/vfx/habilidade_kayron.png", "kind": "follow", "ref_px": 116.0, "radius": 1.5, "duration": 0.6},
	"impacto_de_xargath": {"path": "res://assets/vfx/habilidade_korrak.png", "kind": "pulse", "ref_px": 126.0, "duration": 0.5},
	"constelacao": {"path": "res://assets/vfx/habilidade_leoric.png", "kind": "pulse", "ref_px": 121.0, "radius": 3.0, "duration": 0.5},
	"dominacao": {"path": "res://assets/vfx/habilidade_nyrelia.png", "kind": "sigil", "ref_px": 101.0, "radius": 1.2, "duration": 1.4},
	"suspensao_temporal": {"path": "res://assets/vfx/habilidade_zynara.png", "kind": "pulse", "ref_px": 121.0, "duration": 0.8},
	"concordia": {"path": "res://assets/vfx/habilidade_bromnor.png", "kind": "pulse", "ref_px": 122.0, "duration": 0.5},
}
## Abilities whose own `nova` event already draws the plain ring; the sprite on `active` replaces it.
const NOVA_WEAPONS := ["impacto_de_xargath", "concordia"]
static var _frames: Dictionary = {}

static func supports(ability_id: String) -> bool:
	return SPECS.has(ability_id)

static func kind(ability_id: String) -> String:
	return String(SPECS.get(ability_id, {}).get("kind", ""))

static func covers_nova(weapon: String) -> bool:
	return NOVA_WEAPONS.has(weapon)

static func frames_for(ability_id: String) -> SpriteFrames:
	if _frames.has(ability_id):
		return _frames[ability_id]
	var spec: Dictionary = SPECS.get(ability_id, {})
	if spec.is_empty() or not ResourceLoader.exists(spec.path):
		return null
	var built := frames_from_texture(load(spec.path) as Texture2D, float(spec.duration), String(spec.kind) == "follow")
	if built != null:
		_frames[ability_id] = built
	return built

static func frames_from_texture(texture: Texture2D, duration: float, loop: bool = false) -> SpriteFrames:
	if texture == null or texture.get_size() != Vector2(CELL * FRAMES, CELL):
		return null
	var frames := SpriteFrames.new()
	frames.set_animation_loop(&"default", loop)
	frames.set_animation_speed(&"default", FRAMES / duration)
	for index in FRAMES:
		var region := AtlasTexture.new()
		region.atlas = texture
		region.region = Rect2(index * CELL, 0, CELL, CELL)
		frames.add_frame(&"default", region)
	return frames

## Ground (tile) to screen linear map, then rotation by the ground heading and a uniform tiles-per-art-pixel scale.
static func ground_transform(heading: float, tiles_per_px: float, origin_ground: Vector2) -> Transform2D:
	var iso := Transform2D(Iso.to_screen(Vector2(1, 0)), Iso.to_screen(Vector2(0, 1)), Vector2.ZERO)
	var result := iso * Transform2D(heading, Vector2.ZERO) * Transform2D().scaled(Vector2.ONE * tiles_per_px)
	result.origin = Iso.to_screen(origin_ground)
	return result

## `event` is the battle `active` event (pos, radius, ability_id) or the `text` event for the charm sigil (pos).
## `heading` is the ground direction of a directional ability (ignored by round ones). Returns null if unsupported.
static func create_effect(ability_id: String, event: Dictionary, color: Color, heading: Vector2 = Vector2.ZERO, reduced_impact: bool = false) -> Node2D:
	if reduced_impact or not SPECS.has(ability_id) or not event.has("pos"):
		return null
	var frames := frames_for(ability_id)
	if frames == null:
		return null
	var spec: Dictionary = SPECS[ability_id]
	var root := Node2D.new()
	var sprite := AnimatedSprite2D.new()
	sprite.sprite_frames = frames
	sprite.modulate = color
	var material := CanvasItemMaterial.new()
	material.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	sprite.material = material
	root.add_child(sprite)
	var dir := heading.normalized() if heading.length() > 0.01 else Vector2(1, 1).normalized()
	match String(spec.kind):
		"arc":
			var reach := float(event.get("radius", 3.2))
			root.transform = ground_transform(dir.angle(), reach / float(spec.ref_px), event.pos)
		"trail":
			var distance := float(event.get("distance", 3.5))
			var tiles_per_px := distance / float(spec.length_px)
			var center: Vector2 = event.pos - dir * (float(spec.head_px) * tiles_per_px)
			root.transform = ground_transform(dir.angle(), tiles_per_px, center)
		"follow":
			# Child of the hero view: position stays at its origin, drawn behind it.
			var r := float(spec.radius)
			root.scale = Vector2(Iso.TILE_W, Iso.TILE_H) * (r * sqrt(2.0) * 0.5 / float(spec.ref_px))
			root.show_behind_parent = true
		_:
			var radius := float(spec.get("radius", event.get("radius", 2.0)))
			root.position = Iso.to_screen(event.pos)
			root.scale = Vector2(Iso.TILE_W, Iso.TILE_H) * (radius * sqrt(2.0) * 0.5 / float(spec.ref_px))
	if String(spec.kind) != "follow":
		sprite.animation_finished.connect(root.queue_free)
	sprite.play(&"default")
	return root
