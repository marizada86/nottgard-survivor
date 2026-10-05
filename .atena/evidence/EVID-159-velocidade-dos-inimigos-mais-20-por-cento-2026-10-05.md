---
id: "EVID-159"
title: "Velocidade dos inimigos +20% (SPEC-124, PLAN-058)"
created: "2026-10-05"
relations: ["[[SPEC-124-velocidade-de-movimento-dos-inimigos]]", "[[EVID-158-velocidade-de-movimento-x-passo-da-arte-2026-10-05]]"]
---

# EVID-159

## Mudança
- `data/difficulty.json`: `enemy_speed_mult = 1.2`.
- `core/enemy.gd` (spawn): `speed *= enemy_speed_mult` só quando `speed > 0`. Enrage de chefe multiplica por cima; investidas e projéteis intocados.
- Reverter: `enemy_speed_mult = 1.0`.

## Verificação
- `tests/run_all.gd`: 0 falhas.
- Bot (`tools/bot.gd`, 4 seeds, dagruve, dt 0,08, 8 fases), antes → depois:
  - durvall: fases 6 mapas-seed (dagruve 4, docas 1, shedaklah 1) → dagruve 4. Níveis 3/20/6/5 → 14/5/4/6.
  - zynara: nv 2/30/3/4 (um run até molor) → nv 2/38/5/3 (um run até shendilavri).
- Leitura: **inconclusiva**. 4 seeds por herói; o bot é caótico (a mudança altera o consumo de RNG e a trajetória de cada seed), e as seeds 1 de durvall e 2 de zynara mudaram de destino em sentidos opostos. Não há sinal de que +20% quebre a sobrevivência, nem de que a endureça de forma mensurável. O efeito real é de sensação e precisa de playtest humano.

## Pendente
- Playtest do dono; se o ritmo ficar duro, ajustar `enemy_speed_mult` (1,1 a 1,35) ou migrar para valores por papel.
- Sem commit (aprovação explícita).
