# EVID-096 — Execução da SPEC-072 (segurar clique esquerdo para andar)

Data: 2026-09-28
SPEC: [[SPEC-072-segurar-clique-para-andar]]
PLAN: [[PLAN-034-pendencias-restantes-2026-09-28]]

## Alterações realizadas

- `ui/run.gd`: em `_physics_process`, quando nenhuma tecla de movimento
  está pressionada (`d == Vector2.ZERO`) e o botão esquerdo do mouse está
  segurado (`Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)`), calcula a
  direção tela herói→mouse e a usa como `d`, com zona morta de 4 px pra
  evitar tremor quando o clique cai muito perto do herói. WASD continua com
  prioridade total — só entra em jogo quando `d` já é zero.

Nenhuma mudança em `Hero`, `Battle`, mira (`aim_dir`/`aim_pos`) ou qualquer
outro sistema — a proteção contra clique em botões de UI durante ofertas
pausadas já vem de graça do guard existente em `Battle.step()`
(`if state != "running": return`), que já protegia o WASD do mesmo jeito.

## Verificações executadas

| Comando | Resultado |
|---|---|
| `Godot_v4.7.2-stable_win64.exe --headless --path . -s tests/run_all.gd` | `testes: 0 falha(s)` |
| `Godot_v4.7.2-stable_win64.exe --headless --path . res://tools/smoke.tscn` | `smoke: ok` nas 8 fases |

## Exceção de validação

Entrada de mouse/clique não é exercitada pela suíte headless nem pelo
smoke (ambos simulam `Battle` diretamente, sem `_physics_process` de
`ui/run.gd`). Sem checagem manual interativa nesta sessão — recomenda-se
confirmar segurando o clique numa run real, e também confirmar que clicar em
botões de oferta (level-up, loja, escolha de equipar/vender) continua
funcionando sem mover o herói por baixo do painel.
