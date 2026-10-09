---
id: "CHATGPT-FILA-017"
title: "Fila de geração — animações dos inimigos de Shendilavri"
status: "5 de 5 pilotos aprovados pelo dono em 2026-10-07; ciclos em geracao"
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

- [x] gerada · [a] aprovada — I01 `escravo_de_rivenheart_idle_00`
- [x] gerada · [a] aprovada — I02 `sucubo_idle_00`
- [x] gerada · [a] aprovada — I03 `guarda_do_castelo_idle_00` v01
- [x] gerada · [a] aprovada — I04 `master_of_cruelties_idle_00` v02 (v01 preservada, corte do chifre)
- [x] gerada · [a] aprovada — I05 `malcanthet_idle_00` v01

## Quadros por alvo

### `escravo_de_rivenheart` — Escravo de Rivenheart (19 quadros a gerar, fora o `idle_00`)
Destino: `.atena/generated/art-candidates/enemies-shendilavri/escravo_de_rivenheart/`

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

### `sucubo` — Súcubo (19 quadros a gerar, fora o `idle_00`)
Destino: `.atena/generated/art-candidates/enemies-shendilavri/sucubo/`

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

### `guarda_do_castelo` — Guarda do Castelo Argento (19 quadros a gerar, fora o `idle_00`)
Destino: `.atena/generated/art-candidates/enemies-shendilavri/guarda_do_castelo/`

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

### `master_of_cruelties` — Master of Cruelties (19 quadros a gerar, fora o `idle_00`)
Destino: `.atena/generated/art-candidates/enemies-shendilavri/master_of_cruelties/`

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

### `malcanthet` — Malcanthet, Rainha das Súcubos (25 quadros a gerar, fora o `idle_00`)
Destino: `.atena/generated/art-candidates/enemies-shendilavri/malcanthet/`

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
- [x] `special_00`
- [x] `special_01`
- [x] `special_02`
- [x] `special_03`
- [x] `special_04`
- [x] `special_05`


2026-10-04 — Shendilavri início autorizado S-006: I01escravo_de_rivenheart eI02sucubo v01gerados1254x1254, alfa nativo, sem cortes, solidez0,947/0,948; prancha parcial priority-review/shendilavri_identities_v01.png inspecionada. Nenhum ciclo ou assetruntime Shendilavri. I03guarda_do_castelo falhouHTTP429usage_limit_reached, resets_at1791215015=2026-10-05 12:43:35BRT. Nenhuma nova tentativa após quota. Preservadosprompts/resultados/estado shendilavri-{identity-prompts,identity-results,execution-state}-2026-10-04.json;logsreview/alpha/solidity. RetomarI03→I04Master→I05Malcanthet, auditar5identidades e submetergateFILA017 antesciclos; gateincompleto2de5,sem aprovaçãoinventada. BuildFengTucompleta validada preservada; centralPLAN056 intacto, sem commit/push.

2026-10-05: I03/I04/I05 v02 geradas via imagegen com enquadramento corrigido; I01/I02 v01 preservadas. Cinco pilotos auditados e prancha shendilavri_identities_v02.png revisada. Gate humano pendente, zero ciclos. Estado shendilavri-execution-state-2026-10-05.json; EVID-145.
2026-10-07 — Retomada autorizada pelo dono, PLAN_DEVIATION com retorno ao PLAN-071 registrado antes da geração. Shendilavri: cinco identidades prontas; I01/I02 preservadas, I03/I05 v01, I04 Master v02 corrigindo chifre cortado na v01. Auditoria das cinco fontes passou, alfa nativo preservado. Gate visual PENDING_OWNER_APPROVAL; nenhum ciclo ou asset oficial novo. Prancha e prompts em .atena/generated/shendilavri-resume/v01; evidência .atena/evidence/shendilavri-identities-resume-2026-10-07.md. Próximo: aprovação I01-I05 antes dos 101 quadros restantes; estado central e cursor específico reconciliados.


2026-10-07 — Escravo concluido: 20 fontes selecionadas e quatro tiras oficiais. Dono aceitou marcha arrastada como excecao; move03 v03 e death03 v02 selecionados. Fontes, hashes, recuperacao de CursorSkin e reparos locais de validacao registrados em shendilavri-resume/v01/escravo-completion-receipt.json; queue, runtime, suite e smoke nove fases passaram. Proximo Sucubo; 82 quadros novos restantes no lote.

2026-10-07 — Sucubo: 20 quadros prontos como candidatas (19 novos), quatro tiras tecnicas, sem admissao. move02 v02 e move03 v03 alternam pernas; move04 v01 antecipa retorno, decisao humana pendente apos tres versoes. death04 v03 preserva arma na mao, death05 v03 tecido existente cobre corpo; v02 armadura nova rejeitada. Fontes nativas e prompts preservados, 20 sem cortes/solidez >=0.90; recibo sucubo-preview-receipt.json, prancha sucubo_compact_review.png. 63 quadros novos restantes (Guarda, Master, Malcanthet).

2026-10-07 — sucubo: 20 quadros/4 tiras integrados, queue/runtime/captura passaram; manifesto167 hashes conferidos. Evidencia shendilavri-sucubo-cycles-2026-10-07.md. Proximo guarda_do_castelo, 63 quadros novos restantes. Sem commit/push.

2026-10-07 — guarda_do_castelo: 20 quadros/4 tiras integrados, queue/runtime/captura passaram; manifesto171 hashes conferidos. Evidencia shendilavri-guarda_do_castelo-cycles-2026-10-07.md. Proximo master_of_cruelties, 44 quadros novos restantes. Sem commit/push.

2026-10-07 — master_of_cruelties: 20 quadros/4 tiras integrados, queue/runtime/captura passaram; manifesto175 hashes conferidos. Evidencia shendilavri-master_of_cruelties-cycles-2026-10-07.md. Proximo malcanthet, 25 quadros novos restantes. Sem commit/push.

2026-10-07 — malcanthet: 26 quadros/5 tiras integrados, queue/runtime/captura passaram; manifesto180 hashes conferidos. Evidencia shendilavri-malcanthet-cycles-2026-10-07.md. Proximo goranthis-identities, 0 quadros novos restantes. Sem commit/push.

2026-10-07 — Shendilavri completo local: cinco atores/106 quadros/21 tiras, Ilusao reutiliza Sucubo alpha0.45; manifesto180 hashes validos, suite/fila0, smoke9, runtime/capturas aprovados tecnicamente. Malcanthet aoe usa telegraph real para special, teste completo passou. Exportacao/EXE60frames exit0; build ac14526+, 411300112bytes SHA256277f4c31f6148f20a4d95cb265a055bdee3409ec58665929006e416ef16e7f48. Recibo shendilavri-complete-build-validation-2026-10-07.json; evidencia shendilavri-complete-2026-10-07.md. Playtest humano pendente, sem commit/push. Proximo quatro pilotos Goranthis, gate antes de ciclos; retorno PLAN-071 preservado.
