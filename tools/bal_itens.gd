extends SceneTree
## Raridade e poder dos itens por tier (SPEC-122 B-001):
##   godot --headless --path . -s tools/bal_itens.gd -- <amostras por tier> [luck]
## Saída CSV (prefixo "CSV;"): tier;n;%comum;%magico;%incomum;%raro;%unico;poder_comum;poder_magico;poder_incomum;poder_raro;poder_unico
## Poder = soma de mods normalizados (pct /0,05; hp /5; regen /0,25; pickup /0,3; demais 1 por ponto). Régua grosseira, serve para comparar raridades.

func _unit(k: String) -> float:
	if k.ends_with("_pct") or k in ["dodge", "crit_overflow_bonus"]: return 0.05
	if k == "hp": return 5.0
	if k == "regen": return 0.25
	if k == "pickup": return 0.3
	return 1.0

func _power(mods: Dictionary) -> float:
	var s := 0.0
	for k in mods:
		s += float(mods[k]) / _unit(String(k))
	return s

func _init() -> void:
	var a := OS.get_cmdline_user_args()
	var n := int(a[0]) if a.size() > 0 else 4000
	var luck := float(a[1]) if a.size() > 1 else 0.0
	var rng := RandomNumberGenerator.new()
	rng.seed = 12345
	for tier in 9:
		var cnt := {"comum": 0, "magico": 0, "incomum": 0, "raro": 0, "unico": 0}
		var pw := {"comum": 0.0, "magico": 0.0, "incomum": 0.0, "raro": 0.0, "unico": 0.0}
		for i in n:
			var it := Items.roll(rng, tier, luck)
			var r := String(it.rarity)
			cnt[r] += 1
			pw[r] += _power(it.mods)
		var f := func(r: String) -> float: return 100.0 * cnt[r] / n
		var p := func(r: String) -> float: return pw[r] / maxf(1.0, cnt[r])
		print("CSV;%d;%d;%.1f;%.1f;%.1f;%.1f;%.1f;%.2f;%.2f;%.2f;%.2f;%.2f" % [tier, n, f.call("comum"), f.call("magico"), f.call("incomum"), f.call("raro"), f.call("unico"),
			p.call("comum"), p.call("magico"), p.call("incomum"), p.call("raro"), p.call("unico")])
	var db: Dictionary = Data.table("items")
	for u in db.uniques:
		print("UNI;%s;%s;%d;%.2f" % [u.id, u.slot, int(u.tier), _power(u.mods)])
	quit()
