---
id: "CHATGPT-FILA-016"
title: "Fila de geração — animações dos inimigos de Feng Tu"
status: "Feng Tu integrado:126quadros/25tiras — build159validada"
created: "2026-10-01"
relations: ["[[ART-PROMPTS-047-mobs-feng-tu]]", "[[PLAN-041-animacao-padrao-zumbi-para-inimigos-e-interacoes-2026-09-29]]"]
---

# CHATGPT-FILA-016 — Feng Tu (126 quadros)

Compilação operacional de [[ART-PROMPTS-047-mobs-feng-tu]]; em caso de dúvida, o ART-PROMPTS prevalece.

## Ordem de envio

1. **Gate de identidade:** gerar `I01`–`I06` (um `idle_00` por alvo), anexando a arte estática. **Pare e devolva ao dono** para aprovar cada identidade.
2. Só depois da aprovação, gerar os demais quadros de cada alvo, um alvo por vez, na mesma conversa, anexando a arte estática e o `idle_00` aprovado.
3. Apresentar uma prancha por estado e uma prancha geral para revisão. Nada entra no runtime nesta fila; a admissão segue o rito do SPEC-111.

Marque `[x]` ao gerar e `[a]` ao aprovar.

## Gate de identidade

- [x] gerada · [a] aprovada — I01 `larva_de_lu_yueh_idle_00`
- [x] gerada · [a] aprovada — I02 `cultista_de_feng_tu_idle_00`
- [x] gerada · [a] aprovada — I03 `estatua_do_templo_idle_00`
- [x] gerada · [a] aprovada — I04 `cultista_ghaunadaur_idle_00`
- [x] gerada · [a] aprovada — I05 `discipulo_pestilento_idle_00`
- [x] gerada · [a] aprovada — I06 `lu_yueh_idle_00`

## Quadros por alvo

### `larva_de_lu_yueh` — Larva de Lu Yueh (19 quadros a gerar, fora o `idle_00`)
Destino: `.atena/generated/art-candidates/enemies-feng-tu/larva_de_lu_yueh/`

- [x] `idle_01`
- [x] `idle_02`
- [x] `idle_03`
- [x] `move_00`
- [x] `move_01`
- [x] `move_02`
- [x] `move_03`
- [x] `move_04`
- [x] `move_05`
- [x] `attack_00`
- [x] `attack_01`
- [x] `attack_02`
- [x] `attack_03`
- [x] `death_00`
- [x] `death_01`
- [x] `death_02`
- [x] `death_03`
- [x] `death_04`
- [x] `death_05`

### `cultista_de_feng_tu` — Acólito Pestilento (19 quadros a gerar, fora o `idle_00`)
Destino: `.atena/generated/art-candidates/enemies-feng-tu/cultista_de_feng_tu/`

- [x] `idle_01`
- [x] `idle_02`
- [x] `idle_03`
- [x] `move_00`
- [x] `move_01`
- [x] `move_02`
- [x] `move_03`
- [x] `move_04`
- [x] `move_05`
- [x] `attack_00`
- [x] `attack_01`
- [x] `attack_02`
- [x] `attack_03`
- [x] `death_00`
- [x] `death_01`
- [x] `death_02`
- [x] `death_03`
- [x] `death_04`
- [x] `death_05`

### `estatua_do_templo` — Estátua do Templo (19 quadros a gerar, fora o `idle_00`)
Destino: `.atena/generated/art-candidates/enemies-feng-tu/estatua_do_templo/`

- [x] `idle_01`
- [x] `idle_02`
- [x] `idle_03`
- [x] `move_00`
- [x] `move_01`
- [x] `move_02`
- [x] `move_03`
- [x] `move_04`
- [x] `move_05`
- [x] `attack_00`
- [x] `attack_01`
- [x] `attack_02`
- [x] `attack_03`
- [x] `death_00`
- [x] `death_01`
- [x] `death_02`
- [x] `death_03`
- [x] `death_04`
- [x] `death_05`

### `cultista_ghaunadaur` — Fanático de Ghaunadaur (19 quadros a gerar, fora o `idle_00`)
Destino: `.atena/generated/art-candidates/enemies-feng-tu/cultista_ghaunadaur/`

- [x] `idle_01`
- [x] `idle_02`
- [x] `idle_03`
- [x] `move_00`
- [x] `move_01`
- [x] `move_02`
- [x] `move_03`
- [x] `move_04`
- [x] `move_05`
- [x] `attack_00`
- [x] `attack_01`
- [x] `attack_02`
- [x] `attack_03`
- [x] `death_00`
- [x] `death_01`
- [x] `death_02`
- [x] `death_03`
- [x] `death_04`
- [x] `death_05`

### `discipulo_pestilento` — O Discípulo Pestilento (19 quadros a gerar, fora o `idle_00`)
Destino: `.atena/generated/art-candidates/enemies-feng-tu/discipulo_pestilento/`

- [x] `idle_01`
- [x] `idle_02`
- [x] `idle_03`
- [x] `move_00`
- [x] `move_01`
- [x] `move_02`
- [x] `move_03`
- [x] `move_04`
- [x] `move_05`
- [x] `attack_00`
- [x] `attack_01`
- [x] `attack_02`
- [x] `attack_03`
- [x] `death_00`
- [x] `death_01`
- [x] `death_02`
- [x] `death_03`
- [x] `death_04`
- [x] `death_05`

### `lu_yueh` — Lu Yueh, Deus das Epidemias (25 quadros a gerar, fora o `idle_00`)
Destino: `.atena/generated/art-candidates/enemies-feng-tu/lu_yueh/`

- [ ] `idle_01`
- [ ] `idle_02`
- [ ] `idle_03`
- [ ] `move_00`
- [ ] `move_01`
- [ ] `move_02`
- [ ] `move_03`
- [ ] `move_04`
- [ ] `move_05`
- [ ] `attack_00`
- [ ] `attack_01`
- [ ] `attack_02`
- [ ] `attack_03`
- [ ] `death_00`
- [ ] `death_01`
- [ ] `death_02`
- [ ] `death_03`
- [ ] `death_04`
- [ ] `death_05`
- [ ] `special_00`
- [ ] `special_01`
- [ ] `special_02`
- [ ] `special_03`
- [ ] `special_04`
- [ ] `special_05`

2026-10-04: pilotos I01–I06 v02 gerados e inspecionados na prancha priority-review/feng-tu_identities_v02.png. Fontes1254x1254, alfa nativo, sem cortes; solidez0,956–0,979. V01 rejeitados por halos externos (e mão duplicada no discípulo); v02 removeu halos via imagegen integrado, sem scripts de limpeza. Discípulo preserva três braços e Lu Yueh seis, conforme as referências estáticas; divergência de Lu Yueh com descrição anterior de quatro braços será submetida explicitamente ao dono. Esta nota registra candidatos, não altera intenção canônica nem registra aprovação. Ordem na prancha: linha superior Larva, Acólito, Estátua, Fanático; inferior Discípulo, Lu Yueh. Gate FILA-016 PENDING; zero ciclos e zero assets Feng Tu no runtime. Prompts/resultados feng-tu-identity-{prompts,results}-2026-10-04.json e feng-tu-identity-correction-{prompts,results}-2026-10-04.json; logs feng-tu-identity-{review-v02,alpha-v02,solidity}-2026-10-04.log.

2026-10-04: dono respondeu ‘atena continue’ após gate explícito das seis identidades v02. Aprovação registrada incluindo Lu Yueh6 braços e Discípulo3 da referência. Pedido IN_PLAN; continuar por ator a partir de Larva. Gate liberado, fontes aprovadas versão02.

2026-10-04: Larva19 quadros v01 gerados,20 com identidade aprovada v02. Todos sem cortes. Morte02/04/05 requer continuidade antes da admissão; nenhuma tira oficial instalada ainda. Empacotamento técnico preserva alfa/RGB. Prompts/results feng-tu-larva-{prompts,results}-2026-10-04.json; correções em arquivos irmãos. Attack03 examinado pelo caminho exato: fechado/recuperação aceito.

2026-10-04 — Feng Tu: gate de seis identidades v02 aprovado pelo dono com “atena continue”. Larva integrada20 quadros/4 tiras: identidadeidle00v02; fontes19v01; death02/03/04/05 selecionadosv02. Recuperaçãoattack03v01 conferida pelo caminho exato, boca fechada. Alturas da morte selecionada1093/1041/877/848/713/709, sem cortes; solidez das tiras0,975–0,981. Corpo150/base356; runtime na escala real0,7 passou em ancoragem/ações/limpeza. Captura priority-review/larva_de_lu_yueh_runtime.png inspecionada em Feng Tu (IDruntimefeng_tu, candidatosfeng-tu). Alpha/RGB preservados por nearest packing; nenhuma limpeza por scripts. PNGs4 em assets/animations/enemies/larva_de_lu_yueh, manifesto138 hashes conferidos. Installer aceita IDsFeng Tu; contratoLu Yueh26quadros inclui special. Prompts/resultados e correções em feng-tu-larva-*.json; QA feng-tu-larva-qa-notes-2026-10-04.json. Acólito é próximo ator,19quadros; nenhuma alteração de combate/dependências, nenhum commit/push. BugsP1 abertos2 (025,027), playtest humano pendente. Aprovações visuais duráveis no registro canônico020, sem afirmar admissão de outros atores. Estado central PLAN-056 preservado.


2026-10-04 — Acólito integrado20quadros/4tiras; identidadeidle00v02,19fontesv01,death04/05v02 corrigem retorno indevido à postura de pé. Fontes sem cortes, alfa nativo preservado, tiras solidez0,956–0,965, corpo119/base356. Runtime real e fila passaram (0falhas); captura Feng Tu cultista_de_feng_tu_runtime.png revisada. Manifesto142assets. Estátua19quadros em geração, respeitando quatro braços e armas fixas por mão. Build142 em validação; sem commit/push. Estado central PLAN-056 preservado.




2026-10-04 — Estátua admitida20quadros/4tiras. Identidadeidle00v02;19fontesv01,death04v03/death05v02 selecionados. Death04v01 repete intermediária,death05v01 reacende rachaduras;death04v02 rejeita fusão lança/maça e mão do escudo oculta. Correçãov03 mantém quatro mãos visíveis e armas separadas, luzes apagadas/olhos fechados na pose deitada. Fonte sem cortes;tirassolidez0,955–0,972;corpo152/base356. Runtime real/queue0, captura Feng Tu estatua_do_templo_runtime.png revisada. Manifesto146assets, Feng Tu60quadros/12tiras. Fanático em geração; sem commit/push. Estado central PLAN-056 preservado.




2026-10-04 — Fanático admitido20quadros/4tiras:idle00v02 e19fontesv01,death05v02 selecionado (v01 levantava cajado/rotacionava corpo após death04). Queda termina com staff horizontal e olhos/adornos darkpurple;altura1104/1095/1032/864/505/497. Todas fontes sem cortes,alfa nativo;solidez0,961–0,972,corpo153/base356. Runtime real/queue0;captura cultista_ghaunadaur_runtime.png revisada. Manifesto150assets,Feng Tu80quadros/16tiras. Discípulo18quadros em geração e death05 após revisão death04. Sem commit/push;centralPLAN056 preservado.


2026-10-04 — Discípulo admitido20quadros/4tiras: identidadeidle00v02 e19fontesv01, death05 derivado de death04 após revisão. Três braços preservados; morte alturas1197/1161/1079/977/585/582, todos20semcortes, solidez0,962–0,966; corpo171/base356. Runtime real/queue0; captura discipulo_pestilento_runtime.png revisada. Manifesto154assets, Feng Tu100quadros/20tiras. Lu Yueh24quadros em geração, death05 após inspeção; seis braços eprops mesmos braços aprovados. Sem commit/push; centralPLAN056 preservado.

2026-10-04 — Feng Tu concluído localmente:6atores/126quadros/25tiras;manifesto159assets. Lu Yueh26quadros/5tiras:identityidle00v02,25fontesv01;special02/03/04v02 reforçam ritual,death04v03 mostra seis mãos resting e death05v04 selecionado (v01corte coroa,v02/v03halos rejeitados). Alfa nativo preservado,26semcortes,solidez0,953–0,965;corpo145/base356. Death1141/1060/1079/1051/487/478: aumento19 em02 vem coroa/urnas,corpo passa crouch→kneeling;03fall→04lying com seisbraços baixos. Runtime real1,8 escala/ações/limpeza0;queue0;captura lu_yueh_runtime.png revisada. Habilidadeaoe existente toca special(ui/run.gd). Buildcompleta em validação,próximo gatecincoidentidades Shendilavri. Sem commit/push;centralPLAN056 preservado.
