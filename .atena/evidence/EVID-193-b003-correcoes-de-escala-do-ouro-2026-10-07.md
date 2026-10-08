---
id: EVID-193
title: Correções de escala do ouro (PLAN-075 B-003)
date: 2026-10-07
spec: SPEC-142
plan: PLAN-075
cards: [BAL-023, BAL-003]
---

# EVID-193 — B-003, correções de escala

Antes dos ajustes: cópias em `.atena/generated/gold-economy/v01/battle-before-b003.gd` e `difficulty-before-b003.json`. Parâmetros novos em `data/difficulty.json`, bloco `gold`. **Nada foi commitado.**

## O que mudou (uma alavanca por vez, todas ligadas por parâmetro)

| Passo | Alavanca | Antes → depois | Parâmetro |
|---|---|---|---|
| S-006 | Bônus de moedas por abate (`gold_pct`) | `round(coin_mult × (1+gold_pct))` mínimo 1, mais 0,05 de chance por ponto → `coin_mult × (1+gold_pct)` **sem arredondar**, resto fracionário acumulado entre abates (esperado exato, sem tocar a RNG); chance fixa 22 % | — |
| S-007 | Venda de peça | 8–32 fixo e entrava no Quartel → **× `coin_mult` da fase** (igual à loja, valores nas ofertas também) e **só vale na run** (`stats.gold_extra`) | `run_only_sell` |
| S-008a | Ouro das fases no Quartel | entrava bruto (× `coin_mult` até 5) → entra como **valor-base**: `ouro / coin_mult^expoente`; compras e preços da run seguem escalados | `meta_coin_exponent` = 1,0 |
| S-008b | Chicote Avarento (`gold_hit`) | +1 por acerto, sem teto → **no máximo 0,15 moeda/s** (valor-base; paga × `coin_mult` na run) | `gold_hit_per_second` |
| S-008c | Multiplicador de recompensa (descida × Marcas) | sem teto (até ×4,75 no depth 3 com Marcas máx.) → **teto 3,0** | `reward_cap` |
| — | Bolsa de Moedas (oferta de nível, 40) | continua fixa e entra inteira no Quartel | — |

Não alterados: custos de `data/upgrades.json` (B-004), bônus de chefe 60×(1+tier), valores de loja/ferreiro/curandeiro, Mesa de Aposta, `reward_per_point` das Marcas.

## Medição (mesmas 50 runs por perfil, sementes iguais, sem Marcas)

| Ganho médio no Quartel por run | Antes | Depois |
|---|---|---|
| Veterano | 372 | **169** (−55 %) |
| Novato | 193 | **93** (−52 %) |

Ouro médio por fase (veterano, valor-base já aplicado): Dagruve 86→78 · Docas 208→118 · Shedaklah 372→196 · Molor 1 384→505 · Durão 672→182 (n pequeno depois de Shedaklah). Chicote: 20–63 % da fase → **0–4 %**. Dados: `.atena/generated/gold-economy/v01/after-b003/`.

## Metas (EVID-191)

| Meta | Resultado | Situação |
|---|---|---|
| M1 vitória até Feng-tu 9 000–13 000 | **não medido** (bot não vence). Projeção: corte de ~50 % sobre ~23 000 do T02 ⇒ ~11–12 000 | provável, a calibrar com `gold_src` do 1º playtest |
| M2 run morta na fase 2 = 100–300 | estimativa do bot ≈ 100–120 | **no limite inferior** |
| M3 Marcas máx. + descida 3 ≤ 3× | teto 3,0 por construção; teste de unidade | **ok** |
| M4 nenhuma fonte > 40 % | Chicote, evento, oferta ≤ 4 %; mas **abate = 37–64 %** por ser a fonte natural | **ok na intenção, não na letra** (ver abaixo) |
| M5 `gold_pct` +10 % ⇒ +8–12 % | teste de unidade: +10,0 % em Dagruve e Docas | **ok** |
| M6 1ª compra em ≤ 2 runs | média 169/run; mediana 21 (bot morre cedo) | **provável**; humano joga melhor que o bot |

**M4:** como escrito, o abate fica acima de 40 % em quase todas as fases, porque é a fonte principal por desenho. Interpreto a meta como "nenhuma fonte *de build ou exploração* passa de 40 %". Se você quiser a letra, preciso de outro desenho (mais quebráveis/chefe/elite). Confirmar.

## Testes e smoke
- `tests/test_battle.gd`: `gold_pct` proporcional em Dagruve e Docas; valor-base no Quartel; venda só na run e escalada; teto do Chicote; teto 3,0 do multiplicador. `tests/test_run_record.gd`: `raw_gold` e `gold_src` no registro. **Suíte inteira: 0 falhas.**
- Smoke das nove fases (`tools/smoke.tscn`): ok.

## Limites
- Bot sem vitória, baú, evento nem loja: M1 e M6 são projeção.
- Perfis e moedas já guardadas não foram tocados; só ganhos futuros mudam.
- O servidor de playtest ainda precisa aceitar `gold_src`/`gold_extra` dentro de `result`.
- Reverter: `meta_coin_exponent` 0, `run_only_sell` false, `gold_hit_per_second` 0, `reward_cap` 99 (a fórmula do `gold_pct` e a venda escalada exigem reverter o código; cópia em `battle-before-b003.gd`).
