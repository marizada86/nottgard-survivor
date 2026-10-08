extends SceneTree
## PLAN-081 B-005 (SPEC-150, SPEC-151): régua do conteúdo novo contra o que já existe.
##   godot --headless --path . -s tools/bal_conteudo_novo.gd
## Armas: DPS esperado em alvo único, sem crítico, modificador de atributo +2 (referência), nível 1 e 5; "area" = o que multiplica alvos.
## Itens únicos: poder = soma de mods normalizados (mesma régua de tools/bal_itens.gd), por slot e tier.
## Saída: linhas "ARMA;..." e "ITEM;...".

const NEW_WEAPONS := ["bola_de_fogo", "tormenta_de_fogo", "lamina_de_sombra", "romper_armadura", "esmagar_defesas", "dominio_da_vontade"]
const REFERENCE := ["descarga_estelar", "chuva_de_estrelas", "lamina_trovejante", "raio_enfraquecedor", "golpe_esmagador", "golpe_do_juizo", "dominar_pessoa", "cera_fervente", "espada_sombria"]
const NEW_ITEMS := ["cajado_familia_infernum", "wave_of_terror", "colar_visao_verdadeira", "detector_arcano", "dispositivo_antimagia_gilly", "dispositivo_das_docas", "coracao_da_dominancia"]

func _unit(k: String) -> float:
	if k.ends_with("_pct") or k in ["dodge", "crit_overflow_bonus"]:
		return 0.05
	if k == "hp":
		return 5.0
	if k == "regen":
		return 0.25
	if k == "pickup":
		return 0.3
	return 1.0

func _power(mods: Dictionary) -> float:
	var s := 0.0
	for k in mods:
		s += float(mods[k]) / _unit(String(k))
	return s

func _dps(w: Weapon) -> float:
	var p := w.params()
	var avg := Dice.avg(String(p.get("dice", "1d4"))) + 2.0 + float(p.get("dmg", 0))
	var n := maxf(1.0, float(p.get("count", 1)))
	return avg * n / maxf(0.1, float(p.get("cd", 1.0)))

func _area(p: Dictionary) -> String:
	if p.has("radius"):
		return "r%.1f" % float(p.radius)
	if p.has("cone"):
		return "c%d" % int(p.cone)
	return "p%d" % int(p.get("pierce", 0))

func _init() -> void:
	var table: Dictionary = Data.table("weapons")
	for group in [["novo", NEW_WEAPONS], ["ref", REFERENCE]]:
		for id in group[1]:
			var w1 := Weapon.make(String(id))
			var w5 := Weapon.make(String(id), 5)
			var p := w1.params()
			var extra := ""
			for k in ["weaken", "ignore_def", "stun", "pierce"]:
				if float(p.get(k, 0.0)) > 0.0:
					extra += " %s=%s" % [k, p[k]]
			print("ARMA;%s;%s;%s;%s;%.2f;%.2f;%s;%s" % [group[0], id, p.kind, p.dtype, _dps(w1), _dps(w5), _area(p), extra.strip_edges()])
	var uniques: Array = Data.table("items").uniques
	for u in uniques:
		var tag := "novo" if NEW_ITEMS.has(String(u.id)) else "ref"
		print("ITEM;%s;%s;%s;%d;%.1f;%s" % [tag, u.id, u.slot, int(u.tier), _power(u.mods), "arma:" + String(u.weapon) if String(u.get("weapon", "")) != "" else ""])
	quit()
