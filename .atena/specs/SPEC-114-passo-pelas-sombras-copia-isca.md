---
id: "SPEC-114"
title: "Passo pelas Sombras: cópia-isca explosiva do Sylas"
status: "implementada 2026-10-01; aguarda playtest e arte própria (ART-027)"
created: "2026-10-01"
relations: ["[[EVID-139-playtest-higor-qa-14b15e4-2026-10-01]]", "[[PLAN-050-pos-playtest-higor-2026-10-01]]"]
---

# SPEC-114 — Passo pelas Sombras com cópia-isca (MEC-029)

Risco: **médio**. Origem: relato do dono (IN-043): a habilidade Q/RMB do Sylas está fraca; sugeriu deixar uma cópia que atrai os inimigos.
Decisão do dono (2026-10-01): a cópia **explode**.

## Regra
- Ao usar o Passo pelas Sombras, o herói faz o deslize de sempre (enfraquece quem está no caminho) e deixa uma **cópia** onde estava.
- Inimigos comuns e móveis a até `decoy_aggro` (12) passam a **perseguir a cópia** em vez do herói. Chefes e inimigos imóveis a ignoram.
- Inimigos que alcançam a cópia a golpeiam (dados de ataque deles); ela tem `decoy_hp` (24) e dura `decoy_life` (4 s).
- Ao acabar o tempo ou os PV, a cópia **explode**: `blast_dice` (3d8 + INT) magico em `blast_radius` (2,6, afetado por área) e `weaken` 2.
- Recarga sobe de 10 s para 12 s.

## Dados
`data/abilities.json` → `sylas`: `decoy_life`, `decoy_hp`, `decoy_aggro`, `blast_radius`, `blast_dice`, `dtype`, `attr`.

## Código
`core/battle.gd` (`decoys`, `_spawn_decoy`, `_decoy_for`, `_hit_decoy`, `_update_decoys`, `_detonate_decoy`; `_enemy_step` usa a isca como alvo),
`ui/run.gd` (`_sync_decoys`: fantasma roxo do herói; evento `decoy_blast`).

## Teste
`tests/test_battle.gd`: cópia no lugar certo, atração só dentro do alcance, explosão por tempo e por destruição.
Bot (3 sementes, Dagruve): níveis de Sylas 12, 17 e 4 contra 4, 3 e 12 antes; uma semente chegou às Docas.

## Pendências
- Visual provisório: o próprio sprite do Sylas em roxo translúcido. Arte própria e VFX da explosão em ART-027.
- Inimigos à distância ainda atiram na direção da cópia; seus projéteis só ferem o herói (sem efeito na cópia).
- Conferir em run real e ajustar números no playtest.
