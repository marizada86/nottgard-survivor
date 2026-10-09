---
id: "EVID-227"
title: "PLAN-090: clicar na HUD não move mais o herói (BUG-007 verificado, BUG-039 corrigido)"
created: "2026-10-09"
spec: "SPEC-072"
cards: ["BUG-007", "BUG-039"]
status: "implementado local, sem commit até a aprovação; aceite subjetivo pendente do playtest"
---

# EVID-227 — Segurar o clique para andar, sem mover ao clicar na HUD

Última verificação manual do roteiro do PLAN-033 (BUG-007). Em vez de deixar para o olho humano, a verificação foi feita com a **janela aberta e entrada de mouse simulada** (`Input.parse_input_event`), o que a suíte headless não alcança.

## O defeito (BUG-039)

`ui/run.gd` lia `Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)` sem olhar se o cursor estava sobre a HUD. Só as telas que pausam a batalha eram protegidas (por `battle.state != "running"`). Botão 1x, Ajuda, Pausa, painel do herói e slot da habilidade, que não pausam, faziam o herói andar até eles ao serem clicados.

## Medição (`tools/probe_mouse_walk.tscn`, 1280×720, 30 passos de física com o botão esquerdo segurado)

| Cursor | `ui/run.gd` antigo | `ui/run.gd` novo |
|---|---|---|
| Sobre o botão 1x | herói andou **2,95** tiles | **0,00** |
| Sobre o painel do herói | andou **4,32** tiles | **0,00** |
| No mundo, a leste | andou 3,34 | andou 3,34 (inalterado) |

Também confirmado com o mouse em repouso: o mundo aberto devolve nenhum controle sob o cursor; botões, `StatBox` e `AbilitySlot` devolvem o controle.

## O que mudou

| Arquivo | Mudança |
|---|---|
| `core/hero.gd` | `Hero.mouse_walk_dir(keys_dir, left_pressed, over_ui, to_mouse, dead_zone=4.0)`: conta pura; tecla de movimento tem prioridade; zona morta de 4 px; sobre a HUD, nada |
| `ui/hud.gd` | `pointer_over_ui()`: há controle sob o cursor (`gui_get_hovered_control`) |
| `ui/run.gd` | o trecho do clique usa as duas funções; o toque (celular) segue pelo caminho próprio |
| `tests/test_mouse_walk.gd` (novo) | 9 casos: sem clique, no mundo, sobre a HUD, WASD com prioridade (com e sem HUD), zona morta, parâmetro |
| `tools/probe_mouse_walk.{gd,tscn}` (novos) | sonda com a janela aberta: hover por posição e integração com a física |
| `specs/SPEC-072` | adendo com o defeito e a correção |

## Verificação

| Verificação | Resultado |
|---|---|
| `test_mouse_walk` | 0 falhas |
| **Mutação** (sem a regra da HUD; clique acima da tecla; sem zona morta) | 1 falha cada; restaurado, 0 |
| `tests/run_all.gd` | `testes: 0 falha(s)` |
| `res://tools/smoke.tscn` | `smoke: ok` |
| `res://tools/kit_test.tscn` | `kit: OK` |
| Sonda com a janela aberta, antes e depois | tabela acima |

## Pendências

Só o dono confirma a sensação de andar com o clique em jogo real. O mouse parado sobre a HUD enquanto o botão está segurado não anda; se o dono arrastar do mundo para um botão sem soltar, o herói para ao entrar na HUD (esperado). Commit, push e exportação: aprovação à parte.
