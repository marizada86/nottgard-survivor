---
id: "EVID-214"
title: "PLAN-083 B-003: mapas 84x84 de Feng-tu, Shendilavri e Goranthis"
created: "2026-10-09"
spec: "SPEC-157"
cards: ["MEC-039", "MEC-012"]
status: "implementado local; sem commit"
---

# EVID-214 — B-003 do PLAN-083

Spec: [SPEC-157](../specs/SPEC-157-segredos-nas-outras-fases-v0-5-0.md). Mesmo caminho da fatia piloto ([EVID-207](EVID-207-b006-fatia-piloto-de-segredos-2026-10-08.md)): `enlarge_stage_maps.gd -- 60 84`, chão assado novo, escala de desenho e testes de mapa.

## O que mudou

| Arquivo | Mudança |
|---|---|
| `ui/stages/feng_tu.tscn`, `shendilavri.tscn`, `goranthis.tscn` | `map_size` 84×84, herói em (0, 1344), props escalados, chão `*_ground_baked_v2.png` |
| `assets/tiles/{feng_tu,shendilavri,goranthis}_ground_baked_v2.png` (+ `.import`) | chão assado de 84×84 (~7 a 8 MB cada) |
| `tests/test_map_scale.gd` | seis fases grandes (`BIG`); células 12×12 vazias toleradas só nas de lado > 60 |
| `tests/test_level_design.gd` | lista das seis fases grandes |
| `tests/test_prop_grounding.gd` | o Espelho de Shendilavri é validado contra o `map_size` da cena (antes fixo em 40), com margem de 1 tile |

## Verificações

| Verificação | Resultado |
|---|---|
| `test_prop_grounding` | 0 falhas (antes: Espelho em (47,3; 6,3) reprovado pelo limite de 40) |
| `tests/run_all.gd` | `testes: 0 falha(s)` |
| `res://tools/smoke.tscn` | `smoke: ok` (nove fases) |
| FPS em janela (84×84) | 59,6 a 59,9, como na 0.4.0 |
| Capturas | `.atena/generated/big-maps/{feng_tu,shendilavri,goranthis}_v4_*.png` (quatro cantos e visão geral) |

## Notas

- Os props de cena são só ponto de partida: o runtime usa `SceneryLayout` com cópias e filtro de terreno.
- Segredos (POIs, Ecos, relíquias) ainda não existem nestas três fases; entram no B-004, depois do portão de conteúdo.
- Sem commit: aguarda aprovação explícita (um commit por fase, segundo o plano).
