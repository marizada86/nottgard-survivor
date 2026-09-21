# SPEC-004 — F3: run completa (ondas, XP, level-up)

Status: aprovada (2026-09-21, "todas as fases estão aprovadas até F9"). Executada.

## Escopo
- `Battle` como simulação pura por seed: diretor de ondas por tabela de tempo (`data/stages.json`), cap de inimigos, elites com afixos (veloz/resistente/mortal/avaro), chefe no fim do tempo.
- Todas as armas atacam sozinhas (melee em cone, projétil, nova, zona). Mira alternável: AUTO (mais próximo) ou MOUSE (Tab). Substitui a habilidade ativa Q da SPEC-003 (decisão de ritmo: sem ação manual além de mover/mirar).
- XP em gemas, moedas, poções; level-up com escolha de 3 (+ Mão Cheia), rerrolagem, evoluções (arma nv5 + passiva), 12+ armas, 14 passivas.
- Tempo de i-frames (0,4 s) e ritmo lento (SPAWN_SLOW) para o ritmo Halls of Torment.

## Critérios
1. Testes headless: oferta de level-up, determinismo, 7 tipos de arma, efeitos, evolução, segunda chance, ondas de todas as fases.
2. Bot de balanceamento conclui a fase 1 na maioria das seeds.
