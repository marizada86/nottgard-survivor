---
id: SPEC-122
title: Balanceamento do ritmo inicial (XP, armas iniciais, eventos e raridade de itens)
status: implemented-uncommitted
origin: playtest-dono-e-hiago-2026-10-04
approval: aprovada pelo dono em 2026-10-04 (por lote)
plan: PLAN-056 (por lote)
---

# SPEC-122 (rascunho, aguarda aprovacao e escolha do nivel de aprovacao)

## Pedido (dono + playtester Hiago, 2026-10-04)
O jogo parece "modo facil", ja no comeco. Pontos:
1. Sobe de nivel rapido demais.
2. Armas iniciais deixam o heroi forte cedo demais (dano alto).
3. Acontecimentos do mapa (SPEC-118) e quebraveis/baus/fontes/altares aparecem demais.
4. Equipamentos Raros e Unicos aparecem cedo demais; a raridade nao faz sentido (arma Unica perde para arma de raridade inferior).
Decisoes do dono: atacar XP pela curva **e** pelo XP por inimigo; meta = dificuldade media desde o minuto 0.
Nota separada (nao entra aqui): ferreiro nao deve dar upgrade de magia; havera NPC proprio (vai para o backlog MECANICAS).

## Evidencia ja levantada
- Curva de XP: `xp_need_for(lv) = 12 + 7*lv + 0.9*lv^2` (core/battle.gd:239).
- Bot, durvall seed 2: Dagruve termina no nv 19 (de 1), Docas 22, Shedaklah 33, Molor 36. Em 4 mapas o heroi passa de nv 1 a 36.
- Raridade (core/items.gd `roll`): Unico = 5% + 2%*tier, e o pool inclui uniques de tier ate tier+1, entao ja na fase 1 saem uniques de tier 1. Raro = 22% + 3%*tier. Ou seja, ~1 em 4 itens e Raro ou Unico no primeiro mapa.
- Raro tem 3 afixos sorteados; Unicos tem 1 a 3 mods fixos pequenos (ex.: Lamina da Digestao = +1 forca; Chicote Avarento = +20% ouro). Por isso um Raro de 3 afixos supera varios Unicos. Os valores dos Unicos precisam subir ou os Raros, descer.

## Escopo proposto (a confirmar por lote)
- B-001 Medir: bot por heroi (nv por minuto, poder por mapa, % de itens raros/unicos por mapa) como linha de base. Sem mudar jogo.
- B-002 XP: curva mais ingreme e multiplicador de XP por inimigo (parametros em data/difficulty.json, nao hardcoded).
- B-003 Armas iniciais: reduzir dano/cadencia das armas de partida; medir o poder inicial.
- B-004 Frequencia: espacar acontecimentos do mapa e props interativos (intervalos e chance em dados).
- B-005 Raridade: Raro/Unico raros no inicio (pool de uniques por tier exato, chances menores no tier 0-1) e hierarquia clara (Unico > Raro > Incomum > Magico > Comum em poder medio). **Nova raridade Incomum (sugestao do dono, aprovada 2026-10-04)**: abaixo do Raro, acima do Magico (proposta: 2 afixos); exige cor, rotulo, RANK em core/items.gd, UI e testes.
- B-006 Reexecutar o bot, comparar com a baseline, atualizar QUESTIONARIO-006 e registrar EVIDENCIA.

## Criterios de aceite
- Nv medio ao fim do mapa 1 e do mapa 2 dentro de faixa acordada com o dono (definir apos B-001).
- Nenhum Unico abaixo da mediana de poder de um Raro do mesmo tier.
- Pelo menos < X% de Raro/Unico no tier 0 (X a definir apos B-001).
- Testes verdes; humano decide, bot e alarme.

## Pendencias BLOCKING
- Escolher nivel de aprovacao (por plano, lote ou etapa).
- Aprovar a SPEC (alterar balanceamento exige aprovacao do dono).

## Resultado (2026-10-04)
Lotes B-001 a B-006 executados, sem commit. Evidências: EVID-151, EVID-152, EVID-154, EVID-155. Incomum implementada (B-005). Pendente: recalibrar as fases 4 a 9 contra a curva nova (achado 1 do EVID-155), validar no playtest.

## Decisões da entrevista de alinhamento (dono, 2026-10-04)
| # | Tema | Decisão |
|---|---|---|
| E1 | Meta de morte (bot novato) | Rampa suave: Dagruve e Docas 20 a 30 %, subindo até 40 a 50 % no Durao e finais; veterano morre bem menos |
| E2 | Dagruve (10/20 mortes) | Manter como está; esperar o playtest do Hiago |
| E3 | Goranthis x Shendilavri | Foi acidente: corrigir `dmg_mult` do Goranthis acima do Shendilavri |
| E4 | 7 chefes sem apresentação | Pendente de arte; entra na fila de imagens depois do PLAN-053 |
| E5 | Preço de itens | Tabela por raridade e tier em `data/difficulty.json`, fora da fórmula do ranking |
| E6 | Rótulos de raridade | Corrigir já: Mágico, Incomum, Raro, Único com acento e maiúscula |
| E7 | Versão | Fatiar em minors: XP, armas e eventos (0.3.1) separados de raridade com Incomum (0.4.0) |
| E8 | Ordem | Recalibrar fases (SPEC-122 parte 2) e depois retomar o PLAN-053 (Shu) quando a cota liberar |
| E9 | Incomum | Cor verde e rótulo bastam; sem nome nem arte própria |
| E10 | NPC de upgrade de magia (MEC-041) | Próxima major; o ferreiro continua como está até lá |

Nota para o fatiamento (E7): XP, armas e eventos mexem só em números de JSON; a raridade com Incomum mexe em `core/items.gd` e na interface, então vai em commit próprio.

## Resultado da parte 2 (2026-10-04)
B-007 e B-008 executados, sem commit. Evidência: EVID-156. Multiplicadores finais das fases 3 a 8 em `data/stages.json`; Goranthis acima do Shendilavri; preço por raridade em dados e rótulos legíveis. Pontos abertos: Docas fácil, Feng-tu abaixo da rampa, confirmação com bot novato.
