# EVID-036 - Correcao dos movimentos de Brook e Maelor

Data: 2026-09-25

## Defeitos confirmados

- As folhas `move_n`, `move_ne`, `move_e` e `move_se` de Brook continham
  somente pixels esparsos e nao um ciclo de caminhada utilizavel.
- A folha `move_n` de Maelor mostrava uma pose frontal de conjuracao, em vez
  de uma caminhada para o norte.

## Correcao integrada

Com a aprovacao humana para a nova geracao, foram preservadas as candidatas
fonte RGBA em grades 3x2 e substituidas apenas estas tiras de runtime:

- Brook: `move_n`, `move_ne`, `move_e` e `move_se`;
- Maelor: `move_n`.

As candidatas estao em
`.atena/generated/animation-candidates/heroes/{brook,maelor}/` e as tiras
finais em `assets/animations/heroes/{brook,maelor}/`. Cada grade 1536x1024
foi convertida em seis quadros horizontais de 256x384 por
`tools/normalize_animation_grid.gd`.

Brook agora tem caminhada traseira, diagonal traseira, lateral direita e
diagonal frontal direita. Maelor agora caminha para cima em vista traseira,
sem magia ou pose de conjuracao.

## Verificacao

1. As cinco texturas foram reimportadas pelo Godot.
2. Amostragem de alfa confirmou entre 29% e 36% de pixels visiveis nas novas
   tiras, afastando a regressao das folhas quase vazias.
3. `D:\Godot\Godot_v4.7.2-stable_win64.exe --headless --path . -s tests/run_all.gd`:
   **0 falhas**.
4. `D:\Godot\Godot_v4.7.2-stable_win64.exe --headless --path . -s tools/audit_prompt_execution.gd`:
   **0 falhas**.

## Prevencao

`tests/test_animation_assets.gd` exige cobertura minima de pixels visiveis
para as cinco folhas reparadas, alem de dimensoes, PNG valido e alfa.
