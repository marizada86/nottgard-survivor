---
id: "EVID-102"
title: "Candidatas de props de Feng-tu"
date: "2026-09-28"
status: "admitidas e verificadas"
relations:
  - "[[PLAN-035-geracao-de-assets-pendentes-2026-09-28]]"
  - "[[SPEC-062-fila-de-geracao-externa-de-assets]]"
  - "[[SPEC-068-props-de-feng-tu]]"
  - "[[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]]"
---

# EVID-102 — Candidatas de props de Feng-tu

## Método

O dono liberou o próximo grupo do plano. As três imagens foram geradas pelo
gerador de imagem nativo, uma chamada por prop, a partir dos prompts aprovados
de `ART-PROMPTS-024`, adaptados para saída RGBA com transparência nativa.

## Candidatas

| ID | Candidata |
|---|---|
| `lanterna_01` | `.atena/generated/art-candidates/props/feng-tu/lanterna_01_v01.png` |
| `lanterna_02` | `.atena/generated/art-candidates/props/feng-tu/lanterna_02_v01.png` |
| `sino_01` | `.atena/generated/art-candidates/props/feng-tu/sino_01_v01.png` |

## Verificação técnica

- Todas são PNG `Format32bppArgb`, com alfa zero no canto superior esquerdo.
- Dimensões candidatas: `lanterna_01` 1324×1188,
  `lanterna_02` 1225×1284 e `sino_01` 1330×1182.
- A prancha está em
  `.atena/evidence/EVID-102-props-feng-tu-candidatos-2026-09-28.png`.
- Antes da aprovação, nenhum arquivo sob `assets/props/` havia sido alterado.

## Admissão e verificação

O dono aprovou as três candidatas. Elas foram normalizadas por contenção com
nearest-neighbor para 256×256 RGBA e integradas como props decorativos em Feng-tu.

- O reimportador do Godot processou os três PNGs.
- `godot --headless --path . -s tests/run_all.gd`: `testes: 0 falha(s)`.
- O smoke do jogo encerrou com sucesso.
