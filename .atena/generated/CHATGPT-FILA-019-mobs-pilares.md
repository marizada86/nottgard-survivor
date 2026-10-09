---
id: "CHATGPT-FILA-019"
title: "Fila de geração — animações dos inimigos de Pilares"
status: "26 fontes/5 tiras candidatas revisadas; attack03 pendente de decisão após três versões; zero oficiais"
created: "2026-10-01"
relations: ["[[ART-PROMPTS-050-mobs-pilares]]", "[[PLAN-041-animacao-padrao-zumbi-para-inimigos-e-interacoes-2026-09-29]]"]
---

# CHATGPT-FILA-019 — Pilares (26 quadros)

Compilação operacional de [[ART-PROMPTS-050-mobs-pilares]]; em caso de dúvida, o ART-PROMPTS prevalece.

## Ordem de envio

1. **Gate de identidade:** gerar `I01`–`I01` (um `idle_00` por alvo), anexando a arte estática. **Pare e devolva ao dono** para aprovar cada identidade.
2. Só depois da aprovação, gerar os demais quadros de cada alvo, um alvo por vez, na mesma conversa, anexando a arte estática e o `idle_00` aprovado.
3. Apresentar uma prancha por estado e uma prancha geral para revisão. Nada entra no runtime nesta fila; a admissão segue o rito do SPEC-111.

Marque `[x]` ao gerar e `[a]` ao aprovar.

## Gate de identidade

- [x] gerada · [a] aprovada — I01 `sintese_abissal_idle_00`

## Quadros por alvo

### `sintese_abissal` — A Síntese Abissal (25 quadros a gerar, fora o `idle_00`)
Destino: `.atena/generated/art-candidates/enemies-pilares/sintese_abissal/`

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


2026-10-08 — Pilares: 26 fontes selecionadas/5 tiras candidatas revisadas; RGB/alfa preservados, limites e solidez passaram. Special00-04v02 corrigem pingentes extras e margem do pico03. Attack03v03 ainda retém pequena gota verde em pingente intermediário; GATE-PILARES-ATTACK03-PENDANT-2026-10-08 PENDING_OWNER_DECISION após três versões. Trabalho independente concluído; nenhuma admissão/runtime/build Pilares. Manifesto197 hashes conferido. Evidência pilares-sintese-abissal-candidate-gate-2026-10-08.md; retorno PLAN-071 preservado.

2026-10-08 — Pilares sintese_abissal: 26 fontes/5 tiras integrados e validados; fila/runtime/captura passaram; manifesto 202 hashes conferidos. Evidencia pilares-sintese_abissal-cycles-2026-10-08.md. Proximo s007, 0 quadros novos restantes; retorno PLAN-071 preservado.

2026-10-08 — Pilares completo local: Sintese Abissal 26 fontes/5 tiras; captura inspecionada; suite/fila0, smoke9, manifesto202 hashes, gatilhos reais de special e desbloqueio passaram. Export/EXE60frames0; build ac14526+ SHA25682cce68ab370d99630c97879d7e14ea02d33f1d2fa2273eeb3e2df36ac46676c. Recibo pilares-complete-build-validation-2026-10-08.json. Playtest humano pendente. S-006 completo; S-007 em reconciliacao, retorno PLAN-071 preservado.
