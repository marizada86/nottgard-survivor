---
id: "EVID-162"
title: "SPEC-125 B-003 a B-006: dano e vida dos inimigos por fase (Docas aos Pilares)"
created: "2026-10-05"
relations: ["[[SPEC-125-balanceamento-desafio-e-entretenimento]]", "[[EVID-160-linha-de-base-bal-018-2026-10-05]]", "[[EVID-161-b002-herois-de-dagruve-resultado-negativo-2026-10-05]]"]
cards: ["BAL-018", "BAL-016"]
---

# EVID-162 — Multiplicadores por fase (`data/stages.json`)

Bot `tools/bot_curva.gd` com RNG semeado, mapa 60×60, `dt` 0,1, 10 heróis. Rodadas em [rodadas.csv](EVID-162-b003-inimigos-por-fase-2026-10-05/rodadas.csv) (`r1` a `r5`; `r5` = novato, `r5v` = veterano, 8 sementes). Dagruve **não mudou** (decisão E2; EVID-161).

## Valores (antes → depois)

| Fase | `hp_mult` | `dmg_mult` |
|---|---|---|
| Docas | 1,35 → **1,7** | 1,0 → **1,7** |
| Shedaklah | 1,4 → **1,8** | 1,2 → **1,7** |
| Molor | 2,0 → **2,3** | 1,6 → **2,1** |
| Durao | 2,8 → **3,2** | 1,95 → **2,7** |
| Feng-tu | 3,5 → **4,0** | 2,2 → **3,2** |
| Shendilavri | 4,4 → **5,0** | 2,4 → **3,6** |
| Goranthis | 5,5 → **6,0** | 2,5 → **3,9** |
| Pilares | 6,5 → **7,0** | 2,5 → **4,2** |

Curva monótona (o aviso de curva da auditoria só aparece se a vida cai entre fases), Goranthis acima de Shendilavri (E3). `tests/test_affixes.gd`: constantes e o golpe esperado em Goranthis (10 × 3,9 = 39) atualizados.

## Resultado (8 sementes, morte por fase)

| Fase | Linha de base novato (EVID-160) | **Novato final** | Veterano base | **Veterano final** | Alvo novato |
|---|---:|---:|---:|---:|---|
| Dagruve | 52 % | 50 % (n=80) | 45 % | 38 % | 30–40 % (fora do escopo, E2) |
| Docas | 0 % | **22 %** (n=40) | 0 % | **16 %** | 30–40 % |
| Shedaklah | 17 % | **42 %** (n=31) | 27 % | **41 %** | 45–55 % |
| Molor | 8 % | **38 %** (n=16) | 25 % | **22 %** | 45–55 % |
| Durao | 11 % | **50 %** (n=8) | 0 % | **41 %** | 45–55 % |
| Feng-tu | 0 % | 0 % (n=3) | 0 % | 0 % (n=8) | 55–65 % |
| Shendilavri | 0 % | 100 % (n=2) | 0 % | 50 % (n=6) | 55–65 % |
| Goranthis | 0 % | sem dados | 33 % | 33 % (n=3) | 55–65 % |

PV mínimo médio caiu de 79 a 81 % para 38 a 44 % em Docas, e de 41 a 65 % para 22 a 27 % em Shedaklah, Molor e Durao: o dano agora ameaça quem engrenou.

## Leitura honesta
- Docas a Durao ficaram **dentro ou perto da rampa** (Docas um pouco abaixo; Molor um pouco abaixo). Feng-tu em diante **não são conclusivos**: poucos heróis chegam lá (n de 1 a 8), e o resultado é viés de sobrevivente.
- Uma rodada com `dmg_mult` sozinho (r1) já tinha subido as mortes, mas ficou abaixo da rampa (Docas 6 %, Durao 17 %); a rodada com `hp_mult` junto (r2) levou Docas a 31 % e Shedaklah a 55 %, mas Molor a 60 %: calibrado de volta em passos pequenos (Molor `dmg_mult` 2,2 → 2,0 → 2,1).
- A mudança sozinha **não resolve** o desafio nas fases finais para um humano que passa de Dagruve; a validação é o playtest.

## B-004 (chefes) e B-005 (curva de poder): sem mudança
- Tempo de chefe (veterano) oscila de 71 a 1066 s entre fases (Docas 188, Durao 143, Goranthis 71, Feng-tu 897, Molor 1066), mas com n de 1 a 8 e `boss_t0` medido a partir do surgimento; sem separar o chefe do restante da fase, qualquer ajuste de `boss_phases.json` seria chute. Os chefes herdam o `hp_mult` novo (vida de chefe subiu de 12 a 15 % em todas as fases).
- Nível por fase praticamente igual à linha de base (diferença ≤ 2 níveis): não há excesso de poder que justifique mexer em armas, passivas ou itens agora.
- Ambos voltam ao BAL-018 para depois do playtest.

## Verificação
`tests/run_all.gd`: 0 falhas. `tools/audit_projeto.gd`: 0 erros, 7 avisos (sem aviso de curva; restantes são de apresentação de chefe sem entrada, já conhecidos).
