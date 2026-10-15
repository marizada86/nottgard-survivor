---
id: "PROPOSTA-l5-mecanicas-de-chefe-2026-10-14"
title: "L5: mecânicas de chefe no estilo de raide, com orçamento de caos (proposta por frente)"
created: "2026-10-14"
status: "DRAFT: piloto aprovado pelo dono em 2026-10-14 e implementado local (EVID-257); rollout para os outros 6 chefes aguarda o playtest"
content_state: DRAFT
relations: ["[[AVALIACAO-playtest-t05-mariz-v040-2026-10-14]]", "[[EVID-252-avaliacao-medida-do-relatorio-t05-mariz-2026-10-14]]", "[[PROPOSTA-l4-inimigos-legiveis-e-movimentos-2026-10-14]]", "[[PLAN-103-demo-completa-e-polida-2026-10-14]]"]
---

# L5: mecânicas de chefe (estilo raide), com caos controlado

## Contexto novo (dono, 2026-10-14)
O Mariz é jogador de **WoW**, com bom raciocínio lógico e **nunca jogou jogos do tipo Vampire Survivors**. Logo, "talvez eu seja bom demais" **não** é leitura de veterano do gênero: o jogo está **realmente fácil**, e ele quer **mais mecânicas e mais dificuldade durante o chefe**. O dono aceita **luta de chefe um pouco caótica**, desde que **sem exagerar**.

Efeito nas conclusões anteriores:
- "Fácil demais" passa a ter **5 relatos independentes** (dono, Daniel, Manzi, e o Mariz, agora lido como jogador novo no gênero).
- O L2 (PV do chefe com o poder do herói, campo vivo) está na direção certa, mas **PV e densidade não são mecânica**; o Mariz pede o que uma raide dá: aprender, reagir, priorizar.
- A ressalva da avaliação sobre "jogador forte" cai; fica a ressalva de **não calibrar por uma pessoa só**.

## O que a leitura do código mostra
Todos os chefes combinam os mesmos 6 verbos (`aoe`, `ring`, `summon`, `charge`, `puddle`, `shoot`) e as mesmas 2 fases a 70% e 35% (EVID-252 §4.1). A lore do Vault dá semente temática para cada um e **não** pede mecânica fixa.

## Paleta de verbos de raide para um jogo de uma pessoa só
| # | Verbo | Como funciona no jogo | O jogador aprende a... | Custo |
|---|---|---|---|---|
| V1 | **Totem** | Objeto no chão que cura ou blinda o chefe (30% menos dano) até ser quebrado; linha ligando ao chefe | priorizar alvo | baixo (objeto quebrável já existe) |
| V2 | **Quadrantes** | O mapa em volta do chefe é dividido em 4; 2 acendem por 1,5 s e depois explodem | posicionar | médio |
| V3 | **Varredura** | Linha longa que gira 90° em 2 s a partir do chefe; pilares do cenário bloqueiam | contornar e usar o cenário | médio |
| V4 | **Conjuração interrompível** | Barra sobre o chefe por 2,5 s; usar a habilidade ativa (Q) nesse intervalo o atordoa 2 s; se não, golpe pesado em toda a arena | usar a ativa na hora certa | médio (liga a ativa ao chefe) |
| V5 | **Imunidade e adds** | Em 70% ou 35% o chefe fica imune até os adds morrerem (ou 12 s) | alternar alvo | baixo (reaproveita `summon`) |
| V6 | **Marca** | O herói recebe uma marca por 3 s; no fim explode em raio 3 onde ele estiver | sair de cima de poças e adds | baixo |
| V7 | **Enrage suave** | Depois de 90 s de luta o chefe ganha +8% de dano a cada 15 s (máx. +40%) e a Maré começa a avançar | não enrolar | baixo |

**Todo verbo** tem aviso de pelo menos **1 s**, linha ou círculo legível (padrão do L4) e **interruptor próprio** em `data/difficulty.json`.

## Orçamento de caos (a regra que impede o exagero)
- No máximo **2 mecânicas de chefe ativas ao mesmo tempo** (ex.: Quadrantes + adds; nunca Quadrantes + Varredura + Marca).
- No máximo **1 efeito sobre o herói** (Marca) por vez.
- **Teto de projéteis do chefe** (24) e de **adds do chefe** (uma fração do teto da fase), pelo `_combat_count` que já existe.
- **Nunca** duas mecânicas novas na mesma fase do chefe (70% ou 35%) além da assinatura.
- A mecânica **entra por fases**: abertura limpa (só o kit atual), fase 70% introduz a assinatura, fase 35% soma 1 verbo e **troca** outro (não empilha).
- "Impacto reduzido" desliga hit-stop e tremor, **não** os avisos.

## Piloto (3 chefes) antes de abrir todos
| Chefe | Assinatura (fase 70%) | Fase 35% | Semente do Vault |
|---|---|---|---|
| **Sacerdote da Mente Derretida** (Dagruve) | V1: 2 turíbulos de sangue blindam o chefe até quebrarem | V4: "Sussurro" interrompível; sem interromper, onda de medo curta | ritual de sangue, taça gigante, Ghaunadaur |
| **Guardião Alado** (Docas) | V3: asa em varredura com pilar de cenário | V4: grito abissal interrompível | ritual autossustentável do navio, Grito Abissal |
| **Blogbog** (Molor) | V5: o núcleo se parte em 3 e o chefe fica imune até fechá-los | V2: quadrantes de limo | núcleo verde, manifestação de Juiblex |

**Depois do piloto** (cada um com **1 verbo novo**): Zuggtmoy (V2, esporos), Molydeus (V6, marca de sentença; fraco a radiante), Discípulo Pestilento (V2 ou V6, peste), Malcanthet (V5 com ilusões), Socothbenoth (V2 e V5), Síntese Abissal (V1, lodo que absorve slimes; V4, "Armadura do Psíquico" como escudo a quebrar; presença de Ghaunadaur como medo em área). Só **depois** de o piloto passar no playtest.

## Medição
- Testes por verbo (aviso, efeito, teto, interruptor) e por chefe (assinatura só na fase certa; nunca mais de 2 ativas).
- Sonda no estilo `probe_boss_ttk`, mas com um herói que **se desvia dos avisos** (o do `bot_curva` desvia mal): tempo de luta e vida perdida por mecânica.
- Captura em janela real de cada mecânica.
- **Subjetivo e do dono (e do Mariz):** a luta está "caótica na medida" ou cansa?

## Decisões que preciso de você
1. **Piloto de 3 chefes** (Sacerdote, Guardião, Blogbog) com V1, V3, V4, V5 e V2, ou outro conjunto?
2. **V4 (interromper com a ativa)** entra? Dá peso à habilidade Q (casa com o L6, ativa que evolui), mas obriga o jogador a tê-la pronta.
3. **V7 (enrage suave)** entra já no piloto?
4. Aceita o **orçamento de caos** como regra permanente (2 mecânicas ao mesmo tempo, 1 marca, tetos)?
5. O Mariz joga o piloto antes do rollout, como segundo olho, junto de Daniel ou Hiago, para não calibrar por uma pessoa só?
