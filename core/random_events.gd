class_name RandomEvents
extends RefCounted
## SPEC-164 (MEC-005): seis eventos aleatórios genéricos (Pacto de Sangue, Relicário Lacrado, Peregrino Ferido,
## Contador de Histórias, Carroça Abandonada, Pedra do Eclipse). Números em data/random_events.json.
## As contas são estáticas e testadas; o Battle só chama `open` (monta a oferta) e `apply` (aplica a escolha).

const KINDS := ["pacto_sangue", "relicario", "peregrino", "contador", "carroca", "eclipse_pedra"]
const LEAVE := {"t": "shop_leave", "name": "Sair", "desc": "Nada te obriga a arriscar.", "price": 0}

static func is_kind(kind: String) -> bool:
	return KINDS.has(kind)

static func info(kind: String) -> Dictionary:
	return Data.table("random_events").get("events", {}).get(kind, {})

static func color(kind: String) -> Color:
	var c: Array = info(kind).get("color", [1.0, 1.0, 1.0])
	return Color(float(c[0]), float(c[1]), float(c[2]))

static func label(kind: String) -> String:
	return "%s [E/oeste]" % String(info(kind).get("label", kind))

static func title(kind: String) -> String:
	return "%s — escolha ou saia" % String(info(kind).get("name", kind))

static func intro(kind: String) -> String:
	return String(info(kind).get("intro", ""))

## Linha de escolha: sempre `t = ev_choice`, com o evento e a opção para o `apply`.
static func _row(kind: String, opt: String, name: String, desc: String, price := 0, locked := false, extra := {}) -> Dictionary:
	var row := {"t": "ev_choice", "ev": kind, "opt": opt, "name": name, "desc": desc, "price": price, "locked": locked,
		"brief": desc.replace("\n", " · ")}   # o cartão mostra custo e ganho; o detalhe repete as linhas
	row.merge(extra, true)
	return row

static func _info_row(name: String, desc: String) -> Dictionary:
	return {"t": "shop_info", "name": name, "desc": desc, "price": 0, "locked": true}

## ---------------------------------------------------------------- contas puras

## Quanto o Pacto ainda pode tirar da vida máxima: 45% do que o herói teria sem pactos.
static func blood_room(max_hp: float, lost: float, cfg: Dictionary) -> float:
	var base := max_hp + lost
	return maxf(0.0, float(cfg.get("max_loss_pct", 0.45)) * base - lost)

## PV que um selo cobra (arredondado, nunca zera a vida máxima: piso `min_max_hp`).
static func pact_cost(max_hp: float, hp_pct: float) -> int:
	return maxi(1, int(round(max_hp * hp_pct)))

## Pode-se pagar o selo? (cabe no teto de 45% e a vida máxima não cai do piso)
static func pact_allowed(max_hp: float, lost: float, hp_pct: float, cfg: Dictionary) -> bool:
	var cost := float(pact_cost(max_hp, hp_pct))
	return cost <= blood_room(max_hp, lost, cfg) + 0.001 and max_hp - cost >= float(cfg.get("min_max_hp", 20))

## Custo em sangue do Relicário (25% da vida atual) e se está disponível (vida atual ≥ 40% da máxima).
static func relic_blood_cost(hp: float, cfg: Dictionary) -> float:
	return hp * float(cfg.get("blood_hp_pct", 0.25))

static func relic_blood_allowed(hp: float, max_hp: float, cfg: Dictionary) -> bool:
	return hp >= max_hp * float(cfg.get("blood_min_hp_pct", 0.40))

## Sorteio da Carroça: verdadeiro = emboscada.
static func carroca_is_ambush(roll: float, cfg: Dictionary) -> bool:
	return roll >= float(cfg.get("loot_chance", 0.60))

## Multiplicadores do Eclipse para um inimigo (chefes ficam de fora). `key`: enemy_speed, enemy_dmg, xp, gold.
static func world_mult(world_mod: Dictionary, key: String, is_boss: bool) -> float:
	if world_mod.is_empty() or is_boss:
		return 1.0
	return float(world_mod.get(key, 1.0))

## ---------------------------------------------------------------- oferta

static func open(b: Battle, kind: String) -> Array:
	var cfg := info(kind)
	var rows: Array = []
	match kind:
		"pacto_sangue":
			for o in cfg.options:
				var cost := pact_cost(b.hero.max_hp, float(o.hp_pct))
				var ok := pact_allowed(b.hero.max_hp, b.event_blood_lost, float(o.hp_pct), cfg)
				var desc := "Perde %d PV de vida máxima (%d%%) até o fim da run\nGanha +%d%% de dano até o fim da run" % [cost, int(round(float(o.hp_pct) * 100.0)), int(round(float(o.dmg_pct) * 100.0))]
				if not ok:
					desc = "O selo recusa quem já deu demais.\n" + desc
				rows.append(_row(kind, String(o.id), String(o.name), desc, 0, not ok))
		"relicario":
			var blood := int(round(relic_blood_cost(b.hero.hp, cfg)))
			var blood_ok := relic_blood_allowed(b.hero.hp, b.hero.max_hp, cfg)
			rows.append(_row(kind, "sangue", "Abrir com sangue", "Custa %d PV (25%% da vida atual)%s\nDá 1 equipamento raro ou melhor" % [blood, "" if blood_ok else "; vida abaixo de 40%: indisponível"], 0, not blood_ok))
			var price := int(round(float(cfg.gold_cost) * float(b.stage.coin_mult)))
			rows.append(_row(kind, "ouro", "Arrombar com ouro", "Custa %d moedas\nDá 1 equipamento mágico ou melhor" % price, price, b.hero.gold < price))
		"peregrino":
			var help_price := int(round(float(b.hero.gold) * float(cfg.help_gold_pct)))
			rows.append(_row(kind, "ajudar", "Ajudar", "Custa %d moedas (30%%)\nGratidão do Peregrino: +8%% de XP e +0,6 de coleta por %d s, e um bom pedaço de XP" % [help_price, int(cfg.help_buff_seconds)], help_price, false))
			rows.append(_row(kind, "conversar", "Conversar", "Não custa nada\nUma lição do lugar: um pouco de XP", 0, false))
			rows.append(_row(kind, "roubar", "Roubar", "Ganha %d moedas\nMas %d inimigos o cercam (vingança)" % [int(round(float(cfg.steal_gold) * float(b.stage.coin_mult))), int(cfg.steal_ambush)], 0, false))
		"contador":
			var pool: Array = cfg.stories.duplicate()
			var picked: Array = []
			for _i in mini(int(cfg.show), pool.size()):
				var idx := b.rng.randi() % pool.size()
				picked.append(pool[idx])
				pool.remove_at(idx)
			for s in picked:
				rows.append(_row(kind, String(s.id), String(s.name), "%s até o fim da run" % Items.mods_text(s.mods), 0, false, {"mods": s.mods}))
		"carroca":
			rows.append(_row(kind, "vasculhar", "Vasculhar", "60%% de achar algo (um equipamento raro ou %d moedas)\n40%% de ser uma emboscada: %d inimigos e 1 elite" % [int(round(float(cfg.loot_gold) * float(b.stage.coin_mult))), int(cfg.ambush_enemies)], 0, false))
		"eclipse_pedra":
			for o in cfg.options:
				rows.append(_row(kind, String(o.id), String(o.name),
					"Por %d s: inimigos %s%d%% de velocidade e de dano\nXP e moedas ×%s (o chefe não é afetado)" % [int(cfg.seconds), "+" if float(o.enemy_speed) >= 1.0 else "−", absi(int(round((float(o.enemy_speed) - 1.0) * 100.0))), str(snappedf(float(o.xp), 0.1)).replace(".", ",")], 0, not b.world_mod.is_empty()))
	rows.append(LEAVE.duplicate())
	return rows

## ---------------------------------------------------------------- efeitos

static func apply(b: Battle, row: Dictionary) -> void:
	var kind := String(row.get("ev", ""))
	var opt := String(row.get("opt", ""))
	var cfg := info(kind)
	match kind:
		"pacto_sangue":
			for o in cfg.options:
				if String(o.id) == opt:
					_apply_pact(b, o, cfg)
		"relicario":
			if opt == "sangue":
				if relic_blood_allowed(b.hero.hp, b.hero.max_hp, cfg):
					b.hero.hp = maxf(1.0, b.hero.hp - relic_blood_cost(b.hero.hp, cfg))
					b.give_item(Items.roll(b.rng, b.tier(), b.hero.m("carisma") + b.hero.attr_mod("carisma"), String(cfg.blood_rarity)), true)
			else:
				var price := int(row.get("price", 0))
				if b.hero.gold >= price:
					b.hero.gold -= price
					b.give_item(Items.roll(b.rng, b.tier(), b.hero.m("carisma") + b.hero.attr_mod("carisma"), String(cfg.gold_rarity)), true)
		"peregrino":
			_apply_peregrino(b, opt, row, cfg)
		"contador":
			Hero.add_mods(b.hero.run_mods, row.get("mods", {}))
			b.hero.recalc()
			b.events.append({"type": "toast", "text": "Você leva a história %s." % String(row.name).to_lower()})
		"carroca":
			_apply_carroca(b, cfg)
		"eclipse_pedra":
			for o in cfg.options:
				if String(o.id) == opt and b.world_mod.is_empty():
					b.world_mod = {"id": String(o.id), "name": String(o.name), "enemy_speed": float(o.enemy_speed), "enemy_dmg": float(o.enemy_dmg),
						"xp": float(o.xp), "gold": float(o.gold), "t": float(cfg.seconds)}
					b.events.append({"type": "toast", "text": "%s: o céu se fecha por %d s." % [String(o.name), int(cfg.seconds)]})

static func _apply_pact(b: Battle, o: Dictionary, cfg: Dictionary) -> void:
	if not pact_allowed(b.hero.max_hp, b.event_blood_lost, float(o.hp_pct), cfg):
		return
	var cost := float(pact_cost(b.hero.max_hp, float(o.hp_pct)))
	var old_max := b.hero.max_hp
	b.event_blood_lost += cost
	Hero.add_mods(b.hero.run_mods, {"hp": -cost, "dmg_pct": float(o.dmg_pct)})
	b.hero.recalc()
	b.hero.hp = clampf(b.hero.hp * b.hero.max_hp / maxf(1.0, old_max), 1.0, b.hero.max_hp)   # a vida atual cai na mesma proporção; nunca mata
	b.events.append({"type": "toast", "text": "%s selado: -%d PV máximos, +%d%% de dano." % [String(o.name), int(cost), int(round(float(o.dmg_pct) * 100.0))]})

static func _apply_peregrino(b: Battle, opt: String, row: Dictionary, cfg: Dictionary) -> void:
	match opt:
		"ajudar":
			var price := int(row.get("price", 0))
			if b.hero.gold >= price:
				b.hero.gold -= price
				b.hero.set_kind_buff("gratidao_peregrino", cfg.help_buff, float(cfg.help_buff_seconds))
				b._add_xp(b.hero.xp_need * float(cfg.help_xp_pct))
				b.events.append({"type": "toast", "text": "O peregrino agradece: Gratidão do Peregrino por %d s." % int(cfg.help_buff_seconds)})
		"conversar":
			b._add_xp(b.hero.xp_need * float(cfg.talk_xp_pct))
			var story: Dictionary = Data.table("stage_story").get(b.stage_id, {})
			b.events.append({"type": "toast", "text": String(story.get("epigrafe", "O peregrino conta o que viu por estas terras."))})
		"roubar":
			b._add_gold(float(cfg.steal_gold) * float(b.stage.coin_mult), "evento", false, false)
			b.spawn_ambush(int(cfg.steal_ambush), 3.0)
			b.events.append({"type": "toast", "text": "O peregrino não estava sozinho..."})

static func _apply_carroca(b: Battle, cfg: Dictionary) -> void:
	if carroca_is_ambush(b.rng.randf(), cfg):
		b.spawn_ambush(int(cfg.ambush_enemies), float(cfg.ambush_radius), true)
		b.events.append({"type": "toast", "text": "Era uma emboscada!"})
	elif b.rng.randf() < 0.5:
		b.give_item(Items.roll(b.rng, b.tier(), b.hero.m("carisma") + b.hero.attr_mod("carisma"), String(cfg.loot_rarity)), true)
	else:
		var gold := float(cfg.loot_gold) * float(b.stage.coin_mult)
		b._add_gold(gold, "evento", false, false)
		b.events.append({"type": "toast", "text": "Entre os caixotes: +%d moedas." % int(gold), "color": Color(1.0, 0.85, 0.3)})
