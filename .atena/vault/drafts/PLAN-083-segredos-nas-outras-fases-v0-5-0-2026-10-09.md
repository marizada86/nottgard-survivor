---
id: PLAN-083
title: Segredos nas outras fases e lançamento da v0.5.0 (Major)
spec: SPEC-157
cards: [MEC-039, MEC-012]
status: planejado em 2026-10-09; aguarda rota (DEV-017), nível de aprovação, portão de conteúdo e início explícito
approval_mode: unconfigured
route: PLAN_DEVIATION (DEV-017); PLAN-071 preservado
---

# PLAN-083

Spec: [[SPEC-157-segredos-nas-outras-fases-v0-5-0]]. Estado: `.atena/state/plan-083-segredos-nas-outras-fases.yaml`. Ordem de trilhas do `add.yaml`; um commit por mecânica; **commit, push, exportação e aviso aos testers exigem aprovação à parte**.

## Lotes

| Lote | O quê | Passos |
|---|---|---|
| **B-001 Prontidão** | ler o relato dos testers da 0.4.0 (portão do dono); portão de conteúdo (Ecos, relíquias, Espelho); ler o Vault para Dagruve e Docas; SPECs filhas | S-001 a S-004 |
| **B-002 Dagruve e Docas (60×60)** | `secrets.json`, POIs com sondagem de chão, chaves `unlock_chamber`, relíquias (Broche, Colar dos Tentáculos), conquistas, testes | S-005 a S-008 |
| **B-003 Mapas 84×84** | Feng-tu, Shendilavri e Goranthis: enlarge, bake v2, escala de desenho, testes de mapa e FPS (um commit por fase) | S-009 a S-012 |
| **B-004 Segredos em 84×84** | POIs, Ecos, relíquias e chaves das três fases; Espelho das Almas Desejantes (novo único); `vitimas_drenadas` fixo | S-013 a S-016 |
| **B-005 Balanceamento** | bot por herói antes e depois (EVID-208 como base); ouro e conquistas | S-017, S-018 |
| **B-006 Fechamento** | versão 0.5.0, RELEASES, changelog 0.4.0 → 0.5.0 (PDF), guia, questionário 008; verificação; push só com aprovação | S-019 a S-024 |

## Gates

Sem dependências novas e sem geração de imagens; portão de conteúdo e leitura do Vault antes de escrever texto; originais e outras sessões intactos; qualquer outro pedido durante a execução é classificado antes de agir.

## Pontos de retorno

Snapshot do `plan.yaml` antes do início em `.atena/generated/v050-release/plan-before-083.yaml`. O PLAN-071 continua `active_plan` até o início explícito.
