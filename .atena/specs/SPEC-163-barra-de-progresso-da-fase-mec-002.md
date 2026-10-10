---
id: "SPEC-163"
title: "Barra de progresso da fase na HUD (MEC-002)"
status: "IMPLEMENTADA e publicada (2205341, EVID-226); aceite subjetivo pendente do playtest"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
created: "2026-10-09"
relations: ["[[SPEC-158-nevoa-de-borda-e-de-fim-de-fase]]", "[[SPEC-147]]", "[[SPEC-131]]"]
cards: ["MEC-002"]
---

# SPEC-163 — Barra de progresso da fase

Origem: relato de playtest (EVID-088, nota 3): "mostrar quanto falta até o fim do mapa". Hoje a HUD mostra só o relógio crescendo (`TimerLabel`, `ui/hud.gd:484`) e, com o chefe vivo, a palavra `CHEFE`. Risco: **baixo** (HUD, sem tocar na simulação). **Sem arte nova**: a barra é desenhada por código no estilo da HUD (SPEC-131); a ART-002 (layout final) continua opcional.

## O que existe (lido em 2026-10-09)

- `Battle.time` e `stage.duration` (300 s em Dagruve e Docas): o chefe nasce em `duration` e a fase só termina ao matar o chefe (`core/battle.gd`, `boss_spawned`, `boss_dead`).
- Depois do chefe, a Maré de Névoa (`fog_state`: `grace`, `warning`, `advancing`; `fog_config.grace_seconds`, `warning_seconds`, `advance_seconds`) em toda fase com próximo mapa, menos os Pilares (SPEC-158).
- `TimerLabel` (y 6, fonte 34) e `StageLabel` (y 48) no topo central; `BossPanel` e a pilha do topo (`top_stack`) logo abaixo. A seta de evento já desvia de nós listados em `event_pointer.avoid_nodes`.

## Regras

1. **Fase até o chefe:** uma barra fina (4 px de altura, mesma largura do `TimerLabel`) colada à base do relógio, preenchida de 0 a 100% com `time / stage.duration`. Um marcador na ponta direita representa o chefe. Passa de dourado a laranja nos últimos 20%.
2. **Chefe vivo:** a barra fica cheia e pulsa em vermelho; a vida do chefe continua no `BossPanel`.
3. **Depois do chefe, com Maré:** a barra troca para azul-névoa e mostra quanto falta para a frente da névoa cobrir o mapa (`grace + warning + advance`), esvaziando. Sem Maré (Pilares), a barra some.
4. **Velocidade 2x** e pausas acompanham `Battle.time`: nada de relógio próprio.
5. **Escondida** nos mesmos casos em que o relógio some (modais, introdução do chefe, resultado).
6. **Celular:** mesma barra; entra em `event_pointer.avoid_nodes` para a seta de evento não a cobrir.
7. **Núcleo testável:** uma função pura `StageProgress.state(battle)` devolve `{mode: "stage"|"boss"|"fog"|"none", fraction}`; o desenho só lê esse resultado.

## Padrões (não bloqueiam)

| # | Decisão | Padrão |
|---|---|---|
| P1 | Mostrar a barra também depois do chefe (Maré) | Sim |
| P2 | Texto na barra | Nenhum (só cor e marcador; o relógio já diz o tempo) |
| P3 | Largura | A do relógio (180 px) |

## Verificação

Teste do núcleo (`tests/test_stage_progress.gd`): fração em 0%, 50%, 100%; modo chefe; modo Maré (grace, warning, advancing); Pilares sem Maré; 2x. Prova por mutação (inverter a fração; ignorar `fog_state`). Capturas da HUD com `tools/` (desktop e celular) para checar sobreposição. Suíte `0 falha(s)`, smoke e `backlog_check`. **Se a captura mostrar sobreposição que só se resolve movendo o `StageLabel`, paro e pergunto.**

## Fora do escopo

Arte e ícones, ART-002 final, mudanças na simulação, nova tecla, sons. Julgar se a barra "ajuda" é do dono, no playtest.

## Portões

Commit só com aprovação explícita; push, exportação e aviso aos testers à parte; sem dependência nova; nada em `assets/`; mudanças de outras sessões preservadas.
