---
id: "EVID-171"
title: "Passo pelas Sombras: blast_dice 3d8 -> 1d10 (testes e bot)"
created: "2026-10-06"
relations: ["[[SPEC-133-reducao-do-dano-do-passo-pelas-sombras]]", "[[SPEC-114-passo-pelas-sombras-copia-isca]]"]
cards: ["BAL-021"]
---

# EVID-171 — Passo pelas Sombras com `1d10`

## Mudança
`data/abilities.json` → `sylas.blast_dice`: `3d8` → `1d10`. Mais nada. Dano médio por inimigo atingido: ≈ 20 → ≈ 10 ((dado + INT 3) × 1,2 da passiva). Reverter = `3d8`.

## Verificação
- `tests/run_all.gd`: **0 falhas** (os avisos de RIDs vazados no encerramento já existiam).
- Bot (`tools/bot.gd -- sylas 4 dagruve 0.06 3`, 4 sementes), antes e depois:
  - **3d8:** chegaram `dagruve 4, docas 2, shedaklah 1`; níveis finais 4, 18, 7, 16.
  - **1d10:** chegaram `dagruve 4, docas 2, shedaklah 1`; níveis finais 20, 16, 5, 5.
  - Mesma distribuição de fases alcançadas e níveis dentro do ruído de n = 4 (erro-padrão da EVID-169 ≈ 0,12 fase com n = 60).

## Limite da medição
O bot **não mede** "a explosão limpa a fase 1" (não registra mortes por origem). A medição só mostra que a mudança não quebrou a progressão do Sylas. O efeito real (a horda sobrevivendo à primeira explosão) depende do playtest.

## Pendência
Aguarda playtest. Se ainda parecer forte, próximos botões: `blast_radius` (2,6) ou `decoy_aggro` (12).
