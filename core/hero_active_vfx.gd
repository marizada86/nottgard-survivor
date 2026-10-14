class_name HeroActiveVfx
extends RefCounted
## Presentation only; Battle owns charges, healing, cooldowns and successful activation.

const CONFIG := {
	"brook": {"ability":"guarda_de_lliira", "path":"res://assets/vfx/brook_guarda_de_lliira.png", "pivot":Vector2(128,126), "radius":93.0, "fps":12.0},
	"maelor": {"ability":"comunhao", "path":"res://assets/vfx/maelor_comunhao.png", "pivot":Vector2(130,126), "radius":82.0, "fps":10.0},
}
const MAELOR_DURATION := 0.6
static var _frames: Dictionary = {}

static func supports(event: Dictionary, reduced: bool = false) -> bool:
	var hero := String(event.get("hero_id", ""))
	return not reduced and event.get("type", "") == "active" and CONFIG.has(hero) and event.get("ability_id", "") == CONFIG[hero].ability and event.get("pos") is Vector2

static func frames_from_texture(texture: Texture2D, fps: float) -> SpriteFrames:
	if texture == null or texture.get_size() != Vector2(1536,256): return null
	var frames := SpriteFrames.new()
	frames.set_animation_loop(&"default",true)
	frames.set_animation_speed(&"default",fps)
	for index in 6:
		var frame := AtlasTexture.new()
		frame.atlas = texture
		frame.region = Rect2(index*256,0,256,256)
		frames.add_frame(&"default",frame)
	return frames

static func create_effect(event: Dictionary, battle: Battle, color: Color, reduced: bool = false) -> Node2D:
	if not supports(event,reduced) or battle.hero.id != event.hero_id: return null
	var hero := String(event.hero_id)
	if hero == "brook" and (battle.active_guard <= 0 or battle.active_guard_t <= 0.0): return null
	var config: Dictionary = CONFIG[hero]
	if not _frames.has(hero):
		if not ResourceLoader.exists(config.path): return null
		_frames[hero] = frames_from_texture(load(config.path) as Texture2D,config.fps)
	if _frames[hero] == null: return null
	var root := load("res://ui/hero_active_vfx.gd").new() as Node2D
	root.battle = battle
	root.hero_id = hero
	root.radius = 1.0 if hero == "brook" else float(event.get("radius",0.0))
	if root.radius <= 0.0:
		root.free()
		return null
	var sprite := AnimatedSprite2D.new()
	sprite.sprite_frames = _frames[hero]
	sprite.offset = Vector2(128,128)-config.pivot
	sprite.scale = Vector2(Iso.TILE_W,Iso.TILE_H)*(root.radius*sqrt(2.0)*0.5/float(config.radius))
	sprite.modulate = color
	var additive := CanvasItemMaterial.new()
	additive.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	sprite.material = additive
	root.sprite = sprite
	root.add_child(sprite)
	return root
