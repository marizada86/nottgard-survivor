# EVID-112 — Ofertas em cartão resumido, 2026-09-29

Verificação da [[SPEC-094-ofertas-em-cartao-resumido]] (MEC-027). Capturas em
[EVID-112-ofertas-em-cartao-2026-09-29/](EVID-112-ofertas-em-cartao-2026-09-29/), geradas por `tools/shot.tscn`.

## Automático

- `godot --headless --path . -s tests/run_all.gd`: 0 falhas (inclui destaques, veredito, tabela e percentuais pequenos).
- `godot --headless --path . res://tools/smoke.tscn`: ok nas 9 fases.

## Capturas

| Tela | Cartão | Com Shift |
|---|---|---|
| Item achado | `items.png` | `items_shift.png` |
| Loja | `shop.png` | `shop_shift.png` |
| Ferreiro | `forge.png` | — |
| Subida de nível | `levelup.png` | — |
| Altar | `altar.png` | — |
| Doação | `donate.png` | — |
| Aposta | `bet.png` | — |

Com Shift, as tabelas maiores (loja com 8 linhas) cabem em 1280×720.

## Não verificado

- Hover com mouse real (a tabela foi renderizada por script, sem mover o mouse).
- Shift com teclado real (nas capturas foi simulado por `Input.parse_input_event`).
- Tooltip com o jogo pausado e opção travada por falta de moedas, em jogo.
