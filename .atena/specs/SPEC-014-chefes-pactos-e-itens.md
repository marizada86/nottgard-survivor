# SPEC-014 — Chefes, pactos e itens transformadores

Status: aprovada pelo dono e verificada em 2026-09-22.

## Escopo
- Duas transições de fase para cada chefe.
- Consequências jogáveis para bênçãos existentes.
- Seis itens únicos com efeitos acionados por eventos.

## Plano de voo aprovado
- Mesmo limite local e sem dependências das specs anteriores.
- Efeitos usam um vocabulário fechado, recargas internas e não disparam recursivamente.
- Validação: gatilho único de fases, efeitos, regressão completa e smoke.

## Critérios de aceite
1. Fases disparam uma vez em 70% e 35% de vida.
2. Bênçãos comunicam e produzem efeito observável além dos modificadores numéricos.
3. Itens transformadores não geram recursão nem quebram determinismo.

## Resultado
Implementada e verificada. Evidência: `EVID-007-mecanicas-game-design.md`.
