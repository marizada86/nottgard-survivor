---
id: PLAN-104
title: Retratos próprios da Ficha (C) e do HUD
spec: SPEC-178
status: DRAFT r1; aprovado per-plan em 2026-10-14; B-001 feito (EVID-258); aguarda G-R0 (imagens do dono)
content_state: DRAFT
mode: per-plan   # aprovado pelo dono em 2026-10-14; rota: fazer agora e voltar ao PLAN-103
request_classification: PLAN_DEVIATION   # em relação ao PLAN-103 ativo (B-002 aguarda imagens do dono; B-003 em R5)
recommended_mode: per-batch
---

# PLAN-104 — Retratos da Ficha (C) e do HUD

## Onde ele se encaixa

O PLAN-103 está parado esperando o dono em B-002 (imagens de movimento) e B-003 (proposta R5). Este plano é pequeno, não toca em animação nem em game feel e não compete por arquivos com eles. Rota recomendada: **fazer agora e voltar** ao PLAN-103 no checkpoint em que ele está (B-002/S-008, B-003/R5).

## Lotes e etapas

| Lote | Etapa | Conteúdo | Saída | Depende do dono |
|---|---|---|---|---|
| B-001 | S-001 | Resolvedor `HeroPortraits.texture(id, kind)` com fallback | helper + uso em `character_sheet.gd` e `hero_panel.gd` | não |
| B-001 | S-002 | `stretch_mode` da Ficha para `COVERED`; testes A1, A2, A3 (com pasta vazia e com imagem de teste) | testes verdes | não |
| B-001 | S-003 | Suíte + smoke; captura da Ficha e do HUD (sem imagens novas = idêntico a hoje) | evidência `EVID-` | não |
| **gate** | G-R0 | Dono gera as 24 imagens no ChatGPT e salva em `.atena/generated/retratos-ficha-hud/entrega/` | 24 PNG | **sim** |
| B-002 | S-004 | Normalização: faixa 3:1 → 768×256; quadrado → 256×256; checagem de tamanho, canal alfa e bordas | PNG normalizados em `.atena/generated/retratos-ficha-hud/v01/` | não |
| B-002 | S-005 | Conferência contra as 12 fichas de identidade (traços fixos, "não pode", P1/P4/P6) e folha de contato por lote de 3 a 4 heróis | relatório + folha | não |
| **gate** | G-R1 | Dono aceita, pede ajuste ou pede nova geração, por lote | decisão registrada | **sim** |
| B-003 | S-006 | Admissão: copiar para `assets/portraits/ficha` e `assets/portraits/hud`, `--import`, `build_asset_manifest.ps1`, trava `ASSET-OFFICIAL-LOCK-015`, registro de aprovação | assets no jogo (DRAFT até o aceite) | não |
| B-003 | S-007 | Testes A3 e A4 completos, suíte, smoke e captura em jogo (HUD a 76 px, Ficha desktop e toque) | evidência | não |
| **gate** | G-R2 | Dono confere em jogo (leitura do HUD, rosto na Ficha) | aceite | **sim** |
| B-003 | S-008 | Reconciliar backlog, estado e evidência; propor commit | commit **só com aprovação** | sim |

Contagem: 8 etapas, 3 lotes, 3 gates do dono. B-001 pode começar sem nenhuma imagem; B-002 e B-003 só andam com as imagens entregues e podem ser feitos em lotes por heróis (o fallback permite admitir 3 a 4 por vez).

## Checkpoint inicial

`B-001/S-001` aguardando a escolha do nível de aprovação.

## O que NÃO acontece sem aprovação

Commit, push, exportação do `.exe`, aviso de build, promoção a canon, dependências novas e qualquer edição do menu.
