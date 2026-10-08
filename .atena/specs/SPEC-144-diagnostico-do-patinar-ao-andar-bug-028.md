---
id: "SPEC-144"
title: "Diagnóstico instrumentado do patinar ao andar (BUG-028)"
status: "IMPLEMENTADA localmente em 2026-10-07 (PLAN-077); correção do bug fora do escopo; sem commit"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
created: "2026-10-07"
cards: ["BUG-028", "BUG-025"]
relations: ["[[PLAN-077-diagnostico-patinar-2026-10-07]]", "[[SPEC-018-direcoes-de-movimento-durvall]]"]
---

# SPEC-144 — Diagnóstico instrumentado do patinar ao andar

Pedido do dono (2026-10-07): "tem como fazer uma log e uma forma de colocar breakpoint para testar a real causa do
bug?". O BUG-028 (heróis patinam de lado e nas diagonais) está **adiado** desde 2026-10-05, e a tentativa A+B
(`WALK_FPS` 15 e `speed_scale`) falhou sem medição. Esta spec **não corrige o bug**: ela produz a evidência que
separa as causas candidatas. A correção vira spec própria depois, por decisão do dono.

## O que o código faz hoje (levantado em 2026-10-07)

- `Run._physics_process` chama `battle.step` e depois `_sync()`, que chama `HeroView.sync_visual(Iso.to_screen(h.pos), …)`
  uma vez por tick de física ([ui/run.gd:563](../../ui/run.gd)).
- `HeroView.sync_visual` ([ui/hero_view.gd:137](../../ui/hero_view.gd)) decide andar × idle por
  `distance_squared > 0.04` e escolhe a tira pelo setor de 8 direções do deslocamento **bruto** do tick
  (`WALK_SMOOTHING_HEROES` está vazio, então `_stable_direction` não roda).
- Só `move_e`, `move_se`, `move_s`, `move_n`, `move_ne` são carregadas (`WALK_SOURCE_DIRECTIONS`); `move_w`, `move_sw`
  e `move_nw` são **espelhos** (`flip_h`). Os arquivos `move_w/nw/sw.png` existem mas não entram em jogo.
- `sprite.play(desired)` roda sempre que a tira muda e **reinicia no quadro 0**.
- A tira roda a 10 fps (`add_strip`, 6 quadros), em tempo de renderização; a posição só muda em tick de física.
- O deslizamento contra obstáculos (`core/hero.gd`, `pos = nx` / `pos = ny`) pode gerar deslocamentos quebrados.

## Causas candidatas (nenhuma medida)

| # | Hipótese | Como o diagnóstico decide |
|---|---|---|
| H1 | Troca de tira por jitter de setor reinicia a animação no quadro 0 (nas diagonais e de lado) | contar trocas de tira e reinícios por segundo com direção de entrada constante |
| H2 | Queda breve para o idle por tick com deslocamento ≈ 0 (`moving` falso) | contar quedas ao idle com a tecla de movimento ainda pressionada |
| H3 | Passo curto para a velocidade (190 px/s de tela contra ciclo de ~114 px) | razão entre deslocamento do herói por ciclo e passada medida na arte |
| H4 | Passada da arte menor no leste e nas diagonais que em N e S | medir deslocamento dos pés por quadro em cada tira |
| H5 | Descompasso entre física (60 Hz) e renderização (monitor de taxa alta): a posição e a câmera andam em degraus enquanto a animação avança a cada quadro renderizado | registrar delta de render, ticks de física por quadro e fps |

## Escopo

1. **Log opt-in** (`WalkTrace`): CSV por sessão em `user://walk_trace/`, ligado só por `--walk-debug` (argumento de
   usuário) ou `NOTT_WALK_DEBUG=1`. Desligado por padrão; sem custo quando desligado.
   Colunas por tick: tempo, índice do tick, quadros renderizados desde o último tick, fps, posição em tela, deslocamento,
   `moving`, setor, tira, quadro, `flip_h`, velocidade do herói, `speed_scale`, `still_ticks`, tecla de movimento ativa.
   Eventos marcados: troca de tira, reinício de animação, queda ao idle com movimento pedido, retorno ao quadro 0
   fora do fim do ciclo.
2. **Gancho de breakpoint** em `HeroView`: função `_walk_break_check()` com `breakpoint` condicional (depurador do Godot,
   F5 no editor). Condições configuráveis: N trocas de tira em T segundos, queda ao idle com movimento pedido,
   reinício fora do fim do ciclo. Só ativa com `--walk-debug`.
3. **Controles de diagnóstico** (só com `--walk-debug`): congelar e avançar tick a tick; forçar uma direção
   (`--walk-force=<e|se|s|n|ne|w|sw|nw>`) para isolar a arte do código de direção.
4. **Medição offline da passada** (`tools/measure_walk_stride.gd`): deslocamento horizontal dos pés por quadro e por
   tira, comparado ao deslocamento do herói por quadro de animação na velocidade base e nas velocidades de cada herói.
5. **Teste automatizado** (`tests/test_walk_trace.gd`): simula andar nas 8 direções com `HeroView` e falha se houver
   troca de tira ou queda ao idle com entrada constante; verifica que o log fica desligado por padrão.
6. **Evidência e relatório**: EVID com a tabela H1–H5 (confirmada, descartada ou inconclusiva), números medidos e a
   recomendação de correção. Lançador `.cmd` para o dono rodar o `.exe` com a flag e devolver o CSV.

## Fora de escopo

Qualquer correção do BUG-028; regerar tiras; mudar `SPEED_PX`, `WALK_FPS` ou `speed_scale`; novos assets; commit,
push ou exportação do `.exe`.

## Critérios de aceite

- AC-1: sem `--walk-debug`, nenhum arquivo é criado e o comportamento do jogo é idêntico ao atual (teste).
- AC-2: com a flag, o CSV registra todas as colunas e os eventos listados, uma linha por tick.
- AC-3: o gancho para a execução no depurador nas três condições (testado forçando cada condição).
- AC-4: a medição offline gera uma tabela por tira e por herói.
- AC-5: o relatório classifica H1–H5 com números, sem alterar código de jogo além do gancho opt-in.
- AC-6: suíte existente com zero falhas; `tests/test_animation_assets.gd` e `test_scripts_compile.gd` passando.

## Lacunas

| Id | Lacuna | Classe | Padrão adotado |
|---|---|---|---|
| G1 | Como o dono vai rodar a coleta (editor com F5 ou `.exe`) | NON-BLOCKING | os dois: breakpoint no editor, CSV pelo lançador `.cmd` no `.exe` já exportado em `build/` se aceitar a flag; senão, build local temporária fora de `build/` |
| G2 | Heróis cobertos | NON-BLOCKING | Durvall e Korrak primeiro; medição offline cobre todos |
| G3 | `breakpoint` em build exportado | NON-BLOCKING | a palavra-chave é ignorada fora do depurador; a flag ainda protege |

Sem lacunas BLOCKING.

## Salvaguardas

Sem dependências novas, sem arte nova. Mudanças de outras sessões não commitadas ficam intocadas: o diagnóstico
edita apenas `ui/hero_view.gd` (limpo no git) e cria arquivos novos. Sem commit, push, merge ou exportação sem
aprovação explícita.
