---
id: "EVID-259"
title: "PLAN-105 B-001: verbos novos e parâmetros das mecânicas de chefe"
created: "2026-10-15"
relations: ["[[PLAN-105-mecanicas-dos-outros-chefes-2026-10-15]]", "[[EVID-257-l5-mecanicas-de-chefe-piloto-2026-10-15]]"]
content_state: DRAFT
---

# EVID-259 — PLAN-105, lote B-001 (aprovação por lote; sem commit)

Nível de aprovação registrado pelo dono em 2026-10-15: **por lote**. O B-001 não muda nenhum chefe: só entrega os verbos e parâmetros que o B-002 a B-004 vão usar. Os desenhos da seção 2 do plano valem como estão.

## O que mudou (`core/boss_mechanics.gd`, `data/difficulty.json`)
| Item | Regra |
|---|---|
| N1 **Marca** (`mark`) | O herói é marcado: o círculo (raio 3) **segue** o herói por 2 s, **trava** por 1 s com contagem e explode onde travou. Quem estiver dentro leva dano, e pode ser retardado (`slow`); `puddle` deixa uma poça. Conta no orçamento de caos (máx. 1 por vez) |
| N2 **Totem que cura** (`heal_pct_s`) | Em vez de blindar, os totens curam o chefe (fração do PV máximo por segundo) enquanto algum estiver de pé; a linha fica verde |
| N3 **Varredura em 2 feixes** (`beams`, `gap_deg`) | 2 feixes a `gap_deg` entre si; um acerto por 0,7 s, de qualquer um |
| N4 **Quadrantes** (`lit`, `puddle`) | De 1 a 3 quadrantes acesos; `puddle` deixa uma poça por quadrante aceso (8 s) |
| N5 **Conjuração de armadura** (`effect: armor`) | Sem interromper, o chefe ganha 40% de redução do dano recebido por 6 s (anel azul); não fere o herói. Interrompida a tempo, não entra. Parâmetros em `boss_mech.armor` |
| N6 **Imunidade com `n` e `id`** | Já era parametrizada; só dados nos próximos lotes |
| N7 Pilar bloqueia a varredura | **Não entrou**: o dono não pediu; segue como opcional do plano |

Interruptor novo: `boss_mech.verbs.mark`.

## Verificação
- `tests/test_l5_b001_verbs.gd` (chefe de Molor isolado, definições injetadas): a marca segue, trava, fere quem fica dentro, retarda, deixa poça e não fere quem sai ao travar; totem que cura (e não blinda) e para de curar sem os totens; 2 feixes ferem o lado oposto e 1 feixe não; 3 quadrantes e 3 poças; armadura entra sem interromper (fator 0,6) e não entra interrompida. **4 mutações** (marca sem dano, armadura sem efeito, totem sem cura, 1 feixe só) falham no ponto certo; restaurado, passa. Suíte completa: **0 falhas**.
- Capturas em janela real (`tools/capture_l5_b001.tscn`, `.atena/generated/mariz-playtest/l5_b001_*.png`): marca seguindo e travada com contagem, varredura de 2 feixes e anel de armadura.

## Gate G-L5-1 (seu)
Olhar os 4 verbos novos (as capturas) e dizer: a **Marca** (2 s seguindo e 1 s travada) é legível e justa? O **totem que cura** deve ser quebrado a tempo ou cura demais? A **armadura** a 40% por 6 s é o bastante para forçar a interrupção?

## Pendências
- B-002 (Zuggtmoy e Molydeus) começa com a sua aprovação do gate.
- Sem commit ainda.
