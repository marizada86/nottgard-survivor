---
id: "SPEC-060"
title: "Escolha de equipar ou vender loot de baú"
status: "executada — suíte e smoke verdes; checagem manual interativa do dono pendente"
created: "2026-09-28"
relations:
  - "[[PLAN-030-backlog-hiago-itens-equipamento-e-economia-2026-09-27]]"
  - "[[SPEC-059-descricao-de-itens-e-slots-visiveis]]"
---

# SPEC-060 — Escolha de equipar ou vender loot de baú

## Origem

Fase B do backlog de playtest de Hiago (item 2), triado em
[[PLAN-030-backlog-hiago-itens-equipamento-e-economia-2026-09-27]]. Na
entrevista de alinhamento de 2026-09-27, o dono decidiu o modelo:
**escassez com escolha, estilo roguelike** — o loot vira uma oferta que se
aceita, recusa ou vende no momento da coleta, não um inventário livre para
revisar depois. Esta spec é a base de que os itens 6 e 7 (Fase C) dependem.

## Discovery

- Loot só entra no jogo por `core/battle.gd:_open_chest()`, que chama
  `give_item(item)`. É o único call site em runtime (confirmado por busca no
  código); o resto do backlog de Fase B/C pode assumir esse único ponto de
  entrada.
- `give_item()` hoje **decide sozinho, sem nenhuma escolha do jogador**:
  - Se já existe item equipado no slot (`hero.items[slot]`) e o novo item tem
    raridade **menor**, o novo item é vendido automaticamente por
    `8 * (rank + 1)` moedas e descartado — o equipado atual não muda.
  - Caso contrário (raridade igual/maior, ou slot vazio), o novo item
    **substitui** o atual automaticamente. O item substituído **não é
    vendido nem gera moeda alguma — só desaparece**. Se o item substituído
    concedia uma arma (`weapon`), essa arma é removida do herói.
- Isso significa que o pedido do Hiago não é só "adicionar uma escolha" — é
  também corrigir uma perda de valor real: hoje, todo upgrade de equipamento
  destrói o item anterior sem compensação, enquanto todo item pior é vendido
  automaticamente por uma fórmula fixa. A spec unifica os dois caminhos: a
  peça que não fica equipada é sempre vendida pela mesma fórmula, e quem
  decide qual fica é o jogador.
- O padrão de "pausar e esperar uma escolha numerada" já existe e está
  validado: os estados `levelup` e `altar` já pausam a simulação
  (`state != "running"` guarda o `tick` em vários pontos de `battle.gd`) e
  `ui/run.gd` já roteia `KEY_1..KEY_9` para `battle.choose(i)` nesses estados.
  Reaproveitar esse mecanismo evita inventar um sistema de pausa novo.
- Quando o slot está vazio não há trade-off real (nada a comparar), então não
  há necessidade de pausar para perguntar — mantém o comportamento atual de
  equipar direto.

## Escopo

1. Quando um baú entrega um item para um slot **já ocupado**, a run pausa
   (mesmo padrão de `levelup`/`altar`) e apresenta uma escolha com 2 opções:
   - Equipar o novo (o item atual equipado é vendido pela fórmula existente
     `8 * (rank + 1)`).
   - Manter o atual (o novo item é vendido pela mesma fórmula).
   Cada opção mostra nome, raridade e descrição (reaproveitando
   `Items.mods_text()`/`note`, já usados em SPEC-059) dos dois itens em
   comparação, para decisão informada.
2. Quando o slot está **vazio**, o item continua sendo equipado
   automaticamente, sem pausar — comportamento atual preservado.
3. Se o item substituído concedia uma arma (`weapon`), a venda remove essa
   arma do herói, como já acontece hoje na substituição automática.

## Não objetivos

- Não criar um inventário navegável para revisar/trocar itens fora do momento
  da coleta — o modelo é decisão no drop, não inventário livre (decisão já
  tomada pelo dono).
- Não alterar a fórmula de venda (`8 * (rank + 1)`), a geração de itens
  (`Items.roll`), raridades, afixos ou únicos.
- Não mexer em armas ativas/feitiços (`hero.weapons`, `weapon_slots()`) além
  da remoção já existente de armas concedidas por item vendido.
- Não implementar objetos quebráveis (item 4) nem item de dano temporário
  (item 5) — specs próprias, depois desta.
- Não altera economia de moedas além de tornar a venda do item deslocado
  consistente com a fórmula que já existe para o item recusado.

## Critérios de aceite

1. Encontrar um item para um slot vazio equipa imediatamente, sem pausar —
   sem mudança de comportamento observável aqui.
2. Encontrar um item para um slot ocupado pausa a run e mostra as duas
   opções (equipar novo / manter atual), cada uma com nome, raridade e
   descrição dos dois itens.
3. Escolher "equipar novo" troca o item equipado e credita ao jogador a
   venda do item antigo pela fórmula vigente; escolher "manter atual" credita
   a venda do item novo pela mesma fórmula. Em ambos os casos, exatamente um
   item fica equipado e o outro vira moeda — nenhum item desaparece sem
   crédito.
4. Se o item que sai (equipado ou recusado) concedia uma arma, essa arma sai
   do herói junto — sem regressão do comportamento atual.
5. A suíte automatizada (incluindo os testes existentes de `give_item` em
   `tests/test_battle.gd`, atualizados para o novo fluxo) e o smoke test
   permanecem verdes.

## Plano de voo proposto

1. Introduzir um novo estado de oferta em `battle.gd` (`item_offer` ou
   equivalente) só para o caso de slot ocupado, reaproveitando a estrutura de
   `offer`/`offer_kind` já usada por `levelup`/`altar`.
2. Adaptar `give_item()`: slot vazio resolve direto (como hoje); slot ocupado
   monta a oferta de 2 opções e pausa, sem decidir sozinho.
3. Adicionar `resolve_item_offer(i: int)` (ou reaproveitar `choose()`) que
   aplica a escolha, credita a venda do item que não ficou e retoma
   `state = "running"`.
4. Estender `ui/hud.gd`/`ui/run.gd` para exibir e rotear essa oferta,
   reaproveitando o layout de `show_offer` já existente.
5. Atualizar `tests/test_battle.gd` para o novo fluxo (`give_item` em slot
   ocupado não resolve mais sozinho; testar as duas escolhas).
6. Rodar suíte e smoke, registrar evidência.

## Limites

- Escopo fechado no item 2 do backlog de Hiago (Fase B). Itens 4 e 5 são
  specs separadas; itens 6, 7 e 8 (Fase C) ficam bloqueados até esta spec
  estar reconciliada.

## Reconciliação

- O dono aprovou esta SPEC em 2026-09-28, junto com as recomendações do
  plano.
- Executada em 2026-09-28: `give_item()` só resolve sozinho quando o slot
  está vazio; slot ocupado abre uma oferta de 2 opções pausando a run
  (`state = "item_offer"`), reaproveitando o mecanismo de `levelup`/`altar`.
  A peça que não fica equipada é sempre vendida — corrige o comportamento
  anterior em que o item substituído desaparecia sem gerar moeda. Evidência
  completa em [[EVID-090-spec-060-escolha-equipar-vender-2026-09-28]].
- `tests/run_all.gd`: `testes: 0 falha(s)` (inclui novo bloco 9b cobrindo as
  duas escolhas). Smoke (`tools/smoke.tscn`): `ok` nas 8 fases.
- Exceção: sem checagem manual interativa nesta sessão — ver EVID-090.
