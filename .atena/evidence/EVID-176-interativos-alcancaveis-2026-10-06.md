---
id: "EVID-176"
title: "BUG-032 (adendo): interativos sempre alcançáveis a pé"
created: "2026-10-06"
relations: ["[[SPEC-135-bau-e-portal-fora-de-bloqueio]]", "[[EVID-174-bau-e-portal-fora-de-bloqueio-2026-10-06]]"]
cards: ["BUG-032"]
---

# EVID-176

## Mudança
`core/battle.gd` (`_add_interaction`, `_reachable_interaction_spot`, `_reach_grid`, `_reach_has`, `_place_fixed_interactions`), `tests/test_battle.gd`. Adendo da SPEC-135.

## Verificação
- `tests/run_all.gd`: **0 falhas**. Testes novos: portal pedido no centro de uma bolsa cercada por 24 bloqueios vai para fora dela e tem caminho até o herói; poço fixo pedido dentro de um bloqueio sai dele. Mutação (`_reach_has` sempre verdadeiro): o teste da bolsa acusa a falha.
- **Auditoria nas 9 fases reais** (cenas `.tscn`, `SceneryLayout.apply`, bloqueios dos props, `place_scenery`; script descartável, removido): em todas, 93% a 98% do mapa é livre e **100% do livre é alcançável** (nenhuma bolsa fechada hoje); 0 interativos fixos ruins; chefe morrendo em 60 pontos aleatórios por fase (240 interativos por fase): **0 inalcançáveis nas 9 fases**.
- Bot (`durvall 2 dagruve 0.06 3`): sem erro de script.
- Custo: ~50 ms por cálculo frio em 60×60 com 80 bloqueios.

## Limite da medição
A auditoria usa a mesma grade que a regra; o critério de colisão do herói em movimento (deslizar em quinas) não foi simulado. Falta olho no jogo.

## Pendência
Aguarda playtest; mudança não commitada (depende de aprovação).
