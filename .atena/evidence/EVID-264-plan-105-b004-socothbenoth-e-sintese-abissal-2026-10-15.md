---
id: "EVID-264"
title: "PLAN-105 B-004: mecânicas de Socothbenoth (Goranthis) e da Síntese Abissal (Pilares)"
created: "2026-10-15"
relations: ["[[PLAN-105-mecanicas-dos-outros-chefes-2026-10-15]]", "[[EVID-261-plan-105-b003-discipulo-pestilento-e-malcanthet-2026-10-15]]", "[[EVID-260-plan-105-b002-zuggtmoy-e-molydeus-2026-10-15]]"]
content_state: DRAFT
---

# EVID-264 — PLAN-105, lote B-004 (aprovação por lote; gate G-L5-3 aprovado em 2026-10-15; sem commit)

Com este lote os **9 chefes** têm mecânicas (piloto + B-002 + B-003 + B-004).

## O que mudou
| Chefe (ordem, orçamento) | Fase de 70% | Fase de 35% (troca o conjunto) |
|---|---|---|
| **Socothbenoth** (Goranthis, 7, orçamento 4) | **Quadrantes** (3 de 4 acesos, 2d8, recarga 12 s) **e 2 Âncoras de Juiblex** (80 PV) que **curam** o chefe 1% por segundo, teto de 20%; `skip` das poças soltas antigas | **Verdade desfeita** interrompível (3d8, recarga 18 s) **e 6 Ilusões do Paraíso** de 40 PV com o chefe imune até caírem; `skip` do invocar e do anel de 14 projéteis antigos |
| **A Síntese Abissal** (Pilares, 8, orçamento 4, modo infinito) | **3 poças-fonte de Lodo de Astherion** (80 PV) que curam 1% por segundo, **teto de 10%**, **e varredura** de 1 feixe (2d6, recarga 12 s); `skip` das poças e dos golpes soltos antigos | **Armadura do Psíquico** (conjuração interrompível; sem interromper, 40% de redução por 4,5 s, recarga 24 s) **e quadrantes** (2 acesos com poça); `skip` do anel de 20 projéteis |

Código novo: **início próprio do enrage por chefe** (`"enrage": {"start_s": N}` no chefe; Socothbenoth 135 s e Síntese 180 s, o geral é 90 s), porque as lutas tardias duram mais.

## Ajustes feitos neste lote depois da primeira medição (sem eles os chefes ficavam duros demais)
Primeira leitura da sonda: a Síntese causava de 2,5 a 3 vezes o dano e a luta passava de 280 s. Mudei: **tirei a Marca da Síntese em 35%** (de 3 verbos para 2, abaixo do teto de 4); varredura 2d8 → 2d6; cura do Lodo com teto de 10%; armadura a cada 24 s e por 4,5 s; recarga dos quadrantes 10 → 12 s e do Grito 16 → 18 s no Socothbenoth; enrage mais tarde.

## Verificação
- `tests/test_l5_b004_bosses.gd`: orçamento 4 nos dois; substituição das ações antigas (poças, golpes soltos, invocar, anéis); 2 Âncoras e 3 Lodos nomeados que curam e não blindam; 3 quadrantes; 6 ilusões de 40 PV e chefe imune; conjuração; armadura (fator 0,6) sem interromper; orçamento nunca estoura; **modo infinito** (o chefe repetido recebe mecânicas novas). **4 mutações** (sem `skip` do anel, armadura vira golpe, 2 quadrantes, ilusão de 1 PV) falham no ponto certo. Suíte completa: **0 falhas**.
- Capturas em janela real (`tools/capture_l5_b004.tscn`, `.atena/generated/mariz-playtest/l5_b004_*.png`).
- Um caso de borda achado e tratado **só na sonda e na captura**: no Pilares (modo infinito) o diretor usa a primeira onda no "pinga-pinga" do chefe, então uma fase sem ondas dava erro. Não afeta o jogo (as ondas existem).

## Medição (`tools/probe_boss_fight.gd`, Kayron de nível 12 com armas à distância, 6 sementes, teto de 300 s, PV do chefe fixado em 3000, sem as ondas do L2 durante o chefe)
| Camada | Chefe | antes (caiu / morreu / tempo) | depois | Duração média | Dano médio recebido |
|---|---|---|---|---|---|
| 1 (dano +100%, PV +60, CA +4) | Socothbenoth | 1 / 4 / 1 | 0 / 6 / 0 | 153 s → 148 s | 883 → 667 |
| 1 | Síntese | 1 / 5 / 0 | 0 / 6 / 0 | 156 s → 109 s | 591 → 370 |
| 2 (dano +200%, PV +100, CA +6) | Socothbenoth | 6 / 0 / 0 | **5 / 0 / 1** | 135 s → **266 s** | 702 → **1397** |
| 2 | Síntese | 5 / 1 / 0 | **1 / 5 / 0** | 152 s → **227 s** | 700 → **1242** |
| 2, sem enrage | Socothbenoth | 6 / 0 / 0 | 4 / 0 / 2 | 135 s → 267 s | 702 → 1512 |
| 2, sem enrage | Síntese | 5 / 1 / 0 | 4 / 2 / 0 | 152 s → 249 s | 700 → 1405 |

**Leitura honesta**
- **Socothbenoth** ficou em "duro, mas vencível": a luta dobra de duração e o dano dobra; 5 de 6 caem.
- **A Síntese ficou o ponto mais duro do jogo**: com o enrage suave os 6 morrem em 5 (e sem ele 4 caem). A causa é a **duração** (cura do Lodo, armadura e quadrantes empurram a luta para 4 minutos) e, depois, o enrage. É o chefe final e o dono pediu mais dificuldade, mas **este é o primeiro candidato a alívio** se o gate disser que passou do ponto.
- Na camada 1 (herói mais fraco) **os dois chefes matam o herói da sonda também "antes"** (4 a 5 de 6): a camada 1 é fraca demais para os mapas 7 e 8; o resultado vale pela direção, não pelo número.
- O desvio da sonda é fraco (pior que o de um humano que lê os avisos); trate como **teto de ameaça**. 6 execuções por célula, herói sintético, sem a régua de 12 heróis.

**Botões** (em `data/boss_mechanics.json`; do mais suave ao mais forte), se a Síntese pesar: `enrage.start_s` de 180 para 240; `heal_cap_pct` do Lodo de 0,1 para 0,05; `cd` da armadura de 24 para 30 s; tirar os `quadrants` de 35% (fica só a armadura).

## Gate G-L5-4 (seu)
Jogar Goranthis e Pilares até o chefe e dizer:
1. **Socothbenoth:** quadrantes e Âncoras ao mesmo tempo (70%) e 6 ilusões com o Grito (35%) estão no "caótico na medida"?
2. **Síntese:** a luta longa com Lodo, armadura e quadrantes é épica ou arrastada? A Armadura do Psíquico faz você querer usar a Q?
3. **Pilares (modo infinito):** o chefe volta com as mesmas mecânicas a cada repetição; isso funciona?

## Pendências
- B-005 (equilíbrio do conjunto, régua de 12 heróis) só com o seu gate.
- Arte e sons próprios de Âncora, Lodo e ilusões: ART-049 (hoje: arte do candelabro e sons de impacto).
- B-001 a B-004 acumulam **sem commit**.
