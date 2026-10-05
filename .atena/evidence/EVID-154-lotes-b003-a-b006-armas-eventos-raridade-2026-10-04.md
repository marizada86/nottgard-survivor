---
id: "EVID-154"
title: "SPEC-122 lotes B-003 a B-006: armas iniciais, frequência de eventos, raridade com Incomum e bot final"
created: "2026-10-04"
relations: ["[[SPEC-122-balanceamento-ritmo-inicial-xp-armas-e-raridade]]", "[[EVID-151-linha-de-base-xp-e-raridade-2026-10-04]]", "[[EVID-152-b002-xp-ritmo-de-nivel-2026-10-04]]"]
cards: ["BAL-017", "MEC-041"]
---

# EVID-154 — B-003 a B-006 (nada commitado)

Medição: `tools/bot_curva.gd`, bot **novato** (meta 0), 5 heróis iniciais (durvall, brook, maelor, sylas, kayron) × 4 sementes × 2 fases, `dt` 0,08. Amostra pequena: serve de alarme, não de veredito.

## B-003 — armas iniciais (`data/weapons.json`)
Primeiro corte (cd +0,2 e níveis 5 reduzidos) deixou o Dagruve letal: 9 mortes em 20 e Sylas 4/4. Recalibrado:
- Espada Sombria: recarga 1,3 → 1,4 (DPS nv1 5,77 → 5,36).
- Raio de Luz: recarga 1,4 → 1,5; nível 5 de `{dmg 3, cd -0,2}` para `{dmg 3, cd -0,1}` (DPS nv5 17,5 → ~15).
- Raio Enfraquecedor: **sem mudança** (já era a arma inicial mais fraca; cortar a Sylas só a fazia morrer).
- Armas de herói desbloqueável e as de área (Sentença de Lliira, Descarga Estelar) não foram tocadas.
Ferramenta: `tools/bal_armas.gd` (DPS esperado nv1 e nv5 por herói).

## B-004 — frequência (`data/difficulty.json`, `core/battle.gd`, `core/happenings.gd`)
- Baús, fontes e altares aleatórios: a cada 50–75 s e até 4 vivos → **80–115 s e até 3** (bloco `interactions`).
- Quebráveis: 22–36 s → **32–52 s**.
- Acontecimentos opcionais por fase (SPEC-118): sorteio de 1–2 → **0–1** (bloco `happenings`). Os fixos de cada fase continuam.
- Dois testes codificavam o comportamento antigo e foram atualizados para ler a configuração.

## B-005 — raridade (`core/items.gd`, `data/difficulty.json` bloco `rarity`, `ui/run.gd`)
- Nova raridade **Incomum** (2 afixos), entre Mágico e Raro. `RANK`: comum 0, mágico 1, incomum 2, raro 3, único 4. Cor verde; efeito de loot próprio.
- Chances por tier em dados. Tier 0: comum 49 %, mágico 33 %, incomum 14 %, **raro 4 %, único 0,3 %** (antes raro 21 %, único 5 %). Tier 4: raro 13 %, único 5 %.
- Únicos só saem do próprio tier para baixo (antes tier+1) e ganham 3 afixos sorteados além dos mods fixos.
- Baú do chefe: `Items.roll(..., "raro")` garante piso de Raro (o laço antigo de 12 tentativas falharia com Raro mais raro).
- Poder médio por raridade (régua de `tools/bal_itens.gd`), hierarquia respeitada em todos os tiers: tier 0: mágico 2,8 < incomum 4,3 < raro 5,6 < único 6,8; tier 4: 4,6 < 7,4 < 10,5 < 12,1; tier 8: 5,8 < 11,0 < 15,3 < 17,2.
- Novo `tests/test_rarity.gd` (ordem do RANK, chance no tier 0, hierarquia de poder, tier do Único, mods fixos, piso do baú, cor).
- O efeito próprio das armas Únicas (`weapon`) **não está na régua**; o Único real é um pouco melhor que a tabela.

## B-006 — bot final (bot novato, mesmas 20 runs por fase)

| Fase | Medida | Base (HEAD) | Após B-002+B-003 | **Final (B-002 a B-005)** |
|---|---|---:|---:|---:|
| Dagruve | Mortes / 20 | 6 | 6 | **10** |
| | PV mínimo médio | 44 % | 31 % | **29 %** |
| | Nível ao sair | 12,9 | 9,4 | **8,3** |
| Docas | PV mínimo médio | 66 % | 66 % | **53 %** |
| | Nível ao sair | 22,3 | 16,4 | **15,7** |

Leitura honesta: o nível e a tensão foram para onde o dono pediu (nível 8 no mapa 1). **As mortes no Dagruve do bot novato foram de 6 para 10 em 20.** Com 20 runs a diferença não é estatisticamente firme, mas o sentido é consistente com B-004 e B-005: menos baús, fontes e itens bons ajudam menos o bot, que nem usa loja. Por herói no Dagruve: kayron 3/4, durvall 3/4, brook 2/4, sylas 2/4, maelor 0/4.
Alavanca se o dono achar duro demais: `interactions.min_seconds` (80 → 65) e `rarity.incomum_base`.

Testes: `tests/run_all.gd` 0 falhas após cada lote. Humano decide; bot é alarme.
