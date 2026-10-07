class_name DivineVisuals
extends RefCounted
## Resolução puramente visual. Não altera dano, atributos, colisões ou RNG.

const DIVINE_THEMES := {
	"Shar": {"primary": Color("b56bff"), "aura_accent": Color("6b2a91"), "impact_accent": Color("d6a8ff"), "outline": Color("160d24"), "motif": "eclipse"},
	"Sendrinah": {"primary": Color("f4c542"), "aura_accent": Color("fff0b3"), "impact_accent": Color("ffffff"), "outline": Color("8c5b12"), "motif": "ascend"},
	"Mask": {"primary": Color("aeb8c8"), "aura_accent": Color("536174"), "impact_accent": Color("dce5f0"), "outline": Color("171c27"), "motif": "shadow_ribbon"},
	"Lliira": {"primary": Color("ffa12d"), "aura_accent": Color("ffe05c"), "impact_accent": Color("f04a3a"), "outline": Color("9e2f37"), "motif": "three_stars"},
	"Ghaunadaur": {"primary": Color("8ad14b"), "aura_accent": Color("a56bda"), "impact_accent": Color("c58bff"), "outline": Color("44205e"), "motif": "elder_eye"},
	"Tou Um": {"primary": Color("6fd4ff"), "aura_accent": Color("f1fbff"), "impact_accent": Color("b9d0ff"), "outline": Color("273c8f"), "motif": "north_star"},
	"Selûne": {"primary": Color("8ccbff"), "aura_accent": Color("eaf4ff"), "impact_accent": Color("ffffff"), "outline": Color("355f94"), "motif": "seven_stars"},
}

const HERO_BASE_COLORS := {
	# Identidades canônicas que não coincidem com a sobreposição pós-altar.
	"kayron": Color("d13e54"),
	"maelor": Color("f4c542"),
}

static func is_divine_affinity(god: String) -> bool:
	return DIVINE_THEMES.has(god)

static func base_color_for(hero_id: String) -> Color:
	if HERO_BASE_COLORS.has(hero_id):
		return HERO_BASE_COLORS[hero_id]
	var hero: Dictionary = Data.table("heroes").get(hero_id, {})
	var rgb: Array = hero.get("color", [220, 220, 220])
	return Color(float(rgb[0]) / 255.0, float(rgb[1]) / 255.0, float(rgb[2]) / 255.0)

static func resolve(hero_id: String, god: String, visual_boon_selected: bool) -> Dictionary:
	if visual_boon_selected and is_divine_affinity(god):
		return DIVINE_THEMES[god].duplicate(true)
	var primary := base_color_for(hero_id)
	return {
		"primary": primary,
		"aura_accent": primary.lightened(0.24),
		"impact_accent": primary.lightened(0.38),
		"outline": primary.darkened(0.72),
		"motif": "base",
	}

static func color_for(hero_id: String, god: String, visual_boon_selected: bool = false) -> Color:
	return resolve(hero_id, god, visual_boon_selected).primary

static func outline_for(hero_id: String, god: String, visual_boon_selected: bool = false) -> Color:
	return resolve(hero_id, god, visual_boon_selected).outline
