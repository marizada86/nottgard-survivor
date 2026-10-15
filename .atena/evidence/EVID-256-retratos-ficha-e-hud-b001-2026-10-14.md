---
id: EVID-256
title: Retratos da Ficha e do HUD, lote B-001 (resolvedor com fallback)
spec: SPEC-178
plan: PLAN-104
date: 2026-10-14
content_state: DRAFT
---

# EVID-256 — B-001 (S-001 a S-003)

## Feito
- `ui/hero_portraits.gd` (`HeroPortraits`): `path`, `path_for_kind`, `has_own`, `texture` para `menu|ficha|hud`; ordem: `assets/portraits/<tipo>/<id>.png`, depois `assets/portraits/<id>.png`.
- `ui/character_sheet.gd`: retrato da Ficha pelo resolvedor; `stretch_mode` COVERED só quando a faixa própria existe, senão CENTERED (como hoje).
- `ui/hero_panel.gd`: retrato do HUD pelo resolvedor.
- `ui/menu.gd` não foi tocado.
- `tests/test_hero_portraits.gd` novo (12 heróis × ficha/hud, fallback, tamanho 768×256 e 256×256 quando a imagem própria existe, modo de escala da Ficha).
- Pasta de entrega `.atena/generated/retratos-ficha-hud/entrega/`.

## Verificação
| Verificação | Resultado |
|---|---|
| `godot --headless --import` | ok |
| `tests/run_all.gd` | 0 falhas |
| `tools/smoke.tscn` | ok, nove fases |

## Não verificado
- O ramo "imagem própria existe" só é exercitado com as imagens reais (S-006/S-007); hoje roda o fallback, que mantém o comportamento anterior.
- Sem captura visual nesta etapa (sem mudança visível).

## Critérios da SPEC-178
A1 e A2 verificados por teste; A3 a A8 aguardam as imagens.
