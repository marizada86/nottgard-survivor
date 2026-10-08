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
	_shadow_blade(out)
	_armor_break(out)
	_items(out)
	_coracao(out)
	_icons(out)
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

# ---------------------------------------------------------------- W2 Lâmina de Sombra (SPEC-150)
func _shadow_blade(out: Array) -> void:
	var d := _valid_weapon(out, "lamina_de_sombra", "bolt", "magico", true, 4)
	if d.is_empty():
		return
	if d.has("evolve"):
		out.append("Lâmina de Sombra não evolui na 0.4.0")
	if int(d.get("ignore_def", 0)) != 1 or int(Weapon.make("lamina_de_sombra", 5).params().get("ignore_def", 0)) != 2:
		out.append("Lâmina de Sombra deveria ignorar 1 de defesa e 2 no Nv 5")
	var e := Enemy.make("zumbi", Vector2(0, 0), 0.0, 1.0, 0)
	e.cam = 20
	if e.typed_evasion("magico", 5) >= e.typed_evasion("magico"):
		out.append("ignorar defesa deveria reduzir a esquiva do alvo")
	if e.typed_evasion("magico", 100) != 0.0:
		out.append("ignorar defesa de mais não pode dar esquiva negativa")
	e.ca = 20
	e.cam = 10
	if e.typed_evasion("fisico", 5) >= e.typed_evasion("fisico"):
		out.append("ignorar defesa em ataque físico deveria descontar a CA")
	# a chance de acerto sobe de verdade em _hero_hit: alvo de CAM 20, mesma semente, com e sem ignore_def
	var hits := {}
	for ignore in [0, 6]:
		var b := _bat(9)
		var foe := _foe(b, b.hero.pos + Vector2(3, 0))
		foe.cam = 20
		foe.max_hp = 1.0e9
		foe.hp = 1.0e9
		var n := 0
		for i in 500:
			if b._hero_hit(foe, {"dice": "1d4", "dtype": "magico", "attr": "inteligencia", "ignore_def": ignore}, true):
				n += 1
		hits[ignore] = n
	if int(hits[6]) <= int(hits[0]) + 25:
		out.append("ignore_def deveria aumentar os acertos contra CAM alta (sem: %d, com: %d de 500)" % [hits[0], hits[6]])
	if not _offered("lamina_de_sombra"):
		out.append("Lâmina de Sombra deveria aparecer nas ofertas NOVA")

# ---------------------------------------------------------------- W3 Romper Armadura (SPEC-150)
func _armor_break(out: Array) -> void:
	var d := _valid_weapon(out, "romper_armadura", "melee", "fisico", false, 4)
	if d.is_empty():
		return
	if not d.has("evolve") or String(d.evolve.passive) != "cota_de_malha" or String(d.evolve.into) != "esmagar_defesas":
		out.append("Romper Armadura deveria evoluir com Cota de Malha em Esmagar Defesas")
	var evo := _valid_weapon(out, "esmagar_defesas", "melee", "fisico", false, 0)
	if not evo.is_empty() and (String(evo.get("src", "")) != "Evolução" or int(evo.get("weaken", 0)) != 3):
		out.append("Esmagar Defesas deveria ser evolução com enfraquece 3")
	var b := _bat(11)
	var foe := _foe(b, b.hero.pos + Vector2(1.0, 0.0))
	foe.ca = 14
	foe.cam = 12
	b._apply_effects(foe, Weapon.make("romper_armadura").params())
	if foe.ca != 13 or foe.cam != 11:
		out.append("Romper Armadura Nv 1 deveria tirar 1 de CA e de CAM (CA %d, CAM %d)" % [foe.ca, foe.cam])
	b._apply_effects(foe, Weapon.make("romper_armadura", 3).params())
	if foe.ca != 11 or foe.cam != 9:
		out.append("Romper Armadura Nv 3 deveria tirar 2 (CA %d, CAM %d)" % [foe.ca, foe.cam])
	var shot := _bat(12)
	var w := Weapon.make("romper_armadura")
	shot.hero.weapons.append(w)
	var near := _foe(shot, shot.hero.pos + Vector2(1.2, 0.0))
	near.max_hp = 1.0e6
	near.hp = 1.0e6
	var fired := false
	for i in 40:
		if shot._fire_melee(w.params(), 1.0):
			fired = true
	if not fired:
		out.append("Romper Armadura deveria golpear um alvo no cone")
	if near.ca >= 12 and near.hp >= near.max_hp:
		out.append("Romper Armadura deveria ferir ou enfraquecer o alvo em 40 golpes")
	if not _offered("romper_armadura"):
		out.append("Romper Armadura deveria aparecer nas ofertas NOVA")

# ---------------------------------------------------------------- Equipamentos únicos (SPEC-151)
# id -> {slot, tier, mods, curse (mod negativo esperado), weapon}. Uma entrada por commit.
const ITEMS := {
	"coracao_da_dominancia": {"slot": "arma", "tier": 5, "mods": {"hit": 2, "cam": 1, "carisma": 1}, "weapon": "dominio_da_vontade"},
	"dispositivo_das_docas": {"slot": "amuleto", "tier": 1, "mods": {"dr": 1, "ca": 1}},
	"dispositivo_antimagia_gilly": {"slot": "armadura", "tier": 4, "mods": {"cam": 3, "inteligencia": -1}},
	"detector_arcano": {"slot": "anel", "tier": 1, "mods": {"pickup": 1.5, "sorte": 2}},
	"colar_visao_verdadeira": {"slot": "amuleto", "tier": 2, "mods": {"hit": 2, "crit_overflow_bonus": 0.03}},
	"wave_of_terror": {"slot": "arma", "tier": 5, "mods": {"forca": 1, "dmg_pct": 0.15, "hp": -8}},
	"cajado_familia_infernum": {"slot": "arma", "tier": 3, "mods": {"inteligencia": 2, "cam": 1, "area_pct": 0.1}},
}

func _items(out: Array) -> void:
	var db: Dictionary = Data.table("items")
	var labels: Dictionary = Items.MOD_LABELS
	for id in ITEMS:
		var want: Dictionary = ITEMS[id]
		var def := {}
		for u in db.uniques:
			if String(u.id) == String(id):
				def = u
		if def.is_empty():
			out.append("item %s deveria existir em uniques" % id)
			continue
		if String(def.slot) != String(want.slot) or int(def.tier) != int(want.tier):
			out.append("%s deveria ser %s tier %d (é %s tier %d)" % [id, want.slot, want.tier, def.slot, def.tier])
		if String(def.get("note", "")) == "":
			out.append("%s deveria ter nota" % id)
		for k in want.mods:
			if not labels.has(k):
				out.append("%s: chave de bônus desconhecida %s" % [id, k])
			if absf(float(def.mods.get(k, 0.0)) - float(want.mods[k])) > 0.0001:
				out.append("%s: %s deveria valer %s (vale %s)" % [id, k, want.mods[k], def.mods.get(k, 0)])
		if def.mods.size() != want.mods.size():
			out.append("%s: bônus a mais ou a menos (%s)" % [id, str(def.mods)])
		if String(def.get("weapon", "")) != String(want.get("weapon", "")):
			out.append("%s: arma concedida deveria ser '%s'" % [id, want.get("weapon", "")])
		# equipar aplica os bônus ao herói e trocar os retira
		var b := _bat(21)
		var before := {}
		for k in want.mods:
			before[k] = b.hero.m(k)
		b._equip_item(Items.unique(def))
		for k in want.mods:
			if absf(b.hero.m(k) - before[k] - float(want.mods[k])) > 0.0001:
				out.append("%s: equipar deveria somar %s %s (somou %s)" % [id, k, want.mods[k], b.hero.m(k) - before[k]])
		# só cai a partir do tier
		var below: Array = db.uniques.filter(func(u): return int(u.tier) <= int(want.tier) - 1 and String(u.id) == String(id))
		var at: Array = db.uniques.filter(func(u): return int(u.tier) <= int(want.tier) and String(u.id) == String(id))
		if not below.is_empty() or at.is_empty():
			out.append("%s deveria entrar no sorteio só a partir do tier %d" % [id, want.tier])

# ---------------------------------------------------------------- E7 Coração da Dominância (SPEC-151)
func _coracao(out: Array) -> void:
	var d := _valid_weapon(out, "dominio_da_vontade", "bolt", "magico", true, 0)
	if d.is_empty():
		return
	if String(d.attr) != "carisma" or float(d.get("stun", 0.0)) != 3.0 or not String(d.src).begins_with("Item"):
		out.append("Domínio da Vontade deveria ser magia de carisma que atordoa 3 s, concedida por item (%s)" % str(d))
	var def := {}
	for u in Data.table("items").uniques:
		if String(u.id) == "coracao_da_dominancia":
			def = u
	if def.is_empty():
		return
	var b := _bat(22, "sylas")
	var heart := Items.unique(def)
	b._equip_item(heart)
	var granted: Array = b.hero.weapons.filter(func(w): return w.id == "dominio_da_vontade" and w.granted)
	if granted.size() != 1:
		out.append("equipar o Coração da Dominância deveria conceder Domínio da Vontade (%d)" % granted.size())
	# a arma concedida não é melhorável (Arcanista e ferreiro a ignoram)
	b._open_shop_event("arcanista")
	if b.offer.any(func(o): return String(o.t) == "shop_weapon_up" and String(o.weapon_id) == "dominio_da_vontade"):
		out.append("o Arcanista não deveria melhorar a arma concedida")
	# atordoa alvo comum, não chefe
	var foe := _foe(b, b.hero.pos + Vector2(2, 0))
	b._apply_effects(foe, Weapon.make("dominio_da_vontade").params())
	if foe.stun_t < 2.99:
		out.append("Domínio da Vontade deveria atordoar um alvo comum por 3 s (%s)" % foe.stun_t)
	# trocar o Coração tira a arma concedida
	var other: Dictionary = {}
	for u in Data.table("items").uniques:
		if String(u.id) == "cajado_familia_infernum":
			other = Items.unique(u)
	b._resolve_item_choice(other, heart)
	if b.hero.weapons.any(func(w): return w.id == "dominio_da_vontade"):
		out.append("trocar o Coração da Dominância deveria retirar Domínio da Vontade")

# ---------------------------------------------------------------- Ícones provisórios (ART-042)
func _icons(out: Array) -> void:
	for id in ["bola_de_fogo", "tormenta_de_fogo", "lamina_de_sombra", "romper_armadura", "esmagar_defesas", "dominio_da_vontade"]:
		if not ResourceLoader.exists(Items.weapon_icon(id)):
			out.append("arma %s deveria ter ícone provisório (icon_like)" % id)
	for id in ITEMS:
		if not ResourceLoader.exists(Items.item_icon(String(id))):
			out.append("item %s deveria ter ícone provisório (icon_like)" % id)
	if Items.weapon_icon("espada_sombria") != "res://assets/icons/weapons/espada_sombria.png":
		out.append("arma com ícone próprio deveria usá-lo")
	if Items.item_icon("nao_existe") != "res://assets/icons/items/nao_existe.png":
		out.append("id desconhecido deveria devolver o caminho próprio")
