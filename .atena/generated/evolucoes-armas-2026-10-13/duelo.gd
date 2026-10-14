extends SceneTree
## Duelo base nv5 x evolução (SPEC-174, PLAN-101 S-009): dano causado em 45 s de jogo, no motor, por herói pretendido.
##   godot --headless --path . -s .atena/generated/evolucoes-armas-2026-10-13/duelo.gd
## Cenários: "alvo" = 1 boneco de 1e6 PV a 3 unidades; "horda" = 30 bonecos de 1e6 PV num raio de 2 a 7. Herói parado e imortal,
## sem ondas. 6 sementes por linha. Saída: DUELO;heroi;arma;nivel;cenario;dano_medio_por_s. Alarme, não veredito de equilíbrio.
const CASES := [
	{"hero": "nyrelia", "base": "dominar_pessoa", "evo": "dominio_coletivo"},
	{"hero": "durvall", "base": "golpe_esmagador", "evo": "maca_demolidora"},
	{"hero": "bromnor", "base": "martelo_da_gloria", "evo": "martelo_da_luz"},
	{"hero": "sylas", "base": "raio_enfraquecedor", "evo": "raio_da_ruina"},
	{"hero": "leoric", "base": "sopro_de_estrela", "evo": "constelacao_de_silva"},
]
## Referência (REF=1 na linha de comando): evoluções que já existem, só nível 1 da evolução, para comparar a escala absoluta.
const REFS := [
	{"hero": "durvall", "evo": "espada_do_receptaculo"}, {"hero": "durvall", "evo": "esmagar_defesas"}, {"hero": "durvall", "evo": "golpe_do_juizo"},
	{"hero": "durvall", "evo": "rajada_infinita"}, {"hero": "maelor", "evo": "luz_mais_pura"}, {"hero": "kayron", "evo": "chuva_de_estrelas"},
	{"hero": "kayron", "evo": "tormenta_de_fogo"}, {"hero": "brook", "evo": "julgamento_da_gloria"}, {"hero": "sylas", "evo": "tempestade"}, {"hero": "sylas", "evo": "inferno_de_cera"},
]
const SECONDS := 45.0
const DT := 0.05
const SEEDS := 6

func _run(hero: String, weapon_id: String, level: int, crowd: bool, seed_value: int) -> float:
	var b := Battle.new(seed_value, hero, "dagruve")
	b.stage.waves = []
	b.stage.elites = []
	b.stage.duration = 99999
	b._inter_t = 99999.0
	b._breakable_t = 99999.0
	b.hero.pos = Vector2(30, 30)
	b.hero.max_hp = 1.0e9
	b.hero.hp = 1.0e9
	b.hero.weapons = [Weapon.make(weapon_id, level)]
	var dummies: Array = []
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value * 977
	var n := 30 if crowd else 1
	for i in n:
		var ang := rng.randf() * TAU
		var r := rng.randf_range(2.0, 7.0) if crowd else 3.0
		var e := Enemy.make("zumbi", b.hero.pos + Vector2(cos(ang), sin(ang)) * r, 0.0, 1.0, 0)
		e.max_hp = 1.0e6
		e.hp = 1.0e6
		b.enemies.append(e)
		dummies.append(e)
	var t := 0.0
	while t < SECONDS:
		b.step(Vector2.ZERO, DT)
		b.events.clear()
		t += DT
	var dealt := 0.0
	for e in dummies:
		dealt += float(e.max_hp) - float(e.hp)
	return dealt / SECONDS

func _init() -> void:
	if OS.get_cmdline_user_args().has("REF"):
		for c in REFS:
			for scen in ["alvo", "horda"]:
				var sum := 0.0
				for s in SEEDS:
					sum += _run(String(c.hero), String(c.evo), 1, scen == "horda", s + 1)
				print("REF;%s;%s;%s;%.1f" % [c.hero, c.evo, scen, sum / SEEDS])
		quit()
		return
	for c in CASES:
		for scen in ["alvo", "horda"]:
			var rows := []
			for pair in [[c.base, 5], [c.evo, 1]]:
				var sum := 0.0
				for s in SEEDS:
					sum += _run(String(c.hero), String(pair[0]), int(pair[1]), scen == "horda", s + 1)
				rows.append(sum / SEEDS)
				print("DUELO;%s;%s;%d;%s;%.1f" % [c.hero, pair[0], int(pair[1]), scen, sum / SEEDS])
			print("RAZAO;%s;%s;%s;%.2fx" % [c.hero, c.evo, scen, float(rows[1]) / maxf(0.001, float(rows[0]))])
	quit()
