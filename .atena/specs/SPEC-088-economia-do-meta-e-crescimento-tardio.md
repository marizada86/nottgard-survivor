# SPEC-088 — Mais o que comprar e crescimento tardio (MEC-014 e MEC-015)

Status: **implementada (2026-09-29); números a validar em playtest.**

Origens: T01 (comprou a loja inteira com ~30 000 moedas), T02 (+23 354 moedas; "falta aumento de status, HP
máximo"; "upgrades mais caros") e a queixa de que a progressão estagna de Shendilavri em diante
([[EVID-106-playtest-publico-t01-higor-2026-09-29]], [[EVID-107-playtest-publico-t02-hiago-2026-09-29]]).
Decisão do dono (2026-09-29): **mais coisas para comprar**, com custo crescente e status como HP máximo.

## MEC-015 — Meta (`data/upgrades.json`)

- **Força Bruta** e **Vitalidade** passam de 5 para **10 níveis** (custos 3 200, 6 400, 10 000, 15 000, 20 000 e
  2 560, 5 120, 10 000, 15 000, 20 000 nos novos).
- **Cinco aprimoramentos novos:** Corpo de Ferro (+1 CON), Mente Aguçada (+1 INT), Braço Forte (+1 FOR),
  Presença (+1 CAR), cada um em 3 níveis (1 500, 4 500, 13 500); Sangue Vivo (+0,3 PV/s, 1 200, 3 600, 10 800).
- Custo total dos novos: cerca de **170 mil moedas**, contra ~30 mil de sobra nas runs relatadas.

## MEC-014 — PV por nível na fase tardia

A partir do **nível 15**, cada nível dá **+1 PV máximo** (`level_growth` em `data/difficulty.json`,
`Hero.level_growth_hp`). No nível 55 são +41 PV. O nível recalcula os atributos ao subir.

## Testes

`tests/test_battle.gd`: 10 PV a mais entre os níveis 14 e 24; custos crescentes; novos aprimoramentos presentes.

## Limites

- Sem medição do bot: os números do meta e de PV por nível são ponto de partida.
- Não cria mais sumidouros dentro da run além da Mesa de Aposta (SPEC-087).
- Segunda Chance e Bolso Fundo seguem em nível único.
