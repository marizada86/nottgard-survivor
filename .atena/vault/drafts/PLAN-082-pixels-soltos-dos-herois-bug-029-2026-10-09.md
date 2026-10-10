---
id: PLAN-082
title: Pixels soltos nos heróis, pré-redução das tiras (BUG-029)
spec: SPEC-154
cards: [BUG-029, BUG-025]
status: planejado em 2026-10-09; aguarda rota (DEV-014), nível de aprovação e início explícito
approval_mode: unconfigured
route: PLAN_DEVIATION (DEV-014); PLAN-071 preservado
---

# PLAN-082

Spec: [[SPEC-154-pixels-soltos-dos-herois-pre-reducao-das-tiras-bug-029]]. Estado operacional: `.atena/state/plan-082-pixels-soltos-dos-herois.yaml`.
Um commit por mecânica/arte (`add.yaml`); **commit, push, exportação e aviso aos testers exigem aprovação à parte**. A aprovação visual do dono é um portão independente do nível de aprovação.

## Lotes

### B-001 Ferramenta e piloto no Kayron
| Passo | O quê |
|---|---|
| S-001 | `tools/reduce_hero_strips.gd`: reduz cada quadro (alfa pré-multiplicado), grava em `assets/animations/heroes_screen/<herói>/`; modos A, B e C; determinística. |
| S-002 | Rodar as três variantes no Kayron; medir altura, pés, quadros cortados e solidez contra os originais. |
| S-003 | Capturas em jogo (zoom 1,0, 1,5 e 2,0; 1280×720 e 1920×1080) com o atual ao lado. |
| S-004 | **Portão visual:** o dono escolhe a variante (ou rejeita). |

### B-002 Integração e testes (só o Kayron)
| Passo | O quê |
|---|---|
| S-005 | `HERO_STRIP_SET` em `ui/hero_view.gd`: diretório e fator por herói; recalcula `CELL`, `HERO_IDLE_ART_HEIGHT`, `HERO_FEET_Y` e `display_scale`. Sem entrada = atual. |
| S-006 | Teste novo: mesma altura em tela, mesmos pés, mesmos quadros, sem corte, mesma solidez; ajustar `test_animation_assets`. |
| S-007 | Suíte, smoke e `kit_test`; captura do Kayron em corrida real. |

### B-003 Expansão por lotes (aprovação visual a cada lote)
| Passo | O quê |
|---|---|
| S-008 | Lote 1: Korrak, Durvall, Sylas. |
| S-009 | Lote 2: Maelor, Nyrelia, Zynara. |
| S-010 | Lote 3: Bromnor, Leoric, Brook. |

### B-004 Validação e registro
| Passo | O quê |
|---|---|
| S-011 | Suíte, smoke, `kit_test`, `audit_projeto`; tamanho do repositório; originais intactos. |
| S-012 | Cartões BUG-029 e BUG-025, `INBOX`, `backlog_check`, EVID. |
| S-013 | Reconciliar `plan.yaml` (DEV-014) e voltar ao PLAN-071 em B-006/S-011. |

## Gates

Sem dependências novas e sem geração de imagens. Mudança de aparência só com a aprovação visual do dono. Originais nunca apagados. Outras sessões intactas. Qualquer outro pedido durante a execução é classificado antes de agir.

## Pontos de retorno

Snapshot do `plan.yaml` antes do início em `.atena/generated/bug-029-reducao/plan-before-082.yaml`. O PLAN-071 continua `active_plan` até o início explícito; ao começar, é suspenso com snapshot, como no PLAN-081.
