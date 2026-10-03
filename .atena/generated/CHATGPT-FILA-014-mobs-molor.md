---
id: "CHATGPT-FILA-014"
title: "Fila de geração — animações dos inimigos de Molor"
status: "I01–I03 aprovadas; 66 quadros e 13 ciclos integrados; lote Molor concluído localmente; EVID-145"
created: "2026-10-01"
relations: ["[[ART-PROMPTS-045-mobs-molor]]", "[[PLAN-041-animacao-padrao-zumbi-para-inimigos-e-interacoes-2026-09-29]]"]
---

# CHATGPT-FILA-014 — Molor (66 quadros)

Compilação operacional de [[ART-PROMPTS-045-mobs-molor]]; em caso de dúvida, o ART-PROMPTS prevalece.

## Ordem de envio

1. **Gate de identidade:** gerar `I01`–`I03` (um `idle_00` por alvo), anexando a arte estática. **Pare e devolva ao dono** para aprovar cada identidade.
2. Só depois da aprovação, gerar os demais quadros de cada alvo, um alvo por vez, na mesma conversa, anexando a arte estática e o `idle_00` aprovado.
3. Apresentar uma prancha por estado e uma prancha geral para revisão. Nada entra no runtime nesta fila; a admissão segue o rito do SPEC-111.

Marque `[x]` ao gerar e `[a]` ao aprovar.

## Gate de identidade

- [x] gerada · [a] aprovada — I01 `bolha_de_slime_idle_00`
- [x] gerada · [a] aprovada — I02 `cultista_thullgrime_idle_00`
- [x] gerada · [a] aprovada — I03 `blogbog_idle_00`

## Quadros por alvo

### `bolha_de_slime` — Bolha de Slime (19 quadros a gerar, fora o `idle_00`)
Destino: `.atena/generated/art-candidates/enemies-molor/bolha_de_slime/`

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

### `cultista_thullgrime` — Cultista de Ghaunadaur (19 quadros a gerar, fora o `idle_00`)
Destino: `.atena/generated/art-candidates/enemies-molor/cultista_thullgrime/`

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

### `blogbog` — Blogbog (25 quadros a gerar, fora o `idle_00`)
Destino: `.atena/generated/art-candidates/enemies-molor/blogbog/`

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
