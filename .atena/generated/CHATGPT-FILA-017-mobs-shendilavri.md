---
id: "CHATGPT-FILA-017"
title: "Fila de geração — animações dos inimigos de Shendilavri"
status: "2 de 5 pilotos gerados — quota até2026-10-05 12:43:35BRT; gatependente"
created: "2026-10-01"
relations: ["[[ART-PROMPTS-048-mobs-shendilavri]]", "[[PLAN-041-animacao-padrao-zumbi-para-inimigos-e-interacoes-2026-09-29]]"]
---

# CHATGPT-FILA-017 — Shendilavri (106 quadros)

Compilação operacional de [[ART-PROMPTS-048-mobs-shendilavri]]; em caso de dúvida, o ART-PROMPTS prevalece.

## Ordem de envio

1. **Gate de identidade:** gerar `I01`–`I05` (um `idle_00` por alvo), anexando a arte estática. **Pare e devolva ao dono** para aprovar cada identidade.
2. Só depois da aprovação, gerar os demais quadros de cada alvo, um alvo por vez, na mesma conversa, anexando a arte estática e o `idle_00` aprovado.
3. Apresentar uma prancha por estado e uma prancha geral para revisão. Nada entra no runtime nesta fila; a admissão segue o rito do SPEC-111.

Marque `[x]` ao gerar e `[a]` ao aprovar.

## Gate de identidade

- [x] gerada · [ ] aprovada — I01 `escravo_de_rivenheart_idle_00`
- [x] gerada · [ ] aprovada — I02 `sucubo_idle_00`
- [ ] gerada · [ ] aprovada — I03 `guarda_do_castelo_idle_00`
- [ ] gerada · [ ] aprovada — I04 `master_of_cruelties_idle_00`
- [ ] gerada · [ ] aprovada — I05 `malcanthet_idle_00`

## Quadros por alvo

### `escravo_de_rivenheart` — Escravo de Rivenheart (19 quadros a gerar, fora o `idle_00`)
Destino: `.atena/generated/art-candidates/enemies-shendilavri/escravo_de_rivenheart/`

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

### `sucubo` — Súcubo (19 quadros a gerar, fora o `idle_00`)
Destino: `.atena/generated/art-candidates/enemies-shendilavri/sucubo/`

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

### `guarda_do_castelo` — Guarda do Castelo Argento (19 quadros a gerar, fora o `idle_00`)
Destino: `.atena/generated/art-candidates/enemies-shendilavri/guarda_do_castelo/`

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

### `master_of_cruelties` — Master of Cruelties (19 quadros a gerar, fora o `idle_00`)
Destino: `.atena/generated/art-candidates/enemies-shendilavri/master_of_cruelties/`

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

### `malcanthet` — Malcanthet, Rainha das Súcubos (25 quadros a gerar, fora o `idle_00`)
Destino: `.atena/generated/art-candidates/enemies-shendilavri/malcanthet/`

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


2026-10-04 — Shendilavri início autorizado S-006: I01escravo_de_rivenheart eI02sucubo v01gerados1254x1254, alfa nativo, sem cortes, solidez0,947/0,948; prancha parcial priority-review/shendilavri_identities_v01.png inspecionada. Nenhum ciclo ou assetruntime Shendilavri. I03guarda_do_castelo falhouHTTP429usage_limit_reached, resets_at1791215015=2026-10-05 12:43:35BRT. Nenhuma nova tentativa após quota. Preservadosprompts/resultados/estado shendilavri-{identity-prompts,identity-results,execution-state}-2026-10-04.json;logsreview/alpha/solidity. RetomarI03→I04Master→I05Malcanthet, auditar5identidades e submetergateFILA017 antesciclos; gateincompleto2de5,sem aprovaçãoinventada. BuildFengTucompleta validada preservada; centralPLAN056 intacto, sem commit/push.
