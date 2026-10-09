---
id: "EVID-224"
title: "PLAN-088 B-001: dívida de verificação manual paga por teste automático"
created: "2026-10-09"
spec: "SPEC-162"
cards: ["BUG-003", "BUG-004", "BUG-005", "BUG-006", "BUG-007", "BUG-008", "BUG-009", "BUG-010"]
status: "feito local, sem commit; BUG-007 segue para olho humano"
---

# EVID-224 — verificação manual em testes

Cada item do roteiro do PLAN-033 foi conferido contra a suíte. Nenhum comportamento de jogo foi alterado.

| Cartão | O que a verificação pedia | Veredito | Onde está provado |
|---|---|---|---|
| BUG-003 | Ficha `C`: fechar com `C` e `Esc` (a "rolagem" antiga foi trocada pela ficha em abas e grade, SPEC-130) | **Coberto** | `test_playtest_fixes.gd` `_entrada`: C fecha a ficha, C numa oferta abre e fecha, Esc fecha |
| BUG-004 | Equipar ou vender: moeda creditada, arma some | **Coberto** | `test_battle.gd` 9b e 9c (vender remove a arma e rende moedas; recusar também) |
| BUG-005 | Quebráveis: drop, respawn por tempo, poção só de elite | **Coberto agora** | `test_battle.gd` 9c a 9d-2 (drop e poção) + `test_manual_debt.gd` (o relógio zerado cria um quebrável a 5 a 12 tiles, rearma o relógio, vale nas 9 fases, nada nasce antes) |
| BUG-006 | Loja, ferreiro e curandeiro: preço, "Sair" sem custo, ouro histórico intacto | **Coberto agora** | `test_battle.gd` 9e (preço, "Sair" sem custo, itens travados) + `test_manual_debt.gd` (comprar nos três não altera `stats.gold`, o ouro do Quartel) |
| BUG-007 | Segurar o clique esquerdo para andar, sem mover ao clicar em painel | **Precisa de olho humano** | `ui/run.gd` lê `Input.is_mouse_button_pressed` ao vivo; a regra do painel depende da interface rodando. Continua na dívida |
| BUG-008 | Nível de equipamento e super-upgrade | **Coberto** | `test_battle.gd` 9f (prévia Nv+1 escalada, super-upgrade da base, item no máximo sai da oferta) |
| BUG-009 | Botão de menu encerra o sandbox QA | **Coberto** | `test_qa_sandbox.gd` `_assert_end_qa_sandbox_clears_leak` |
| BUG-010 | Sinergia arma evoluída + acessório no máximo + magia | **Coberto** | `test_battle.gd` 10b (aparece só com as três condições, +1 CA, escala com a descida, persiste) |

## Testes novos e prova por mutação

`tests/test_manual_debt.gd` (BUG-005 e BUG-006).

| Mutação em `core/battle.gd` (restaurada depois) | Resultado |
|---|---|
| `_spawn_random_breakable()` trocado por `pass` | falhou: "quebrável deveria reaparecer" e uma falha por bioma |
| compra da loja somando em `stats.gold` | falhou: "comprar não deveria alterar o ouro do Quartel" |

## Verificação

`tests/run_all.gd`: `testes: 0 falha(s)`. `res://tools/smoke.tscn`: `smoke: ok`. Rodadas em paralelo com a rodada do bot (EVID-225), então sem medida de tempo.

## Efeito no backlog

`BUGS.md`: BUG-003, 004, 005, 006, 008, 009 e 010 saem da dívida e vão para "Fechados". `backlog_check`: verificações manuais pendentes de 8 para 1 (BUG-007). Não houve comportamento quebrado, então nenhum BUG novo.
