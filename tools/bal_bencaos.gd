extends SceneTree
## Poder das bênçãos (SPEC-129 B-001, BAL-019). Mesmo piloto do tools/bot_curva.gd, mas o herói começa a run
## com UMA bênção forçada (ou nenhuma, "none" = controle) e nunca escolhe bênção nos altares (recusa):
##   godot --headless --path . -s tools/bal_bencaos.gd -- <heroi> <seeds> <bencao_id|none> [dt] [maxfases] [lado] [meta 0=novato 1=veterano] [arma:nivel]
## Saída CSV (prefixo "CSV;"): bencao;heroi;seed;fase;nv_entrada;nv_saida;dur_s;pv_min_pct;dano_recebido;resultado
## Ferramenta de medição: não altera o jogo.

var _map_side := 60.0
var _meta := {}
var _weapon := ""
var _passive := ""
const METAS := [{}, {"dmg_pct": 0.16, "hp": 8, "ca": 1, "speed_pct": 0.03}]

func _init() -> void:
	var a := OS.get_cmdline_user_args()
	var hero: String = a[0] if a.size() > 0 else "durvall"
	var seeds := int(a[1]) if a.size() > 1 else 3
	var boon_id: String = a[2] if a.size() > 2 else "none"
	var dt := float(a[3]) if a.size() > 3 else 0.1
	var max_stages := int(a[4]) if a.size() > 4 else 4
	_map_side = float(a[5]) if a.size() > 5 else 60.0
	_meta = METAS[clampi(int(a[6]) if a.size() > 6 else 0, 0, 1)]
	TerrainLayout.scale = _map_side / 40.0
	_passive = a[8] if a.size() > 8 else ""  # ex.: regeneracao:5 (passiva forçada no nível dado)
	_weapon = a[7] if a.size() > 7 and a[7] != "-" else ""  # ex.: vela_sagrada:5 (arma extra no nível dado; "none" na bênção mede só a arma)
	var boon := {}
	var extra: Array = []  # SPEC-129 B-004: "a+b" força duas ou mais bênçãos (mede o Favor)
	if boon_id != "none":
		for one in boon_id.split("+"):
			var found := {}
			for b in Data.table("boons").boons:
				if String(b.id) == one:
					found = b
			if found.is_empty():
				printerr("bênção desconhecida: " + one)
				quit(1)
				return
			extra.append(found)
		boon = extra[0]
	for s in seeds:
		_run(hero, s + 1, dt, max_stages, boon_id, extra)
	quit()

func _new_stat(b: Battle) -> Dictionary:
	return {"id": b.stage_id, "lv0": b.hero.level, "t0": b.run_time, "min": 1.0, "dmg": 0.0, "res": "?"}

func _emit(boon_id: String, hero_id: String, seed_v: int, st: Dictionary, b: Battle) -> void:
	print("CSV;%s;%s;%d;%s;%d;%d;%.0f;%d;%.0f;%s" % [boon_id, hero_id, seed_v, st.id, st.lv0, b.hero.level, b.run_time - float(st.t0),
		int(float(st.min) * 100.0), st.dmg, st.res])

func _run(hero_id: String, seed_v: int, dt: float, max_stages: int, boon_id: String, boons: Array) -> void:
	seed(seed_v * 7919)
	var b := Battle.new(seed_v, hero_id, "dagruve", {"meta_mods": _meta})
	b.map_size = Vector2(_map_side, _map_side)
	b.hero.map_size = b.map_size
	b.hero.pos = b.map_size * 0.5
	if _weapon != "":
		var wp := _weapon.split(":")
		b.hero.weapons.append(Weapon.make(wp[0], int(wp[1]) if wp.size() > 1 else 1))
	if _passive != "":
		var pp := _passive.split(":")
		b.hero.passives[pp[0]] = int(pp[1]) if pp.size() > 1 else 1
	for bn in boons:
		b.hero.boons.append(bn)
	if not boons.is_empty() or _passive != "":
		b.hero.recalc()
		b.hero.hp = b.hero.max_hp
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
			b.choose(0)
			continue
		if b.run_time > 9000.0:
			st.res = "cap_tempo"
			break
		if b.state == "dead" or b.state == "revive_offer":
			st.res = "morreu"
			break
		if b.state == "won":
			st.res = "venceu"
			break
		if b.stage_id != st.id:
			st.res = "passou"
			_emit(boon_id, hero_id, seed_v, st, b)
			n_stages += 1
			if n_stages > max_stages:
				_emit_kinds(boon_id, hero_id, seed_v, b)
				return
			st = _new_stat(b)
			last_hp = b.hero.hp
		if b.active_cd <= 0.0 and not b.enemies.is_empty():
			var active_target := b.nearest(b.hero.pos, 10.0)
			var active_dir := (active_target.pos - b.hero.pos).normalized() if active_target != null else Vector2(1, 0)
			b.use_active(active_dir)
		b.step(_move(b), dt)
		var ratio: float = b.hero.hp / maxf(1.0, b.hero.max_hp)
		st.min = minf(float(st.min), ratio)
		if b.hero.hp < last_hp: st.dmg = float(st.dmg) + (last_hp - b.hero.hp)
		last_hp = b.hero.hp
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
	_emit(boon_id, hero_id, seed_v, st, b)
	_emit_kinds(boon_id, hero_id, seed_v, b)

func _emit_kinds(boon_id: String, hero_id: String, seed_v: int, b: Battle) -> void:
	print("KIND;%s;%s;%d;%d;%d;%d" % [boon_id, hero_id, seed_v, b.kinds.oath_kept, b.kinds.oath_broken, b.kinds.star_exhausted])

func _interact(b: Battle) -> void:
	for it in b.interactions:
		if not it.used and it.kind in ["altar"] and it.pos.distance_to(b.hero.pos) < 1.6:
			b.interact()
			return

## Altar: sempre recusa (a bênção medida é só a forçada). Level-up: mesma regra do bot_curva, sem bênção.
func _pick(b: Battle) -> int:
	var best := 0
	var best_s := -1.0
	for i in b.offer.size():
		var o: Dictionary = b.offer[i]
		var s := 1.0
		match String(o.t):
			"boon_skip": s = 100.0
			"boon": s = -10.0
			"evolve": s = 10.0
			"weapon_up": s = 6.0
			"weapon_new": s = 4.0 if b.hero.weapons.size() < 3 else 2.0
			"passive": s = 5.0 if o.id in ["constituicao", "regeneracao", "cota_de_malha", "forca", "foco_arcano", "pele_de_pedra"] else 3.0
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
	if near == 0 or v.length() < 0.4:
		var star: Variant = b.kinds.star_pos()  # SPEC-129: Caminho da Estrela; o piloto segue a estrela quando calmo
		if star != null:
			v += (star - h.pos).normalized() * 0.8
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
	var m := 3.0
	if h.pos.x < m: v.x += (m - h.pos.x)
	if h.pos.y < m: v.y += (m - h.pos.y)
	if h.pos.x > b.map_size.x - m: v.x -= (h.pos.x - (b.map_size.x - m))
	if h.pos.y > b.map_size.y - m: v.y -= (h.pos.y - (b.map_size.y - m))
	if b.boss != null and not b.boss.dead and near < 3:
		v += (b.boss.pos - h.pos).normalized() * 0.5
	if v.length() < 0.05:
		return Vector2.ZERO
	return Iso.to_screen(v.normalized()).normalized()
