---
id: "EVID-212"
title: "MEC-050: ícone do item nas linhas Doar do Altar da Doação"
created: "2026-10-09"
spec: "SPEC-155"
cards: ["MEC-050"]
status: "implementado local; sem commit"
---

# EVID-212 — MEC-050

Spec: [SPEC-155](../specs/SPEC-155-icone-do-item-nas-linhas-doar-mec-050.md). Pedido do dono em 2026-10-09 ("comece pelo item 6"), como desvio do PLAN-071 (DEV-015), executado e devolvido ao plano.

## O que mudou

| Arquivo | Mudança |
|---|---|
| `core/battle.gd` | a linha `donate` do `_open_risk_event` carrega `base` (o `base` do item ou, se for único, o `id`) |
| `ui/hud.gd` | nova `static func offer_icon_path(o)` com a escolha de ícone de todas as ofertas (a lógica que era inline) mais o caso `donate`; a oferta chama a função |
| `ui/overlay.gd` | comentário corrigido (doação, aposta e ampulheta têm PNG; arcanista e câmara não) |
| `tests/test_donate_icons.gd` (novo) | uma linha Doar por equipamento (quatro comuns e um único), `base` correto, ícone existente, os outros tipos de oferta com o mesmo ícone |

## Verificações

| Verificação | Resultado |
|---|---|
| `test_donate_icons` | 0 falhas |
| **Mutação** (sem o caso `donate`) | 4 falhas; restaurado, 0 |
| `tests/run_all.gd` | `testes: 0 falha(s)` |
| `res://tools/smoke.tscn` | `smoke: ok` |
| Captura da tela do altar (`.atena/generated/big-maps/doacao_icones.png`) | as quatro linhas mostram o ícone do item (cetro do Coração da Dominância, cota, anel e couro) ao lado do nome |

O Coração da Dominância usa o ícone do cetro (provisório, `icon_like`; ART-042).
