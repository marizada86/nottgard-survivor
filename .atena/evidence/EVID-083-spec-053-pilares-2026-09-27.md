# EVID-083 — Os Pilares: platô de obsidiana da Síntese Abissal

Data: 2026-09-27  
SPEC: `SPEC-053-terreno-dos-pilares.md`

## Escopo executado

- `core/terrain_layout.gd` compõe obsidiana, basalto fraturado, poeira astral
  e fundação por coordenadas e seed estáveis; não consome RNG de batalha.
- `ui/ground.gd` ganhou leitura específica para fraturas, poeira e fundação.
  O atlas aprovado é aplicado somente aos materiais terrestres do platô.
- `ui/stages/pilares.tscn` declara `terrain_layout_id = "pilares"`, seed 800 e
  o atlas modular final de quatro variantes.
- `tests/test_terrain.gd` cobre o centro navegável, a fundação de borda e a
  ausência de Estige ou corrente permanente.

## Arte aprovada e integrada

- Arquivo: `.atena/generated/art-candidates/terrain/pilares-ground-source-v1.png`.
- Origem e prompt: `ART-PROMPTS-023-terreno-dos-pilares.md`.
- SHA-256: `FC16D4A0214280C9146399638061E8E15B4FE49F2D7700327AF9C858D85F5D09`.
- Inspeção: obsidiana violeta-negra, placas fraturadas e veios apagados
  dominam. Não há pilares, símbolos, água, Estige, texto ou estruturas altas.
- Aprovação do dono: **“aprovada”**, 2026-09-27.
- Atlas final: `assets/tiles/pilares_ground_atlas_v1.png`, PNG opaco 128×64,
  quatro variantes 64×32, SHA-256
  `9D6AD54A74E12353D87B0BDCFE93D06314E87763EC05329E5F1BAF5530C1BD4E`.
- Integração: obsidiana, basalto e poeira usam o atlas; fundação permanece
  procedural. Não há Estige ou corrente permanente.

## Validação

- Suíte: `godot --headless --path . -s tests/run_all.gd` — `testes: 0 falha(s)`.
- Fumaça: `godot --headless --path . res://tools/smoke.tscn` — `smoke: ok`.
- Captura runtime final: `SPEC-053-pilares-terrain-2026-09-27.png` — viewport
  1280×720, Pilares em execução com Durvall e atlas integrado.
- Integridade textual: `git diff --check` nos arquivos modificados — passou.

## Reconciliação

O registro canônico da aprovação e dos limites é
`ASSET-APPROVAL-REGISTER-016-terreno-dos-pilares-2026-09-27.md`. Os critérios
da SPEC-053 foram demonstrados pela suíte, pela fumaça e pela captura final.
