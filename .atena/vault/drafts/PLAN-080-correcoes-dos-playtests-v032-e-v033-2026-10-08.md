---
id: PLAN-080
title: Correções e clareza da HUD após os playtests v0.3.2 (Manzi) e v0.3.3 (Daniel)
spec: SPEC-147
cards: [IN-059, IN-060, IN-061, IN-062, IN-063, IN-064, IN-065, IN-066, IN-067, IN-068, IN-069, IN-070, IN-071, IN-072, BUG-003]
status: concluído localmente em 2026-10-08 (B-001 a B-005, EVID-201); aguarda aprovação de commit
approval_mode: per-plan
route: PLAN_DEVIATION (DEV-012); PLAN-071 preservado, retorno em B-006/S-011
---

# PLAN-080

Spec: [[SPEC-147-correcoes-dos-playtests-v032-e-v033]]. Estado operacional: `.atena/state/plan-080-correcoes-dos-playtests.yaml`.
Um commit por mecânica (`add.yaml`); **nenhum commit, push, build ou exportação** sem aprovação à parte. Cartões novos usam os próximos IDs livres conferidos no início da execução.

## Lotes

### B-001 Entrada e ficha C
| Passo | O quê |
|---|---|
| S-001 | `ui/hud.gd`: tratar o fechamento com C antes do retorno de `items_panel.visible`; `ui/run.gd` coerente. Teste: abrir e fechar com C (corrida e controle). |
| S-002 | Verificar a ficha nas ofertas `levelup`, `altar`, `item_offer`, `shop` (abrir, navegar, fechar, rerrolar). Corrigir só se o teste falhar. |
| S-003 | Bloco de notas modal: fundo de tela cheia em `core/playtest.gd`; `has_modal` e `Run._unhandled_input` consultam `Playtest.is_overlay_open()`. Testes de entrada bloqueada e de pausa restaurada. |

### B-002 HUD do topo e quests
| Passo | O quê |
|---|---|
| S-004 | Painel de objetivos que mede a própria altura; `BossPanel` e `ToastBox` ancorados abaixo; limite de 4 linhas com "+N". Teste de retângulos em 1280×720 e 1920×1080. |
| S-005 | Painel de quests com moldura, ícone, progresso e tempo; pulso ao iniciar, progredir, concluir, falhar. |
| S-006 | `ui/overlay.gd`: anel pulsante e rótulo reforçado sobre item, alvo, NPC e inimigo da quest dentro da tela, via `Happenings.markers()`. |
| S-007 | Chip de status do Estige (água, INT efetiva, Esquecimento) no lugar da linha de texto. |

### B-003 Armas e primeiro interativo
| Passo | O quê |
|---|---|
| S-008 | `core/battle.gd` `_build_offer`: excluir a arma base quando o herói possui a evolução. Teste com as 8 evoluções e 200 sorteios. |
| S-009 | `load_stage`: primeiro interativo aos 45 s (constante nomeada), ainda baú. Atualizar testes dependentes de 4 s. |

### B-004 Ficha C e ranking
| Passo | O quê |
|---|---|
| S-010 | `ui/character_sheet.gd`: "Próximo nível" e "Evolui em X" para armas, passivas e itens base. |
| S-011 | `_bonus_row`: nome antes do valor. |
| S-012 | `ui/leaderboard.gd`: `refresh()` na primeira exibição da aba. |

### B-005 Validação e retorno
| Passo | O quê |
|---|---|
| S-013 | Suíte completa, smoke das nove fases, `tools/kit_test.gd`; capturas da HUD e da ficha. |
| S-014 | Cartões BUG/MEC/BAL, `INBOX`, `README` (próximos livres), `backlog_check.ps1`, EVID. |
| S-015 | Reconciliar `plan.yaml` (DEV-012) e voltar ao PLAN-071 em B-006/S-011. |

## Gates

Sem dependências novas, sem arte nova, sem commit, push, build ou exportação. Alterações de outras sessões em `core/battle.gd`, `core/playtest.gd`, `ui/character_sheet.gd` e testes ficam intactas: editar só trechos próprios e conferir `git diff` a cada lote. Qualquer outro pedido durante a execução é classificado antes de agir.

## Pontos de retorno

Snapshot do `plan.yaml` antes do início em `.atena/generated/playtest-fixes-080/plan-before-080.yaml`. O PLAN-071 continua `active_plan` até o início explícito; ao começar, ele é suspenso com snapshot, como no PLAN-078.
