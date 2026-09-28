# EVID-081 — Shendilavri: mármore ilusório e braço visual do Estige

Data: 2026-09-27  
SPEC: `SPEC-051-terreno-de-shendilavri.md`

## Escopo executado

- `core/terrain_layout.gd` compõe mármore, veio, pó de cristal, fundação,
  margem e um braço visual do Estige por coordenadas e seed estáveis; não
  consome RNG de batalha.
- `ui/ground.gd` desenha o braço como água escura e calma de margem, sem
  reutilizar regra hídrica ou os riscos de Durao.
- `ui/stages/shendilavri.tscn` declara `terrain_layout_id = "shendilavri"` e
  seed 570, além do atlas modular final de quatro variantes.
- `tests/test_terrain.gd` verifica o braço determinístico, a arena central de
  mármore e a ausência da regra hídrica do Estige.

## Arte aprovada e integrada

- Arquivo: `.atena/generated/art-candidates/terrain/shendilavri-ground-source-v1.png`.
- Origem e prompt: `ART-PROMPTS-021-terreno-de-shendilavri.md`.
- SHA-256: `6D60759FF6630949944D8D784C57E9CEE8AAE04CCC79CD8C4CE4A889FC88CEE0`.
- Inspeção: mármore violeta-escuro, veios rubro-prateados e pó de cristal são
  contidos. Não há props, água, Estige, texto ou estruturas altas.
- Aprovação do dono: **“aprovado”**, 2026-09-27.
- Atlas final: `assets/tiles/shendilavri_ground_atlas_v1.png`, PNG opaco
  128×64, quatro variantes 64×32, SHA-256
  `B2B53F20EB93F1D67379C7B3FA4BE8FE5D2BEE6032B4DEF316990273803E9E1F`.
- Integração: mármore, veio e pó de cristal usam o atlas; fundação, margem e
  braço visual do Estige permanecem procedurais. Não há mecânica de água.

## Validação

- Suíte: `godot --headless --path . -s tests/run_all.gd` — `testes: 0 falha(s)`.
- Fumaça: `godot --headless --path . res://tools/smoke.tscn` — `smoke: ok`.
- Captura runtime final: `SPEC-051-shendilavri-terrain-2026-09-27.png` —
  viewport 1280×720, Shendilavri em execução com Durvall e atlas integrado.
- Integridade textual: `git diff --check` nos arquivos modificados — passou.

## Reconciliação

O registro canônico da aprovação e dos limites é
`ASSET-APPROVAL-REGISTER-014-terreno-de-shendilavri-2026-09-27.md`. Os
critérios da SPEC-051 foram demonstrados pela suíte, pela fumaça e pela captura
final.
