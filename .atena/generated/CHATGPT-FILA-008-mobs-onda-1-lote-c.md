---
id: "CHATGPT-FILA-008"
title: "Fila de geração — animações dos mobs, Onda 1 Lote C"
status: "40 quadros candidatos aprovados pelo dono; reuso da cópia requer decisão visual"
created: "2026-09-30"
relations: ["[[PLAN-048-geracao-animacoes-mobs-onda-1-2026-09-30]]", "[[ART-PROMPTS-035-mobs-onda-1-lote-c]]", "[[CANDIDATES-MANIFEST-003]]"]
---

# CHATGPT-FILA-008 — Lote C

Os dois `idle_00` foram aprovados no gate de identidade e serão reaproveitados
como primeiro quadro de cada ciclo. Gerar os 38 IDs restantes individualmente,
seguindo ART-PROMPTS-035:

| Alvo | Perfil | Quadros totais | Existente | Gerações novas | Célula |
|---|---|---:|---|---:|---:|
| `tentaculo_kraken` | C | 14 | `idle_00` | 13 | 256×384 |
| `guardiao_verdadeiro` | B | 26 | `idle_00` | 25 | 320×480 |
| **Total** | | **40** | **2** | **38** | |

Tentáculo: `idle_01`–`idle_03`, `attack_00`–`attack_03`, `death_00`–`death_05`.
Guardião: `idle_01`–`idle_03`, `move_00`–`move_05`, `attack_00`–`attack_03`,
`death_00`–`death_05`, `special_00`–`special_05`. Destino:
`.atena/generated/art-candidates/enemies-wave-1/<id>/frames/`.

Produzir uma prancha para cada mob e revisar escala, transparência, silhueta e
continuidade dos estados. O ciclo do `guardiao_verdadeiro` precisará de
aprovação explícita antes de ser proposto para `guardiao_copia`. Nada deste lote
entra no runtime.

Os `death_05` v01 foram substituídos por v02 para manter a progressão da queda;
as v01 estão preservadas como superseded e a prancha usa as v02.

Em 2026-09-30, o dono aprovou os dois ciclos. O reuso da animação do guardião
verdadeiro em `guardiao_copia` permanece pendente de decisão visual: as artes
estáticas têm paletas e armas diferentes, conforme registrado em EVID-134.
