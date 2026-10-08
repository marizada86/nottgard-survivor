---
id: "EVID-201"
title: "PLAN-080 / SPEC-147: correções dos playtests v0.3.2 (Manzi) e v0.3.3 (Daniel)"
created: "2026-10-08"
plan: "PLAN-080"
spec: "SPEC-147"
sources: ["EVID-199", "EVID-200"]
cards: ["BUG-034", "BUG-035", "BUG-036", "BUG-037", "MEC-053", "MEC-054", "MEC-055", "MEC-056", "MEC-057", "BAL-024"]
status: "IMPLEMENTADO LOCAL; aguarda playtest; sem commit, push, build ou exportação"
---

# EVID-201 — Entrega local do PLAN-080

Escopo e decisões do dono (por plano; fazer agora e voltar ao PLAN-071; baú atrasado; sem Ctrl; ranking só ao abrir a aba) em [SPEC-147](../specs/SPEC-147-correcoes-dos-playtests-v032-e-v033.md).

## O que mudou (por critério da spec)

| # | Critério | Resultado |
|---|---|---|
| 1 | C fecha a ficha (BUG-034) | `ui/hud.gd`: o ramo da ficha aberta passa a vir antes do retorno e fecha com C, botão de controle e Esc. **O teste falha 4x no HEAD e passa com a correção.** |
| 2 | Ficha nas ofertas | Verificado, **sem correção**: a HUD já abria a ficha em `levelup`, `altar`, `item_offer` e `shop` (commit `14633e2`); com a ficha aberta, C só fecha e não reabre. Corrige a leitura anterior do EVID-199 #4. |
| 3 | Bloco de notas modal (BUG-035) | `core/playtest.gd`: fundo de tela cheia que absorve o mouse (nota e Central), foco preso no campo; `ui/hud.gd` e `Run` ignoram teclado, mouse e controle com nota, guia ou Central abertos; mobile desliga o combate. |
| 4 | Sem sobreposição no topo (BUG-036) | `ui/hud.gd`: `TopStack` empilha chefe, quests, status e avisos; limite de 4 quests e 4 linhas de status com "+N"; aviso do Playtest (F5/F6/F7) saiu de cima do relógio. Teste de retângulos com 0, 1, 3 e 6 objetivos. |
| 5 | Quests em destaque (MEC-055) | `ui/quest_panel.gd` (moldura dourada, progresso, prazo vermelho em ≤ 10 s, pulso); dados em `Happenings.hud_entries()`. |
| 6 | Itens e alvos da quest | `ui/overlay.gd`: anel pulsante e seta sobre item, alvo, NPC e inimigo dentro da tela; rótulo de evento maior e com contorno. |
| 7 | Estige na HUD (MEC-056) | `ui/status_chip.gd`: chip "RIO ESTIGE" (tempo, INT efetiva) e "ESQUECIMENTO", com ícone e dica. |
| 8 | Arma base não volta (BUG-037) | `core/battle.gd` `_evolved_base_ids()`. **Sem o filtro as 8 bases voltam (11 a 57 vezes em 150 ofertas); com ele, nenhuma.** |
| 9 | Primeiro baú aos 45 s (BAL-024) | `Battle.FIRST_INTERACTION_SECONDS = 45.0`; nada surge antes e o primeiro é baú. |
| 10 | Próximo nível e evolução (MEC-053) | Armas, passivas e itens base na ficha C. Detalhe maior (265 px) e menor na aba de bônus (110 px). |
| 11 | Nome antes do valor (MEC-054) | `_bonus_row`. |
| 12 | Ranking ao abrir a aba (MEC-057) | `ui/leaderboard.gd`: `refresh()` ao ficar visível, no máximo uma vez a cada 5 s. |

## Verificação

- Testes novos: `tests/test_playtest_fixes.gd` (entrada, topo, Estige, armas, primeiro baú, ficha, ranking), zero falhas.
- Suíte completa (`tests/run_all.gd`): **0 falhas** ([log](../generated/playtest-fixes-080/tests.log)).
- Smoke das nove fases: ok ([log](../generated/playtest-fixes-080/smoke.log)).
- `tools/kit_test.tscn` (janela, 1280×720): `kit: OK` ([log](../generated/playtest-fixes-080/kit_test.log)).
- Capturas em `.atena/generated/playtest-fixes-080/` (1280×720): topo com quests, chefe e avisos; Estige na água e Esquecimento; ficha com próximo nível e evolução (arma), passiva e bônus. A leitura das capturas achou e corrigiu dois defeitos próprios: a pilha do topo cobria a ficha (ordem de desenho) e a aba de bônus precisava de mais grade.
- Novo `tools/run_one_test.gd` roda um teste isolado: `godot --headless --path . -s tools/run_one_test.gd -- test_nome`.

## Limites

- Relatos de segunda mão; nenhum bug foi reproduzido em run real antes da correção, só pelo teste contra o HEAD (BUG-034, BUG-037) ou pela leitura do código (BUG-035, BUG-036).
- **Não verificado em run real, com mouse e controle:** o bloqueio do bloco de notas e a ordem de desenho em 1920×1080 e no celular (só 1280×720 capturado). O teste de retângulos cobre 1280×720.
- Item 3 do Daniel (ranking) só recebeu o mínimo; o envio e o importador seguem no PLAN-071.
- Árvore com alterações de outras sessões em `core/battle.gd`, `core/playtest.gd`, `ui/character_sheet.gd`; só os trechos próprios foram editados.
