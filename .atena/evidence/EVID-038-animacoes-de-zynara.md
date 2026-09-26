# EVID-038 - Animacoes de Zynara integradas

Data: 2026-09-25

## Escopo executado

Com aprovacao explicita do usuario, as nove sequencias-fonte de Zynara Vellen
foram integradas em `assets/animations/heroes/zynara/`:

- `idle` e `attack`: quatro quadros, `1024x384`;
- `move_n`, `move_ne`, `move_e`, `move_se`, `move_s`, `active` e `death`:
  seis quadros, `1536x384`.

As tres direcoes opostas permanecem derivadas pelo espelhamento horizontal do
runtime: `move_ne` para `move_nw`, `move_e` para `move_w` e `move_se` para
`move_sw`.

## Rastreabilidade e verificacao

- Candidatas preservadas: `../generated/asset-candidates/animations/heroes/zynara/`.
- Registros `HERO-zynara-*`: estado `accepted`.
- Manifesto: nove sequencias concluidas em `HERO-ANIMATION-PROMPT-MANIFEST-001.json`.
- Reimportacao do Godot concluida.
- `tests/run_all.gd`: 0 falhas.
- `tools/audit_prompt_execution.gd`: 0 falhas.
