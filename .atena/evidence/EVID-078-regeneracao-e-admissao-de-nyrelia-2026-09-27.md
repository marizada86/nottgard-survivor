# EVID-078 — Regeneração e admissão de Nyrelia v02

Data: 2026-09-27  
SPEC: `SPEC-048-admissao-das-animacoes-regeneradas-de-nyrelia.md`

## Método e prompt

Método: geração integrada ImageGen, com fundo RGBA transparente, seguida de
normalização local por quadro. O prompt-base exigiu pixel art de fantasia
sombria, visão isométrica 3/4, Nyrelia como sacerdotisa mascarada de Mask,
capuz/manto verde-floresta e carvão, máscara escura, acentos bronze-dourados,
corpo legível a 72 px, sem pele exposta, cenário, sombra, texto ou watermark.

Variações por strip: `idle` (respiração e brilho mínimo), `move_n`,
`move_ne`, `move_e`, `move_se` e `move_s` (ciclos de seis passos nas direções
visuais), `attack` (gesto e Dominar Pessoa contido), `active` (foco
verde-dourado/violeta controlado) e `death` (queda lateral sem gore).

As nove fontes, seus hashes e os strips derivados estão em
`.atena/generated/nyrelia-regeneration/v02/`; as fontes são as entradas de
proveniência e não foram sobrescritas.

## Admissão e recuperação

- Os nove PNGs oficiais anteriores foram copiados para
  `.atena/generated/nyrelia-regeneration/v02/previous-official/` antes da
  substituição.
- O lote novo foi copiado para `assets/animations/heroes/nyrelia/`.
- `move_se[2]` foi transladado um pixel para baixo pelo alinhador local, pois
  sua borda com alfa >= 0,10 terminava em y=366; após o ajuste, todos os
  frames terminam em y=367.
- `ASSET-OFFICIAL-LOCK-010.json` é JSON válido e contém os hashes atuais dos
  nove paths oficiais.

## Validação

- A captura runtime `EVID-078-nyrelia-runtime-v02.png` mostra `idle`,
  `move_se` e `attack` com corpo, máscara e manto legíveis no renderer.
- A inspeção confirmou RGBA, dimensões esperadas e margens laterais de pelo
  menos 16 px em todos os frames.
- Após a reimportação do Godot, `tests/run_all.gd` terminou com
  `testes: 0 falha(s)`.
