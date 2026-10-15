---
id: EVID-263
title: M3 R2, dicas de primeira vez e legibilidade do Q/RMB
spec: SPEC-179
plan: PLAN-103 / B-004
date: 2026-10-15
content_state: DRAFT
---

# EVID-263 — M3 R2

Aprovação do dono (G-M3-2, 2026-10-15): "aprovo as 7 dicas, inclua o Q/RMB". Push segue suspenso até a decisão da L5. Nada foi commitado.

## O que mudou
| Arquivo | Mudança |
|---|---|
| `data/onboarding_hints.json` (novo) | as 7 dicas (D1 a D7) com marcadores `{interact}`, `{pause}`, `{extract}`, `{detail}`, `{next}` |
| `core/onboarding_hints.gd` (novo) | regra pura: 1 dica a cada 90 s de jogo, no máximo 7 por perfil, nenhuma antes de 12 s, nenhuma em luta de chefe nem com vida abaixo de 30%, uma vez por perfil |
| `ui/run.gd` | `_setup_hints`, `_update_hints` (gatilhos por consulta a cada 0,25 s) e marcas por evento (`streak`, `item_offer`); mostra pelo aviso do HUD com o prefixo "Dica:" |
| `core/profile.gd`, `core/game.gd` | `settings.hints` (`on`/`off`, padrão `on`), `settings.hints_seen`, migração, `Game.set_hints`, `Game.reset_hints` |
| `ui/options_panel.gd` | linha "Dicas: Ligadas / Desligadas" e botão "Rever dicas" em Opções |
| `ui/ability_slot.gd` | rótulo "Q/RMB" de 10 para 12 px, contorno 5 e cor mais clara (sumia em piso claro) |

## Gatilhos (em ordem de prioridade)
Portal aberto (D1) → altar aberto (D6) → perto do ritual, até 3,5 tiles (D2) → baú ou fonte à vista, até 5 tiles (D3) → primeiro item para trocar (D7) → primeiro marco da Maré (D4) → primeira missão ou câmara no Questlog (D5).

## Desvio do texto aprovado (D1)
O texto aprovado dizia "Extrair [Esc]". No jogo, **X extrai direto** (pede confirmação) e o aviso do portal já diz "extraia (X/norte)"; o rodapé diz "[Esc] Pausa → Extrair". A dica usa a tecla real da ação de extrair (`{extract}`, X no teclado, o botão do controle em uso) para não contradizer o aviso do portal. O multiplicador vem do jogo (`{next}`), não fixo em ×1,25.

## Verificação
| Verificação | Resultado |
|---|---|
| `tests/test_onboarding_hints.gd` (novo): 7 dicas, texto até 90 caracteres com marcadores resolvidos, abertura, chefe, vida, repetição, intervalo, nova run, desligadas, migração do perfil | 0 falhas |
| Suíte completa | 0 falhas |
| Smoke das 9 fases | ok |
| `tools/capture_hints.tscn`: as 7 disparam em run real; Desligadas não mostra; dica barrada 10 s depois de outra | 9 de 9 como esperado; capturas em `.atena/generated/m3-onboarding/dicas/` |

## Limites e pendências
- As capturas usam estados de QA (portal, ritual, baú, altar) e injetam abates da Maré; não são uma run inteira.
- A dica entra na fila de avisos longos: se a epígrafe da fase ainda estiver na tela, espera atrás dela (na prática a primeira dica só sai depois de 12 s).
- **Não verificado (humano):** se 7 dicas incomodam, se o texto de cada uma é claro, e se o intervalo de 90 s é bom. É o que a R5 (jogador novo) mede.
- **Proposta, não feita:** a linha do rodapé "[Esc] Pausa → Extrair ×1.00" continua mandando abrir a pausa, embora X extraia direto. Trocar por "[X] Extrair ×1,00" deixa o rodapé coerente com o aviso do portal.
