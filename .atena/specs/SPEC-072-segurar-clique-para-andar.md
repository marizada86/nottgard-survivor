---
id: "SPEC-072"
title: "Segurar clique esquerdo para andar"
status: "executada — suíte e smoke verdes; checagem manual interativa do dono pendente"
created: "2026-09-28"
relations:
  - "[[PLAN-034-pendencias-restantes-2026-09-28]]"
  - "[[EVID-091-playtest-higo-hiago-build-c-e-item-offer-2026-09-28]]"
---

# SPEC-072 — Segurar clique esquerdo para andar

## Origem

Resposta 10 do playtest mais recente
([[EVID-091-playtest-higo-hiago-build-c-e-item-offer-2026-09-28]]): "a opção
de clicar e segurar o clique esquerdo para andar é bem vinda (como em
Vampire Survivors)".

## Discovery

- Movimento hoje só existe via WASD/setas
  (`Hero.movement_input()`, lido em `ui/run.gd:_physics_process`). O
  resultado é um vetor em **espaço de tela** (`Vector2(-1..1, -1..1)`),
  convertido para espaço isométrico só dentro de `Hero.step()`.
- O mouse **já mira continuamente** no modo Mira MOUSE
  (`battle.aim_dir`/`aim_pos`, recalculados todo frame pela posição do
  cursor, sem precisar de clique). Isso confirma que segurar o botão
  esquerdo pra andar **não conflita** com mirar — a mira não usa clique
  nenhum hoje.
- `battle.step(d, dt)` já retorna sem efeito quando `battle.state != "running"`
  (primeira linha da função). Isso significa que cliques em botões de UI
  durante ofertas pausadas (level-up, altar, loja, escolha de equipar/vender)
  **já não geram movimento indevido**, mesmo que um clique nessas telas seja
  lido como entrada de movimento por engano — o mesmo guard que já protege o
  WASD protege isso de graça, sem código novo.

## Escopo

1. Quando nenhuma tecla de movimento (WASD/setas) estiver pressionada e o
   botão esquerdo do mouse estiver **segurado**, mover o herói na direção da
   posição atual do cursor (mesmo vetor de tela já usado para calcular a
   mira, antes da conversão isométrica), com uma zona morta pequena para não
   "tremer" quando o clique cai muito perto do herói.
2. WASD continua tendo prioridade: se qualquer tecla de movimento estiver
   pressionada, o clique é ignorado para fins de movimento.

## Não objetivos

- Não altera o sistema de mira (`aim_dir`/`aim_pos`, modo AUTO/MOUSE).
- Não adiciona clique-para-mover-até-um-ponto (é contínuo enquanto o botão
  está segurado, como WASD — solta o botão, para de andar).
- Não altera nenhuma interação de UI existente (botões de oferta, baú,
  loja) — o clique nesses elementos continua funcionando normalmente.

## Critérios de aceite

1. Segurar o botão esquerdo sem nenhuma tecla de movimento pressionada move
   o herói continuamente em direção ao cursor.
2. Soltar o botão para o movimento imediatamente.
3. Pressionar uma tecla de movimento enquanto o botão está segurado usa o
   teclado, não o clique.
4. Clicar em qualquer botão de oferta/UI (level-up, altar, loja, escolha de
   equipar/vender) continua funcionando exatamente como antes — nenhuma
   regressão de clique de interface.
5. Suíte e smoke continuam verdes.

## Plano de voo proposto

1. Em `ui/run.gd:_physics_process`, quando `d == Vector2.ZERO`, checar
   `Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)` e computar a direção
   tela-herói→mouse (já calculada para `m_ground`, mas em espaço de tela,
   antes de `Iso.to_ground`), aplicando uma zona morta mínima.
2. Testar manualmente que não há regressão nos botões de oferta (o teste
   automatizado não cobre clique de UI; suíte/smoke cobrem a lógica de
   `Battle`).
3. Rodar suíte e smoke, registrar evidência.

## Limites

- Execução só começa após aprovação explícita desta spec pelo dono.

## Reconciliação

- O dono aprovou esta SPEC em 2026-09-28.
- Executada em 2026-09-28: `ui/run.gd` agora aceita segurar o clique
  esquerdo como entrada de movimento quando nenhuma tecla WASD está
  pressionada, reaproveitando a proteção já existente de `Battle.step()`
  contra movimento durante ofertas pausadas. Evidência completa em
  [[EVID-096-spec-072-segurar-clique-para-andar-2026-09-28]].
- `tests/run_all.gd`: `testes: 0 falha(s)`. Smoke (`tools/smoke.tscn`): `ok`
  nas 8 fases.
- Exceção: entrada de mouse não é exercitada por suíte/smoke (ambos
  simulam `Battle` sem passar por `ui/run.gd`) — sem checagem manual
  interativa nesta sessão, ver EVID-096.

## Adendo (2026-10-09, PLAN-090, BUG-039)

A verificação manual do BUG-007 ("sem mover ao clicar em painel") achou um defeito: o clique sobre a HUD (botão 1x, Ajuda, painel do herói, slot da habilidade) também fazia o herói andar até o botão, porque só as telas que pausam a batalha eram protegidas. Correção: `Hero.mouse_walk_dir(keys, pressed, over_ui, to_mouse)` (conta pura, `tests/test_mouse_walk.gd`) e `Hud.pointer_over_ui()` (`Viewport.gui_get_hovered_control`). Segurar o clique no mundo segue andando; WASD continua com prioridade. Evidência: [EVID-227](../evidence/EVID-227-plan-090-clique-na-hud-nao-move-o-heroi-2026-10-09.md).
