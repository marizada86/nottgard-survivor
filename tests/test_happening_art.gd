extends RefCounted

const ART := preload("res://ui/happening_art.gd")
const ADMITTED := ["npc_joao_barbosa", "npc_desertor_durao", "npc_vitima_enfeiticada", "npc_nyxara", "npc_vaelis", "npc_grazzt_aliado", "npc_reaper_barqueiro", "npc_vhaerith_aetherion", "npc_mercador_rivenheart", "estrela_do_norte", "trono_zuggtmoy", "arco_pedra", "massa_thullgrime", "coracao_limo", "esporo_zuggtmoy", "limo_juiblex"]

func _battle(stage: String) -> Battle:
	var b := Battle.new(7, "durvall", stage)
	b.stage.waves = []
	b.stage.elites = []
	b.stage.duration = 99999
	b.hero.max_hp = 9999
	b.hero.hp = 9999
	return b

func _definition(stage: String, id: String) -> Dictionary:
	for d in Data.table("stage_events")[stage]:
		if String(d.id) == id:
			return d.duplicate(true)
	return {}

func _fire(stage: String, id: String) -> Battle:
	var b := _battle(stage)
	b.happenings.fire(b, _definition(stage, id))
	return b

func _points(b: Battle, kind: String) -> Array:
	return b.interactions.filter(func(i): return String(i.kind) == kind and not i.used)

func run() -> Array:
	var out: Array = []
	_check_imports_and_geometry(out)
	_check_event_consumption(out)
	_check_rewards_and_legacy(out)
	_check_rng_preserved(out)
	return out

func _check_imports_and_geometry(out: Array) -> void:
	for asset in ADMITTED:
		var path := "res://assets/interactions/%s.png" % asset
		if not ResourceLoader.exists(path):
			out.append("ART-032 import missing: " + asset)
			continue
		var texture := load(path) as Texture2D
		var source := ART.source_rect(texture)
		var dest := ART.destination_rect(texture, Vector2(45, 60), 80)
		if source.position.x < 4 or source.position.y < 4 or source.end.x > texture.get_width() - 4 or source.end.y > texture.get_height() - 4:
			out.append("ART-032 transparent guard padding missing: " + asset)
		if not is_equal_approx(dest.end.y, 60) or not is_equal_approx(dest.get_center().x, 45) or not is_equal_approx(dest.size.y, 80):
			out.append("ART-032 visible base/height not anchored: " + asset)
		if not is_equal_approx(dest.size.x / dest.size.y, source.size.x / source.size.y):
			out.append("ART-032 visible aspect stretched: " + asset)
	var boss := (load("res://assets/enemies/manifestacao_de_juiblex.png") as Texture2D).get_image()
	var old := (load("res://assets/enemies/receptaculo_de_juiblex.png") as Texture2D).get_image()
	if boss == null or boss.get_data() == old.get_data():
		out.append("Juiblex still uses the receptacle instead of the accepted manifestation")

func _check_event_consumption(out: Array) -> void:
	var portal := _fire("shedaklah", "portal_sem_vao")
	var items: Array = _points(portal, "event_item").map(func(i): return String(i.asset))
	if not items.has("esporo_zuggtmoy") or not items.has("limo_juiblex") or String(_points(portal, "event_target")[0].asset) != "arco_pedra":
		out.append("Portal art must propagate both collectible assets and the arch")
	var pedido := _fire("shedaklah", "pedido_de_zuggtmoy")
	var carrier: Array = pedido.enemies.filter(func(e): return e.event_item != "")
	pedido._kill(carrier[0])
	if String(_points(pedido, "event_item")[0].asset) != "coracao_limo" or String(_points(pedido, "event_target")[0].asset) != "trono_zuggtmoy":
		out.append("Elite drop lost the heart asset or throne target")
	for spec in [["durao", "desertores", "event_npc", "npc_desertor_durao"], ["shendilavri", "vitimas_drenadas", "event_npc", "npc_vitima_enfeiticada"], ["feng_tu", "peregrinacao_da_estrela", "event_star", "estrela_do_norte"], ["molor", "ritual_de_estagnacao", "event_target", "massa_thullgrime"], ["shedaklah", "barqueiro_do_estige", "event_pact", "npc_reaper_barqueiro"], ["durao", "vhaerith_na_jaula", "event_pact", "npc_vhaerith_aetherion"], ["shendilavri", "mercador_de_rivenheart", "event_pact", "npc_mercador_rivenheart"], ["goranthis", "o_nome_tres_vezes", "event_pact", "npc_grazzt_aliado"]]:
		var b := _fire(spec[0], spec[1])
		for point in _points(b, spec[2]):
			if String(point.asset) != spec[3]:
				out.append("Event asset not consumed: " + spec[1])
	var joao := _fire("feng_tu", "escolta_do_peregrino")
	if String(joao.happenings.allies[0].asset) != "npc_joao_barbosa":
		out.append("Escort lost João's event art")
	var journal := _fire("molor", "diario_do_chefe")
	if String(_points(journal, "event_npc")[0].asset) != "":
		out.append("Uncovered journal must preserve fallback, not borrow an unrelated NPC")

func _check_rewards_and_legacy(out: Array) -> void:
	var sisters := _battle("shendilavri")
	sisters.happenings._apply_reward(sisters, _definition("shendilavri", "vitimas_drenadas").reward, sisters.hero.pos)
	if sisters.happenings.allies.size() != 2 or String(sisters.happenings.allies[0].asset) != "npc_nyxara" or String(sisters.happenings.allies[1].asset) != "npc_vaelis":
		out.append("Radiant Sisters must keep two allies with distinct Nyxara/Vaelis art")
	var grazzt := _battle("goranthis")
	grazzt.happenings._apply_reward(grazzt, _definition("goranthis", "o_nome_tres_vezes").choices[0].effect, grazzt.hero.pos)
	if grazzt.happenings.allies.size() != 1 or String(grazzt.happenings.allies[0].asset) != "npc_grazzt_aliado" or not is_equal_approx(grazzt.happenings.allies[0].hp, 500):
		out.append("Graz'zt ally lost art/count/existing stats")
	var legacy := _battle("shedaklah")
	legacy.happenings._add_ally(legacy, {"sprite": "servo_de_zuggtmoy", "label": "legacy"})
	if legacy.happenings.allies[0].asset != "" or legacy.happenings.allies[0].sprite != "servo_de_zuggtmoy":
		out.append("Legacy enemy-sprite allies must retain fallback")

func _without_art(value: Variant) -> Variant:
	if value is Dictionary:
		var copy := {}
		for key in value:
			if key not in ["asset", "assets"]:
				copy[key] = _without_art(value[key])
		return copy
	if value is Array:
		var copy: Array = []
		for item in value:
			copy.append(_without_art(item))
		return copy
	return value

func _check_rng_preserved(out: Array) -> void:
	for spec in [["shedaklah", "portal_sem_vao"], ["shedaklah", "pedido_de_zuggtmoy"], ["feng_tu", "escolta_do_peregrino"], ["shendilavri", "vitimas_drenadas"], ["molor", "ritual_de_estagnacao"]]:
		var a := _battle(spec[0])
		var b := _battle(spec[0])
		var definition := _definition(spec[0], spec[1])
		a.happenings.fire(a, definition)
		b.happenings.fire(b, _without_art(definition))
		if a.rng.state != b.rng.state or a.interactions.size() != b.interactions.size() or a.enemies.size() != b.enemies.size():
			out.append("Visual metadata changed simulation/RNG: " + spec[1])
		for i in a.interactions.size():
			if a.interactions[i].pos != b.interactions[i].pos:
				out.append("Art metadata changed event position: " + spec[1])
