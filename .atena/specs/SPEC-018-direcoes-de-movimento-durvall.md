# SPEC-018 — Direções de movimento de Durvall

Status: **concluída e reconciliada em 2026-09-22**

## Objetivo

Produzir oito variações direcionais da caminhada de Durvall e selecioná-las conforme o vetor de movimento em tela, sem substituir a sequência `move.png` do piloto.

## Escopo

- Oito sequências: `move_n`, `move_ne`, `move_e`, `move_se`, `move_s`, `move_sw`, `move_w` e `move_nw`.
- Seis quadros por direção, em grade-fonte 3×2, normalizados em tiras RGBA de células `256×384`.
- Referências obrigatórias: arte estática de Durvall e a sequência `move.png` já aprovada.
- `HeroView` escolhe a sequência pela direção real de movimento na tela; transições para idle, ataque, habilidade e morte continuam intactas.
- Manifesto, prompts, teste de dimensões e smoke test.

## Não objetivos

- Não gerar idle, ataque, habilidade ou morte direcionais nesta etapa.
- Não alterar a composição manual de nenhuma fase.
- Não alterar balanceamento, lore, controles ou áudio.

## Critérios de aceite

1. Oito PNGs finais existem e têm alfa e dimensões `1536×384`.
2. Durvall aponta para a direção de deslocamento entre as oito direções de tela.
3. A silhueta, roupa, espada, câmera e linha de base permanecem consistentes.
4. A suíte e o smoke test permanecem verdes.

## Reconciliação

- As oito sequências foram geradas com ImageGen, limpas deterministicamente e normalizadas em tiras RGBA.
- `HeroView` agora mapeia os oito setores do vetor de tela para as sequências direcionais; a antiga `move.png` continua como fallback.
- Nenhuma cena de fase foi modificada ou povoada automaticamente.
