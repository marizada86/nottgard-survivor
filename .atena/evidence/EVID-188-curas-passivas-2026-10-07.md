---
id: "EVID-188"
title: "Revisão das curas, parte 2: passiva Regeneração (BAL-022)"
created: "2026-10-07"
relations: ["[[EVID-178-curas-vela-sagrada-e-revisao-2026-10-06]]", "[[EVID-166-b001-medicao-das-bencaos-2026-10-06]]"]
cards: ["BAL-022"]
---

# EVID-188 — Regeneração (passiva) forte demais

Continuação do pedido do dono ("vamos avaliar as curas do jogo, estou achando muito fortes"). `tools/bal_bencaos.gd` agora aceita forçar uma passiva (`regeneracao:5`).

## Medição (bot, 10 heróis × novato/veterano × 6 sementes = 60 runs por célula, 4 fases; controle 0,72 fases, ≈ ±0,12; conta ≥ ≈ 0,33)

| Passiva forçada | Novato | Veterano |
|---|---|---|
| **Regeneração, +0,4 PV/s por nível (original)**, nível 3 | 1,37 | 1,60 |
| Regeneração original, nível 5 | 1,50 | 1,58 |
| Cota de Malha nível 5 (comparação) | 0,87 | 0,92 |
| Força nível 5 (comparação) | 0,85 | 0,92 |
| Regeneração **0,15** por nível, nível 3 / nível 5 | 1,07 / 1,23 | 1,18 / 1,40 |
| **Regeneração 0,12 por nível (adotada)**, nível 3 | **1,05** | **1,10** |
| Regeneração 0,12, nível 5 | **1,17** | **1,35** |

## Leitura
- A Regeneração original dava **+0,65 a +0,88 fase já no nível 3** e quase nada a mais no nível 5 (saturava); as passivas comuns dão +0,15 a +0,20 no nível 5.
- Baixar de 0,4 para 0,12 por nível leva o nível 5 a **+0,45 (novato) e +0,63 (veterano)**, e o nível 3 a +0,33 e +0,38. **Ainda é a passiva mais forte** (cura é o que mais sustenta o bot, o mesmo que se viu nas bênçãos e na Vela), mas o excesso caiu de ≈ +0,9 para ≈ +0,5.
- Passar de 0,15 para 0,12 quase não mudou o resultado (retorno decrescente): o ganho está em ter alguma regeneração, não no valor exato. Baixar mais exigiria tirar a passiva do pool de preferidas do bot ou mudar o desenho dela.

## Mudança
`data/passives.json`: Regeneração **+0,4 → +0,12 PV/s por nível**. Nenhum teste dependia do valor.

## Ainda sem medir (BAL-022)
Itens de regeneração (até +0,7 cada; únicos de +0,5 e +0,6), Machado de Xar'gath (roubo de vida 10%), fontes (40% de PV), poções, Provisões (40%), Curandeiro, Comunhão do Maelor.

## Limites
Bot (prefere Regeneração nos level-ups), 4 fases, passiva forçada. Sem playtest.

## Reversão
`git revert` do commit; valor antigo `regen: 0.4` em `data/passives.json`.
