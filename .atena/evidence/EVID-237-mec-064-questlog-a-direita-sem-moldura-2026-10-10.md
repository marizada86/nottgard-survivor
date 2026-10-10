# EVID-237 — MEC-064: questlog à direita, sem moldura e translúcido (2026-10-10)

**Origem:** dono, "eu estive pensando num 'questlog' na direita do jogo sem interface para ser translúcido e o jogador não perder informação na tela".
**Desvio:** DEV-035 (PLAN_DEVIATION do PLAN-071); rota "fazer agora e voltar"; aprovação por plano (PLAN-095, SPEC-168).
**Resolve:** a pendência 1 da [EVID-236](EVID-236-bug-042-avisos-do-topo-acumulavam-e-colidiam-2026-10-10.md) (com 3 quests e chefe, os avisos desciam a y=247–340, sobre o herói). As correções (a) e (b) previstas ali foram **substituídas** por esta, por decisão do dono.

## Mudança
- `ui/quest_panel.gd`: o `QuestPanel` perdeu moldura, fundo e barra; texto com contorno alinhado à direita, o conjunto a `LOG_ALPHA = 0.8` (o pulso sobe a 1,0 e volta a 0,8); uma linha por objetivo (título, `n/N`, prazo, ◆); `urgent_index()` escolhe o de menor prazo (sem prazo, o primeiro) e só ele mostra a descrição; "+N objetivos" e "Carregando: …" por último.
- `ui/hud.gd`: o questlog saiu do `TopStack` e é filho da HUD, ancorado no topo direito (largura 300, margem 12, `offset_top = 66`, abaixo de `1x` e `?`); no celular desce para baixo dos botões de topo (`_place_questlog`); `STACK_WIDTH` 680 → 640 (a barra do chefe tem 580); as setas de evento desviam dele.
- `tests/test_playtest_fixes.gd`: `_questlog()`.

## Verificação
| Verificação | Resultado |
|---|---|
| `test_playtest_fixes` | 0 falhas; **mutação** (descrição em todas as linhas): 2 falhas |
| Smoke das 9 fases | ok |
| `kit_test` | OK |
| `mobile_buttons_check` | 146/0 |
| `controller_check --headless` | 90/0 |
| Suíte completa | **2 falhas, fora desta mudança**: `test_new_heroes.gd` ("arlindo/erik ainda usa arte provisória"), porque o commit `ce2d259` ("art: integrate Erik and Arlindo portraits and animations", de outra sessão, 2 min antes) trocou a arte; a expectativa do teste ficou velha. Não toquei. |
| Run real nas Docas, 3 quests + chefe + rajada de 6 avisos | avisos começam em y=90 (igual ao caso sem quests), 4 avisos, 92 px; questlog em x 968–1268 sem tocar `1x`/`?`/ficha (`e_rajada_quests_1280x720.png`) |
| Mesmo cenário em modo celular | questlog abaixo dos botões Ajuda/Ficha/Pausa (`e_rajada_quests_mobile_1280x720.png`) |

Capturas em `.atena/generated/bug-036-diag/`; logs em `.atena/generated/questlog-095/`.

## Pendências e limites
1. Subjetivo (legibilidade a 80% sobre mapas claros ou carregados, a descrição só do mais urgente bastar, a posição à direita) aguarda playtest.
2. Em 1280×720 o questlog com 6 objetivos ocupa 132 px (y 66–198); não foi medido em outras proporções (o `expand` só alarga a tela).
3. O `ObjectiveLabel` (juramento, buffs, Favor) continua no topo central, por decisão do dono.
4. As verificações da suíte completa ficam com 2 falhas até alguém atualizar `tests/test_new_heroes.gd` para a arte integrada (não é desta frente).
