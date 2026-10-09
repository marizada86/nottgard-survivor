---
id: "EVID-225"
title: "PLAN-088 B-002: linha de base nova do bot por herói (12 heróis) e o efeito da faixa de névoa"
created: "2026-10-09"
spec: "SPEC-162"
cards: ["BAL-016", "BAL-018", "BAL-027", "BAL-028"]
status: "medido local; nenhum número de balanceamento alterado; proposta aguarda o dono"
---

# EVID-225 — Bot por herói, estado de `240f629`

## Método

`tools/bot_curva.gd` (bot que recua da faixa de névoa, EVID-220), dt 0,08, 9 fases, lado 60, **12 heróis**, metas 0 (novato) e 1 (veterano), **15 sementes**, sem Marcas. Scripts e CSV em `.atena/generated/plan-088/` (`run_bot.sh`, `aggregate.js`, `compare.js`, `se.js`, `stages.js`, `bot/`). Linha de base: EVID-208 (`v040-release/bot/after-b007-n15`); o agregador reproduz o 0,59 e o 0,96 do EVID-208.
Medida de "fase vencida" = resultado `passou` por semente (média das 15). O bot não explora, não usa Ecos e não joga em 84×84; serve para comparar heróis e versões entre si, **não** para dizer se um jogador acha o jogo difícil nem divertido.

## Resultado (fases vencidas · nível máximo · minutos por run)

| Herói | Novato: base EVID-208 | Novato: agora | Veterano: base EVID-208 | Veterano: agora |
|---|---|---|---|---|
| Durvall | 0,07 · nv 5,3 | 0,13 · nv 4,9 | 0,20 · nv 5,9 | 0,00 · nv 5,3 |
| Brook | 0,33 · nv 8,3 | 0,33 · nv 6,9 | 0,93 · nv 11,9 | 1,20 · nv 13,7 |
| Maelor | 1,00 · nv 12,1 | 1,33 · nv 14,5 | 1,27 · nv 13,9 | 1,67 · nv 16,7 |
| Sylas | 0,80 · nv 10,9 | 0,40 · nv 9,5 | 1,13 · nv 14,3 | 0,67 · nv 12,0 |
| Kayron | 0,47 · nv 8,1 | 0,80 · nv 9,7 | 1,00 · nv 11,5 | 0,13 · nv 7,1 |
| Korrak | 2,13 · nv 20,1 | 1,53 · nv 16,4 | 2,27 · nv 21,0 | 2,67 · nv 22,8 |
| Leoric | 0,20 · nv 6,0 | 0,07 · nv 4,9 | 0,33 · nv 7,7 | 0,20 · nv 6,5 |
| Nyrelia | 0,00 · nv 3,6 | 0,07 · nv 2,7 | 0,27 · nv 5,5 | 0,13 · nv 6,0 |
| Zynara | 0,07 · nv 5,0 | 0,13 · nv 4,8 | 0,13 · nv 6,7 | 0,13 · nv 5,9 |
| Bromnor | 0,87 · nv 12,1 | 1,20 · nv 14,2 | 2,07 · nv 18,6 | 1,60 · nv 16,4 |
| Arlindo (novo) | — | 0,00 · nv 2,3 | — | 0,27 · nv 4,4 |
| Erik (novo) | — | 0,27 · nv 10,3 | — | 0,73 · nv 13,6 |
| **Média dos 10 antigos** | **0,59** | **0,60** | **0,96** | **0,84** |

A rodada anterior com a árvore e a faixa de névoa sem o bot recuar (EVID-217) dava 0,16 e 0,29: o **bot que recua da faixa devolveu o novato à linha de base** (0,60 contra 0,59) e deixou o veterano −12% (0,84 contra 0,96).

Nenhum herói difere da linha de base por 2 erros-padrão **com 15 sementes** (o erro-padrão por herói é de 0,1 a 0,5 fase). Por isso os três que mais se mexeram foram refeitos com 45 sementes.

## Confirmação com 45 sementes: o que é ruído e o que é a faixa de borda

Rodei Sylas e Kayron (os maiores recuos do veterano) na árvore atual, na árvore atual **sem a faixa de borda** (`edge_band_tiles = 0`, `telegraph_tiles = 0`) e no commit `aa496f2` (worktree próprio, removido depois).

| Herói · meta | EVID-208 (15) | `aa496f2` (45) | Atual sem faixa (45) | **Atual com faixa (45)** |
|---|---|---|---|---|
| Sylas · novato | 0,80 ± 0,30 | 0,42 ± 0,12 | 0,40 ± 0,14 | 0,33 ± 0,07 |
| Sylas · veterano | 1,13 ± 0,29 | 0,82 ± 0,15 | 0,82 ± 0,15 | **0,44 ± 0,11** |
| Kayron · novato | 0,47 ± 0,17 | 0,29 ± 0,08 | 0,27 ± 0,07 | 0,42 ± 0,17 |
| Kayron · veterano | 1,00 ± 0,48 | 0,71 ± 0,19 | 0,69 ± 0,13 | **0,36 ± 0,13** |

Leituras:

1. A linha de base de 15 sementes estava **otimista** para os dois (Sylas 0,80/1,13 → 0,42/0,82 com 45 sementes no mesmo código). O código desde `aa496f2` não mexeu neles: "atual sem faixa" iguala `aa496f2`.
2. A faixa de borda **corta o veterano ao meio** (Sylas −46%, Kayron −48%; cerca de 2 erros-padrão em cada) e não mexe no novato. Hipótese não verificada: a meta 1 anda mais rápido e o piloto do bot encosta na faixa; não medi a causa dentro do bot.
3. Isso é um fato sobre o **bot**. Se uma pessoa joga como o bot, não sei. É exatamente o que o item 1 do roteiro de playtest observa (a faixa fere cedo demais?).

## Curva por fase (10 heróis antigos, 300 runs por rodada)

| Fase | Passagem: base EVID-208 | Passagem: agora |
|---|---|---|
| Dagruve | 44% (131/300) | 39% (117/300) |
| Docas | 50% (66/131) | 59% (69/117) |
| Shedaklah | 29% (19/66) | 19% (13/69) |
| Molor | 53% (10/19) | 92% (12/13) |
| Durão | 30% (3/10) | 17% (2/12) |
| Feng-tu a Goranthis | quase ninguém chega (no máximo 3 entradas) | idem |

As diferenças por fase têm amostra pequena e não passam de ruído, exceto a mensagem de sempre: **o bot quase não chega às fases 6 a 9**, então a curva depois da fase 5 (BAL-016) continua sem régua; só playtest humano mede.

## Proposta de ajustes (nenhuma aplicada)

| # | Proposta | Onde | Quando faz sentido | Risco |
|---|---|---|---|---|
| 1 | **Não mexer em números agora.** O bot não sustenta mudança de herói (ruído do tamanho do efeito) e o único sinal robusto, a faixa, só vale se humanos sofrerem igual. | — | Já | Nenhum |
| 2 | Se o playtest disser que a faixa fere cedo demais: `edge_band_tiles` 3 → 2 ou `start_dps_pct` 2% → 1% | `data/fog.json` (`edge`) | Depois do roteiro, item 1 | Baixo; desfaz-se sozinho |
| 3 | Ensinar o bot a recuar mais cedo na meta 1 (ou medir a causa), para a régua parar de punir só o veterano | `tools/bot_curva.gd` | Antes da próxima rodada de balanceamento | Baixo (ferramenta) |
| 4 | Passar a usar **45 sementes** em qualquer decisão por herói (15 têm erro-padrão de 0,1 a 0,5 fase) | Regra em `BALANCEAMENTO.md` | Já | Nenhum |
| 5 | Grupo fraco constante (veterano < 0,3 fase: Durvall, Nyrelia, Zynara, Leoric e Arlindo) já era assim no EVID-208; **não** é regressão. Decidir com playtest se algum precisa de ajuste (Arlindo continua com a pergunta do BAL-027). | `data/heroes.json` | Depois do playtest | Médio |

Dados do Erik: meio do grupo (0,73 veterano, nível 13,6), sem anomalia. Arlindo: 0,27 e nível 4,4, na faixa de Zynara e Nyrelia (BAL-027 mantido).

## Verificação

Sem código nem dado de jogo alterado nesta rodada. Os scripts do bot (`bot_curva.gd`, `bot_curva_noedge.gd`) rodaram fora da suíte. Suíte do lote 1: `0 falha(s)`, smoke ok (EVID-224).
