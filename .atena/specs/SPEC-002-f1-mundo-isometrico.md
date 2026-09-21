# SPEC-002 — F1: mundo isométrico e herói andando

Status: aprovada (2026-09-21, "tudo aprovado").

## Escopo
- `Iso`: projeção 2:1 (tile 64x32 px) plano de chão <-> tela.
- Simulação no plano de chão (x,y em tiles); render projetado, Y-sort.
- `Hero` placeholder move com WASD/setas; input normalizado em espaço de tela (velocidade visual constante), colisão simples com limites do mapa e props.
- Mapa placeholder 40x40 tiles xadrez escuro + props (pilares) Y-sorted.
- Câmera segue o herói.

## Critérios de aceite
1. Testes: projeção ida e volta exata; herói não sai do mapa; herói bloqueado por prop.
2. `--import` e `run_all` sem falhas; cena principal roda headless sem erro.
3. Playtest manual: andar pelo mapa a 60 fps, passar atrás/na frente dos pilares corretamente.
