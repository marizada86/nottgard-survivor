---
id: PLAN-076
title: Marcas do Abismo, entrega 2 (liberação por conquista e quatro marcas)
spec: SPEC-143
cards: [MEC-040, BAL-016]
status: concluido localmente em 2026-10-07 (B-001 a B-005, EVID-195); aguarda aprovacao de commit
approval_mode: per-plan
route: PLAN_DEVIATION (DEV-008); PLAN-071 preservado, retorno em B-006/S-011
---

# PLAN-076

Spec: [[SPEC-143-marcas-do-abismo-entrega-2]]. Estado operacional: `.atena/state/plan-076-marcas-do-abismo-entrega-2.yaml`.
Um commit por mecânica (`add.yaml`); **nenhum commit, push, build ou exportação** neste plano sem aprovação à parte.

## Lotes

### B-001 Liberação por conquista (sem marcas novas)
| Passo | O quê |
|---|---|
| S-001 | `data/abyss_marks.json`: ordem de progressão e `requires`; `core/abyss_marks.gd`: `max_level(id)` por marca, `requires(id)`. |
| S-002 | `data/achievements.json`: nove conquistas de liberação (`unlock_mark`) e as de pontuação 20 e 25; texto da de 15. |
| S-003 | `core/profile.gd` (`abyss_mark_unlocked`, `abyss_unlocked_ids`), `core/game.gd` (filtro por marca), testes de liberação e de conquista. |

### B-002 Quatro marcas no combate
| Passo | O quê |
|---|---|
| S-004 | Elites despertos (`_spawn_elite`, elite extra do nível 3) e Chefe desperto (PV e fase a 15%), com `abyss_rng` próprio. |
| S-005 | Abismo vivo (intervalo da regra, timers de poça e raio, chance das ilusões) e Sem trégua (sorteio e fixos do cenário). |
| S-006 | Testes numéricos por marca e de identidade sem marcas (comparando com o HEAD). |

### B-003 Interface
| Passo | O quê |
|---|---|
| S-007 | `ui/abyss_panel.gd`: nove linhas na ordem da progressão, bloqueio por marca com a condição da conquista, resumo na aba Jogar. |
| S-008 | HUD e resultado já mostram o nível; conferir 25 pontos, rolagem, foco de controle e toque; capturas 1280×720. |

### B-004 Medição
| Passo | O quê |
|---|---|
| S-009 | `tools/bot_curva.gd` (`all=max`); varredura de cada marca nova no máximo e das nove no máximo, perfil veterano, três heróis; EVID. |
| S-010 | Ajuste de número só se o aceite 8 falhar, uma alavanca por vez. |

### B-005 Validação e reconciliação
| Passo | O quê |
|---|---|
| S-011 | Importação Godot, suíte inteira, smoke das nove fases (sem marcas e com as nove no máximo), contrato ADD e links. |
| S-012 | Backlog (MEC-040), SPEC-141 (nota de que a liberação mudou), RELEASES "O que testar", SPEC-120, EVID, `plan.yaml`; retorno ao PLAN-071. |

## Portões

Sem dependências novas · sem arte nova · alterações da economia de ouro (PLAN-075) **não** entram no commit (`git add -p`) · commit, push, build e exportação exigem aprovação própria.

## Recuperação

Snapshot de `plan.yaml` antes do desvio: `.atena/generated/abyss-marks/v02/plan-before-076.yaml`. Reverter = reverter o commit da entrega 2 (a entrega 1, `78c6f39`, fica intacta).

## Premissas a confirmar na aprovação

B1 (nomes e limiares das nove conquistas), B2 (pontuação 5/10/15/20/25), B3 (+10% de moeda por ponto), B4 (marcas bloqueadas ignoradas uma a uma). Detalhes na SPEC-143.
