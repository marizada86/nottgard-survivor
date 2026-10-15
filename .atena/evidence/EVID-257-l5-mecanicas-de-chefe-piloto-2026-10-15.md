---
id: "EVID-257"
title: "L5 piloto: mecânicas de chefe no estilo de raide (Sacerdote, Guardião Alado e Blogbog)"
created: "2026-10-15"
relations: ["[[PROPOSTA-l5-mecanicas-de-chefe-2026-10-14]]", "[[EVID-250-relato-t05-mariz-v040-2026-10-14]]", "[[EVID-256-l4-inimigos-legiveis-e-movimentos-novos-2026-10-14]]"]
cards: ["IN-091", "IN-093", "BAL-001", "BAL-028"]
content_state: DRAFT
---

# EVID-257 — L5 piloto (aprovado pelo dono em 2026-10-14; sem commit)

Aprovação do dono sobre a [proposta L5](../vault/drafts/PROPOSTA-l5-mecanicas-de-chefe-2026-10-14.md): piloto de 3 chefes, verbo de interrupção pela habilidade Q (V4), enrage suave (V7), e orçamento de caos como regra permanente **que pode crescer conforme os mapas avançam**. Tudo atrás de `boss_mech.enabled` em `data/difficulty.json`, com um interruptor por verbo.

## O que mudou
| Verbo | Regra | Chefes |
|---|---|---|
| V1 Totem | 2 turíbulos de 45 PV a 3 a 4 tiles do chefe; enquanto de pé o chefe recebe **30% menos dano**; linha ligando cada turíbulo ao chefe | Sacerdote, fase 70% |
| V4 Conjuração interrompível | Barra de 2,5 s sobre o chefe; **usar a habilidade ativa** (ou qualquer atordoamento) na janela interrompe e atordoa o chefe por 2 s; senão, golpe pesado em toda a arena (`2d8` do Sussurro, `3d6` do Grito Abissal) a cada 15 a 16 s | Sacerdote e Guardião, fase 35% |
| V3 Varredura | 1 s de aviso (linha fina) e uma linha larga que gira 90° em 2,2 s a partir do chefe; ferida a cada 0,7 s a quem estiver nela | Guardião, fase 70% |
| V5 Imunidade e servos | 3 servos nascem em volta; o chefe fica **imune** (escudo azul e linhas) até todos morrerem ou 12 s; substitui o invocar antigo de 5 servos | Blogbog, fase 70% |
| V2 Quadrantes | 2 de 4 quadrantes em torno do chefe acendem por 1,5 s e explodem (`2d8`); o herói precisa estar nos outros 2 | Blogbog, fase 35% |
| V7 Enrage suave | Depois de 90 s de luta, +8% de dano do chefe a cada 15 s, teto +40%; aviso a cada degrau | todos os chefes com mecânica |

**Orçamento de caos (código, `BossMechanics.budget_for_order`):** 2 mecânicas ativas ao mesmo tempo nas fases de ordem 0 a 2, 3 nas fases 3 a 5 e 4 nas fases 6 a 8. Um verbo que dispara com o orçamento cheio **espera 1 s e tenta de novo**.

**Fase 35% troca o conjunto:** os verbos repetidos da fase anterior param quando a nova fase começa (a assinatura entra em 70% e é substituída em 35%).

## Arquivos
`core/boss_mechanics.gd` (novo), `data/boss_mechanics.json` (novo), `data/difficulty.json` (`boss_mech`), `data/enemies.json` (`totem_de_chefe`), `core/battle.gd` (ganchos: criação ao nascer o chefe, passo, fases, blindagem, imunidade, ativa, enrage e limpeza), `ui/overlay.gd` (`draw_fx`), `data/audio_manifest.json` (eventos do turíbulo), `assets/enemies/totem_de_chefe.png` (**provisório**, cópia da arte do candelabro).

## Verificação
- `tests/test_l5_boss_mechanics.gd`: orçamento (2, 3, 4) e espera com orçamento cheio; turíbulos (2 a 70%, 30% de blindagem, somem com o chefe); imunidade e substituição do invocar antigo; conjuração com e sem interrupção e atordoamento; varredura fere quem está na linha; quadrantes (seguro × aceso); enrage (90 s, +8%, teto +40%); interruptores. **Mutações:** `skip` desligado, ativa sem interromper, enrage sem efeito e totem sem blindagem fazem o teste falhar em 2 pontos cada; restaurado, passa. Suíte completa: **0 falhas**.
- Capturas em janela real (`tools/capture_l5.tscn`, `.atena/generated/mariz-playtest/l5_*.png`): turíbulos com linha, barra "Sussurro (Q interrompe)", varredura, escudo de imunidade e quadrantes vermelhos.

## `bot_curva` com o L5 (L2 e L4 ligados; 4 heróis × 6 sementes; metas 0 e 1)
| Cenário | Fases alcançadas, novato | Fases alcançadas, veterano | Dagruve passou (novato / veterano) |
|---|---|---|---|
| L5 desligado (base) | 1,63 | 2,29 | 33% / 46% |
| L5 ligado, **bot cego** às mecânicas | 1,17 | 1,38 | 17% / 29% |
| L5 ligado, **bot atento** (desvia de varredura e quadrantes e guarda a ativa para interromper) | **1,46** | **1,79** | **29% / 33%** |

Tabelas: `.atena/generated/mariz-playtest/bot-l5/resumo-l5.md` (cego) e `bot-l5b/resumo-l5b.md` (atento).

**Leitura honesta**
- Quem **ignora** as mecânicas sofre muito (pior caso, o bot cego): o chefe deixa de ser um saco de PV, que era o pedido.
- Quem **reage** perde 10% a 20% das fases alcançadas pelo bot, e a Dagruve fica 4 a 13 pontos mais difícil. É dificuldade a mais **de propósito**, e o bot atento ainda é um jogador ruim (morre no nível 3 a 5).
- **Amostra pequena** (24 por célula) e **sem a régua de 12 heróis**: sinal de alarme, não aceite de equilíbrio.
- O primeiro chefe é o ponto a olhar: o Sacerdote ficou o mais mexido pelo bot. Botões, do mais para o menos suave: `verbs.cast` desligado na Dagruve (tirar a conjuração de 35%), `shield` de 0,3 para 0,2 em `data/boss_mechanics.json`, `enrage.start_s` de 90 para 120.

## Pendências
- **Humano:** achar a luta "caótica na medida" (o dono aceitou caos moderado), a conjuração legível (barra e texto), a varredura justa e a Q de interromper gostosa de usar. Segundo olho: o Mariz, mais Daniel ou Hiago.
- **Arte e som próprios** do turíbulo (hoje arte e sons emprestados): pedir como ART-049 (junto com a abertura do Guardião) e um som de queda de turíbulo.
- **Fora do piloto** (cada um com 1 verbo novo, depois do playtest): Zuggtmoy, Molydeus, Discípulo Pestilento, Malcanthet, Socothbenoth, Síntese Abissal.
- **Pilar do cenário bloqueando a varredura** (V3 da proposta) não foi feito: hoje só dá para desviar.
