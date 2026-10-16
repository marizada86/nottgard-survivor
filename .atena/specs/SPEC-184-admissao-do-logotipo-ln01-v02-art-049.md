---
id: "SPEC-184"
title: "Admissão do logotipo LN01 v02 no menu inicial (ART-049)"
status: "IMPLEMENTADA localmente em 2026-10-16; aguarda a avaliação do dono (EVID-267)"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION   # PLAN-103 em B-002/S-008; dono: "fazer agora e voltar" e "por plano" em 2026-10-16
created: "2026-10-16"
revision: "r1 (2026-10-16)"
relations: ["[[PLAN-106]]", "[[SPEC-181]]", "[[ART-049]]", "[[PLAN-103]]"]
content_state: DRAFT   # preparação visual v02 aceita pelo dono ("atena aprovado", 2026-10-16); sem promoção a CANON
---

# SPEC-184 — Admissão do logotipo LN01 v02

## Origem

Pacote `claude-logo-handoff-v01.zip` (worktree Codex `31a7`; delivery PLAN-108/SPEC-183 do Codex, ainda não commitado lá).
Extraído em pasta nova; arte aceita: `LN01_runtime_candidate_v02.png`, 699×176 RGBA,
SHA-256 `7aeec54d…f7523a7f09` (conferido). Destino: `assets/ui/title/logo.png`, hash anterior `5d5214fb…4eecb5` (conferido).

## Escopo (por plano)

1. Backup do `logo.png` atual e cópia da candidata, sem alterar raster.
2. Importação no Godot; `ui/title.gd` não tem sequência `logo_NN.png` que mascare a peça; faixa y24..200, KEEP_ASPECT_CENTERED, sem deformar (699 px por proporção; `data/lettering.json` lista 1100×176 como máximo).
3. Captura do título real a 1280×720, suíte, evidência.

Fora: commit, push, build, exportação, promoção a CANON. O dono avalia a legibilidade (inclusive em celular); a prévia estática do pacote não prova isso.
