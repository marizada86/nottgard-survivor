---
id: "EVID-101"
title: "Candidatas de props de Durao"
date: "2026-09-28"
status: "admitidas e verificadas"
relations:
  - "[[PLAN-035-geracao-de-assets-pendentes-2026-09-28]]"
  - "[[SPEC-062-fila-de-geracao-externa-de-assets]]"
  - "[[SPEC-067-props-de-durao]]"
  - "[[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]]"
---

# EVID-101 — Candidatas de props de Durao

## Método

O dono liberou o próximo grupo do plano. As três imagens foram geradas pelo
gerador de imagem nativo, uma chamada por prop, a partir dos prompts aprovados
de `ART-PROMPTS-024`, adaptados para saída RGBA com transparência nativa.

## Candidatas

| ID | Candidata |
|---|---|
| `corrente_01` | `.atena/generated/art-candidates/props/durao/corrente_01_v01.png` |
| `corrente_02` | `.atena/generated/art-candidates/props/durao/corrente_02_v01.png` |
| `osso_01` | `.atena/generated/art-candidates/props/durao/osso_01_v01.png` |

## Verificação técnica

- Todas são PNG `Format32bppArgb` com transparência real; os cantos das duas
  correntes têm alfa zero e o canto de `osso_01` tem alfa 1 (quase transparente,
  sem fundo residual visível).
- Dimensões candidatas: `corrente_01` 1536×1024,
  `corrente_02` 1254×1254 e `osso_01` 1402×1122.
- A prancha está em
  `.atena/evidence/EVID-101-props-durao-candidatos-2026-09-28.png`.
- Antes da aprovação, nenhum arquivo sob `assets/props/` havia sido alterado.

## Admissão e verificação

O dono aprovou as três candidatas nesta conversa. Elas foram normalizadas por
contenção com nearest-neighbor para 256×256 RGBA, sem substituir asset
existente, e foram integradas como props decorativos no cenário Durao.

| ID | SHA-256 da versão admitida |
|---|---|
| `corrente_01` | `f3460028883b93548833253ace3ebed49bbad9f6852da5d0b1a24acd1099dad2` |
| `corrente_02` | `747e334e46dc0709c36453d8a5179993b7732bac791c62022e0d9a05ae4cf12e` |
| `osso_01` | `1b332b989e458c306383eab4e2fbe7e0880d59147396eabe141bf266f00bd16c` |

- O reimportador do Godot processou os três PNGs.
- `godot --headless --path . -s tests/run_all.gd`: `testes: 0 falha(s)`.
- `godot --headless --path . res://tools/smoke.tscn`: nove fases em `running`;
  `smoke: ok`.
