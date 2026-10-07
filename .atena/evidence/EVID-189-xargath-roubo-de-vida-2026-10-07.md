---
id: "EVID-189"
title: "Revisão das curas, parte 3: roubo de vida do Machado de Xar'gath (Korrak)"
created: "2026-10-07"
relations: ["[[EVID-188-curas-passivas-2026-10-07]]", "[[EVID-178-curas-vela-sagrada-e-revisao-2026-10-06]]", "[[EVID-160-linha-de-base-bal-018-2026-10-05]]"]
cards: ["BAL-022", "BAL-018"]
---

# EVID-189 — Machado de Xar'gath (roubo de vida)

**Direção do dono (2026-10-07):** não melhorar curas; só revisar as que podem estar desequilibrando o jogo (jogadores dizem que ficam imortais com cura suficiente).

## Por que este
O roubo de vida cura uma fração do **dano causado**, sem teto, e cresce com o dano. O Machado de Xar'gath (arma inicial do Korrak) tem **10%**, **15%** no nível 4. Nos dados já medidos, o Korrak é o herói que mais se destaca: **1,67 / 2,50** fases (novato / veterano, 6 runs; EVID-166, controle de cada herói) contra ≈ 0,5 dos demais; EVID-160 já mostrava Korrak com 0% de morte em Dagruve.

## Medição (bot, Korrak, 10 sementes, 4 fases, `tools/bal_bencaos.gd`; arquivo de dados restaurado no fim)
| Roubo de vida (base / bônus do nível 4) | Novato | Veterano | Nível final médio |
|---|---|---|---|
| **10% / +5% (original)** | 2,10 | 2,50 | 19,5 / 20,8 |
| **5% / +2,5% (adotado)** | 1,80 | 2,20 | 18,2 / 19,1 |
| 0% / 0% (diagnóstico) | 1,30 | 1,70 | 14,8 / 16,3 |

## Leitura
- O roubo de vida original valia **≈ +0,8 fase**; o valor adotado tira **≈ 0,3** e preserva a identidade da arma ("queima e devolve vida").
- **Mesmo sem roubo de vida o Korrak fica bem acima dos outros** (1,30 / 1,70): o resto da força vem do dano e da queimadura do machado, e do corpo a corpo. Isso é **equilíbrio entre heróis** (BAL-018), não de cura; **não foi mexido** aqui.
- Amostra pequena (10 sementes); sem playtest.

## Mudança
`data/weapons.json`: `machado_de_xargath` `lifesteal` **0,10 → 0,05** e bônus do nível 4 **+0,05 → +0,025** (apenas redução). `tests/run_all.gd`: 0 falhas.

## Não mexido (por decisão do dono)
Itens de regeneração, fontes, poções, Provisões, Curandeiro e Comunhão do Maelor: nenhuma melhora; ficam para o playtest.

## Reversão
`git revert` do commit.
