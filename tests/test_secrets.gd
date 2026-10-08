extends RefCounted
## SPEC-152 (MEC-039, fatia piloto): pontos de interesse, covil e Ecos de Shedaklah, Molor e Durao (84x84).

const STAGES := ["shedaklah", "molor", "durao"]
const FORBIDDEN := ["adam", "astherion", "vanimelda", "mystralia", "arco 02", "síntese", "fusão"]

func _bat(stage: String, seed_value := 5) -> Battle:
	var b := Battle.new(seed_value, "durvall", stage)
	b.map_size = Vector2(84, 84)
	b.hero.map_size = b.map_size
	b.hero.pos = b.map_size * 0.5
	b.stage.waves = []
	b.stage.elites = []
	b.stage.duration = 99999
	b._inter_t = 99999.0
	b._breakable_t = 99999.0
	return b

func run() -> Array:
	var out: Array = []
	var saved := TerrainLayout.scale
	TerrainLayout.scale = 84.0 / 40.0
	_data(out)
	for stage in STAGES:
		_placement(out, stage)
	_lair(out)
	_ecos(out)
	_profile(out)
	_diary(out)
	_relics(out)
	_keys(out)
	_achievements(out)
	TerrainLayout.scale = saved
	return out

# ---------------------------------------------------------------- dados
func _data(out: Array) -> void:
	var table: Dictionary = Data.table("secrets")
	var uniques: Dictionary = {}
	for u in Data.table("items").uniques:
		uniques[String(u.id)] = true
	var enemies: Dictionary = Data.table("enemies")
	for stage in STAGES:
		if not table.has(stage):
			out.append("secrets.json deveria ter %s" % stage)
			continue
		var spec: Dictionary = table[stage]
		var kinds := {}
		for poi in spec.pois:
			kinds[String(poi.kind)] = int(kinds.get(String(poi.kind), 0)) + 1
			if String(poi.kind) == "covil" and not enemies.has(String(poi.elite)):
				out.append("%s: elite %s inexistente" % [stage, poi.elite])
		if kinds != {"ruina": 1, "camara": 1, "covil": 1}:
			out.append("%s: deveria ter 1 ruína, 1 câmara e 1 covil (%s)" % [stage, str(kinds)])
		if spec.ecos.size() != 4:
			out.append("%s: deveria ter 4 Ecos (tem %d)" % [stage, spec.ecos.size()])
		var ids := {}
		for eco in spec.ecos:
			if ids.has(String(eco.id)):
				out.append("Eco repetido: %s" % eco.id)
			ids[String(eco.id)] = true
			var text := String(eco.texto)
			if text == "" or text.length() > 260:
				out.append("%s: texto vazio ou longo demais (%d)" % [eco.id, text.length()])
			if String(eco.get("fonte_vault", "")) == "":
				out.append("%s: sem fonte_vault" % eco.id)
			var lower := text.to_lower()
			for term in FORBIDDEN:
				if lower.find(term) >= 0:
					out.append("%s: termo proibido '%s' (cânone do mestre ou próximo arco)" % [eco.id, term])
			if lower.find("colar") >= 0 and (lower.find("adam") >= 0 or lower.find("amuleto") >= 0):
				out.append("%s: o colar do segredo não pode aparecer" % eco.id)
			if lower.find("luna") >= 0:
				out.append("%s: lore paralela dos Aetherion" % eco.id)
			if String(eco.onde) == "destrutivel" and not enemies.has(String(eco.get("quebravel", ""))):
				out.append("%s: destrutível inexistente" % eco.id)
		var relic: Dictionary = spec.relic
		for item_id in relic.items:
			if not uniques.has(String(item_id)):
				out.append("%s: relíquia %s não existe em uniques" % [stage, item_id])
		var key_found := false
		for ev in Data.table("stage_events").get(stage, []):
			if String(ev.id) == String(relic.key):
				key_found = true
		if not key_found:
			out.append("%s: acontecimento-chave %s não existe" % [stage, relic.key])

# ---------------------------------------------------------------- posição
func _placed(stage: String) -> Battle:
	var b := _bat(stage)
	b._place_secrets()
	return b

func _placement(out: Array, stage: String) -> void:
	var b := _placed(stage)
	var spec: Dictionary = b.secrets_spec()
	var chests: Array = b.interactions.filter(func(i): return String(i.kind) == "chest" and bool(i.get("fixed", false)))
	if chests.size() != 1 or not bool(chests[0].get("safe", false)):
		out.append("%s: a ruína deveria ter 1 baú seguro e fixo (%d)" % [stage, chests.size()])
	var lairs: Array = b.enemies.filter(func(e): return e.lair)
	if lairs.size() != 1 or not lairs[0].drops_chest or lairs[0].lair_reward != "boss_chest":
		out.append("%s: o covil deveria ter 1 elite dormente que larga baú de chefe" % stage)
	if b.ecos.size() != 4:
		out.append("%s: deveria haver 4 Ecos na fase (%d)" % [stage, b.ecos.size()])
	var points: Array = []
	for poi in spec.pois:
		points.append(Vector2(float(poi.pos[0]), float(poi.pos[1])))
	for eco in b.ecos:
		points.append(eco.pos)
		if not b.hero.can_stand(eco.pos, 0.3):
			out.append("%s: o Eco %s está em chão bloqueado (%s)" % [stage, eco.id, str(eco.pos)])
		if eco.pos.distance_to(b.hero.pos) < 8.0:
			out.append("%s: o Eco %s nasce perto demais do início" % [stage, eco.id])
	for p in points:
		if p.x < 3.0 or p.y < 3.0 or p.x > 81.0 or p.y > 81.0:
			out.append("%s: ponto fora da margem do mapa 84x84 %s" % [stage, str(p)])
		if TerrainLayout.is_blocked(stage, p) or TerrainLayout.is_styx_water(stage, p):
			out.append("%s: ponto sobre água ou terreno bloqueado %s" % [stage, str(p)])
	# a distância a pé do início ao ponto mais afastado precisa ser razoável (SPEC-119: POI a até ~25 s do centro)
	for p in points:
		if p.distance_to(b.hero.pos) > 40.0:
			out.append("%s: ponto longe demais do centro (%.1f tiles)" % [stage, p.distance_to(b.hero.pos)])

# ---------------------------------------------------------------- covil
func _lair(out: Array) -> void:
	var b := _placed("shedaklah")
	var lair: Enemy = b.enemies.filter(func(e): return e.lair)[0]
	var home: Vector2 = lair.pos
	b.hero.pos = home + Vector2(20.0, 0.0)
	for i in 30:
		b._enemy_step(lair, 0.1)
	if lair.pos != home or not lair.lair:
		out.append("o elite do covil deveria ficar parado com o herói longe")
	b.hero.pos = home + Vector2(5.0, 0.0)
	b.events.clear()
	b._enemy_step(lair, 0.1)
	if lair.lair:
		out.append("o covil deveria acordar com o herói a menos de 8 tiles")
	if not b.events.any(func(ev): return String(ev.type) == "toast" and String(ev.text).begins_with("O covil acorda")):
		out.append("o covil deveria avisar quando acorda")
	b.interactions.clear()
	b._kill(lair)
	if not b.interactions.any(func(i): return String(i.kind) == "boss_chest"):
		out.append("o elite do covil deveria largar um baú de chefe")

# ---------------------------------------------------------------- Ecos
func _ecos(out: Array) -> void:
	var b := _placed("molor")
	b.hero.pos = Vector2(5.0, 5.0)
	b.events.clear()
	b._update_ecos()
	if b.events.any(func(ev): return String(ev.type) == "eco"):
		out.append("nenhum Eco deveria ser pego com o herói longe")
	var eco: Dictionary = b.ecos[0]
	b.hero.pos = eco.pos + Vector2(0.5, 0.0)
	b._update_ecos()
	var picked: Array = b.events.filter(func(ev): return String(ev.type) == "eco")
	if picked.size() != 1 or String(picked[0].id) != String(eco.id) or String(picked[0].texto) != String(eco.texto) or String(picked[0].stage) != "molor":
		out.append("tocar o Eco deveria emitir um evento com id, texto e fase (%s)" % str(picked))
	b._update_ecos()
	if b.events.filter(func(ev): return String(ev.type) == "eco").size() != 1:
		out.append("o mesmo Eco não pode ser pego duas vezes")
	if b.ecos_progress() != Vector2i(1, 4) or b.stats.ecos != [eco.id]:
		out.append("o progresso deveria ser 1 de 4 (%s, %s)" % [str(b.ecos_progress()), str(b.stats.ecos)])
	# trocar de fase limpa os Ecos
	b.ecos.clear()
	if b.ecos_progress() != Vector2i(0, 0):
		out.append("sem Ecos o progresso deveria ser 0 de 0")

# ---------------------------------------------------------------- perfil
func _profile(out: Array) -> void:
	var p := Profile.new()
	if not p.mark_eco_found("molor", "eco_mol_1") or p.mark_eco_found("molor", "eco_mol_1"):
		out.append("o Eco só conta na primeira vez")
	if p.ecos_found("molor") != 1 or p.secrets_complete("molor"):
		out.append("um Eco não completa os segredos da fase")
	for id in ["eco_mol_2", "eco_mol_3", "eco_mol_4"]:
		p.mark_eco_found("molor", id)
	if p.secrets_complete("molor"):
		out.append("sem a relíquia os segredos da fase não estão completos")
	if not p.mark_relic_taken("molor") or p.mark_relic_taken("molor"):
		out.append("a relíquia só conta na primeira vez")
	if not p.secrets_complete("molor") or p.stat_value("secrets_molor", {}) != 1.0 or p.stat_value("secrets_durao", {}) != 0.0:
		out.append("quatro Ecos e a relíquia completam os segredos da fase")
	# save antigo sem o campo continua válido
	var old := Profile.new({"name": "Antigo", "coins": 5})
	if not old.data.ecos.is_empty() or not old.data.relics.is_empty() or old.ecos_found("shedaklah") != 0:
		out.append("perfil antigo deveria nascer sem Ecos nem relíquias")

# ---------------------------------------------------------------- Diário (Quartel)
func _diary(out: Array) -> void:
	var menu_script = load("res://ui/menu.gd")
	var saved_profile = Game.profile
	Game.profile = Profile.new()
	var empty: String = menu_script.eco_diary_text("durao")
	if empty.count("🔒 Eco escondido") != 4 or empty.find("0 de 4") < 0:
		out.append("sem nenhum Eco, o Diário deveria mostrar 4 escondidos: %s" % empty)
	Game.profile.mark_eco_found("durao", "eco_dur_1")
	var one: String = menu_script.eco_diary_text("durao")
	var first: Dictionary = Data.table("secrets").durao.ecos[0]
	if one.count("🔒 Eco escondido") != 3 or one.find(String(first.texto)) < 0 or one.find(String(first.fonte_vault)) < 0:
		out.append("o Eco achado deveria aparecer com texto e fonte, e os outros três escondidos")
	var second_text := String(Data.table("secrets").durao.ecos[1].texto)
	if one.find(second_text) >= 0:
		out.append("o Eco não achado não pode vazar o texto no Diário")
	Game.profile.mark_relic_taken("durao")
	if String(menu_script.eco_diary_text("durao")).find("pega") < 0:
		out.append("o Diário deveria mostrar a relíquia como pega")
	Game.profile = saved_profile

# ---------------------------------------------------------------- Câmara selada, relíquias e conquistas
func _chamber_bat(stage: String, seed_value := 7) -> Battle:
	var b := _bat(stage, seed_value)
	b._place_secrets()
	var chamber: Dictionary = b.interactions.filter(func(i): return String(i.kind) == "camara")[0]
	b.hero.pos = chamber.pos + Vector2(0.4, 0.0)
	chamber["born_at"] = -5.0
	b.state = "running"
	b.events.clear()
	return b

func _relics(out: Array) -> void:
	var expected := {"shedaklah": ["manto_do_pantano"], "molor": ["lamina_da_digestao", "anel_resistencia_abissal"], "durao": ["machado_de_xargath"]}
	for stage in STAGES:
		var b := _chamber_bat(stage)
		if b.interact() or not b.events.any(func(ev): return String(ev.type) == "toast" and String(ev.text).begins_with("A câmara está selada")):
			out.append("%s: a câmara trancada deveria avisar e não abrir" % stage)
		var chamber: Dictionary = b.interactions.filter(func(i): return String(i.kind) == "camara")[0]
		if bool(chamber.used):
			out.append("%s: a câmara trancada não pode ser consumida" % stage)
		b.unlock_chamber()
		b.events.clear()
		if not b.interact():
			out.append("%s: a câmara liberada deveria abrir" % stage)
			continue
		var relic_event: Array = b.events.filter(func(ev): return String(ev.type) == "relic")
		if relic_event.size() != 1 or not expected[stage].has(String(relic_event[0].item)) or String(relic_event[0].stage) != stage:
			out.append("%s: a câmara deveria entregar a relíquia da fase (%s)" % [stage, str(relic_event)])
			continue
		var item_id := String(relic_event[0].item)
		if b.state == "item_offer":  # slot vazio: o jogo pausa e mostra o item (BUG-031); equipa ao confirmar
			b.choose(0)
		if not b.relic_taken or String(b.hero.items.get(String(Data.table("items").uniques.filter(func(u): return String(u.id) == item_id)[0].slot), {}).get("id", "")) != item_id:
			out.append("%s: a relíquia %s deveria ser equipada num slot vazio" % [stage, item_id])
		b.hero.pos = chamber.pos
		b.interactions = b.interactions.filter(func(i): return String(i.kind) != "camara")
		if b.interact():
			out.append("%s: a câmara não pode abrir duas vezes" % stage)
	# Molor sorteia entre as duas relíquias, sem depender da semente da batalha para o mesmo resultado
	var seen := {}
	for seed_value in range(1, 40):
		var b := _chamber_bat("molor", seed_value)
		b.unlock_chamber()
		b.events.clear()
		b.interact()
		for ev in b.events:
			if String(ev.type) == "relic":
				seen[String(ev.item)] = true
	if seen.size() != 2:
		out.append("Molor deveria sortear as duas relíquias em 40 sementes (%s)" % str(seen.keys()))
	# trocar de fase tranca de novo
	var stage_swap := _chamber_bat("durao")
	stage_swap.unlock_chamber()
	if not stage_swap.chamber_unlocked:
		out.append("unlock_chamber deveria liberar a câmara")
	# a cópia é garantida, mas o item não sai do sorteio normal (nenhuma tabela de drop mudou)
	for u in Data.table("items").uniques:
		if String(u.id) == "manto_do_pantano" and int(u.tier) > 1:
			out.append("a relíquia continua no sorteio normal pelo tier original")

func _keys(out: Array) -> void:
	# o reward do acontecimento-chave abre a câmara; Durao sempre tem a arena
	var keys := {"shedaklah": "portal_sem_vao", "molor": "ritual_de_estagnacao", "durao": "arena_do_testador"}
	for stage in keys:
		var def := {}
		for ev in Data.table("stage_events")[stage]:
			if String(ev.id) == String(keys[stage]):
				def = ev
		if not bool(def.get("reward", {}).get("unlock_chamber", false)):
			out.append("%s: %s deveria destrancar a câmara" % [stage, keys[stage]])
		if String(def.get("pool", "fixed")) == "optional":
			out.append("%s: o acontecimento-chave não pode ser opcional" % stage)
		var b := _chamber_bat(stage)
		b.happenings._apply_reward(b, def.reward, b.hero.pos)
		if not b.chamber_unlocked:
			out.append("%s: aplicar o reward deveria destrancar a câmara" % stage)

func _achievements(out: Array) -> void:
	var ids := {}
	for a in Data.table("achievements").achievements:
		ids[String(a.id)] = a
	for stage in STAGES:
		var a: Dictionary = ids.get("ecos_%s" % stage, {})
		if a.is_empty() or String(a.stat) != "secrets_%s" % stage or int(a.reward.get("coins", 0)) <= 0:
			out.append("conquista ecos_%s deveria existir com moedas" % stage)
	var p := Profile.new()
	for id in ["eco_dur_1", "eco_dur_2", "eco_dur_3", "eco_dur_4"]:
		p.mark_eco_found("durao", id)
	var run := {"level": 1, "time": 1.0}
	if p.check_achievements(run).has("ecos_durao"):
		out.append("sem a relíquia a conquista não pode sair")
	p.mark_relic_taken("durao")
	var coins_before := p.coins()
	var earned: Array = p.check_achievements(run)
	if not earned.has("ecos_durao") or p.coins() != coins_before + 300 or earned.has("ecos_molor"):
		out.append("Ecos de Durao deveria sair com 300 moedas só para a fase certa (%s)" % str(earned))
