extends RefCounted
## SPEC-158 (MEC-059, MEC-060): névoa de borda e Maré de Névoa em todas as fases com próximo mapa.

func _bat(stage := "dagruve", size := Vector2(60, 60)) -> Battle:
	var b := Battle.new(7, "durvall", stage)
	b.map_size = size
	b.hero.map_size = size
	b.stage.waves = []
	b.stage.elites = []
	b.stage.duration = 99999
	b._inter_t = 99999.0
	b._breakable_t = 99999.0
	b.hero.pos = size * 0.5
	return b

## Perda de vida em `dt` segundos com o herói em `at`, sem regeneração nem defesas atrapalhando a conta.
func _edge_loss(b: Battle, at: Vector2, dt: float) -> float:
	b.hero.pos = at
	b.hero.hp = b.hero.max_hp
	b._update_edge_fog(dt)
	return (b.hero.max_hp - b.hero.hp) / b.hero.max_hp

func _scene_size(stage_id: String) -> Vector2:
	var f := FileAccess.open("res://ui/stages/%s.tscn" % stage_id, FileAccess.READ)
	if f == null:
		return Vector2.ZERO
	var rx := RegEx.new()
	rx.compile("map_size = Vector2i\\((\\d+), (\\d+)\\)")
	var m := rx.search(f.get_as_text())
	return Vector2(int(m.get_string(1)), int(m.get_string(2))) if m != null else Vector2.ZERO

func _collect_pos(node: Variant, out: Array) -> void:
	if node is Dictionary:
		for k in node:
			if String(k) == "pos" and node[k] is Array and node[k].size() == 2:
				out.append(Vector2(float(node[k][0]), float(node[k][1])))
			else:
				_collect_pos(node[k], out)
	elif node is Array:
		for v in node:
			_collect_pos(v, out)

func run() -> Array:
	var out: Array = []
	var cfg: Dictionary = Data.table("fog")

	# 1) A faixa de 3 tiles fere do dano inicial ao máximo de data/fog.json (hoje 3% a 9% da vida máxima por segundo) em 20 s de exposição contínua
	var edge_cfg: Dictionary = cfg.edge
	var e_start := float(edge_cfg.start_dps_pct)
	var e_max := float(edge_cfg.max_dps_pct)
	var b := _bat()
	if b.edge_band_tiles() != 3.0:
		out.append("a faixa de borda deveria ter 3 tiles (data/fog.json)")
	var first := _edge_loss(b, Vector2(2.5, 30), 1.0)
	var first_hi := e_start + (e_max - e_start) / float(edge_cfg.ramp_seconds) + 0.0005
	if first < e_start - 0.0001 or first > first_hi:
		out.append("o primeiro segundo na faixa deveria custar ~%.1f%% da vida (custou %.4f)" % [e_start * 100.0, first])
	var last := 0.0
	for i in 25:
		last = _edge_loss(b, Vector2(2.5, 30), 1.0)
	if absf(last - e_max) > 0.0005:
		out.append("a exposição longa deveria chegar a %.1f%% da vida por segundo (chegou a %.4f)" % [e_max * 100.0, last])
	if e_max <= e_start:
		out.append("o dano máximo da borda deveria passar do inicial")

	# 2) Fora da faixa nada acontece; as quatro bordas valem; o limite é 3 tiles
	var c := _bat()
	for at in [Vector2(30, 30), Vector2(3.2, 30), Vector2(30, 3.2), Vector2(56.9, 30), Vector2(30, 56.9)]:
		if _edge_loss(c, at, 1.0) != 0.0:
			out.append("fora da faixa não pode ferir (%s)" % str(at))
	for at in [Vector2(2.9, 30), Vector2(30, 2.9), Vector2(57.1, 30), Vector2(30, 57.1), Vector2(0.5, 0.5)]:
		var d := _bat()
		if _edge_loss(d, at, 1.0) <= 0.0:
			out.append("dentro da faixa deveria ferir (%s)" % str(at))

	# 3) Dano verdadeiro: ignora CA, esquiva, barreira e invulnerabilidade
	var t := _bat()
	t.hero.hero_mods = {"ca": 99, "cam": 99, "dodge": 0.99}
	t.hero.recalc()
	t.invuln = 5.0
	t.barrier = 999.0
	if _edge_loss(t, Vector2(1, 1), 1.0) <= 0.0:
		out.append("a névoa de borda deveria ignorar CA, esquiva, barreira e invulnerabilidade")

	# 4) Sair e voltar não zera o castigo: a exposição cai ao dobro da velocidade; ficar fora a zera
	var e := _bat()
	e.hero.pos = Vector2(1, 1)
	for i in 10:
		e.hero.hp = e.hero.max_hp
		e._update_edge_fog(1.0)
	if absf(e.edge_exposure - 10.0) > 0.001:
		out.append("a exposição deveria subir 1 por segundo na faixa (%.2f)" % e.edge_exposure)
	e.hero.pos = Vector2(30, 30)
	e._update_edge_fog(2.0)
	if absf(e.edge_exposure - 6.0) > 0.001:
		out.append("2 s fora deveriam tirar 4 s de exposição (%.2f)" % e.edge_exposure)
	e._update_edge_fog(10.0)
	if e.edge_exposure != 0.0:
		out.append("ficar fora tempo suficiente deveria zerar a exposição")

	# 5) Aviso uma vez por fase
	var w := _bat()
	w.hero.pos = Vector2(1, 1)
	w.hero.hp = w.hero.max_hp
	w.events.clear()
	w._update_edge_fog(0.1)
	w._update_edge_fog(0.1)
	var warns := 0
	for ev in w.events:
		if ev.get("type", "") == "toast" and String(ev.get("text", "")).contains("névoa queima"):
			warns += 1
	if warns != 1:
		out.append("o aviso da borda deveria sair uma vez (saiu %d)" % warns)

	# 6) Maré e borda juntas não somam: vale o maior dos dois (a borda só acrescenta o que passa da Maré)
	var s := _bat()
	s.fog_state = "advancing"
	s.fog_config = cfg.postboss.duplicate(true)
	s.fog_config["advance_seconds"] = 28.0
	s.fog_elapsed = 8.0 + 2.0 + 40.0
	s.fog_intensity = 1.0
	s.hero.pos = Vector2(1, 1)
	s.hero.hp = s.hero.max_hp
	s.edge_exposure = 99.0   # a borda já está no dano máximo
	var tide_pct := s.postboss_fog_pct_at_hero()
	if absf(tide_pct - float(cfg.postboss.max_dps_pct)) > 0.0001:
		out.append("a Maré cheia deveria valer %.1f%% (%.4f)" % [float(cfg.postboss.max_dps_pct) * 100.0, tide_pct])
	var before := s.hero.hp
	s._update_edge_fog(1.0)
	var extra_ratio := (before - s.hero.hp) / s.hero.max_hp
	if absf(extra_ratio - maxf(0.0, e_max - tide_pct)) > 0.0001:
		out.append("a borda deveria acrescentar só o que passa da Maré (%.4f, esperado %.4f)" % [extra_ratio, maxf(0.0, e_max - tide_pct)])
	s.fog_config["start_dps_pct"] = 0.5   # Maré mais forte que a borda: a borda não acrescenta nada
	s.fog_config["max_dps_pct"] = 0.5
	before = s.hero.hp
	s._update_edge_fog(1.0)
	if before - s.hero.hp > 0.0001:
		out.append("com a Maré mais forte que a borda, a borda não pode somar")

	# 7) Maré em todas as fases com próximo mapa; Pilares fica de fora
	var with_fog := 0
	var stages: Dictionary = Data.table("stages")
	for id in stages:
		var st: Dictionary = stages[id]
		var f := _bat(String(id), _scene_size(String(id)))
		f.interactions.clear()
		var boss_id := String(st.boss)
		var boss_e := f.spawn_for_test(boss_id, Vector2(30, 30))
		f._on_boss_dead(boss_e)
		boss_e.dead = true
		var has_next := String(st.get("next", "")) != ""
		if has_next:
			with_fog += 1
			if f.fog_state != "grace":
				out.append("%s: a Maré deveria nascer após o chefe" % id)
		elif f.fog_state != "inactive":
			out.append("%s: a última fase não pode ter Maré de fim de fase" % id)
	if with_fog != 8:
		out.append("esperava 8 fases com próximo mapa (achou %d)" % with_fog)

	# 8) A frente anda na mesma velocidade em 60x60 e 84x84
	var speeds: Array = []
	for size in [Vector2(60, 60), Vector2(84, 84)]:
		var g := _bat("molor", size)
		g._start_postboss_fog("molydeus_chefe")
		speeds.append(minf(size.x, size.y) * 0.5 / float(g.fog_config.advance_seconds))
	if absf(speeds[0] - speeds[1]) > 0.001:
		out.append("a frente da Maré deveria andar na mesma velocidade em 60x60 e 84x84 (%s)" % str(speeds))

	# 9) Nada necessário na faixa: interativos e portal do chefe nascem fora; POIs e câmaras dos segredos também
	for id in stages:
		var size := _scene_size(String(id))
		var h := _bat(String(id), size)
		h.interactions.clear()
		for at in [Vector2(0, 0), Vector2(size.x, size.y), Vector2(0.5, size.y * 0.5), Vector2(size.x * 0.5, 0.5), Vector2(size.x - 0.5, size.y * 0.5)]:
			h._add_interaction("chest", at)
		h._add_interaction("portal", Vector2(1, 1))
		for it in h.interactions:
			if h.in_edge_band(it.pos):
				out.append("%s: %s nasceu na faixa da névoa em %s" % [id, String(it.kind), str(it.pos)])
		var corner := _bat(String(id), size)
		corner.interactions.clear()
		var boss_c := corner.spawn_for_test(String(stages[id].boss), Vector2(1.5, 1.5))
		corner._on_boss_dead(boss_c)
		for it in corner.interactions:
			if corner.in_edge_band(it.pos):
				out.append("%s: %s do chefe morto no canto nasceu na faixa em %s" % [id, String(it.kind), str(it.pos)])
	var secrets: Dictionary = Data.table("secrets")
	for id in secrets:
		if String(id).begins_with("_"):
			continue
		var ssize := _scene_size(String(id))
		if ssize == Vector2.ZERO:
			continue
		var pts: Array = []
		_collect_pos(secrets[id], pts)
		var sb := _bat(String(id), ssize)
		for p in pts:
			if sb.in_edge_band(p):
				out.append("%s: ponto de segredo %s dentro da faixa da névoa" % [id, str(p)])
	return out
