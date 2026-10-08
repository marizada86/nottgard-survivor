---
id: EVID-194
title: Validação e reconciliação do PLAN-075 (B-005)
date: 2026-10-07
spec: SPEC-142
plan: PLAN-075
cards: [BAL-023]
---

# EVID-194 — B-005

B-004 pulada por decisão do dono (2026-10-07); motivo: a projeção de M1 e M6 já cai na faixa depois do corte de ~55 % (EVID-193). Revisitar só se o playtest com `gold_src` reprovar.

## Validação (S-011)
| Verificação | Resultado |
|---|---|
| Importação Godot (`--import`) | sem erro de script |
| Suíte inteira (`tests/run_all.gd`) | **0 falhas** (uma rodada intermediária acusou `test_abyss_marks.gd: não compila` enquanto outra sessão regravava `core/abyss_marks.gd` e o teste; na rodada seguinte, 0 falhas) |
| Smoke das nove fases (`tools/smoke.tscn`) | ok |
| `tools/backlog_check.ps1` (com `-ExecutionPolicy Bypass` só nesse processo) | P0=0; P1 abertos 4 (BUG-025/027/028/029); 10 P1 aguardando playtest; 8 verificações manuais; alertas de IDs duplicados antigos (ART-036/037, MEC-049) **não são deste plano** |
| Links | SPEC-142, PLAN-075, EVID-191/193/194, `BALANCEAMENTO.md`, `RELEASES.md` apontam para arquivos existentes |

## Reconciliação (S-012)
- `BALANCEAMENTO.md` BAL-023; `RELEASES.md` seção "Economia de ouro" em "Aguardando versão"; `README.md` próximos livres (SPEC-143, EVID-195, PLAN-076, BAL-024).
- `plan.yaml`: PLAN-075 em `completed_side_plans`, DEV-007 `COMPLETED_LOCAL`; `active_plan` PLAN-071 intacto (B-006/S-011).
- Nada commitado, publicado, exportado ou enviado.

## Pendências abertas
1. Servidor de playtest aceitar `gold_src` e `gold_extra` dentro de `result`.
2. Calibrar M1 e M6 com o primeiro playtest que trouxer `gold_src`.
3. Interpretação da M4 (abate é a fonte natural).
4. Commit: pela regra do projeto, uma mecânica por commit e sem misturar com outras trilhas; `core/battle.gd` e `tools/bot_curva.gd` também têm trabalho do PLAN-074 e de outras sessões no mesmo arquivo — separar os trechos antes de commitar, e só com sua aprovação.
