class_name InteractionAnim
extends RefCounted
## SPEC-185 (PLAN-110, B-002): idles em loop de interações, NPCs, pontos de evento, eventos, segredos e ruínas.
## Cada tira (data/interaction_anims.json, gerada por tools/prepare_idle_strips.gd) está na escala da arte estática e traz `pad` px de folga em volta
## (célula = textura estática + 2 x pad). O jogo desenha o quadro atual no mesmo retângulo da arte estática, ampliado pela folga;
## sem tira (ou sem a textura estática), o chamador segue desenhando a arte estática de sempre.

static var _textures := {}

static func spec(asset: String) -> Dictionary:
	if asset == "":
		return {}
	return Data.table("interaction_anims").get("anims", {}).get(asset, {})

static func has(asset: String) -> bool:
	return not spec(asset).is_empty()

static func strip_texture(sp: Dictionary) -> Texture2D:
	var path := String(sp.get("strip", ""))
	if path == "":
		return null
	if not _textures.has(path):
		_textures[path] = load(path) if ResourceLoader.exists(path) else null
	return _textures[path]

static func frame_index(sp: Dictionary, ticks_ms: int, phase_ms: int = 0) -> int:
	var count := maxi(1, int(sp.get("frames", 1)))
	var fps := maxf(0.5, float(sp.get("fps", 5.0)))
	return int(floor(float(ticks_ms + phase_ms) / 1000.0 * fps)) % count

## Fase própria de cada objeto (por posição), para vários iguais não baterem no mesmo quadro.
static func phase_for(pos: Vector2) -> int:
	return absi(int(round(pos.x * 31.0)) * 7 + int(round(pos.y * 17.0)) * 13) * 137 % 1000

## Retângulo da célula inteira, a partir do retângulo de destino da arte estática inteira.
static func cell_dest(sp: Dictionary, full_dest: Rect2, static_size: Vector2) -> Rect2:
	var k := full_dest.size.x / maxf(1.0, static_size.x)
	var pad := float(sp.get("pad", 0)) * k
	return Rect2(full_dest.position - Vector2(pad, pad), Vector2(float(sp.cell[0]), float(sp.cell[1])) * k)

## Arte de acontecimento: o destino dado é o do retângulo visível (HappeningArt); devolve o da textura inteira.
static func full_dest_from_used(texture: Texture2D, used_dest: Rect2) -> Rect2:
	var used := HappeningArt.source_rect(texture)
	var k := used_dest.size.x / maxf(1.0, used.size.x)
	return Rect2(used_dest.position - used.position * k, texture.get_size() * k)

## Desenha o quadro atual no lugar da arte estática; devolve false quando não há tira (o chamador desenha a arte estática).
static func draw(ci: CanvasItem, asset: String, static_texture: Texture2D, full_dest: Rect2, ticks_ms: int, phase_ms: int = 0, tint: Color = Color.WHITE) -> bool:
	if static_texture == null:
		return false
	var sp := spec(asset)
	if sp.is_empty():
		return false
	var strip := strip_texture(sp)
	if strip == null:
		return false
	var cell_w := float(sp.cell[0])
	var cell_h := float(sp.cell[1])
	var index := frame_index(sp, ticks_ms, phase_ms)
	ci.draw_texture_rect_region(strip, cell_dest(sp, full_dest, static_texture.get_size()), Rect2(float(index) * cell_w, 0.0, cell_w, cell_h), tint)
	return true
