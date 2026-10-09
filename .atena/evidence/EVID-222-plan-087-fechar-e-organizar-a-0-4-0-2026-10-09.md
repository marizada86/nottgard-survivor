---
id: "EVID-222"
title: "PLAN-087: fechar e organizar a 0.4.0 (sem assets nem movimentação)"
created: "2026-10-09"
spec: "SPEC-161"
status: "feito local; commits e escolha do inventário aguardam o dono"
---

# EVID-222 — PLAN-087

| Lote | Resultado |
|---|---|
| B-001 | Changelog, guia fácil e RELEASES ganharam a névoa de borda e a Maré de fim de fase (MEC-059, MEC-060), que estavam commitadas e fora dos documentos dos testers. PDFs do changelog (agora 5 páginas) e do guia (2) refeitos com `chrome --headless --print-to-pdf`. A seta de evento (MEC-061) **não** entrou: só com o commit dela. S-002 e S-003 aguardam os commits. |
| B-002 | `generated/organizacao-087/mapa-de-pendencias.md`: 4 grupos de commit em ordem, itens de outras sessões preservados. EVID-219 duplicado resolvido (seta de evento virou EVID-221). |
| B-003 | `inventario-de-planos-e-specs.md` e `specs.tsv`: 35 planos (21 entregues, 10 esperando, 4 vivos) e 163 specs (131 entregues); status velhos e números repetidos listados; nada removido. |
| B-004 | BAL-027: decisão de **manter** os números; pergunta levada ao roteiro. |
| B-005 | `roteiro-de-playtest-0-4-0.md`. Playtest humano **não realizado**. |

Verificações: `tools/backlog_check.ps1` sem alertas (P1 abertos 4: BUG-025, 027, 028, 029). Suíte não rodada: nenhum código nem dado de jogo foi alterado neste plano. Sem commit, push, exportação nem remoção.
