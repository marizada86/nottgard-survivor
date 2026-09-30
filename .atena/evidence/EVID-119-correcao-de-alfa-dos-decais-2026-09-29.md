# EVID-119 — Correção de transparência dos decais do Lote 2

Data: 2026-09-29  
SPEC: SPEC-082  
Status: **transparência aprovada em QA; composição por bioma pendente**.

## Defeito confirmado

As capturas de QA revelaram retângulos magenta atrás dos decais. A chave
anterior, baseada na média dos quatro cantos, preservava partes do fundo com
variação de tom: em Shedaklah, amostras externas tinham alfa entre 93 e 100
em 255.

## Correção aplicada

- `tools/normalize_lote_2_candidates.gd` agora identifica o chroma magenta ou
  ciano e remove somente a região ligada à borda do PNG. Isso protege o roxo
  que pertence à própria ilustração.
- As 27 candidatas normalizadas foram regeneradas. As fontes brutas e os
  destinos em `assets/` não foram alterados.
- `tests/test_ground_decals.gd` passou a exigir transparência nas faixas
  externas superior e inferior, além de presença, carregamento, determinismo
  e contrato de camada.

## Verificação

- As seis amostras que apresentavam alfa residual no fundo de
  `shedaklah_remendo_01_v01.png` passaram a alfa **0/255**.
- `D:\\Godot\\godot.exe --headless --path . -s res://tests/run_all.gd`:
  **0 falhas**.
- `git diff --check`: sem erros de whitespace.

## Pendente

A inspeção visual confirmou que o fundo rosa sumiu. Permanece necessária uma
decisão de composição e posicionamento fino por bioma, pois a aprovação atual
cobre a transparência. O BUG-013 não é fechado por esta correção e nenhum
asset do Lote 2 foi promovido para `assets/`.
