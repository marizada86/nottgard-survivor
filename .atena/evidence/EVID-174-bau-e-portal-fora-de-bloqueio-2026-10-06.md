---
id: "EVID-174"
title: "BUG-032: baú e portal fora de bloqueio de cenário"
created: "2026-10-06"
relations: ["[[SPEC-135-bau-e-portal-fora-de-bloqueio]]"]
cards: ["BUG-032"]
---

# EVID-174

## Mudança
`core/battle.gd` (`_add_interaction`, `_reachable_interaction_spot`, `_place_fixed_interactions`), `tests/test_battle.gd`. Detalhes na SPEC-135.

## Verificação
- `tests/run_all.gd`: **0 falhas**. Teste novo: chefe morto no centro de três bloqueios que cobrem todos os deslocamentos antigos; baús, baú do chefe e portal ficam onde o herói cabe (folga 0,6/0,9); ponto livre não é movido; `snap = false` mantém a posição.
- Bot (`tools/bot.gd -- durvall 2 dagruve 0.06 3`): rodou sem erro de script, mas as 2 sementes morreram em Dagruve antes do chefe; **não exercitou o portal**.

## Limite da medição
Não conferido em janela de jogo com a cena do print (rochas reais). O ponto livre pode cair numa bolsa fechada (limite da SPEC-135). Falta olho no jogo: matar um chefe encostado em rochas/estruturas em mais de uma fase e pegar baú e portal.

## Pendência
Aguarda playtest; commit, push e build só com aprovação.
