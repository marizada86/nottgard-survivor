class_name DivineVisuals
extends RefCounted
## Paleta de resposta visual: não altera dano, atributos ou colisões.

const GOD_COLORS := {
	"Shar": Color("d13e54"), "Sendrinah": Color("f4c542"),
	"Mask": Color("aab4c8"), "Lliira": Color("ff8a2a"),
	"Ghaunadaur": Color("8ad14b"), "Tou Um": Color("65c8ff"),
	"Helion": Color("5d8cff"), "Selûne": Color("8ccbff"),
}

const GOD_OUTLINES := {
	"Shar": Color("260d2b"), "Sendrinah": Color("8c5b12"),
	"Mask": Color("202532"), "Lliira": Color("c6373d"),
	"Ghaunadaur": Color("44205e"), "Tou Um": Color("273c8f"),
	"Helion": Color("e6d3a1"), "Selûne": Color("eaf4ff"),
}

static func color_for(hero_id: String, god: String) -> Color:
	if GOD_COLORS.has(god):
		return GOD_COLORS[god]
	var hero: Dictionary = Data.table("heroes").get(hero_id, {})
	var rgb: Array = hero.get("color", [220, 220, 220])
	return Color(float(rgb[0]) / 255.0, float(rgb[1]) / 255.0, float(rgb[2]) / 255.0)

static func outline_for(hero_id: String, god: String) -> Color:
	if GOD_OUTLINES.has(god):
		return GOD_OUTLINES[god]
	return color_for(hero_id, god).darkened(0.72)
