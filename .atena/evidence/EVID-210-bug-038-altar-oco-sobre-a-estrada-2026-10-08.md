---
id: "EVID-210"
title: "BUG-038: altar oco sobre a estrada (sheet animado com corpo transparente)"
created: "2026-10-08"
plan: "PLAN-071 (desvio DEV-015)"
spec: "SPEC-153"
cards: ["BUG-038", "ART-044"]
status: "corrigido local; verificado por parse, teste de assets, captura e suíte completa (0 falhas); falta olho do dono numa run real"
---

# EVID-210 — Altar oco sobre a estrada (BUG-038)

## Origem
Print do dono, 2026-10-08: altar de bênção sobre a estrada de Dagruve, com o chão aparecendo através do corpo. Hipótese do dono: o altar estaria atrás do asset da estrada.

## Medição
- Ordem de desenho: overlay `over` em `z_index` 60 (`tools/build_scenes.gd`); decais e estradas em -90 (`ui/ground_decals.gd`). O altar já ficava à frente.
- Sheet `assets/animations/interactions/altar_active.png`: pixels do corpo (por exemplo (40,120), (60,130), (100,140)) com RGBA 0,0,0,0. Amostragem do quadro 1 (192×192, passo 2): 7711 transparentes, 1051 parciais, 454 opacos (~5 %).
- Sprite estático `assets/interactions/altar_active.png`: 192×192, corpo completo (visto na revisão da imagem).

## Correção
`ui/overlay.gd`: `if scenery_texture != null or String(it.kind) == "altar": animation_texture = null`. Efeito: o altar usa o sprite estático.

## Verificação
| Verificação | Resultado |
|---|---|
| `godot --headless --check-only --script res://ui/overlay.gd` (Godot 4.7.2) | sem erro de parse |
| `tools/run_one_test.gd -- test_animation_assets` | 0 falhas |
| Captura de Dagruve (herói Durvall) com um altar posto sobre a estrada, via cópia temporária de `tools/shot.gd` (removida depois) | altar de pedra opaco, com velas e pano vermelho; a estrada não aparece através do corpo |
| `tests/run_all.gd` (suíte completa, Godot 4.7.2 headless, 2026-10-08) | **0 falhas** (avisos de RID vazado no encerramento são ruído do modo headless) |
| Run real jogando | **pendente** (dono) |

## Pendências
- Olho do dono num altar real (BUG-038 fecha no próximo playtest se não reaparecer).
- ART-044: sheet novo com corpo opaco para devolver a animação das chamas.
- Sem exportação do `.exe` (o build local segue com o altar antigo).
