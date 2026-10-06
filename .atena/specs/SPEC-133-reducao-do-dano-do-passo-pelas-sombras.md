---
id: "SPEC-133"
title: "Reduzir o dano da explosão do Passo pelas Sombras (Sylas)"
status: "implementada 2026-10-06; aguarda playtest (PLAN-066, EVID-171)"
created: "2026-10-06"
origin: "pedido direto do dono (Atena, Guided ADD), 2026-10-06"
relations: ["[[SPEC-114-passo-pelas-sombras-copia-isca]]", "[[BAL-021]]"]
---

# SPEC-133 — Dano do Passo pelas Sombras

Risco: **baixo** (um número em `data/abilities.json`).

## Origem
Dono (2026-10-06): a habilidade Q/RMB do Sylas Malafas "está praticamente matando tudo na primeira fase".

## Diagnóstico
- A cópia-isca atrai todo inimigo comum e móvel a até `decoy_aggro` (12) e explode em `blast_radius` (2,6) com `blast_dice` `3d8`.
- Dano médio por inimigo: (3d8 = 13,5 + INT 16 → +3) × 1,2 (passiva `dmg_pct`) ≈ **20**. Zumbi tem 14 PV; os inimigos comuns da fase 1 têm pouco mais. A isca junta a horda num ponto, então a explosão limpa quase tudo.

## Decisão do dono
`blast_dice`: `3d8` → **`1d10`** (média ≈ 10, cerca de 48 % menos). Aprovação **por etapa**.

## Fora de escopo
Raio, atração, duração, PV da cópia, `weaken`, recarga, atributo e tipo de dano permanecem. Nenhuma mudança de código.

## Aceite
- `data/abilities.json` → `sylas.blast_dice == "1d10"`; `desc` continua verdadeira (não cita dados).
- Suíte de testes sem novas falhas.
- Bot com o Sylas: a fase 1 deixa de ser limpa por uma explosão; medir antes/depois quando possível.
- Reverter = `blast_dice: "3d8"`.
