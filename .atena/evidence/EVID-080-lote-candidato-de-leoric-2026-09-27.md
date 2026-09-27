# EVID-080 — Lote candidato completo de Leoric

Data: 2026-09-27  
SPEC: `SPEC-049-preparacao-da-regeneracao-do-piloto-de-leoric.md`

## Escopo e proveniência

Após o aceite artístico do piloto pelo dono, o lote foi expandido localmente
com ImageGen integrado. As fontes ficam preservadas em
`.atena/generated/leoric-regeneration/v01/sheets/`; os strips abaixo são
candidatos e não foram copiados para `assets/`.

## Candidatos normalizados

| Strip | Frames | SHA-256 |
| --- | ---: | --- |
| `idle` | 4 | `7bd7e25c61b6bb4a639bed62639828bf5cd22f1ca14795884bd699e9059f8663` |
| `move_n` | 6 | `cf42b12627f6b75312ea2a4ed114cf9cbd0821cc932b5b71d28767b3f39fe0c4` |
| `move_ne` | 6 | `fb08f435995845753719dcf9236481a537f7018ff31ebe3213496c4a396d3f6c` |
| `move_e` | 6 | `bda86a85763a2cbd10009cc57b80fc23f8ebe34c0dc981d93cf0f51872c0485e` |
| `move_se` | 6 | `8b95bea1cfb288d28390ea18d128e7aef31ad27a817be4d221ecf403082100f3` |
| `move_s` | 6 | `2fb2262439781c7793d273c486cc87cea479c5b8a48231fd028ff5549e0f3eda` |
| `attack` | 4 | `798c57e5d5d659f83e33de4a35ba4f90bd8dacd363839c1a22f19a54c0469414` |
| `active` | 6 | `b3d6f536dc4146e121fbdf5e58bdd3ad3d626353f26b810c6446524e911ae1d1` |
| `death` | 6 | `24af342265863a7254a5f42baa61ea92e74bcbe161440a2f5dfe1a501e24aac9` |

## Verificações

- Os 50 frames possuem canvas RGBA 256×384, margem lateral de pelo menos 8 px
  e último pixel com alfa >= 26 em y=367.
- A captura [EVID-080-leoric-lote-candidato-v01.png](EVID-080-leoric-lote-candidato-v01.png)
  mostra idle, movimento sudeste e ataque em escala de jogo após a
  normalização: corpo, chapéu, barba, manto e foco seguem legíveis.
- `active` preserva o corpo enquanto a constelação permanece contida em torno
  do foco; `death` é uma queda lateral sem gore.
- A captura de runtime emite apenas avisos de cache/log/certificado do ambiente
  isolado do Godot; não houve falha de carregamento dos strips candidatos.

## Limite de alteração

Nenhum arquivo sob `assets/animations/heroes/leoric/`, lock oficial ou registro
canônico foi modificado. A substituição requer aprovação explícita de admissão
do dono e deverá preservar os nove PNGs anteriores antes da cópia.
