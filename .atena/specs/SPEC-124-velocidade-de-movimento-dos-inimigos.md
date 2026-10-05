---
id: SPEC-124
title: Velocidade de movimento dos inimigos (+20%)
status: implemented-uncommitted
origin: pedido-do-dono-2026-10-05
approval: aprovada pelo dono em 2026-10-05 (por plano)
plan: PLAN-058
---

# SPEC-124

## Pedido
Balanceamento: considerar aumentar a velocidade de movimento dos inimigos. Decisoes do dono: +20% geral; so inimigos moveis (`speed > 0`); aprovacao por plano.

## Evidencia
- Herois andam a ~4,2 u/s (190 px de tela); inimigos de 0,7 a 2,0 u/s (`data/enemies.json`).
- EVID-158: humanoides inimigos aprovados tem razao jogo/passo da arte ~0,6 (pernas giram mais que o chao passa); +20% sobe para ~0,74, sem patinar.

## Escopo
- `data/difficulty.json`: chave `enemy_speed_mult` (1.2), reversivel sem mexer nos 50+ inimigos.
- `core/enemy.gd`: aplicar no spawn apenas quando `speed > 0`. Enrage de chefes continua multiplicando por cima.
- Nao muda: `enemies.json`, habilidades de investida (`charge`), projeteis.

## Aceite
- Testes verdes. Bot antes/depois nos mesmos herois/seeds registrado; humano decide, bot e alarme.
- Inimigos de speed 0 continuam parados.
