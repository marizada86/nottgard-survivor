---
id: "SPEC-162"
title: "Dívida de verificação manual em testes automáticos e linha de base nova do bot"
status: "APROVADA por plano em 2026-10-09 (DEV-023, PLAN-088); em execução"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
created: "2026-10-09"
relations: ["[[SPEC-161-fechar-e-organizar-a-0-4-0-sem-assets]]"]
cards: ["BUG-003", "BUG-004", "BUG-005", "BUG-006", "BUG-007", "BUG-008", "BUG-010", "BAL-016", "BAL-018", "BAL-027"]
---

# SPEC-162 — Verificação manual em testes e linha de base do bot

Pedido do dono (2026-10-09): enquanto os assets não chegam, seguir com o que não depende de arte nem de movimentação. Aprovação **por plano**; o dono saiu e deixou rodar. Recomendação da Atena aceita: lotes 1 e 2.

## Lote 1 — Dívida de verificação manual (BUG-003 a BUG-008 e BUG-010)

Cada item do roteiro do PLAN-033 ("sem checagem interativa numa run real") é conferido contra a suíte atual. Resultado por item: **coberto** (cita o teste), **coberto agora** (teste novo, com mutação para provar que falha quando o comportamento quebra) ou **precisa de olho humano** (continua na lista, com a razão). Não se muda comportamento de jogo; se um teste novo revelar defeito real, vira BUG-nnn e fica reportado, sem correção sem aprovação (exceto erro de uma linha dentro do escopo do item).

## Lote 2 — Linha de base nova do bot

`tools/bot_curva.gd`, doze heróis (inclui Arlindo e Erik), metas 0 e 1, 15 sementes, dt 0,08, 9 fases, lado 60, na árvore commitada (bot que recua da faixa de névoa, EVID-220). Entrega: tabela por herói e por meta, comparação com o EVID-208/217/219, lista de outliers e **proposta** de ajustes só em JSON. **Nenhum número de balanceamento é alterado sem aprovação do dono.**

## Fora do escopo

Arte, movimentação, BUG-025/027/028/029, MEC-002/003/004/005, push, exportação, aviso aos testers. Julgamento de sensação e diversão permanece com o dono.

## Portões

Commits só com aprovação explícita (o dono não está disponível: o trabalho fica local e commitável); nenhuma dependência nova; nada em `assets/`; mudanças de outras sessões preservadas; `tests/run_all.gd` com 0 falhas antes de qualquer commit.

## Aceite

1. Tabela dos 8 itens com veredito e teste citado.
2. `tests/run_all.gd` com `0 falha(s)` e `tools/smoke.tscn` ok ao final.
3. EVID do bot com a tabela nova e a proposta de ajustes.
4. `backlog_check` sem alertas; cartões atualizados.
