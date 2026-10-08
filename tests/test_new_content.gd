extends RefCounted
## PLAN-081 B-005 (SPEC-150, SPEC-151): armas, magias e equipamentos novos da 0.4.0.

func _bat(seed_value := 3, hero := "durvall") -> Battle:
	var b := Battle.new(seed_value, hero, "dagruve")
	b.hero.pos = Vector2(30, 30)
	b.stage.waves = []
	b.stage.elites = []
	b.stage.duration = 99999
	b._inter_t = 99999.0
	b._breakable_t = 99999.0
	return b

func _foe(b: Battle, at: Vector2) -> Enemy:
	var e := Enemy.make("zumbi", at, 0.0, 1.0, 0)
	b.enemies.append(e)
	return e

func _events_of(b: Battle, kinds: Array) -> int:
	var n := 0
	for ev in b.events:
		if kinds.has(String(ev.type)):
			n += 1
	return n

func _valid_weapon(out: Array, id: String, kind: String, dtype: String, spell: bool, n_levels: int) -> Dictionary:
	var table: Dictionary = Data.table("weapons")
	if not table.has(id):
		out.append("arma %s deveria existir" % id)
		return {}
	var d: Dictionary = table[id]
	var rx := RegEx.new()
	rx.compile("^\\d+d\\d+$")
	if rx.search(String(d.get("dice", ""))) == null:
		out.append("%s: dado inválido %s" % [id, d.get("dice", "")])
	if String(d.kind) != kind or String(d.dtype) != dtype:
		out.append("%s deveria ser %s/%s (é %s/%s)" % [id, kind, dtype, d.kind, d.dtype])
	if Weapon.is_spell(d) != spell:
		out.append("%s deveria ser %s" % [id, "magia" if spell else "arma"])
	if (d.get("levels", []) as Array).size() != n_levels:
		out.append("%s deveria ter %d níveis (tem %d)" % [id, n_levels, (d.get("levels", []) as Array).size()])
	if d.has("evolve"):
		if not Data.table("passives").has(String(d.evolve.passive)):
			out.append("%s: passiva %s inexistente" % [id, d.evolve.passive])
		if not table.has(String(d.evolve.into)):
			out.append("%s: evolução %s inexistente" % [id, d.evolve.into])
	return d

func _offered(id: String) -> bool:
	for seed_value in range(1, 400):
		var b := _bat(seed_value)
		b.hero.weapons = [b.hero.weapons[0]]
		for o in b._build_offer():
			if String(o.t) == "weapon_new" and String(o.id) == id:
				return true
	return false

func run() -> Array:
	var out: Array = []
	_fireball(out)
	return out

# ---------------------------------------------------------------- W1 Bola de Fogo (SPEC-150)
func _fireball(out: Array) -> void:
	var d := _valid_weapon(out, "bola_de_fogo", "nova", "fogo", true, 4)
	if d.is_empty():
		return
	if String(d.get("src", "")) != "Carta: Bola de Fogo":
		out.append("Bola de Fogo deveria ser carta do Nottcard (src %s)" % d.get("src", ""))
	var evo := _valid_weapon(out, "tormenta_de_fogo", "nova", "fogo", true, 0)
	if not d.has("evolve") or String(d.evolve.passive) != "foco_arcano" or String(d.evolve.into) != "tormenta_de_fogo":
		out.append("Bola de Fogo deveria evoluir com Foco Arcano em Tormenta de Fogo")
	if not evo.is_empty() and String(evo.get("src", "")) != "Evolução":
		out.append("Tormenta de Fogo deveria ter src Evolução")
	var b := _bat(4)
	var w := Weapon.make("bola_de_fogo")
	b.hero.weapons.append(w)
	var inside: Array = [_foe(b, b.hero.pos + Vector2(1.5, 0.0)), _foe(b, b.hero.pos + Vector2(0.0, -2.5)), _foe(b, b.hero.pos + Vector2(-3.0, 0.0))]
	var outside := _foe(b, b.hero.pos + Vector2(9.0, 0.0))
	b.events.clear()
	if not b._fire_nova(w.params(), 1.0):
		out.append("Bola de Fogo deveria disparar com inimigos no raio")
	if _events_of(b, ["hit", "miss"]) != inside.size():
		out.append("Bola de Fogo deveria resolver um golpe por inimigo no raio (%d, esperado %d)" % [_events_of(b, ["hit", "miss"]), inside.size()])
	if outside.hp < outside.max_hp:
		out.append("Bola de Fogo não deveria ferir quem está fora do raio")
	var nv := Weapon.make("bola_de_fogo", 5).params()
	if String(nv.dice) != "4d8" or float(nv.radius) <= float(w.params().radius) or float(nv.cd) >= float(w.params().cd):
		out.append("Bola de Fogo Nv 5 deveria ser 4d8, maior e mais rápida (%s, raio %s, recarga %s)" % [nv.dice, nv.radius, nv.cd])
	if not _offered("bola_de_fogo"):
		out.append("Bola de Fogo deveria aparecer nas ofertas NOVA")
