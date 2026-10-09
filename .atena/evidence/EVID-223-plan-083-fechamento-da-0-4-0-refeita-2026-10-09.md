---
id: "EVID-223"
title: "PLAN-083: fechamento da 0.4.0 refeita (commits locais, verificacao e retorno ao PLAN-071)"
created: "2026-10-09"
spec: "SPEC-157"
status: "commitado local; push, exportacao e aviso aos testers pendentes"
---

# EVID-223 — fechamento do PLAN-083 (S-023, S-024)

Complementa a [EVID-218](EVID-218-b006-fechamento-da-0-4-0-refeita-2026-10-09.md) (documentos) e a [EVID-222](EVID-222-plan-087-fechar-e-organizar-a-0-4-0-2026-10-09.md) (PLAN-087).

| Commit | Conteudo |
|---|---|
| `d83c106` | Arlindo Orlando e Erik Blackthorn jogaveis (MEC-062, MEC-063, SPEC-160) |
| `2d929b0` | Seta de evento na borda (MEC-061, SPEC-159) |
| `10c833d` | SPEC-159 a 161, PLAN-085 a 087, EVID-219/221/222, cartoes, mapa de pendencias, inventario, roteiro |
| `c0ebc87` | Documentos da 0.4.0 refeita: changelog, guia facil, questionario 007, RELEASES (inclui nevoa e seta) |

## Verificacao (checkout limpo, fora da arvore de trabalho)

| Commit | Suite | Smoke |
|---|---|---|
| `d83c106` | `testes: 0 falha(s)` | — |
| `2d929b0` | `testes: 0 falha(s)` | `smoke: ok` (9 fases) |
| `10c833d`, `c0ebc87` | so documentos | — |

Primeira tentativa de importacao no worktree falhou (importacao incompleta, 130 falhas por texturas ausentes, nao por codigo); repetida com o cache `.godot` copiado, 0 falhas. `backlog_check`: sem alertas de organizacao (P1 abertos: BUG-025, 027, 028, 029).

## Fora dos commits (outra sessao ou decisao do dono)

PLAN-082 / BUG-029 (`BUGS.md`, `tools/reduce_hero_strips.gd` e afins, SPEC-154, `assets/animations/heroes_screen/`), pacote do Caio (BUG-028), capturas de `big-maps/` e `nevoa-borda/`. `ui/hero_view.gd` levou o encanamento inerte das tiras reduzidas (`HERO_STRIP_SET` vazio).

## Retorno

`plan.yaml`: PLAN-083 fechado; PLAN-071 volta a ser o plano ativo em B-006/S-011. Pendentes (aprovacao a parte): push (republica o `latest`), exportacao do `.exe` local, aviso aos testers, escolha A/B/C/D do inventario.
