---
id: "SPEC-168"
title: "Questlog à direita, sem moldura e translúcido (MEC-064; resolve a pendência da EVID-236)"
status: "IMPLEMENTADA LOCAL em 2026-10-10 (PLAN-095, EVID-237); aguarda playtest"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
created: "2026-10-10"
relations: ["[[SPEC-147-correcoes-dos-playtests-v032-e-v033]]", "[[SPEC-167-avisos-do-topo-sem-acumular-nem-colidir-bug-042]]", "[[SPEC-159-seta-de-evento-na-borda-da-tela-mec-061]]"]
cards: ["MEC-064", "MEC-055", "BUG-042"]
visual_direction: "sem moldura nem fundo; texto com contorno, alinhado à direita, a 80% de opacidade; DRAFT até o dono ver em jogo"
---

# SPEC-168 — Questlog à direita

Origem: pedido do dono em 2026-10-10 ("eu estive pensando num 'questlog' na direita do jogo sem interface para ser translúcido e o jogador não perder informação na tela"). Resolve a pendência 1 da [EVID-236](../evidence/EVID-236-bug-042-avisos-do-topo-acumulavam-e-colidiam-2026-10-10.md): com 3 quests e chefe, a pilha de avisos descia a y=247–340, sobre a cabeça do herói.

## Hoje (lido em 2026-10-10)
- `QuestPanel` (`ui/quest_panel.gd`, SPEC-147/MEC-055) é filho do `TopStack` central, com moldura dourada, fundo a 84%, descrição e barra por objetivo; 3 quests ocupam ~150 px e empurram os avisos para o centro da tela.
- A direita só tem `SpeedBtn` e `HelpBtn` (x 1168–1268, y 12–58) e as setas de evento na borda (SPEC-159).

## Decisões do dono (2026-10-10)
| # | Decisão |
|---|---|
| D1 | O questlog **substitui** as correções (a) avisos acima do painel e (b) teto menor com quests. |
| D2 | Conteúdo: título, progresso e prazo de cada objetivo; descrição só do objetivo mais urgente. |
| D3 | Linhas de status (juramento, buffs, Favor) ficam no topo central; "Carregando: …" vai no questlog. |
| D4 | Aprovação **por plano**; rota fazer agora e voltar ao PLAN-071. |

## Comportamento novo
1. O `QuestPanel` sai do `TopStack` e vira o **questlog**: filho da HUD, ancorado no topo direito (`offset_top = 66`, largura 300 px, margem direita 12 px, abaixo dos botões `1x` e `?`).
2. **Sem interface:** sem moldura, sem fundo e sem barra de progresso; texto com contorno, alinhado à direita, o conjunto a `LOG_ALPHA = 0.8`. O pulso de brilho (objetivo nasceu, avançou, terminou) volta a 0,8.
3. Cada objetivo é uma linha: `◆ Título   1/3   95 s` (progresso só com `need > 1`; prazo vira vermelho a 10 s ou menos). Até `MAX_ROWS = 4`, depois "+N objetivos".
4. A descrição aparece só no objetivo **mais urgente**: o de menor prazo restante; sem prazo, o primeiro.
5. "Carregando: …" é a última linha do questlog.
6. As setas de evento (SPEC-159) desviam do questlog (`avoid_nodes`).
7. `ObjectiveLabel` (status) continua na pilha do topo, sem mudança.

## Fora do escopo
- Quartel, ficha e Diário; o texto dos objetivos; o destaque no mundo (anel e seta, MEC-055 S-006).
- Arte, lettering (ART-039) e o plano de "mensagens ao centro".
- Recolher o questlog por tecla ou clique (candidato a backlog se o playtest pedir).

## Aceite
1. Com 0, 1, 3 e 6 objetivos, o questlog não intercepta `SpeedBtn`, `HelpBtn`, o `TopStack` nem a ficha do herói, e fica dentro da tela (1280×720).
2. O `TopStack` não contém o questlog; com 3 quests e chefe vivo os avisos começam no mesmo y que sem quests.
3. Sem estilo de fundo (painel vazio), sem barra de progresso, opacidade 0,8; "+N" com mais de 4; descrição só no mais urgente; "Carregando" por último.
4. A seta de evento desvia do questlog.
5. Suíte, smoke, `mobile_buttons_check`, `controller_check` e `kit_test` sem falhas; uma mutação do teste novo.
6. Subjetivo (legibilidade a 80% sobre o mapa, a descrição do mais urgente bastar) pendente de playtest.

## Reversão
Reverter o commit local; nada em dados, save ou assets.
