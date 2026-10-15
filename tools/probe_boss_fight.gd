extends SceneTree
## PLAN-105 (EVID-260): luta de chefe com um herói que se movimenta (mantém distância, desvia de zonas, projéteis,
## varredura e quadrantes e guarda a ativa para interromper conjurações). Compara com e sem as mecânicas do chefe.
##   godot --headless --path . -s tools/probe_boss_fight.gd -- <heroi> <nivel> <nivel_armas> <sementes> <camada 0|1|2> <fases,...> [off_bosses,...] [sem_enrage|-] [pv_do_chefe]
## Saída CSV: "FIGHT;fase;variante;semente;resultado;duracao_s;pv_min_pct;dano_recebido". Com IMMORTAL o herói é curado a cada passo (mede dano causado pelas mecânicas e a duração da luta).

const IMMORTAL := true
var near_mode := false
const METAS := [{}, {"dmg_pct": 1.0, "hp": 60, "ca": 4}, {"dmg_pct": 2.0, "hp": 100, "ca": 6, "speed_pct": 0.1}]

func _init() -> void:
	var a := OS.get_cmdline_user_args()
	var hero_id: String = a[0] if a.size() > 0 else "durvall"
	var level := int(a[1]) if a.size() > 1 else 12
	var wlevel := int(a[2]) if a.size() > 2 else 4
	var seeds := int(a[3]) if a.size() > 3 else 6
	var tier := int(a[4]) if a.size() > 4 else 1
	var stages: PackedStringArray = (a[5] if a.size() > 5 else "shedaklah,durao").split(",", false)
	var off: Array = Array(a[6].split(",", false)) if a.size() > 6 else []
	var boss_hp := float(a[8]) if a.size() > 8 else 0.0   # fixa o PV do chefe (as lutas tardias passam de 300 s com o herói sintético)
	var flags: PackedStringArray = a[7].split(",", false) if a.size() > 7 else PackedStringArray()
	if flags.has("sem_enrage"):   # separa o efeito do enrage suave do das demais mecânicas
		Data.table("difficulty")["boss_mech"]["verbs"]["enrage"] = false
	if flags.has("perto"):   # herói de corpo a corpo: encosta no chefe (distância 1,6 a 3) em vez de mantê-lo a 3,5 a 6,5
		near_mode = true
	if flags.has("sem_campo"):   # sem as ondas do L2 durante o chefe (a mira automática não alcança o chefe no meio de 20 inimigos)
		Data.table("difficulty")["l2"]["field"]["rate"] = 0.0
	var pool := ["espada_sombria", "romper_armadura", "lamina_de_sombra"]
	if a.size() > 7 and a[7].split(",", false).has("alcance"):   # armas à distância: chefes que mantêm distância (Discípulo, Malcanthet)
		pool = ["descarga_estelar", "bola_de_fogo", "raio_de_luz"]
	for stage_id in stages:
		for variant in ["antes", "depois"]:
			Data.table("difficulty")["boss_mech"]["off_bosses"] = off if variant == "antes" else []
			for s in seeds:
				print(_fight(hero_id, level, wlevel, tier, stage_id, variant, s + 1, pool, boss_hp))
	quit()

func _fight(hero_id: String, level: int, wlevel: int, tier: int, stage_id: String, variant: String, seed_v: int, pool: Array, boss_hp: float = 0.0) -> String:
	var b := Battle.new(seed_v, hero_id, stage_id, {"meta_mods": METAS[clampi(tier, 0, 2)]})
	b.map_size = Vector2(60, 60)
	b.hero.map_size = b.map_size
	b.hero.pos = b.map_size * 0.5
	b.stage.waves = [{"id": "zumbi", "t0": 99999.0, "t1": 99999.0, "every": 1000.0, "n": 1, "max": 1}]   # sem ondas, mas a primeira existe (o modo infinito a usa no pinga-pinga)
	b.stage.elites = []
	b._inter_t = 99999.0
	b._breakable_t = 99999.0
	b.qa_prepare({"target_state": "boss", "prelude_seconds": 0.5, "level": level, "weapons": pool.slice(0, 3)})
	for w in b.hero.weapons:
		w.level = clampi(wlevel, 1, 5)
	b.hero.recalc()
	b.hero.hp = b.hero.max_hp
	var t := 0.0
	var t_boss := -1.0
	var t_boss_loop := -1.0
	var min_hp := 1.0
	var start_hp: float = b.hero.hp
	var taken := 0.0
	var last_hp: float = b.hero.hp
	var result := "tempo"
	while t < 300.0:
		if b.state == "levelup" or b.state == "altar" or b.state == "item_offer":
			b.choose(0)
			continue
		if b.state == "dead" or b.state == "revive_offer":
			result = "herói morreu"
			break
		if b.boss != null and t_boss < 0.0:
			t_boss = b.time
			t_boss_loop = t
			if boss_hp > 0.0:
				b.boss.max_hp = boss_hp
				b.boss.hp = boss_hp
		var m: BossMechanics = b.boss_mech
		if b.active_cd <= 0.0 and b.boss != null and (m == null or not m.cast.is_empty()) and not b.enemies.is_empty():
			b.use_active((b.boss.pos - b.hero.pos).normalized())
		b.step(_move(b), 0.05)
		t += 0.05
		var ratio: float = b.hero.hp / maxf(1.0, b.hero.max_hp)
		min_hp = minf(min_hp, ratio)
		if b.hero.hp < last_hp:
			taken += last_hp - b.hero.hp
		if IMMORTAL:   # mede a ameaça das mecânicas sem a morte encerrar a luta: o herói é curado a cada passo
			b.hero.hp = b.hero.max_hp
		last_hp = b.hero.hp
		b.events.clear()
		if b.boss_dead:
			result = "chefe caiu"
			break
	var dur := (t - t_boss_loop) if t_boss_loop >= 0.0 else -1.0   # relógio do laço: no modo infinito o `time` zera ao cair o chefe
	return "FIGHT;%s;%s;%d;%s;%.1f;%d;%d" % [stage_id, variant, seed_v, result, dur, int(min_hp * 100.0), int(taken)]

func _move(b: Battle) -> Vector2:
	var h := b.hero
	var v := Vector2.ZERO
	for e in b.enemies:
		if e.dead or e.is_boss():
			continue
		var off: Vector2 = h.pos - e.pos
		var d := off.length()
		if d < 3.0 and d > 0.01:
			v += off / d / maxf(0.5, d * d)
	for z in b.zones:
		if z.owner != "hero" and (z.kind == "telegraph" or z.kind == "puddle"):
			var off2: Vector2 = h.pos - z.pos
			var d2 := off2.length()
			if d2 < float(z.radius) + 1.6 and d2 > 0.01:
				v += off2 / d2 * 2.5
	for p in b.projectiles:
		if p.owner == "enemy":
			var off3: Vector2 = h.pos - p.pos
			var d3 := off3.length()
			if d3 < 3.0 and d3 > 0.01:
				var perp := Vector2(-p.dir.y, p.dir.x)
				v += perp * (1.0 if perp.dot(off3) >= 0.0 else -1.0) * 1.5 / maxf(0.5, d3)
	if b.boss != null and not b.boss.dead:
		var to_boss: Vector2 = b.boss.pos - h.pos
		var db := to_boss.length()
		var lo := 1.6 if near_mode else 3.5
		var hi := 3.0 if near_mode else 6.5
		if db < lo:
			v -= to_boss.normalized() * 1.2
		elif db > hi:
			v += to_boss.normalized() * 0.6
	if b.boss_mech != null:
		v += _mech_avoid(b)
	var margin := 3.0
	if h.pos.x < margin: v.x += margin - h.pos.x
	if h.pos.y < margin: v.y += margin - h.pos.y
	if h.pos.x > b.map_size.x - margin: v.x -= h.pos.x - (b.map_size.x - margin)
	if h.pos.y > b.map_size.y - margin: v.y -= h.pos.y - (b.map_size.y - margin)
	if v.length() < 0.05:
		return Vector2.ZERO
	return Iso.to_screen(v.normalized()).normalized()

func _mech_avoid(b: Battle) -> Vector2:
	var m: BossMechanics = b.boss_mech
	var h := b.hero
	var push := Vector2.ZERO
	if not m.sweep.is_empty():
		var origin: Vector2 = m.sweep.origin
		var rel := h.pos - origin
		for off in m.sweep.get("offsets", [0.0]):
			var dir := Vector2.from_angle(float(m.sweep.a) + float(off))
			var along := rel.dot(dir)
			var across := rel.cross(dir)
			if along > -1.0 and along < float(m.sweep.len) + 1.0 and absf(across) < 2.6:
				var side := 1.0 if across >= 0.0 else -1.0
				push += Vector2(-dir.y, dir.x) * side * -4.0 + rel.normalized() * 1.5
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
	if not m.mark.is_empty() and float(m.mark.t) >= float(m.mark.follow) - 0.3:
		var rel3: Vector2 = h.pos - (m.mark.pos as Vector2)
		if rel3.length() < float(m.mark.radius) + 1.0:
			push += (rel3.normalized() if rel3.length() > 0.01 else Vector2(1, 0)) * 5.0
	return push
