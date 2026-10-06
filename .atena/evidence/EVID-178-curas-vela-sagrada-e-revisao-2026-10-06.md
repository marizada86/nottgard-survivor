---
id: "EVID-178"
title: "Revisão das curas: Vela Sagrada, Julgamento da Glória e barreira do excesso de cura (pedido do dono)"
created: "2026-10-06"
relations: ["[[SPEC-129-dinamismo-bencaos-divinas-e-eventos]]", "[[EVID-166-b001-medicao-das-bencaos-2026-10-06]]", "[[EVID-170-b003-novas-bencaos-e-rebalanceamento-2026-10-06]]"]
cards: ["BAL-022", "BAL-019"]
---

# EVID-178 — Curas muito fortes (relato do dono)

**Origem:** o dono (2026-10-06): "a vela só deveria curar ao causar dano e está curando muito, deixando imortal; já foi alterado?" e "vamos avaliar as curas do jogo, estou achando muito fortes". Não havia alteração anterior (a Vela só mudou na criação, commit `43a630c`).

## Diagnóstico (leitura do código)
`Battle._fire_nova` curava em **todo disparo**, mesmo sem inimigo no alcance, se o herói estivesse ferido; vale para a **Vela Sagrada** (cura 3, até 8 no nível máximo, a cada 3 s) e para o **Julgamento da Glória** (6 a cada 3,2 s, evolução da Sentença de Lliira do Brook). A recarga menor (`cd_pct`) multiplicava a cura. Fontes comparáveis: Regeneração +0,4 PV/s por nível; itens até +0,7 PV/s; Bênção da Cura (antes) +0,8 PV/s.

## Mudanças
1. **Condição:** a nova só dispara e só cura se **feriu ao menos um inimigo**; a cura é **uma por disparo**, não por alvo (`core/battle.gd`, teste `tests/test_nova_heal.gd`).
2. **Números** (`data/weapons.json`): Vela Sagrada cura base **3 → 1**, níveis `+1, +2, +2` → `+0,25, +0,25, 0` (nível máximo **8 → 1,5 PV por disparo**, ≈ 0,5 PV/s); Julgamento da Glória **6 → 2**. O número flutuante de cura passou a arredondar para no mínimo 1.
3. **Barreira do excesso de cura:** `OVERHEAL_BARRIER_CAP` **0,25 → 0,10** do PV máximo (`core/battle.gd`); atinge a Bênção da Cura e o Resto da Tarn.

## Medição (bot, 10 heróis × novato/veterano × 6 sementes = 60 runs por célula, 4 fases)
`tools/bal_bencaos.gd` agora aceita forçar uma arma (`vela_sagrada:5`). Controle (sem nada): **0,72 fases**, erro-padrão ≈ 0,12; só conta ≥ ≈ 0,33.

| Configuração (nível 5 forçado) | Novato | Veterano | Observação |
|---|---|---|---|
| Vela original (cura 8, curava sem alvo; **medida só com a condição já corrigida**) | 1,88 | 1,98 | +1,16 / +1,26 |
| Vela, cura na metade (4,5) | 1,75 | 1,77 | quase não muda |
| Vela, cura ≈ 0 (diagnóstico) | 0,75 | 0,88 | ≈ controle: **o poder da Vela era quase só a cura** |
| Sentença de Lliira (nova sem cura, comparação) | 1,13 | 1,52 | +0,41 / +0,80 |
| **Vela, cura leve (adotada)** | **1,30** | **1,40** | +0,58 / +0,68, no nível de uma nova comum |

Barreira (efeito `overheal_shield`, com a bênção forçada):

| Bênção | Antes (teto 25%) novato / veterano | **Depois (teto 10%)** | vs controle |
|---|---|---|---|
| Bênção da Cura | 0,97 / 1,33 | **0,92 / 1,18** | +0,20 / +0,46 |
| Resto da Tarn | 0,88 / 1,22 | **0,82 / 1,18** | +0,10 / +0,46 |

## Leitura
- Exigir inimigo no alcance **sozinho não basta**: a Vela original com a condição já corrigida ainda rendia +1,2 fase. O poder estava na quantidade de cura (≈ 2,7 PV/s no nível máximo, até ≈ 7 PV/s com recarga reduzida).
- A resposta ao tamanho da cura é **forte e quase linear**: cada ~1,5 PV/s de cura vale ≈ +1,0 fase para o bot.
- **Medição do "antes" exato** (cura sem alvo) **não foi feita**: a "original" aqui já exige alvo. Em jogo real, com cura sem alvo, o efeito era pior que o medido.
- Com as mudanças, **Bênção da Cura e Resto da Tarn** ficaram abaixo de +0,5 no veterano (+0,46), fechando a pendência do EVID-170.

## Ainda não avaliado (a pedido do dono: "as curas do jogo")
Regeneração (+0,4 PV/s por nível, sem teto de nível), itens de regeneração (até +0,7 cada), Machado de Xar'gath (roubo de vida 10%), fontes, poções e "Provisões" (40% de PV), Curandeiro, Comunhão do Maelor, Fome do Abismo (já rebaixada). A medição por fonte fica para uma próxima rodada; pedir decisão ao dono sobre a ordem.

## Limites
Bot, só 4 fases, arma forçada no nível 5 (no jogo vem de um level-up), sem playtest. O bot pode subestimar a Vela de quem a evolui mais tarde.

## Reversão
`git revert` do commit; os valores antigos estão no diff (`data/weapons.json`, `OVERHEAL_BARRIER_CAP`).
