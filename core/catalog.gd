class_name Catalog
extends RefCounted
## SPEC-165 (MEC-003): catálogo do jogo (inimigos, armas e feitiços, itens únicos) para o menu de pausa.
## Contas puras: desbloqueados aparecem com nome, ícone e detalhe; bloqueados ficam escuros, sem informação ("???").
## A fonte é `profile.codex` (entre runs) e `battle.codex` (o que apareceu nesta run), no mesmo formato.

const CATEGORIES := ["enemies", "weapons", "items"]
const LABELS := {"enemies": "Inimigos", "weapons": "Armas e feitiços", "items": "Itens únicos"}
const UNKNOWN_NAME := "???"
const UNKNOWN_DETAIL := "[color=#888888]Ainda não descoberto.[/color]"

static func source(category: String) -> Dictionary:
	if category == "items":
		var out := {}
		for u in Data.table("items").uniques:
			out[String(u.id)] = u
		return out
	return Data.table(category)

static func icon_path(category: String, id: String) -> String:
	match category:
		"enemies": return "res://assets/enemies/%s.png" % id
		"weapons": return "res://assets/icons/weapons/%s.png" % id
		"items": return "res://assets/icons/items/%s.png" % id
	return ""

## Entradas da categoria, na ordem dos dados: {id, name, known, seen_run, icon}.
## `known`: já está no perfil ou foi visto nesta run; `seen_run`: apareceu nesta run.
static func entries(category: String, profile_codex: Dictionary, run_codex: Dictionary = {}) -> Array:
	var seen_profile: Dictionary = profile_codex.get(category, {})
	var seen_run: Dictionary = run_codex.get(category, {})
	var out: Array = []
	var src := source(category)
	for id in src:
		if String(id).begins_with("_"):
			continue
		var in_run: bool = bool(seen_run.get(id, false)) if seen_run.has(id) else false
		var known: bool = seen_profile.has(id) or in_run
		out.append({"id": String(id), "name": String(src[id].name) if known else UNKNOWN_NAME, "known": known, "seen_run": in_run,
			"icon": icon_path(category, String(id)) if known else ""})
	return out

## {known, total}: quantos já foram descobertos entre todos.
static func counts(category: String, profile_codex: Dictionary, run_codex: Dictionary = {}) -> Dictionary:
	var known := 0
	var list := entries(category, profile_codex, run_codex)
	for e in list:
		if bool(e.known):
			known += 1
	return {"known": known, "total": list.size()}

## Texto (BBCode) do detalhe; desconhecido não revela nada.
static func detail(category: String, id: String, known: bool) -> String:
	if not known:
		return UNKNOWN_DETAIL
	match category:
		"enemies":
			var d: Dictionary = Data.table("enemies").get(id, {})
			if d.is_empty():
				return UNKNOWN_DETAIL
			return "[b]%s[/b]\nPV %d · CA %d (%d%%) · CAM %d (%d%%) · dano %s · velocidade %.1f\n\n%s\nResistências: %s" % [d.name, d.hp, d.ca, clampi((int(d.ca) - 10) * 3, 0, 30), d.cam, clampi((int(d.cam) - 10) * 3, 0, 30), d.atk, float(d.speed), d.get("note", ""), str(d.get("resist", "nenhuma"))]
		"weapons":
			var w: Dictionary = Data.table("weapons").get(id, {})
			if w.is_empty():
				return UNKNOWN_DETAIL
			return "[b]%s[/b]\nOrigem: %s\nTipo: %s · dano %s (%s, atributo %s) · recarga %.1fs\n\n%s" % [w.name, w.src, w.kind, w.dice if w.dice != "" else "—", w.dtype, w.attr, float(w.cd), w.desc]
		"items":
			for u in Data.table("items").uniques:
				if String(u.id) == id:
					return "[b]%s[/b] [color=#ff8c26](único · %s)[/color]\n%s\n\n%s" % [u.name, u.slot, Items.mods_text(u.mods), u.get("note", "")]
	return UNKNOWN_DETAIL
