---
id: "SPEC-063"
title: "Objetos quebráveis e rebalanceamento de drop de poção"
status: "executada — suíte e smoke verdes; checagem manual interativa do dono pendente"
created: "2026-09-28"
relations:
  - "[[PLAN-032-proxima-atualizacao-pos-playtest-2026-09-28]]"
  - "[[EVID-091-playtest-higo-hiago-build-c-e-item-offer-2026-09-28]]"
  - "[[PLAN-030-backlog-hiago-itens-equipamento-e-economia-2026-09-27]]"
  - "[[EVID-093-spec-063-quebraveis-e-rebalanceamento-2026-09-28]]"
---

# SPEC-063 — Objetos quebráveis e rebalanceamento de drop de poção

## Origem

Respostas 8 e 10 do playtest
([[EVID-091-playtest-higo-hiago-build-c-e-item-offer-2026-09-28]]):
quebráveis (candelabro, caixote, arbusto) com variação por bioma — "caixas e
candelabros não combinam com alguns mapas do abismo" — e rebalancear pra que
monstro comum não largue mais poção, só quebráveis e elites (elites com
chance baixa). Por decisão do dono, as duas coisas entram numa spec só,
porque o rebalanceamento só faz sentido se a nova fonte de cura já existir.

Item 4 da Fase B mapeada em
[[PLAN-030-backlog-hiago-itens-equipamento-e-economia-2026-09-27]].

## Discovery

- **Drop de poção hoje é indiscriminado.** `core/battle.gd:_kill()` dá 2,5%
  de chance de poção pra **qualquer** inimigo com XP > 0 — ou seja,
  praticamente todo inimigo comum. Elites (`e.affix != "" or e.drops_chest`)
  já ganham baú + moeda garantida, mas nenhuma chance própria de poção.
- **Não existe entidade quebrável hoje.** Os objetos parecidos são só
  decoração (`ui/prop.gd` + `data/prop_visuals.json`): caixote
  (`caixote_01/02/03.png`) e velas (`velas_01/02/03.png`) já existem como
  arte, mas só bloqueiam movimento — sem HP, sem dano recebido, sem drop.
  Não existe arte de "arbusto" nem "candelabro" ainda.
- **`Enemy` é o único tipo de entidade com HP/morte/drop do jogo** — o
  caminho de menor risco é reaproveitá-lo como uma variante inerte, não criar
  um sistema paralelo. `speed = 0` já impede movimento
  (`core/battle.gd:872`), mas **mesmo um inimigo parado ainda ataca** se o
  herói chegar a 1.4 de distância (`core/battle.gd:901-904`) — preciso de um
  guard novo (`flags` já suporta tags livres, ex. `ghost`/`illusory`) pra um
  quebrável não atacar o jogador.
- **"Ímã" não existe como pickup.** Só há `xp`, `gold`, `potion`
  (`core/battle.gd:_collect()`). Pickups já têm um campo `magnet` por item
  que os puxa pro herói (`_update_pickups`); um pickup "ímã" novo só precisa
  ativar `magnet = true` em todos os pickups do mapa de uma vez —
  reaproveita o sistema existente.
- **Biomas.** Cada fase já declara um `prop.kind` de ambientação própria
  (`data/stages.json`): Dagruve = pilar, Docas = doca, Shedaklah = cogumelo,
  Molor = bolha, Durao = rocha, Feng-tu = torii, etc. Caixote/velas foram
  criados especificamente para Dagruve/Docas (SPEC-022 a SPEC-031, tema de
  cais/porto). Proponho ler "mapas do abismo" como as fases que já tocam o
  rio Estige (Shedaklah em diante), em oposição a Dagruve/Docas, que são a
  única dupla de fases fora do tema abissal — confirmável/ajustável durante
  a execução, não travado nesta spec.

## Escopo

1. **Flag `"inerte"` em `Enemy`**: pula o bloco de ataque automático em
   `_enemy_step` quando presente. Não afeta nenhum inimigo existente.
2. **Três tipos de quebrável** (`data/enemies.json`): `candelabro`, `caixote`,
   `arbusto` — HP baixo fixo (morre em 1–2 acertos), `xp = 0`,
   `speed = 0`, `flags = ["inerte", "quebravel"]`. `caixote` reaproveita a
   arte já existente; `candelabro`/`arbusto` entram na fila de geração
   ([[SPEC-062-fila-de-geracao-externa-de-assets]]) quando a arte chegar —
   até lá, usam um asset provisório sem bloquear a mecânica.
3. **Restrição por bioma**: `candelabro`/`caixote` só aparecem em
   Dagruve/Docas; `arbusto` pode aparecer em qualquer fase.
4. **Drop table garantida do quebrável**: ao morrer, sorteia exatamente um
   entre poção, moeda ou ímã — não é chance de não dropar nada.
5. **Novo pickup "ímã"**: ao coletar, ativa `magnet = true` em todos os
   pickups vivos no mapa.
6. **Rebalanceamento**: remove a chance de poção do inimigo comum; elites
   ganham uma chance própria e baixa de poção (ordem de grandeza parecida
   com a chance antiga, ex. 5–8%, a ajustar na execução).

## Não objetivos

- Não altera o sistema de baú/equipamento de elite, evolução de armas ou
  economia do Quartel.
- Não gera arte nova nesta spec — `candelabro`/`arbusto` ficam com
  placeholder até serem processados pela fila de geração (SPEC-062).
- Não muda o sistema de interação por tecla `E` (altar/ritual/portal/baú);
  quebrável morre por dano direto, como um inimigo.
- Não define a cadência exata de quantos quebráveis por fase — fica como
  decisão de execução, revisável no próximo playtest.

## Critérios de aceite

1. Inimigo comum morto nunca mais dropa poção diretamente.
2. Elite morto tem uma chance baixa e própria de dropar poção, além do que já
   dropa hoje (baú, moeda).
3. Um quebrável não se move e não ataca o herói mesmo parado ao lado; morre
   em poucos acertos e sempre dropa exatamente um item (poção, moeda ou
   ímã).
4. `candelabro`/`caixote` não aparecem em fases fora de Dagruve/Docas;
   `arbusto` aparece em qualquer fase.
5. Coletar um ímã ativa a atração em todos os pickups presentes no mapa
   naquele momento.
6. Suíte e smoke continuam verdes; teste novo cobre que um quebrável com
   `speed=0` e `flags=["inerte"]` não inicia ataque mesmo com o herói dentro
   do alcance.

## Plano de voo proposto

1. Adicionar o flag `"inerte"` e o guard correspondente em `_enemy_step`.
2. Adicionar os três IDs de quebrável em `data/enemies.json`.
3. Implementar a restrição de bioma no spawn dos quebráveis.
4. Implementar spawn dos quebráveis na run (pontos por fase).
5. Implementar drop table garantida em `_kill()` para `flags.has("quebravel")`.
6. Implementar o pickup "ímã" em `_collect()`.
7. Remover a chance de poção do inimigo comum; adicionar chance baixa no
   elite.
8. Testes automatizados, suíte, smoke, registrar evidência.

## Limites

- Arte final de candelabro/arbusto depende da fila de geração (SPEC-062);
  esta spec não bloqueia nem antecipa isso.

## Reconciliação

- O dono aprovou esta SPEC em 2026-09-28.
- Executada em 2026-09-28: flag `"inerte"` impede ataque; três quebráveis
  (`candelabro_quebravel`, `caixote_quebravel`, `arbusto_quebravel`) com
  drop garantido de poção/moeda/ímã; poção removida do inimigo comum e
  realocada como chance baixa (6%) do elite; pickup "ímã" novo reaproveita
  o campo `magnet` já existente. Candelabro/caixote reaproveitam arte já
  existente (`velas_01.png`/`caixote_01.png`); arbusto usa
  `cogumelo_fungico.png` como placeholder até a fila de geração
  (SPEC-062) entregar arte própria. Evidência completa em
  [[EVID-093-spec-063-quebraveis-e-rebalanceamento-2026-09-28]].
- `tests/run_all.gd`: `testes: 0 falha(s)` (dois blocos novos de teste).
  Smoke (`tools/smoke.tscn`): `ok` nas 8 fases.
- Exceção: sem checagem manual interativa nesta sessão — ver EVID-093.

## Amendment: quebráveis por bioma e drop enviesado (2026-09-28)

A pedido do dono, dois ajustes sobre a base já executada:

1. **Um quebrável temático por bioma**, em vez de só `arbusto_quebravel`
   fora de Dagruve/Docas: `saco_de_esporos_quebravel` (Shedaklah),
   `casulo_viscoso_quebravel` (Molor), `urna_funeraria_quebravel` (Durao),
   `lanterna_de_papel_quebravel` (Feng-tu), `espelho_ilusorio_quebravel`
   (Shendilavri), `estatua_rachada_quebravel` (Goranthis),
   `relicario_instavel_quebravel` (Pilares). Arbusto continua como
   alternativa em todo bioma sub-decorado. Prompts de arte definitiva em
   [[ART-PROMPTS-024-cenario-e-quebraveis-por-bioma]]; arte provisória
   reaproveitada de assets já existentes, mesmo padrão do lote original.
2. **Drop enviesado**: era 1/3 poção, 1/3 moeda, 1/3 ímã. Agora 65% moeda,
   20% poção, 10% ímã, 5% item de verdade (via `Items.roll()` +
   `give_item()`, reaproveitando a escolha de equipar/vender da SPEC-060 se
   o slot estiver ocupado) — ouro é o resultado comum; um item é raro.

Evidência completa em
[[EVID-095-spec-063-amend-quebraveis-por-bioma-2026-09-28]].
