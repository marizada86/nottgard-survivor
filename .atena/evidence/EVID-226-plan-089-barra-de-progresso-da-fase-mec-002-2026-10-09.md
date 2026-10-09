---
id: "EVID-226"
title: "PLAN-089: barra de progresso da fase na HUD (MEC-002, SPEC-163)"
created: "2026-10-09"
spec: "SPEC-163"
cards: ["MEC-002"]
status: "implementado local, sem commit; aceite subjetivo pendente do playtest"
---

# EVID-226 — Barra de progresso da fase

Spec: [SPEC-163](../specs/SPEC-163-barra-de-progresso-da-fase-mec-002.md). Aprovação por plano (2026-10-09). Sem arte nova, sem dependência nova, nada em `assets/`.

## O que mudou

| Arquivo | Mudança |
|---|---|
| `ui/stage_progress.gd` (novo) | `StageProgress`: `state(battle)` estático (modo e fração) e o desenho: faixa de 4 px, marcador do chefe, cores por modo |
| `ui/hud.gd` | Cria a barra sob o relógio (offsets -90/+90, y 43 a 47), a esconde junto do `EventPointer` e a registra em `event_pointer.avoid_nodes` |
| `tests/test_stage_progress.gd` (novo) | Núcleo: 0%, 50%, 99%, teto 1; chefe vivo; Maré (carência, aviso, avanço, total 38 s por padrão); sem Maré; fase real até o chefe; cores |
| `tools/capture_stage_progress.{gd,tscn}` (novos) | Capturas de desktop e celular |

Comportamento: até o chefe a barra enche (dourado, laranja nos últimos 20%); com o chefe vivo fica cheia e pulsa em vermelho; depois do chefe, com Maré, esvazia em azul-névoa até a frente cobrir o mapa; sem Maré (Pilares) some. Padrões P1 a P3 da spec mantidos.

## Verificação

| Verificação | Resultado |
|---|---|
| `test_stage_progress` | 0 falhas |
| **Mutação** (fração invertida; Maré ignorada; sem modo chefe; Maré enchendo em vez de esvaziar) | 2, 3+, 2 e 3+ falhas; restaurado, 0 |
| `tests/run_all.gd` | `testes: 0 falha(s)` |
| `res://tools/smoke.tscn` | `smoke: ok` |
| `res://tools/kit_test.tscn` | `kit: OK` |
| Capturas 1280×720 (desktop e celular) | A barra (550,43 a 730,47) cabe entre o relógio (y 6 a 41) e o nome da fase (y 48); não toca nos botões de toque nem no painel do herói. Em `.atena/generated/plan-089/capturas/` |

Auditoria do projeto (`tools/audit_projeto.gd`): `erros=0; avisos=9` (os 9 de antes).

## Pendências

- **Aceite subjetivo:** só o dono diz se a barra ajuda e se é fina demais (4 px) para ler. Ajustes de espessura ou cor são de uma linha em `ui/stage_progress.gd` e `ui/hud.gd`.
- Commit, push, exportação e texto no changelog (`seta` e `barra` ainda não constam nos documentos dos testers): aprovação à parte.
