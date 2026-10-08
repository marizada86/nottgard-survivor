---
id: "EVID-197"
title: "Diagnóstico instrumentado do patinar ao andar (BUG-028): log, breakpoint, medição e sonda"
spec: "SPEC-144"
plan: "PLAN-077"
created: "2026-10-07"
status: "B-001 a B-004 concluídos localmente; aguardando coleta do dono para fechar a H5; sem commit"
---

# EVID-197 — Diagnóstico instrumentado do BUG-028

## O que foi entregue (tudo opt-in; sem a flag o jogo é idêntico)

| Peça | Arquivo | Função |
|---|---|---|
| Log CSV | [ui/walk_trace.gd](../../ui/walk_trace.gd) | `--walk-debug` ou `NOTT_WALK_DEBUG=1`; uma linha por tick e uma por troca de quadro; eventos `start`, `switch`, `idle_drop`, `stop`, `reset`, `frame` |
| Gancho no herói | [ui/hero_view.gd](../../ui/hero_view.gd) (`_walk_debug_setup`, `_walk_debug_tick`) | `breakpoint` condicional (`--walk-break=switch,idle,reset`, `--walk-break-n`, `--walk-break-window`); `--walk-force=<dir>`, `--walk-smooth`, `--walk-fps=N` |
| Congelar/avançar | [ui/walk_debug_controls.gd](../../ui/walk_debug_controls.gd) | `--walk-controls`: F9 congela, F10 avança um tick |
| Medição offline | [tools/measure_walk_stride.gd](../../tools/measure_walk_stride.gd) | passada desenhada por tira e herói; resultado em `.atena/generated/walk-debug/stride.csv` |
| Sonda em run real | [tools/walk_trace_probe.gd](../../tools/walk_trace_probe.gd) | anda em direções fixas ou ângulos livres, com mapa e colisão reais |
| Teste | [tests/test_walk_trace.gd](../../tests/test_walk_trace.gd) | desligado por padrão; 8 direções sem troca/queda; queda ao idle e jitter detectados e disparam o gancho |
| Lançador do dono | [.atena/generated/walk-debug/Abrir-jogo-com-diagnostico.cmd](../generated/walk-debug/Abrir-jogo-com-diagnostico.cmd) | menu com 5 modos; abre a pasta dos CSVs ao fechar |

Colunas do CSV: `tick, t_ms, render_frames` (quadros renderizados desde o tick anterior), `physics_frame, fps, hero, anim, frame, flip_h, sx, sy, dx, dy, moving, still_ticks, sector, input, speed_scale, event, detail`.
Local dos CSVs: `%APPDATA%\Godot\app_userdata\Nottgard Survivors\walk_trace\`.

## Verificação

- Suíte inteira (`tests/run_all.gd`): **0 falhas**, incluindo `test_walk_trace.gd` e `test_scripts_compile.gd`.
- Sem argumentos: `WalkTrace.enabled()` falso e nenhum arquivo criado (AC-1). Com `--walk-debug --walk-fps=15 --walk-force=se --walk-smooth` as opções são lidas corretamente (conferido por script).
- O `breakpoint` é no-op quando não há depurador; o teste conta `break_hits` e confirma o disparo nas três condições.
- Os CSVs gerados pela sonda foram apagados da pasta do usuário para não se misturarem à coleta do dono.

## Resultados por hipótese (SPEC-144)

| # | Hipótese | Resultado | Evidência |
|---|---|---|---|
| H1 | Jitter de setor reinicia a tira | **Não ocorre andando reto.** Oculta só na fronteira de setor ou em colisão | Sonda em run real (Durvall, Dagruve, 180 ticks, partindo do centro): 0 trocas nas 8 direções do teclado e em 8 de 9 ângulos livres (10°, 22°, 23°, 37°, 50°, 170°, 200°, 300°). A 100° houve 4 trocas em 180 ticks (provável deslize em obstáculo). O teste sintético mostra que, com movimento oscilando em ±2,5° da fronteira de 22,5°, a tira troca a cada tick sem suavização e 0 vezes com `--walk-smooth`. Falta ver se isso ocorre em jogo com mouse ou analógico |
| H2 | Queda ao idle por tick sem deslocamento | **Só ao ser bloqueado** (borda do mapa ou obstáculo com a tecla pressionada). Não ocorre em campo livre | Sonda: os dois únicos `idle_drop` (SE e S) coincidiram com 75–79 ticks sem deslocamento (parou num bloqueio). Em campo livre, 0 |
| H3 | Passo curto para a velocidade | **Compatível, não isolado** | O ciclo de 6 quadros a 10 fps cobre 114 px (103 px no Korrak, que tem −10 %) com a velocidade de 190 px/s. A 15 fps seriam 76 px |
| H4 | Passada da arte menor no leste e nas diagonais que em N e S | **Refutada como explicação única** | A abertura dos pés medida é pequena **em todas as direções**, inclusive N e S: velocidade que a planta do pé desenhada implicaria, Durvall a 10 fps: E 61, SE 12, S 9, NE 17, N 27 px/s, contra 190 px/s reais. Korrak E 76, SE 52. O dono diz que N e S estão bons, então só o tamanho da passada não separa os casos |
| H5 | Descompasso física × renderização | **Não verificável sem hardware do dono** | Em `--fixed-fps 60` headless cada tick coincide com um quadro. O CSV do dono traz `render_frames` por tick e `fps`; se houver ticks com 0 ou 2+ quadros, está confirmado |
| Ritmo da animação | 10 fps | **Correto** | Sonda: 30 trocas de quadro em 180 ticks (3 s) em todas as direções em campo livre |

Observações paralelas:
- `move_w`, `move_nw` e `move_sw` não são carregados; o jogo espelha E, NE e SE (confirmado em `WALK_SOURCE_DIRECTIONS`).
- O primeiro tick de uma run mede o deslocamento a partir da posição do nó no editor, não do ponto de partida do herói. Isso produz uma troca espúria no primeiro quadro (visível em teste, sem efeito prático).
- Limites da medição de passada: é uma métrica estática (bbox dos pés nos 10 % inferiores e ponto mais baixo por quadro), sensível a capa e arma na banda inferior. Serve para ordem de grandeza, não para um número exato.

## Conclusão

- **Descartado em campo livre:** troca de tira (H1) e queda ao idle (H2) com teclado. Os dados não mostram ruído de código no andar reto.
- **Sustentado:** a arte desenha pés bem mais lentos que o chão em todas as direções (H3/H4 em conjunto). Por ser igual em N e S, fica sem explicação a diferença que o dono percebe entre lado/diagonais e cima/baixo. Uma hipótese, ainda não testada: em N e S o movimento é na profundidade e o olhar não encontra referência horizontal do patinar.
- **Em aberto:** H5 e o caso de mouse/analógico; só a coleta no PC do dono decide.

## Próximo passo (dono)

1. Rodar `Abrir-jogo-com-diagnostico.cmd`, modo 1, jogar uns 2 minutos com Durvall andando de lado, nas diagonais e para cima e baixo.
2. Repetir no modo 3 (`--walk-force=se`) andando de lado e com mouse. Se o patinar sumir ou mudar, o código de direção está envolvido.
3. Repetir no modo 5 (15 fps). Se piorar ou melhorar de forma clara, o ritmo manda.
4. Enviar os CSVs. A leitura procura `render_frames` diferente de 1, `switch`, `idle_drop` e `reset`.

A correção do bug (passada nova ou 8 quadros, `SPEED_PX`, ritmo) continua fora deste plano e pede spec própria.

## Salvaguardas cumpridas

Sem dependências novas, sem arte, sem commit/push/exportação. Único arquivo existente editado: `ui/hero_view.gd` (limpo no git antes). Mudanças de outras sessões intactas.
