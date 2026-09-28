# EVID-082 — Goranthis: terraços do falso paraíso e queda do Estige

Data: 2026-09-27  
SPEC: `SPEC-052-terreno-de-goranthis.md`

## Escopo executado

- `core/terrain_layout.gd` compõe terraço, mármore pérola, musgo seco,
  fundação, margem e queda visual do Estige por coordenadas e seed estáveis;
  não consome RNG de batalha.
- `ui/ground.gd` desenha a queda como água luminosa e periférica, sem ativar
  regra hídrica ou riscos de Durao.
- `ui/stages/goranthis.tscn` declara `terrain_layout_id = "goranthis"` e seed
  597, além do atlas modular final de quatro variantes.
- `tests/test_terrain.gd` verifica a queda determinística, o terraço central e
  a ausência da regra hídrica do Estige.

## Arte aprovada e integrada

- Arquivo: `.atena/generated/art-candidates/terrain/goranthis-ground-source-v1.png`.
- Origem e prompt: `ART-PROMPTS-022-terreno-de-goranthis.md`.
- SHA-256: `F67198BB690F9F1C1726862831FD80442E035D4EC661144377139C1D62E6F088`.
- Inspeção: pedra clara, juntas largas, desgaste e musgo seco são discretos.
  Não há água, queda, props, texto, símbolos ou estruturas altas.
- Aprovação do dono: **“aprovado”**, 2026-09-27.
- Atlas final: `assets/tiles/goranthis_ground_atlas_v1.png`, PNG opaco 128×64,
  quatro variantes 64×32, SHA-256
  `1D73C07E5795AD47A3D85A10145558639F27B5C1A69C7E1C3CEE3D3FB8CE991E`.
- Integração: terraço, mármore pérola e musgo seco usam o atlas; fundação,
  margem e queda do Estige permanecem procedurais. Não há mecânica de água.

## Validação

- Suíte: `godot --headless --path . -s tests/run_all.gd` — `testes: 0 falha(s)`.
- Fumaça: `godot --headless --path . res://tools/smoke.tscn` — `smoke: ok`.
- Captura runtime final: `SPEC-052-goranthis-terrain-2026-09-27.png` —
  viewport 1280×720, Goranthis em execução com Durvall e atlas integrado.
- Integridade textual: `git diff --check` nos arquivos modificados — passou.

## Reconciliação

O registro canônico da aprovação e dos limites é
`ASSET-APPROVAL-REGISTER-015-terreno-de-goranthis-2026-09-27.md`. Os critérios
da SPEC-052 foram demonstrados pela suíte, pela fumaça e pela captura final.
