---
id: "EVID-151"
title: "Linha de base de XP, nível e raridade de itens (SPEC-122 B-001)"
created: "2026-10-04"
relations: ["[[SPEC-122-balanceamento-ritmo-inicial-xp-armas-e-raridade]]", "[[EVID-150-curva-base-em-escala-2026-10-03]]"]
---

# EVID-151 — Linha de base (nada do jogo foi alterado)

Commit medido: `8307924`. Nível por fase reaproveita as 335 passagens de [EVID-150](EVID-150-curva-base-em-escala-2026-10-03/curva.csv) (curva de XP não mudou desde então). Raridade: `tools/bal_itens.gd`, 4000 itens por tier, sorte 0, dados em [itens.csv](EVID-151-linha-de-base-xp-e-raridade-2026-10-04/itens.csv).

## 1. Nível (bot veterano, 10 heróis × 6 sementes)

| Fase | Nível ao entrar | Ao sair | Ganho | Duração média |
|---|---:|---:|---:|---:|
| Dagruve | 1,0 | 14,2 | 13,2 | 546 s |
| Docas | 15,9 | 23,6 | 7,7 | 359 s |
| Shedaklah | 23,6 | 35,5 | 11,9 | 947 s |
| Molor | 36,0 | 46,6 | 10,6 | 872 s |
| Durao | 46,7 | 53,5 | 6,8 | 662 s |

Leitura: o herói sai do 1º mapa no nível ~14 (≈9 min) e do 4º no ~47. Com `xp_need_for(lv) = 12 + 7·lv + 0,9·lv²` o custo por nível sobe, mas o XP por inimigo e a densidade de inimigos sobem mais rápido, então o nível dispara. Isto bate com "sobe de nível muito rápido".

## 2. Raridade dos itens por tier (% dos drops)

| Tier (mapa) | Comum | Mágico | Raro | Único |
|---|---:|---:|---:|---:|
| 0 Dagruve | 26,2 | 47,5 | 21,1 | 5,2 |
| 1 Docas | 22,5 | 47,0 | 23,8 | 6,7 |
| 2 Shedaklah | 19,1 | 45,3 | 25,6 | 10,0 |
| 3 Molor | 16,9 | 43,8 | 28,7 | 10,7 |
| 4 Durao | 14,1 | 42,7 | 29,2 | 14,0 |

Já no 1º mapa **1 em 4 drops é Raro ou Único** (26 %). Como o mapa 1 sorteia Únicos até o tier 1, saem Únicos de tier 1 (Lâmina da Digestão, Ampulheta, Manto do Pântano, Chicote Avarento) logo na primeira fase. Comuns somem quase ao final.

## 3. Poder por raridade (régua grosseira, só mods; ver cabeçalho de `bal_itens.gd`)

| Tier | Mágico | Raro | Único (sorteado) |
|---|---:|---:|---:|
| 0 | 2,75 | 5,62 | 2,68 |
| 2 | 3,66 | 7,95 | 3,18 |
| 4 | 4,42 | 10,49 | 3,36 |
| 8 | 5,92 | 15,18 | 3,38 |

- O poder do Raro **cresce com o tier** (afixos escalam) e o do Único é **fixo** (~3,4). Em todos os tiers o Único fica no nível do **Mágico** e **abaixo do Raro** (já no tier 0: 2,7 vs 5,6; no tier 8: 3,4 vs 15,2).
- Únicos de arma têm mods mínimos (Lâmina da Digestão 1,0; Martelo da Glória 2,0; Cajado dos Desejos 3,0), mas também trazem uma **arma/efeito próprio** (`weapon`) que esta régua não mede. Falta medir esse efeito (dano real do bot) antes de decidir se subir os mods ou o efeito.

## Conclusão para o balanceamento
- XP: confirma o relato (nv 14 após 1 mapa, 47 após 4). Parâmetros candidatos: curva mais íngreme e XP/inimigo menor.
- Raridade: confirma o relato de Hiago nas duas partes: Raro/Único cedo (26 % no mapa 1) e hierarquia invertida (Único ≈ Mágico < Raro).
- Pendente (para o lote B-005): medir o efeito das armas Únicas no dano do bot; medir também o poder das armas iniciais (B-003).

Humano decide; o bot é alarme.
