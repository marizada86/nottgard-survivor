---
id: "CHATGPT-FILA-030"
title: "Fila de geração: névoa do mundo, faixa da borda (NB01) e frente da Maré (NB02)"
status: "criada 2026-10-13; geração aprovada pelo dono; nenhuma peça gerada (a sessão não tem gerador de imagem)"
priority: "baixa: refinamento visual; as mecânicas MEC-059/060 já funcionam com polígonos e `nevoa_borda_01`"
created: "2026-10-13"
relations: ["[[ART-PROMPTS-063-nevoa-de-borda-e-frente-da-mare]]", "[[ART-PROMPTS-025-lote-1-nevoa-bau-de-chefe-imas-e-npcs]]", "[[SPEC-158-nevoa-de-borda-e-de-fim-de-fase]]"]
---

# CHATGPT-FILA-030: névoa do mundo (NB01, NB02)

Compilação operacional de [[ART-PROMPTS-063-nevoa-de-borda-e-frente-da-mare]]; em caso de dúvida, o ART-PROMPTS prevalece (traz contexto, aceite e pós-processamento).

## Como enviar

1. **Uma peça, uma mensagem**, parágrafo completo colado. Sem anexos: o fundo é branco sobre preto e não há referência de estilo.
2. Peça imagem **larga (landscape)** na maior resolução.
3. **Destino das candidatas:** `.atena/generated/art-candidates/nevoa-mundo/<id>_vNN.png` (até 3 por peça; cada nova tentativa corrige um defeito objetivo). Nada entra em `assets/` antes da aprovação do dono.
4. Marque `[x]` ao gerar e `[a]` ao aprovar.

## Fila

- [ ] gerada · [ ] aprovada — NB01 `nevoa_mundo_borda_01` (final 1536×384, repetível na horizontal)
- [ ] gerada · [ ] aprovada — NB02 `nevoa_mundo_frente_01` (final 1280×360)

## NB01 — colar no ChatGPT

```text
A wide horizontal strip of low, creeping ground mist for a dark-fantasy game, drawn as slow rolling banks and long thin horizontal wisps in pure white and light gray. The mist hugs the ground: it is thickest and most opaque along the bottom edge of the image and fades steadily upward until the top third is almost completely empty black. Wisps must run mostly horizontally, parallel to the long axis of the strip, with occasional small curls, and no tall vertical columns, no towering shapes and no single dominant focal cloud. Pixel-art style with controlled dithering and clearly visible stepped pixel bands for density, no smooth airbrushed gradient and no painterly softness. The pattern must be seamlessly tileable horizontally: the left edge must match the right edge exactly, with no visible seam and no feature that repeats obviously. Density varies unevenly along the strip, with thinner and thicker patches, but the bottom edge is never empty. Background: a single completely flat pure black (#000000) — the mist is white on black, with no color, no ground, no scenery, no objects, no creatures, no text, no logo, no watermark, no frame and no border. Wide landscape image.
```

Aceite: emenda sem costura em 3×1; lê como névoa rasteira (sem torres, sem foco).

## NB02 — colar no ChatGPT

```text
A wide horizontal wall of advancing dark-fantasy fog seen from the side, with a clearly readable leading edge. The leading edge runs across the upper part of the image as a churning, billowing crest of rolling fog banks with a few thin curling tendrils reaching upward and forward; the contour must be distinct, like the front of a tide, drawn with stepped pixel bands and controlled dithering rather than a soft gradient. Below the crest, the body of the fog becomes dense and nearly solid, with visible internal swirls and layers of lighter and darker gray, thickest along the bottom edge of the image. The top quarter of the image is empty black so it can sit over a game scene. The left and right ends of the wall fade softly into black over about the outer eight percent of the width, so the wall can overlap at screen corners without a hard cut. One single connected bank, no gaps or holes, no separate floating clouds. Pixel-art style, no smooth airbrushed gradient and no painterly softness. Background: a single completely flat pure black (#000000) — the fog is white and light gray on black, with no color, no ground, no scenery, no objects, no creatures, no text, no logo, no watermark, no frame and no border. Wide landscape image.
```

Aceite: o contorno do alto lê como limite a 80 px e a 360 px de profundidade; distinta de `nevoa_borda_01` e de NB01.

## Depois da geração

Avise com os arquivos nas candidatas; eu confiro emenda, alfa por luminância e leitura nas duas profundidades, e preparo a spec de admissão. Código (`edge_fog.gd`, `run.gd`) só depois de aprovar a imagem.
