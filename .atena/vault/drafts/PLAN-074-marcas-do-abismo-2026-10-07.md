---
id: PLAN-074
title: Marcas do Abismo, entrega 1 (cinco marcas, run inteira)
spec: SPEC-141
cards: [MEC-040, BAL-016]
status: concluido localmente em 2026-10-07 (B-001 a B-005, EVID-196 e EVID-192); commit 78c6f39 local, sem push
approval_mode: per-plan
route: PLAN_DEVIATION (DEV-006); PLAN-071 preservado, retorno em B-006/S-011
---

# PLAN-074

Spec: [[SPEC-141-marcas-do-abismo-entrega-1]]. Estado operacional: `.atena/state/plan-074-marcas-do-abismo.yaml`.
Um commit por mecânica (`add.yaml`); **nenhum commit, push, build ou exportação** neste plano sem aprovação à parte.

## Lotes

### B-001 Dados e núcleo de combate
| Passo | O quê |
|---|---|
| S-001 | `data/abyss_marks.json` e `core/abyss_marks.gd` (normalizar, limitar, somar, validar liberação). |
| S-002 | `core/battle.gd`: Horda (cap e taxa), Fúria, Carapaça, Pressa, Fome (todos os pontos de cura), moeda e campos novos de `result()`. |
| S-003 | `tests/test_abyss_marks.gd`: run idêntica com marcas desligadas; efeito numérico por marca; cobertura dos pontos de cura. |

### B-002 Perfil, recompensa e conquistas
| Passo | O quê |
|---|---|
| S-004 | `core/profile.gd` (`abyss_best`, stat), `core/game.gd` (`run_marks`, `battle_ctx` com liberação), `settings.abyss_marks`. |
| S-005 | `data/achievements.json`: 5, 10 e 15 pontos (moedas 200/400/800) e testes de recorde e conquista. |

### B-003 Interface
| Passo | O quê |
|---|---|
| S-006 | Painel no Quartel (`ui/menu.gd`, `tools/build_scenes.gd` se necessário): cinco linhas com −/+, total, bônus de moeda, aviso de bloqueio; mouse, controle e toque. |
| S-007 | `ui/hud.gd`: chip "Marcas N" e linha no resultado; verificação de foco (BUG-033 não pode regredir). |

### B-004 Medição
| Passo | O quê |
|---|---|
| S-008 | `tools/bot.gd`: argumento de marcas; varredura por marca (níveis 0, 1, 3) e conjunto máximo, perfil veterano; EVID com a tabela. |
| S-009 | Ajuste de números só se a meta do aceite 8 falhar, **uma alavanca por vez**, antes e depois anotados. |

### B-005 Validação e reconciliação
| Passo | O quê |
|---|---|
| S-010 | Importação Godot, suíte inteira, smoke das nove fases, contrato ADD e links. |
| S-011 | Backlog (MEC-040, BAL-016, README e `RELEASES.md` "O que testar"), SPEC-120 (Parte B, entrega 1), EVID, `plan.yaml`; retorno ao PLAN-071. |

## Portões

Sem dependências novas · sem arte nova · `data/abilities.json` e demais alterações de outras sessões **não** entram · commit, push, build e exportação exigem aprovação própria · o `.exe` de playtest só se você pedir.

## Recuperação

Snapshot de `plan.yaml` antes do desvio: `.atena/generated/abyss-marks/v01/plan-before-074.yaml`. Reverter a mecânica = não ligar nenhuma marca (comportamento atual) ou reverter o commit da mecânica.

## Premissas a confirmar na aprovação

A1 (conquistas 5/10/15 já nesta entrega, só moedas), A2 (relíquia e as 4 marcas restantes na entrega 2), A3 (liberação olha só a fase inicial). Detalhes na SPEC-141.
