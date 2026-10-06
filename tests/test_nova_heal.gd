extends RefCounted
## Revisão das curas: a Vela Sagrada (e o Julgamento da Glória) só curam quando ferem alguém.

func _bat() -> Battle:
	var b := Battle.new(2, "durvall", "dagruve")
	b.hero.pos = Vector2(30, 30)
	b.stage.waves = []
	b.stage.elites = []
	b.stage.duration = 99999
	b._inter_t = 99999.0
	b._breakable_t = 99999.0
	b.hero.weapons.append(Weapon.make("vela_sagrada"))
	return b

func _fire(b: Battle, w: Weapon) -> bool:
	return b._fire_nova(w.params(), 1.0)

func run() -> Array:
	var out: Array = []
	var b := _bat()
	var w: Weapon = b.hero.weapons[b.hero.weapons.size() - 1]
	b.hero.hp = b.hero.max_hp * 0.5
	var hp0: float = b.hero.hp
	if _fire(b, w):
		out.append("a Vela não deveria disparar sem inimigos no alcance")
	if b.hero.hp != hp0:
		out.append("a Vela não deve curar sem inimigos no alcance (PV %.1f -> %.1f)" % [hp0, b.hero.hp])
	var e := Enemy.make("zumbi", b.hero.pos + Vector2(1.0, 0.0), 0.0, 1.0, 0)
	b.enemies.append(e)
	if not _fire(b, w):
		out.append("a Vela deveria disparar com um inimigo no alcance")
	if b.hero.hp <= hp0:
		out.append("a Vela deveria curar ao ferir um inimigo (PV %.1f -> %.1f)" % [hp0, b.hero.hp])
	var healed: float = b.hero.hp - hp0
	if healed > float(w.params().get("heal", 0.0)) + 0.001:
		out.append("a cura da Vela é uma por disparo, não por alvo (curou %.1f)" % healed)
	return out
