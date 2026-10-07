---
id: "EVID-190"
title: "Korrak: cura do Impacto de Xar'gath e do machado reduzidas (pedido do dono)"
created: "2026-10-07"
relations: ["[[EVID-189-xargath-roubo-de-vida-2026-10-07]]", "[[EVID-188-curas-passivas-2026-10-07]]"]
cards: ["BAL-022", "BAL-018"]
---

# EVID-190 — Cura do Korrak

**Pedido do dono (2026-10-07):** "reduza a cura de Korrak para balancear". Regra vigente: curas só descem ([[feedback-nao-melhorar-curas]]).

## Fontes de cura do Korrak
1. **Machado de Xar'gath** (arma): roubo de vida sobre o dano causado. Era 10% (+5% no nível 4); o EVID-189 já levou a 5% (+2,5%).
2. **Impacto de Xar'gath** (habilidade ativa, a cada 14 s): 3d10 em área com roubo de vida de **20%** por inimigo atingido (`data/abilities.json`).

## Medição (bot, Korrak, 10 sementes, 4 fases; novato / veterano)
| Configuração | Novato | Veterano | Nível final |
|---|---|---|---|
| Machado 5%, Impacto 20% (estado do EVID-189) | 1,80 | 2,20 | 18,2 / 19,1 |
| Machado 5%, Impacto 10% | 1,70 | 2,20 | 17,5 / 19,1 |
| Machado 5%, Impacto 5% | 1,60 | 2,10 | 17,2 / 18,7 |
| **Machado 3% (+1,5% no nível 4), Impacto 10% (adotado)** | **1,60** | **2,00** | 17,1 / 17,9 |
| Referência: Machado 0% / nível 4 +0% | 1,30 | 1,70 | 14,8 / 16,3 |
| Referência: demais heróis (EVID-166, sem bênção) | ≈ 0,5 | ≈ 0,5 | — |

*Nota:* a primeira rodada da tabela do Impacto saiu idêntica nas três variantes porque o padrão do ajuste automático não casou com o espaço do JSON; foi corrigido e refeito (esta tabela é a refeita).

## Leitura
- **O Impacto pesa pouco** na sobrevivência (20% → 5% tira só 0,2 fase); **o machado é a cura que importa** (10% → 0% tira ≈ 0,8).
- Com tudo reduzido (machado 3%, Impacto 10%), o Korrak cai de 2,10 / 2,50 (original) para **1,60 / 2,00** (−0,5), mas **continua bem acima dos demais heróis**: mesmo com roubo de vida zero ele mede 1,30 / 1,70. O resto vem do **dano e da queimadura do machado** (1d10 + queimadura, FORÇA 18, Fúria Goliath +20% de dano).
- **Reduzir cura sozinha não nivela o Korrak**: para isso seria preciso mexer em dano, queimadura ou na passiva. Não mexi (decisão do dono; BAL-018).

## Mudanças
`data/weapons.json`: `machado_de_xargath` `lifesteal` 0,05 → **0,03** e bônus do nível 4 0,025 → **0,015**. `data/abilities.json`: Impacto de Xar'gath `lifesteal` 0,20 → **0,10**. Somente reduções.

## Validação
Medição acima feita com o jogo íntegro. A suíte `tests/run_all.gd` não pôde ser rodada ao final: outra sessão está com `core/battle.gd` em edição (`AbyssMarks` ainda sem registro de classe), o que faz o script não compilar; a minha mudança é só de números em JSON. **Rodar a suíte quando essa sessão terminar.**

## Reversão
`git revert` do commit.
