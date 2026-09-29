---
id: "SPEC-064"
title: "Eventos econômicos: loja, ferreiro e curandeiro"
status: "executada — suíte e smoke verdes; checagem manual interativa do dono pendente"
created: "2026-09-28"
relations:
  - "[[PLAN-032-proxima-atualizacao-pos-playtest-2026-09-28]]"
  - "[[PLAN-030-backlog-hiago-itens-equipamento-e-economia-2026-09-27]]"
  - "[[EVID-091-playtest-higo-hiago-build-c-e-item-offer-2026-09-28]]"
  - "[[SPEC-060-escolha-de-equipar-ou-vender-loot]]"
---

# SPEC-064 — Eventos econômicos: loja, ferreiro e curandeiro

## Origem

Item 8 do backlog de Hiago (loja/ferreiro/curandeiro), pedido de novo nas
respostas 8 e 10 do playtest mais recente
([[EVID-091-playtest-higo-hiago-build-c-e-item-offer-2026-09-28]]: "seria bom
o evento de loja no jogo"; "adicionar mais eventos aleatórios"). Último item
da ordem combinada com o dono (Zumbi → ficha de personagem →
quebráveis+drop → **loja**).

## Discovery

- **`stats.gold` (histórico) é separado de `hero.gold` (saldo corrente).**
  `core/battle.gd:result()` calcula a recompensa final a partir de
  `stats.gold` — um acumulador que só cresce, nunca é reduzido por gasto.
  `hero.gold` é o saldo exibido no HUD ("Moedas") e pode subir e descer.
  **Gastar `hero.gold` numa loja durante a run não afeta a recompensa
  final.** Isso remove o risco de balanceamento econômico que
  [[PLAN-030-backlog-hiago-itens-equipamento-e-economia-2026-09-27]] tinha
  levantado — não é necessária nenhuma spec de economia separada (decisão já
  tomada na entrevista de alinhamento).
- **O padrão de pausar e oferecer escolhas já existe três vezes**
  (`levelup`, `altar`, `item_offer` de SPEC-060) — a base de
  `offer`/`offer_kind`/`choose()` é reaproveitada para o evento econômico,
  não um sistema novo.
- **Armas já têm nível** (`Weapon.level`, `max_level()`, `levels` em
  `data/weapons.json`) — "ferreiro" não precisa de nenhum sistema de nível de
  equipamento novo. O pedido de nível para armadura/amuleto/anel (itens 6/7
  do backlog original) continua fora de escopo — é Fase C, ainda não feita.
  Ferreiro, nesta spec, sobe o nível de uma **arma** equipada elegível.
- **`give_item()` já decide sozinho** (SPEC-060): equipa direto se o slot
  está vazio, ou abre a escolha equipar/vender se está ocupado. Uma compra de
  loja pode chamar `give_item()` tal como um baú chama — reaproveita a
  mecânica inteira sem código novo.
- **A fonte (`fountain`) já cura de graça, parcialmente** (`_update_interactions`,
  ~40% do PV máximo). Um "curandeiro" pago só se justifica sendo mais forte
  (cura completa ou quase) — senão é redundante com o que já existe de
  graça.
- **Interações manuais por `E` já existem** (`interact()`, tipos `altar`,
  `ritual`, `portal`) e **interações automáticas por proximidade** (`chest`,
  `fountain`, em `_update_interactions`), escolhidas por peso em
  `stage.interactions` (`_spawn_random_interaction`). Os três eventos
  econômicos entram como um quarto grupo de interação manual (`E`), pesado
  como qualquer outro tipo.
- **Sem arte de ativação nova**: `ui/run.gd:_play_interaction()` já
  degrada graciosamente (não desenha nada) quando o tipo de interação não
  tem uma folha de animação mapeada — os três eventos novos não têm
  animação de ativação nesta entrega, sem quebrar nada.

## Escopo

1. Três novos tipos de interação manual (`E`): `loja`, `ferreiro`,
   `curandeiro`. Entram nos pesos de `stage.interactions` de cada fase
   (mais raros que baú).
2. Interagir pausa a run (`state = "shop"`) e mostra uma oferta com até 3
   opções + **"Sair"**, sempre grátis, sempre disponível, sem obrigação de
   comprar.
3. **Loja**: 2 itens sorteados (mesmo gerador `Items.roll()` dos baús), cada
   um com preço em moeda. Comprar deduz `hero.gold` e chama `give_item()` —
   se o slot já está ocupado, abre a escolha de equipar/vender da SPEC-060
   normalmente.
4. **Ferreiro**: oferece subir 1 nível de uma arma equipada elegível
   (`w.level < w.max_level()`, excluindo armas concedidas por item), com
   custo crescente pelo nível atual. Sem arma elegível, mostra só "Sair".
5. **Curandeiro**: oferece cura generosa (definida na execução, ex. cheia ou
   quase) por um preço proporcional ao PV faltante.
6. Preços escalam com `stage.coin_mult`/`tier()`, na mesma linha de outros
   custos do jogo.
7. Compra deduz apenas `hero.gold` — nunca `stats.gold`.

## Não objetivos

- Não implementa nível de equipamento (armadura/amuleto/anel) — Fase C,
  ainda não feita.
- Não implementa sinergias de evolução combinada (item 7 do backlog).
- Não altera `stats.gold` nem o cálculo de `result()`.
- Não adiciona arte/animação de ativação nova para os três eventos.
- Não adiciona mais de 3 subtipos de evento econômico nesta entrega.

## Critérios de aceite

1. Os três subtipos aparecem como interação no mundo, ativável por `E`,
   pausando a run como altar já faz.
2. Toda oferta econômica tem uma opção "Sair" sem custo, sem penalidade.
3. Comprar da loja gasta exatamente o preço mostrado e entrega o item do
   mesmo jeito que um baú entregaria — inclusive abrindo a escolha de
   equipar/vender se o slot já estiver ocupado.
4. Ferreiro só oferece armas com nível abaixo do máximo; sem nenhuma
   elegível, mostra só "Sair".
5. Curandeiro cura a quantia anunciada e cobra exatamente o preço mostrado.
6. Tentar comprar sem moeda suficiente não é permitido (opção bloqueada ou
   ausente).
7. Nenhuma compra altera `stats.gold`; `result().gold` continua calculado
   exatamente como antes desta spec.
8. Suíte e smoke continuam verdes; testes novos cobrem: compra bem-sucedida
   de cada subtipo, tentativa sem moeda suficiente, e "Sair" sem custo.

## Plano de voo proposto

1. Adicionar os três pesos de interação em `data/stages.json` (todas as 8
   fases).
2. Implementar `_open_shop_event(kind)` (mirroring `_open_altar()`), montando
   a oferta com preços calculados por subtipo.
3. Estender `choose()`/`offer_kind` para os três subtipos: deduzir
   `hero.gold`, aplicar o efeito (loja → `give_item()`; ferreiro → `w.level
   += 1`; curandeiro → `_heal_hero()`), ou simplesmente fechar em "Sair".
4. Ligar `loja`/`ferreiro`/`curandeiro` a `interact()` (tecla `E`), no mesmo
   grupo de `altar`/`ritual`/`portal`.
5. `ui/hud.gd`: `show_offer()` reconhece os novos `offer_kind` (título
   próprio); prompt de interação (`[E] ...`) ganha as três novas entradas.
6. Testes automatizados, suíte, smoke, registrar evidência.

## Limites

- Preços e a força da cura do curandeiro são estimativas de execução,
  explicitamente revisáveis no próximo playtest — esta spec não os trava.

## Reconciliação

- O dono aprovou esta SPEC em 2026-09-28.
- Executada em 2026-09-28: três eventos econômicos (loja, ferreiro,
  curandeiro) como interação manual (`E`), pausando a run e reaproveitando
  `give_item()` (SPEC-060) para compras de loja em slot ocupado. Evidência
  completa em [[EVID-094-spec-064-eventos-economicos-2026-09-28]].
- `tests/run_all.gd`: `testes: 0 falha(s)` (bloco novo cobrindo os três
  subtipos, "Sair" e ausência de opção sem moeda). Smoke
  (`tools/smoke.tscn`): `ok` nas 8 fases.
- Exceção: sem checagem manual interativa nesta sessão — ver EVID-094.
