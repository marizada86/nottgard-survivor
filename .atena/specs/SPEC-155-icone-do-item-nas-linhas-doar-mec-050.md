---
id: "SPEC-155"
title: "Ícone do item nas linhas Doar do Altar da Doação (MEC-050)"
status: "IMPLEMENTADA localmente em 2026-10-09 (EVID-212); sem commit"
origin: planned
implementation_preceded_spec: false
request_classification: PLAN_DEVIATION
created: "2026-10-09"
relations: ["[[SPEC-087-fidelidade-e-eventos-de-risco]]", "[[SPEC-094-ofertas-em-cartao-resumido]]", "[[SPEC-151-sete-equipamentos-unicos-do-vault]]"]
cards: ["MEC-050"]
---

# SPEC-155 — Ícone do item nas linhas "Doar" (MEC-050)

Pedido do dono (2026-10-09, "comece pelo item 6"); origem do cartão: pergunta do dono em 2026-10-06 sobre os assets do Altar da Doação. Risco: **baixo** (interface), sem arte nova.

## Situação de partida

`Battle._open_risk_event("doacao")` cria uma linha `donate` por equipamento, sem dizer qual ícone usar. A lista de ícones da oferta (`ui/hud.gd`) tem `item_swap`, `shop_item` e `shop_item_up`, mas não `donate`, então as linhas "Doar" aparecem sem ícone. O comentário de `ui/overlay.gd` ainda dizia que doação, aposta e ampulheta não têm PNG, embora `assets/interactions/doacao.png`, `aposta.png` e `ampulheta.png` existam.

## Regra

1. Cada linha `donate` carrega `base`: o `base` do item (equipamento comum) ou, se não houver, o `id` (único).
2. `Hud.offer_icon_path(o)` (nova função estática, que concentra a escolha do ícone de qualquer oferta) devolve, para `donate`, `Items.item_icon(base)`. Os outros tipos de oferta mantêm exatamente o mesmo ícone de antes; tipo sem ícone devolve vazio.
3. Único sem PNG próprio usa o ícone provisório do `icon_like` (SPEC-151), como no resto do jogo.
4. O comentário do overlay passa a dizer a verdade (os três eventos têm PNG; arcanista e câmara não).

## Não objetivos

Mudar texto, preço, bênçãos ou a regra da doação; arte nova.

## Critérios de aceite

1. Para cada equipamento do herói há uma linha Doar com `base` igual ao `base` (ou `id`) do item e um ícone que existe.
2. Os demais tipos de oferta (cura, arma nova, tipo desconhecido) mantêm o ícone anterior.
3. Mutação: sem o caso `donate` o teste falha.
4. Suíte, smoke e captura da tela do altar sem falhas novas.

## Lacunas

Nenhuma `BLOCKING`.
