# EVID-037 - Correcao do idle de Brook

Data: 2026-09-25

## Defeito

`assets/animations/heroes/brook/idle.png` usava uma versao anterior com halos
coloridos e acabamento de alfa degradado, visivel durante o repouso em jogo.

## Correcao integrada

Com aprovacao humana, foi gerada a candidata
`.atena/generated/animation-candidates/heroes/brook/idle_v04.png`: quatro
quadros de repouso de Brook, com armadura escura, tabardo ocre, maca compacta,
barba e cabelo castanho-escuros e orelhas curtas arredondadas. A grade 2x2 foi
convertida para `assets/animations/heroes/brook/idle.png` em tira 1024x384,
com quatro celulas de 256x384 e alfa transparente.

`tools/normalize_animation_grid.gd` agora aceita grades 2x2 e 3x2, mantendo
o mesmo processo para idle e para movimentos.

## Verificacao

1. Inspecao visual: quatro sprites completos, sem halo perceptivel e sem
   recorte de membros.
2. Reimportacao local de `idle.png` concluida pelo Godot.
3. `D:\Godot\Godot_v4.7.2-stable_win64.exe --headless --path . -s tests/run_all.gd`:
   **0 falhas**.
4. `D:\Godot\Godot_v4.7.2-stable_win64.exe --headless --path . -s tools/audit_prompt_execution.gd`:
   **0 falhas**.
