# EVID-026 — Animações básicas de Sylas

Data: 2026-09-24  
Especificação: `SPEC-021-prompts-de-animacao-dos-herois`

## Escopo executado

Foram produzidas e normalizadas as doze sequências aprovadas para Sylas: `idle`, as oito direções de movimento (`n`, `ne`, `e`, `se`, `s`, `sw`, `w`, `nw`), `attack`, `active` e `death`.

Os PNGs finais estão em `assets/animations/heroes/sylas/`. As saídas brutas selecionadas permanecem rastreáveis em `.atena/generated/asset-candidates/animations/heroes/sylas/`.

## Contrato verificado

- `idle.png`: 1024×384 (4 quadros de 256×384);
- cada `move_*.png`: 1536×384 (6 quadros de 256×384);
- `attack.png`: 1024×384 (4 quadros de 256×384);
- `active.png` e `death.png`: 1536×384 (6 quadros de 256×384);
- canal alfa presente, incluindo alfa zero no canto de cada folha;
- identidade visual preservada a partir de `assets/heroes/sylas.png`: capuz, chifres, armadura escura e símbolos roxos existentes;
- sem asas, auras, partículas, efeitos mágicos ou novos símbolos;
- `tests/test_animation_assets.gd` verifica a existência, importação, dimensões e alfa das doze folhas.
