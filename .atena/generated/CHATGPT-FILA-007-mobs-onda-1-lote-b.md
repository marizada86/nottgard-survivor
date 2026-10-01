---
id: "CHATGPT-FILA-007"
title: "Fila de geração — animações dos mobs, Onda 1 Lote B"
status: "40 quadros candidatos aprovados pelo dono em 2026-09-30"
created: "2026-09-30"
relations: ["[[PLAN-048-geracao-animacoes-mobs-onda-1-2026-09-30]]", "[[ART-PROMPTS-034-mobs-onda-1-lote-b]]", "[[CANDIDATES-MANIFEST-003]]"]
---

# CHATGPT-FILA-007 — Lote B

Os dois `idle_00` de identidade já foram aprovados. Reutilizá-los como o
primeiro quadro de cada ciclo; gerar uma imagem independente para cada um dos
38 IDs abaixo com ART-PROMPTS-034.

| Alvo | Identidade | Quadros existentes | Gerações novas |
|---|---|---|---:|
| `criatura_corrompida` | I05 | `idle_00` | 19 |
| `arch_hag` | I06 | `idle_00` | 19 |
| **Total** | | | **38** |

Estados por alvo: `idle_01`–`idle_03` (3), `move_00`–`move_05` (6),
`attack_00`–`attack_03` (4), `death_00`–`death_05` (6). Saída selecionada em
`.atena/generated/art-candidates/enemies-wave-1/<id>/frames/`, redimensionada
para 256×384 por nearest-neighbor. Registrar qualquer substituição no manifesto.
Apresentar uma prancha por mob e só avançar ao próximo lote após revisão do dono.
Nenhuma saída entra no runtime.
