---
id: "SPEC-073"
title: "Nível de equipamento e super-upgrade por base"
status: "executada — suíte e smoke verdes; checagem manual interativa do dono pendente"
created: "2026-09-28"
relations:
  - "[[PLAN-034-pendencias-restantes-2026-09-28]]"
  - "[[PLAN-030-backlog-hiago-itens-equipamento-e-economia-2026-09-27]]"
  - "[[SPEC-064-eventos-economicos-loja-ferreiro-curandeiro]]"
---

# SPEC-073 — Nível de equipamento e super-upgrade por base

## Origem

Item 6 do backlog original de Hiago (Fase C, [[PLAN-030-backlog-itens-equipamento-e-economia-2026-09-27]]):
"Limitar o nível dos equipamentos, magias, etc e no nível final fazer um
upgrade do item. Exemplo: Cota de malha nível máximo aumenta +1CA e +2
força." Alinhado com o dono em
[[PLAN-034-pendencias-restantes-2026-09-28]]: o ferreiro (SPEC-064) sobe o
nível do equipamento equipado pagando moeda (sem depender de achar
duplicata), e o bônus final é definido à mão por base de item.

## Discovery

- Itens de armadura/amuleto/anel (`data/items.json`) não têm nenhum campo de
  nível hoje — são objetos rolados uma vez (`Items.roll()`), com `mods`
  fixos por raridade/afixo.
- `Hero.add_mods(into, src, times)` já aceita um multiplicador — dá pra
  escalar o mod de um item pelo nível **sem mutar o dicionário de mods
  original**, só na hora de agregar em `Hero.recalc()`.
- Uniques (`Items.unique()`) não têm campo `base` — ficam de fora do
  ferreiro nesta spec (identidade própria já forte, sem uma "base" pra
  buscar o bônus final; nivelar itens únicos fica pra decisão futura, fora
  de escopo aqui).
- O ferreiro (SPEC-064) já sabe montar oferta, cobrar `hero.gold` e aplicar
  efeito via `choose()` — este trabalho estende esse mesmo evento, não cria
  um novo.

## Escopo

1. Todo item rolado (`Items.roll()`) ganha `"level": 1` na criação.
2. Nível máximo de equipamento: **3**. `Hero.recalc()` escala os mods de
   cada item equipado por `1.0 + 0.15 * (level - 1)` ao agregar (via
   `add_mods(..., times)`), sem alterar o dicionário `mods` do item.
3. Ao atingir o nível 3, o item também aplica o **bônus fixo de super-
   upgrade da sua base**, definido à mão em `data/items.json`
   (`bases.<slot>[i].super`) — 13 bases, um bônus temático cada (ex.: Cota
   de Malha → `{"ca": 1, "forca": 2}`, exatamente o exemplo do Hiago).
4. O ferreiro (`_open_shop_event("ferreiro")`) ganha uma segunda categoria de
   oferta: para cada item equipado com `base` definido e `level < 3`, uma
   opção de subir 1 nível por um preço crescente — ao lado da oferta de
   armas já existente, sem substituí-la.
5. O painel de itens (`C`, SPEC-059) passa a mostrar o nível do item
   equipado e, se aplicável, que ele já tem o super-upgrade ativo.

## Não objetivos

- Não nivela itens únicos.
- Não altera o sistema de nível/evolução de armas já existente.
- Não implementa sinergias combinadas entre arma+acessório+magia (item 7 do
  backlog original) — spec separada, depois desta.
- Não altera a fórmula de venda, drop de itens ou qualquer economia fora do
  custo do próprio upgrade do ferreiro.

## Critérios de aceite

1. Item recém-encontrado começa no nível 1; `Hero.mods` reflete o mesmo
   valor de hoje (sem regressão) quando o item está no nível 1.
2. Subir o nível de um item equipado pelo ferreiro aumenta seus mods
   agregados em `Hero.mods` na proporção esperada, sem mutar o dicionário
   `mods` original do item.
3. Ao chegar no nível 3, o bônus de super-upgrade da base aparece somado em
   `Hero.mods`, uma única vez (não se acumula se comprado de novo — o item
   já está no nível máximo e some da oferta do ferreiro).
4. O painel de itens (`C`) mostra o nível atual do item.
5. Itens únicos não aparecem na oferta de nível do ferreiro.
6. Suíte e smoke continuam verdes; testes novos cobrem nível 1 sem
   regressão, escala de mods por nível, e aplicação do super-upgrade no
   nível máximo.

## Plano de voo proposto

1. Adicionar `"super"` a cada uma das 13 bases em `data/items.json`.
2. `Items.roll()`: incluir `"level": 1` no item retornado.
3. `Hero.recalc()`: escalar mods de item por nível e somar o `super` da base
   quando `level >= 3`.
4. `Battle._open_shop_event("ferreiro")`: nova categoria de oferta pra subir
   nível de item equipado; `choose()`: novo tipo `shop_item_up` que
   incrementa `item.level` e deduz `hero.gold`.
5. `ui/hud.gd`: mostrar nível do item no painel `C`.
6. Testes automatizados, suíte, smoke, registrar evidência.

## Limites

- Nível máximo (3) e o multiplicador por nível (15%) são estimativas de
  execução, revisáveis no próximo playtest.

## Reconciliação

- O dono aprovou esta SPEC em 2026-09-28.
- Executada em 2026-09-28: itens ganham nível 1 na criação, escalam mods
  por nível via multiplicador em `Hero.recalc()`, e aplicam um bônus fixo
  por base no nível máximo (3). O ferreiro oferece o upgrade pagando moeda;
  itens únicos ficam de fora. Evidência completa em
  [[EVID-097-spec-073-nivel-de-equipamento-2026-09-28]].
- `tests/run_all.gd`: `testes: 0 falha(s)` (bloco novo cobrindo nível 1,
  escala por nível, super-upgrade final e exclusão de únicos). Smoke
  (`tools/smoke.tscn`): `ok` nas 8 fases.
- Exceção: sem checagem manual interativa nesta sessão — ver EVID-097.
