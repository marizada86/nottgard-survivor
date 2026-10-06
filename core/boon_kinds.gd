class_name BoonKinds
extends RefCounted
## SPEC-129 B-002: bênçãos com dinâmica própria, em vez de só "+X, mas -Y".
##  - `oath` (Juramento de Lliira): janelas periódicas de objetivo; cumprir dá Glória, quebrar dá Julgamento (nunca mata).
##  - `path` (Caminho da Estrela, Tou Um): uma estrela recua quando o herói chega perto; segui-la cura, seguir demais cansa.
## Parâmetros em data/boons.json (blocos `oath` e `path`). A Battle chama `reset_stage`, `step` e `on_hit`;
## a UI lê `hud_lines` e `star_pos`. Sem referência guardada à Battle (evita ciclo de RefCounted).
## A estrela usa RNG própria (semente da run), para não deslocar a da batalha.

const OATH_HIT_SOURCES := ["hit", "aoe", "trap"]   # puddle, névoa e custos de pacto não quebram juramento

var oath := {}   # {open, window_t, to_open, hits}
var star := {}   # {pos, follow_t, has}
var oath_kept := 0      # contadores da run (balanceamento e conquistas futuras)
var oath_broken := 0
var star_exhausted := 0
var _rng := RandomNumberGenerator.new()
var _seeded := false
var _prev_pos := Vector2.ZERO
var _have_prev := false

static func boon_of(b: Battle, kind: String) -> Dictionary:
	for bn in b.hero.boons:
		if String(bn.get("kind", "")) == kind:
			return bn
	return {}

## Texto da regra, gerado dos parâmetros (o cartão de oferta nunca diverge dos dados).
static func describe(boon: Dictionary) -> String:
	match String(boon.get("kind", "")):
		"oath":
			var o: Dictionary = boon.oath
			return "A cada %d s abre um juramento de %d s: levar no máximo %d golpes.\nCumprido: %s por %d s.\nQuebrado: %s por %d s (sem perda de PV)." % [
				int(o.cycle), int(o.window), int(o.max_hits), Items.mods_text(o.reward.mods), int(o.reward.duration), Items.mods_text(o.penalty.mods), int(o.penalty.duration)]
		"path":
			var p: Dictionary = boon.path
			return "Uma estrela aparece no mapa e recua quando você chega perto. Andar na direção dela cura %.1f PV/s.\nA cada %d s seguindo vem a Exaustão: %s por %d s." % [
				float(p.heal), int(p.exhaust_after), Items.mods_text(p.exhaust.mods), int(p.exhaust.duration)]
	return ""

func reset_stage(_b: Battle) -> void:
	oath = {"armed": false, "open": false, "window_t": 0.0, "to_open": 0.0, "hits": 0}
	star = {"has": false, "pos": Vector2.ZERO, "follow_t": 0.0}
	_have_prev = false

func step(b: Battle, dt: float) -> void:
	if oath.is_empty():
		reset_stage(b)
	var o := boon_of(b, "oath")
	if not o.is_empty():
		_step_oath(b, o.oath, dt)
	var p := boon_of(b, "path")
	if not p.is_empty():
		_step_path(b, p.path, dt)
	else:
		star.has = false
	_prev_pos = b.hero.pos
	_have_prev = true

func on_hit(b: Battle, src: String) -> void:
	if bool(oath.get("open", false)) and src in OATH_HIT_SOURCES:
		oath.hits = int(oath.hits) + 1

# ------------------------------------------------------------------ juramento

func _step_oath(b: Battle, o: Dictionary, dt: float) -> void:
	if not bool(oath.armed):
		oath.armed = true
		oath.to_open = float(o.first_delay)
	oath.to_open = float(oath.to_open) - dt
	if bool(oath.open):
		oath.window_t = float(oath.window_t) - dt
		if int(oath.hits) > int(o.max_hits):
			_close_oath(b, o, false)
		elif float(oath.window_t) <= 0.0:
			_close_oath(b, o, true)
	elif float(oath.to_open) <= 0.0:
		oath.open = true
		oath.window_t = float(o.window)
		oath.to_open = float(o.cycle)
		oath.hits = 0
		b.events.append({"type": "toast", "text": "Juramento de Lliira: aguente %d s com no máximo %d golpes." % [int(o.window), int(o.max_hits)]})

func _close_oath(b: Battle, o: Dictionary, kept: bool) -> void:
	oath.open = false
	if kept:
		oath_kept += 1
	else:
		oath_broken += 1
	var side: Dictionary = o.reward if kept else o.penalty
	b.hero.set_kind_buff("oath_glory" if kept else "oath_judgment", side.mods, float(side.duration))
	b.hero.kind_buffs.erase("oath_judgment" if kept else "oath_glory")
	b.hero.recalc()
	b.events.append({"type": "toast", "text": ("Glória de Lliira: %s por %d s." if kept else "Julgamento da Glória: %s por %d s.") % [Items.mods_text(side.mods), int(side.duration)]})

# ------------------------------------------------------------------ estrela

func _step_path(b: Battle, p: Dictionary, dt: float) -> void:
	if not _seeded:
		_rng.seed = b._seed ^ 0x57A2
		_seeded = true
	var hero_pos: Vector2 = b.hero.pos
	if not bool(star.get("has", false)) or hero_pos.distance_to(star.pos) <= float(p.retreat_dist):
		_place_star(b, p)
	if not _have_prev:
		return
	var moved: Vector2 = hero_pos - _prev_pos
	if moved.length() < 0.001:
		return
	var to_star: Vector2 = (star.pos - hero_pos).normalized()
	if moved.normalized().dot(to_star) < cos(deg_to_rad(float(p.cone_deg))):
		return
	b._heal_hero(float(p.heal) * dt)
	star.follow_t = float(star.follow_t) + dt
	if float(star.follow_t) >= float(p.exhaust_after):
		star.follow_t = 0.0
		star_exhausted += 1
		b.hero.set_kind_buff("star_exhaust", p.exhaust.mods, float(p.exhaust.duration))
		b.events.append({"type": "toast", "text": "Exaustão: você seguiu a estrela por tempo demais (%s por %d s)." % [Items.mods_text(p.exhaust.mods), int(p.exhaust.duration)]})

func _place_star(b: Battle, p: Dictionary) -> void:
	var margin := 4.0
	var best := b.map_size * 0.5
	var best_d := -1.0
	for i in 16:
		var ang := _rng.randf() * TAU
		var cand: Vector2 = b.hero.pos + Vector2(cos(ang), sin(ang)) * float(p.spawn_dist)
		cand = cand.clamp(Vector2(margin, margin), b.map_size - Vector2(margin, margin))
		var d: float = cand.distance_to(b.hero.pos)
		if d > best_d:
			best_d = d
			best = cand
		if d >= float(p.min_far):
			break
	star.pos = best
	star.has = true

func star_pos() -> Variant:
	if bool(star.get("has", false)):
		return star.pos
	return null

# ------------------------------------------------------------------ interface

func hud_lines(b: Battle) -> Array:
	var out: Array = []
	var o := boon_of(b, "oath")
	if not o.is_empty() and not oath.is_empty():
		if bool(oath.open):
			out.append("⚖ Juramento — %d s · golpes %d/%d" % [maxi(0, int(ceil(float(oath.window_t)))), int(oath.hits), int(o.oath.max_hits)])
		elif float(oath.to_open) > 0.0:
			out.append("⚖ Próximo juramento em %d s" % int(ceil(float(oath.to_open))))
	for id in b.hero.kind_buffs:
		var kb: Dictionary = b.hero.kind_buffs[id]
		var title: String = {"oath_glory": "Glória", "oath_judgment": "Julgamento", "star_exhaust": "Exaustão"}.get(id, id)
		out.append("☼ %s: %s (%d s)" % [title, Items.mods_text(kb.mods), int(ceil(float(kb.t)))])
	var p := boon_of(b, "path")
	if not p.is_empty() and not star.is_empty():
		out.append("★ Estrela — fé %d/%d s" % [int(float(star.follow_t)), int(p.path.exhaust_after)])
	return out
