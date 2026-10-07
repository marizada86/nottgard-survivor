extends RefCounted
## SPEC-126 (MEC-046): o altar de bênção permite recusar todas as opções.

func _bat(seed_value := 1) -> Battle:
	var b := Battle.new(seed_value, "durvall", "dagruve")
	b.hero.pos = Vector2(20, 20)
	b.stage.waves = []
	b.stage.elites = []
	b.stage.duration = 99999
	b._inter_t = 99999.0
	b._breakable_t = 99999.0
	return b

func run() -> Array:
	var out: Array = []
	var b := _bat(5)
	b._open_altar()
	if b.state != "altar" or b.offer.size() < 2:
		out.append("altar deveria abrir com bênçãos e a recusa (estado %s, %d ofertas)" % [b.state, b.offer.size()])
		return out
	var last: Dictionary = b.offer[b.offer.size() - 1]
	if String(last.t) != "boon_skip":
		out.append("a recusa deveria ser a última oferta, veio %s" % last.t)
	if b.offer.filter(func(o): return String(o.t) == "boon_skip").size() != 1:
		out.append("deveria haver exatamente uma recusa")
	var before: int = b.hero.boons.size()
	b.choose(b.offer.size() - 1)
	if b.state != "running" or not b.offer.is_empty():
		out.append("recusar deveria voltar a running e limpar a oferta (estado %s)" % b.state)
	if b.hero.boons.size() != before:
		out.append("recusar não deve alterar as bênçãos do herói")
	if int(b.stats.boons_declined) != 1:
		out.append("boons_declined deveria ser 1, veio %s" % b.stats.boons_declined)
	# escolher uma bênção continua igual
	var c := _bat(6)
	c._open_altar()
	c.choose(0)
	if c.state != "running" or c.hero.boons.size() != 1 or int(c.stats.boons_declined) != 0:
		out.append("escolher a bênção 0 deveria adicionar 1 bênção e não contar recusa")
	# a doação já gastou o item: sem recusa
	var d := _bat(7)
	d._open_altar(false)
	if d.offer.any(func(o): return String(o.t) == "boon_skip"):
		out.append("o altar da doação não deve oferecer recusa")
	return out
