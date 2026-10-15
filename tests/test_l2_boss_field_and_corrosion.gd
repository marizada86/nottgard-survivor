extends RefCounted
## L2 do relato do T05 (EVID-250/EVID-252): campo vivo com o chefe, PV do chefe com o poder do herói, corrosão de poça e névoa.

func _bat(stage := "dagruve", meta := {}) -> Battle:
	var b := Battle.new(9, "durvall", stage, {"meta_mods": meta})
	b.map_size = Vector2(60, 60)
	b.hero.map_size = b.map_size
	b.hero.pos = b.map_size * 0.5
	b._inter_t = 99999.0
	b._breakable_t = 99999.0
	b.stage.elites = []
	return b

func _set_l2(on: bool) -> void:
	Data.table("difficulty")["l2"]["enabled"] = on

func run() -> Array:
	var out: Array = []
	var was_on: bool = bool(Data.table("difficulty").get("l2", {}).get("enabled", false))
	if not Data.table("difficulty").has("l2"):
		return ["data/difficulty.json deveria ter o bloco l2"]
	var l4: Dictionary = Data.table("difficulty").get("l4", {})   # o L2 é medido sem o L4 (movimentos novos mexem nas contagens)
	var l4_was: bool = bool(l4.get("enabled", false))
	if l4.has("enabled"):
		l4["enabled"] = false
	_field(out)
	_boss_power(out)
	_corrosion(out)
	if l4.has("enabled"):
		l4["enabled"] = l4_was
	_set_l2(was_on)
	return out

## Inimigos vivos 20 s depois de o chefe nascer, herói imortal e parado.
func _alive_with_boss(l2: bool) -> int:
	_set_l2(l2)
	var b := _bat("dagruve")
	b.qa_prepare({"target_state": "boss", "prelude_seconds": 0.5, "level": 8})
	var t := 0.0
	while t < 22.0:
		b.hero.hp = b.hero.max_hp
		if b.state == "levelup" or b.state == "altar" or b.state == "item_offer":
			b.choose(0)
			continue
		b.step(Vector2.ZERO, 0.05)
		b.events.clear()
		t += 0.05
	if b.boss == null or b.boss_dead:
		return -1
	var n := 0
	for e in b.enemies:
		if not e.dead and not e.is_boss():
			n += 1
	return n

func _field(out: Array) -> void:
	var off := _alive_with_boss(false)
	var on := _alive_with_boss(true)
	if off < 0 or on < 0:
		out.append("o chefe deveria estar vivo para medir o campo (off %d, on %d)" % [off, on])
		return
	if on < off + 6:
		out.append("com o L2 o campo deveria ter bem mais inimigos com o chefe vivo (off %d, on %d)" % [off, on])
	# o teto da fase continua valendo
	var cap: int = int(Data.table("stages")["dagruve"].cap) + 12
	if on > cap:
		out.append("o campo passou do teto da fase (%d > %d)" % [on, cap])

func _boss_hp(l2: bool, level: int, meta: Dictionary) -> float:
	_set_l2(l2)
	var b := _bat("dagruve", meta)
	b.hero.level = level
	b.hero.recalc()
	b.qa_prepare({"target_state": "boss", "prelude_seconds": 0.1})
	b.hero.level = level
	b.hero.recalc()
	for _i in 8:
		b.step(Vector2.ZERO, 0.05)
		if b.boss != null:
			break
	return b.boss.max_hp if b.boss != null else -1.0

func _boss_power(out: Array) -> void:
	var base := _boss_hp(false, 20, {"dmg_pct": 1.0})
	var novice := _boss_hp(true, 4, {})
	var strong := _boss_hp(true, 20, {"dmg_pct": 1.0})
	var strongest := _boss_hp(true, 60, {"dmg_pct": 5.0})
	if base <= 0.0:
		out.append("o chefe deveria nascer na sonda")
		return
	if _boss_hp(false, 4, {}) != novice:
		out.append("o herói iniciante não deveria mudar o PV do chefe (%.0f contra %.0f)" % [novice, _boss_hp(false, 4, {})])
	if strong <= base * 1.2:
		out.append("herói forte deveria encontrar um chefe com bem mais PV (%.0f contra %.0f)" % [strong, base])
	var cap: float = base * (1.0 + float(Data.table("difficulty").l2.boss_power.max_bonus)) + 1.0
	if strongest > cap:
		out.append("o bônus do PV do chefe passou do teto (%.0f > %.0f)" % [strongest, cap])

func _puddle_loss(l2: bool, regen: bool) -> float:
	_set_l2(l2)
	var b := _bat("docas")
	b.stage.waves = []
	b.stage.duration = 99999
	if regen:
		b.hero.passives["regeneracao"] = 3
		b.hero.recalc()
	b.hero.hp = b.hero.max_hp * 0.5
	var start: float = b.hero.hp
	b.zones.append({"owner": "enemy", "kind": "puddle", "pos": b.hero.pos, "radius": 3.0, "delay": 0.0, "life": 30.0, "acc": 0.0})
	for _i in 60:   # 3 s dentro da poça
		b.step(Vector2.ZERO, 0.05)
		b.events.clear()
	return start - b.hero.hp

func _corrosion(out: Array) -> void:
	var plain_off := _puddle_loss(false, false)
	var plain_on := _puddle_loss(true, false)
	if plain_off <= 0.0:
		out.append("a poça deveria ferir o herói parado nela")
	if plain_on <= plain_off:
		out.append("com o L2 a poça deveria ferir mais (%.2f contra %.2f)" % [plain_on, plain_off])
	# regeneração: fora do L2 ela amortece a poça; no L2 é suspensa lá dentro
	var regen_off := _puddle_loss(false, true)
	var regen_on := _puddle_loss(true, true)
	if regen_off >= plain_off:
		out.append("a regeneração deveria amortecer a poça sem o L2 (%.2f contra %.2f)" % [regen_off, plain_off])
	if absf(regen_on - plain_on) > 0.1:
		out.append("com o L2 a regeneração deveria ficar suspensa dentro da poça (%.2f contra %.2f)" % [regen_on, plain_on])
	# névoa de borda: rampa final mais alta e sem regeneração
	_set_l2(true)
	var f := _bat("dagruve")
	f.stage.waves = []
	f.stage.duration = 99999
	f.hero.passives["regeneracao"] = 3
	f.hero.recalc()
	var edge := Vector2(0.6, 30.0)
	if not f.in_edge_band(edge):
		out.append("o ponto de teste deveria estar na faixa de borda")
		return
	f.hero.pos = edge
	for _i in 600:   # 30 s na borda: a rampa de 20 s chega ao máximo
		f.hero.hp = f.hero.max_hp
		f.step(Vector2.ZERO, 0.05)
		f.events.clear()
		f.hero.pos = edge
	f.hero.hp = f.hero.max_hp
	f._update_edge_fog(1.0)
	var per_second: float = (f.hero.max_hp - f.hero.hp) / f.hero.max_hp
	var expected: float = float(Data.table("difficulty").l2.corrosion.edge_max_dps_pct)
	if absf(per_second - expected) > 0.005:
		out.append("a borda no máximo deveria tirar %.0f%% do PV por segundo, tirou %.1f%%" % [expected * 100.0, per_second * 100.0])
	if f._corroded_t <= 0.0:
		out.append("a faixa de borda deveria suspender a regeneração")
