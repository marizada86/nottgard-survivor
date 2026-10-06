extends RefCounted
## SPEC-129 B-004: Favor divino e rivalidade.

func _boon(id: String) -> Dictionary:
	for b in Data.table("boons").boons:
		if String(b.id) == id:
			return b
	return {}

func _bat() -> Battle:
	var b := Battle.new(4, "durvall", "dagruve")
	b.hero.pos = Vector2(30, 30)
	b.stage.waves = []
	b.stage.elites = []
	b._inter_t = 99999.0
	b._breakable_t = 99999.0
	return b

func run() -> Array:
	var out: Array = []
	var cfg: Dictionary = Data.table("favor")
	# dados: todo deus de bênção tem entrada; rivais são recíprocos
	for bn in Data.table("boons").boons:
		if not cfg.gods.has(String(bn.god)):
			out.append("deus %s das bênçãos sem entrada em favor.json" % bn.god)
	for god in cfg.gods:
		var r := String(cfg.gods[god].get("rival", ""))
		if r != "" and String(cfg.gods.get(r, {}).get("rival", "")) != String(god):
			out.append("rivalidade de %s não é recíproca" % god)
	# sem bênção, sem favor
	if not Favor.mods([]).is_empty():
		out.append("sem bênçãos não deve haver bônus de Favor")
	# uma bênção: sem nível; duas do mesmo deus: nível 1
	var tu1 := _boon("tou_um_caminho")
	var tu2 := _boon("tou_um_estrela")
	if not Favor.mods([tu1]).is_empty():
		out.append("uma bênção não deve liberar nível de Favor")
	var two := Favor.mods([tu1, tu2])
	var want1: Dictionary = cfg.gods["Tou Um"].tiers[0]
	for k in want1:
		if absf(float(two.get(k, 0.0)) - float(want1[k])) > 0.0001:
			out.append("duas bênçãos de Tou Um deveriam dar %s %s no Favor" % [k, want1[k]])
	# rivalidade: uma bênção do rival tira 1 de Favor e derruba o nível
	var ly := _boon("lu_yueh_praga")
	if Favor.net([tu1, tu2, ly], "Tou Um") != 1:
		out.append("o rival deveria tirar 1 Favor (esperado 1, veio %d)" % Favor.net([tu1, tu2, ly], "Tou Um"))
	if Favor.net([tu1, tu2, ly], "Lu Yueh") != 0:
		out.append("Lu Yueh com 1 bênção contra 2 do rival deve ter Favor 0")
	var mixed := Favor.mods([tu1, tu2, ly])
	if mixed.has("speed_pct"):
		out.append("com o rival empatando, o nível 1 de Tou Um não deve valer")
	# sem rival: Favor só sobe
	var mk := _boon("mask_faca_sombra")
	var mk2 := _boon("mask_fechaduras")
	if Favor.net([mk, mk2], "Mask") != 2 or Favor.tier(2) != 1 or Favor.tier(3) != 2 or Favor.tier(1) != 0:
		out.append("limiares de Favor errados")
	# o herói aplica o Favor em recalc() e o rival nunca bloqueia a oferta
	var b := _bat()
	b.hero.boons.append(tu1)
	b.hero.recalc()
	var speed1: float = b.hero.m("speed_pct")
	b.hero.boons.append(tu2)
	b.hero.recalc()
	var expect_delta: float = float(tu2.mods.get("speed_pct", 0.0)) + float(want1.speed_pct)
	if absf(b.hero.m("speed_pct") - speed1 - expect_delta) > 0.0001:
		out.append("recalc deveria somar o bônus de Favor (delta %.3f, esperado %.3f)" % [b.hero.m("speed_pct") - speed1, expect_delta])
	b.hero.boons.append(ly)
	b._open_altar()
	var offered_ids: Array = b.offer.map(func(o): return String(o.get("id", "")))
	if b.offer.size() < 2:
		out.append("o altar deve continuar oferecendo bênçãos com rivais no herói")
	# o cartão da bênção do rival avisa o efeito
	var hint := Favor.offer_hint([tu1], _boon("lu_yueh_praga"))
	if hint == "":
		out.append("a oferta do rival deveria mostrar o efeito no Favor")
	if Favor.offer_hint([], _boon("mask_faca_sombra")) == "":
		out.append("a primeira bênção de um deus deveria mostrar Favor 0 → 1")
	if offered_ids.is_empty():
		out.append("oferta vazia")
	# HUD
	if Favor.hud_lines([tu1, tu2, ly]).is_empty():
		out.append("o HUD deveria listar o Favor")
	return out
