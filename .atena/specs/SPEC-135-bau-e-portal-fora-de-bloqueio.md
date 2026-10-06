---
id: SPEC-135
title: Baú, baú do chefe e portal nunca nascem dentro de bloqueio de cenário
status: implemented-pending-playtest (aprovada por plano pelo dono em 2026-10-06)
origin: relato do playtester Vitão, 2026-10-06 (print: baú e portal sobre um objeto, sem alcance)
cards: BUG-032
risk: baixo (posição de interativos; sem número de combate)
plan: PLAN-068 (por plano; side-plan, não é o active_plan)
---

# SPEC-135

## Pedido (Vitão)
Ao finalizar o mapa, o baú (do chefe) e o portal nasceram em cima de um objeto: impossível pegar o baú e passar de fase.

## Decisões do dono (2026-10-06)
| # | Decisão |
|---|---|
| D1 | Aprovação por plano. |
| D2 | Prioridade **P0** (trava o avanço da run). |
| D3 | Escopo global: a regra vale em `_add_interaction`, para todo interativo, exceto os fixos autorados. |

## Causa (lida no código)
`Battle._on_boss_dead` criava baús e portal em `e.pos + deslocamento` fixo. `_add_interaction` só limitava o ponto às bordas do mapa; não consultava `Hero.can_stand`, que conhece `hero.blockers` (cenário, preenchido por `ui/run.gd`) e o terreno bloqueado. Chefe morto perto/dentro de um bloqueio gerava interativo inalcançável. Mesmo defeito em recompensas de evento (`happenings.gd`) e interações aleatórias.

## Mudança
- `core/battle.gd` `_add_interaction(kind, at, snap = true)`: com `snap`, a posição passa por `_reachable_interaction_spot` (pedido, se o herói cabe; senão anéis de até 8 tiles ao redor do pedido, depois ao redor do herói; por fim o herói). Folga: 0,6 tile (0,9 para o portal).
- `_place_fixed_interactions` passa `snap = false` (posição autorada).

## Aceite
- A1: chefe morto dentro de bloqueios grandes cria baús, baú do chefe e portal em pontos onde o herói cabe.
- A2: ponto livre não é movido; interativo fixo mantém a posição.
- A3: suíte sem falhas; bot sem travar.

## Limite conhecido
O ponto livre mais próximo pode estar numa bolsa fechada por bloqueios (sem caminho até o herói). Não tratado; exigiria busca de alcance (BFS). Reabrir se o playtest mostrar.

## Adendo (2026-10-06, pedido do dono: "impedir que os interativos fiquem inalcançáveis")
Fecha o limite conhecido acima e o caso dos interativos fixos.
- `core/battle.gd` `_reach_grid()`: grade de 0,75 tile com bloqueios do cenário, terreno e bordas (mesmo critério de `Hero.can_stand` no centro da célula) e busca em largura a partir do herói; resultado em cache enquanto célula do herói, mapa e bloqueios não mudam.
- `_reachable_interaction_spot` só aceita ponto onde o herói cabe **e** que a grade marca como alcançável a pé (anéis de até 12 tiles).
- O parâmetro `snap` saiu: os interativos fixos (poço, oficina) também passam pela regra, porque os props do cenário são sorteados por zona e podem cair sobre a posição autorada.
- Custo medido: ~50 ms numa chamada fria em mapa 60×60 com 80 bloqueios (mapas reais têm 40 a 100); a morte do chefe cria 4 interativos e paga uma vez só.
- Limite que resta: passagens mais estreitas que ~0,75 tile contam como fechadas (conservador); só um ponto onde o herói já esteja preso numa bolsa não seria corrigido.
