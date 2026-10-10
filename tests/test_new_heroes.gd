extends RefCounted
## SPEC-160 (MEC-062, MEC-063): Arlindo Orlando e Erik Blackthorn jogáveis (dados, passivas, arma e ativa, desbloqueio).

func _bat(hero: String, stage := "dagruve", seed_value := 5) -> Battle:
	var b := Battle.new(seed_value, hero, stage)
	b.map_size = Vector2(60, 60)
	b.hero.map_size = b.map_size
	b.hero.pos = Vector2(30, 30)
	b.stage.waves = []
	b.stage.elites = []
	b.stage.duration = 99999
	b._inter_t = 99999.0
	b._breakable_t = 99999.0
	b.state = "running"
	return b

func run() -> Array:
	var out: Array = []
	var saved := TerrainLayout.scale
	TerrainLayout.scale = 60.0 / 40.0
	_data(out)
	_unlock(out)
	_arlindo_weapon(out)
	_arlindo_forget(out)
	_arlindo_ecos(out)
	_erik_passive(out)
	_erik_zone(out)
	_text(out)
	TerrainLayout.scale = saved
	return out

func _data(out: Array) -> void:
	var heroes: Dictionary = Data.table("heroes")
	for id in ["arlindo", "erik"]:
		if not heroes.has(id):
			out.append("%s deveria existir em heroes.json" % id)
			continue
		var h: Dictionary = heroes[id]
		if h.has("art_like"):
			out.append("%s: ainda usa arte provisória" % id)
		if not Data.table("weapons").has(String(h.weapon)) or not Data.table("abilities").has(id):
			out.append("%s: arma ou habilidade ausente" % id)
		if not Data.table("hero_bios").has(id) or not Data.table("barks").has(id):
			out.append("%s: sem bio ou falas" % id)
		if not Data.table("achievements").achievements.any(func(a): return String(a.id) == "bio_%s" % id):
			out.append("%s: sem a conquista de biografia" % id)
		if not ResourceLoader.exists("res://assets/portraits/%s.png" % id):
			out.append("%s: sem retrato" % id)
	var view: Script = load("res://ui/hero_view.gd")
	if view.art_id("arlindo") != "arlindo" or view.art_id("erik") != "erik" or view.art_id("brook") != "brook":
		out.append("art_id: os heróis devem usar a própria arte")
	var grimholders := 0
	for id in heroes:
		if JSON.stringify(heroes[id]).to_lower().find("greenhold") >= 0 or String(Data.table("hero_bios").get(id, "")).to_lower().find("greenhold") >= 0:
			out.append("%s ainda cita Greenholders (o jogo diz Grimholders)" % id)
		if JSON.stringify(heroes[id]).find("Grimholders") >= 0:
			grimholders += 1
	if grimholders != 3:
		out.append("Arlindo, Erik e Nyrelia deveriam citar os Grimholders no título (%d)" % grimholders)

func _unlock(out: Array) -> void:
	var p := Profile.new()
	if p.hero_unlocked("arlindo") or p.hero_unlocked("erik"):
		out.append("Arlindo e Erik nascem bloqueados")
	for id in ["dagruve", "docas"]:
		for n in 4:
			p.mark_eco_found(id, "x%d" % n)
		p.mark_relic_taken(id)
	p.check_achievements({"level": 1, "time": 1.0})
	if not p.hero_unlocked("arlindo") or not p.hero_unlocked("erik"):
		out.append("Ecos de Dagruve libera o Arlindo e Ecos de Docas libera o Erik")
	var q := Profile.new()
	for n in 4:
		q.mark_eco_found("dagruve", "x%d" % n)
	q.mark_relic_taken("dagruve")
	q.check_achievements({"level": 1, "time": 1.0})
	if not q.hero_unlocked("arlindo") or q.hero_unlocked("erik"):
		out.append("só Dagruve completo libera só o Arlindo")

func _arlindo_weapon(out: Array) -> void:
	var b := _bat("arlindo")
	var e := b._spawn("zumbi", Vector2(34, 30))
	b._hero_hit(e, b.hero.weapons[0].params(), false)
	if e.slow_t <= 0.0:
		out.append("Memória Alterada deveria deixar o alvo lento")
	if String(b.hero.weapons[0].id) != "memoria_alterada":
		out.append("Arlindo começa com a Memória Alterada")

func _arlindo_forget(out: Array) -> void:
	var b := _bat("arlindo")
	var near := b._spawn("zumbi", Vector2(32, 30))
	var far := b._spawn("zumbi", Vector2(40, 30))
	var boss := b._spawn("zumbi", Vector2(30, 32))
	boss.max_hp = 9999.0
	boss.hp = 9999.0
	boss.flags = boss.flags.duplicate()
	if not b.use_active(Vector2(1, 0)):
		out.append("Modify Memory deveria disparar")
		return
	if not is_equal_approx(near.stun_t, 2.0):
		out.append("o inimigo próximo deveria perder os ataques por 2 s (%.2f)" % near.stun_t)
	if far.stun_t > 0.0:
		out.append("o inimigo fora do raio não pode esquecer")
	if b.active_cd <= 0.0:
		out.append("Modify Memory deveria entrar em recarga")

func _arlindo_ecos(out: Array) -> void:
	var b := _bat("arlindo")
	b._place_secrets()
	var eco: Dictionary = b.ecos[0]
	b.hero.pos = eco.pos + Vector2(0.5, 0.0)
	b.hero.xp = 0.0
	var need := b.hero.xp_need
	b._update_ecos()
	if absf(b.hero.xp - need * 0.2) > 0.01:
		out.append("o Eco deveria render 20%% da barra de XP ao Arlindo (%.2f de %.2f)" % [b.hero.xp, need])
	var d := _bat("durvall")
	d._place_secrets()
	d.hero.pos = d.ecos[0].pos + Vector2(0.5, 0.0)
	d.hero.xp = 0.0
	d._update_ecos()
	if d.hero.xp != 0.0:
		out.append("o Eco não rende XP a quem não tem Olhos de Andarilho")
	if absf(float(b.hero.m("eco_pista_pct")) - 0.5) > 0.001 or d.hero.m("eco_pista_pct") != 0.0:
		out.append("o brilho do Eco deveria ir de 6 a 9 tiles só para o Arlindo")

func _hit_damage(b: Battle, p: Dictionary) -> float:
	var e := b._spawn("zumbi", Vector2(31, 30))
	e.max_hp = 99999.0
	e.hp = 99999.0
	b._hero_hit(e, p, false)
	return 99999.0 - e.hp

func _erik_passive(out: Array) -> void:
	var b := _bat("erik")
	var fire := {"kind": "melee", "dtype": "fogo", "attr": "forca", "dice": "100d1"}
	var phys := {"kind": "melee", "dtype": "fisico", "attr": "forca", "dice": "100d1"}
	var area := {"kind": "nova", "dtype": "fisico", "attr": "forca", "dice": "100d1"}
	var with_fire := _hit_damage(b, fire)
	var with_phys := _hit_damage(b, phys)
	var with_area := _hit_damage(b, area)
	b.hero.mods["fire_pct"] = 0.0
	b.hero.mods["area_dmg_pct"] = 0.0
	var no_fire := _hit_damage(b, fire)
	var no_area := _hit_damage(b, area)
	if with_fire <= no_fire * 1.1:
		out.append("o dano de fogo deveria subir ~15%% com Incendiário Procurado (%.0f contra %.0f)" % [with_fire, no_fire])
	if with_area <= no_area * 1.1:
		out.append("o dano em área deveria subir ~15%% (%.0f contra %.0f)" % [with_area, no_area])
	if with_phys > no_fire * 1.02:
		out.append("o golpe físico comum não pode ganhar o bônus de fogo ou de área (%.0f)" % with_phys)
	var a := _bat("arlindo")
	if _hit_damage(a, fire) > no_fire * 1.02:
		out.append("o Arlindo não tem o bônus de fogo")

func _erik_zone(out: Array) -> void:
	var b := _bat("erik")
	var victim := b._spawn("zumbi", Vector2(32.4, 30.0))
	victim.max_hp = 99999.0
	victim.hp = 99999.0
	if not b.use_active(Vector2(1, 0)):
		out.append("Navios em Chamas deveria disparar")
		return
	var zones: Array = b.zones.filter(func(z): return String(z.get("owner", "")) == "hero")
	if zones.size() != 1 or absf(float(zones[0].life) - 8.0) > 0.01:
		out.append("deveria nascer uma zona do herói de 8 s (%d)" % zones.size())
		return
	if zones[0].pos.distance_to(Vector2(32.5, 30.0)) > 0.6:
		out.append("a zona deveria nascer à frente do herói (%s)" % str(zones[0].pos))
	b._update_zones(0.6)
	if victim.hp >= 99999.0:
		out.append("a zona de fogo deveria ferir quem está dentro")
	var far := b._spawn("zumbi", Vector2(45, 45))
	far.hp = 99999.0
	b._update_zones(0.6)
	if far.hp < 99999.0:
		out.append("a zona de fogo não fere quem está fora")
	if b.active_cd <= 0.0:
		out.append("Navios em Chamas deveria entrar em recarga")

func _text(out: Array) -> void:
	var text := JSON.stringify(Data.table("hero_bios").get("arlindo", "")) + JSON.stringify(Data.table("hero_bios").get("erik", "")) + JSON.stringify(Data.table("barks").get("arlindo", {})) + JSON.stringify(Data.table("barks").get("erik", {}))
	for term in ["adam", "colar", "síntese", "astherion", "mestre"]:
		if text.to_lower().find(term) >= 0:
			out.append("bio ou fala cita '%s' (cânone do mestre)" % term)
