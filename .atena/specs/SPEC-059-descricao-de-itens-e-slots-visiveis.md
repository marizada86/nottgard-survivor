---
id: "SPEC-059"
title: "Descrição de itens equipados e slots visíveis"
status: "executada e estendida — suíte e smoke verdes; checagem manual interativa do dono pendente"
created: "2026-09-27"
relations:
  - "[[PLAN-030-backlog-hiago-itens-equipamento-e-economia-2026-09-27]]"
  - "[[PLAN-032-proxima-atualizacao-pos-playtest-2026-09-28]]"
  - "[[EVID-092-extensao-spec-059-ficha-de-personagem-2026-09-28]]"
---

# SPEC-059 — Descrição de itens equipados e slots visíveis

## Origem

Fase A do backlog de playtest de Hiago (itens 1 e 3), triado em
[[PLAN-030-backlog-hiago-itens-equipamento-e-economia-2026-09-27]]. Escolhida
para ir primeiro por ser exposição de UI sobre dado e limites que já existem,
sem tocar economia, save ou o sistema de evolução de armas.

## Discovery

- `desc` já é exibido em runtime para armas/habilidades na tela de level-up
  (`ui/hud.gd:152`) e no Códex (`ui/menu.gd:249`), mas os itens equipados
  (bases/afixos/únicos de `data/items.json`) não mostram descrição nenhuma
  durante a run — só aparecem como texto simples na lista do HUD (nome e,
  quando único, "(item)").
- `data/items.json` já tem `name` e `mods` para todo item, e `note` (lore) para
  as peças únicas. Não é necessário criar nenhum campo de dado novo para a
  descrição textual dos mods conhecidos; únicos sem `note` usam só nome + mods.
- Limites de slot já existem via `data/upgrades.json` (`bolso_fundo`: +1 slot
  de arma; `mao_cheia`: +1 opção de level-up), mas não há indicador de HUD
  mostrando quantos slots existem nem quantos estão ocupados, por categoria
  (arma, armadura, amuleto, anel).

## Escopo

1. Adicionar um painel/tooltip acessível durante a run que mostra, para cada
   item atualmente equipado, nome e efeito(s) em texto legível (reaproveitando
   o formato de descrição já usado nas outras telas), incluindo `note` quando
   existir.
2. Adicionar ao HUD um indicador `ocupados/limite` por categoria de slot
   (arma, armadura, amuleto, anel), lendo o limite vigente — incluindo
   bônus de upgrades meta como `bolso_fundo` — em vez de introduzir um novo
   sistema de limites.

## Não objetivos

- Não implementar escolha de equipar/vender no momento do drop (fica para a
  spec de Fase B do item 2, que já foi decidida como modelo de escassez com
  escolha — depende deste trabalho de exibição, mas é escopo separado).
- Não alterar números, mods, custos ou limites atuais de itens/upgrades.
- Não alterar o sistema de evolução de armas (`levels`/`evolve`) nem antecipar
  a Fase C (nível máximo de equipamento e sinergias).
- Não alterar save, economia de moedas ou dados de balanceamento.

## Critérios de aceite

1. Durante uma run, é possível consultar a descrição de cada item equipado
   (nome + efeito(s), e lore quando existir) sem abrir o Códex do Quartel.
2. O HUD mostra a contagem `ocupados/limite` de cada categoria de slot
   (arma, armadura, amuleto, anel), correta antes e depois de comprar
   upgrades que alteram limites (ex.: `bolso_fundo`).
3. Nenhum valor de mod, custo ou limite existente muda de comportamento —
   apenas exibição nova.
4. A suíte automatizada e o smoke test permanecem verdes.

## Plano de voo proposto

1. Levantar no código onde os itens equipados ficam armazenados em runtime
   (provavelmente em `core/battle.gd`/estruturas de `Hero`), para reaproveitar
   como fonte única de dado do tooltip e do contador de slots.
2. Implementar o painel/tooltip de descrição, reaproveitando o formato de
   texto já usado em `ui/hud.gd`/`ui/menu.gd` para armas e melhorias.
3. Implementar o indicador de slots no HUD, lendo os limites vigentes
   (incluindo modificadores meta já aplicados ao perfil).
4. Cobrir com teste automatizado: descrição aparece para item com e sem
   `note`; contador de slots reflete limite base e limite com upgrade meta.
5. Rodar suíte e smoke, registrar evidência da execução.

## Limites

- Escopo fechado nos itens 1 e 3 do backlog de Hiago. Qualquer mudança de
  modelo de loot, economia ou progressão de equipamento é outra spec.

## Reconciliação

- O dono aprovou esta SPEC em 2026-09-27 ("está aprovado").
- Executada em 2026-09-27: painel de itens/feitiços aberto pela tecla `C`
  (fecha com `C` ou `Esc`), com descrição de armas/feitiços, passivas, itens
  equipados e bênçãos, mais indicador `ocupados/limite` de armas e de
  equipamento. Evidência completa em
  [[EVID-089-spec-059-descricao-itens-e-slots-2026-09-27]].
- `tests/run_all.gd`: `testes: 0 falha(s)`. Smoke (`tools/smoke.tscn`): `ok`
  nas 8 fases.
- Exceção: sem checagem manual interativa (apertar `C` numa run real) nesta
  sessão — ver EVID-089 para o motivo e a recomendação de verificação pelo
  dono antes de fechar a spec como totalmente validada.

## Extensão pós-playtest (2026-09-28)

Respostas 1, 2 e 3 do questionário de playtest
([[EVID-091-playtest-higo-hiago-build-c-e-item-offer-2026-09-28]]) pediram
mais do que a entrega original cobria. Por decisão do dono, isso entrou como
extensão desta mesma spec, não como spec nova:

1. **Dica visível durante o jogo** (resposta 1): novo label estático no HUD
   ("[C] Itens e feitiços"), sempre visível durante a run, complementando a
   dica que já existia só no menu de pausa.
2. **Ficha de personagem** (resposta 3): o painel `C` ganhou um cabeçalho com
   o retrato do herói (`assets/portraits/<id>.png`, já existente e usado no
   Quartel), atributos finais (FOR/INT/CON/CAR, PV, CA e CAM já com todos os
   mods aplicados, via `Hero.attr()`/`ca()`/`cam()`/`max_hp` existentes) e uma
   linha de bônus ativos agregando item+passiva+bênção+meta num só lugar,
   via `Items.mods_text(hero.mods)` — reaproveitando formatação que já
   existia, sem inventar cálculo novo.
3. **"Mais detalhe ao passar o mouse" (resposta 2)**: decisão de projeto —
   em vez de reestruturar a lista compacta em widgets individuais só para
   suportar tooltip por item, o cabeçalho de totais acima já expõe a
   informação "específica" que faltava (o problema relatado era falta de
   dado agregado, não a falta de hover em si). Registrado aqui como decisão
   consciente, não como pendência.

Evidência completa em
[[EVID-092-extensao-spec-059-ficha-de-personagem-2026-09-28]].
