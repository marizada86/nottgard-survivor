# EVID-077 — Shedaklah: dois braços do Estige e terreno fúngico

Data: 2026-09-27  
SPEC: `SPEC-047-terreno-de-shedaklah-e-dois-bracos-do-estige.md`

## Escopo executado

- O cânone registra Shedaklah entre dois braços lentos do Rio Estige.
- `core/terrain_layout.gd` cria os dois cursos determinísticos nas bordas,
  margem orgânica, solo fúngico, micélio e crosta de ooze.
- `ui/ground.gd` desenha o Estige de Shedaklah como água calma de borda, sem
  reutilizar a indicação gelatinosa e os riscos de Durao.
- `ui/stages/shedaklah.tscn` passou a declarar `terrain_layout_id =
  "shedaklah"` e seed visual 222.
- `tests/test_terrain.gd` verifica os dois braços, a arena central seca e a
  ausência de ativação de `is_styx_water` para Shedaklah.

## Arte aprovada e integrada

- Arquivo: `.atena/generated/art-candidates/terrain/shedaklah-ground-source-v1.png`.
- Origem: geração interna de imagem, a partir do prompt em
  `ART-PROMPTS-018-terreno-de-shedaklah.md`.
- SHA-256: `7EBE13C1538AE4BA55581F6191ED53FD3FA46457167D0F2198A418AE52230360`.
- Aprovação explícita do dono: “aprovado”, em 2026-09-27.
- Atlas final: `assets/tiles/shedaklah_ground_atlas_v1.png` — opaco, 128×64,
  quatro variantes de 64×32; SHA-256
  `D4CF6F868752E1DD0FE0F16D2E9973CAAC79B822190FBBF164E84188C6FE9421`.
- Integração: a cena de Shedaklah consome o atlas somente para solo fúngico,
  micélio e crosta de ooze. As margens e os dois braços do Estige continuam
  procedurais para manter seu contraste e sua identidade de borda.

## Validação

- Suíte: `godot --headless --path . -s tests/run_all.gd` — `testes: 0 falha(s)`.
- Fumaça: `godot --headless --path . res://tools/smoke.tscn` — as nove fases,
  incluindo Shedaklah, abriram; `smoke: ok`.
- Captura runtime: `SPEC-047-shedaklah-terrain-2026-09-27.png` — viewport
  1280×720, Shedaklah em execução com Durvall.
- Integridade textual: `git diff --check` nos arquivos modificados — passou.

## Reconciliação

O registro `ASSET-APPROVAL-REGISTER-011-terreno-de-shedaklah-2026-09-27.md`
fixa a promoção aprovada. Não houve alteração no Estige gelatinoso de Durao,
nem nas ondas, colisão, chefe, duração ou regra ambiental de Shedaklah.
