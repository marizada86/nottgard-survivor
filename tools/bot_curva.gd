extends SceneTree
## Curva de dificuldade por fase (PLAN-055 F2). Mesmo piloto do tools/bot.gd, mas mede cada fase:
##   godot --headless --path . -s tools/bot_curva.gd -- <heroi> <seeds> [dt] [maxfases] [lado] [meta 0=novato 1=veterano 2=loja cheia] [marcas] [l2 0|1] [l4 0|1] [boss_mech 0|1]
## Saída CSV (prefixo "CSV;"): heroi;seed;fase;nv_entrada;nv_saida;dur_s;pv_min_pct;s_abaixo_50;s_abaixo_25;dano_recebido;chefe_s;resultado
## BAL-023 (venda = só da run, fora do total): junto de cada CSV sai uma linha "GOLD;" com moedas brutas da fase por fonte:
##   GOLD;heroi;seed;fase;total;abate;elite;chefe;quebravel;evento;venda;oferta;arma;outro

var _map_side := 60.0
var _start_stage := "dagruve"
var _meta := {}
var _marks := {}   # SPEC-141 e SPEC-143: 7º argumento "horda=3,fome=2", "all=3" ou "all=max"
const METAS := [{}, {"dmg_pct": 0.16, "hp": 8, "ca": 1, "speed_pct": 0.03}, {"dmg_pct": 0.4, "hp": 20, "ca": 3, "speed_pct": 0.09, "pickup": 1.2}]

func _init() -> void:
	var a := OS.get_cmdline_user_args()
	var hero: String = a[0] if a.size() > 0 else "durvall"
	var seeds := int(a[1]) if a.size() > 1 else 3
	var dt := float(a[2]) if a.size() > 2 else 0.08
	var max_stages := int(a[3]) if a.size() > 3 else 9
	_map_side = float(a[4]) if a.size() > 4 else 60.0
	_meta = METAS[clampi(int(a[5]) if a.size() > 5 else 0, 0, 2)]
	_marks = _parse_marks(a[6] if a.size() > 6 else "")
	# 8º argumento: 0 desliga o bloco "l2" de data/difficulty.json (campo vivo, PV do chefe, corrosão); padrão = o que está no arquivo
	if a.size() > 7:
		Data.table("difficulty")["l2"]["enabled"] = (a[7] != "0")
	if a.size() > 8:   # 9º argumento: 0 desliga o bloco "l4" (inimigos legíveis e movimentos novos)
		Data.table("difficulty")["l4"]["enabled"] = (a[8] != "0")
	if a.size() > 9:   # 10º argumento: 0 desliga o bloco "boss_mech" (mecânicas de chefe do L5)
		Data.table("difficulty")["boss_mech"]["enabled"] = (a[9] != "0")
	if a.size() > 10 and a[10] != "":   # 11º argumento: fase inicial (padrão dagruve); 12º: chefes sem mecânica, separados por vírgula
		_start_stage = a[10]
	if a.size() > 11:
		Data.table("difficulty")["boss_mech"]["off_bosses"] = Array(a[11].split(",", false))
	TerrainLayout.scale = _map_side / 40.0
	for s in seeds:
		_run(hero, s + 1, dt, max_stages)
	quit()

## "all=3" liga todas as marcas no nível 3 (limitado ao máximo de cada uma); "all=max" liga todas no máximo; "horda=2,fome=max" liga marcas soltas; vazio = sem marcas.
func _parse_marks(text: String) -> Dictionary:
	var out := {}
	for part in text.split(",", false):
		var kv := part.split("=")
		if kv.size() != 2:
			continue
		if kv[0] == "all":
			for id in AbyssMarks.ids():
				out[id] = AbyssMarks.max_level(String(id)) if kv[1] == "max" else int(kv[1])
		else:
			out[kv[0]] = AbyssMarks.max_level(kv[0]) if kv[1] == "max" else int(kv[1])
	return AbyssMarks.normalize(out)

func _new_stat(b: Battle) -> Dictionary:
	return {"id": b.stage_id, "lv0": b.hero.level, "g0": float(b.stats.gold), "src0": b.stats.gold_src.duplicate(), "ext0": b.stats.gold_extra.duplicate(), "t0": b.run_time, "min": 1.0, "b50": 0.0, "b25": 0.0, "dmg": 0.0, "boss_t0": -1.0, "boss": -1.0, "res": "?"}

func _emit(hero_id: String, seed_v: int, st: Dictionary, b: Battle) -> void:
	print("CSV;%s;%d;%s;%d;%d;%.0f;%d;%.0f;%.0f;%.0f;%.0f;%s" % [hero_id, seed_v, st.id, st.lv0, b.hero.level, b.run_time - float(st.t0),
		int(float(st.min) * 100.0), st.b50, st.b25, st.dmg, st.boss, st.res])
	var cols: Array = []
	for k in ["abate", "elite", "chefe", "quebravel", "evento", "venda", "oferta", "arma", "outro"]:
		if k == "venda":  # SPEC-142: venda vale só na run (fora do total do Quartel)
			cols.append("%.0f" % (float(b.stats.gold_extra.get(k, 0.0)) - float(st.ext0.get(k, 0.0))))
		else:
			cols.append("%.0f" % (float(b.stats.gold_src.get(k, 0.0)) - float(st.src0.get(k, 0.0))))
	print("GOLD;%s;%d;%s;%.0f;%s" % [hero_id, seed_v, st.id, float(b.stats.gold) - float(st.g0), ";".join(cols)])

func _run(hero_id: String, seed_v: int, dt: float, max_stages: int) -> void:
	seed(seed_v * 7919)  # BAL-018: RNG global do bot reprodutível (empates em _pick)
	var b := Battle.new(seed_v, hero_id, _start_stage, {"meta_mods": _meta, "abyss_marks": _marks})
	b.map_size = Vector2(_map_side, _map_side)
	b.hero.map_size = b.map_size
	b.hero.pos = b.map_size * 0.5
	var st := _new_stat(b)
	var n_stages := 1
	var steps := 0
	var last_hp: float = b.hero.hp
	while steps < 600000:
		steps += 1
		if b.state == "levelup" or b.state == "altar":
			b.choose(_pick(b))
			continue
		if b.state == "item_offer":
			b.choose(_pick_item(b))
			continue
		if b.run_time > 9000.0:
			st.res = "cap_tempo"
			break
		if b.state == "dead" or b.state == "revive_offer":
			st.res = "morreu@%.0fs" % b.time
			break
		if b.state == "won":
			st.res = "venceu"
			break
		if b.stage_id != st.id:
			st.res = "passou"
			_emit(hero_id, seed_v, st, b)
			n_stages += 1
			if n_stages > max_stages:
				return
			st = _new_stat(b)
			last_hp = b.hero.hp
		# L5: com mecânicas de chefe o piloto guarda a habilidade para interromper a conjuração (como um jogador atento)
		var hold_active: bool = b.boss_mech != null and b.boss_mech.cast.is_empty()
		if b.active_cd <= 0.0 and not b.enemies.is_empty() and not hold_active:
			var active_target := b.nearest(b.hero.pos, 10.0)
			var active_dir := (active_target.pos - b.hero.pos).normalized() if active_target != null else Vector2(1, 0)
			b.use_active(active_dir)
		b.step(_move(b), dt)
		var ratio: float = b.hero.hp / maxf(1.0, b.hero.max_hp)
		st.min = minf(float(st.min), ratio)
		if ratio < 0.5: st.b50 = float(st.b50) + dt
		if ratio < 0.25: st.b25 = float(st.b25) + dt
		if b.hero.hp < last_hp: st.dmg = float(st.dmg) + (last_hp - b.hero.hp)
		last_hp = b.hero.hp
		if b.boss != null and not b.boss.dead and float(st.boss_t0) < 0.0:
			st.boss_t0 = b.time
		elif b.boss_dead and float(st.boss_t0) >= 0.0 and float(st.boss) < 0.0:
			st.boss = b.time - float(st.boss_t0)
		b.events.clear()
		_interact(b)
		if b.stage_cleared and b.stage.get("next", "") == "" and not b.stage.get("endless", false):
			st.res = "fim"
			break
		if b.stage_cleared and b.stage.get("next", "") != "":
			for it in b.interactions:
				if it.kind == "portal" and not it.used:
					b.hero.pos = it.pos
					b.interact()
	_emit(hero_id, seed_v, st, b)

func _interact(b: Battle) -> void:
	# usa altares e rituais próximos como um jogador usaria
	for it in b.interactions:
		if not it.used and it.kind in ["altar"] and it.pos.distance_to(b.hero.pos) < 1.6:
			b.interact()
			return

func _pick(b: Battle) -> int:
	var best := 0
	var best_s := -1.0
	for i in b.offer.size():
		var o: Dictionary = b.offer[i]
		var s := 1.0
		match String(o.t):
			"evolve": s = 10.0
			"weapon_up": s = 6.0
			"weapon_new": s = 4.0 if b.hero.weapons.size() < 3 else 2.0
			"passive": s = 5.0 if o.id in ["constituicao", "regeneracao", "cota_de_malha", "forca", "foco_arcano", "pele_de_pedra"] else 3.0
			"boon": s = 5.0
			"heal": s = 2.0
		s += randf() * 0.5
		if s > best_s:
			best_s = s
			best = i
	return best

func _move(b: Battle) -> Vector2:
	var h := b.hero
	var v := Vector2.ZERO
	var near := 0
	for e in b.enemies:
		var off: Vector2 = h.pos - e.pos
		var d := off.length()
		if d < 4.5 and d > 0.01:
			near += 1
			var w := 1.0 / maxf(0.4, d * d)
			if e.move == "keep":
				w *= 0.4
			v += off / d * w
	for z in b.zones:
		if z.owner != "hero" and (z.kind == "telegraph" or z.kind == "puddle"):
			var off: Vector2 = h.pos - z.pos
			var d := off.length()
			if d < z.radius + 1.6 and d > 0.01:
				v += off / d * 2.5
	for p in b.projectiles:
		if p.owner == "enemy":
			var off: Vector2 = h.pos - p.pos
			var d := off.length()
			if d < 3.0 and d > 0.01:
				var perp := Vector2(-p.dir.y, p.dir.x)
				v += perp * (1.0 if perp.dot(off) >= 0.0 else -1.0) * 1.5 / maxf(0.5, d)
	# pickups atraem quando calmo
	if near == 0 or v.length() < 0.4:
		var best: Variant = null
		var bd := 9.0
		for pk in b.pickups:
			var d: float = pk.pos.distance_to(h.pos)
			if d < bd:
				bd = d
				best = pk
		if best != null:
			v += (best.pos - h.pos).normalized() * 0.6
		for it in b.interactions:
			if not it.used and it.kind in ["chest", "fountain", "altar"]:
				var d2: float = it.pos.distance_to(h.pos)
				if d2 < 16.0:
					v += (it.pos - h.pos).normalized() * 0.5
	# fica longe das bordas (SPEC-158: com a faixa de névoa ligada, recua mais cedo e com mais força)
	var m := 3.0
	var k := 1.0
	if b.edge_band_tiles() > 0.0:
		m = b.edge_band_tiles() + 2.0
		k = 3.0
	if h.pos.x < m: v.x += k * (m - h.pos.x)
	if h.pos.y < m: v.y += k * (m - h.pos.y)
	if h.pos.x > b.map_size.x - m: v.x -= k * (h.pos.x - (b.map_size.x - m))
	if h.pos.y > b.map_size.y - m: v.y -= k * (h.pos.y - (b.map_size.y - m))
	# quando o boss existe e está calmo, aproxima para causar dano
	if b.boss != null and not b.boss.dead and near < 3:
		v += (b.boss.pos - h.pos).normalized() * 0.5
	if b.boss_mech != null:   # L5: desvia de varredura e quadrantes acesos
		v += _mech_avoid(b)
	if v.length() < 0.05:
		return Vector2.ZERO
	return Iso.to_screen(v.normalized()).normalized()

## Troca de item (MEC-021/027): fica com a opção de melhor saldo de modificadores; empate, a primeira (equipar o novo).
func _pick_item(b: Battle) -> int:
	var best := 0
	var best_s := -999
	for i in b.offer.size():
		var badge: Dictionary = b.offer[i].get("badge", {})
		var s := int(badge.get("up", 0)) - int(badge.get("down", 0))
		if s > best_s or (s == best_s and bool(b.offer[i].get("equips", false))):   # L1: empate equipa o novo (o atual vem primeiro)
			best_s = s
			best = i
	return best

## L5: desvio das mecânicas de chefe (varredura, quadrantes). Vetor em coordenadas de mundo, peso alto para dominar o resto.
func _mech_avoid(b: Battle) -> Vector2:
	var m: BossMechanics = b.boss_mech
	var h := b.hero
	var push := Vector2.ZERO
	if not m.sweep.is_empty():
		var origin: Vector2 = m.sweep.origin
		var dir := Vector2.from_angle(float(m.sweep.a))
		var rel := h.pos - origin
		var along := rel.dot(dir)
		var across := rel.cross(dir)
		if along > -1.0 and along < float(m.sweep.len) + 1.0 and absf(across) < 2.6:
			var side := 1.0 if across >= 0.0 else -1.0
			push += Vector2(-dir.y, dir.x) * side * 4.0 * -1.0 + (h.pos - origin).normalized() * 1.5
	if not m.quad.is_empty():
		var center: Vector2 = m.quad.center
		var rel2 := h.pos - center
		if rel2.length() <= float(m.quad.radius) + 1.0:
			var idx := int(floor(wrapf(rel2.angle(), 0.0, TAU) / (TAU / 4.0)))
			if (m.quad.sectors as Array).has(idx):
				var safe := 0
				for s in 4:
					if not (m.quad.sectors as Array).has(s):
						safe = s
						break
				var target := center + Vector2.from_angle((float(safe) + 0.5) * TAU / 4.0) * 4.0
				push += (target - h.pos).normalized() * 4.0
	return push
