# SPEC-090 — IA de cerco: perseguidores que flanqueiam (MEC-011)

Status: **implementada (2026-09-29); validação em playtest.**

Origem: T01 S2-N5 (inimigos "travam" e deveriam "circular, flanquear, cercar"), em
[[EVID-106-playtest-publico-t01-higor-2026-09-29]]. O travamento em objetos é o BUG-012 (já corrigido, SPEC de
[[PLAN-038-atualizacao-pos-playtests-t01-t02-t03-2026-09-29]]); esta spec cobre só o comportamento de perseguição.

## Regra

Cerca de **60%** dos perseguidores comuns (`move = chase`, não chefes, com velocidade) recebem um **lado**
(esquerda ou direita) ao surgir. Longe do herói eles **abrem um arco** de até **1,0 rad (~57°)** em relação à
linha reta; o arco **fecha** ao chegar a 2,5 tiles, então terminam de frente para o herói. Os 40% restantes vão
direto. O resultado é um grupo que chega **de vários lados** em vez de uma fila. Ranged (`keep`), chefes e
inimigos parados não mudam.

- Sorteio **sem consumir o RNG** da run (`serial × 37 % 100`), para não alterar sementes e testes.
- Dados em `data/difficulty.json` (`flank`: `share`, `max_arc`, `open_distance`, `close_distance`); `share: 0` desliga.
- `Battle._flank_side_for`, `Battle._chase_dir`; campo `Enemy.flank_side`.

## Medição com o bot (Brook, Bromnor, Kayron, Durvall; 6 sementes cada)

| Configuração | Nível médio | Runs que chegam a Docas |
|---|---:|---:|
| Sem flanqueio (`share 0`) | 7,2 | 1 de 24 |
| **Com flanqueio (esta spec)** | 9,2 | 2 de 24 |

Sem piora; a diferença é ruído do bot (muito variável). Não há como o bot medir a "sensação" de cerco.

## Testes

`tests/test_battle.gd`: flanqueadores dos dois lados e perseguidores diretos; o direto não sai da reta; o
flanqueador curva e ainda chega ao herói.

## Limites

- Não é IA de grupo: ninguém coordena o cerco nem toma posição "em pinça".
- Não altera velocidade, dano nem número de inimigos.
