# EVID-120 — Suporte a controle joystick

**SPEC:** `[[SPEC-096-suporte-completo-a-controle-joystick]]`  
**Data:** 2026-09-29  
**Estado:** automação validada; teste físico pendente

## Mudança entregue

- Ações semânticas registram os dois analógicos, direcional, RB, LB, Start,
  Back/View, leste, sul e os comandos de run equivalentes ao teclado.
- Movimento usa zona morta de `0.24` com intensidade progressiva; teclado
  ainda tem prioridade e o clique para caminhar continua como alternativa.
- No modo de mira manual, o analógico direito atualiza a mira e preserva a
  última direção válida quando retorna à zona morta. Mover o mouse volta a dar
  prioridade à mira por cursor.
- Ofertas, pausa, inventário, reviver, resultado, menu e guia recebem foco
  inicial ou retorno navegável; o direcional/analógico esquerdo alimenta a
  navegação padrão de UI. O botão sul fecha somente painéis seguros.
- O guia de controles foi atualizado para teclado/mouse e controle.

## Verificações executadas

| Verificação | Resultado |
|---|---|
| `tests/run_all.gd` | `testes: 0 falha(s)` |
| Contrato novo `test_input_controls.gd` | ações, botões de controle e zona morta aprovados |
| `tools/smoke.tscn` | `smoke: ok` nas 9 fases |
| `git diff --check` | aprovado, sem erros de espaço ou marcadores |

O ambiente registrou avisos preexistentes de log `user://`, certificados do
sistema e recursos de renderização ao encerrar o Godot. Eles não produziram
falhas de teste ou fumaça.

## Exceção de validação

Não há um controle físico disponível nesta sessão para verificar driver,
rotulagem e sensação de zonas mortas no dispositivo real. Isso impede afirmar
o critério de aceite de jornada completa com hardware como concluído. A próxima
checagem manual deve cobrir:

1. Título → menu → seleção de herói/fase → iniciar partida;
2. Movimento nos dois eixos, direcional e repouso sem deriva;
3. Mira manual pelo analógico direito e retomada pelo mouse;
4. Interação, habilidade, pausa, inventário, velocidade, extração e oferta;
5. Navegação e retorno em oferta, loja, altar, reviver, resultado e guia.

## Reconciliação

- Contrato permanente: `[[INPUT-CONTROL-001-joystick-2026-09-29]]`.
- Plano de origem preservado como `[[PLAN-044-suporte-completo-a-controle-joystick-2026-09-29]]`.
- SPEC-096 aponta para esta evidência e permanece em validação manual pendente.
