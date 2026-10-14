class_name UiFonts
extends RefCounted
## SPEC-173 (MEC-066): fonte de títulos escolhida em Opções → TELA → Fonte dos títulos.
## Vale para os títulos e o lettering (Lettering.style, tela de título, título do Quartel). O texto de corpo, os botões e os números
## (dano, HP, tempo) seguem na Alegreya do tema: a fonte decorativa não toca neles, por legibilidade.
## Padrão: IM Fell English (decisão do dono em 2026-10-13). Glifo ausente na candidata cai na Cinzel (fallback).

const DEFAULT_ID := "fell"
const FALLBACK_ID := "cinzel"   # cobre qualquer glifo que a candidata não tenha
## "size" e "outline" compensam o desenho de cada fonte (x-height pequena, traço fino): o contorno do lettering foi pensado
## para o traço grosso da Cinzel. "embolden" engrossa fontes de traço fino demais.
const OPTIONS: Array[Dictionary] = [
	{"id": "fell", "label": "IM Fell English (padrão)", "path": "res://assets/fonts/IMFeENrm28P.ttf", "size": 1.1, "outline": 0.6},
	{"id": "cinzel", "label": "Cinzel Decorative", "path": "res://assets/fonts/CinzelDecorative-Bold.ttf", "size": 1.0, "outline": 1.0},
	{"id": "uncial", "label": "Uncial Antiqua", "path": "res://assets/fonts/UncialAntiqua-Regular.ttf", "size": 1.0, "outline": 0.8},
	{"id": "almendra", "label": "Almendra Display", "path": "res://assets/fonts/AlmendraDisplay-Regular.ttf", "size": 1.15, "outline": 0.5, "embolden": 0.9},
	{"id": "pirata", "label": "Pirata One", "path": "res://assets/fonts/PirataOne-Regular.ttf", "size": 1.3, "outline": 0.7},
]
## Ids antigos: "padrao" era a Cinzel no B-002 (antes do padrão virar a IM Fell); perfis com ele recebem o padrão novo.
const LEGACY_IDS := {"padrao": DEFAULT_ID}
## Caracteres que um título do jogo pode usar (português, pontuação e algarismos). "À" maiúsculo fica de fora: não aparece em
## texto algum do jogo (conferido em data, ui e core) e a Almendra não o tem; o fallback cobre.
const REQUIRED_GLYPHS := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzÁÂÃÇÉÊÍÓÔÕÚàáâãçéêíóôõú0123456789.,:;!?…—–-'\"“”()[]/+%"

static var _cache: Dictionary = {}

static func option_of(id: String) -> Dictionary:
	for o in OPTIONS:
		if String(o.id) == id:
			return o
	return OPTIONS[0]

static func size_scale(id: String = "") -> float:
	return float(option_of(normalize(id if id != "" else current())).size)

static func outline_scale(id: String = "") -> float:
	return float(option_of(normalize(id if id != "" else current())).outline)

static func path_of(id: String) -> String:
	return String(option_of(id).path)

## Opções com arquivo presente; o padrão e o fallback sempre entram.
static func available() -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	for o in OPTIONS:
		var id := String(o.id)
		if id == DEFAULT_ID or id == FALLBACK_ID or ResourceLoader.exists(String(o.path)):
			out.append(o)
	return out

static func normalize(id: Variant) -> String:
	var s := str(id)
	s = String(LEGACY_IDS.get(s, s))
	for o in available():
		if String(o.id) == s:
			return s
	return DEFAULT_ID

## O id gravado no perfil, ou o padrão (sem perfil ainda, valor desconhecido ou arquivo removido).
static func current() -> String:
	if Game.profile == null:
		return DEFAULT_ID
	return normalize(Game.profile.data.settings.get("ui_font", DEFAULT_ID))

static func title_font(id: String = "") -> Font:
	var key := normalize(id if id != "" else current())
	if not _cache.has(key):
		var base := load(path_of(FALLBACK_ID)) as Font
		var font: Font = base
		if key != FALLBACK_ID:
			var candidate := (load(path_of(key)) as FontFile).duplicate() as FontFile
			candidate.fallbacks = [base]
			font = candidate
			var embolden := float(option_of(key).get("embolden", 0.0))
			if embolden > 0.0:  # traço fino demais para o contorno do lettering: engrossa
				var thick := FontVariation.new()
				thick.base_font = candidate
				thick.variation_embolden = embolden
				font = thick
		_cache[key] = font
	return _cache[key]

## Glifos de REQUIRED_GLYPHS que a própria fonte do arquivo não tem (o fallback cobre, mas o título fica misto).
static func missing_glyphs(id: String) -> String:
	var font := load(path_of(id)) as Font
	var out := ""
	for i in REQUIRED_GLYPHS.length():
		if not font.has_char(REQUIRED_GLYPHS.unicode_at(i)):
			out += REQUIRED_GLYPHS[i]
	return out
