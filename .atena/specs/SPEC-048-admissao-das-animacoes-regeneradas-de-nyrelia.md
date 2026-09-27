# SPEC-048 — Admissão das animações regeneradas de Nyrelia

Status: **concluída** (2026-09-27).

## Intenção e escopo

Substituir os nove strips oficiais de Nyrelia por um lote v02 com corpo,
máscara e manto legíveis em escala real. O escopo inclui `idle`, as cinco
direções-fonte, `attack`, `active` e `death`; direções espelhadas continuam
sob responsabilidade do runtime.

## Não objetivos

Não altera dados, lore, cenas, SFX, placements, outros heróis ou props.

## Critérios de aceite

1. PNG RGBA em 256×384 por célula, quatro frames para `idle`/`attack` e seis
   para os demais strips.
2. Conteúdo corporal legível, margem lateral e base y=367.
3. Runtime carrega as novas tiras; testes passam.
4. Os bytes anteriores permanecem recuperáveis e o lock referencia os hashes
   novos.

## Resultado

Os critérios passaram. O lote v02 foi copiado para
`assets/animations/heroes/nyrelia/`, os bytes anteriores foram preservados em
`.atena/generated/nyrelia-regeneration/v02/previous-official/` e o lock 010
foi emitido. `move_se[2]` recebeu alinhamento vertical de um pixel antes da
admissão para satisfazer a base contratada.

Evidência: `EVID-078-regeneracao-e-admissao-de-nyrelia-2026-09-27.md`.
