---
id: "EVID-217"
title: "PLAN-083 B-005: bot por herói da 0.5.0 e atribuição da queda à névoa de borda"
created: "2026-10-09"
spec: "SPEC-157"
cards: ["BAL-026", "MEC-039"]
status: "medido; os segredos não regridem; a queda vem da névoa de borda (SPEC-158, outra sessão); sem ajuste de número"
---

# EVID-217 — Bot por herói (B-005)

## Método

Mesma rodada do [EVID-208](EVID-208-b007-bot-por-heroi-e-ouro-2026-10-08.md): `tools/bot_curva.gd`, dt 0,08, 9 fases, lado 60, dez heróis, meta 0 e meta 1, sem Marcas, **15 sementes** por herói. Linha de base: a coluna "depois" do EVID-208 (`.atena/generated/v040-release/bot/after-b007-n15`). Medição nova: `.atena/generated/v050-release/bot/after-b005` (`run_b005.sh`, `aggregate.js`, `resultado-b005-n15.md`), feita com a **árvore de trabalho**, que além dos segredos (SPEC-157) traz alterações **não commitadas de outra sessão** (SPEC-158, névoa de borda; SPEC-159, setas).

## Resultado bruto

| Meta | Média linha de base (0.4.0) | Média desta árvore |
|---|---|---|
| Novato | 0,59 fases · nv 9,2 · 12,7 min | 0,16 fases · nv 4,5 · 3,7 min |
| Veterano | 0,96 fases · nv 11,7 · 17,7 min | 0,29 fases · nv 5,6 · 5,0 min |
| Ouro bruto por run (300 runs) | 215 | 54 |

Todos os heróis caem e as corridas morrem em Dagruve em poucos minutos (Korrak veterano: 2,3 → 0,6 fases; Bromnor: 2,1 → 0,1).

## Atribuição

Os segredos **não** mexem no bot (ele usa um lado único e não chama `place_scenery`; o `_place_secrets` não roda). Para isolar a causa, rodei Korrak e Bromnor (veterano, 5 sementes, mesma tabela) com `edge_band_tiles = 0` e `telegraph_tiles = 0` num script temporário (`bot_noedge.gd`, fora do repositório):

| Herói (veterano) | Linha de base | Árvore atual | Árvore atual **sem a faixa de borda** |
|---|---|---|---|
| Korrak | 2,3 fases | 0,6 | **2,2** |
| Bromnor | 2,1 fases | 0,1 | **2,0** |

Sem a faixa de borda o resultado volta ao da linha de base (diferença dentro do ruído do EVID-208). **A queda vem da névoa de borda do SPEC-158** (dano de 2% a 6% da vida por segundo nas 3 tiles junto às bordas): o piloto do bot anda e foge pelas bordas e morre ali. Isso não diz nada sobre um jogador humano, mas o dono precisa saber antes de publicar.

## Conclusão

- **Segredos, relíquias, Espelho e chaves:** sem regressão atribuível (a árvore sem a borda fica na linha de base). Nenhum número de `data/` foi mexido por este lote.
- **Névoa de borda:** é do PLAN-084 (outra sessão). O bot precisa ser ensinado a evitar a faixa, ou a medição deve rodar com a faixa desligada, antes de qualquer decisão de balanceamento ou de publicar a 0.5.0 com ela.
- O ouro por fonte (`gold_src`) cai junto com a sobrevivência; a meta de ouro segue **projetada** (sem pacote de tester com `gold_src`).

## Limites

O bot não explora, não usa Ecos nem câmaras e não joga em 84×84. A rodada sem borda tem 5 sementes e só dois heróis (suficiente para atribuir, não para medir). Dois heróis é um recorte: não repeti os dez sem a borda.
