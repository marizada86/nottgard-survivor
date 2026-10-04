---
id: "EVID-150"
title: "Curva base em escala depois da SPEC-120 parte A: 10 heróis × 6 sementes, perfil veterano"
created: "2026-10-03"
relations: ["[[EVID-149-curva-base-spec-120-parte-a-2026-10-03]]", "[[EVID-148-curva-de-dificuldade-por-fase-2026-10-03]]", "[[SPEC-120-curva-base-e-marcas-do-abismo]]"]
cards: ["BAL-016"]
---

# EVID-150 — Curva base em escala

Commit medido: `ea2971d` (`dmg_mult` com Molor 1,75 e Durao 1,9, afixos, horda).
`tools/bot_curva.gd`, perfil veterano (meta 1), mapa 60×60, `dt` 0,08, 10 heróis × 6 sementes = 60 runs, 335 passagens de fase. Dados brutos: [`curva.csv`](curva.csv) (colunas do `bot_curva.gd`, sem o prefixo `CSV;`).

## Resultado

| Fase | Passagens | PV mín. médio | Com tempo < 50 % de PV | PV mín. < 50 % | Mortes |
|---|---:|---:|---:|---:|---:|
| Dagruve | 60 | 52 % | 33 % | 33 % | 12 (20 %) |
| Docas | 47 | 85 % | 2 % | 2 % | 0 |
| Shedaklah | 47 | 71 % | 13 % | 13 % | 3 (6 %) |
| Molor | 42 | 67 % | 10 % | 12 % | 2 (5 %) |
| Durao | 38 | 66 % | 18 % | 21 % | 3 (8 %) |
| Feng-tu | 33 | 77 % | 9 % | 9 % | 1 (3 %) |
| Shendilavri | 27 | 72 % | 4 % | 4 % | 0 |
| Goranthis | 24 | 50 % | 38 % | 42 % | 4 (17 %) |
| Pilares | 17 | 29 % | 59 % | 76 % | 6 (35 %) |

## Contra a meta da SPEC-120 (fases 3+: PV mín. 45–65 %, ≥ 30 % com tempo abaixo de 50 %, 3–10 % de mortes)

- **Dentro ou quase:** Durao (66 %, 8 % de mortes), Molor (67 %, 5 %), Goranthis (50 %; mortes 17 %, acima de 10 %).
- **Ainda folgadas:** Shedaklah 71 %, Shendilavri 72 %, Feng-tu 77 % (mortes 0 a 6 %). Nenhuma fase 3+ chega a 30 % das passagens abaixo de 50 % de PV, exceto Goranthis e o Pilares.
- **Pilares** (infinito, 29 %) está acima da meta de dureza; fora do escopo da parte A.
- Antes (EVID-148, veterano): 80–90 % de PV mínimo e 0–3 % de mortes nas fases 3+. A base saiu do patamar de "não tem risco" nas fases 3+, mas a curva ainda não é uniforme: Feng-tu e Shendilavri ficaram mais fáceis que Durao.

## Leitura e próximo passo (proposta, não aplicada)

Sem novo ajuste neste commit. Se o dono quiser aproximar Shedaklah, Feng-tu e Shendilavri da faixa: subir `dmg_mult` de Feng-tu (1,85 → ~2,1) e Shendilavri (2,05 → ~2,3) e Shedaklah (1,25 → ~1,4), e medir de novo. Dagruve (20 % de mortes) segue com BAL-015.

O bot não usa loja, ferreiro nem eventos e não explora; o veredito é o playtest de T03.
