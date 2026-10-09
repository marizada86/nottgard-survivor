---
id: "CHATGPT-FILA-018"
title: "Fila de geração — animações dos inimigos de Goranthis"
status: "86 fontes geradas; 3 atores/12 tiras integrados; Socothbenoth candidato aguarda decisao da marcha"
created: "2026-10-01"
relations: ["[[ART-PROMPTS-049-mobs-goranthis]]", "[[PLAN-041-animacao-padrao-zumbi-para-inimigos-e-interacoes-2026-09-29]]"]
---

# CHATGPT-FILA-018 — Goranthis (86 quadros)

Compilação operacional de [[ART-PROMPTS-049-mobs-goranthis]]; em caso de dúvida, o ART-PROMPTS prevalece.

## Ordem de envio

1. **Gate de identidade:** gerar `I01`–`I04` (um `idle_00` por alvo), anexando a arte estática. **Pare e devolva ao dono** para aprovar cada identidade.
2. Só depois da aprovação, gerar os demais quadros de cada alvo, um alvo por vez, na mesma conversa, anexando a arte estática e o `idle_00` aprovado.
3. Apresentar uma prancha por estado e uma prancha geral para revisão. Nada entra no runtime nesta fila; a admissão segue o rito do SPEC-111.

Marque `[x]` ao gerar e `[a]` ao aprovar.

## Gate de identidade

- [x] gerada · [a] aprovada — I01 `guardiao_de_goranthis_idle_00`
- [x] gerada · [a] aprovada — I02 `cultista_de_socothbenoth_idle_00`
- [x] gerada · [a] aprovada — I03 `death_tyrant_idle_00`
- [x] gerada · [a] aprovada — I04 `socothbenoth_idle_00`

## Quadros por alvo

### `guardiao_de_goranthis` — Guardião do Paraíso (19 quadros a gerar, fora o `idle_00`)
Destino: `.atena/generated/art-candidates/enemies-goranthis/guardiao_de_goranthis/`

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

### `cultista_de_socothbenoth` — Sacerdote de Ilusões (19 quadros a gerar, fora o `idle_00`)
Destino: `.atena/generated/art-candidates/enemies-goranthis/cultista_de_socothbenoth/`

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

### `death_tyrant` — Death Tyrant (19 quadros a gerar, fora o `idle_00`)
Destino: `.atena/generated/art-candidates/enemies-goranthis/death_tyrant/`

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

### `socothbenoth` — Socothbenoth, Âncora de Juiblex (25 quadros a gerar, fora o `idle_00`)
Destino: `.atena/generated/art-candidates/enemies-goranthis/socothbenoth/`

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


2026-10-07 — I01/I03/I04v01, I02v02 candidatas completas e auditadas, alfa nativo preservado. I02v01 rejeitada por face à esquerda. Prancha priority-review/goranthis_identities_v01.png; recibo goranthis-resume/v01/identity-gate-receipt.json. Gate pendente, nenhum ciclo ou PNG oficial; 82 quadros após aprovação. Shendilavri/build concluídos; retorno PLAN-071 preservado.

2026-10-07 — Dono respondeu atena continue ao gate I01-I04; aprovação no registro canônico023. Início de 82 quadros restantes, um ator por vez.

2026-10-07 — Dono pediu atena, pausar. Fila interrompida; Guardiao idle01-03/move00-03 preservados. Move03 retornou antes da interrupção e sua cópia foi concluída para preservar o resultado, sem nova geração. QA completo pendente; nenhum PNG Goranthis admitido. Próximo na retomada: revisar move03, gerar os 12 restantes do Guardiao; 75 no bioma. Recibo goranthis-resume/v01/owner-pause-2026-10-07.json.

2026-10-08 — Goranthis guardiao_de_goranthis: 20 fontes/4 tiras integrados e validados; fila/runtime/captura passaram; manifesto 184 hashes conferidos. Evidencia goranthis-guardiao_de_goranthis-cycles-2026-10-08.md. Proximo cultista_de_socothbenoth, 63 quadros novos restantes; retorno PLAN-071 preservado.

2026-10-08 — Goranthis cultista_de_socothbenoth: 20 fontes/4 tiras integrados e validados; fila/runtime/captura passaram; manifesto 188 hashes conferidos. Evidencia goranthis-cultista_de_socothbenoth-cycles-2026-10-08.md. Proximo death_tyrant, 44 quadros novos restantes; retorno PLAN-071 preservado.

2026-10-08 — Goranthis death_tyrant: 20 fontes/4 tiras integrados e validados; fila/runtime/captura passaram; manifesto 192 hashes conferidos. Evidencia goranthis-death_tyrant-cycles-2026-10-08.md. Proximo socothbenoth, 25 quadros novos restantes; retorno PLAN-071 preservado.

2026-10-08 — Goranthis socothbenoth: 26 fontes/5 tiras integrados e validados; fila/runtime/captura passaram; manifesto 197 hashes conferidos. Evidencia goranthis-socothbenoth-cycles-2026-10-08.md. Proximo pilares, 0 quadros novos restantes; retorno PLAN-071 preservado.

2026-10-08 — Goranthis completo local: 4 atores/86 fontes/17 tiras; Ilusao reutiliza Cultista alpha0.45. Death Tyrant com excecao contextual limitada death02-05. Manifesto197 hashes validos, suite/fila0, smoke9, runtimes e capturas inspecionados. Socothbenoth aoe telegraph/summon/ring reais ->special, unlock e puddle->attack passaram. Exportacao/EXE60frames exit0, build ac14526+ SHA2568d2f1965957add779bd669d287f028f626cfd2affa9ab6394cd4a0feeed9660c. Recibo goranthis-complete-build-validation-2026-10-08.json. Playtest humano pendente. Proximo piloto Pilares com gate antes dos ciclos; retorno PLAN-071 preservado.
