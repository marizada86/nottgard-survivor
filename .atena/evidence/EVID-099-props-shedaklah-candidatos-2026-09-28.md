---
id: "EVID-099"
title: "Candidatas de props de Shedaklah"
date: "2026-09-28"
status: "admitidas e verificadas"
relations:
  - "[[PLAN-035-geracao-de-assets-pendentes-2026-09-28]]"
  - "[[SPEC-062-fila-de-geracao-externa-de-assets]]"
  - "[[SPEC-065-props-de-shedaklah]]"
  - "[[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]]"
---

# EVID-099 — Candidatas de props de Shedaklah

## Método

O dono liberou o próximo grupo do plano. As três imagens foram geradas pelo
gerador de imagem nativo, uma chamada por prop, a partir dos prompts aprovados
de `ART-PROMPTS-024`, adaptados para saída RGBA com transparência nativa.

## Candidatas

| ID | Candidata |
|---|---|
| `esporo_01` | `.atena/generated/art-candidates/props/shedaklah/esporo_01_v01.png` |
| `esporo_02` | `.atena/generated/art-candidates/props/shedaklah/esporo_02_v01.png` |
| `lodo_01` | `.atena/generated/art-candidates/props/shedaklah/lodo_01_v01.png` |

## Verificação técnica

- Todas são PNG `Format32bppArgb`, com alfa zero no canto superior esquerdo.
- Dimensões candidatas: `esporo_01` 1199×1312, `esporo_02` 1254×1254 e
  `lodo_01` 1312×1199.
- Nenhum arquivo sob `assets/props/` foi criado ou alterado.

## Admissão e verificação

O dono aprovou as três candidatas nesta conversa. Elas foram normalizadas por
contenção com nearest-neighbor para 256×256 RGBA, sem substituição de asset
existente, e foram integradas como props decorativos no cenário Shedaklah.

| ID | SHA-256 da versão admitida |
|---|---|
| `esporo_01` | `cde5ded19d7f393cb2edcaf5ec17bab394ea4e34c1d48e9c83d58021c41b6014` |
| `esporo_02` | `1907c086fb113c4dfeae1c3391248729dd5c7c4f9d8d0f4881c032654e9e5dee` |
| `lodo_01` | `7d6a5439b743d4870c15e83a109b77ec19739150f5a901dc677bfc26017f3e58` |

- O reimportador do Godot processou os três PNGs.
- `godot --headless --path . -s tests/run_all.gd`: `testes: 0 falha(s)`.
- `godot --headless --path . res://tools/smoke.tscn`: nove fases em `running`;
  `smoke: ok`.
