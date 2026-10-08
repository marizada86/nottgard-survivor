extends RefCounted
## SPEC-149 (MEC-041): o ferreiro melhora armas e equipamentos; o Arcanista melhora magias.

const WEAPONS := ["espada_sombria", "espada_do_receptaculo", "golpe_esmagador", "adaga_rapida", "rajada_infinita", "golpe_atordoante",
	"golpe_do_juizo", "chicote_avarento", "martelo_da_gloria", "machado_de_xargath", "lamina_da_digestao"]

func _bat(seed_value := 1, hero := "durvall", stage := "dagruve") -> Battle:
	var b := Battle.new(seed_value, hero, stage)
	b.hero.pos = Vector2(20, 20)
	b.stage.waves = []
	b.stage.elites = []
	b.stage.duration = 99999
	b._inter_t = 99999.0
	b._breakable_t = 99999.0
	return b

func _types(b: Battle) -> Array:
	return b.offer.map(func(o): return String(o.t))

func run() -> Array:
	var out: Array = []
	_classification(out)
	_shops(out)
	_empty(out)
	_world(out)
	return out

func _classification(out: Array) -> void:
	var table: Dictionary = Data.table("weapons")
	var spells := 0
	var arms := 0
	for id in table:
		var is_spell := Weapon.is_spell(table[id])
		if is_spell:
			spells += 1
		else:
			arms += 1
		if (id in WEAPONS) == is_spell:
			out.append("%s deveria ser %s" % [id, "arma" if id in WEAPONS else "magia"])
	if arms != WEAPONS.size() or spells != table.size() - WEAPONS.size():
		out.append("contagem inesperada: %d armas e %d magias" % [arms, spells])
	if not Weapon.is_spell({"kind": "melee", "dtype": "fisico", "spell": true}):
		out.append("spell:true explícito deveria virar magia")
	if Weapon.is_spell({"kind": "bolt", "dtype": "magico", "spell": false}):
		out.append("spell:false explícito deveria virar arma")

func _shops(out: Array) -> void:
	var b := _bat(31)
	b.hero.weapons = [Weapon.make("espada_sombria"), Weapon.make("raio_de_luz")]
	b.hero.items.clear()
	b.hero.gold = 1000
	b._open_shop_event("ferreiro")
	var smith_ids: Array = b.offer.filter(func(o): return String(o.t) == "shop_weapon_up").map(func(o): return String(o.weapon_id))
	if smith_ids != ["espada_sombria"]:
		out.append("o ferreiro deveria oferecer só a arma (veio %s)" % str(smith_ids))
	b._open_shop_event("arcanista")
	if b.offer_kind != "shop_arcanista" or b.state != "shop":
		out.append("o Arcanista deveria abrir uma loja (%s, %s)" % [b.offer_kind, b.state])
	var arc_ids: Array = b.offer.filter(func(o): return String(o.t) == "shop_weapon_up").map(func(o): return String(o.weapon_id))
	if arc_ids != ["raio_de_luz"]:
		out.append("o Arcanista deveria oferecer só a magia (veio %s)" % str(arc_ids))
	if String(b.offer.back().t) != "shop_leave":
		out.append("o Arcanista deveria terminar com Sair")
	var idx := 0
	for i in b.offer.size():
		if String(b.offer[i].t) == "shop_weapon_up":
			idx = i
	var price: int = int(b.offer[idx].price)
	var gold_before: int = b.hero.gold
	b.choose(idx)
	var level := 0
	for w in b.hero.weapons:
		if w.id == "raio_de_luz":
			level = w.level
	if level != 2 or b.hero.gold != gold_before - price or b.state != "running":
		out.append("comprar do Arcanista deveria subir a magia a Nv 2, cobrar %d e fechar (nível %d, moeda %d, estado %s)" % [price, level, b.hero.gold, b.state])
	var cheap := _bat(32)
	cheap.hero.weapons = [Weapon.make("raio_de_luz")]
	cheap.hero.gold = 0
	cheap._open_shop_event("arcanista")
	var locked := cheap.offer.filter(func(o): return String(o.t) == "shop_weapon_up" and bool(o.locked))
	if locked.size() != 1:
		out.append("sem moeda o Arcanista deveria mostrar a opção travada")

func _empty(out: Array) -> void:
	var only_weapon := _bat(33)
	only_weapon.hero.weapons = [Weapon.make("espada_sombria")]
	only_weapon.hero.items.clear()
	only_weapon._open_shop_event("arcanista")
	if _types(only_weapon) != ["shop_info", "shop_leave"] or String(only_weapon.offer[0].desc).find("ferreiro") < 0:
		out.append("Arcanista sem magia deveria avisar e mandar ao ferreiro: %s" % str(_types(only_weapon)))
	var only_spell := _bat(34)
	only_spell.hero.weapons = [Weapon.make("raio_de_luz")]
	only_spell.hero.items.clear()
	only_spell._open_shop_event("ferreiro")
	if _types(only_spell) != ["shop_info", "shop_leave"] or String(only_spell.offer[0].desc).find("Arcanista") < 0:
		out.append("ferreiro sem arma nem equipamento deveria mandar ao Arcanista: %s" % str(_types(only_spell)))
	var granted := _bat(35)
	var gw := Weapon.make("raio_de_luz")
	gw.granted = true
	granted.hero.weapons = [gw]
	granted._open_shop_event("arcanista")
	if _types(granted) != ["shop_info", "shop_leave"]:
		out.append("magia concedida por item não é melhorável: %s" % str(_types(granted)))

func _world(out: Array) -> void:
	var stages: Dictionary = Data.table("stages")
	for sid in stages:
		if not stages[sid].get("interactions", {}).has("arcanista"):
			out.append("fase %s deveria ter o Arcanista em interactions" % sid)
	var b := _bat(36, "durvall", "docas")
	b._first_inter = false
	var seen := {}
	for i in 600:
		b.interactions.clear()
		b._spawn_random_interaction()
		for it in b.interactions:
			seen[String(it.kind)] = true
	if not seen.has("arcanista"):
		out.append("o sorteio deveria produzir o Arcanista em Docas: %s" % str(seen.keys()))
	if not Battle.TRUCE_KINDS.has("arcanista"):
		out.append("Sem trégua deveria tirar o Arcanista")
	var t := _bat(37, "durvall", "dagruve")
	t.hero.weapons = [Weapon.make("raio_de_luz")]
	t.interactions.clear()
	t._add_interaction("arcanista", t.hero.pos + Vector2(0.5, 0.0))
	t.interactions.back()["born_at"] = -5.0
	t.state = "running"
	if not t.interact() or t.offer_kind != "shop_arcanista":
		out.append("E perto do Arcanista deveria abrir a loja (%s)" % t.offer_kind)
	if MobileControls.interaction_label(_near("arcanista")) != "Estudar":
		out.append("o botão mobile deveria dizer Estudar")

func _near(kind: String) -> Battle:
	var b := _bat(38)
	b.interactions.clear()
	b._add_interaction(kind, b.hero.pos + Vector2(0.5, 0.0))
	b.interactions.back()["born_at"] = -5.0
	return b
