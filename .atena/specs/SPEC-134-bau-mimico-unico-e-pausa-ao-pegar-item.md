---
id: SPEC-134
title: Baú vira Mímico uma vez só; item de baú com slot vazio pausa e mostra o item
status: implemented-pending-playtest (aprovada por plano pelo dono em 2026-10-06)
origin: relato do Manzi (playtest), 2026-10-06
cards: BUG-030, BUG-031
risk: baixo (baús e painel de item; sem número de combate novo)
plan: PLAN-067 (por plano; side-plan, não é o active_plan)
---

# SPEC-134

## Pedido (Manzi)
1. O baú virou Mímico, virou baú, virou Mímico, 3 vezes seguidas. Um baú só deveria virar Mímico uma vez; ao morrer, o Mímico deixa um baú de verdade.
2. Ao pegar um item de baú ele é equipado sem aviso. O jogo deveria pausar e mostrar o item, para o jogador entender o que aconteceu.

## Decisões do dono (2026-10-06)
| # | Decisão |
|---|---|
| D1 | Aprovação por plano. |
| D2 | O painel de item cobre **só baús** (baú comum e baú do chefe). Destrutível, loja e demais origens seguem equipando direto. |

## Causa (lida no código)
- **BUG-030:** o Mímico nasce com `drops_chest = true`; ao morrer, `Battle._kill` larga um baú comum, que rola `0,10 + tier × 0,01` de virar Mímico de novo. O campo `safe` já existia em `_open_chest`, mas nada o ligava.
- **BUG-031:** `Battle.give_item` com o slot vazio equipava direto e só emitia toast; só o slot ocupado abria o painel (`item_offer`).

## Mudança
- `core/battle.gd` `_kill`: o baú largado por `mimico` recebe `safe = true`.
- `core/battle.gd` `give_item(item, announce := false)`: com `announce` e slot vazio, abre `item_offer` com **uma** opção (`Equipar X [raridade]`, ícone, atributos, badge) e só equipa ao confirmar. `_open_chest` e `_open_boss_chest` passam `announce = true`.
- `core/battle.gd` `_resolve_item_choice`: `sell` vazio = só equipa (nada é vendido).
- `ui/hud.gd`: título "Item encontrado no baú — equipar" quando a oferta tem uma opção.

## Aceite
- A1: um baú só vira Mímico uma vez; o baú que o Mímico larga nunca vira Mímico.
- A2: baú com slot vazio pausa (`state == item_offer`), não equipa antes da confirmação, retoma o jogo e equipa ao confirmar, sem vender nada.
- A3: `give_item` sem `announce` (loja, destrutível) equipa direto.
- A4: suíte de testes sem falhas; bot conclui a run sem travar no painel.

## Efeito colateral aceito
O baú do chefe nasce junto do herói e abre sozinho; agora ele pausa o jogo (e, portanto, a Maré pós-chefe) enquanto o painel está aberto. O teste da Maré passou a limpar as interações.
