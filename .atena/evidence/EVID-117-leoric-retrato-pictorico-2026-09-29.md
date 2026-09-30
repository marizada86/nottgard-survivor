# EVID-117 — Retrato pictórico de Leoric

Data: 2026-09-29  
Status: **admitido e validado**

## Intenção aprovada

Substituir somente o retrato de seleção cartunesco de Leoric por uma ilustração
pictórica de fantasia sombria, preservando-o como gnomo adulto compacto de
barba grisalha, cartola preta e sobretudo marrom.

## Proveniência

- Candidata gerada pelo gerador integrado, usando o retrato anterior de Leoric
  como referência de identidade e os retratos de Maelor e Bromnor como
  referência de acabamento.
- A instrução exigiu materiais gastos, volume pictórico, luz fria lateral,
  pontos quentes de velas e fundo de cripta/biblioteca; proibiu chibi,
  mascote, contornos grossos, mãos exageradas, texto e marca d'água.
- Origem preservada:
  `.atena/generated/leoric-skin-cartola/v02/candidates/leoric_portrait_v02_painterly_candidate.png`.
- Normalizada:
  `.atena/generated/leoric-skin-cartola/v02/normalized/leoric_portrait_v02_painterly_640x427.png`.

## Auditoria estática

| Item | Resultado |
| --- | --- |
| Formato oficial | PNG RGBA, 640×427 |
| Hash da candidata normalizada e do oficial | `b25ae3839e5a7bf3e760d38f7505d82d35ddcbf4f383a16d0cf4b36d787785df` |
| Backup recuperável | `v02/previous-official/assets/portraits/leoric.png` |
| Hash do backup | `3f6a0dffa75f9bde211bc0b5da71e29212eec4b4c8b65cb943be171ea752b5dc` |
| Lock sucessor | `ASSET-OFFICIAL-LOCK-014.json`, 127 entradas |

## Escopo preservado

Não foram alterados o sprite de runtime de Leoric, as animações, cenas, dados,
lore, habilidades, SFX, colisão ou gameplay.

## Validação runtime

- `godot --headless --path . -s tests/run_all.gd`: `testes: 0 falha(s)`.
- `godot --headless --path . res://tools/smoke.tscn`: as nove fases terminaram
  com `smoke: ok`.
- O ambiente emitiu avisos conhecidos sobre o arquivo de log, certificados do
  sistema e recursos remanescentes no encerramento; nenhum deles correspondeu
  a uma falha de teste ou smoke.
