---
id: "EVID-160"
title: "Linha de base do bot por herói e fase sobre a base 0.3.1 (SPEC-125 B-001)"
created: "2026-10-05"
relations: ["[[SPEC-125-balanceamento-desafio-e-entretenimento]]", "[[EVID-156-b007-b008-recalibracao-das-fases-2026-10-04]]"]
cards: ["BAL-018"]
---

# EVID-160 — Linha de base (nada do jogo foi alterado)

Commit medido: `63b6394` (SPEC-122 e SPEC-124 inclusas). `tools/bot_curva.gd` com RNG global **semeado** (`seed(seed_v * 7919)`; única mudança, é ferramenta). Comando: `-- <heroi> 4 0.1 9 60 <meta>`; meta 0 = novato, 1 = veterano; 10 heróis × 4 sementes. Dados em [curva.csv](EVID-160-linha-de-base-bal-018-2026-10-05/curva.csv).

## Por fase (todas as passagens; morte% = mortes ÷ entradas na fase)

| Fase | Novato: n | morte | nv saída | PV mín | Veterano: n | morte | nv saída | PV mín | Alvo novato |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| Dagruve | 40 | **52 %** | 8,7 | 27 % | 40 | 45 % | 9,2 | 31 % | 30–40 % |
| Docas | 19 | **0 %** | 16,4 | 79 % | 22 | 0 % | 15,6 | 81 % | 30–40 % |
| Shedaklah | 18 | 17 % | 22,5 | 56 % | 22 | 27 % | 22,6 | 46 % | 45–55 % |
| Molor | 12 | 8 % | 31,7 | 52 % | 16 | 25 % | 28,8 | 51 % | 45–55 % |
| Durao | 9 | 11 % | 36,1 | 41 % | 10 | 0 % | 33,2 | 65 % | 45–55 % |
| Feng-tu | 7 | 0 % | 40,0 | 68 % | 10 | 0 % | 36,1 | 60 % | 55–65 % |
| Shendilavri | 6 | 0 % | 41,7 | 62 % | 7 | 0 % | 38,6 | 42 % | 55–65 % |
| Goranthis | 4 | 0 % | 43,8 | 43 % | 6 | 33 % | 41,8 | 29 % | 55–65 % |
| Pilares | 4 | 50 % | 52,0 | 12 % | 3 | 100 % | 47,7 | 0 % | 55–65 % |

## Por herói em Dagruve (morte%, nível ao sair; fases por run)

| Herói | Novato | Veterano |
|---|---|---|
| Durvall | 100 % · 6,8 · 1,0 | 75 % · 7,8 · 1,8 |
| Leoric | 100 % · 6,5 · 1,0 | 100 % · 5,8 · 1,0 |
| Nyrelia | 75 % · 5,8 · 1,8 | 75 % · 7,0 · 1,5 |
| Sylas | 75 % · 8,8 · 2,0 | 50 % · 12,0 · 2,2 |
| Zynara | 75 % · 6,5 · 3,0 | 25 % · 9,0 · 5,2 |
| Kayron | 50 % · 7,8 · 3,5 | 50 % · 9,0 · 5,0 |
| Brook | 25 % · 10,0 · 3,8 | 50 % · 8,8 · 3,0 |
| Bromnor | 25 % · 11,8 · 4,0 | 0 % · 12,0 · 3,8 |
| Korrak | 0 % · 11,5 · 4,5 | 0 % · 11,5 · 6,2 |
| Maelor | 0 % · 12,0 · 5,2 | 25 % · 9,5 · 4,2 |

## Leitura
1. **Dagruve é um filtro de heróis, não de dificuldade geral.** Durvall, Leoric, Nyrelia, Sylas e Zynara morrem no mapa 1 (novato 75 a 100 %), enquanto Korrak e Maelor nunca morrem ali. O 52 % global está acima da faixa de 30 a 40 % por causa de poucos heróis.
2. **Quem passa de Dagruve atropela as fases seguintes:** Docas 0 %, Feng-tu 0 %, Shendilavri 0 %, PV mínimo de 60 a 80 % em Docas. As fases do meio e finais estão **muito abaixo** da rampa-alvo nova (45 a 65 %).
3. **Viés de sobrevivente:** as fases tardias têm n de 3 a 12 (só passam os heróis fortes), então as taxas oscilam muito (ex.: Pilares 50 % e 100 % com n de 3 e 4). Conclusões do meio e do fim exigem mais sementes ou rodadas por herói forte.
4. Chefes: Docas, Durao, Feng-tu e Shendilavri caem em 74 a 260 s (veterano), contra 650 a 1277 s em Dagruve, Shedaklah e Molor: picos de tensão curtos e desiguais.
5. A média de PV mínimo ≥ 60 % em Docas, Durao e Feng-tu (veterano) indica que o dano dos inimigos não ameaça quem já engrenou.

## Limites
Bot é alarme, não juiz; 4 sementes; mapa 60×60, `dt` 0,1. Execução paralela (6 processos) sem erro de script. Esta rodada ainda foi disparada por `xargs` com saída bufferizada, mas todas as 20 combinações têm as 4 sementes.
