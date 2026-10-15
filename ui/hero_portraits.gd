class_name HeroPortraits
extends RefCounted
## SPEC-178: retrato do herói por tela. O menu usa `assets/portraits/<id>.png`; a Ficha (C) e o HUD têm
## imagens próprias (faixa 3:1 e quadrado) e, sem elas, caem no retrato do menu.
const ROOT := "res://assets/portraits/"
const MENU := "menu"
const FICHA := "ficha"
const HUD := "hud"

static func path(id: String, kind: String) -> String:
	var own := path_for_kind(id, kind)
	if own != "" and ResourceLoader.exists(own):
		return own
	var menu_path := "%s%s.png" % [ROOT, id]
	return menu_path if ResourceLoader.exists(menu_path) else ""

## Caminho do arquivo próprio do tipo (sem fallback); vazio para o menu.
static func path_for_kind(id: String, kind: String) -> String:
	return "" if kind == MENU else "%s%s/%s.png" % [ROOT, kind, id]

## Há imagem própria do tipo (e não só o retrato do menu)?
static func has_own(id: String, kind: String) -> bool:
	var own := path_for_kind(id, kind)
	return own != "" and ResourceLoader.exists(own)

static func texture(id: String, kind: String) -> Texture2D:
	var p := path(id, kind)
	return load(p) as Texture2D if p != "" else null
