---
id: "EVID-173"
title: "BUG-030 e BUG-031: Mímico de baú único e painel de item de baú"
created: "2026-10-06"
relations: ["[[SPEC-134-bau-mimico-unico-e-pausa-ao-pegar-item]]"]
cards: ["BUG-030", "BUG-031"]
---

# EVID-173

## Mudança
`core/battle.gd` (`_kill`, `give_item`, `_resolve_item_choice`, `_open_chest`, `_open_boss_chest`), `ui/hud.gd` (título do painel), `tests/test_battle.gd`. Detalhes na SPEC-134.

## Verificação
- `tests/run_all.gd`: **0 falhas**. Testes novos: baú do chefe com slot vazio pausa com 1 opção, não equipa antes, equipa e retoma ao confirmar, sem vender nada; `give_item` sem aviso equipa direto; baú largado pelo Mímico nasce `safe` e 40 aberturas de baú seguro nunca geram Mímico.
- Primeira rodada teve 3 falhas da Maré: os baús do chefe, nascidos junto do herói, passaram a pausar o jogo. Teste ajustado (limpa as interações); comportamento é o pedido.
- Bot (`tools/bot.gd -- durvall 2 dagruve 0.06 3`): 2 sementes concluídas, itens equipados pelo painel, sem travar.

## Limite da medição
Painel não conferido visualmente em janela de jogo (só testes e bot headless). O painel reaproveita `OfferCard` com o mesmo formato do cartão de bênção. Falta olho no jogo: abrir um baú com slot vazio e conferir o cartão; e a cadeia baú → Mímico → baú.

## Pendência
Aguarda playtest do Manzi; commit local só com aprovação.
