---
id: "SPEC-075"
title: "Sinergias combinadas: arma + acessório + magia no nível máximo"
status: "executada — suíte e smoke verdes; checagem manual interativa do dono pendente"
created: "2026-09-28"
relations:
  - "[[PLAN-035-sinergias-combinadas-arma-acessorio-magia-2026-09-28]]"
  - "[[PLAN-030-backlog-hiago-itens-equipamento-e-economia-2026-09-27]]"
  - "[[SPEC-073-nivel-de-equipamento-e-super-upgrade]]"
---

# SPEC-075 — Sinergias combinadas: arma + acessório + magia no nível máximo

## Origem

Item 7 do backlog original de Hiago (Fase C,
[[PLAN-030-backlog-hiago-itens-equipamento-e-economia-2026-09-27]]): "Combinar
armas, acessórios e magias com sinergia, no nível máximo, para escalar poder
em runs mais longas/descidas mais profundas." Alinhado com o dono em
[[PLAN-035-sinergias-combinadas-arma-acessorio-magia-2026-09-28]]: "magia" =
passiva de `passives.json`; a sinergia estende as 8 combinações arma+passiva
já existentes (não um sistema genérico); é um evento único escolhido na tela
de level-up (como a evolução de arma); o bônus concedido escala com
`descent_depth`, sem teto.

## Discovery

- Cada uma das 8 armas com `evolve` em `data/weapons.json` já define
  `{"passive": <id>, "into": <arma_evoluída>}`. Ao escolher evoluir
  (`core/battle.gd:1601-1608`, tipo `"evolve"`), o objeto `Weapon` no array
  `hero.weapons` é **substituído** — o `id` original (ex. `espada_sombria`)
  desaparece e passa a valer o `id` evoluído (ex.
  `espada_do_receptaculo`). A sinergia precisa ser identificada pelo id
  evoluído, não pelo original, porque é o único que sobrevive depois da
  escolha.
- Acessórios (armadura/amuleto/anel/arma-base de `data/items.json`) ficam em
  `hero.items[<slot>]`, com `base` (id da base) e `level` (1–3, SPEC-073).
  `Items.MAX_LEVEL == 3` é o nível máximo já usado pelo super-upgrade.
- O pool de ofertas de level-up é montado em `Battle._build_offer()`
  (`core/battle.gd:1466`). A entrada de evolução hoje é
  `{"t": "evolve", "id": w.id, "into": ..., "weight": 9.0, "role":
  "synergy"}` — mesmo padrão de dicionário que a nova oferta de sinergia vai
  seguir.
- `descent_depth` (`core/battle.gd:98`) incrementa em `enter_next_stage()`
  (`core/battle.gd:1447`) a cada portal, sem teto e sem regra especial por
  modo (decisão já fechada no PLAN-034). Hoje `enter_next_stage()` **não**
  chama `hero.recalc()` — precisa passar a chamar, para que o bônus de
  sinergia (que depende de `descent_depth`) seja reagregado a cada descida.

## Escopo

1. **Estrutura de dados**: cada entrada `evolve` de `data/weapons.json` que
   tiver sinergia ganha uma chave `"synergy"`:
   ```json
   "evolve": {"passive": "cota_de_malha", "into": "espada_do_receptaculo",
     "synergy": {"item_base": "cota", "name": "Muralha do Receptáculo",
       "bonus_per_depth": {"ca": 1}}}
   ```
   `item_base` é o id de uma base em `data/items.json` (qualquer um dos 4
   slots); `bonus_per_depth` são mods somados em `Hero.mods` multiplicados
   por `descent_depth` (mínimo 1, ou seja, o bônus já vale a partir da
   ativação, mesmo em `descent_depth == 0` — ver critério de aceite 3).
2. **8 combos propostos** (arma evoluída + acessório + passiva já exigida
   para evoluir):

   | Arma evoluída | Acessório (base) | Passiva (já exigida) | Sinergia proposta | Bônus por camada |
   |---|---|---|---|---|
   | `espada_do_receptaculo` | `cota` (Cota de Malha) | `cota_de_malha` | Muralha do Receptáculo | `{"ca": 1}` |
   | `rajada_infinita` | `anel_simples` (Anel) | `sorte_de_sendrinah` | Fúria Sem Fim | `{"cd_pct": 0.01}` |
   | `golpe_do_juizo` | `maca_de_guerra` (Maça de Guerra) | `forca` | Sentença Ampliada | `{"dmg_pct": 0.02}` |
   | `julgamento_da_gloria` | `cetro` (Cetro) | `carisma` | Círculo Crescente | `{"area_pct": 0.03}` |
   | `luz_mais_pura` | `amuleto_simples` (Amuleto) | `constituicao` | Luz Perene | `{"hp": 3}` |
   | `chuva_de_estrelas` | `cajado` (Cajado) | `inteligencia` | Manto Estelar | `{"cam": 1}` |
   | `inferno_de_cera` | `anel_de_prata` (Anel de Prata) | `alcance` | Cera Abissal | `{"dmg_pct": 0.02}` |
   | `tempestade` | `couro` (Couro) | `botas_leves` | Vendaval Constante | `{"speed_pct": 0.02}` |

   Nomes e valores de `bonus_per_depth` são estimativas de execução,
   revisáveis no próximo playtest (mesma ressalva já registrada na
   SPEC-073).
3. **Condição de oferta**: em `Battle._build_offer()`, para cada arma em
   `hero.weapons` cujo id evoluído tenha `synergy` definida e ainda não
   esteja em `hero.synergies`, oferecer `{"t": "synergy_activate", "id":
   <weapon_evoluido_id>, "name": "SINERGIA: <nome>", "desc": ..., "weight":
   9.0, "role": "synergy"}` **somente quando** `hero.items` tiver, no slot
   correto, um item com `base == item_base` e `level >= Items.MAX_LEVEL`.
   Não reabre nem duplica a oferta de evolução em si — é estritamente
   posterior a ela.
4. **Ativação**: novo tipo em `Battle.choose()`, `"synergy_activate"`, que
   marca `hero.synergies[c.id] = true` (dicionário novo em `Hero`, save-safe
   por padrão pois faz parte do estado da run, não do save persistente) e
   chama `hero.recalc()`.
5. **Agregação**: `Hero.recalc()` passa a somar, para cada id em
   `hero.synergies`, `bonus_per_depth * max(1, descent_depth)` da definição
   correspondente.
6. **`enter_next_stage()`** passa a chamar `hero.recalc()` depois de
   incrementar `descent_depth`, para que o bônus já ativo escale
   imediatamente ao descer, sem esperar o próximo level-up.
7. **Painel de itens (`C`)**: sinergias ativas aparecem listadas (nome +
   bônus atual calculado com o `descent_depth` da hora), reaproveitando o
   padrão visual já usado para nível de item (SPEC-073).

## Não objetivos

- Não altera as 8 combinações arma+passiva já existentes (evolução em si
  continua idêntica) — a sinergia é estritamente aditiva e posterior.
- Não adiciona itens, armas, passivas ou heróis novos — usa só bases já
  existentes em `data/items.json`/`data/weapons.json`/`data/passives.json`.
- Não nivela itens únicos (mesma exclusão já feita na SPEC-073) — sinergia
  exige um item de `bases`, não um único.
- Não implementa caso especial por modo de jogo (infinito vs. normal) —
  decisão já fechada no PLAN-034.
- Não persiste `hero.synergies` no save entre runs — é estado de run, como
  `hero.passives`/`hero.weapons`.

## Critérios de aceite

1. A oferta "SINERGIA: ..." só aparece quando a arma evoluída correspondente
   já está em `hero.weapons` **e** o acessório certo está equipado no nível
   máximo **e** a sinergia ainda não foi ativada nesta run.
2. Escolher a oferta marca a sinergia como ativa e não a oferece de novo.
3. Com a sinergia ativa, `Hero.mods` inclui o bônus da sinergia multiplicado
   por `max(1, descent_depth)` — ou seja, o bônus já vale author (mínimo 1x)
   mesmo antes da primeira descida, e dobra/triplica/etc. a cada portal.
4. Descer de fase (`enter_next_stage()`) reagrega `Hero.mods` imediatamente
   com o novo `descent_depth`, sem esperar o próximo level-up.
5. Perder o acessório (vender, trocar por outro na escolha de equipar/vender
   da SPEC-060) **não** desativa uma sinergia já ativada — ativação é
   permanente para a run, como a evolução de arma.
6. Itens únicos nunca satisfazem a condição de acessório (sem campo `base`).
7. Painel de itens (`C`) mostra as sinergias ativas e seu bônus atual.
8. Suíte e smoke continuam verdes; testes novos cobrem: oferta aparece só
   com as 3 condições simultâneas, ativação marca o estado e some da oferta,
   escala correta por `descent_depth` (incluindo o mínimo 1×), e
   persistência da sinergia após vender o acessório.

## Plano de voo proposto

1. Adicionar `"synergy"` às 8 entradas `evolve` de `data/weapons.json`
   conforme a tabela acima.
2. `core/hero.gd`: novo dicionário `synergies := {}`; `recalc()` soma
   `bonus_per_depth * max(1, descent_depth)` para cada sinergia ativa (Hero
   precisa ler `descent_depth` — hoje é campo de `Battle`, não de `Hero`;
   avaliar se `recalc()` recebe `descent_depth` como parâmetro ou se
   `Battle` chama um setter antes de recalcular).
3. `core/battle.gd`:
   - `_build_offer()`: nova entrada de oferta condicionada às 3 condições.
   - `choose()`: novo tipo `"synergy_activate"`.
   - `enter_next_stage()`: chamar `hero.recalc()` após incrementar
     `descent_depth`.
4. `ui/hud.gd`: listar sinergias ativas no painel de itens (`C`).
5. Testes automatizados cobrindo os 8 critérios de aceite; suíte e smoke;
   registrar evidência.

## Limites

- Execução só começa após aprovação explícita desta spec pelo dono.
- Nomes e valores de `bonus_per_depth` da tabela são estimativas, revisáveis
  no próximo playtest — mesma ressalva já aplicada aos valores da SPEC-073.

## Reconciliação

- O dono aprovou esta SPEC em 2026-09-28 ("aprovo como está e faremos
  ajustes conforme os playtests").
- Executada em 2026-09-28: os 8 combos, a oferta de ativação na tela de
  level-up, a escala por `descent_depth` e a listagem no painel de itens
  foram implementados como descrito. Um desvio técnico do exemplo de JSON da
  spec foi necessário — ver "Desvio da spec" em
  [[EVID-099-spec-075-sinergias-combinadas-2026-09-28]] — sem mudar contrato,
  combos ou critérios de aceite.
- `tests/run_all.gd`: `testes: 0 falha(s)` (bloco novo 10b cobrindo os 8
  critérios de aceite). Smoke (`tools/smoke.tscn`): `ok` nas 8 fases.
- Exceção: sem checagem manual interativa nesta sessão — ver EVID-099.
  Valores de `bonus_per_depth` seguem revisáveis pelos próximos playtests,
  como já previsto nos Limites.
