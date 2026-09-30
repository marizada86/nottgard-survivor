# EVID-122 — Admissão parcial dos decais do Lote 2

Data: 2026-09-29  
SPEC: SPEC-082  
Decisão: **admissão autorizada pelo responsável após QA visual aprovada**.

## Admitidos

Foram promovidos para `assets/decals/` os 16 PNGs de remendo e trilha de:

- Dagruve, Shedaklah, Molor e Durão;
- Feng-tu, Shendilavri, Goranthis e Pilares.

O manifesto `data/ground_decals.json` aponta esses oito biomas aos destinos
oficiais. O processo recusaria sobrescrever qualquer arquivo existente.

## Verificação

- Suíte Godot: **0 falhas**.
- Smoke Godot: **ok nas nove fases**.
- `git diff --check`: sem erros de whitespace.

## Fora deste corte

- Docas não possui área seca declarada; seus dois decais continuam candidatos.
- As nove estruturas do Lote 2 e as HQs ainda não estão integradas.
- A admissão não altera física, navegação, colisões, y-sort ou seeds.
