extends RefCounted
## MEC-050 (SPEC-155): as linhas "Doar" do Altar da Doação mostram o ícone do item que será doado.

const HudScript := preload("res://ui/hud.gd")

func _bat(seed_value := 41) -> Battle:
	var b := Battle.new(seed_value, "durvall", "dagruve")
	b.hero.pos = Vector2(30, 30)
	b.stage.waves = []
	b.stage.elites = []
	b.stage.duration = 99999
	b._inter_t = 99999.0
	b._breakable_t = 99999.0
	return b

func run() -> Array:
	var out: Array = []
	var b := _bat()
	# equipa um item comum de cada slot e um único (sem `base`, o ícone vem do id)
	var rng := RandomNumberGenerator.new()
	rng.seed = 7
	for slot in Items.SLOTS:
		var item := Items.roll(rng, 0, 0.0, "comum")
		item["slot"] = slot
		b.hero.items[slot] = item
	var unique: Dictionary = {}
	for u in Data.table("items").uniques:
		if String(u.id) == "wave_of_terror":
			unique = Items.unique(u)
	b.hero.items["arma"] = unique
	b._open_risk_event("doacao")
	var donate: Array = b.offer.filter(func(o): return String(o.t) == "donate")
	if donate.size() != b.hero.items.size():
		out.append("deveria haver uma linha Doar por equipamento (%d de %d)" % [donate.size(), b.hero.items.size()])
	for o in donate:
		var item: Dictionary = b.hero.items[o.slot]
		var want := String(item.get("base", item.get("id", "")))
		if String(o.get("base", "")) != want:
			out.append("a linha Doar de %s deveria carregar o ícone-base '%s' (veio '%s')" % [item.name, want, o.get("base", "")])
		var path: String = HudScript.offer_icon_path(o)
		if path != Items.item_icon(want) or not ResourceLoader.exists(path):
			out.append("a linha Doar de %s deveria usar um ícone existente (%s)" % [item.name, path])
	# os demais tipos de oferta continuam com o mesmo ícone
	if HudScript.offer_icon_path({"t": "heal"}) != "res://assets/pickups/health_potion.png":
		out.append("oferta de cura deveria manter a poção")
	if HudScript.offer_icon_path({"t": "weapon_new", "id": "raio_de_luz"}) != Items.weapon_icon("raio_de_luz"):
		out.append("oferta de arma deveria manter o ícone da arma")
	if HudScript.offer_icon_path({"t": "algo_desconhecido"}) != "":
		out.append("tipo sem ícone deveria devolver vazio")
	return out
