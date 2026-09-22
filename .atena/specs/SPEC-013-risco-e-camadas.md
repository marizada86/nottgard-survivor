# SPEC-013 — Risco, extração e identidade das camadas

Status: aprovada pelo dono e verificada em 2026-09-22.

## Escopo
- Extração versus descida com multiplicador de recompensa e pressão progressiva.
- Uma regra principal legível por camada, orientada por `data/stage_rules.json`.
- Os Pilares alternam regras em vez de acumulá-las simultaneamente.

## Plano de voo aprovado
- Mesmo limite local e sem dependências da SPEC-012.
- Máximo de 3 ciclos de correção e nenhuma mudança destrutiva de save.
- Validação: transição, resultado, determinismo, todas as fases e smoke.

## Critérios de aceite
1. O jogador vê as consequências de extrair e descer.
2. Descer mantém a build, aumenta risco/recompensa e reduz recuperação.
3. Cada camada tem uma regra identificável, telegrafada e testável.

## Resultado
Implementada e verificada. Evidência: `EVID-007-mecanicas-game-design.md`.
