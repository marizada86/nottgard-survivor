# EVID-028 — Animações de Kayron

Data: 2026-09-24  
Especificação: `SPEC-021-prompts-de-animacao-dos-herois`

## Escopo executado

Foram produzidas e normalizadas as doze sequências de Kayron: `idle`, as oito direções de movimento (`n`, `ne`, `e`, `se`, `s`, `sw`, `w`, `nw`), `attack`, `active` e `death`.

Os PNGs finais estão em `assets/animations/heroes/kayron/`. As saídas brutas selecionadas permanecem em `.atena/generated/asset-candidates/animations/heroes/kayron/`.

## Contrato verificado

- `idle.png` e `attack.png`: 1024×384 (4 quadros de 256×384);
- as demais folhas: 1536×384 (6 quadros de 256×384);
- canal alfa presente, inclusive alfa zero nos cantos;
- identidade visual baseada em `assets/heroes/kayron.png`: aasimar de cabelo branco, traje negro-violeta e ornamentos estelares;
- sem asas anatômicas ou penas;
- `attack` representa a Descarga Estelar, `active` representa a Sobrecarga Mística e `death` não contém gore;
- `tests/test_animation_assets.gd` verifica existência, importação, dimensões e alfa das doze folhas.
