---
id: PLAN-081
title: Lançamento da v0.4.0 (Major)
spec: SPEC-148
cards: [MEC-039, MEC-041, MEC-042, MEC-040, BAL-023, BAL-018, BUG-033]
status: planejado em 2026-10-08; aguarda início explícito
approval_mode: per-plan
route: PLAN_DEVIATION (DEV-013); PLAN-071 preservado, retorno em B-006/S-011
---

# PLAN-081 — Lançamento da v0.4.0

Spec: [[SPEC-148-lancamento-da-v0-4-0]]. Estado operacional: `.atena/state/plan-081-lancamento-v0-4-0.yaml`.
Ordem de trilhas do `add.yaml`: bugs → arte → mecânicas → balanceamento. Uma spec, um teste e um commit por mecânica.
**Commit, push, exportação e aviso aos testers exigem aprovação explícita à parte**, mesmo com o plano aprovado por plano.

## O que a 0.4.0 entrega, em linguagem de jogador

- Tudo o que ficou sem publicar desde a 0.3.1: Marcas do Abismo, economia de ouro, controles de Xbox/PlayStation e celular, bênçãos novas, ficha C e HUD mais claras, correções dos relatos do Manzi e do Daniel.
- Novo: **NPC que melhora magias**, **3 armas ou magias**, **6 equipamentos** e **Ecos de Nottgard** com mapa maior em Shedaklah, Molor e Durao.
- Conhecidos (não resolvidos): heróis que patinam, costas ao andar para cima, pixels soltos.

## Lotes

### B-001 Higiene da árvore e linha de base
| Passo | O quê |
|---|---|
| S-001 | `backlog_check` e lista de bugs abertos. |
| S-002 | Mapa dos 56 itens sujos por grupo: G1 ouro, G2 F7/ZIP, G3 lettering/cursor, G4 diagnóstico e pacote Caio, G5 documentos Atena, G6 versão. |
| S-003 | Um commit por grupo (G1 a G5), cada um com aprovação; arquivos compartilhados separados por trecho a partir do `HEAD`. G6 espera o fechamento. |
| S-004 | Suíte em cópia limpa do `HEAD`. |

### B-002 Bugs e verificação
| Passo | O quê |
|---|---|
| S-005 | Suíte, smoke das nove fases e `kit_test`. |
| S-006 | Reteste do BUG-033 e das verificações BUG-003 a 010 em run real (o que não for visto vai para "O que testar"). |
| S-007 | `BUGS.md`: bloco "Conhecidos"; correção do Caio entra como minor-fix se chegar. |

### B-003 Arte e áudio provisórios
| Passo | O quê |
|---|---|
| S-008 | Integrar com fallback a arte que o dono aprovar (lettering/cursor, ícones de bênçãos). |
| S-009 | Ícones provisórios de Eco e do NPC de magia, sem gerar imagem. |

### B-004 MEC-041 — NPC de upgrade de magia
| Passo | O quê |
|---|---|
| S-010 | SPEC-149: regras, preço, rerrolagem, Marcas e "Sem trégua"; teste antes do código. |
| S-011 | Código: NPC de magia; ferreiro só para armas corpo a corpo e equipamentos; um commit. |
| S-012 | Teste dos dois lados, bot sem regressão, cartão. |

### B-005 MEC-042 — conteúdo novo
| Passo | O quê |
|---|---|
| S-013 | **Portão de conteúdo:** proposta de 3 armas/magias e 6 equipamentos do Vault; o dono aprova. |
| S-014 | SPEC-150 (armas e magias) e SPEC-151 (equipamentos). |
| S-015 | Dados e código; um commit e um teste por item. |
| S-016 | Bot antes e depois (`bal_armas`, `bal_itens`); uma alavanca por vez. |

### B-006 MEC-039 — fatia piloto (Shedaklah, Molor, Durao)
| Passo | O quê |
|---|---|
| S-017 | **Portão de conteúdo:** Ecos, POIs e relíquia por fase; o dono aprova um a um; sem cânone do mestre. |
| S-018 | SPEC-152: 84×84, POIs em dados, Ecos, relíquia; testes de mapa e de dados. |
| S-019 | Coletável Eco, aba "Ecos" no Diário, pista, câmara e relíquia; sem consumir a RNG da batalha. |
| S-020 | Desempenho no `.exe`; se cair de 60 fps, 72×72. |

### B-007 Balanceamento
| Passo | O quê |
|---|---|
| S-021 | Bot por herói contra as linhas de base anteriores; ajustes só em JSON. |
| S-022 | `gold_src` (BAL-023) dos pacotes dos testers; `BALANCEAMENTO.md`. |

### B-008 Fechamento e lançamento
| Passo | O quê |
|---|---|
| S-023 | `VERSION` e `export_presets.cfg` em 0.4.0; `RELEASES.md` absorve 0.3.2 e 0.3.3; `backlog_check`. |
| S-024 | Changelog 0.4.0 (HTML e PDF) e guia fácil 0.4.0 (HTML e PDF); conferência página a página. |
| S-025 | Questionário 007 e PDF. |
| S-026 | Suíte, smoke, kit_test, bot; `.exe` em `build/` exportado de commit limpo. |
| S-027 | Commit de versão e documentos; **push só com aprovação à parte**. |
| S-028 | EVID final, `plan.yaml` reconciliado e retorno ao PLAN-071. |

## Gates

Sem dependências novas, sem geração de imagens, sem cânone do mestre, outras sessões intactas (sem `checkout`, `reset` ou `clean` sobre arquivos sujos). Qualquer outro pedido durante a execução é classificado antes de agir.

## Pontos de retorno

Snapshot do `plan.yaml` antes do planejamento: `.atena/generated/v040-release/plan-before-081.yaml`. O PLAN-071 continua `active_plan` até o início explícito; ao começar, ele é suspenso com snapshot, como nos PLAN-078 e PLAN-080.
