---
id: "EVID-100"
title: "Candidatas de props de Molor"
date: "2026-09-28"
status: "admitidas e verificadas"
relations:
  - "[[PLAN-035-geracao-de-assets-pendentes-2026-09-28]]"
  - "[[SPEC-062-fila-de-geracao-externa-de-assets]]"
  - "[[SPEC-066-props-de-molor]]"
  - "[[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]]"
---

# EVID-100 — Candidatas de props de Molor

## Método

O dono liberou o próximo grupo do plano. As três imagens foram geradas pelo
gerador de imagem nativo, uma chamada por prop, a partir dos prompts aprovados
de `ART-PROMPTS-024`, adaptados para saída RGBA com transparência nativa.

## Candidatas

| ID | Candidata |
|---|---|
| `estalactite_01` | `.atena/generated/art-candidates/props/molor/estalactite_01_v01.png` |
| `estalactite_02` | `.atena/generated/art-candidates/props/molor/estalactite_02_v01.png` |
| `resina_01` | `.atena/generated/art-candidates/props/molor/resina_01_v01.png` |

## Verificação técnica

- Todas são PNG `Format32bppArgb`, com alfa zero no canto superior esquerdo.
- Dimensões candidatas: `estalactite_01` 1199×1312,
  `estalactite_02` 1295×1214 e `resina_01` 1402×1122.
- A prancha está em
  `.atena/evidence/EVID-100-props-molor-candidatos-2026-09-28.png`.
- Antes da aprovação, nenhum arquivo sob `assets/props/` havia sido alterado.

## Admissão e verificação

O dono aprovou as três candidatas nesta conversa. Elas foram normalizadas por
contenção com nearest-neighbor para 256×256 RGBA, sem substituir asset
existente, e foram integradas como props decorativos no cenário Molor.

| ID | SHA-256 da versão admitida |
|---|---|
| `estalactite_01` | `87d1311d7efa6e8474c1eb43557be6f0833f028f2fe2bbe424a6ca08b0481967` |
| `estalactite_02` | `6990d22690e3691f4b6a21502206084ffa2d4b1d646be6e8985c7d66218fbdb9` |
| `resina_01` | `f6198a6cd593f7c820755968b4f61d5a0dc0840a68cf44c3e951e585ecf9a063` |

- O reimportador do Godot processou os três PNGs.
- `godot --headless --path . -s tests/run_all.gd`: `testes: 0 falha(s)`.
- `godot --headless --path . res://tools/smoke.tscn`: nove fases em `running`;
  `smoke: ok`.
