# EVID-090 — Execução da SPEC-060 (escolha de equipar ou vender loot)

Data: 2026-09-28
SPEC: [[SPEC-060-escolha-de-equipar-ou-vender-loot]]
PLAN: [[PLAN-030-backlog-hiago-itens-equipamento-e-economia-2026-09-27]] (Fase B, item 2)

## Alterações realizadas

- `core/battle.gd`:
  - `give_item()` reescrito: slot vazio continua equipando direto (sem
    mudança observável); slot ocupado agora monta uma oferta de 2 opções
    (`t: "item_swap"`) e pausa a run com `state = "item_offer"`, em vez de
    decidir sozinho.
  - `_equip_item()` extraído da lógica de equipar que já existia.
  - `_resolve_item_choice(keep, sell)` novo: sempre vende a peça que não
    fica (mesma fórmula `8 * (rank + 1)` que já existia), remove a arma
    concedida pela peça vendida quando aplicável — corrige o comportamento
    anterior, em que o item substituído simplesmente desaparecia sem gerar
    moeda.
  - `choose()` estendido para aceitar `state == "item_offer"` e o tipo
    `item_swap`, com retorno para `state = "running"` sem tocar na lógica de
    `levelup`/`altar` já existente.
  - Comentário do enum de `state` atualizado.
- `ui/hud.gd`: `show_offer()` reconhece `offer_kind == "item"` (título
  próprio, ícone por `assets/icons/items/<base ou id>.png`, cor de destaque
  quando a opção equipa).
- `ui/run.gd`: `item_offer` roteado pelo mesmo caminho de `levelup`/`altar`
  (teclas 1–2, painel de oferta, refresh de estado).
- `tests/test_battle.gd`: novo bloco (9b) cobrindo as duas escolhas — equipar
  o novo item (vende o antigo, remove a arma concedida por ele, credita
  moedas) e manter o atual (vende o novo, credita moedas), incluindo que a
  run fica pausada em `item_offer` até a escolha.

Nenhum dado de jogo (`data/*.json`), fórmula de venda, geração de itens ou
sistema de armas/evolução foi alterado — só o fluxo de decisão no momento do
drop, como decidido pelo dono.

## Verificações executadas

| Comando | Resultado |
|---|---|
| `Godot_v4.7.2-stable_win64.exe --headless --path . -s tests/run_all.gd` | `testes: 0 falha(s)` |
| `Godot_v4.7.2-stable_win64.exe --headless --path . res://tools/smoke.tscn` | `smoke: ok` nas 8 fases |

Os testes novos (9b) exercitam diretamente `give_item`/`choose` para os dois
caminhos da oferta — inclusive o caso que corrige o comportamento anterior
(peça deslocada agora sempre gera moeda e perde a arma concedida). O smoke
confirma que a cena de run continua carregando e rodando sem erro com as
mudanças de `battle.gd`/`hud.gd`/`run.gd`.

## Exceção de validação

Mesma exceção da SPEC-059: sem checagem manual interativa (abrir um baú de
verdade numa run com um slot já ocupado e ver o painel de escolha aparecer)
nesta sessão. A lógica de UI (`show_offer`, roteamento de teclas 1/2) reusa
exatamente o mecanismo já validado para `levelup`/`altar`. Recomenda-se o
dono confirmar visualmente antes de considerar a SPEC-060 fechada ponta a
ponta.
