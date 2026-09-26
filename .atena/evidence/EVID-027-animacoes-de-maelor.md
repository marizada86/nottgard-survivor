# EVID-027 — Animações de Maelor

Data: 2026-09-24  
Especificação: `SPEC-021-prompts-de-animacao-dos-herois`

## Escopo executado

Foram produzidas e normalizadas as doze sequências de Maelor: `idle`, as oito direções de movimento (`n`, `ne`, `e`, `se`, `s`, `sw`, `w`, `nw`), `attack`, `active` e `death`.

Os PNGs finais estão em `assets/animations/heroes/maelor/`. As saídas brutas selecionadas permanecem em `.atena/generated/asset-candidates/animations/heroes/maelor/`.

## Contrato verificado

- `idle.png` e `attack.png`: 1024×384 (4 quadros de 256×384);
- as demais folhas: 1536×384 (6 quadros de 256×384);
- canal alfa presente, inclusive alfa zero nos cantos;
- identidade visual baseada em `assets/heroes/maelor.png`: devoto viajante, armadura clara, manto azul-acinzentado e detalhes dourados;
- `attack` representa o Raio de Luz; `active` representa a Comunhão com luz branca-dourada contida; `death` não contém gore;
- `tests/test_animation_assets.gd` verifica existência, importação, dimensões e alfa das doze folhas.
