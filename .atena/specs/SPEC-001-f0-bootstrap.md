# SPEC-001 — F0: bootstrap do projeto Godot

Status: aprovada (PLAN-001, aprovado em 2026-09-21).

## Escopo
- `project.godot` (Godot 4.7.2, GL Compatibility, viewport 1280x720, filtro nearest, stretch canvas_items).
- Estrutura `core/ ui/ data/ tests/ tools/ assets/`.
- Runner de teste headless `tests/run_all.gd`.
- Cena principal placeholder que imprime a versão do projeto.
- Executável: `D:\Godot\Godot_v4.7.2-stable_win64_console.exe`.

## Critérios de aceite
1. `--headless --path . --import` conclui sem erro.
2. `-s tests/run_all.gd` roda com 0 falhas.
3. Cena principal abre e imprime a versão.

## Fora de escopo
Gameplay (F1+). Copiar assets do Nottcard: só sob demanda por fase.
