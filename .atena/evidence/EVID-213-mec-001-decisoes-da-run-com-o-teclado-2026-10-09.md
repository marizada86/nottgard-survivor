---
id: "EVID-213"
title: "MEC-001: decisões da run só com o teclado (W/S escolhem, Enter confirma)"
created: "2026-10-09"
spec: "SPEC-156"
cards: ["MEC-001"]
status: "implementado local; sem commit"
---

# EVID-213 — MEC-001

Spec: [SPEC-156](../specs/SPEC-156-decisoes-da-run-so-com-o-teclado-mec-001.md). Pedido do dono em 2026-10-09 ("siga para o item 7"), como desvio do PLAN-071 (DEV-016), executado e devolvido ao plano.

## Verificação do que já estava coberto

Antes de codar: as teclas 1 a 9 escolhem direto, a primeira opção nasce focada, as setas movem o foco e Enter/Espaço confirmam. **Só faltava WASD.**

## O que mudou

| Arquivo | Mudança |
|---|---|
| `ui/hud.gd` | `offer_key_step(tecla)` (W/A = −1, S/D = +1, o resto 0) e `offer_focus_step(passo)` (foco circular entre os botões da oferta, pulando os travados); a dica do teclado ganhou "W/S ou setas escolhem, Enter confirma, 1 a 9 escolhem direto" |
| `ui/run.gd` | no ramo das ofertas (`levelup`, `altar`, `item_offer`, `shop`), W/A e S/D chamam `offer_focus_step` |
| `tests/test_offer_keyboard.gd` (novo) | mapa de teclas; volta circular na oferta de nível (começa na primeira, S percorre e volta, W recua, o botão focado escolhe a opção certa); oferta do ferreiro sem moeda: nenhuma opção travada recebe o foco |

## Verificações

| Verificação | Resultado |
|---|---|
| `test_offer_keyboard` | 0 falhas; **mutação** (sem `grab_focus`): 9 falhas; restaurado, 0 |
| Sonda com teclas reais na cena da run (S, D, W, Enter) | o foco foi 0 → 2 → 3 → 2 e Enter fechou a oferta, voltando ao estado `running` |
| `tests/run_all.gd` | `testes: 0 falha(s)` |
| `res://tools/smoke.tscn`, `res://tools/kit_test.tscn` | `smoke: ok`, `kit: OK` |

## Limites

Só o teclado: o Quartel e os menus continuam navegando com as setas. Nenhuma arte nova.
