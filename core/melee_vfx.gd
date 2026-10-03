class_name MeleeVfx
extends RefCounted
## Visual apenas: não lê RNG nem altera dano, alcance ou colisões.

const WEAPON_SHAPES := {
	"chicote_avarento": "chicote",
	"espada_sombria": "corte_medio", "golpe_esmagador": "corte_medio",
	"adaga_rapida": "corte_medio", "rajada_infinita": "corte_medio",
	"lamina_da_digestao": "corte_medio",
	"golpe_atordoante": "arco_largo", "espada_do_receptaculo": "arco_largo",
}
static var _frames: Dictionary = {}
const SHAPE_PATHS := {
	"corte_medio": "res://assets/vfx/melee_fisico_corte_medio.png",
	"arco_largo": "res://assets/vfx/melee_fisico_arco_largo.png",
	"estocada_longa": "res://assets/vfx/melee_estocada_longa.png",
	"chicote": "res://assets/vfx/melee_chicote.png",
}

static func shape_for(weapon: String, dtype: String) -> String:
	if weapon == "estocada_mistica":
		return "estocada_longa" if dtype == "magico" else ""
	return String(WEAPON_SHAPES.get(weapon, "")) if dtype == "fisico" else ""

static func projection(direction: Vector2) -> Transform2D:
	# Rotação no chão antes da compressão isométrica, incluindo a diagonal de Iso.
	var rotation := Transform2D(direction.angle() + PI / 4.0, Vector2.ZERO)
	return Transform2D(Vector2(1, 0), Vector2(0, 0.5), Vector2.ZERO) * rotation

static func create_effect(event: Dictionary, color: Color) -> Node2D:
	var shape := shape_for(String(event.get("weapon", "")), String(event.get("dtype", "")))
	if shape.is_empty():
		return null
	if not _frames.has(shape):
		var texture := load(SHAPE_PATHS[shape]) as Texture2D
		if texture == null:
			return null
		var frames := SpriteFrames.new()
		frames.set_animation_loop("default", false)
		frames.set_animation_speed("default", 30.0)
		for index in 6:
			var frame := AtlasTexture.new()
			frame.atlas = texture
			frame.region = Rect2(index * 256, 0, 256, 256)
			frames.add_frame("default", frame)
		_frames[shape] = frames
	var root := Node2D.new()
	root.transform = projection(event.dir)
	root.position = Iso.to_screen(event.pos) + Vector2(0, -18)
	var sprite := AnimatedSprite2D.new()
	sprite.sprite_frames = _frames[shape]
	var radius_fraction := 0.45 if shape in ["estocada_longa", "chicote"] else 0.4
	var reach_scale := float(event.range) * Iso.TILE_W * 0.5 * sqrt(2.0) / (256.0 * radius_fraction)
	sprite.scale = Vector2.ONE * reach_scale
	sprite.modulate = color
	var material := CanvasItemMaterial.new()
	material.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	sprite.material = material
	root.add_child(sprite)
	sprite.animation_finished.connect(root.queue_free)
	sprite.play()
	return root
