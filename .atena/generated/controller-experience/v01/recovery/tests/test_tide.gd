extends RefCounted
## SPEC-116 D4: Maré do Abismo (sequência de abates).

func _bat() -> Battle:
	var b := Battle.new(7, "durvall", "dagruve")
	b.stage.waves = []
	b.stage.elites = []
	b.stage.duration = 99999
	b._inter_t = 99999.0
	b._breakable_t = 99999.0
	return b

func _streak_events(b: Battle) -> Array:
	return b.events.filter(func(e): return e.type == "streak")

func run() -> Array:
	var out: Array = []
	var b := _bat()
	for i in 9:
		b._tide_kill()
	if not _streak_events(b).is_empty():
		out.append("nenhum marco antes de 10 abates")
	b._tide_kill()
	var marks := _streak_events(b)
	if marks.size() != 1 or int(marks[0].count) != 10:
		out.append("o 10º abate deveria disparar o primeiro marco")
	if not is_equal_approx(b.tide_xp_bonus(), 0.02):
		out.append("um marco ativo deveria dar +2%% de XP (deu %f)" % b.tide_xp_bonus())
	# a janela de 3 s sem matar reinicia a sequência
	b.time += Battle.TIDE_WINDOW + 0.5
	b._tide_kill()
	if b.tide_kills != 1:
		out.append("a sequência deveria reiniciar após a janela (há %d)" % b.tide_kills)
	# o bônus expira após 5 s
	b.time += Battle.TIDE_BUFF_SECONDS + 0.1
	if b.tide_xp_bonus() != 0.0:
		out.append("o bônus deveria expirar após %d s" % int(Battle.TIDE_BUFF_SECONDS))
	# teto de +10% mesmo com todos os marcos ativos ao mesmo tempo
	var c := _bat()
	for i in 200:
		c._tide_kill()
		c.time += 0.05
	if _streak_events(c).size() != 5:
		out.append("200 abates seguidos deveriam disparar 5 marcos (%d)" % _streak_events(c).size())
	if c.tide_xp_bonus() > Battle.TIDE_BUFF_CAP + 0.0001:
		out.append("o bônus de XP não pode passar de +10%%")
	# conquistas de sequência sem dano: o contador zera ao receber dano e guarda o melhor valor da run
	var d := _bat()
	for i in 30:
		d._tide_kill()
		d.stats.clean_kills += 1
		d.stats.clean_streak_best = maxi(int(d.stats.clean_streak_best), int(d.stats.clean_kills))
	d._hurt_hero(5.0, "teste", true)
	if int(d.stats.clean_kills) != 0:
		out.append("receber dano deveria zerar a sequência sem dano")
	if int(d.stats.clean_streak_best) != 30:
		out.append("a melhor sequência sem dano deveria ser guardada")
	var profile := Profile.new()
	if profile.stat_value("run_clean_streak", {"clean_streak": 80}) != 80.0:
		out.append("run_clean_streak deveria ler o melhor da run")
	var ids := ["intocado", "sombra_sem_marca", "mare_sem_rastro"]
	var found := 0
	for a in Data.table("achievements").achievements:
		if ids.has(a.id) and a.stat == "run_clean_streak":
			found += 1
	if found != 3:
		out.append("faltam conquistas de sequência sem dano (%d/3)" % found)
	return out
