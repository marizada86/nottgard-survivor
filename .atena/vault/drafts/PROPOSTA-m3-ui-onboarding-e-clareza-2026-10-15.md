---
id: PROPOSTA-M3
title: M3, UI, onboarding e clareza (B-004)
plan: PLAN-103 / B-004
content_state: DRAFT
status: proposta para aprovação do lote B-004 (2026-10-15)
---

# Proposta M3: UI, onboarding e clareza

## Critério de aceite do plano
"Um jogador novo explica sozinho level-up, bênção, extrair/descer e questlog." Só se verifica com um jogador novo de verdade (como o T05, jogador de WoW novo em survivors); não dá para fechar por teste automático.

## Ponto de partida (lido no código em 2026-10-15)
| Tema | Hoje |
|---|---|
| Primeira vez | Janela de boas-vindas com nome e guia do playtest; depois só o botão `?` ("Como jogar") |
| "Como jogar" | Uma parede de texto em 5 blocos (`Playtest.game_rules_text`): objetivo, controles, combate, decisões da run, progresso |
| Dentro da run | Painel do herói pulsa até abrir a ficha (C) pela primeira vez; ponteiro de eventos fora da tela; falas do herói por situação (barks); avisos de fase |
| Sistemas sem nenhuma dica no momento em que aparecem | Level-up com rerrolagem, altar (bênção + maldição), baú e troca de item, portal (extrair ou descer), Questlog "Missões", Favor, Maré do Abismo, fonte e ritual |
| UI | Padrão UiKit já na pausa, ficha C, HUD de status e título; **faltam as ofertas (level-up, altar, loja) e o HUD da run** no padrão (lote 3 da SPEC-165). A direção visual segue DRAFT |

## Rodadas propostas (um lote pequeno por rodada, teste, captura e commit próprios)
| Rodada | Conteúdo | Depende de imagem? | Decisão sua |
|---|---|---|---|
| **R1 Inventário dos primeiros minutos** | Tabela por sistema: quando o jogador o encontra, o que a tela diz, o que o jogador precisa deduzir, e capturas dos 10 primeiros minutos de duas fases. Só leitura e captura | não | nenhuma |
| **R2 Dicas de primeira vez** | Uma dica curta (até 90 caracteres) no primeiro encontro de cada sistema, com o ícone da tecla/botão do controle em uso; uma vez por perfil (`hints_seen`); nunca durante luta de chefe nem com vida baixa; opção "Dicas: Ligadas / Desligadas" e "rever dicas" em Opções; usa a camada de avisos já legível (M2 F-11) | não | quais sistemas ganham dica e o texto |
| **R3 Ofertas e HUD da run no padrão UiKit** | Level-up, altar e loja com a mesma moldura e hierarquia da ficha C; bênção e maldição lado a lado com cor e ícone; portal com "Extrair: recompensa X, seguro" e "Descer: multiplicador Y, risco" | não (moldura procedural; o botão ART-047 é imagem e fica no M5) | layout e textos |
| **R4 Promoção da direção visual** | Capturas finais e sua decisão DRAFT → CANON | não | aceite explícito |
| **R5 Teste com jogador novo** | Roteiro de 10 minutos e perguntas de verificação do critério acima; você ou o T05 joga e responde | não | quem joga |

## Riscos
- Dica demais vira ruído: teto de 1 dica a cada 90 s e no máximo 7 no total; sem repetir.
- Texto novo precisa de lore correta: nada de "cânone do mestre" nas dicas.
- R3 mexe em telas centrais; cada tela entra com captura antes e depois e reversão por commit.

## Recomendação
Aprovar o lote com **R1 e R2 já** (R1 é só leitura; R2 é o que mais move o critério de aceite). R3 depois do seu aceite das dicas, e R4/R5 com você jogando.

## Decisões pedidas (G-M3-1)
1. Aprova o B-004 com R1 e R2 agora?
2. Teto proposto para as dicas (1 a cada 90 s, no máximo 7): serve?
